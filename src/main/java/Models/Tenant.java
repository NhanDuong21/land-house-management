package Models;

/**
 * Author: Duong Thien Nhan - CE190741 Created on: 2026-01-12  
 */
public class Tenant {

    private int tenantId;
    private int accountId;
    private String fullName;
    private String phone;
    private String identityCode;

    public Tenant() {
    }

    public Tenant(int tenantId, int accountId, String fullName, String phone, String identityCode) {
        this.tenantId = tenantId;
        this.accountId = accountId;
        this.fullName = fullName;
        this.phone = phone;
        this.identityCode = identityCode;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getIdentityCode() {
        return identityCode;
    }

    public void setIdentityCode(String identityCode) {
        this.identityCode = identityCode;
    }

}
