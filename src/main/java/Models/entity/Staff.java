package Models.entity;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class Staff {

    private int staffId;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String identityCode;
    private Date dateOfBirth;
    private Integer gender; // 0/1 or null

    private String staffRole;     // MANAGER/ADMIN
    private String passwordHash;  // MD5
    private String avatar;

    private String status;        // ACTIVE/INACTIVE
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Staff() {
    }

    public Staff(int staffId, String fullName, String phoneNumber, String email, String identityCode, Date dateOfBirth,
            Integer gender, String staffRole, String passwordHash, String avatar, String status, Timestamp createdAt,
            Timestamp updatedAt) {
        this.staffId = staffId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.identityCode = identityCode;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.staffRole = staffRole;
        this.passwordHash = passwordHash;
        this.avatar = avatar;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
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

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public String getStaffRole() {
        return staffRole;
    }

    public void setStaffRole(String staffRole) {
        this.staffRole = staffRole;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}
