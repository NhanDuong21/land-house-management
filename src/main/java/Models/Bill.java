package Models;

import java.sql.Date;

public class Bill {

    private int billId;
    private int contractId;
    private Date billMonth;
    private Date dueDate;
    private double totalAmount;
    private String paymentStatus;

    public Bill() {
    }

    public Bill(int billId, int contractId, Date billMonth,
            Date dueDate, double totalAmount, String paymentStatus) {
        this.billId = billId;
        this.contractId = contractId;
        this.billMonth = billMonth;
        this.dueDate = dueDate;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public Date getBillMonth() {
        return billMonth;
    }

    public void setBillMonth(Date billMonth) {
        this.billMonth = billMonth;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}
