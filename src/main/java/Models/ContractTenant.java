package Models;

import java.time.LocalDate;

public class ContractTenant {

    private Integer recordId;
    private int contractId;
    private int profileId;
    private LocalDate moveInDate;
    private LocalDate moveOutDate; // nullable
    private int tenantRole; // 1=Leader, 2=Member

    public ContractTenant() {
    }

    public ContractTenant(Integer recordId, int contractId, int profileId, LocalDate moveInDate, LocalDate moveOutDate,
            int tenantRole) {
        this.recordId = recordId;
        this.contractId = contractId;
        this.profileId = profileId;
        this.moveInDate = moveInDate;
        this.moveOutDate = moveOutDate;
        this.tenantRole = tenantRole;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public LocalDate getMoveInDate() {
        return moveInDate;
    }

    public void setMoveInDate(LocalDate moveInDate) {
        this.moveInDate = moveInDate;
    }

    public LocalDate getMoveOutDate() {
        return moveOutDate;
    }

    public void setMoveOutDate(LocalDate moveOutDate) {
        this.moveOutDate = moveOutDate;
    }

    public int getTenantRole() {
        return tenantRole;
    }

    public void setTenantRole(int tenantRole) {
        this.tenantRole = tenantRole;
    }

}
