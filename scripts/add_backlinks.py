#!/usr/bin/env python3
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOP_README = ROOT / 'README.md'

def find_nearest_readme(path: Path):
    # Search current dir then upward for README.md, stop at repo root
    cur = path.parent
    while True:
        candidate = cur / 'README.md'
        if candidate.exists():
            return candidate
        if cur == ROOT:
            return None
        cur = cur.parent


def relativize(from_path: Path, to_path: Path):
    return os.path.relpath(to_path, start=from_path.parent)


def main():
    md_files = list(ROOT.rglob('*.md'))
    for md in md_files:
        # skip top-level README
        if md.resolve() == TOP_README.resolve():
            continue
        # find nearest README
        nearest = find_nearest_readme(md)
        if nearest is None:
            # fallback to top-level README
            nearest = TOP_README
        rel = relativize(md, nearest)
        backlink = f"[back to Readme]({rel})\n"
        # read file
        text = md.read_text(encoding='utf-8')
        if backlink.strip() in text:
            continue
        # avoid duplicating if a similar backlink exists
        if '\n[back to Readme]' in text or text.strip().endswith('[back to Readme]()'):
            continue
        # append backlink with a preceding blank line
        if not text.endswith('\n'):
            text += '\n'
        text += '\n' + backlink
        md.write_text(text, encoding='utf-8')
        print(f'Updated: {md.relative_to(ROOT)} -> {rel}')

if __name__ == '__main__':
    main()
