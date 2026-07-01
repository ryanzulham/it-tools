#!/bin/bash
# Export a Markdown report to a PDF (default: on the Desktop).
# Usage: bash export_pdf.sh <input.md> [output.pdf]
# macOS: Chrome headless (primary) -> cupsfilter (fallback). No installs required.

set -e
MD="$1"
if [ -z "$MD" ] || [ ! -f "$MD" ]; then
  echo "Usage: bash export_pdf.sh <input.md> [output.pdf]" >&2; exit 1
fi
OUT="${2:-$HOME/Desktop/Laporan_Kesehatan_$(date +%Y%m%d_%H%M%S).pdf}"
DIR="$(cd "$(dirname "$0")" && pwd)"
TMPHTML="$(mktemp -t healthreport).html"

# 1) Markdown -> styled HTML
python3 "$DIR/md_to_html.py" "$MD" > "$TMPHTML"

# 2) HTML -> PDF
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[ -x "$CHROME" ] || CHROME="/Applications/Chromium.app/Contents/MacOS/Chromium"
[ -x "$CHROME" ] || CHROME="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"

if [ -x "$CHROME" ]; then
  PROFILE="$(mktemp -d)"   # isolated profile so it won't clash with a running browser
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --user-data-dir="$PROFILE" --print-to-pdf="$OUT" "file://$TMPHTML" >/dev/null 2>&1 || true
  rm -rf "$PROFILE"
fi

# Fallback: built-in cupsfilter
if [ ! -f "$OUT" ] && command -v cupsfilter >/dev/null 2>&1; then
  cupsfilter "$TMPHTML" > "$OUT" 2>/dev/null || true
fi

rm -f "$TMPHTML"

if [ -f "$OUT" ] && [ -s "$OUT" ]; then
  echo "PDF berhasil dibuat: $OUT"
else
  echo "GAGAL membuat PDF. Pastikan Google Chrome terpasang, atau install pandoc/wkhtmltopdf." >&2
  exit 1
fi
