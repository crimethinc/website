#!/usr/bin/env ruby
# V3: Generate draft YAMLs by page-based alignment of language PDFs against
# the English reference. Each TCE `-reading` PDF is 48 pages with a consistent
# layout; the page→YAML mapping is fixed, so we can extract each language's
# page 5, page 7, etc. and land them directly in the correct YAML field.
#
# Usage:
#   ruby tmp/generate_draft_yamls_from_pdf.rb

require 'yaml'
require 'fileutils'
require 'open3'

EN_YAML     = File.expand_path('../config/locales/to_change_everything/en.yml', __dir__)
PDFS_DIR    = File.expand_path('../public/downloads', __dir__)
OUTPUT_DIR  = File.expand_path('tce_draft_yamls_v4', __dir__)

FileUtils.mkdir_p(OUTPUT_DIR)

# Canonical 48-page English layout → YAML keys.
# Pages not listed (15, 21, 35, 40) are image-only pages.
PAGE_MAP = {
  1  => %w[title_html subtitle_html],
  2  => ['intro.left_text_html'],
  3  => ['intro.right_text_html'],
  4  => ['self.left_text_html'],
  5  => ['self.right_text_html'],
  6  => ['answering.left_text_html'],
  7  => ['answering.right_text_html'],
  8  => ['power.left_text_html'],
  9  => ['power.right_text_html'],
  10 => ['relationships.left_text_html'],
  11 => ['relationships.right_text_html'],
  12 => ['reconciling.left_text_html'],
  13 => ['reconciling.right_text_html'],
  14 => ['reconciling.right_text_html'],       # continuation
  16 => ['liberation.left_text_html'],
  17 => ['liberation.right_text_html'],
  18 => ['revolt.left_text_html'],
  19 => ['revolt.right_text_html'],
  20 => ['revolt.right_text_html'],            # continuation
  22 => ['control.left_text_html'],
  23 => ['control.right_text_html'],
  24 => ['hierarchy.left_text_html'],
  25 => ['hierarchy.right_text_html'],
  26 => ['borders.left_text_html'],
  27 => ['borders.right_text_html'],
  28 => ['representation.left_text_html'],
  29 => ['representation.right_text_html'],
  30 => ['leaders.left_text_html'],
  31 => ['leaders.right_text_html'],
  32 => ['government.left_text_html'],
  33 => ['government.right_text_html'],
  34 => ['government.right_text_html'],        # continuation
  36 => ['profit.left_text_html'],
  37 => ['profit.right_text_html'],
  38 => ['property.left_text_html'],
  39 => ['property.right_text_html'],
  41 => ['property.right_text_html'],          # continuation
  42 => ['lastcrime.left_text_html'],
  43 => ['lastcrime.right_text_html'],
  44 => ['anarchy.first_html'],
  45 => ['anarchy.second_html'],
  46 => ['outro.left_text_html'],
  47 => ['outro.right_text_html'],
  48 => %w[take_flight_html next_text]
}.freeze

TECHNICAL_FIELDS = %w[image_name image_alt video_url pdf_get_url pdf_image next_path].freeze

# For bleed detection: when a `*.left_text_html` field ends up longer than
# LABEL_MAX_CHARS, treat the first paragraph as the actual label and move
# the rest into the corresponding `*.right_text_html`. intro is excluded —
# its `left_text_html` is actually the intro body, not a label.
LABEL_MAX_CHARS  = 80
LABEL_SECTIONS   = %w[self answering power relationships reconciling liberation
                      revolt control hierarchy borders representation leaders
                      government profit property lastcrime outro].freeze

