---
name: it-hardware-health
description: This skill should be used when the user asks to "diagnosa laptop", "cek kesehatan laptop/PC", "diagnose hardware", "hardware health report", "cek baterai/RAM/SSD/CPU", "apakah perlu ganti laptop", "laporan kondisi komputer", or wants an IT Support health assessment of a Mac, Windows, or Linux machine, including a recommendation on repair vs. replacement and a procurement memo.
version: 0.1.0
---

# IT Hardware Health — Diagnosa & Laporan Kesehatan Laptop/PC

Act as a professional IT Support technician. This skill detects hardware, analyzes each
component's health against objective thresholds, and produces a clear health report with a
repair-vs-replace recommendation (and, on request, a procurement memo for HR/management).

## Workflow

Follow these five steps in order.

### Step 1 — Detect the operating system

Run `uname -s` (macOS/Linux) or check for PowerShell (Windows). Select the matching
diagnostic script:

- **macOS** → `scripts/diagnose_macos.sh`
- **Linux** → `scripts/diagnose_linux.sh`
- **Windows** → `scripts/diagnose_windows.ps1` (run via PowerShell)

### Step 2 — Collect hardware data

Execute the matching script. Each script prints a labeled, section-by-section dump covering:
system model & age, CPU, RAM + swap/memory pressure, storage + SMART, battery health &
cycle count, thermal state, GPU/display, and OS version. If a script is unavailable, fall
back to the individual commands listed in `references/commands.md`.

Do not guess values. If a command fails or a component is absent (e.g. desktop with no
battery), record it as "N/A" and move on — never fabricate readings.

### Step 3 — Analyze against thresholds

Interpret each reading using `references/health-thresholds.md`, which defines the
GREEN / YELLOW / RED bands for every component (battery health %, cycle count, RAM
adequacy & swap pressure, CPU load per core, SSD SMART & wear, thermal throttling, OS
end-of-support). Compute derived metrics where needed:

- **Battery health %** = `MaxCapacity / DesignCapacity × 100`
- **CPU load ratio** = `load average ÷ number of cores` (>1.0 = oversubscribed)
- **Swap pressure** = swap used vs. total, plus lifetime swapins/swapouts

Assign each component a status color and a one-line reason grounded in the actual numbers.

### Step 4 — Produce the health report

Fill in `assets/report-template.md` with the collected data and per-component analysis.
Present it to the user as Markdown. Always include:

1. Device identity table (model, serial, age, specs)
2. Per-component status table (GREEN/YELLOW/RED + reason with real numbers)
3. Root-cause analysis (which components limit the machine and why)
4. Cost consideration (repair estimate vs. replacement value)
5. A clear verdict using the decision rule below

### Step 5 — Give the repair-vs-replace verdict

Apply the decision rule from `references/health-thresholds.md`:

- **REPLACE (urgent)** — any RED safety item (swollen/failing battery, failing SSD SMART) OR OS past end-of-support with no upgrade path.
- **REPLACE (plan within 1 quarter)** — 2+ RED/YELLOW items that cannot be economically repaired (e.g. soldered RAM too small + worn battery + aging CPU).
- **REPAIR** — a single isolated fault that is economical to fix (e.g. only the battery is worn on an otherwise capable, upgradeable machine).
- **KEEP** — all components GREEN/YELLOW with no economic or safety concern.

State the verdict plainly with justification tied to the findings. When the user asks for a
procurement memo, use the memo section in `assets/report-template.md`, including suggested
minimum replacement specs.

### Step 6 — Export the report to PDF (on request)

When the user asks to export/save the report as a file (PDF), write the finished report to a
Markdown file, then run `scripts/export_pdf.sh`:

```bash
bash scripts/export_pdf.sh <report.md> [output.pdf]
```

Default output is `~/Desktop/Laporan_Kesehatan_<timestamp>.pdf`; pass a second argument to set
a specific path. The script converts Markdown → styled HTML (`scripts/md_to_html.py`, no
dependencies) → PDF via Chrome/Chromium/Edge headless, falling back to macOS `cupsfilter`. It
requires no installs when a Chromium-based browser is present. After it runs, confirm the file
exists (`ls -lh`) before reporting success — never claim a PDF was created without verifying.

On Linux/Windows without a Chromium browser, fall back to `pandoc report.md -o report.pdf` or
`wkhtmltopdf` if available, and tell the user which tool is needed if none is present.

## Guardrails

- Read-only diagnosis. The scripts only query state; never run commands that modify config,
  disks, or power settings.
- Some commands need elevated privileges (e.g. `smartctl`, `dmidecode`). If they fail for
  lack of permission, note it and suggest the user re-run with `sudo`, or ask them to run
  it themselves via a `!` command — do not silently skip.
- Keep the tone factual and neutral. The report may go to non-technical stakeholders (HR,
  management), so explain each finding in plain language alongside the raw numbers.

## Additional Resources

### Scripts
- **`scripts/diagnose_macos.sh`** — full macOS hardware sweep (`system_profiler`, `ioreg`, `pmset`, `sysctl`)
- **`scripts/diagnose_linux.sh`** — Linux sweep (`lscpu`, `free`, `upower`, `smartctl`, `sensors`)
- **`scripts/diagnose_windows.ps1`** — Windows sweep (CIM/WMI, battery report, storage reliability)
- **`scripts/export_pdf.sh`** — export a Markdown report to PDF (Chrome headless → cupsfilter fallback)
- **`scripts/md_to_html.py`** — dependency-free Markdown → styled HTML converter used by the PDF export

### References
- **`references/health-thresholds.md`** — GREEN/YELLOW/RED bands per component + the repair-vs-replace decision rule
- **`references/commands.md`** — individual fallback commands per OS when a script is unavailable

### Assets
- **`assets/report-template.md`** — health report + procurement memo template
