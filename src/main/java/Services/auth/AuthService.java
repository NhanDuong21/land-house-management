package Services.auth;

import DALs.auth.StaffDAO;
import DALs.auth.TenantDAO;
import Models.authentication.AuthResult;
import Models.entity.Staff;
import Models.entity.Tenant;
import Utils.security.HashUtil;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class AuthService {

    private final StaffDAO staffDAO = new StaffDAO();
    private final TenantDAO tenantDAO = new TenantDAO();

    public AuthResult login(String email, String rawPass) {
        if (email == null || rawPass == null) {
            return null;
        }
        //check staff
        Staff staff = staffDAO.findByEmail(email.trim());
        if (staff != null) {
            if (!"ACTIVE".equalsIgnoreCase(staff.getStatus())) {
                return null;
            }
            if (staff.getPasswordHash() == null) {
                return null;
            }
            if (!HashUtil.md5(rawPass).equalsIgnoreCase(staff.getPasswordHash())) {
                return null;
            }
            String role = staff.getStaffRole();
            return new AuthResult(role, null, staff);
        }

        //check tenant
        Tenant tenant = tenantDAO.findByEmail(email.trim());
        if (tenant == null) {
            return null;
        }

        if (tenant.getPasswordHash() == null) {
            return null;
        }
        if (!"ACTIVE".equalsIgnoreCase(tenant.getAccountStatus())) {
            return null;
        }

        if (!HashUtil.md5(rawPass).equalsIgnoreCase(tenant.getPasswordHash())) {
            return null;
        }
        return new AuthResult("TENANT", tenant, null);
    }
}
