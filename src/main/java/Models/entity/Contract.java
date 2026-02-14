package Models.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class Contract {

    private int contractId;
    private int roomId;
    private int tenantId;
    private int createdByStaffId;

    private Date startDate;
    private Date endDate; // nullable

    private BigDecimal monthlyRent;
    private BigDecimal deposit;
    private String paymentQrData;

    private String status; // PENDING/ACTIVE/ENDED/CANCELLED
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // list join room
    private String roomNumber;
    private String blockName;
    private String tenantName;

    // Room
    private Integer floor;
    private BigDecimal area;
    private Integer maxTenants;
    private Boolean isMezzanine;
    private Boolean hasAirConditioning;
    private String roomDescription;

    // Party A (Landlord) = ADMIN
    private String landlordFullName;
    private String landlordPhoneNumber;
    private String landlordEmail;
    private String landlordIdentityCode;
    private Date landlordDateOfBirth;

    // Party B (Tenant)
    private String tenantEmail;
    private String tenantPhoneNumber;
    private String tenantIdentityCode;
    private Date tenantDateOfBirth;
    private String tenantAddress;

    public Contract() {
    }

    public Contract(int contractId, int roomId, int tenantId, int createdByStaffId, Date startDate, Date endDate,
            BigDecimal monthlyRent, BigDecimal deposit, String paymentQrData, String status, Timestamp createdAt,
            Timestamp updatedAt, String roomNumber, String blockName, String tenantName, Integer floor, BigDecimal area,
            Integer maxTenants, Boolean isMezzanine, Boolean hasAirConditioning, String roomDescription,
            String landlordFullName, String landlordPhoneNumber, String landlordEmail, String landlordIdentityCode,
            Date landlordDateOfBirth, String tenantEmail, String tenantPhoneNumber, String tenantIdentityCode,
            Date tenantDateOfBirth, String tenantAddress) {
        this.contractId = contractId;
        this.roomId = roomId;
        this.tenantId = tenantId;
        this.createdByStaffId = createdByStaffId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.monthlyRent = monthlyRent;
        this.deposit = deposit;
        this.paymentQrData = paymentQrData;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.roomNumber = roomNumber;
        this.blockName = blockName;
        this.tenantName = tenantName;
        this.floor = floor;
        this.area = area;
        this.maxTenants = maxTenants;
        this.isMezzanine = isMezzanine;
        this.hasAirConditioning = hasAirConditioning;
        this.roomDescription = roomDescription;
        this.landlordFullName = landlordFullName;
        this.landlordPhoneNumber = landlordPhoneNumber;
        this.landlordEmail = landlordEmail;
        this.landlordIdentityCode = landlordIdentityCode;
        this.landlordDateOfBirth = landlordDateOfBirth;
        this.tenantEmail = tenantEmail;
        this.tenantPhoneNumber = tenantPhoneNumber;
        this.tenantIdentityCode = tenantIdentityCode;
        this.tenantDateOfBirth = tenantDateOfBirth;
        this.tenantAddress = tenantAddress;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public int getCreatedByStaffId() {
        return createdByStaffId;
    }

    public void setCreatedByStaffId(int createdByStaffId) {
        this.createdByStaffId = createdByStaffId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getMonthlyRent() {
        return monthlyRent;
    }

    public void setMonthlyRent(BigDecimal monthlyRent) {
        this.monthlyRent = monthlyRent;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public String getPaymentQrData() {
        return paymentQrData;
    }

    public void setPaymentQrData(String paymentQrData) {
        this.paymentQrData = paymentQrData;
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

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getBlockName() {
        return blockName;
    }

    public void setBlockName(String blockName) {
        this.blockName = blockName;
    }

    public String getTenantName() {
        return tenantName;
    }

    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }

    public Integer getFloor() {
        return floor;
    }

    public void setFloor(Integer floor) {
        this.floor = floor;
    }

    public BigDecimal getArea() {
        return area;
    }

    public void setArea(BigDecimal area) {
        this.area = area;
    }

    public Integer getMaxTenants() {
        return maxTenants;
    }

    public void setMaxTenants(Integer maxTenants) {
        this.maxTenants = maxTenants;
    }

    public Boolean getIsMezzanine() {
        return isMezzanine;
    }

    public void setIsMezzanine(Boolean isMezzanine) {
        this.isMezzanine = isMezzanine;
    }

    public Boolean getHasAirConditioning() {
        return hasAirConditioning;
    }

    public void setHasAirConditioning(Boolean hasAirConditioning) {
        this.hasAirConditioning = hasAirConditioning;
    }

    public String getRoomDescription() {
        return roomDescription;
    }

    public void setRoomDescription(String roomDescription) {
        this.roomDescription = roomDescription;
    }

    public String getLandlordFullName() {
        return landlordFullName;
    }

    public void setLandlordFullName(String landlordFullName) {
        this.landlordFullName = landlordFullName;
    }

    public String getLandlordPhoneNumber() {
        return landlordPhoneNumber;
    }

    public void setLandlordPhoneNumber(String landlordPhoneNumber) {
        this.landlordPhoneNumber = landlordPhoneNumber;
    }

    public String getLandlordEmail() {
        return landlordEmail;
    }

    public void setLandlordEmail(String landlordEmail) {
        this.landlordEmail = landlordEmail;
    }

    public String getLandlordIdentityCode() {
        return landlordIdentityCode;
    }

    public void setLandlordIdentityCode(String landlordIdentityCode) {
        this.landlordIdentityCode = landlordIdentityCode;
    }

    public Date getLandlordDateOfBirth() {
        return landlordDateOfBirth;
    }

    public void setLandlordDateOfBirth(Date landlordDateOfBirth) {
        this.landlordDateOfBirth = landlordDateOfBirth;
    }

    public String getTenantEmail() {
        return tenantEmail;
    }

    public void setTenantEmail(String tenantEmail) {
        this.tenantEmail = tenantEmail;
    }

    public String getTenantPhoneNumber() {
        return tenantPhoneNumber;
    }

    public void setTenantPhoneNumber(String tenantPhoneNumber) {
        this.tenantPhoneNumber = tenantPhoneNumber;
    }

    public String getTenantIdentityCode() {
        return tenantIdentityCode;
    }

    public void setTenantIdentityCode(String tenantIdentityCode) {
        this.tenantIdentityCode = tenantIdentityCode;
    }

    public Date getTenantDateOfBirth() {
        return tenantDateOfBirth;
    }

    public void setTenantDateOfBirth(Date tenantDateOfBirth) {
        this.tenantDateOfBirth = tenantDateOfBirth;
    }

    public String getTenantAddress() {
        return tenantAddress;
    }

    public void setTenantAddress(String tenantAddress) {
        this.tenantAddress = tenantAddress;
    }

}
