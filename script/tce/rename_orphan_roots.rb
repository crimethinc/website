#!/usr/bin/env ruby
# Rename the YAML root key in each orphan draft to the endonym, and for the
# two text-only extracts, prepend a note about what the eventual YAML root
# should be.

require 'English'
require 'yaml'
require 'fileutils'
require 'shellwords'

REPO = File.expand_path('..', __dir__)

ORPHANS = [
  { code: 'bg', file: 'bg.yml', branch: 'tce_draft_bg', old_root: 'bulgarian', new_root: 'български' },
  { code: 'ca', file: 'ca.yml', branch: 'tce_draft_ca', old_root: 'catalan',   new_root: 'català' },
  { code: 'da', file: 'da.yml', branch: 'tce_draft_da', old_root: 'danish',    new_root: 'dansk' },
  { code: 'mt', file: 'mt.yml', branch: 'tce_draft_mt', old_root: 'maltese',   new_root: 'malti' },
  { code: 'ru', file: 'ru.yml', branch: 'tce_draft_ru', old_root: 'russian',   new_root: 'русский' },
  { code: 'sv', file: 'sv.yml', branch: 'tce_draft_sv', old_root: 'swedish',   new_root: 'svenska' },
  { code: 'ar', file: 'ar.yml', branch: 'tce_draft_ar', old_root: 'arabic',    new_root: 'العربية' },
  { code: 'el', file: 'el.yml', branch: 'tce_draft_el', old_root: 'greek',     new_root: 'ελληνικά' },
  { code: 'zh', file: 'zh.yml', branch: 'tce_draft_zh', old_root: 'chinese',   new_root: '中文' },

  # Text-only: prepend a note
  { code: 'hy', file: 'hy.txt', branch: 'tce_draft_hy', txt_root: 'հայերեն',   latin_hint: 'hayeren' },
  { code: 'ro', file: 'ro.txt', branch: 'tce_draft_ro', txt_root: 'română',    latin_hint: 'romana' }
].freeze

def run!(*cmd)
  out = IO.popen(cmd + [{ err: %i[child out] }], &:read)
  abort "FAIL: #{cmd.shelljoin}\n#{out}" unless $CHILD_STATUS.success?
  out
end

Dir.chdir(REPO) do
  run!('git', 'checkout', 'main')

  ORPHANS.each do |orphan|
    branch = orphan[:branch]
    file   = orphan[:file]
    puts "\n=== #{orphan[:code]} — #{branch} ==="

    run!('git', 'checkout', branch)
    run!('git', 'pull', 'origin', branch)

    path = File.join(REPO, "config/locales/to_change_everything/#{file}")

    commit_msg =
      if file.end_with?('.yml')
        old_root = orphan[:old_root]
        new_root = orphan[:new_root]

        # Load, swap top-level key, write back
        data = YAML.load_file(path)
        unless data.key?(old_root)
          puts "  WARN: root #{old_root.inspect} not present in #{file}; keys=#{data.keys.inspect}"
          run!('git', 'checkout', 'main')
          next
        end
        new_data = { new_root => data.delete(old_root) }
        File.write(path, YAML.dump(new_data))

        "Rename TCE YAML root #{old_root} → #{new_root} (endonym)"
      else
        txt_root   = orphan[:txt_root]
        latin_hint = orphan[:latin_hint]
        note = <<~NOTE
          # NOTE: When this raw text is hand-converted to YAML, the root node should be:
          #   #{txt_root}
          # (endonym / native name for the language; Latin transliteration: "#{latin_hint}")

        NOTE
        original = File.read(path)
        # Avoid prepending twice if run more than once
        File.write(path, note + original) unless original.lstrip.start_with?('# NOTE:')

        "Note YAML root (#{txt_root}) for future conversion"
      end

    # Stage + commit
    run!('git', 'add', path)
    commit_out = IO.popen(['git', 'commit', '-m', commit_msg, { err: %i[child out] }], &:read)
    unless $CHILD_STATUS.success?
      puts "  commit failed / no changes:\n#{commit_out}"
      run!('git', 'checkout', 'main')
      next
    end

    # Push
    run!('git', 'push', 'origin', branch)
    puts '  pushed.'
  end

  run!('git', 'checkout', 'main')
end

puts "\nAll orphan branches updated. Back on main."
