/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services.staff;

import DALs.auth.TenantDAO;
import Models.entity.Tenant;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class TenantService {

    private TenantDAO TenantDAO = new TenantDAO();

    public List<Tenant> getAllTenants() {
        return TenantDAO.getAllTenants();
    }

    public List<Tenant> searchTenant(String keyword) {
        return TenantDAO.searchTenant(keyword);
    }

    public Tenant findById(int id) {
        return TenantDAO.findById(id);
    }

    public boolean updateTenant(Tenant t) {
        validateTenant(t);
        return TenantDAO.updateTenant(t);
    }
    // ===== VALIDATION =====

    private void validateTenant(Tenant t) {

        // 1. Full Name
        String fullName = t.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full Name không được để trống.");
        }
        if (!fullName.matches("^[\\p{L}\\s]+$")) {
            throw new IllegalArgumentException("Full Name chỉ được chứa chữ cái.");
        }

        // 2. Identity Code
        String identityCode = t.getIdentityCode();
        if (identityCode == null || identityCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Citizen ID không được để trống.");
        }
        if (!identityCode.matches("^\\d{12}$")) {
            throw new IllegalArgumentException("Citizen ID phải đúng 12 chữ số.");
        }

        // 3. Phone Number
        String phone = t.getPhoneNumber();
        if (phone == null || phone.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone Number không được để trống.");
        }

// Không cho nhập chữ
        if (!phone.matches("^\\d+$")) {
            throw new IllegalArgumentException("Phone Number không được chứa chữ hoặc ký tự đặc biệt.");
        }

// Phải đủ 10 số và bắt đầu bằng 0
        if (!phone.matches("^0\\d{9}$")) {
            throw new IllegalArgumentException("Phone Number phải có 10 số và bắt đầu bằng 0.");
        }

        // 4. Date of Birth
        if (t.getDateOfBirth() == null) {
            throw new IllegalArgumentException("Date of Birth không được để trống.");
        }

        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        if (t.getDateOfBirth().after(today)) {
            throw new IllegalArgumentException("Date of Birth không được lớn hơn ngày hiện tại.");
        }
    }
}
