package Models;

public class Admin {

    private int adminId;
    private int accountId;

    public Admin() {
    }

    public Admin(int adminId, int accountId) {
        this.adminId = adminId;
        this.accountId = accountId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}
