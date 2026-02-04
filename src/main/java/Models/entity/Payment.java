package Models.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class Payment {

    private int paymentId;
    private Integer contractId; // nullable
    private Integer billId;     // nullable

    private String method;      // BANK/CASH
    private BigDecimal amount;
    private Timestamp paidAt;

    private String status;      // PENDING/CONFIRMED/REJECTED
    private String note;

    public Payment() {
    }

    public Payment(int paymentId, Integer contractId, Integer billId, String method, BigDecimal amount,
            Timestamp paidAt, String status, String note) {
        this.paymentId = paymentId;
        this.contractId = contractId;
        this.billId = billId;
        this.method = method;
        this.amount = amount;
        this.paidAt = paidAt;
        this.status = status;
        this.note = note;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public Integer getContractId() {
        return contractId;
    }

    public void setContractId(Integer contractId) {
        this.contractId = contractId;
    }

    public Integer getBillId() {
        return billId;
    }

    public void setBillId(Integer billId) {
        this.billId = billId;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

}
