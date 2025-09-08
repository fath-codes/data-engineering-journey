-- Masalah 1 - Urutkan berdasarkan gaji tertinggi dan diberi nomor
--SELECT nama, departemen, gaji, id_karyawan, ROW_NUMBER() OVER(ORDER BY gaji DESC) AS urutan_ranking  FROM karyawan 

-- Masalah 2 - Urutkan berdasarkan gaji setiap departemen, jika ada gaji sama peringkat sama dan peringkat berikutnya melompat
-- SELECT nama, departemen, gaji, id_karyawan, RANK() OVER(PARTITION BY departemen ORDER BY gaji DESC) AS urutang_ranking FROM karyawan 

-- Masalah 3 - Sama seperti masalah 2 namun peringkat tidak boleh melompat
-- SELECT nama, departemen, gaji, id_karyawan, DENSE_RANK () OVER(PARTITION BY departemen ORDER BY gaji DESC) AS urutan_ranking FROM karyawan

-- Masalah 4 - "Manajemen ingin memberikan bonus kepada karyawan dengan gaji tertinggi kedua di setiap departemen. Tampilkan nama, departemen, dan gaji dari orang-orang tersebut."
SELECT nama, departemen, gaji 
FROM (
	SELECT 
		nama, 
		departemen, 
		gaji, 
		DENSE_RANK() OVER (PARTITION BY departemen ORDER BY gaji DESC) AS urutan_ranking
	FROM 
		karyawan
) AS tabel_peringkat
WHERE
	urutan_ranking = 2;