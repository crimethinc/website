#!/usr/bin/env ruby
# For each orphan language, create a new branch off main, drop the draft
# file in config/locales/to_change_everything/, commit, push, and open a
# draft PR using gh.

require 'English'
require 'fileutils'
require 'tempfile'
require 'shellwords'

REPO       = File.expand_path('..', __dir__)
ORPHAN_DIR = File.join(REPO, 'tmp/tce_orphan_yamls')
LOCALE_DIR = File.join(REPO, 'config/locales/to_change_everything')

# Skip bg — already done manually as PR #5267
ORPHANS = [
  { code: 'ca',  name: 'Catalan',   file: 'ca.yml',  quality: 'v4 (clean)' },
  { code: 'da',  name: 'Danish',    file: 'da.yml',  quality: 'v4 (clean)' },
  { code: 'mt',  name: 'Maltese',   file: 'mt.yml',  quality: 'v4 (clean)' },
  { code: 'ru',  name: 'Russian',   file: 'ru.yml',  quality: 'v4 (clean)' },
  { code: 'sv',  name: 'Swedish',   file: 'sv.yml',  quality: 'v4 (clean)' },
  { code: 'ar',  name: 'Arabic',    file: 'ar.yml',  quality: 'v2 (rough — sections may be misaligned)' },
  { code: 'el',  name: 'Greek',     file: 'el.yml',  quality: 'v2 (rough — sections may be misaligned)' },
  { code: 'zh',  name: 'Chinese',   file: 'zh.yml',  quality: 'v2 (rough — sections may be misaligned)' },
  { code: 'hy',  name: 'Armenian',  file: 'hy.txt',  quality: 'raw text dump — no YAML structure' },
  { code: 'ro',  name: 'Romanian',  file: 'ro.txt',  quality: 'raw text dump — no YAML structure' }
].freeze

def run!(*cmd)
  out = IO.popen(cmd + [{ err: %i[child out] }], &:read)
  abort "FAIL: #{cmd.shelljoin}\n#{out}" unless $CHILD_STATUS.success?
  out
end

def body_for orphan
  file    = orphan[:file]
  code    = orphan[:code]
  quality = orphan[:quality]
  is_txt  = file.end_with?('.txt')

  file_note =
    if is_txt
      "This file is `#{file}` — **raw pdftotext output, not a YAML file**. It lives in the locales folder for convenience but Rails will not load it as a locale. Use it as a text source when hand-writing `#{code}.yml`."
    else
      "This file is `#{file}` — a YAML draft. It is **imperfect**: expect misaligned section boundaries, missing short UI labels, and English-language `image_alt` placeholders carried over from `en.yml`."
    end

  <<~MD
    ## About this draft

    Auto-generated starter for a new language's TCE YAML. **Imperfect and incomplete** — a decent starting point but needs manual intervention to finish.

    Quality level: **#{quality}**

    #{file_note}

    ## Scope of this PR

    This PR **only** adds the draft file. It does **not** wire up the language. A full TCE language migration also needs:

    - Entries in `config/application.rb` (`path_ltr_locales` or `path_rtl_locales`)
    - Entry in `ToChangeEverythingController::LTR_TO_CHANGE_ANYTHING_YAMLS` (or RTL)
    - New `.scss` stylesheet in `app/assets/stylesheets/to_change_everything/`
    - `@import` line in `app/assets/stylesheets/to_change_everything.scss`
    - HTML formatting (`<p>`, `<br>`, `<span class="bold">`) around body text
    - Translated `layouts.to_change_everything` section (menu/toc labels)
    - Short UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) that the extractor couldn't pick up
    - Correct `image_alt` descriptions (currently copied from English)

    For the complete process, see [`docs/to-change-everything-guide.md`](./docs/to-change-everything-guide.md). Reference PRs: #5200 (Deutsch), #5201 (Polski).
  MD
end

results = []

Dir.chdir(REPO) do
  ORPHANS.each do |orphan|
    code   = orphan[:code]
    name   = orphan[:name]
    file   = orphan[:file]
    branch = "tce_draft_#{code}"
    is_txt = file.end_with?('.txt')

    puts "\n=== #{code} (#{name}) — #{file} ==="

    run!('git', 'checkout', 'main')
    run!('git', 'checkout', '-b', branch)

    src = File.join(ORPHAN_DIR, file)
    dst = File.join(LOCALE_DIR, file)
    FileUtils.cp(src, dst)

    run!('git', 'add', dst)
    commit_msg = "Add #{name} (#{code}) TCE draft #{is_txt ? 'text extract' : 'YAML'}"
    commit_out = IO.popen(['git', 'commit', '-m', commit_msg, { err: %i[child out] }], &:read)
    unless $CHILD_STATUS.success?
      puts "  commit failed:\n#{commit_out}"
      run!('git', 'checkout', 'main')
      run!('git', 'branch', '-D', branch)
      results << [code, name, nil, 'commit failed']
      next
    end

    run!('git', 'push', '-u', 'origin', branch)

    title = "[TCE] Draft #{name} (#{code}) #{is_txt ? 'text extract' : 'YAML'}"

    Tempfile.create(["pr_body_#{code}_", '.md']) do |f|
      f.write(body_for(orphan))
      f.flush
      pr_out = IO.popen(
        ['gh', 'pr', 'create', '--draft', '--title', title, '--body-file', f.path, { err: %i[child out] }], &:read
      )
      unless $CHILD_STATUS.success?
        puts "  gh pr create failed:\n#{pr_out}"
        results << [code, name, nil, 'pr create failed']
        next
      end
      pr_url = pr_out.lines.last.strip
      puts "  PR: #{pr_url}"
      results << [code, name, pr_url, 'ok']
    end
  end

  run!('git', 'checkout', 'main')
end

puts "\n=== Summary ==="
results.each { |c, n, url, status| printf "%-3s %-12s %-10s %s\n", c, n, status, url || '-' }
