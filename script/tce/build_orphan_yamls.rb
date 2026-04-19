#!/usr/bin/env ruby
# Consolidate everything we have for orphan languages (PDF-only, no YAML yet)
# into a single folder that a reviewer can work from.
#
# For each orphan:
#   - if v4 PDF-based draft exists, copy it (HIGH quality).
#   - else if v2 IDML-based draft exists, copy it (ROUGH quality).
#   - else extract pdftotext output to .txt (RAW — no YAML structure).
#
# Usage:
#   ruby tmp/build_orphan_yamls.rb

require 'fileutils'

TMP        = File.expand_path(__dir__)
V4_DIR     = File.join(TMP, 'tce_draft_yamls_v4')
V2_DIR     = File.join(TMP, 'tce_draft_yamls')
PDF_DIR    = File.expand_path('../public/downloads', __dir__)
OUT_DIR    = File.join(TMP, 'tce_orphan_yamls')

FileUtils.mkdir_p(OUT_DIR)

# Orphan = has PDF on CDN, no YAML in config/locales/to_change_everything/
ORPHANS = {
  'ar' => { name: 'Arabic',    pdf: 'to-change-everything-arabic-reading.pdf' },
  'bg' => { name: 'Bulgarian', pdf: 'to-change-everything-bulgarian-reading.pdf' },
  'ca' => { name: 'Catalan',   pdf: 'to-change-everything-catalan-reading.pdf' },
  'da' => { name: 'Danish',    pdf: 'to-change-everything-danish-reading.pdf' },
  'el' => { name: 'Greek',     pdf: 'to-change-everything-greek-reading.pdf' },
  'hy' => { name: 'Armenian',  pdf: 'to-change-everything-armenian.pdf' },
  'mt' => { name: 'Maltese',   pdf: 'to-change-everything-maltese-reading.pdf' },
  'ro' => { name: 'Romanian',  pdf: 'to-change-everything-romanian.pdf' },
  'ru' => { name: 'Russian',   pdf: 'to-change-everything-russian-reading.pdf' },
  'sv' => { name: 'Swedish',   pdf: 'to-change-everything-swedish-reading.pdf' },
  'zh' => { name: 'Chinese',   pdf: 'to-change-everything-chinese.pdf' }
}.freeze

report = []

ORPHANS.each do |code, info|
  v4_yml = File.join(V4_DIR, "#{code}.yml")
  v2_yml = File.join(V2_DIR, "#{code}.yml")
  pdf    = File.join(PDF_DIR, info[:pdf])

  if File.exist?(v4_yml)
    FileUtils.cp(v4_yml, File.join(OUT_DIR, "#{code}.yml"))
    report << [code, info[:name], 'v4 (clean)', "#{code}.yml"]
  elsif File.exist?(v2_yml)
    FileUtils.cp(v2_yml, File.join(OUT_DIR, "#{code}.yml"))
    report << [code, info[:name], 'v2 (rough)', "#{code}.yml"]
  elsif File.exist?(pdf)
    # Extract raw text, no structure
    txt_path = File.join(OUT_DIR, "#{code}.txt")
    system('pdftotext', pdf, txt_path)
    report << [code, info[:name], 'raw text', "#{code}.txt"]
  else
    report << [code, info[:name], 'NONE', '-']
  end
end

# Write a README explaining what each file is
readme = []
readme << '# TCE Orphan Language Drafts'
readme << ''
readme << 'Starting points for creating new `config/locales/to_change_everything/<root>.yml` files for languages that currently have PDFs on the CDN but no YAML/web page.'
readme << ''
readme << 'All drafts need human review before landing as real YAMLs.'
readme << ''
readme << '## Files'
readme << ''
readme << '| code | language | quality | file | notes |'
readme << '| ---- | -------- | ------- | ---- | ----- |'
report.each do |code, name, quality, file|
  note = case quality
         when 'v4 (clean)' then 'PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually.'
         when 'v2 (rough)' then 'IDML-based. Sections may be misaligned — cross-check against the PDF.'
         when 'raw text'   then 'No YAML structure. pdftotext dump — text flows in visual reading order but is not segmented by YAML key.'
         else 'No source available.'
         end
  readme << "| #{code} | #{name} | #{quality} | `#{file}` | #{note} |"
end
readme << ''
readme << '## Process for finalizing each'
readme << ''
readme << "1. Copy the file to `config/locales/to_change_everything/<code>.yml` (use the YAML root key matching the language's endonym — e.g. `bulgarian` for `bg`)."
readme << '2. Add the matching `lang_code` (already set in v4 drafts).'
readme << '3. Review each section against the PDF and fix any misalignments.'
readme << '4. Fill in the short UI labels that pdftotext missed: `video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`.'
readme << "5. Wrap body paragraphs in `<p>` tags to match existing YAMLs' HTML formatting."
readme << "6. Add the language's `layouts.to_change_everything` section (menu labels, toc entries, etc.) — copy from another YAML of a same-family language and translate."
readme << '7. Add the language to `config/application.rb` `path_ltr_locales` (or `path_rtl_locales` for Arabic).'
readme << '8. Add a new `.scss` stylesheet and `@import` in `app/assets/stylesheets/to_change_everything.scss`.'
readme << '9. Add entry in `ToChangeEverythingController::LTR_TO_CHANGE_ANYTHING_YAMLS` (or RTL).'
readme << ''
readme << 'See existing language migrations (PR #5200 for Deutsch, PR #5201 for Polski) as reference for the full checklist.'
readme << ''

File.write(File.join(OUT_DIR, 'README.md'), readme.join("\n"))

puts "Orphan drafts consolidated into: #{OUT_DIR}"
puts
report.each { |c, n, q, f| puts "  #{c.ljust(4)} #{n.ljust(12)} #{q.ljust(12)} → #{f}" }
puts
puts "README: #{File.join(OUT_DIR, 'README.md')}"
