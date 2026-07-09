---
name: xhs-postflow
description: Orchestrates evidence-based Xiaohongshu/Rednote publishing packages from a video/note link or an existing article. Use when the user types /xhs, /xhs-postflow, $xhs-postflow, /xhs-pack, or asks to拆解视频后转成小红书文章、把对标视频改写成可发布笔记、把文章做成小红书图文、生成小红书图文包、文章转小红书图片、输出文案和图片分开的发布包. This skill coordinates yyl-benchmark-breakdown for evidence, copy gates for publishable text, and xhs-article-to-images for 1080x1440 PNG cards; it must not claim guaranteed virality or auto-publish to Xiaohongshu.
---

# XHS Postflow

This is an orchestration skill for producing a **local publish package**:

```text
source evidence -> publishable text -> 1080x1440 image cards -> separated text/ and images/
```

It does not replace `yyl-benchmark-breakdown` or `xhs-article-to-images`; it coordinates them.

## Slash Commands

Treat these as trigger phrases even when the client does not implement real slash commands:

```text
/xhs <link-or-article-path>
/xhs-postflow <link-or-article-path>
/xhs-pack <link-or-article-path>
```

Default behavior:

- Link input: run evidence extraction first, then write publishable text, then generate image cards unless the user asks for text only.
- Article path input: skip evidence extraction only if the article already contains the adapted publishable draft; then package text and generate image cards.
- Never auto-publish, log in, upload, or operate Xiaohongshu accounts. Deliver files for manual publishing.

## Core Contract

- Do not write from memory or guessing when a link/video is provided.
- Do not call a draft "guaranteed viral", "必爆", or similar. Use "基于对标拆解的可发布草稿".
- For video/note links, use `yyl-benchmark-breakdown` first for metadata, transcript/body, visual frames/images, reusable formula, and positioning.
- For existing articles, still run the copy and safety gates before packaging.
- For health, medical, legal, financial, or other high-stakes content, read `references/health-content-safety.md` before writing.
- Final delivery must separate publishable text files from PNG images. Word .docx is the primary final text artifact. Markdown is allowed only as an intermediate working format, and .txt must not be the only final copy artifact.

## Output Layout

Create one release package per post. Use the current workspace `outputs/` when available:

```text
outputs/xhs-postflow/<slug>/
├── text/
│   ├── publish.docx        # required, primary copy document for posting/review
│   ├── publish.txt         # optional plain-text backup/compatibility copy
│   ├── titles.txt          # optional sidecar; include content in publish.docx
│   ├── cover-copy.txt      # optional sidecar; include content in publish.docx
│   └── tags.txt            # optional sidecar; include content in publish.docx
├── images/
│   ├── 01-cover.png
│   ├── 02-body.png
│   └── ...
└── work/
    ├── article.md          # intermediate only
    ├── index.html          # xhs-article-to-images working file
    ├── assets/
    └── output/             # raw renderer output before copying/renaming to images/
```

Use `scripts/init-release-package.ps1` to create this structure when possible:

```powershell
powershell -ExecutionPolicy Bypass -File <skill>/scripts/init-release-package.ps1 -Slug "<slug>" -Root "<workspace>\outputs\xhs-postflow"
```

## Workflow

1. **Classify input**
   - If input is a link to a video/note/account, run the evidence workflow.
   - If input is an existing article file, inspect it and decide whether it is already publishable or still needs humanization/safety revision.
   - If input is missing, ask for exactly one link or article path.

2. **Build or reuse evidence**
   - For links, load and follow `yyl-benchmark-breakdown`.
   - If transcript/body or visual evidence is missing, stop at a partial report and ask for missing transcript/screenshots instead of inventing details.
   - Read `references/evidence-chain.md` and produce a compact evidence pack.

3. **Generate publishable text**
   - Read `references/xhs-copy-gates.md` and `references/output-template.md`.
   - Produce title options, cover copy options, publish body, tags, and self-check notes.
   - Run one humanization pass: remove AI handoff phrases such as "如果你想要", "本文是改写稿", "参考边界", "以下是", "一文讲清楚" unless they are genuinely natural for the post.
   - Save final posting artifacts with Word as the primary deliverable:
     - `text/publish.docx`: required; contains title options, cover copy options, publish body, and tags in clearly labeled sections.
     - `text/publish.txt`: optional compatibility copy; if created, it contains only the body that should be pasted into Xiaohongshu.
     - `text/titles.txt`, `text/cover-copy.txt`, `text/tags.txt`: optional quick-copy sidecars; if created, their content must also appear in `publish.docx`.
   - When no richer document tool is being used, run `scripts/write-publish-docx.py` after text sidecars exist. Do not make `.md` or `.txt` the only final text artifact.

4. **Generate image cards**
   - Use `xhs-article-to-images` after the final publish body is ready and `publish.docx` is planned.
   - Create `work/article.md` from the publish body only; keep operational notes out of image cards.
   - Default image skin: E 雅刊 unless the user specifies another style. If the topic is practical health/education and no image assets are available, prefer a restrained style over decorative themes.
   - Follow `xhs-article-to-images` exactly for page planning, HTML filling, and rendering.
   - Render via:

```powershell
node "C:\Users\ghy36\.codex\skills\xhs-article-to-images\scripts\render.cjs" "<package>\work"
```

   - Copy rendered PNGs from `work/output/` to `images/`, renamed as `01-cover.png`, `02-body.png`, etc.

5. **Verify**
   - Inspect generated PNGs visually before claiming completion.
   - Confirm every image is 1080x1440.
   - Check no text overflow, no template/example text, no AI handoff text, no unsafe health/legal/financial claims, and no unrelated instructions inside cards.
   - Confirm final package contains `text/publish.docx` and `images/` separately.

6. **Report**
   - Give the package path and the key files, not a long markdown dump.
   - State whether it is ready for manual posting or still needs domain review.

## Cleanup

Keep final `text/` and `images/`. Keep `work/` until the user approves the output or asks to clean. If media was downloaded only for evidence extraction, run or adapt `scripts/cleanup-staging.ps1` after final files are saved.


