# LAPORAN DIAGNOSA KESEHATAN PERANGKAT
<!-- Isi placeholder {{...}}. Hapus baris/bagian yang tidak relevan (mis. baterai untuk PC desktop). Gunakan emoji status: 🟢 GREEN, 🟠 YELLOW, 🔴 RED. -->

**Perihal:** Diagnosa Kesehatan Perangkat Keras
**Tanggal:** {{tanggal}} | **Oleh:** IT Support

## A. Identitas Perangkat

| Item | Detail |
|---|---|
| Model | {{model}} |
| Serial Number | {{serial}} |
| Prosesor | {{cpu}} ({{cores}} core) |
| RAM | {{ram}} ({{ram_upgradeable}}) |
| Penyimpanan | {{storage}} |
| Sistem Operasi | {{os}} |
| Usia Perangkat | {{usia}} |

## B. Hasil Diagnosa per Komponen

| Komponen | Status | Keterangan (dengan angka nyata) |
|---|---|---|
| Baterai | {{status}} | Health {{batt_health}}%, {{cycles}} siklus, kondisi: {{batt_condition}} |
| RAM | {{status}} | {{ram}}; swap {{swap_used}}/{{swap_total}} — {{ram_note}} |
| CPU | {{status}} | {{cores}} core; load ratio {{load_ratio}} |
| Penyimpanan | {{status}} | SMART {{smart}}; wear {{wear}}; sisa {{free}} |
| Thermal | {{status}} | {{thermal_note}} |
| GPU/Display | {{status}} | {{gpu}} |
| OS/Keamanan | {{status}} | {{os_support_note}} |

## C. Analisis (Akar Masalah)

{{Jelaskan komponen mana yang membatasi kinerja/keamanan dan mengapa, dalam bahasa awam + angka.}}

## D. Pertimbangan Biaya

- Estimasi biaya perbaikan: {{repair_cost}}
- Nilai/biaya unit pengganti: {{replace_cost}}
- Analisis: {{apakah perbaikan sepadan atau hanya menunda masalah}}

## E. VERDICT

> **{{REPLACE URGENT | REPLACE (rencanakan ≤1 kuartal) | REPAIR | KEEP}}**

**Justifikasi:** {{alasan mengacu pada aturan keputusan dan temuan di atas}}

**Usulan spesifikasi minimum unit pengganti (jika REPLACE):**
- RAM minimal 16 GB
- SSD minimal 512 GB
- Prosesor modern (Apple M-series / Intel Core Ultra / AMD Ryzen setara)

---
---

<!-- ============ BAGIAN OPSIONAL: MEMO PENGAJUAN KE HRD/MANAJEMEN ============ -->
<!-- Sertakan bagian ini hanya jika user meminta memo pengadaan. -->

# MEMO INTERNAL — PENGAJUAN PENGGANTIAN PERANGKAT

**Kepada:** {{HRD / General Affairs / Manajemen}}
**Dari:** IT Support
**Tanggal:** {{tanggal}}
**Perihal:** Permohonan Penggantian Unit {{perangkat}} (Berdasarkan Hasil Diagnosa)
**Sifat:** {{prioritas}}

## 1. Latar Belakang
Berdasarkan diagnosa perangkat keras terhadap unit {{model}} (SN {{serial}}), perangkat
{{ringkasan kondisi — mis. telah mencapai penghujung siklus hidup produktif}}.

## 2. Ringkasan Temuan
{{Salin tabel status komponen dari Bagian B, fokus pada item RED/YELLOW.}}

## 3. Rekomendasi
{{Verdict + justifikasi dari Bagian E.}}

## 4. Usulan Spesifikasi Unit Pengganti
| Komponen | Spesifikasi Disarankan |
|---|---|
| RAM | Minimal 16 GB |
| Penyimpanan | SSD minimal 512 GB |
| Prosesor | Modern (Apple M-series / Intel Core Ultra / AMD Ryzen setara) |

## 5. Penutup
Demikian memo ini disampaikan sebagai dasar pertimbangan pengadaan. IT Support siap
mendampingi pemilihan unit, migrasi data, dan konfigurasi perangkat baru.

**Hormat kami,**            **Menyetujui,**

IT Support                  {{HRD / Manajemen}}

( ................. )       ( ................. )
