package Models;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Staff {

    private int staffId;
    private String username;
    private String passwordHash;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String identityCode;
    private byte staffRole;       // 1=admin, 2=manager
    private byte status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt; // nullable
    private String avatar;        // nullable
    private Byte gender;          // nullable
    private LocalDate dateOfBirth; // nullable
    private Integer houseId;      // nullable (staff phụ trách house)

    public Staff() {
    }

    public Staff(int staffId, String username, String passwordHash, String fullName, String phoneNumber, String email,
            String identityCode, byte staffRole, byte status, LocalDateTime createdAt, LocalDateTime updatedAt,
            String avatar, Byte gender, LocalDate dateOfBirth, Integer houseId) {
        this.staffId = staffId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.identityCode = identityCode;
        this.staffRole = staffRole;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.avatar = avatar;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.houseId = houseId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getIdentityCode() {
        return identityCode;
    }

    public void setIdentityCode(String identityCode) {
        this.identityCode = identityCode;
    }

    public byte getStaffRole() {
        return staffRole;
    }

    public void setStaffRole(byte staffRole) {
        this.staffRole = staffRole;
    }

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Byte getGender() {
        return gender;
    }

    public void setGender(Byte gender) {
        this.gender = gender;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Integer getHouseId() {
        return houseId;
    }

    public void setHouseId(Integer houseId) {
        this.houseId = houseId;
    }

}
