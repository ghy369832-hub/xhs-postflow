---
name: xhs-postflow
description: Orchestrates evidence-based Xiaohongshu post creation from a video or note link. Use when the user types /xhs-postflow, /xhs, $xhs-postflow, or asks to拆解视频后转成小红书文章、把对标视频改写成可发布笔记、先转写再产出爆款规则和发布草稿、or combine yyl-benchmark-breakdown with a Xiaohongshu copywriting workflow. This skill must run video evidence extraction before copywriting and must not claim guaranteed virality.
---

# XHS Postflow

This is an orchestration skill. It does not replace `yyl-benchmark-breakdown`; it makes that skill the required first stage, then turns the resulting evidence into a Xiaohongshu publishing draft with copy gates.

## Core Contract

- Do not write the final post from memory or guessing.
- Do not call a draft “guaranteed viral” or “必爆”. Call it a “基于对标拆解的可发布草稿”.
- Use `yyl-benchmark-breakdown` first for video/note evidence: metadata, transcript, visual frames, reusable formula, and positioning.
- Only after the evidence report exists, use the copywriting gates in `references/xhs-copy-gates.md` to produce titles, cover copy, body, tags, and revision notes.
- For health, medical, legal, financial, or other high-stakes content, read `references/health-content-safety.md` before writing and avoid absolute claims.
- Downloaded media is temporary. Use the staging directory documented by `yyl-benchmark-breakdown`, then clean temporary media after extracting conclusions.


## Invocation

Recommended prompts:

```text
/xhs-postflow <小红书或短视频链接>
/xhs <链接> 先拆证据包，再生成小红书发布草稿
用 $xhs-postflow 拆这个视频，先出证据包，再写发布草稿
```

If the client does not support custom slash commands, treat `/xhs-postflow` and `/xhs` as plain-text trigger phrases for this skill.
## Workflow

1. **Invoke the evidence skill**
   - Load and follow `yyl-benchmark-breakdown` for the target link.
   - If it cannot produce transcript or visual evidence, stop at a partial report and ask the user for missing transcript/screenshots instead of inventing content.
   - If `ffmpeg` or `whisper` appears missing, first distinguish real absence from sandbox/PATH error.

2. **Create the intermediate evidence pack**
   Read `references/evidence-chain.md` and produce an explicit evidence pack containing:
   - source link, platform, author, title, and available metrics;
   - complete transcript or original body;
   - visual evidence summary;
   - reusable topic, structure, title/cover, and visual formulas;
   - “保留 / 改写 / 禁止照搬” boundaries;
   - safety and factual-risk notes.

3. **Generate Xiaohongshu draft**
   Read `references/xhs-copy-gates.md` and `references/output-template.md`.
   Produce:
   - 5-8 title options;
   - 2-3 cover text options;
   - one publishable draft body;
   - tags/keywords;
   - humanization pass;
   - self-check notes explaining what came from evidence and what is original adaptation.

4. **Run safety and honesty gates**
   - Never promise performance.
   - Label uncertain facts as unverified.
   - For health content, keep language educational and non-diagnostic.
   - Make the final answer clear about whether the draft is ready to post or still needs user/domain review.

5. **Clean temporary media**
   When media was downloaded only for this task, run or adapt `scripts/cleanup-staging.ps1` after the report and draft are saved. Keep final markdown/text outputs; remove mp4, images, audio, extracted frames, and transient JSON.

## Output Rule

Final user-facing output should include the evidence pack summary before the draft. If the evidence is incomplete, deliver a partial draft only when clearly labeled as incomplete and explain what is missing.