package Services.staff;

import java.sql.Date;

import DALs.auth.StaffDAO;
import DALs.auth.TenantDAO;
import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import Models.entity.Staff;
import Models.entity.Tenant;
import Utils.security.HashUtil;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-26
 */
public class StaffService {

    private final StaffDAO staffDAO = new StaffDAO();
    private final TenantDAO tenantDAO = new TenantDAO();

    // MANAGER: only phone + email
    public ServiceResult updateManagerContact(int staffId, String phoneRaw, String emailRaw) {
        Staff s = staffDAO.findById(staffId);
        if (s == null) {
            return ServiceResult.fail("NOT_FOUND");
        }

        String phone = normalizePhone(phoneRaw);
        if (phone.isBlank()) {
            return ServiceResult.fail("PHONE_REQUIRED");
        }
        if (!phone.matches("^0\\d{9,10}$")) {
            return ServiceResult.fail("PHONE_FORMAT");
        }

        String email = normalizeEmail(emailRaw);
        if (email.isBlank()) {
            return ServiceResult.fail("EMAIL_REQUIRED");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return ServiceResult.fail("EMAIL_FORMAT");
        }

        boolean changed = !phone.equals(nvl(s.getPhoneNumber())) || !email.equalsIgnoreCase(nvl(s.getEmail()));
        if (!changed) {
            return ServiceResult.ok("OK");
        }

        if (staffDAO.existsPhoneExceptStaff(staffId, phone)) {
            return ServiceResult.fail("PHONE_EXISTS");
        }
        if (staffDAO.existsEmailExceptStaff(staffId, email)) {
            return ServiceResult.fail("EMAIL_EXISTS");
        }

        boolean ok = staffDAO.updateContactForStaff(staffId, phone, email);
        return ok ? ServiceResult.ok("OK") : ServiceResult.fail("UPDATE_FAILED");
    }

    // ADMIN: full info
    public ServiceResult updateAdminProfile(int staffId, String fullNameRaw, String phoneRaw, String emailRaw, String identityRaw, String dobRaw, String genderRaw) {

        Staff s = staffDAO.findById(staffId);
        if (s == null) {
            return ServiceResult.fail("NOT_FOUND");
        }

        String fullName = (fullNameRaw == null) ? "" : fullNameRaw.trim();
        if (fullName.isBlank()) {
            return ServiceResult.fail("FULLNAME_REQUIRED");
        }
        if (fullName.length() > 120) {
            return ServiceResult.fail("FULLNAME_LENGTH");
        }

        String phone = normalizePhone(phoneRaw);
        if (phone.isBlank()) {
            return ServiceResult.fail("PHONE_REQUIRED");
        }
        if (!phone.matches("^0\\d{9,10}$")) {
            return ServiceResult.fail("PHONE_FORMAT");
        }

        String email = normalizeEmail(emailRaw);
        if (email.isBlank()) {
            return ServiceResult.fail("EMAIL_REQUIRED");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return ServiceResult.fail("EMAIL_FORMAT");
        }

        String identity = (identityRaw == null) ? "" : identityRaw.trim();
        if (!identity.isBlank() && identity.length() > 20) {
            return ServiceResult.fail("IDENTITY_LENGTH");
        }

        Date dob = null;
        if (dobRaw != null && !dobRaw.trim().isBlank()) {
            try {
                dob = Date.valueOf(dobRaw.trim()); // yyyy-mm-dd
            } catch (Exception e) {
                return ServiceResult.fail("DOB_FORMAT");
            }
        }

        Integer gender = null;
        if (genderRaw != null && !genderRaw.trim().isBlank()) {
            if (!genderRaw.trim().matches("^[01]$")) {
                return ServiceResult.fail("GENDER_FORMAT");
            }
            gender = Integer.valueOf(genderRaw.trim());
        }

        // unique checks
        if (staffDAO.existsPhoneExceptStaff(staffId, phone)) {
            return ServiceResult.fail("PHONE_EXISTS");
        }
        if (staffDAO.existsEmailExceptStaff(staffId, email)) {
            return ServiceResult.fail("EMAIL_EXISTS");
        }

        boolean ok = staffDAO.updateProfileForAdmin(staffId, fullName, phone, email, identity, dob, gender);
        return ok ? ServiceResult.ok("OK") : ServiceResult.fail("UPDATE_FAILED");
    }

    private static String normalizePhone(String raw) {
        String s = (raw == null) ? "" : raw.trim();
        return s.replaceAll("[\\s.]", "");
    }

    private static String normalizeEmail(String raw) {
        return (raw == null) ? "" : raw.trim();
    }

    private static String nvl(String s) {
        return (s == null) ? "" : s;
    }

    private boolean isAdmin(AuthResult auth) {
        return auth != null && auth.getStaff() != null && "ADMIN".equalsIgnoreCase(auth.getRole()) && "ACTIVE".equalsIgnoreCase(auth.getStaff().getStatus());
    }

    public ServiceResult adminResetPassword(AuthResult auth, String targetType, int targetId,
            String newPassword, String confirmPassword) {

        if (!isAdmin(auth)) {
            return ServiceResult.fail("You do not have permission to perform this function.");
        }

        if (newPassword == null || confirmPassword == null
                || newPassword.isBlank() || confirmPassword.isBlank()) {
            return ServiceResult.fail("Please enter full password.");
        }

        if (!newPassword.equals(confirmPassword)) {
            return ServiceResult.fail("The verification password doesn't match.");
        }

        if (newPassword.length() < 6) {
            return ServiceResult.fail("Password must be at least 6 characters long.");
        }

        String newHash = HashUtil.md5(newPassword);

        if ("TENANT".equalsIgnoreCase(targetType)) {
            Tenant tenant = tenantDAO.findById(targetId);
            if (tenant == null) {
                return ServiceResult.fail("Tenant does not exist.");
            }

            boolean ok = tenantDAO.adminResetPasswordForTenant(targetId, newHash);
            return ok ? ServiceResult.ok("Password reset for TENANT was successful.") : ServiceResult.fail("Password reset for TENANT failed.");
        }

        if ("MANAGER".equalsIgnoreCase(targetType)) {
            Staff staff = staffDAO.findById(targetId);

            if (staff == null || !"MANAGER".equalsIgnoreCase(staff.getStaffRole())) {
                return ServiceResult.fail("Manager does not exist.");
            }

            boolean ok = staffDAO.updatePasswordForStaff(targetId, newHash);
            return ok ? ServiceResult.ok("Password reset for MANAGER was successful.") : ServiceResult.fail("Password reset for MANAGER failed.");
        }

        return ServiceResult.fail("Invalid account type.");
    }
}
