package Models;

import java.time.LocalDateTime;

public class AccountRole {

    private int accountId;
    private int roleId;
    private LocalDateTime grantedDate;
    private boolean isActive;

    public AccountRole() {
    }

    public AccountRole(int accountId, int roleId, LocalDateTime grantedDate, boolean isActive) {
        this.accountId = accountId;
        this.roleId = roleId;
        this.grantedDate = grantedDate;
        this.isActive = isActive;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public LocalDateTime getGrantedDate() {
        return grantedDate;
    }

    public void setGrantedDate(LocalDateTime grantedDate) {
        this.grantedDate = grantedDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

}