# Language config: lang_code => { root:, pdf:, page_offset:, expected_pages: }
#   page_offset: added to each PAGE_MAP key when extracting from this PDF.
#                Used when a language's PDF has extra leading pages (e.g., blank
#                cover fronts) that push content later by N pages.
#   expected_pages: if set, enforces a specific total. Otherwise defaults to 48.
LANGUAGES = {
  'en'     => { root: 'english',                pdf: 'to-change-everything-english-reading.pdf' },
  'ar'     => { root: 'arabic',                 pdf: 'to-change-everything-arabic-reading.pdf', expected_pages: 50 }, # 2 internal image pages
  'bg'     => { root: 'bulgarian',              pdf: 'to-change-everything-bulgarian-reading.pdf' },
  'ca'     => { root: 'catalan',                pdf: 'to-change-everything-catalan-reading.pdf' }, # orphan, canonical 48
  'ceb'    => { root: 'cebuano',                pdf: 'to-change-everything-cebuano.pdf', expected_pages: 27 }, # compact layout — needs separate mapping
  'cs'     => { root: 'czech',                  pdf: 'to-change-everything-czech-reading.pdf' },
  'da'     => { root: 'danish',                 pdf: 'to-change-everything-danish-reading.pdf' }, # orphan, canonical 48
  'de'     => { root: 'deutsch',                pdf: 'to-change-everything-deutsch-reading.pdf' },
  'el'     => { root: 'greek',                  pdf: 'to-change-everything-greek-reading.pdf',   expected_pages: 56 }, # 8 extra pages
  'es'     => { root: 'espanol',                pdf: 'to-change-everything-espanol-reading.pdf', page_offset: 1, expected_pages: 50 }, # 2 blank cover pages, content starts p3
  'es-419' => { root: 'espanol-america-latina', pdf: nil },
  'fa'     => { root: 'فارسی',                  pdf: 'to-change-everything-farsi-reading.pdf', expected_pages: 52 }, # RTL, 4 extra pages
  'fr'     => { root: 'quebecois',              pdf: 'to-change-everything-quebecois-reading.pdf' },
  'fr-fr'  => { root: 'français',               pdf: 'to-change-everything-français-reading.pdf' },
  'hbs'    => { root: 'srpskohrvatski',         pdf: 'to-change-everything-srpskohrvatski-reading.pdf' },
  'ja'     => { root: '日本語',                  pdf: nil },
  'ko'     => { root: '한국어',                  pdf: 'to-change-everything-hangugeo-reading.pdf' },
  'mt'     => { root: 'maltese',                pdf: 'to-change-everything-maltese-reading.pdf' },   # orphan, canonical 48
  'ms'     => { root: 'malay',                  pdf: 'to-change-everything-malay-reading.pdf' },
  'pl'     => { root: 'polski',                 pdf: 'to-change-everything-polski-reading.pdf' },
  'pt'     => { root: 'portugues',              pdf: nil },
  'ru'     => { root: 'russian',                pdf: 'to-change-everything-russian-reading.pdf' },   # orphan, canonical 48
  'sk'     => { root: 'slovensko',              pdf: nil },
  'sl'     => { root: 'slovenscina',            pdf: nil },
  'sv'     => { root: 'swedish',                pdf: 'to-change-everything-swedish-reading.pdf' },   # orphan, canonical 48
  'th'     => { root: 'ภาษาไทย',                pdf: nil },
  'tr'     => { root: 'turkce',                 pdf: nil }
}.freeze

# Unicode bidi control characters that pdftotext inserts around RTL text.
# Visually invisible but break string equality.
BIDI_CTL = /[\u200E\u200F\u202A-\u202E\u2066-\u2069]/

# Line-length thresholds for paragraph-boundary detection (see extract_page).
SHORT_LINE_THRESHOLD = 30
LONG_LINE_THRESHOLD  = 45

def extract_page pdf_path, page
  # Run without -layout: prose-flow text (no narrow-column hard breaks).
  out, _err, status = Open3.capture3('pdftotext', '-f', page.to_s, '-l', page.to_s, pdf_path, '-')
  return nil unless status.success?

  # Strip bidi control marks (RTL languages)
  out = out.gsub(BIDI_CTL, '')

  # Drop isolated page-number lines
  lines = out.lines.map(&:rstrip).reject { |l| l.strip =~ /\A\d+\z/ }

  # Insert paragraph breaks at line-length transitions. Labels render as
  # short lines (< SHORT_LINE_THRESHOLD chars), body paragraphs render as
  # longer lines. When a short run gives way to a long run, that's a visual
  # paragraph boundary even without a blank line in the PDF text.
  classify = lambda { |l|
    len = l.strip.length
    return :blank if len.zero?
    return :short if len < SHORT_LINE_THRESHOLD
    return :long  if len >= LONG_LINE_THRESHOLD

    :medium
  }

  broken = []
  prev_class = nil
  lines.each do |l|
    cur_class = classify.call(l)
    # Insert blank between short→long or long→short transitions to create a paragraph break
    if prev_class && cur_class != :blank && prev_class != :blank &&
       ((prev_class == :short && cur_class == :long) || (prev_class == :long && cur_class == :short))
      broken << ''
    end
    broken << l
    prev_class = cur_class
  end

  # Split on blank lines → paragraph blocks; within a block, join lines with spaces.
  paragraphs = broken.join("\n").split(/\n\s*\n/).map { |blk| blk.gsub(/\s+/, ' ').strip }.reject(&:empty?)

  paragraphs.join("\n\n")
end

