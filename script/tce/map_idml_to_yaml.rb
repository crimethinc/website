#!/usr/bin/env ruby
# Build a paragraph-index → YAML-key mapping from en.yml + English IDML extract,
# then emit a per-paragraph report showing which YAML key each English paragraph
# corresponds to.
#
# The mapping is derived by searching for each en.yml text value in the extract,
# stripping HTML and normalizing whitespace before comparison.
#
# Usage:
#   ruby tmp/map_idml_to_yaml.rb
#
# Outputs:
#   tmp/tce_extracts/en-mapping.tsv  — paragraph index, best-matching YAML path, text
#   tmp/tce_extracts/en-mapping.json — same data machine-readable, for downstream use

require 'yaml'
require 'json'

EN_YAML     = File.expand_path('../config/locales/to_change_everything/en.yml', __dir__)
EN_EXTRACT  = File.expand_path('tce_extracts/to change everything.txt', __dir__)
OUTPUT_DIR  = File.expand_path('tce_extracts', __dir__)

def strip_html str
  str.gsub(/<[^>]+>/, ' ')
     .gsub(/&#\d+;/) { |m| [m[2..-2].to_i].pack('U') } # numeric entities
     .gsub('&nbsp;', ' ')
     .gsub('&amp;', '&')
     .gsub('&quot;', '"')
     .gsub('&lt;', '<')
     .gsub('&gt;', '>')
     .gsub(/\s+/, ' ')
     .strip
end

def normalize str
  str.unicode_normalize(:nfc)
     .gsub(/[\u2018\u2019\u201B\u2032]/, "'")
     .gsub(/[\u201C\u201D\u201F\u2033]/, '"')
     .gsub(/[\u2013\u2014]/, '-')
     .gsub(/\p{Space}/u, ' ').squeeze(' ')
     .strip
end

# Walk a hash/array yielding [dotted_path, value] for every leaf String
def walk_leaves obj, path = [], &block
  case obj
  when Hash
    obj.each { |k, v| walk_leaves(v, path + [k], &block) }
  when Array
    obj.each_with_index { |v, i| walk_leaves(v, path + [i], &block) }
  when String
    yield(path.join('.'), obj)
  end
end

# Load en.yml → map of { dotted_path => normalized_text } for string values
yaml_raw  = YAML.load_file(EN_YAML)
show      = yaml_raw['english']['to_change_everything']['show']

yaml_fields = {}
walk_leaves(show) do |path, value|
  next if path.end_with?('image_name', 'image_alt', 'video_url', 'pdf_get_url', 'pdf_image', 'next_path')

  text = normalize(strip_html(value))
  yaml_fields[path] = text unless text.empty?
end

puts "en.yml text fields: #{yaml_fields.size}"

# Load English extract, split into paragraphs (empty-line separated, preserving
# story breaks as explicit paragraphs so positions stay stable)
extract = File.read(EN_EXTRACT)
paragraphs = extract.split(/\n\s*\n/).map(&:strip).reject(&:empty?)

puts "extract paragraphs: #{paragraphs.size}"

# For each paragraph, find which YAML field it most likely comes from.
# Strategy: sort YAML fields by length descending; for each, check whether its
# normalized text is a substring of the paragraph OR vice versa. First hit wins.
# Short paragraphs (< 10 chars) need exact normalized-equality to avoid noise.
rows = []

# For each paragraph, find the YAML field with the longest overlap.
# Overlap = length of the longest common substring (in the simple sense of
# "is the short one fully contained in the long one?"). If neither direction
# is a pure substring, we fall back to checking whether a long prefix or
# suffix of one appears in the other — this catches cases where the extract
# merged two adjacent YAML <p> tags or split one across story boundaries.
def overlap_score short, long
  return short.length if long.include?(short)

  # Check increasingly-long prefixes/suffixes of `short` against `long`
  # Binary search for the longest prefix of `short` that's in `long`.
  lo = 0
  hi = short.length
  best = 0
  while lo <= hi
    mid = (lo + hi) / 2
    if mid.positive? && long.include?(short[0, mid])
      best = mid
      lo = mid + 1
    else
      hi = mid - 1
    end
  end
  # Also check suffixes
  lo = 0
  hi = short.length
  while lo <= hi
    mid = (lo + hi) / 2
    if mid.positive? && long.include?(short[-mid, mid])
      best = [best, mid].max
      lo = mid + 1
    else
      hi = mid - 1
    end
  end
  best
end

paragraphs.each_with_index do |para, i|
  next if para == '--- story break ---'

  npara = normalize(strip_html(para))
  next if npara.empty?

  best_path = nil
  best_score = 0

  yaml_fields.each do |path, ytext|
    # Short YAML values (labels, buttons): require substring match either way.
    if ytext.length < 30 || npara.length < 30
      if npara.include?(ytext) || ytext.include?(npara)
        score = [ytext.length, npara.length].min
        if score > best_score
          best_score = score
          best_path = path
        end
      end
      next
    end

    # Long values: use fuzzy overlap.
    short, long = npara.length <= ytext.length ? [npara, ytext] : [ytext, npara]
    score = overlap_score(short, long)

    # Require ≥ 20 chars absolute overlap AND ≥ 30% of the shorter string.
    next if score < 20
    next if score.to_f / short.length < 0.30

    if score > best_score
      best_score = score
      best_path = path
    end
  end

  rows << {
    paragraph_index: i,
    match_path:      best_path,
    overlap_chars:   best_score,
    length:          npara.length,
    text_preview:    npara[0, 100]
  }
end

# Write outputs
File.open(File.join(OUTPUT_DIR, 'en-mapping.tsv'), 'w') do |f|
  f.puts %w[paragraph_index match_path overlap_chars length text_preview].join("\t")
  rows.each do |r|
    f.puts [r[:paragraph_index], r[:match_path] || 'UNMAPPED', r[:overlap_chars] || 0, r[:length],
            r[:text_preview]].join("\t")
  end
end

File.write(File.join(OUTPUT_DIR, 'en-mapping.json'), JSON.pretty_generate(rows))

# Summary
mapped   = rows.count { |r| r[:match_path] }
unmapped = rows.size - mapped
yaml_covered = rows.filter_map { |r| r[:match_path] }.uniq.size

puts
puts 'Mapping summary:'
puts "  paragraphs mapped:   #{mapped} / #{rows.size}"
puts "  paragraphs unmapped: #{unmapped}"
puts "  yaml fields covered: #{yaml_covered} / #{yaml_fields.size}"
puts
puts 'YAML fields NOT covered by any paragraph:'
uncovered = yaml_fields.keys - rows.filter_map { |r| r[:match_path] }.uniq
uncovered.each { |p| puts "  #{p}" }
puts
puts 'Output:'
puts "  #{File.join(OUTPUT_DIR, 'en-mapping.tsv')}"
puts "  #{File.join(OUTPUT_DIR, 'en-mapping.json')}"
