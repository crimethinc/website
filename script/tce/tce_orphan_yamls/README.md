# TCE Orphan Language Drafts

Starting points for creating new `config/locales/to_change_everything/<root>.yml` files for languages that currently have PDFs on the CDN but no YAML/web page.

All drafts need human review before landing as real YAMLs.

## Files

| code | language | quality | file | notes |
| ---- | -------- | ------- | ---- | ----- |
| ar | Arabic | v2 (rough) | `ar.yml` | IDML-based. Sections may be misaligned — cross-check against the PDF. |
| bg | Bulgarian | v4 (clean) | `bg.yml` | PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually. |
| ca | Catalan | v4 (clean) | `ca.yml` | PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually. |
| da | Danish | v4 (clean) | `da.yml` | PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually. |
| el | Greek | v2 (rough) | `el.yml` | IDML-based. Sections may be misaligned — cross-check against the PDF. |
| hy | Armenian | raw text | `hy.txt` | No YAML structure. pdftotext dump — text flows in visual reading order but is not segmented by YAML key. |
| mt | Maltese | v4 (clean) | `mt.yml` | PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually. |
| ro | Romanian | raw text | `ro.txt` | No YAML structure. pdftotext dump — text flows in visual reading order but is not segmented by YAML key. |
| ru | Russian | v4 (clean) | `ru.yml` | PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually. |
| sv | Swedish | v4 (clean) | `sv.yml` | PDF-based, page-aligned. Mostly accurate; may need cover text / UI labels (`video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`) added manually. |
| zh | Chinese | v2 (rough) | `zh.yml` | IDML-based. Sections may be misaligned — cross-check against the PDF. |

## Process for finalizing each

1. Copy the file to `config/locales/to_change_everything/<code>.yml` (use the YAML root key matching the language's endonym — e.g. `bulgarian` for `bg`).
2. Add the matching `lang_code` (already set in v4 drafts).
3. Review each section against the PDF and fix any misalignments.
4. Fill in the short UI labels that pdftotext missed: `video_cte`, `pdf_cte_html`, `take_flight_html`, `next_text`.
5. Wrap body paragraphs in `<p>` tags to match existing YAMLs' HTML formatting.
6. Add the language's `layouts.to_change_everything` section (menu labels, toc entries, etc.) — copy from another YAML of a same-family language and translate.
7. Add the language to `config/application.rb` `path_ltr_locales` (or `path_rtl_locales` for Arabic).
8. Add a new `.scss` stylesheet and `@import` in `app/assets/stylesheets/to_change_everything.scss`.
9. Add entry in `ToChangeEverythingController::LTR_TO_CHANGE_ANYTHING_YAMLS` (or RTL).

See existing language migrations (PR #5200 for Deutsch, PR #5201 for Polski) as reference for the full checklist.
