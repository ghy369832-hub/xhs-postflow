# xhs-postflow

`xhs-postflow` 是一个 Codex 编排型技能，用来把小红书/Rednote 对标视频或图文链接，整理成一套可以手动发布的小红书图文包。

它不是单纯“转写文案”。它会按流程把原始内容拆成证据，再改写成可发布文案，并把文案拆成小红书 3:4 图片卡片。

最终你会拿到：

- `text/publish.docx`：主文案 Word 文档，包含标题、封面文案、正文、标签。
- `text/publish.txt`：正文纯文本备份，方便复制到小红书。
- `text/titles.txt`、`cover-copy.txt`、`tags.txt`：快捷复制用的侧边文件。
- `images/01-cover.png`、`02-body.png` 等：小红书 1080×1440 图文图片。
- `work/`：中间工作文件，方便后续改图、改 HTML、重新渲染。

## 适合什么场景

- 你看到一条小红书爆款视频，想拆解后写成自己的图文笔记。
- 你已经有一篇长文，想转成小红书可发的图片组。
- 你想把“文案”和“配图”分开交付，方便复制正文、单独上传图片。
- 你想让 Codex 固定按证据链工作，不凭空编内容。

不适合：

- 自动登录小红书、自动发布、自动刷数据。
- 保证爆款、保证涨粉、保证转化。
- 医疗、法律、金融内容的最终专业审核。

## 安装

在朋友电脑的 Windows PowerShell 里运行：

```powershell
git clone https://github.com/ghy369832-hub/xhs-postflow.git "$env:USERPROFILE\.codex\skills\xhs-postflow"
```

然后重启 Codex，或者开一个新的 Codex 聊天，让技能列表刷新。

如果已经下载到任意目录，也可以在仓库目录里运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## 依赖

这个技能是“编排器”，完整效果依赖另外两个技能：

- `yyl-benchmark-breakdown`：负责抓取/拆解视频、转写、抽帧、总结爆款结构。
- `xhs-article-to-images`：负责把文章渲染成小红书 1080×1440 PNG 图片组。

视频类任务还需要本机媒体工具链可用，例如：

- FFmpeg
- 转写工具链，例如 Whisper
- 能正常访问小红书链接的网络环境

如果缺依赖，Codex 会停在对应步骤，并告诉你缺什么。

## 快速使用

在 Codex 里直接输入：

```text
[$xhs-postflow] https://www.xiaohongshu.com/...
```

或者：

```text
/xhs-postflow https://www.xiaohongshu.com/...
```

也可以更明确一点：

```text
用 $xhs-postflow 拆这个小红书视频，生成可发布 Word 文案和图片组：
https://www.xiaohongshu.com/...
```

如果你已经有文章文件，可以这样用：

```text
[$xhs-postflow] C:\path\to\article.txt
```

## 它会怎么工作

标准流程是：

1. 识别输入是链接还是文章。
2. 如果是视频/笔记链接，先调用 `yyl-benchmark-breakdown` 拿证据：标题、作者、数据、转写、画面、结构。
3. 根据证据重写成小红书可发布文案，避免“AI 味”和“如果你想继续”这类交付尾巴。
4. 生成 Word 文档 `publish.docx`，这是主交付文件。
5. 调用 `xhs-article-to-images` 把正文拆成 3:4 小红书图片卡片。
6. 检查图片尺寸、文字溢出、模板残留、医学/金融/法律风险表述。
7. 输出一个本地发布包，用户手动复制文案、上传图片。

## 输出在哪里

默认输出在当前 Codex 工作区：

```text
outputs/xhs-postflow/<标题或主题>/
├── text/
│   ├── publish.docx
│   ├── publish.txt
│   ├── titles.txt
│   ├── cover-copy.txt
│   └── tags.txt
├── images/
│   ├── 01-cover.png
│   ├── 02-body.png
│   └── ...
└── work/
    ├── article.md
    ├── index.html
    ├── assets/
    └── output/
```

发布时通常只需要：

- 打开 `text/publish.docx`，复制标题、正文、标签。
- 把 `images/` 里的 PNG 按顺序上传到小红书。

## 常见提示词

拆视频：

```text
[$xhs-postflow] <小红书视频链接>
```

只做图文包，不要重新写太多：

```text
[$xhs-postflow] <文章路径>
保持原意，转成小红书图文包，文案用 Word，图片单独放 images。
```

医疗健康内容：

```text
[$xhs-postflow] <链接>
这是健康科普，表述保守一点，不要诊断，不要承诺疗效。
```

指定风格：

```text
[$xhs-postflow] <链接>
图片用 E 雅刊风格，整体克制、干净、适合健康科普。
```

## 注意事项

- 这个技能不会自动发布小红书，也不会登录你的账号。
- 它不会保证“必爆”，只会输出“基于对标拆解的可发布草稿”。
- 健康、医疗、法律、金融内容需要人工复核，不能直接当专业建议。
- Markdown 只作为中间文件，最终文案默认是 Word 文档。
- 图片默认是小红书竖版 3:4，尺寸为 1080×1440。

## 更新

如果朋友电脑上已经安装过，可以进入技能目录后更新：

```powershell
cd "$env:USERPROFILE\.codex\skills\xhs-postflow"
git pull
```

如果不是用 git clone 安装的，重新下载后运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## 卸载

删除这个目录即可：

```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\skills\xhs-postflow"
```
