package Models;

import java.time.LocalDate;

public class Bill {

    private int billId;
    private int roomId;
    private int billMonth; // yyyymm
    private LocalDate dueDate;
    private LocalDate paymentDate; // nullable
    private byte status;           // 0..3
    private String note;           // nullable

    private Integer oldWaterNumber;    // nullable
    private Integer newWaterNumber;    // nullable
    private Integer oldElectricNumber; // nullable
    private Integer newElectricNumber; // nullable

    public Bill() {
    }

    public Bill(int billId, int roomId, int billMonth, LocalDate dueDate, LocalDate paymentDate, byte status,
            String note, Integer oldWaterNumber, Integer newWaterNumber, Integer oldElectricNumber,
            Integer newElectricNumber) {
        this.billId = billId;
        this.roomId = roomId;
        this.billMonth = billMonth;
        this.dueDate = dueDate;
        this.paymentDate = paymentDate;
        this.status = status;
        this.note = note;
        this.oldWaterNumber = oldWaterNumber;
        this.newWaterNumber = newWaterNumber;
        this.oldElectricNumber = oldElectricNumber;
        this.newElectricNumber = newElectricNumber;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
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

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Integer getOldWaterNumber() {
        return oldWaterNumber;
    }

    public void setOldWaterNumber(Integer oldWaterNumber) {
        this.oldWaterNumber = oldWaterNumber;
    }

    public Integer getNewWaterNumber() {
        return newWaterNumber;
    }

    public void setNewWaterNumber(Integer newWaterNumber) {
        this.newWaterNumber = newWaterNumber;
    }

    public Integer getOldElectricNumber() {
        return oldElectricNumber;
    }

    public void setOldElectricNumber(Integer oldElectricNumber) {
        this.oldElectricNumber = oldElectricNumber;
    }

    public Integer getNewElectricNumber() {
        return newElectricNumber;
    }

    public void setNewElectricNumber(Integer newElectricNumber) {
        this.newElectricNumber = newElectricNumber;
    }

}
