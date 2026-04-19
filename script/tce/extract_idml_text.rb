#!/usr/bin/env ruby
# Extract plain text from InDesign IDML files.
#
# IDML is a ZIP archive containing XML. Text lives in Stories/*.xml; each Story
# has ParagraphStyleRange > CharacterStyleRange > Content. We concatenate the
# Content within each paragraph, preserving <Br/> line breaks.
#
# Story ordering in a flat Stories/ directory is not visual reading order.
# designmap.xml references Spreads/*.xml in document order, and each spread
# references text frames (TextFrame elements) with ParentStory="<story_id>"
# attributes. We traverse that graph to emit stories in the order a reader
# sees them.
#
# Usage:
#   ruby tmp/extract_idml_text.rb <input_dir_or_file> [<output_dir>]
#
#   input:  a single .idml file, or a directory that will be searched
#           recursively for *.idml
#   output: directory to write .txt files into
#           (default: tmp/tce_extracts/)
#
# For each input.idml, writes:
#   <output_dir>/<basename>.txt        — one paragraph per line, story breaks marked
#   <output_dir>/<basename>.stories.txt — same text, grouped per story for debugging

require 'zip'
require 'nokogiri'
require 'fileutils'

INPUT       = ARGV[0] or abort "Usage: #{$PROGRAM_NAME} <input_dir_or_file> [<output_dir>]"
OUTPUT_DIR  = ARGV[1] || File.expand_path('tce_extracts', __dir__)
STORY_BREAK = "\n\n--- story break ---\n\n".freeze

FileUtils.mkdir_p(OUTPUT_DIR)

def idml_files input
  return [input] if File.file?(input) && input.end_with?('.idml')

  Dir.glob(File.join(input, '**/*.idml'))
end

# Returns { "<story_id>" => "<text>" } for every story in the IDML,
# text normalized with paragraph breaks preserved.
def extract_stories zip
  stories = {}

  zip.each do |entry|
    next unless entry.name.start_with?('Stories/') && entry.name.end_with?('.xml')

    xml = entry.get_input_stream.read
    doc = Nokogiri::XML(xml).remove_namespaces!

    # IDML wraps real Story inside an idPkg:Story package node — both become
    # <Story> after remove_namespaces. Pick the one with a Self attribute.
    story_node = doc.at_xpath('//Story[@Self]')
    story_id   = story_node&.[]('Self') || File.basename(entry.name, '.xml')

    paragraphs = []

    story_node&.xpath('./ParagraphStyleRange')&.each do |para|
      # Within a paragraph, text may be split across multiple CharacterStyleRange
      # siblings (e.g., when a word changes style). Concatenate them in order.
      chunks = []
      para.children.each do |child|
        case child.name
        when 'CharacterStyleRange'
          child.xpath('.//Content').each { |c| chunks << c.text }
          # A soft line break inside a character range
          child.xpath('.//Br').each { chunks << "\n" }
        when 'Br'
          chunks << "\n"
        end
      end

      text = chunks.join
      paragraphs << text unless text.strip.empty?
    end

    stories[story_id] = paragraphs.join("\n\n") unless paragraphs.empty?
  end

  stories
end

# Returns an array of story IDs in visual reading order by walking
# designmap.xml → Spreads/*.xml → TextFrame[@ParentStory].
# Falls back to hash-insertion order if graph traversal fails.
def reading_order zip, stories
  designmap_entry = zip.find_entry('designmap.xml')
  return stories.keys unless designmap_entry

  designmap = Nokogiri::XML(designmap_entry.get_input_stream.read).remove_namespaces!

  spread_srcs = designmap.xpath('//idPkg:Spread/@src', 'idPkg' => 'http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging').map(&:value)
  # Some IDMLs omit the namespace — fall back to plain match
  spread_srcs = designmap.xpath("//*[local-name()='Spread']/@src").map(&:value) if spread_srcs.empty?

  ordered = []
  seen    = {}

  spread_srcs.each do |src|
    entry = zip.find_entry(src) or next
    spread_doc = Nokogiri::XML(entry.get_input_stream.read).remove_namespaces!

    spread_doc.xpath('//TextFrame').each do |frame|
      sid = frame['ParentStory']
      next unless sid && stories.key?(sid) && !seen[sid]

      ordered << sid
      seen[sid] = true
    end
  end

  # Append any stories not referenced by a spread (fallback)
  stories.each_key { |sid| ordered << sid unless seen[sid] }

  ordered
end

results = []

idml_files(INPUT).sort.each do |idml|
  basename = File.basename(idml, '.idml')
  puts "→ #{idml}"

  Zip::File.open(idml) do |zip|
    stories = extract_stories(zip)
    order   = reading_order(zip, stories)

    ordered_text = order.map { |sid| stories[sid] }.join(STORY_BREAK)

    File.write(File.join(OUTPUT_DIR, "#{basename}.txt"), ordered_text)
    File.write(
      File.join(OUTPUT_DIR, "#{basename}.stories.txt"),
      stories.map { |sid, text| "=== #{sid} ===\n\n#{text}" }.join("\n\n")
    )

    chars = ordered_text.length
    puts "  #{stories.size} stories, #{chars} chars → #{basename}.txt"
    results << [basename, stories.size, chars]
  end
rescue StandardError => e
  warn "  FAIL: #{e.class}: #{e.message}"
end

puts
puts "#{results.size} IDMLs extracted to #{OUTPUT_DIR}"
