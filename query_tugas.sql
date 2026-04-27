-- ============================================================
-- TUGAS 1: EKSPLORASI DATABASE PERPUSTAKAAN
-- File: query_tugas.sql
-- Deskripsi: Kumpulan query untuk eksplorasi database perpustakaan
-- ============================================================

USE perpustakaan;

-- ============================================================
-- BAGIAN 1: STATISTIK BUKU
-- ============================================================

-- 1.1 Total buku seluruhnya (jumlah baris/judul buku)
SELECT COUNT(*) AS total_buku
FROM buku;

-- 1.2 Total nilai inventaris (sum harga × stok)
SELECT 
    SUM(harga * stok) AS total_nilai_inventaris,
    FORMAT(SUM(harga * stok), 0) AS total_nilai_inventaris_format
FROM buku;

-- 1.3 Rata-rata harga buku
SELECT 
    AVG(harga) AS rata_rata_harga,
    FORMAT(AVG(harga), 0) AS rata_rata_harga_format
FROM buku;

-- 1.4 Buku termahal (tampilkan judul dan harga)
SELECT judul, harga
FROM buku
ORDER BY harga DESC
LIMIT 1;

-- 1.5 Buku dengan stok terbanyak
SELECT judul, stok
FROM buku
ORDER BY stok DESC
LIMIT 1;


-- ============================================================
-- BAGIAN 2: FILTER DAN PENCARIAN
-- ============================================================

-- 2.1 Semua buku kategori Programming dengan harga < 100.000
SELECT judul, pengarang, harga, stok
FROM buku
WHERE kategori = 'Programming'
  AND harga < 100000;

-- 2.2 Buku yang judulnya mengandung kata "PHP" atau "MySQL"
SELECT judul, pengarang, kategori, harga
FROM buku
WHERE judul LIKE '%PHP%'
   OR judul LIKE '%MySQL%';

-- 2.3 Buku yang terbit tahun 2024
SELECT judul, pengarang, tahun_terbit, harga
FROM buku
WHERE tahun_terbit = 2024;

-- 2.4 Buku yang stoknya antara 5-10
SELECT judul, pengarang, stok
FROM buku
WHERE stok BETWEEN 5 AND 10
ORDER BY stok ASC;

-- 2.5 Buku yang pengarangnya "Budi Raharjo"
SELECT judul, pengarang, kategori, harga, stok
FROM buku
WHERE pengarang = 'Budi Raharjo';


-- ============================================================
-- BAGIAN 3: GROUPING DAN AGREGASI
-- ============================================================

-- 3.1 Jumlah buku per kategori beserta total stok per kategori
SELECT 
    kategori,
    COUNT(*) AS jumlah_judul,
    SUM(stok) AS total_stok
FROM buku
GROUP BY kategori
ORDER BY jumlah_judul DESC;

-- 3.2 Rata-rata harga buku per kategori
SELECT 
    kategori,
    COUNT(*) AS jumlah_buku,
    ROUND(AVG(harga), 0) AS rata_rata_harga,
    FORMAT(AVG(harga), 0) AS rata_rata_harga_format
FROM buku
GROUP BY kategori
ORDER BY rata_rata_harga DESC;

-- 3.3 Kategori dengan total nilai inventaris terbesar
SELECT 
    kategori,
    SUM(harga * stok) AS total_nilai_inventaris,
    FORMAT(SUM(harga * stok), 0) AS total_nilai_format
FROM buku
GROUP BY kategori
ORDER BY total_nilai_inventaris DESC
LIMIT 1;


-- ============================================================
-- BAGIAN 4: UPDATE DATA
-- ============================================================

-- 4.1 Naikkan harga semua buku kategori Programming sebesar 5%
--     (Cek data sebelum update)
SELECT judul, harga AS harga_sebelum
FROM buku
WHERE kategori = 'Programming';

UPDATE buku
SET harga = ROUND(harga * 1.05, 0)
WHERE kategori = 'Programming';

--     (Cek data sesudah update)
SELECT judul, harga AS harga_sesudah
FROM buku
WHERE kategori = 'Programming';

-- 4.2 Tambah stok 10 untuk semua buku yang stoknya < 5
--     (Cek data sebelum update)
SELECT judul, stok AS stok_sebelum
FROM buku
WHERE stok < 5;

UPDATE buku
SET stok = stok + 10
WHERE stok < 5;

--     (Cek data sesudah update)
SELECT judul, stok AS stok_sesudah
FROM buku
WHERE stok < 15
ORDER BY stok ASC;


-- ============================================================
-- BAGIAN 5: LAPORAN KHUSUS
-- ============================================================

-- 5.1 Daftar buku yang perlu restocking (stok < 5)
SELECT 
    judul,
    pengarang,
    kategori,
    stok,
    'Perlu Restocking' AS status
FROM buku
WHERE stok < 5
ORDER BY stok ASC;

-- 5.2 Top 5 buku termahal
SELECT 
    ROW_NUMBER() OVER (ORDER BY harga DESC) AS peringkat,
    judul,
    pengarang,
    kategori,
    harga,
    FORMAT(harga, 0) AS harga_format
FROM buku
ORDER BY harga DESC
LIMIT 5;
