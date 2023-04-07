---lab7
--cau 1--
CREATE PROCEDURE sp_InsertHangsx
    @mahangsx NCHAR(10),
    @tenhang NVARCHAR(20),
    @diachi NVARCHAR(30),
    @sodt NVARCHAR(20),
    @email NVARCHAR(30)
AS
BEGIN
    -- Kiểm tra xem tenhang đã tồn tại trong bảng chưa
    IF EXISTS (SELECT 1 FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        RAISERROR('Tên hãng sản xuất đã tồn tại trong bảng', 16, 1)
        RETURN
    END
    
    -- Nếu tenhang chưa tồn tại, thực hiện thêm dữ liệu vào bảng
    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)
END

EXEC sp_InsertHangsx @mahangsx = 'H04', @tenhang = 'Apple', @diachi = 'USA', @sodt = '1234567890', @email = 'apple@gmail.com'

--cau2--
CREATE PROCEDURE sp_InsertOrUpdateSanPham 
    @masp nvarchar(50), 
    @mahangsx nvarchar(50),
    @tensp nvarchar(50),
    @soluong int,
    @mausac nvarchar(50),
    @giaban decimal(18,2),
    @donvitinh nvarchar(50),
    @mota nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem masp đã tồn tại trong bảng hay chưa
    IF EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        -- Nếu tồn tại rồi thì cập nhật thông tin sản phẩm
        UPDATE sanpham 
        SET 
            mahangsx = @mahangsx,
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE 
            masp = @masp
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại thì thêm mới sản phẩm vào bảng
        INSERT INTO sanpham 
            (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES 
            (@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
END

EXEC sp_InsertOrUpdateSanPham @masp = 123, @mahangsx = 'H01', @tensp = 'Galaxy S21', @soluong = 50, @mausac = 'Đen', @giaban = 20000000, @donvitinh = 'Chiếc', @mota = 'Điện thoại cao cấp'

--cau3--
CREATE PROCEDURE delete_hangsx
  @tenhang nvarchar(50)
AS
BEGIN
  -- Kiểm tra nếu tên hãng chưa có thì thông báo
  IF NOT EXISTS (SELECT * FROM hangsx WHERE tenhang = @tenhang)
  BEGIN
    PRINT 'Không tìm thấy hãng sản xuất ' + @tenhang
    RETURN
  END
  
  -- Xóa các sản phẩm của hãng
  DELETE FROM sanpham WHERE mahangsx = @tenhang
  
  -- Xóa hãng sản xuất
  DELETE FROM hangsx WHERE tenhang = @tenhang
  
  PRINT 'Đã xóa hãng sản xuất ' + @tenhang + ' và ' + CAST(@@ROWCOUNT AS nvarchar) + ' sản phẩm liên quan.'
END

---cau4---
CREATE PROCEDURE NhapDuLieuNhanVien 
   @manv NVARCHAR(50), 
   @tennv NVARCHAR(50), 
   @gioitinh NVARCHAR(10), 
   @diachi NVARCHAR(100), 
   @sodt NVARCHAR(20), 
   @email NVARCHAR(50), 
   @phong NVARCHAR(50),
   @Flag BIT
AS
BEGIN
   SET NOCOUNT ON;

   IF @Flag = 0 -- Nếu Flag = 0 thì cập nhật dữ liệu
   BEGIN
      UPDATE NhanVien
      SET Tennv = @tennv, 
          GioiTinh = @gioitinh, 
          DiaChi = @diachi, 
          SoDT = @sodt, 
          Email = @email, 
          Phong = @phong
      WHERE Manv = @manv
   END
   ELSE -- Ngược lại thêm mới nhân viên
   BEGIN
      INSERT INTO NhanVien (Manv, Tennv, GioiTinh, DiaChi, SoDT, Email, Phong)
      VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
   END
END

-- Thêm mới nhân viên
EXEC NhapDuLieuNhanVien 'NV001', 'Nguyen Van A', 'Nam', '123 Nguyen Hue', '0901234567', 'a@abc.com', 'Phong Ke Toan', 1

-- Cập nhật thông tin nhân viên
EXEC NhapDuLieuNhanVien 'NV001', 'Nguyen Van B', 'Nam', '123 Nguyen Hue', '0901234567', 'b@abc.com', 'Phong Ke Toan', 0

---cau5---
CREATE PROCEDURE sp_ThemNhap
    @sohdn NVARCHAR(50),
    @masp NVARCHAR(50),
    @manv NVARCHAR(50),
    @ngaynhap DATE,
    @soluongN INT,
    @dongiaN FLOAT
AS
BEGIN
    -- Kiểm tra sản phẩm tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong bảng Sanpham'
        RETURN
    END
    
    -- Kiểm tra nhân viên tồn tại trong bảng nhanvien hay không
    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Nhân viên không tồn tại trong bảng nhanvien'
        RETURN
    END
    
    -- Kiểm tra số lượng nhập và đơn giá nhập có hợp lệ hay không
    IF (@soluongN <= 0 OR @dongiaN <= 0)
    BEGIN
        PRINT 'Số lượng nhập hoặc đơn giá nhập không hợp lệ'
        RETURN
    END
    
    -- Thêm dữ liệu vào bảng Nhap
    INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
    VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    
    PRINT 'Thêm dữ liệu thành công'
END

EXEC sp_ThemNhap @sohdn = 'HD001', @masp = 'SP001', @manv = 'NV001', @ngaynhap = '2023-04-07', @soluongN = 10, @dongiaN = 50000;

--cau6---
CREATE PROCEDURE spNhapXuat
    @sohdx varchar(10),
    @masp varchar(10),
    @manv varchar(10),
    @ngayxuat date,
    @soluongX int
AS
BEGIN
    -- Kiểm tra mã sản phẩm có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại trong bảng Sanpham.'
        RETURN
    END

    -- Kiểm tra mã nhân viên có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng Nhanvien.'
        RETURN
    END

    -- Kiểm tra số lượng xuất có lớn hơn số lượng tồn kho không
    IF @soluongX > (SELECT soluong FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Số lượng xuất vượt quá số lượng tồn kho.'
        RETURN
    END

    -- Kiểm tra nếu số hóa đơn xuất đã tồn tại thì cập nhật bảng Xuat, ngược lại thêm mới bảng Xuat
    IF EXISTS (SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        INSERT INTO Xuat (sohdx, masp, manv, ngayxuat, soluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
END


---cau7---
CREATE PROCEDURE sp_XoaNhanVien (@manv NVARCHAR(50))
AS
BEGIN
    -- kiểm tra xem manv đã tồn tại trong bảng nhanvien hay chưa
    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Không tồn tại nhân viên với mã ' + @manv
        RETURN
    END
    
    -- xóa các bản ghi trong bảng Nhap và Xuat mà nhân viên này tham gia
    DELETE FROM Nhap WHERE manv = @manv
    DELETE FROM Xuat WHERE manv = @manv
    
    -- xóa bản ghi nhân viên với mã manv
    DELETE FROM nhanvien WHERE manv = @manv
    
    PRINT 'Đã xóa nhân viên với mã ' + @manv
END

EXEC sp_XoaNhanVien 'NV001'

---cau8---
CREATE PROCEDURE sp_DeleteSanPham
    @masp INT
AS
BEGIN
    -- Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không?
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT N'Mã sản phẩm không tồn tại trong bảng Sanpham.'
        RETURN
    END
    
    BEGIN TRY
        BEGIN TRANSACTION
            -- Xóa các bản ghi trong bảng Nhap mà sanpham này cung ứng
            DELETE FROM Nhap WHERE masp = @masp

            -- Xóa các bản ghi trong bảng Xuat mà sanpham này cung ứng
            DELETE FROM Xuat WHERE masp = @masp

            -- Xóa bản ghi trong bảng Sanpham
            DELETE FROM Sanpham WHERE masp = @masp

            PRINT N'Đã xóa sản phẩm có mã là ' + CAST(@masp AS NVARCHAR(MAX))
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT N'Lỗi khi xóa sản phẩm'
    END CATCH
END

EXEC sp_DeleteSanPham @masp = 123

