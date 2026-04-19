#!/usr/bin/env ruby
# Remove the "Quality level: ..." line from each orphan PR's body.

require 'English'
require 'tempfile'

ORPHANS = [
  { code: 'bg', name: 'Bulgarian', file: 'bg.yml', pr: 5267 },
  { code: 'ca', name: 'Catalan',   file: 'ca.yml', pr: 5268 },
  { code: 'da', name: 'Danish',    file: 'da.yml', pr: 5269 },
  { code: 'mt', name: 'Maltese',   file: 'mt.yml', pr: 5270 },
  { code: 'ru', name: 'Russian',   file: 'ru.yml', pr: 5271 },
  { code: 'sv', name: 'Swedish',   file: 'sv.yml', pr: 5272 },
  { code: 'ar', name: 'Arabic',    file: 'ar.yml', pr: 5273 },
  { code: 'el', name: 'Greek',     file: 'el.yml', pr: 5274 },
  { code: 'zh', name: 'Chinese',   file: 'zh.yml', pr: 5275 },
  { code: 'hy', name: 'Armenian',  file: 'hy.txt', pr: 5276 },
  { code: 'ro', name: 'Romanian',  file: 'ro.txt', pr: 5277 }
].freeze

def body_for orphan
  file   = orphan[:file]
  code   = orphan[:code]
  is_txt = file.end_with?('.txt')

  file_note =
    if is_txt
      "This file is `#{file}` — **raw pdftotext output, not a YAML file**. It lives in the locales folder for convenience but Rails will not load it as a locale. Use it as a text source when hand-writing `#{code}.yml`."
    else
      "This file is `#{file}` — a YAML draft. It is **imperfect**: expect misaligned section boundaries, missing short UI labels, and English-language `image_alt` placeholders carried over from `en.yml`."
    end

  <<~MD
    ## About this draft

    Auto-generated starter for a new language's TCE YAML. **Imperfect and incomplete** — a decent starting point but needs manual intervention to finish.

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

ORPHANS.each do |orphan|
  Tempfile.create(['pr_body_', '.md']) do |f|
    f.write(body_for(orphan))
    f.flush
    out = IO.popen(['gh', 'pr', 'edit', orphan[:pr].to_s, '--body-file', f.path, { err: %i[child out] }], &:read)
    status = $CHILD_STATUS.success? ? 'ok' : 'FAIL'
    puts "##{orphan[:pr]} #{orphan[:name].ljust(12)} #{status}  #{out.strip}"
  end
end
