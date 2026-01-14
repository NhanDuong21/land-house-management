package Models;

import java.time.LocalDate;

public class UserProfile {

    private Integer profileId;
    private int accountId; // unique FK
    private String fullName;
    private String identityCode;
    private String phoneNumber; // nullable
    private String address;     // nullable
    private LocalDate dateOfBirth; // nullable
    private Integer gender; // nullable, 0..3
    private String avatar;  // nullable

    public UserProfile() {
    }

    public UserProfile(Integer profileId, int accountId, String fullName, String identityCode, String phoneNumber,
            String address, LocalDate dateOfBirth, Integer gender, String avatar) {
        this.profileId = profileId;
        this.accountId = accountId;
        this.fullName = fullName;
        this.identityCode = identityCode;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.avatar = avatar;
    }

    public Integer getProfileId() {
        return profileId;
    }

    public void setProfileId(Integer profileId) {
        this.profileId = profileId;
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

    public String getIdentityCode() {
        return identityCode;
    }

    public void setIdentityCode(String identityCode) {
        this.identityCode = identityCode;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

}
