#!/usr/bin/env python3
"""Create a minimal Word document for an xhs-postflow text package.

Uses only Python stdlib so it works even when python-docx is unavailable.
"""
from __future__ import annotations

import argparse
import html
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

CONTENT_TYPES = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>
'''

RELS = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'''


def read_text(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8-sig").strip()


def paragraph(text: str = "", *, bold: bool = False) -> str:
    escaped = html.escape(text)
    rpr = "<w:rPr><w:b/></w:rPr>" if bold else ""
    return f'<w:p><w:r>{rpr}<w:t xml:space="preserve">{escaped}</w:t></w:r></w:p>'


def section(title: str, body: str) -> list[str]:
    if not body:
        return []
    parts = [paragraph(title, bold=True)]
    for line in body.splitlines():
        parts.append(paragraph(line)) if line.strip() else parts.append(paragraph())
    parts.append(paragraph())
    return parts


def build_document_xml(parts: list[str]) -> str:
    body = "\n".join(parts) + "\n<w:sectPr/>"
    return f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    {body}
  </w:body>
</w:document>
'''


def write_docx(output: Path, document_xml: str) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(output, "w", ZIP_DEFLATED) as zf:
        zf.writestr("[Content_Types].xml", CONTENT_TYPES)
        zf.writestr("_rels/.rels", RELS)
        zf.writestr("word/document.xml", document_xml)


def main() -> int:
    parser = argparse.ArgumentParser(description="Create text/publish.docx for xhs-postflow.")
    parser.add_argument("--text-dir", required=True, help="Path to the package text directory")
    parser.add_argument("--output", help="Output .docx path. Defaults to <text-dir>/publish.docx")
    args = parser.parse_args()

    text_dir = Path(args.text_dir)
    output = Path(args.output) if args.output else text_dir / "publish.docx"

    titles = read_text(text_dir / "titles.txt")
    cover = read_text(text_dir / "cover-copy.txt")
    body = read_text(text_dir / "publish.txt")
    tags = read_text(text_dir / "tags.txt")
    if not body:
        raise SystemExit(f"Missing publish body: {text_dir / 'publish.txt'}")

    parts: list[str] = [paragraph("小红书发布文案", bold=True), paragraph()]
    parts.extend(section("标题选项", titles))
    parts.extend(section("封面文案", cover))
    parts.extend(section("正文", body))
    parts.extend(section("标签", tags))
    write_docx(output, build_document_xml(parts))
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
