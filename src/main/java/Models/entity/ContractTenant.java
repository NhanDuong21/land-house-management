package Models.entity;

import java.time.LocalDate;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-16
 */
public class ContractTenant {

    private int recordId;
    private int contractId;
    private int tenantId;
    private LocalDate moveInDate;
    private LocalDate moveOutDate;
    private String note;

    public ContractTenant() {
    }

    public ContractTenant(int recordId, int contractId, int tenantId, LocalDate moveInDate, LocalDate moveOutDate,
            String note) {
        this.recordId = recordId;
        this.contractId = contractId;
        this.tenantId = tenantId;
        this.moveInDate = moveInDate;
        this.moveOutDate = moveOutDate;
        this.note = note;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

}
