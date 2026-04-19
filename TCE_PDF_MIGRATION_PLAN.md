# TCE PDF Migration Plan

## What this is

A plan to move all "To Change Everything" (TCE) PDFs into a single folder on the CDN, with a consistent naming convention.

## Why

- PDFs are currently scattered across 5+ folders on the CDN (`/tce/images/`, `/tce/pdfs/`, `/assets/tce/images/`, `/assets/tce/espanol/get/images/`, `/assets/tce/get/resources/`, `/assets/zines/...`).
- Filenames follow inconsistent conventions (`Pour-Tout-Transformer.pdf`, `cambiaretutto_imposed.pdf`, `tce-korean.pdf`, `to-change-everything-quebecois.pdf`).
- Same file content exists at multiple URLs (verified by byte-length); changing "the PDF" for a language means editing many places.
- Moving to one canonical folder with predictable names makes it possible for the YAML files to derive the URL from the YAML root key.

## The target convention

One folder for all TCE PDFs:

```txt
https://cdn.crimethinc.com/assets/tce/downloads/
```

Filename pattern — main PDF for a language:

```txt
to-change-everything-<language>.pdf
```

Where `<language>` is the root-node key of the YAML file at `config/locales/to_change_everything/<lang>.yml`. Examples:

- `cs.yml` → root `czech` → `to-change-everything-czech.pdf`
- `fr.yml` → root `quebecois` → `to-change-everything-quebecois.pdf`
- `sl.yml` → root `slovenscina` → `to-change-everything-slovenscina.pdf`

Filename pattern — variants (multiple editions per language):

```txt
to-change-everything-<language>-<variant>.pdf
```

The variant vocabulary is modeled on `/assets/zines/` naming. Most of the existing TCE PDF filename jargon (`1up`, `2up`, `spread`, `imposed`, `printing-version`, `siteweb`, `uppslag`, `web`) maps into three human-readable purpose labels:

| `<variant>`          | purpose                                                 | what it is                                                             |
| -------------------- | ------------------------------------------------------- | ---------------------------------------------------------------------- |
| _(none — no suffix)_ | **default** — on-screen reading on laptop/iPad          | two pages side-by-side, sequential order, meant to be viewed together  |
| `-reading`           | on-screen scrolling on a phone, or source for re-layout | single page, sequential order                                          |
| `-print`             | double-sided printing, folding, stapling                | imposed for booklet printing (non-sequential page order after folding) |

Modifiers on `-print` only:

| modifier           | when to use                        | effect      |
| ------------------ | ---------------------------------- | ----------- |
| _(none)_           | default print — color, letter-size |             |
| `-a4`              | A4 paper instead of letter         | can combine |
| `-black-and-white` | B&W instead of color               | can combine |

Examples:

- `to-change-everything-english.pdf` — default (side-by-side, screen reading)
- `to-change-everything-english-reading.pdf` — single page (phone)
- `to-change-everything-english-print.pdf` — print, color, letter
- `to-change-everything-english-print-a4.pdf` — print, color, A4
- `to-change-everything-english-print-black-and-white.pdf` — print, B&W, letter
- `to-change-everything-english-print-a4-black-and-white.pdf` — print, B&W, A4

## Ground rules for this migration

1. **No deletes.** Old files stay where they are. Redirects from old URLs to new URLs will be set up separately in S3 / CloudFront — that's not part of this plan.
2. **No YAML updates yet.** The YAMLs keep pointing at their current URLs until the new files are in place and redirects are set up. YAML updates come as a follow-up.
3. **Copy, don't move.** Every operation below is an S3 copy from a source URL (that already exists) to a new destination URL. The source is not deleted.

## Step 1 — Decide two ambiguous cases before copying

Two languages have more than one PDF version on the CDN. Before copying, open both versions and decide which one is the authoritative "current" edition. Only the winner gets copied to the new canonical name.

### 1a. German (deutsch) — two editions

