package Models;

/**
 * Author: Duong Thien Nhan - CE190741 Created on: 2026-01-12
 */
public class Manager {

    private int managerId;
    private int accountId;
    private int houseId;
    private String fullName;
    private String phone;

    public Manager() {
    }

    public Manager(int managerId, int accountId, int houseId, String fullName, String phone) {
        this.managerId = managerId;
        this.accountId = accountId;
        this.houseId = houseId;
        this.fullName = fullName;
        this.phone = phone;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getHouseId() {
        return houseId;
    }

    public void setHouseId(int houseId) {
        this.houseId = houseId;
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

}
