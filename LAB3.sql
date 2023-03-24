--1 Thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
SELECT Hangsx.tenhang, COUNT(Sanpham.masp) AS so_luong_sp
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
GROUP BY Hangsx.tenhang
ORDER BY so_luong_sp DESC;
--2 Thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2018
SELECT masp, SUM(soluongN * dongiaN) AS TongTienNhap
FROM Nhap
WHERE YEAR(ngaynhap) = 2020
GROUP BY masp;
--3 thống kê các sản phẩm có tổng số lượng xuất năm 2018 là lớn hơn 10.000 sản phẩm của hãng samsung.
SELECT Sanpham.masp, Sanpham.tensp, SUM(Xuat.soluongX) AS tong_so_luong_xuat
FROM Sanpham JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE Sanpham.mahangsx = 'H01'
GROUP BY Sanpham.masp, Sanpham.tensp
HAVING SUM(Xuat.soluongX) > 1000
--4 Thống kê số lượng nhân viên Nam của mỗi phòng ban.
SELECT phong, COUNT(*) as 'So_luong_nhan_vien_nam'
FROM Nhanvien
WHERE gioitinh = N'Nam'
GROUP BY phong;
--5 Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
SELECT Hangsx.tenhang, SUM(Nhap.soluongN) AS tongnhap
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2020
GROUP BY Hangsx.tenhang
--6 Thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu
SELECT Nhanvien.manv, Nhanvien.tennv, SUM(Xuat.soluongX * Sanpham.giaban) AS tongtienxuat
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE YEAR(Xuat.ngayxuat) = 2018
GROUP BY Nhanvien.manv, Nhanvien.tennv
--7 đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
SELECT manv, SUM(soluongN * dongiaN) AS tong_tien_nhap
FROM Nhap
WHERE MONTH(ngaynhap) = 8 AND YEAR(ngaynhap) = 2018
GROUP BY manv
HAVING SUM(soluongN * dongiaN) > 100000;
--8 Đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
SELECT *
FROM Sanpham
WHERE masp NOT IN (SELECT masp FROM Xuat)
--9 Đưa ra danh sách các sản phẩm đã nhập năm 2018 và đã xuất năm 2018.
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.ngaynhap, Xuat.ngayxuat
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Nhap.ngaynhap) = 2018 AND YEAR(Xuat.ngayxuat) = 2018;
--10 Đưa ra danh sách các nhân viên vừa nhập vừa xuất.
SELECT DISTINCT NV.manv, NV.tennv
FROM Nhap N 
JOIN Xuat X ON N.masp = X.masp AND N.manv = X.manv
JOIN Nhanvien NV ON N.manv = NV.manv;
--11 Đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
SELECT *
FROM Nhanvien
LEFT JOIN Nhap ON Nhanvien.manv = Nhap.manv
LEFT JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Nhap.manv IS NULL AND Xuat.manv IS NULL;