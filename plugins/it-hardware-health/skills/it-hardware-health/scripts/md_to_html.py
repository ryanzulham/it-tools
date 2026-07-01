#!/usr/bin/env python3
"""Minimal, dependency-free Markdown -> styled HTML converter.
Handles the subset used by the IT health report: headings, tables, blockquotes,
horizontal rules, unordered lists, bold, inline code, and paragraphs (emoji pass through).
Usage: python3 md_to_html.py report.md > report.html
"""
import sys, html, re

CSS = """
@page { size: A4; margin: 18mm 16mm; }
* { box-sizing: border-box; }
body { font-family: -apple-system, 'Helvetica Neue', Arial, sans-serif; color:#1a1a1a;
       font-size: 12px; line-height: 1.5; }
h1 { font-size: 20px; border-bottom: 3px solid #333; padding-bottom: 6px; margin-top: 4px; }
h2 { font-size: 15px; margin-top: 20px; border-bottom: 1px solid #ccc; padding-bottom: 3px; }
h3 { font-size: 13px; margin-top: 14px; }
table { border-collapse: collapse; width: 100%; margin: 10px 0; }
th, td { border: 1px solid #bbb; padding: 6px 9px; text-align: left; vertical-align: top; }
th { background: #f0f0f0; font-weight: 600; }
tr:nth-child(even) td { background: #fafafa; }
blockquote { border-left: 4px solid #c0392b; background: #fdf3f2; margin: 10px 0;
             padding: 8px 14px; font-weight: 600; }
hr { border: none; border-top: 1px solid #ddd; margin: 16px 0; }
code { background: #f2f2f2; padding: 1px 4px; border-radius: 3px; font-size: 11px; }
ul { margin: 6px 0; padding-left: 22px; }
.footer { margin-top: 24px; font-size: 10px; color: #888; text-align: center; }
"""

def inline(t):
    t = html.escape(t)
    t = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', t)
    t = re.sub(r'`(.+?)`', r'<code>\1</code>', t)
    return t

def convert(md):
    out, lines, i = [], md.splitlines(), 0
    in_list = False
    def close_list():
        nonlocal in_list
        if in_list: out.append('</ul>'); in_list = False
    while i < len(lines):
        line = lines[i].rstrip()
        # strip HTML comments (single-line)
        if line.strip().startswith('<!--') and line.strip().endswith('-->'):
            i += 1; continue
        # table block
        if line.strip().startswith('|') and i + 1 < len(lines) and re.match(r'^\s*\|[-:\s|]+\|\s*$', lines[i+1]):
            close_list()
            headers = [c.strip() for c in line.strip().strip('|').split('|')]
            out.append('<table><thead><tr>' + ''.join(f'<th>{inline(h)}</th>' for h in headers) + '</tr></thead><tbody>')
            i += 2
            while i < len(lines) and lines[i].strip().startswith('|'):
                cells = [c.strip() for c in lines[i].strip().strip('|').split('|')]
                out.append('<tr>' + ''.join(f'<td>{inline(c)}</td>' for c in cells) + '</tr>')
                i += 1
            out.append('</tbody></table>')
            continue
        # headings
        m = re.match(r'^(#{1,6})\s+(.*)', line)
        if m:
            close_list(); lvl = len(m.group(1))
            out.append(f'<h{lvl}>{inline(m.group(2))}</h{lvl}>'); i += 1; continue
        # horizontal rule
        if re.match(r'^-{3,}$', line.strip()):
            close_list(); out.append('<hr>'); i += 1; continue
        # blockquote
        if line.strip().startswith('>'):
            close_list()
            out.append(f'<blockquote>{inline(line.strip()[1:].strip())}</blockquote>'); i += 1; continue
        # unordered list
        if re.match(r'^\s*[-*]\s+', line):
            if not in_list: out.append('<ul>'); in_list = True
            item = re.sub(r'^\s*[-*]\s+', '', line)
            out.append(f'<li>{inline(item)}</li>'); i += 1; continue
        # blank
        if not line.strip():
            close_list(); i += 1; continue
        # paragraph
        close_list(); out.append(f'<p>{inline(line)}</p>'); i += 1
    close_list()
    return '\n'.join(out)

def main():
    src = open(sys.argv[1], encoding='utf-8').read() if len(sys.argv) > 1 else sys.stdin.read()
    body = convert(src)
    print(f'<!DOCTYPE html><html><head><meta charset="utf-8"><style>{CSS}</style></head>'
          f'<body>{body}<div class="footer">Dihasilkan oleh skill it-hardware-health — IT Support</div></body></html>')

if __name__ == '__main__':
    main()