| option | size                        | where it lives today                                                                                                                            |
| ------ | --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| A      | 3,699,119 bytes (~3.7 MB)   | `https://cdn.crimethinc.com/tce/images/Alles-Verandern.pdf` AND `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-deutsch.pdf` |
| B      | 16,787,005 bytes (~16.8 MB) | `https://cdn.crimethinc.com/assets/tce/images/Alles-Verandern.pdf` AND `https://cdn.crimethinc.com/assets/tce/images/Alles-Vera%CC%88ndern.pdf` |

**✅ Decided: Option A.** Canonical source: `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-deutsch.pdf`. Option B was an early v1 design, since superseded.

### 1b. Portuguese (portugues) — two editions

| option | size                       | where it lives today                                                                                  |
| ------ | -------------------------- | ----------------------------------------------------------------------------------------------------- |
| A      | 5,966,594 bytes (~5.97 MB) | 4 old-path URLs AND `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-portugues.pdf` |
| B      | 6,554,310 bytes (~6.55 MB) | `https://cdn.crimethinc.com/assets/tce/images/Para-Mudar-Tudo.pdf`                                    |

**✅ Decided: Option A.** Canonical source: `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-portugues.pdf`.

## Step 1.5 — Variants to create (TODO list)

Before copying, fill the gaps. For each language, the ideal set is:

- `<language>.pdf` (default)
- `<language>-reading.pdf`
- `<language>-print.pdf`
- `<language>-print-a4.pdf`

(Black-and-white variants are not user-creatable in this migration — skip those.)

