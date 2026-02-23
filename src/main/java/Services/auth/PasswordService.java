package Services.auth;

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
 * @since 2026-02-24
 */
public class PasswordService {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    public ServiceResult changePassword(AuthResult auth,
            String oldPassword,
            String newPassword,
            String confirmPassword) {

        if (auth == null) {
            return ServiceResult.fail("AUTH_REQUIRED");
        }

        oldPassword = nvl(oldPassword).trim();
        newPassword = nvl(newPassword).trim();
        confirmPassword = nvl(confirmPassword).trim();

        // ===== Validate new password =====
        if (newPassword.isEmpty() || confirmPassword.isEmpty()) {
            return ServiceResult.fail("PWD_REQUIRED");
        }

        if (newPassword.length() < 6 || newPassword.length() > 64) {
            return ServiceResult.fail("PWD_LENGTH");
        }

        if (!newPassword.equals(confirmPassword)) {
            return ServiceResult.fail("PWD_CONFIRM_MISMATCH");
        }

        // ===== TENANT =====
        if (auth.getTenant() != null) {

            Tenant sessionTenant = auth.getTenant();
            int tenantId = sessionTenant.getTenantId();

            String currentHash = tenantDAO.getPasswordHashById(tenantId);
            boolean mustCheckOld = (currentHash != null && !currentHash.isBlank());

            // Nếu tenant đã có password -> phải check old
            if (mustCheckOld) {
                if (oldPassword.isEmpty()) {
                    return ServiceResult.fail("OLD_REQUIRED");
                }

                String oldHash = HashUtil.md5(oldPassword);
                if (!oldHash.equalsIgnoreCase(currentHash)) {
                    return ServiceResult.fail("OLD_INCORRECT");
                }
            }

            String newHash = HashUtil.md5(newPassword);
            boolean updated = tenantDAO.updatePasswordForTenant(tenantId, newHash);

            if (!updated) {
                return ServiceResult.fail("UPDATE_FAILED");
            }

            // Update session object
            sessionTenant.setPasswordHash(newHash);
            sessionTenant.setMustSetPassword(false);
            auth.setTenant(sessionTenant);

            return ServiceResult.ok("SUCCESS");
        }

        // ===== STAFF =====
        if (auth.getStaff() != null) {

            Staff sessionStaff = auth.getStaff();
            int staffId = sessionStaff.getStaffId();

            String currentHash = staffDAO.getPasswordHashById(staffId);

            if (currentHash == null || currentHash.isBlank()) {
                return ServiceResult.fail("NO_CURRENT_PASSWORD");
            }

            if (oldPassword.isEmpty()) {
                return ServiceResult.fail("OLD_REQUIRED");
            }

            String oldHash = HashUtil.md5(oldPassword);
            if (!oldHash.equalsIgnoreCase(currentHash)) {
                return ServiceResult.fail("OLD_INCORRECT");
            }

            String newHash = HashUtil.md5(newPassword);
            boolean updated = staffDAO.updatePasswordForStaff(staffId, newHash);

            if (!updated) {
                return ServiceResult.fail("UPDATE_FAILED");
            }

            sessionStaff.setPasswordHash(newHash);
            auth.setStaff(sessionStaff);

            return ServiceResult.ok("SUCCESS");
        }

        return ServiceResult.fail("AUTH_INVALID");
    }

    private static String nvl(String s) {
        return (s == null) ? "" : s;
    }
}
