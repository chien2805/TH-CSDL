---LAB2---
-- 2.1 Hiển thị thông tin các bảng dữ liệu trên --
create view vw_ds1
as
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
select * from vw_ds1
-- 2.2Thông tin các sản phẩm sắp xếp theo chiều giảm dần giá bán--
create view vw_ds2
as
SELECT top 100 PERCENT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
ORDER BY Sanpham.giaban DESC;
select * from vw_ds2
-- 2.3.Thông tin các sản phẩm có trong cữa hàng do công ty có tên hãng là samsung sản xuất. --
create view vw_ds3
as
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung'
select * from vw_ds3
-- 2.4.Thông tin các nhân viên Nữ ở phòng ‘Kế toán’.--
create view vw_ds4
as
SELECT * FROM nhanvien
WHERE gioitinh = 'Nữ' AND phong = 'Kế toán'
select * from vw_ds4
-- 2.5.Thông tin phiếu nhập.Sắp xếp theo chiều tăng dần của hóa đơn nhập.--
create view vw_ds5
as
SELECT top 100 percent Nhap.sohdn, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.soluongN, Nhap.dongiaN, Nhap.soluongN*Nhap.dongiaN AS tiennhap, Sanpham.mausac, Sanpham.donvitinh, Nhap.ngaynhap, Nhanvien.tennv, Nhanvien.phong
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
ORDER BY Nhap.sohdn ASC;
select * from vw_ds5
--2.6.Thông tin phiếu xuất  trong tháng 10 năm 2018, sắp xếp theo chiều tăng dần của sohdx.
create view vw_ds6
as
SELECT top 100 percent Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, 
       Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, 
       Nhanvien.tennv, Nhanvien.phong
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE MONTH(Xuat.ngayxuat) = 10 AND YEAR(Xuat.ngayxuat) = 2018
ORDER BY Xuat.sohdx ASC;
select * from vw_ds6
-- 2.7. thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017
create view vw_ds7
as
SELECT sohdn, Sanpham.masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong
FROM Nhap 
JOIN Sanpham ON Nhap.masp = Sanpham.masp 
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2017;
select * from vw_ds7
--2.8. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018
create view vw_ds8
as
SELECT TOP 10 Xuat.sohdx, Sanpham.tensp, Xuat.soluongX
FROM Xuat 
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE YEAR(Xuat.ngayxuat) = '2023' 
ORDER BY Xuat.soluongX DESC;
select * from vw_ds8
--2.9. thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm dần gía bán.
create view vw_ds9
as
SELECT TOP 10 tenSP, giaBan
FROM SanPham
ORDER BY giaBan DESC;
select * from vw_ds9
--2.10. thông tin sản phẩm có gía bán từ 100.000 đến 500.000 của hãng samsung.
create view vw_ds10
as
SELECT top 100 percent Hangsx.tenhang, Sanpham.giaban,Sanpham.mahangsx
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND Sanpham.giaban >= 100000 AND Sanpham.giaban <= 500000
select * from vw_ds10
--2.11 Tính tổng tiền đã nhập trong năm 2018 của hãng samsung.
create view vw_ds11
as
SELECT SUM(soluongN * dongiaN) AS tongtien
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2018
select * from vw_ds11
--2.12 Thống kê tổng tiền đã xuất trong ngày 2/9/2018
create view vw_ds12
as
SELECT SUM(Xuat.soluongX * Sanpham.giaban) AS Tongtien
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE Xuat.ngayxuat = '2018-09-02'
select * from vw_ds12
--2.13 Đưa ra sohdn, ngaynhap có tiền nhập phải trả cao nhất trong năm 2018
create view vw_ds13
as
SELECT TOP 1 sohdn, ngaynhap, dongiaN
FROM Nhap
ORDER BY dongiaN DESC
select * from vw_ds13
--2.14 Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019.
create view vw_ds14
as
SELECT TOP 10 Sanpham.tensp, SUM(Nhap.soluongN) AS TongSoLuongN 
FROM Sanpham 
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp 
WHERE YEAR(Nhap.ngaynhap) = 2019 
GROUP BY Sanpham.tensp 
ORDER BY TongSoLuongN DESC
select * from vw_ds14
--2.15 Đưa ra masp,tensp của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
create view vw_ds15
as
SELECT Sanpham.masp, Sanpham.tensp
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp
INNER JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND Nhanvien.manv = 'NV01';
select * from vw_ds15
--2.16 Đưa ra sohdn,masp,soluongN,ngayN của mặt hàng có masp là ‘SP02’, được nhân viên ‘NV02’ xuất.
create view vw_ds16
as
SELECT sohdn, masp, soluongN, ngaynhap
FROM Nhap
WHERE masp = 'SP02' AND manv = 'NV02'
select * from vw_ds16
--2.17 Đưa ra manv,tennv đã xuất mặt hàng có mã ‘SP02’ ngày ’03-02-2020’.
create view vw_ds17
as
SELECT Nhanvien.manv, Nhanvien.tennv
FROM Nhanvien
JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Xuat.masp = 'SP02' AND Xuat.ngayxuat = '2020-03-02'
select * from vw_ds17

