#!/usr/bin/env ruby
# V2: Generate draft YAMLs for each language by applying the English
# paragraph→YAML mapping proportionally.
#
# Approach:
#   1. Load en-mapping.json (from map_idml_to_yaml.rb) → English paragraph
#      index to YAML key mapping.
#   2. For each non-English extract, for each paragraph at index i_lang:
#        relative_pos = i_lang / N_lang
#        english_index = round(relative_pos * N_english)
#        yaml_key = en_mapping[english_index]
#   3. Group consecutive paragraphs that map to the same YAML key, joining
#      with blank lines.
#   4. Merge with en.yml scaffolding: non-text fields (image_name, image_alt,
#      video_url, pdf_get_url, pdf_image, next_path) are copied from en.yml.
#      Translated text fields are populated from the language extract.
#   5. Write tmp/tce_draft_yamls/<code>.yml per language, plus a report TSV.
#
# Usage:
#   ruby tmp/generate_draft_yamls.rb

require 'yaml'
require 'json'
require 'fileutils'

EN_YAML     = File.expand_path('../config/locales/to_change_everything/en.yml', __dir__)
EN_MAPPING  = File.expand_path('tce_extracts/en-mapping.json', __dir__)
EXTRACT_DIR = File.expand_path('tce_extracts', __dir__)
OUTPUT_DIR  = File.expand_path('tce_draft_yamls', __dir__)

FileUtils.mkdir_p(OUTPUT_DIR)

# Map of extract filename → (yaml root key, yaml filename) for languages we
# have existing YAMLs for OR want to generate drafts for. Keys are the IDML
# extract filenames (without .txt).
LANGUAGE_MAP = {
  # filename (.txt basename)                          => [yaml_root, yaml_code]
  'to change everything'                             => %w[english en],
  'To Change Everything Arabic'                      => %w[arabic ar],         # ORPHAN — no YAML yet
  'To Change Everything Bulgarian'                   => %w[bulgarian bg],      # ORPHAN
  'To Change Everything Cebuano'                     => %w[cebuano ceb],
  'To Change Everything Chinese'                     => %w[chinese zh],        # ORPHAN
  'To Change Everything Czech'                       => %w[czech cs],
  'To Change Everything Farsi'                       => %w[فارسی fa],
  'To Change Everything Greek'                       => %w[greek el],          # ORPHAN
  'To Change Everything Korean'                      => %w[한국어 ko],
  'To Change Everything Polish'                      => %w[polski pl],
  'To Change Everything Serbo-Croatian'              => %w[srpskohrvatski hbs],
  'To Change Everything A4 Imposed Brazilian'        => %w[portugues pt], # ⚠ imposed order
  'To Change Everything A4 Imposed japanese'         => %w[日本語 ja], # ⚠ imposed order
  'To Change Everything A4 Imposed THAI'             => %w[ภาษาไทย th], # ⚠ imposed order
  'To Change Everything LETTER COLOR Spanish'        => %w[espanol es],
  'To Change Everything LETTER COLOR Lat Am Spanish' => %w[espanol-america-latina es-419]
}.freeze

# Fields that are technical — copy from en.yml, do not translate.
TECHNICAL_FIELDS = %w[image_name image_alt video_url pdf_get_url pdf_image next_path].freeze

# Load English mapping
en_mapping_rows = JSON.parse(File.read(EN_MAPPING))
# Build a dense array: index → yaml_path (or nil for unmapped)
max_en_index   = en_mapping_rows.pluck('paragraph_index').max
en_idx_to_path = Array.new(max_en_index + 1)
en_mapping_rows.each do |r|
  en_idx_to_path[r['paragraph_index']] = r['match_path']
end

# Load en.yml for technical field fallbacks and scaffolding
en_yaml_full = YAML.load_file(EN_YAML)
en_show      = en_yaml_full['english']['to_change_everything']['show']

# Helper: walk show hash yielding [path_array, value]
def deep_each obj, path = [], &block
  case obj
  when Hash
    obj.each { |k, v| deep_each(v, path + [k], &block) }
  when Array
    obj.each_with_index { |v, i| deep_each(v, path + [i], &block) }
  else
    yield(path, obj)
  end
