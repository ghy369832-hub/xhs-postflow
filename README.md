# xhs-postflow

Evidence-first Codex skill for turning a Xiaohongshu or short-video link into a publishable Xiaohongshu draft.

It is an orchestration skill:

1. Run `yyl-benchmark-breakdown` first to extract evidence: metadata, transcript, visual frames, reusable formula, and positioning.
2. Build an intermediate evidence pack.
3. Apply Xiaohongshu copy gates to generate titles, cover copy, body, tags, and publishing notes.

It must not claim guaranteed virality. The final output is a `基于对标拆解的可发布草稿`, not a guaranteed hit.

## Install

Clone this repo into your Codex skills directory:

```powershell
git clone https://github.com/ghy369832-hub/xhs-postflow.git "$env:USERPROFILE\.codex\skills\xhs-postflow"
```

Restart Codex or open a new Codex chat so the skill list refreshes.

## Dependency

For full video evidence extraction, also install/use `yyl-benchmark-breakdown`. `xhs-postflow` is the orchestration layer; it expects the benchmark skill to download, transcribe, and inspect visual evidence before writing copy.

## Usage

Best prompt:

```text
/xhs-postflow https://www.xiaohongshu.com/explore/xxxx
```

More explicit prompt:

```text
/xhs-postflow https://www.xiaohongshu.com/explore/xxxx
先拆证据包，再生成小红书发布草稿
```

Stable Codex skill invocation:

```text
用 $xhs-postflow 拆这个视频，先出证据包，再写发布草稿：
https://www.xiaohongshu.com/explore/xxxx
```

If you only type `/xhs-postflow` without a link, Codex will need to ask for the video link, transcript, screenshots, or note text.

## Notes

- Slash commands may work as plain-text trigger phrases if the Codex client does not provide a custom slash-command menu.
- For health, medical, legal, or financial topics, the skill uses stricter safety wording and avoids absolute claims.
- Downloaded media is temporary and should be cleaned after the evidence report and draft are saved.
