#!/usr/bin/env ruby
# Rename orphan-language PDFs in public/downloads/ from English exonyms to
# native endonyms, and create Latin-transliteration duplicates for non-Latin
# scripts (following the ja/ko/fa canonical-glyph + latin-duplicate pattern).

require 'fileutils'

DOWNLOADS = File.expand_path('../public/downloads', __dir__)

# exonym → { canonical: endonym_in_native_script, latin: latin_transliteration or nil }
# canonical = new filename stem (replaces the exonym)
# latin     = if present, an additional duplicate copy with this stem
RENAMES = {
  'arabic'    => { canonical: 'العربية',   latin: 'arabi'     },
  'armenian'  => { canonical: 'հայերեն',   latin: 'hayeren'   },
  'bulgarian' => { canonical: 'български', latin: 'balgarski' },
  'catalan'   => { canonical: 'català',   latin: nil          },
  'chinese'   => { canonical: '中文',       latin: 'zhongwen' },
  'danish'    => { canonical: 'dansk',    latin: nil          },
  'dutch'     => { canonical: 'nederlands', latin: nil        },
  'french'    => { canonical: 'français',   latin: nil        }, # France French, distinct from fr.yml's Quebecois
  'greek'     => { canonical: 'ελληνικά', latin: 'ellinika' },
  'maltese'   => { canonical: 'malti',    latin: nil          },
  'romanian'  => { canonical: 'română',   latin: nil          },
  'russian'   => { canonical: 'русский',  latin: 'russkii'    },
  'swedish'   => { canonical: 'svenska',  latin: nil          }
}.freeze

Dir.chdir(DOWNLOADS) do
  Dir.glob('to-change-everything-*.pdf').each do |filename|
    # Match pattern: to-change-everything-<exonym>[-<variant>].pdf
    match = filename.match(/\Ato-change-everything-([a-z]+)(-.+)?\.pdf\z/)
    next unless match

    stem    = match[1]
    variant = match[2] || ''
    next unless RENAMES.key?(stem)

    rename = RENAMES[stem]
    canonical_name = "to-change-everything-#{rename[:canonical]}#{variant}.pdf"
    next if canonical_name == filename

    # Rename to canonical
    if File.exist?(canonical_name)
      puts "  skip #{filename} — #{canonical_name} already exists"
    else
      FileUtils.mv(filename, canonical_name)
      puts "rename   #{filename}"
      puts "      →  #{canonical_name}"
    end

    # Duplicate to Latin if specified
    next unless rename[:latin]

    latin_name = "to-change-everything-#{rename[:latin]}#{variant}.pdf"
    next if latin_name == canonical_name

    if File.exist?(latin_name)
      puts "  skip latin #{latin_name} — exists"
    else
      FileUtils.cp(canonical_name, latin_name)
      puts "duplicate    →  #{latin_name}"
    end
  end
end

puts
puts "Done. Count: #{Dir[File.join(DOWNLOADS, '*.pdf')].size} PDFs in #{DOWNLOADS}"
