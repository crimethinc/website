# TCE migration working files

One-off scripts and intermediate outputs from the "To Change Everything" PDF + orphan-YAML migration. Preserved here so nothing is lost, but **not part of the running application** — these are ad-hoc tools that were written to solve this specific migration and aren't intended to run on CI.

## Scripts (in approximate order of use)

| file | what it does |
|---|---|
| `download_tce_pdfs.rb` | Downloads every TCE PDF from the CDN and renames to the canonical endonym filenames. Source of truth for the 77 files that went to `/assets/tce/downloads/`. Idempotent. |
| `extract_idml_text.rb` | Unzips InDesign `.idml` files and pulls out reading-order text into `.txt` per language. Walks `designmap.xml` → spreads → text frames for correct story order. |
| `map_idml_to_yaml.rb` | V1 of the paragraph → YAML-key mapper. Uses the English extract + `en.yml` as a Rosetta Stone. Produces `en-mapping.json`. |
| `generate_draft_yamls.rb` | V2 mapper — IDML-based. Proportional-position alignment. Works but drifts for languages with different paragraph counts; kept here for reference. |
| `generate_draft_yamls_from_pdf.rb` | V4 mapper — PDF-based, page-aligned against the canonical 48-page `-reading` layout. Handles bidi marks, label-page bleed, per-language page offsets. Best quality; produced the drafts that ended up in the orphan PRs. |
| `build_orphan_yamls.rb` | Consolidates v2 + v4 outputs into one folder per-language for handoff, picking the highest-quality draft available for each. |
| `rename_orphan_pdfs.rb` | Renames downloaded PDFs in `/public/downloads/` from English exonyms to native-script endonyms; creates Latin-transliteration duplicate copies for non-Latin scripts. |
| `rename_orphan_roots.rb` | Rewrites the YAML root key in each orphan draft YAML from exonym to endonym; prepends a note to the two `.txt` drafts. Runs per-branch. |
| `create_orphan_prs.rb` | Creates the 11 orphan draft PRs off `main`, one per language. |
| `update_orphan_pr_bodies.rb` | Rewrites the PR body text on all 11 PRs after a body-template tweak. |

All scripts expect to run from the repo root with `ruby script/tce/<name>.rb`. **Paths inside each script assume their original home was `tmp/`**, so moving back to `tmp/` (or adjusting the `File.expand_path` lines) is required to actually rerun.

## Data

| directory | what's inside |
|---|---|
| `tce_extracts/` | IDML text extracts per language (17 `.txt` files plus a few mapping artifacts like `en-mapping.tsv` / `en-mapping.json`). |
| `tce_orphan_yamls/` | Final handoff bundle: per-orphan-language draft YAML or raw text extract, plus a `README.md` describing quality level per file. This is what went into the 12 orphan PRs. |
| `tce_draft_yamls_v4/` | Per-language drafts from the V4 PDF-based mapper. Useful as the clean-quality source; v2 outputs (imperfect IDML-based) were dropped. |

## Related files outside this folder

- `TCE_PDF_MIGRATION_PLAN.md` (repo root) — the overall migration plan.
- `TCE_URLS.txt` (repo root) — snapshot of the S3 inventory taken during the audit.
- `docs/to-change-everything-guide.md` — canonical process doc for creating a real TCE language YAML.
- `public/downloads/` — the staging folder where the 77 renamed PDFs landed before S3 upload. Intended to be deleted locally after upload.