The audit below is based on filename and `Content-Length` only. Some existing files are ambiguous (a 2.2 MB `quebecois.pdf` could be a screen spread, a single-page reading version, or a web-optimized preview — can't tell without opening it). Those are flagged "**identify first**".

### Group A — already complete (no action)

| YAML         | why it's done                                                                                                                                               |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| en (english) | zine-folder files cover default (`screen_two_page_view`), `-reading` (`screen_single_page_view`), `-print` (`print_color`), `-print-a4` (`print_color_a4`). |
| es (espanol) | has `-spread` (default), `-single` (-reading), `_print_color` (-print), `_print_color_a4` (-print-a4).                                                      |

### Group B — missing a specific variant you can create

| YAML                            | has today                                                                                                                                                                                                                                                                                                           | TODO create                                                                          |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| ceb (cebuano)                   | default (20.9 MB "spread")                                                                                                                                                                                                                                                                                          | `-reading`, `-print`, `-print-a4`                                                    |
| cs (czech)                      | default (was "2up", 1.1 MB), `-reading` (was "1up"/"main", 1.2 MB), `-print-a4` (1.7 MB, was "a4-imposed-color")                                                                                                                                                                                                    | `-print` (letter-size imposed color)                                                 |
| es-419 (espanol-america-latina) | `-print`, `-print-a4` (+ B&W variants) in zine folder                                                                                                                                                                                                                                                               | default (side-by-side screen), `-reading` (single page)                              |
| fa (فارسی / farsi)              | default ("spread", 22.9 MB), `-reading` ("single", 23.2 MB), `-print` ("imposed", 10.1 MB)                                                                                                                                                                                                                          | `-print-a4`                                                                          |
| hbs (srpskohrvatski)            | default ("spread", 1.1 MB), `-reading` ("single", 1.2 MB), `-print` ("imposed", 15.8 MB)                                                                                                                                                                                                                            | `-print-a4`                                                                          |
| ms (malay)                      | default ("spread", 909 KB — confirmed real side-by-side, just heavily image-compressed), `-reading` ("single", 20.2 MB)                                                                                                                                                                                             | `-print`, `-print-a4`                                                                |
| fr (quebecois)                  | `-reading` (existing `to-change-everything-quebecois.pdf`, 2.2 MB, confirmed single page)                                                                                                                                                                                                                           | default, `-print`, `-print-a4`                                                       |
| pl (polski)                     | `-reading` (existing `to-change-everything-polski.pdf`, 951 KB, confirmed single page)                                                                                                                                                                                                                              | default, `-print`, `-print-a4`                                                       |
| de (deutsch)                    | `-reading` (canonical `to-change-everything-deutsch.pdf`, 3.7 MB, confirmed single page — per Step 1a)                                                                                                                                                                                                              | default, `-print`, `-print-a4`                                                       |
| pt (portugues)                  | default (canonical `to-change-everything-portugues.pdf`, 5.97 MB, confirmed side-by-side spread — per Step 1b). **Note: this file is black-and-white, not color. Deviates from convention.** Also: cover image has a missing background image bug (white text on white bg). See "Step 1.7 — Deferred design fixes". | `-reading`, `-print`, `-print-a4`                                                    |
| ja (日本語 / nihongo)           | `-print-a4-black-and-white` (existing `to-change-everything-japanese.pdf`, 10.8 MB, confirmed print-imposed A4 B&W)                                                                                                                                                                                                 | default, `-reading`, `-print`, `-print-a4`                                           |
| ko (한국어 / hangugeo)          | `-reading` (existing `tce-korean.pdf`, 7.6 MB, confirmed single page). Also: cover image has a bug — see "Step 1.7 — Deferred design fixes".                                                                                                                                                                        | default, `-print`, `-print-a4`                                                       |
| sl (slovenscina)                | default (existing `to-change-everything-slovenscina.pdf`, 1.0 MB, confirmed side-by-side spread)                                                                                                                                                                                                                    | `-reading`, `-print`, `-print-a4`                                                    |
| sk (slovensko)                  | default (existing `to-change-everything-slovensko.pdf`, 1.0 MB, byte-identical to sl — currently Slovenian content awaiting Slovak translation)                                                                                                                                                                     | `-reading`, `-print`, `-print-a4` (all pending Slovak translation per `sk.yml` TODO) |

### Group C — only one existing PDF, unclear what it is — identify first, then fill gaps

_All Group C items resolved and moved into Group B above._

### Group D — no PDF source material at all

**Decision: flag for commission.** YAMLs for these 4 keep pointing at `/tce/get` (current behaviour) until PDFs are produced and uploaded. When each PDF lands at `/assets/tce/downloads/to-change-everything-<root>.pdf`, update the corresponding YAML's `pdf_get_url`.

| YAML                  | status                                                       |
| --------------------- | ------------------------------------------------------------ |
| hu (hungarian)        | no PDF on CDN — commission; YAML stays on `/tce/get` for now |
| li (lietuvos)         | no PDF on CDN — commission; YAML stays on `/tce/get` for now |
| th (ภาษาไทย / thai)   | no PDF on CDN — commission; YAML stays on `/tce/get` for now |
| tr (turkce / turkish) | no PDF on CDN — commission; YAML stays on `/tce/get` for now |

## Step 1.7 — Deferred design fixes

These are existing-PDF issues surfaced while cataloguing. Not blocking for this migration, but tracked so they don't get lost.

- [ ] **Portuguese (pt) default PDF** — `to-change-everything-portugues.pdf`. Cover page has a missing background image (white title text sits on a white background, essentially invisible). Fix the cover in the source file, re-export, re-upload.
- [ ] **Portuguese (pt) default PDF is black-and-white** — the rest of the language set uses color for the default. Decide whether to produce a color version (then relegate B&W to the `-print-black-and-white` slot), or accept pt as a B&W-only language and document the deviation.
- [ ] **Korean (ko) reading PDF** — `tce-korean.pdf`. Cover image has a bug (needs fixing, re-export, re-upload).
- [ ] **Czech (cs) — cover damage on `/assets/tce/images/to-change-everything-czech.pdf`** (1,195,878 bytes). Content is otherwise identical to `/tce/images/Zmen-Vse.pdf` (958,032 bytes, good cover). Step 2 sources the `-reading` variant from `Zmen-Vse.pdf` to avoid the damaged cover. The 2-up variant (`to-change-everything-czech-2up.pdf`, used as cs default) and the imposed variants should also be checked for the same cover damage — verify before migration.
- [ ] **Danish (orphan) PDFs are A6 paper size**, not letter or A4. All three `tce_dk_a6_*` files are outside the convention's paper-size slots (`-print` = letter, `-print-a4` = A4). Either (a) re-export at letter/A4 so they fit, or (b) extend the convention with an `-a6` modifier.

## Step 1.6 — Italian (italiano) TCE redesign

Italian is excluded from this migration's copy + redirect work. The existing Italian files will stay at their current CDN paths until a redesigned set is produced. The plan for Italian is a separate design task.

**Existing Italian files (stay in place, don't copy):**

- `https://cdn.crimethinc.com/assets/tce/images/cambiaretutto_siteweb.pdf`
- `https://cdn.crimethinc.com/tce/pdfs/cambiaretutto_siteweb.pdf`
- `https://cdn.crimethinc.com/assets/tce/images/cambiaretutto_imposed.pdf`
- `https://cdn.crimethinc.com/tce/pdfs/cambiaretutto_imposed.pdf`
- `https://cdn.crimethinc.com/assets/tce/images/cambiaretutto_imposed_x2.pdf`
- `https://cdn.crimethinc.com/tce/pdfs/cambiaretutto_imposed_x2.pdf`

**Italian TCE redesign TODO:**

- [ ] Produce `to-change-everything-italiano.pdf` (default — side-by-side, screen reading)
- [ ] Produce `to-change-everything-italiano-reading.pdf` (single page — phone)
- [ ] Produce `to-change-everything-italiano-print.pdf` (letter, color, imposed)
- [ ] Produce `to-change-everything-italiano-print-a4.pdf` (A4, color, imposed)

Once redesigned, Italian joins the main migration flow: copy to `/assets/tce/downloads/`, set up redirects from old paths, update `it.yml`.

## Step 2 — Copy PDFs to the new canonical folder

All destination URLs go under `https://cdn.crimethinc.com/assets/tce/downloads/`. Each row below is one S3 copy: source URL (already exists, stays in place) → new canonical filename in `/assets/tce/downloads/`.

Rows that aren't in this table (e.g. `-reading` for deutsch) fall into Step 1.5 "TODO create" — no existing source to copy from.

### Languages with a TCE YAML page

| YAML   | slot (new convention)                   | canonical destination filename                                             | source URL (existing; any content-identical copy)                                                                                                                                       |
| ------ | --------------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ceb    | default                                 | `to-change-everything-cebuano.pdf`                                         | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-cebuano-spread.pdf`                                                                                                  |
| cs     | default                                 | `to-change-everything-czech.pdf`                                           | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-czech-2up.pdf`                                                                                                       |
| cs     | `-reading`                              | `to-change-everything-czech-reading.pdf`                                   | `https://cdn.crimethinc.com/tce/images/Zmen-Vse.pdf` (identical content to `/assets/tce/images/to-change-everything-czech.pdf` but with an un-damaged cover — canonical for `-reading`) |
| cs     | `-print-a4`                             | `to-change-everything-czech-print-a4.pdf`                                  | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-czech-a4-imposed-color.pdf`                                                                                          |
| cs     | `-print-a4-black-and-white`             | `to-change-everything-czech-print-a4-black-and-white.pdf`                  | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-czech-a4-imposed-black-and-white.pdf`                                                                                |
| de     | `-reading`                              | `to-change-everything-deutsch-reading.pdf`                                 | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-deutsch.pdf` (Option A per Step 1a)                                                                                  |
| en     | default                                 | `to-change-everything-english.pdf`                                         | `https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_screen_two_page_view.pdf`                                                                            |
| en     | `-reading`                              | `to-change-everything-english-reading.pdf`                                 | `https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_screen_single_page_view.pdf`                                                                         |
| en     | `-print`                                | `to-change-everything-english-print.pdf`                                   | `https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_print_color.pdf`                                                                                     |
| en     | `-print-a4`                             | `to-change-everything-english-print-a4.pdf`                                | `https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_print_color_a4.pdf`                                                                                  |
| en     | `-print-black-and-white`                | `to-change-everything-english-print-black-and-white.pdf`                   | `https://cdn.crimethinc.com/assets/zines/to-change-everything/to-change-everything_print_black_and_white.pdf`                                                                           |
| es     | default                                 | `to-change-everything-espanol.pdf`                                         | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-espanol-spread.pdf`                                                                                                  |
| es     | `-reading`                              | `to-change-everything-espanol-reading.pdf`                                 | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-espanol-single.pdf`                                                                                                  |
| es     | `-print`                                | `to-change-everything-espanol-print.pdf`                                   | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_color.pdf`                                                                                           |
| es     | `-print-a4`                             | `to-change-everything-espanol-print-a4.pdf`                                | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_color_a4.pdf`                                                                                        |
| es     | `-print-black-and-white`                | `to-change-everything-espanol-print-black-and-white.pdf`                   | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_black_and_white.pdf`                                                                                 |
| es     | `-print-a4-black-and-white`             | `to-change-everything-espanol-print-a4-black-and-white.pdf`                | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo/para-cambiar-todo_print_black_and_white_a4.pdf`                                                                              |
| es-419 | `-print`                                | `to-change-everything-espanol-america-latina-print.pdf`                    | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_color.pdf`                                                             |
| es-419 | `-print-a4`                             | `to-change-everything-espanol-america-latina-print-a4.pdf`                 | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_color_a4.pdf`                                                          |
| es-419 | `-print-black-and-white`                | `to-change-everything-espanol-america-latina-print-black-and-white.pdf`    | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_black_and_white.pdf`                                                   |
| es-419 | `-print-a4-black-and-white`             | `to-change-everything-espanol-america-latina-print-a4-black-and-white.pdf` | `https://cdn.crimethinc.com/assets/zines/para-cambiar-todo-america-latina/para-cambiar-todo-america-latina_print_black_and_white_a4.pdf`                                                |
| fa     | default (glyph)                         | `to-change-everything-فارسی.pdf`                                           | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-spread.pdf`                                                                                                    |
| fa     | default (latin duplicate)               | `to-change-everything-farsi.pdf`                                           | same as above                                                                                                                                                                           |
| fa     | `-reading` (glyph)                      | `to-change-everything-فارسی-reading.pdf`                                   | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-single.pdf`                                                                                                    |
| fa     | `-reading` (latin duplicate)            | `to-change-everything-farsi-reading.pdf`                                   | same as above                                                                                                                                                                           |
| fa     | `-print` (glyph)                        | `to-change-everything-فارسی-print.pdf`                                     | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-farsi-imposed.pdf` (paper size assumed letter — verify)                                                              |
| fa     | `-print` (latin duplicate)              | `to-change-everything-farsi-print.pdf`                                     | same as above                                                                                                                                                                           |
| fr     | `-reading`                              | `to-change-everything-quebecois-reading.pdf`                               | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-quebecois.pdf`                                                                                                       |
| hbs    | default                                 | `to-change-everything-srpskohrvatski.pdf`                                  | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-serbocroatian-spread.pdf`                                                                                            |
| hbs    | `-reading`                              | `to-change-everything-srpskohrvatski-reading.pdf`                          | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-serbocroatian-single.pdf`                                                                                            |
| hbs    | `-print`                                | `to-change-everything-srpskohrvatski-print.pdf`                            | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-serbocroatian-imposed.pdf` (paper size assumed letter — verify)                                                      |
| hu     | —                                       | (nothing to copy; commissioned — see Group D)                              |                                                                                                                                                                                         |
| it     | —                                       | (excluded; Italian redesign — see Step 1.6)                                |                                                                                                                                                                                         |
| ja     | `-print-a4-black-and-white` (glyph)     | `to-change-everything-日本語-print-a4-black-and-white.pdf`                 | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-japanese.pdf`                                                                                                        |
| ja     | `-print-a4-black-and-white` (latin dup) | `to-change-everything-nihongo-print-a4-black-and-white.pdf`                | same as above                                                                                                                                                                           |
| ko     | `-reading` (glyph)                      | `to-change-everything-한국어-reading.pdf`                                  | `https://cdn.crimethinc.com/assets/tce/images/tce-korean.pdf`                                                                                                                           |
| ko     | `-reading` (latin duplicate)            | `to-change-everything-hangugeo-reading.pdf`                                | same as above                                                                                                                                                                           |
| li     | —                                       | (nothing to copy; commissioned — see Group D)                              |                                                                                                                                                                                         |
| ms     | default                                 | `to-change-everything-malay.pdf`                                           | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-malay-spread.pdf`                                                                                                    |
| ms     | `-reading`                              | `to-change-everything-malay-reading.pdf`                                   | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-malay-single.pdf`                                                                                                    |
| pl     | `-reading`                              | `to-change-everything-polski-reading.pdf`                                  | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-polski.pdf`                                                                                                          |
| pt     | default                                 | `to-change-everything-portugues.pdf`                                       | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-portugues.pdf` (Option A per Step 1b; B&W + cover bug — see Step 1.7)                                                |
| sk     | default                                 | `to-change-everything-slovensko.pdf`                                       | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-slovensko.pdf` (Slovenian content pending Slovak translation)                                                        |
| sl     | default                                 | `to-change-everything-slovenscina.pdf`                                     | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-slovenscina.pdf`                                                                                                     |
| th     | —                                       | (nothing to copy; commissioned — see Group D)                              |                                                                                                                                                                                         |
| tr     | —                                       | (nothing to copy; commissioned — see Group D)                              |                                                                                                                                                                                         |

#### Naming notes

- **ja / ko / fa** (non-Latin YAML root keys: `日本語`, `한국어`, `فارسی`): **canonical filenames use the native glyphs** — matches YAML root keys exactly, and S3/CloudFront serves them fine in both unencoded and percent-encoded forms. In addition, **duplicate copies with endonym Latin-transliterations** (`nihongo`, `hangugeo`, `farsi`) are also created — not linked from the TCE page, but kept on the CDN for human findability / guessability. (Endonym transliterations are used rather than English exonyms to match the style of `espanol`, `quebecois`, `slovenscina`, etc.)
  - `ja`: canonical `to-change-everything-日本語.pdf` + duplicate `to-change-everything-nihongo.pdf` (same variants for each: default, `-reading`, `-print`, `-print-a4`)
  - `ko`: canonical `to-change-everything-한국어.pdf` + duplicate `to-change-everything-hangugeo.pdf`
  - `fa`: canonical `to-change-everything-فارسی.pdf` + duplicate `to-change-everything-farsi.pdf` (farsi already is the endonym transliteration)
- **hbs**: YAML root key is `srpskohrvatski` but source filenames say `serbocroatian`. Destination uses the YAML root key (`srpskohrvatski`) to match the convention.
- **it**: Italian is excluded from this copy table — see Step 1.6 (redesign task).

### Languages without a TCE YAML — copy anyway under new convention

**Decision: copy these 25 files into `/assets/tce/downloads/` under the new naming convention, even though no YAML links to them yet.** GitHub issues already exist for creating YAMLs/routes for these languages (tracked separately). This migration future-proofs the filenames so the eventual YAML work can link them without further CDN moves.

For orphan languages without a YAML root key, the language slug in the filename uses the existing English word from current filenames (`arabic`, `armenian`, `bulgarian`, etc.). When YAMLs are eventually created, the slug can be renamed to an endonym if desired, with CDN redirects for continuity.

Mapping table:

| orphan language | slot (new convention)        | canonical destination filename                  | source URL (existing; any content-identical copy)                                               |
| --------------- | ---------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Arabic          | default                      | `to-change-everything-arabic.pdf`               | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-spread.pdf`           |
| Arabic          | `-reading`                   | `to-change-everything-arabic-reading.pdf`       | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-single.pdf`           |
| Arabic          | `-print-a4`                  | `to-change-everything-arabic-print-a4.pdf`      | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-arabic-imposed.pdf`          |
| Armenian        | default                      | `to-change-everything-armenian.pdf`             | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-armenian-spread.pdf`         |
| Bulgarian       | default                      | `to-change-everything-bulgarian.pdf`            | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-spread.pdf`        |
| Bulgarian       | `-reading`                   | `to-change-everything-bulgarian-reading.pdf`    | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-single.pdf`        |
| Bulgarian       | `-print-a4`                  | `to-change-everything-bulgarian-print-a4.pdf`   | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-bulgarian-imposed.pdf`       |
| Catalan         | `-reading`                   | `to-change-everything-catalan-reading.pdf`      | `https://cdn.crimethinc.com/assets/tce/images/per-canviar-ho-tot_1up.pdf`                       |
| Chinese         | default                      | `to-change-everything-chinese.pdf`              | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-chinese-2up.pdf`             |
| Chinese         | `-print-a4`                  | `to-change-everything-chinese-print-a4.pdf`     | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-a4-imposed-chinese.pdf`      |
| Danish          | — A6 paper                   | (excluded — see Step 1.7 deferred design fixes) | `https://cdn.crimethinc.com/assets/tce/images/tce_dk_a6_final.pdf`                              |
| Danish          | — A6 paper                   | (excluded — see Step 1.7 deferred design fixes) | `https://cdn.crimethinc.com/assets/tce/images/tce_dk_a6_booklet_final.pdf`                      |
| Danish          | — A6 paper                   | (excluded — see Step 1.7 deferred design fixes) | `https://cdn.crimethinc.com/assets/tce/images/tce_dk_a6_small_final.pdf`                        |
| Dutch           | `-reading`                   | `to-change-everything-dutch-reading.pdf`        | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-dutch-single.pdf`            |
| French (France) | `-reading`                   | `to-change-everything-french-reading.pdf`       | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-french-reading-version.pdf`  |
| French (France) | `-print-a4`                  | `to-change-everything-french-print-a4.pdf`      | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-french-printing-version.pdf` |
| Greek           | default                      | `to-change-everything-greek.pdf`                | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-greek-2up.pdf`               |
| Greek           | `-reading`                   | `to-change-everything-greek-reading.pdf`        | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-greek-1up.pdf`               |
| Greek           | `-print-a4`                  | `to-change-everything-greek-print-a4.pdf`       | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-a4-imposed-greek.pdf`        |
| Maltese         | default                      | `to-change-everything-maltese.pdf`              | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-maltese-spread.pdf`          |
| Maltese         | `-reading`                   | `to-change-everything-maltese-reading.pdf`      | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything-maltese-single.pdf`          |
| Romanian        | default                      | `to-change-everything-romanian.pdf`             | `https://cdn.crimethinc.com/assets/tce/images/ct-tce-ro.pdf`                                    |
| Russian         | `-reading`                   | `to-change-everything-russian-reading.pdf`      | `https://cdn.crimethinc.com/assets/tce/images/to-change-everything_rus.pdf`                     |
| Swedish         | default ("uppslag" = spread) | `to-change-everything-swedish.pdf`              | `https://cdn.crimethinc.com/assets/tce/images/att-forandra-allt_web_uppslag.pdf`                |
| Swedish         | `-reading`                   | `to-change-everything-swedish-reading.pdf`      | `https://cdn.crimethinc.com/assets/tce/images/att-forandra-allt_web.pdf`                        |

Items still to verify by opening the file:

- Arabic `-imposed` → paper size (letter or A4?)
- Bulgarian `-imposed` → paper size
- French (France) `-reading-version` → single page or spread?
- French (France) `-printing-version` → paper size
- Romanian single file → what type?
- Russian single file → what type?
- Swedish `att-forandra-allt_web.pdf` → single or spread?

## Step 3 — Set up CDN redirects (happens after Step 2)

For every old URL in `TCE_URLS.txt`, set up a redirect to the new canonical URL. Scope is CDN / S3 / CloudFront — not this codebase.

High-level groups of redirects needed:

1. **Every `/tce/images/*.pdf` and `/tce/pdfs/*.pdf`** → corresponding new `/assets/tce/downloads/...` URL (mapping derived from Step 2's table, same content).
2. **Every `/assets/tce/images/*.pdf`** → corresponding new `/assets/tce/downloads/...` URL.
3. **Every `/assets/tce/espanol/get/images/*.pdf`** → corresponding new `/assets/tce/downloads/...` URL.
4. **Every `/assets/tce/get/resources/*.pdf`** → corresponding new `/assets/tce/downloads/...` URL.
5. **Every `/assets/zines/to-change-everything*/*.pdf`, `/assets/zines/para-cambiar-todo*/*.pdf`** → corresponding new `/assets/tce/downloads/...` URL.

(Not listing every individual redirect row; the Step 2 table + `TCE_URLS.txt` together provide the full mapping. Happy to produce an explicit one-line-per-redirect list if that's easier for the CloudFront config.)

## Step 4 — Update YAMLs (follow-up PR, after Steps 2 + 3)

After the new URLs all return 200 and the redirects are live, update `pdf_get_url` in each YAML at `config/locales/to_change_everything/*.yml` to point at the new canonical URL. Not part of this plan.

## Appendix — content-identical groupings used to dedupe sources

Files confirmed byte-identical by HTTP `Content-Length`:

- **English 2up** (5,883,205 bytes): `/assets/tce/get/resources/To-Change-Everything_2up.pdf` ≡ `/tce/pdfs/to-change-everything-english-2up.pdf` ≡ `/assets/tce/images/to-change-everything-2up.pdf`
- **Portuguese Option A** (5,966,594 bytes): 5 URLs across `/tce/images/`, `/tce/pdfs/`, `/assets/tce/images/` under both `Para-Mudar-Tudo.pdf` and `to-change-everything-portugues.pdf`
- **Slovenian** (1,011,227 bytes): `spremeniti_vse_spread.pdf` ≡ `to-change-everything-slovenscina.pdf` ≡ `to-change-everything-slovensko.pdf` at both old and new paths
- **Czech "main"** (1,195,878 bytes): `to-change-everything-czech.pdf` ≡ `to-change-everything-czech-1up.pdf`
- **Polish** (951,306 bytes): `Zmienic-Wszystko.pdf` ≡ `to-change-everything-polski.pdf`
- **German Option A** (3,699,119 bytes): `Alles-Verandern.pdf` (old path) ≡ `to-change-everything-deutsch.pdf` (new path)
- **German Option B** (16,787,005 bytes): `Alles-Verandern.pdf` (new path) ≡ `Alles-Vera%CC%88ndern.pdf` (new path, URL-encoded combining umlaut)
- All other old-path files (`/tce/images/*` and `/tce/pdfs/*`) have byte-identical twins at `/assets/tce/images/<same-filename>.pdf`.

## Appendix — files only present at one old-path URL

For reference. Already covered by content-identical twins at the new path (via different filename), so no new copies needed:

- `/tce/images/Zmen-Vse.pdf` (958,032 bytes) — content-identical to `/assets/tce/images/to-change-everything-czech.pdf` (1,195,878 bytes), but with an un-damaged cover (the `/assets/` version's cover is damaged). Treated as canonical for Czech `-reading` in Step 2. Size difference is due to the broken/bloated cover image in the `/assets/` copy.
- `/tce/images/Zmienic-Wszystko.pdf` (951,306 bytes) — matches new `to-change-everything-polski.pdf`. Covered.
- `/tce/images/spremeniti_vse_spread.pdf` (1,011,227 bytes) — matches new `to-change-everything-slovenscina.pdf` / `-slovensko.pdf`. Covered.
- `/tce/pdfs/to-change-everything-english-2up.pdf` (5,883,205 bytes) — matches new `to-change-everything-2up.pdf`. Covered.
