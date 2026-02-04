package Models.authentication;

import Models.entity.Staff;
import Models.entity.Tenant;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class AuthResult {

    private String role;     // GUEST / TENANT / MANAGER / ADMIN
    private Tenant tenant;   // null nếu không phải tenant
    private Staff staff;

    public AuthResult() {
    }

    public AuthResult(String role, Tenant tenant, Staff staff) {
        this.role = role;
        this.tenant = tenant;
        this.staff = staff;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Tenant getTenant() {
        return tenant;
    }

    public void setTenant(Tenant tenant) {
        this.tenant = tenant;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

}
