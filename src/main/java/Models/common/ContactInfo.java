package Models.common;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-09
 */
public class ContactInfo {

    public String companyName;
    public String managerName;
    public String phone;
    public String email;
    public String address;
    public String workingHours;

    public ContactInfo() {
    }

    public ContactInfo(String companyName, String managerName, String phone, String email, String address,
            String workingHours) {
        this.companyName = companyName;
        this.managerName = managerName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.workingHours = workingHours;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getWorkingHours() {
        return workingHours;
    }

    public void setWorkingHours(String workingHours) {
        this.workingHours = workingHours;
    }

}