end

# Helper: set a dotted path in a nested hash
def deep_set hash, dotted_path, value
  parts = dotted_path.split('.')
  cur = hash
  parts[0..-2].each do |p|
    cur[p] ||= {}
    cur = cur[p]
  end
  cur[parts.last] = value
end

# For each language, produce a draft YAML
report = []

LANGUAGE_MAP.each do |basename, (yaml_root, yaml_code)|
  extract_path = File.join(EXTRACT_DIR, "#{basename}.txt")
  unless File.exist?(extract_path)
    warn "  missing extract: #{extract_path}"
    next
  end

  # Keep story breaks so indices align with what v1 used for en-mapping.json
  paragraphs = File.read(extract_path).split(/\n\s*\n/).map(&:strip).reject(&:empty?)

  n_lang = paragraphs.size
  n_en   = en_idx_to_path.size

  # Group consecutive paragraphs that map to the same YAML key via proportional
  # alignment with the English mapping.
  groups = Hash.new { |h, k| h[k] = [] } # yaml_path => [paragraphs]
  order  = [] # yaml_paths in order of first appearance

  # Also emit per-paragraph review TSV
  tsv_rows = []

  paragraphs.each_with_index do |para, i_lang|
    if para == '--- story break ---'
      tsv_rows << [i_lang, 'BREAK', 0, '']
      next
    end

    rel        = i_lang.to_f / n_lang
    i_en       = (rel * n_en).round
    i_en       = [i_en, n_en - 1].min
    yaml_path  = en_idx_to_path[i_en]

    tsv_rows << [i_lang, yaml_path || 'UNMAPPED', para.length, para[0, 120].gsub(/\s+/, ' ')]

    next unless yaml_path

    order << yaml_path unless groups.key?(yaml_path)
    groups[yaml_path] << para
  end

  tsv_path = File.join(OUTPUT_DIR, "#{yaml_code}.review.tsv")
  File.open(tsv_path, 'w') do |f|
    f.puts %w[paragraph_index proposed_yaml_key length text_preview].join("\t")
    tsv_rows.each { |r| f.puts r.join("\t") }
  end

  # Build draft YAML structure: deep clone en.yml's show subtree, then override
  # text fields with language text.
  draft_show = YAML.load(YAML.dump(en_show))

  order.each do |yaml_path|
    # Skip if path points to a technical field
    next if TECHNICAL_FIELDS.any? { |t| yaml_path.end_with?(t) }

    joined = groups[yaml_path].join("\n\n")
    deep_set(draft_show, yaml_path, joined)
  end

  # Wrap in the full YAML structure with the correct root
  draft = {
    yaml_root => en_yaml_full['english'].dup
  }
  draft[yaml_root]['to_change_everything'] = draft[yaml_root]['to_change_everything'].dup
  draft[yaml_root]['to_change_everything']['show'] = draft_show

  # Update lang_code in layouts scaffolding
  if draft[yaml_root]['layouts'] && draft[yaml_root]['layouts']['to_change_everything']
    layouts = draft[yaml_root]['layouts']['to_change_everything'].dup
    layouts['lang_code'] = yaml_code
    draft[yaml_root]['layouts']['to_change_everything'] = layouts
  end

  output_path = File.join(OUTPUT_DIR, "#{yaml_code}.yml")
  File.write(output_path, YAML.dump(draft))

  covered = groups.keys.uniq
  report << [yaml_code, yaml_root, n_lang, covered.size]
  puts "→ #{yaml_code.ljust(8)} (#{yaml_root}) #{n_lang} paragraphs, #{covered.size} YAML fields covered → #{yaml_code}.yml"
end

puts
puts "Drafts written to: #{OUTPUT_DIR}"
puts
puts 'Next: diff each draft against its existing YAML (if any) to see how'
puts 'close the auto-mapping got. Orphans (ar, bg, zh, el) have no reference.'
