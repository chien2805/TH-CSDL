---1---
CREATE FUNCTION Cau1(@ten AS NVARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT sp.masp, sp.tensp, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota, hsx.tenhang
    FROM Sanpham sp
    INNER JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
    WHERE sp.tensp LIKE '%' + @ten + '%'

SELECT * FROM Cau1('f1 plus')
---2---
CREATE FUNCTION Cau2(@x DATE, @y DATE)
RETURNS TABLE
AS
RETURN 
    SELECT sp.masp, sp.tensp, hsx.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota
    FROM Nhap n
    JOIN Sanpham sp ON n.masp = sp.masp
    JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
    WHERE n.ngaynhap BETWEEN @x AND @y

SELECT * FROM Cau2('2018-01-01', '2023-01-01')

---3---
CREATE FUNCTION Cau3 (@hangsx nvarchar(50), @luachon int)
RETURNS TABLE
AS
RETURN
    SELECT sp.masp, sp.tensp, hsx.tenhang, sp.soluong, sp.giaban, sp.donvitinh, sp.mota
    FROM Sanpham sp
    JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
    WHERE hsx.tenhang = @hangsx AND ((@luachon = 0 AND sp.soluong = 0) OR (@luachon = 1 AND sp.soluong > 0))

SELECT * FROM Cau3('samsung', 1)

---4---

CREATE FUNCTION Cau4 (@tenphong NVARCHAR(50))
RETURNS @nhanvien TABLE (
    manv INT,
    tennv NVARCHAR(50),
    gioitinh NVARCHAR(10),
    diachi NVARCHAR(100),
    sodt NVARCHAR(20),
    email NVARCHAR(50),
    phong NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @nhanvien
    SELECT manv, tennv, gioitinh, diachi, sodt, email, phong
    FROM Nhanvien
    WHERE phong = @tenphong
    RETURN
END

SELECT * FROM Cau4(N'Kế toán')

---5---
CREATE FUNCTION Cau5 (@diaChi NVARCHAR(50))
RETURNS @hangSX TABLE (
    mahangsx INT,
    tenhang NVARCHAR(50),
    diachi NVARCHAR(50),
    sodt NVARCHAR(20),
    email NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @hangSX
    SELECT mahangsx, tenhang, diachi, sodt, email
    FROM Hangsx
    WHERE diachi LIKE '%' + @diaChi + '%'

    RETURN
END

SELECT * FROM Cau5(N'TPHCM')

---Cau6
CREATE FUNCTION Cau6 (@namX INT, @namY INT)
RETURNS @sanPhamHangSX TABLE (
    masp NVARCHAR(50),
    tensp NVARCHAR(50),
    tenhang NVARCHAR(50),
    ngayxuat DATE,
    soluongX INT
)
AS
BEGIN
    INSERT INTO @sanPhamHangSX
    SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.ngayxuat, Xuat.soluongX
    FROM Sanpham
    JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
    JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Xuat.ngayxuat) BETWEEN @namX AND @namY

    RETURN
END

SELECT * FROM Cau6(2020,2023)

---7---
CREATE FUNCTION Cau7(@mahangsx NVARCHAR,@luaChon INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        sp.masp, 
        sp.tensp, 
        sp.soluong, 
        sp.giaban, 
        sp.donvitinh, 
        sp.mota
    FROM 
        Sanpham sp
        JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
        LEFT JOIN Nhap n ON sp.masp = n.masp
        LEFT JOIN Xuat x ON sp.masp = x.masp
    WHERE 
        hs.mahangsx = @mahangsx 
        AND (@luaChon = 0 AND n.masp IS NOT NULL OR @luaChon = 1 AND x.masp IS NOT NULL)
)
SELECT * FROM Cau7('H01','1')
---8---
CREATE FUNCTION Cau8(@ngayNhap DATE)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        nv.manv, 
        nv.tennv, 
        nv.gioitinh, 
        nv.diachi, 
        nv.sodt, 
        nv.email, 
        nv.phong
    FROM 
        Nhanvien nv 
        JOIN Nhap n ON nv.manv = n.manv
    WHERE 
        n.ngaynhap = @ngayNhap
)

SELECT * FROM Cau8('2019-02-05')
---9---
CREATE FUNCTION Cau9
(
    @minPrice FLOAT,
    @maxPrice FLOAT,
    @manufacturer VARCHAR(50)
)
RETURNS @products TABLE
(
    masp VARCHAR(10),
    mahangsx VARCHAR(10),
    tensp NVARCHAR(50),
    soluong INT,
    mausac NVARCHAR(50),
    giaban FLOAT,
    donvitinh NVARCHAR(20),
    mota NVARCHAR(MAX)
)
AS
BEGIN
    INSERT INTO @products
    SELECT s.masp, s.mahangsx, s.tensp, s.soluong, s.mausac, s.giaban, s.donvitinh, s.mota
    FROM Sanpham s
    INNER JOIN Hangsx h ON s.mahangsx = h.mahangsx
    WHERE s.giaban >= @minPrice AND s.giaban <= @maxPrice AND h.tenhang = @manufacturer
    RETURN
END

---10---
CREATE FUNCTION Cau10
(
)
RETURNS TABLE
AS
RETURN
(
    SELECT sp.Masp, sp.Tensp, sp.Mausac, sp.Giaban, sp.Donvitinh, sp.Mota, hs.Tenhang
    FROM Sanpham sp
    INNER JOIN Hangsx hs ON sp.Mahangsx = hs.Mahangsx
)

SELECT * FROM Cau10()