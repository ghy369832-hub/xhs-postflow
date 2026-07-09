# xhs-postflow

Codex skill for turning a Xiaohongshu/Rednote video or note link into a local publishing package:

- Word copy document: `text/publish.docx`
- Optional plain text sidecars: `publish.txt`, `titles.txt`, `cover-copy.txt`, `tags.txt`
- Xiaohongshu image cards: `images/*.png`

This is an orchestration skill. It coordinates evidence extraction, copy rewriting, and image-card generation.

## Install

Fastest install on Windows PowerShell:

```powershell
git clone https://github.com/ghy369832-hub/xhs-postflow.git "$env:USERPROFILE\.codex\skills\xhs-postflow"
```

Alternative install:

```powershell
git clone https://github.com/ghy369832-hub/xhs-postflow.git
cd xhs-postflow
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Then restart Codex or open a new Codex chat so the skill list refreshes.

## Dependencies

Install these skills on the target computer too:

- `yyl-benchmark-breakdown`
- `xhs-article-to-images`

For video extraction and transcription, the target computer also needs the same local media tooling used by those skills, such as FFmpeg and the configured transcription toolchain.

## Usage

In Codex:

```text
[$xhs-postflow] <xiaohongshu link>
```

Or:

```text
/xhs-postflow <xiaohongshu link>
```

The final output is written under the current workspace:

```text
outputs/xhs-postflow/<slug>/
├── text/
│   ├── publish.docx
│   ├── publish.txt
│   ├── titles.txt
│   ├── cover-copy.txt
│   └── tags.txt
├── images/
└── work/
```

## Notes

- The skill does not auto-publish or log in to Xiaohongshu.
- Health, legal, financial, and other high-stakes content still needs domain review before posting.
- Markdown is only used as an intermediate working format; Word is the primary text deliverable.
