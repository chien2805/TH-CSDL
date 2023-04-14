1--A--
INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES 
('NV04', N'Nguyen Van A', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Kế Tóan')


BACKUP DATABASE QLBanHang TO DISK = 'C:\backup\QLBH.bak' 

--B--
INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES 
('NV05', N'Nguyen Van A', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Văn Phòng')

BACKUP DATABASE QLBanHang TO DISK = 'C:\backup\QLBH_diff.bak' with differential

--C--
INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES 
('NV06', N'Nguyen Van A', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Tài Chính')

BACKUP DATABASE QLBanHang TO DISK = 'C:\backup\QLBH_log1.trn' 

--D--

INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES 
('NV07', N'Nguyen Van B', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', N'Tài Chính')

BACKUP DATABASE QLBanHang TO DISK = 'C:\backup\QLBH_log1.trn' 


--2--
--a--
drop database QLBanHang
--b--
restore database QLBanHang from disk ='C:\backup\QLBH.bak' 
WITH STANDBY = 'C:\backup\QLBH_undoFile.undo';

