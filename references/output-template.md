# Output Template

Use this structure for the internal draft, then split it into final files.

```markdown
# 基于对标拆解的小红书发布草稿

## 证据摘要
- 来源:
- 作者 / 标题:
- 可用数据:
- 转写状态:
- 画面证据:
- 关键风险:

## 爆款结构规则
- 选题公式:
- 标题/封面公式:
- 正文结构:
- 视觉/图文建议:

## 标题备选
1.
2.
3.
4.
5.

## 封面文案备选
1.
2.
3.

## 正文草稿

<小红书正文，只保留要发布的正文，不放交付说明>

## 标签
#标签 #标签 #标签

## 图文卡片计划
- 皮肤:
- 页数:
- P1:
- P2:
- P3:

## 发布前自检
- 证据来自哪里:
- 新增改写在哪里:
- 需要人工确认:
- 不能承诺:
```

Final file split:

- `text/publish.txt`: content under `正文草稿` only.
- `text/titles.txt`: title options only.
- `text/cover-copy.txt`: cover copy options only.
- `text/tags.txt`: tags only.
- `images/*.png`: rendered Xiaohongshu cards.

Do not deliver Markdown as the final posting file. Markdown may remain under `work/` as an intermediate.
