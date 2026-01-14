package Models;

import java.time.LocalDate;

public class Bill {

    private Integer billId;
    private int roomId;
    private int billMonth; // yyyymm
    private LocalDate dueDate;
    private LocalDate paymentDate; // nullable
    private long totalAmount;
    private int status; // 0..3
    private String note; // nullable

    public Bill() {
    }

    public Bill(Integer billId, int roomId, int billMonth, LocalDate dueDate, LocalDate paymentDate, long totalAmount,
            int status, String note) {
        this.billId = billId;
        this.roomId = roomId;
        this.billMonth = billMonth;
        this.dueDate = dueDate;
        this.paymentDate = paymentDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.note = note;
    }

    public Integer getBillId() {
        return billId;
    }

    public void setBillId(Integer billId) {
        this.billId = billId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getBillMonth() {
        return billMonth;
    }

    public void setBillMonth(int billMonth) {
        this.billMonth = billMonth;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public LocalDate getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDate paymentDate) {
        this.paymentDate = paymentDate;
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

}
