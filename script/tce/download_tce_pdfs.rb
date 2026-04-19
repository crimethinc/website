#!/usr/bin/env ruby
# One-off: download all TCE PDFs from the CDN into public/downloads/,
# renaming each to its canonical Step 2 destination from TCE_PDF_MIGRATION_PLAN.md.
# 63 files total. Idempotent: skips files that already exist and are non-empty.

require 'fileutils'

DEST_DIR = File.expand_path('../public/downloads', __dir__)
FileUtils.mkdir_p(DEST_DIR)

# Each entry: [source_url, destination_filename]
DOWNLOADS = [
  # YAML-linked: ceb
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-cebuano-spread.pdf',
   'to-change-everything-cebuano.pdf'],

  # YAML-linked: cs
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-czech-2up.pdf',
   'to-change-everything-czech.pdf'],
  ['https://cdn.crimethinc.com/tce/images/Zmen-Vse.pdf',
   'to-change-everything-czech-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-czech-a4-imposed-color.pdf',
   'to-change-everything-czech-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-czech-a4-imposed-black-and-white.pdf',
   'to-change-everything-czech-print-a4-black-and-white.pdf'],

  # YAML-linked: de
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-deutsch.pdf',
   'to-change-everything-deutsch-reading.pdf'],

  # YAML-linked: en (from /assets/zines/to-change-everything/)
  ['https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_screen_two_page_view.pdf',
   'to-change-everything-english.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_screen_single_page_view.pdf',
   'to-change-everything-english-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_print_color.pdf',
   'to-change-everything-english-print-letter.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_print_color_a4.pdf',
   'to-change-everything-english-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_print_black_and_white.pdf',
   'to-change-everything-english-print-letter-black-and-white.pdf'],

  # YAML-linked: es
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-espanol-spread.pdf',
   'to-change-everything-espanol.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-espanol-single.pdf',
   'to-change-everything-espanol-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_color.pdf',
   'to-change-everything-espanol-print-letter.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_color_a4.pdf',
   'to-change-everything-espanol-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_black_and_white.pdf',
   'to-change-everything-espanol-print-letter-black-and-white.pdf'],
  ['https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_black_and_white_a4.pdf',
   'to-change-everything-espanol-print-a4-black-and-white.pdf'],

  # YAML-linked: es-419
  [
    'https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_color.pdf',             'to-change-everything-espanol-america-latina-print-letter.pdf'
  ],
  [
    'https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_color_a4.pdf',          'to-change-everything-espanol-america-latina-print-a4.pdf'
  ],
  [
    'https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_black_and_white.pdf',   'to-change-everything-espanol-america-latina-print-letter-black-and-white.pdf'
  ],
  [
    'https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_black_and_white_a4.pdf', 'to-change-everything-espanol-america-latina-print-a4-black-and-white.pdf'
  ],

  # YAML-linked: fa (3 variants × 2 filename forms = 6 rows, but 3 unique source URLs)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-spread.pdf',
   'to-change-everything-فارسی.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-spread.pdf',
   'to-change-everything-farsi.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-single.pdf',
   'to-change-everything-فارسی-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-single.pdf',
   'to-change-everything-farsi-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-imposed.pdf',
   'to-change-everything-فارسی-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-imposed.pdf',
   'to-change-everything-farsi-print-a4.pdf'],

  # YAML-linked: fr
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-quebecois.pdf',
   'to-change-everything-quebecois-reading.pdf'],

  # YAML-linked: hbs (rename serbocroatian -> srpskohrvatski)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-serbocroatian-spread.pdf',
   'to-change-everything-srpskohrvatski.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-serbocroatian-single.pdf',
   'to-change-everything-srpskohrvatski-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-serbocroatian-imposed.pdf',
   'to-change-everything-srpskohrvatski-print-a4.pdf'],

  # YAML-linked: ja (glyph + latin duplicates)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-japanese.pdf',
   'to-change-everything-日本語-print-a4-black-and-white.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-japanese.pdf',
   'to-change-everything-nihongo-print-a4-black-and-white.pdf'],

  # YAML-linked: ko (glyph + latin duplicates)
  ['https://cdn.crimethinc.com/assets/tce/images/tce-korean.pdf', 'to-change-everything-한국어-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/tce-korean.pdf', 'to-change-everything-hangugeo-reading.pdf'],

  # YAML-linked: ms
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-malay-spread.pdf',
   'to-change-everything-malay.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-malay-single.pdf',
   'to-change-everything-malay-reading.pdf'],

  # YAML-linked: pl
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-polski.pdf',
   'to-change-everything-polski-reading.pdf'],

  # YAML-linked: pt
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-portugues.pdf',
   'to-change-everything-portugues.pdf'],

  # YAML-linked: sk (content is Slovenian awaiting Slovak translation)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-slovensko.pdf',
   'to-change-everything-slovensko.pdf'],

  # YAML-linked: sl
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-slovenscina.pdf',
   'to-change-everything-slovenscina.pdf'],

  # Orphans: Arabic (العربية). Canonical filenames use the endonym in native
  # script; Latin-transliteration duplicates (arabi) also created for human
  # findability, same bytes.
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-spread.pdf',
   'to-change-everything-العربية.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-spread.pdf',
   'to-change-everything-arabi.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-single.pdf',
   'to-change-everything-العربية-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-single.pdf',
   'to-change-everything-arabi-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-imposed.pdf',
   'to-change-everything-العربية-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-imposed.pdf',
   'to-change-everything-arabi-print-a4.pdf'],

  # Orphans: Armenian (հայերեն)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-armenian-spread.pdf',
   'to-change-everything-հայերեն.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-armenian-spread.pdf',
   'to-change-everything-hayeren.pdf'],

  # Orphans: Bulgarian (български)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-spread.pdf',
   'to-change-everything-български.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-spread.pdf',
   'to-change-everything-balgarski.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-single.pdf',
   'to-change-everything-български-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-single.pdf',
   'to-change-everything-balgarski-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-imposed.pdf',
   'to-change-everything-български-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-imposed.pdf',
   'to-change-everything-balgarski-print-a4.pdf'],

  # Orphans: Catalan (català). Latin-script endonym, no duplicate needed.
  ['https://cdn.crimethinc.com/assets/tce/images/per-canviar-ho-tot_1up.pdf',
   'to-change-everything-català-reading.pdf'],

  # Orphans: Chinese (中文)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-chinese-2up.pdf',
   'to-change-everything-中文.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-chinese-2up.pdf',
   'to-change-everything-zhongwen.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-a4-imposed-chinese.pdf',
   'to-change-everything-中文-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-a4-imposed-chinese.pdf',
   'to-change-everything-zhongwen-print-a4.pdf'],

  # Orphans: Danish (dansk). Latin-script endonym.
  ['https://cdn.crimethinc.com/assets/tce/images/tce_dk_a6_final.pdf',
   'to-change-everything-dansk-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/tce_dk_a6_small_final.pdf',
   'to-change-everything-dansk-reading-lite.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/tce_dk_a6_booklet_final.pdf',
   'to-change-everything-dansk-print-a5.pdf'],

  # Orphans: Dutch (nederlands). Latin-script endonym.
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-dutch-single.pdf',
   'to-change-everything-nederlands-reading.pdf'],

  # Orphans: French (français) — France French, distinct from fr.yml's Quebecois.
  # Latin-script endonym with cedilla.
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-french-reading-version.pdf',
   'to-change-everything-français-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-french-printing-version.pdf',
   'to-change-everything-français-print-a4.pdf'],

  # Orphans: Greek (ελληνικά)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-greek-2up.pdf',
   'to-change-everything-ελληνικά.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-greek-2up.pdf',
   'to-change-everything-ellinika.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-greek-1up.pdf',
   'to-change-everything-ελληνικά-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-greek-1up.pdf',
   'to-change-everything-ellinika-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-a4-imposed-greek.pdf',
   'to-change-everything-ελληνικά-print-a4.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-a4-imposed-greek.pdf',
   'to-change-everything-ellinika-print-a4.pdf'],

  # Orphans: Maltese (malti). Latin-script endonym.
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-maltese-spread.pdf',
   'to-change-everything-malti.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything-maltese-single.pdf',
   'to-change-everything-malti-reading.pdf'],

  # Orphans: Romanian (română). Latin-script endonym.
  ['https://cdn.crimethinc.com/assets/tce/images/ct-tce-ro.pdf', 'to-change-everything-română.pdf'],

  # Orphans: Russian (русский)
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything_rus.pdf',
   'to-change-everything-русский-reading.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/to-change-everything_rus.pdf',
   'to-change-everything-russkii-reading.pdf'],

  # Orphans: Swedish (svenska). Latin-script endonym.
  ['https://cdn.crimethinc.com/assets/tce/images/att-forandra-allt_web_uppslag.pdf',
   'to-change-everything-svenska.pdf'],
  ['https://cdn.crimethinc.com/assets/tce/images/att-forandra-allt_web.pdf',
   'to-change-everything-svenska-reading.pdf']
].freeze

puts "→ #{DOWNLOADS.size} PDFs to download into #{DEST_DIR}"
puts

errors = []

DOWNLOADS.each_with_index do |(url, dest), i|
  path   = File.join(DEST_DIR, dest)
  status = format('[%2d/%2d]', i + 1, DOWNLOADS.size)

  if File.exist?(path) && File.size(path).positive?
    puts "#{status} skip (already present) — #{dest}"
    next
  end

  ok = system('/usr/bin/curl', '--silent', '--show-error', '--fail', '--location', '--output', path, url)

  if ok && File.size(path).positive?
    puts "#{status} ok   #{File.size(path).to_s.rjust(10)}  #{dest}"
  else
    puts "#{status} FAIL #{url} -> #{dest}"
    errors << [url, dest]
    File.delete(path) if File.exist?(path) && File.empty?(path)
  end
end

puts
if errors.empty?
  puts "✅ All #{DOWNLOADS.size} downloads succeeded."
else
  puts "❌ #{errors.size} failure(s):"
  errors.each { |u, d| puts "   - #{d} <- #{u}" }
  exit 1
end
