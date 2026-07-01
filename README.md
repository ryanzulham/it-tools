# IT Tools — Marketplace Plugin Claude Code

Kumpulan tools internal IT Support untuk [Claude Code](https://claude.com/claude-code).
Repo ini adalah **marketplace** berisi satu atau lebih plugin yang bisa dipasang tim.

## Plugin yang tersedia

| Plugin | Fungsi |
|---|---|
| **it-hardware-health** | Diagnosa perangkat keras laptop/PC (macOS, Windows, Linux), analisa kesehatan komponen, laporan + verdict *repair-vs-replace*, dan ekspor PDF ke Desktop. |

---

## Cara Pakai (untuk anggota tim)

Jalankan di dalam sesi Claude Code:

```
/plugin marketplace add <ORG-ATAU-USER>/it-tools
/plugin install it-hardware-health@it-tools
```

Ganti `<ORG-ATAU-USER>/it-tools` dengan lokasi repo ini di GitHub
(mis. `perusahaan/it-tools`). Untuk repo Git internal (GitLab/Bitbucket/self-hosted),
gunakan URL lengkap:

```
/plugin marketplace add https://git.perusahaan.co.id/it/it-tools.git
```

Setelah terpasang, skill aktif otomatis. Cukup minta, misalnya:

- "diagnosa laptop"
- "cek kesehatan PC ini"
- "apakah laptop ini perlu diganti?"
- "buatkan laporan kondisi komputer dan ekspor ke PDF"

## Update

Saat plugin diperbarui (maintainer `git push`), anggota tim menarik versi terbaru dengan:

```
/plugin marketplace update it-tools
```

## Untuk Maintainer (cara publish pertama kali)

```bash
cd it-tools
git init
git add .
git commit -m "Add it-hardware-health plugin"
git branch -M main
git remote add origin <URL-REPO-GIT-ANDA>
git push -u origin main
```

Selesai. Bagikan dua baris perintah `/plugin ...` di atas ke tim.

## Struktur Repo

```
it-tools/
├── .claude-plugin/
│   └── marketplace.json           # daftar plugin di marketplace ini
├── plugins/
│   └── it-hardware-health/
│       ├── .claude-plugin/
│       │   └── plugin.json         # manifest plugin
│       └── skills/
│           └── it-hardware-health/
│               ├── SKILL.md
│               ├── scripts/        # diagnose_{macos,linux,windows}, export_pdf, md_to_html
│               ├── references/     # threshold analisa + perintah fallback
│               └── assets/         # template laporan + memo HRD
└── README.md
```

## Catatan Keamanan

Semua script diagnosa bersifat **read-only** — hanya membaca status perangkat, tidak
mengubah konfigurasi/disk/power. Ekspor PDF hanya menulis file output (default ke Desktop).
