package com.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;

import com.laptopshop.entities.DonHang;
import com.laptopshop.entities.NguoiDung;

public interface DonHangRepository extends JpaRepository<DonHang, Long>, QuerydslPredicateExecutor<DonHang> {

	public List<DonHang> findByTrangThaiDonHangAndShipper(String trangThai, NguoiDung shipper);

	@Query(value = "select DATE_FORMAT(dh.ngayNhanHang, '%m') as month, "
			+ " DATE_FORMAT(dh.ngayNhanHang, '%Y') as year, sum(ct.soLuongNhanHang * ct.donGia) as total "
			+ " from DonHang dh, ChiTietDonHang ct"
			+ " where dh.id = ct.donHang.id and dh.trangThaiDonHang ='Hoàn thành'"
			+ " group by DATE_FORMAT(dh.ngayNhanHang, '%Y%m')"
			+ " order by year asc" )
	public List<Object> layDonHangTheoThangVaNam();
	@Query(value = "select ct.sanPham.tenSanPham, sum(ct.soLuongNhanHang) as total " +
			" from DonHang dh, ChiTietDonHang ct"
			+ " where dh.id = ct.donHang.id and dh.trangThaiDonHang = 'Hoàn thành'"
			+ " group by ct.sanPham"
			+ " order by total desc")
	public List<Object> thongKeDonHangTheoThang();
	@Query(value = "SELECT sp.tenSanPham, SUM(sp.donViKho) AS soLuongConLai " +
            "FROM SanPham sp " +
            "INNER JOIN ChiTietDonHang ctdh ON sp.id = ctdh.sanPham.id " +
            "INNER JOIN DonHang dh ON ctdh.donHang.id = dh.id " +
            "WHERE dh.trangThaiDonHang = 'Hoàn thành' " +
            "GROUP BY sp.tenSanPham " +
            "ORDER BY soLuongConLai DESC")
	public List<Object> thongKeSoLuongConLaiCuaSanPhamTrongKho();
	@Query("SELECT sp FROM SanPham sp WHERE sp.donViKho = 0")
	public List<Object> thongKeHetHang();
	
	public List<DonHang> findByNguoiDat(NguoiDung ng);
	
	public int countByTrangThaiDonHang(String trangThaiDonHang);
	
}