----LAB3-----
--1 Thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
create view vw_ds_18
as
SELECT top 100 percent Hangsx.tenhang, COUNT(Sanpham.masp) AS so_luong_sp
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
GROUP BY Hangsx.tenhang
ORDER BY so_luong_sp DESC;
select * from ds18
--2 Thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2018
create view vw_ds19
as
SELECT top 100 percent masp, SUM(soluongN * dongiaN) AS TongTienNhap
FROM Nhap
WHERE YEAR(ngaynhap) = 2020
GROUP BY masp;
select * from vw_ds19
--3 thống kê các sản phẩm có tổng số lượng xuất năm 2018 là lớn hơn 10.000 sản phẩm của hãng samsung.
create view vw_ds20
as
SELECT Sanpham.masp, Sanpham.tensp, SUM(Xuat.soluongX) AS tong_so_luong_xuat
FROM Sanpham JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE Sanpham.mahangsx = 'H01'
GROUP BY Sanpham.masp, Sanpham.tensp
HAVING SUM(Xuat.soluongX) > 1000
select * from vw_ds20
--4 Thống kê số lượng nhân viên Nam của mỗi phòng ban.
create view vw_ds21
as
SELECT phong, COUNT(*) as 'So_luong_nhan_vien_nam'
FROM Nhanvien
WHERE gioitinh = N'Nam'
GROUP BY phong;
select * from vw_ds21
--5 Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
create view vw_ds22
as
SELECT Hangsx.tenhang, SUM(Nhap.soluongN) AS tongnhap
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2020
GROUP BY Hangsx.tenhang
select * from vw_ds22
--6 Thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu
create view vw_ds23
as
SELECT Nhanvien.manv, Nhanvien.tennv, SUM(Xuat.soluongX * Sanpham.giaban) AS tongtienxuat
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE YEAR(Xuat.ngayxuat) = 2018
GROUP BY Nhanvien.manv, Nhanvien.tennv
select * from vw_ds23
--7 đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
create view vw_ds24
as
SELECT manv, SUM(soluongN * dongiaN) AS tong_tien_nhap
FROM Nhap
WHERE MONTH(ngaynhap) = 8 AND YEAR(ngaynhap) = 2018
GROUP BY manv
HAVING SUM(soluongN * dongiaN) > 100000;
select * from vw_ds24
--8 Đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
create view vw_ds25
as
SELECT *
FROM Sanpham
WHERE masp NOT IN (SELECT masp FROM Xuat)
select * from vw_ds25
--9 Đưa ra danh sách các sản phẩm đã nhập năm 2018 và đã xuất năm 2018.
create view vw_ds26
as
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.ngaynhap, Xuat.ngayxuat
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Nhap.ngaynhap) = 2018 AND YEAR(Xuat.ngayxuat) = 2018;
select * from vw_ds26
--10 Đưa ra danh sách các nhân viên vừa nhập vừa xuất.
create view vw_ds27
as
SELECT DISTINCT NV.manv, NV.tennv
FROM Nhap N 
JOIN Xuat X ON N.masp = X.masp AND N.manv = X.manv
JOIN Nhanvien NV ON N.manv = NV.manv;
select * from vw_ds27
--11 Đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
create view vw_ds28
as
SELECT top 100 percent Nhanvien.manv
FROM Nhanvien
LEFT JOIN Nhap ON Nhanvien.manv = Nhap.manv
LEFT JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Nhap.manv IS NULL AND Xuat.manv IS NULL;
select * from vw_ds28