def deep_set hash, dotted_path, value
  parts = dotted_path.split('.')
  cur = hash
  parts[0..-2].each do |p|
    cur[p] ||= {}
    cur = cur[p]
  end
  cur[parts.last] = value
end

en_yaml_full = YAML.load_file(EN_YAML)
en_show      = en_yaml_full['english']['to_change_everything']['show']

report = []

LANGUAGES.each do |lang_code, config|
  yaml_root    = config[:root]
  pdf_basename = config[:pdf]
  page_offset  = config[:page_offset] || 0
  expected     = config[:expected_pages] || 48

  if pdf_basename.nil?
    puts "→ #{lang_code.ljust(8)} (#{yaml_root}): skipped — no -reading PDF available"
    next
  end

  pdf_path = File.join(PDFS_DIR, pdf_basename)
  unless File.exist?(pdf_path)
    puts "→ #{lang_code.ljust(8)} (#{yaml_root}): MISSING #{pdf_basename}"
    next
  end

  # Verify PDF page count. A page_offset of 0 means PAGE_MAP applies directly.
  # Non-zero offset shifts all PAGE_MAP keys by that much (for PDFs with extra
  # leading pages). Sizes other than 48 + offset are flagged as unsupported.
  pdfinfo_out, _err, _s = Open3.capture3('pdfinfo', pdf_path)
  page_count = pdfinfo_out[/^Pages:\s+(\d+)/, 1]&.to_i
  unless page_count == expected
    puts "→ #{lang_code.ljust(8)} (#{yaml_root}): skipped — PDF is #{page_count} pages, expected #{expected}."
    next
  end
  if expected != 48 && page_offset.zero?
    puts "→ #{lang_code.ljust(8)} (#{yaml_root}): skipped — #{expected}-page layout with no known offset; manual PAGE_MAP needed."
    next
  end

  # Group per-page text by YAML path (pages that flow into the same field are concatenated)
  groups = Hash.new { |h, k| h[k] = [] }

  PAGE_MAP.each do |page, yaml_paths|
    text = extract_page(pdf_path, page + page_offset)
    next if text.blank?

    if yaml_paths.size == 1
      groups[yaml_paths.first] << text
    else
      # Multiple YAML paths on one page: split heuristically by double-blank-lines.
      chunks = text.split(/\n{2,}/).map(&:strip).reject(&:empty?)
      yaml_paths.each_with_index do |path, i|
        groups[path] << chunks[i] if chunks[i]
      end
    end
  end

  # Post-process: detect label-page bleed. See LABEL_MAX_CHARS below.
  LABEL_SECTIONS.each do |section|
    label_path = "#{section}.left_text_html"
    body_path  = "#{section}.right_text_html"

    joined = groups[label_path].join("\n\n")
    next if joined.empty?

    paragraphs = joined.split(/\n\s*\n/).map(&:strip).reject(&:empty?)
    next if paragraphs.size <= 1 && paragraphs.first.to_s.length <= LABEL_MAX_CHARS

    # Find the label: leading short paragraphs (< LABEL_MAX_CHARS). The first
    # paragraph that's LABEL_MAX_CHARS+ starts the bleed.
    label_paras = []
    bleed_paras = []
    paragraphs.each do |p|
      if bleed_paras.empty? && p.length <= LABEL_MAX_CHARS
        label_paras << p
      else
        bleed_paras << p
      end
    end

    groups[label_path] = [label_paras.join("\n\n")]
    groups[body_path] = [bleed_paras.join("\n\n")] + groups[body_path] if bleed_paras.any?
  end

  # Build draft YAML: clone en.yml's show subtree, override text fields with extracted text.
  draft_show = YAML.load(YAML.dump(en_show))
  groups.each do |path, chunks|
    next if TECHNICAL_FIELDS.any? { |t| path.end_with?(t) }

    deep_set(draft_show, path, chunks.join("\n\n"))
  end

  # Wrap in full YAML structure
  draft = { yaml_root => YAML.load(YAML.dump(en_yaml_full['english'])) }
  draft[yaml_root]['to_change_everything']['show'] = draft_show
  draft[yaml_root]['layouts']['to_change_everything']['lang_code'] = lang_code

  output_path = File.join(OUTPUT_DIR, "#{lang_code}.yml")
  File.write(output_path, YAML.dump(draft))

  report << [lang_code, yaml_root, groups.size]
  puts "→ #{lang_code.ljust(8)} (#{yaml_root}): #{groups.size} YAML fields populated → #{lang_code}.yml"
end

puts
puts "Drafts written to: #{OUTPUT_DIR}"
