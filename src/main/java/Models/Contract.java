package Models;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Contract {

    private Integer contractId;
    private int roomId;
    private LocalDate startDate;
    private LocalDate endDate; // nullable
    private BigDecimal deposit;
    private BigDecimal monthlyRent;
    private int startWaterIndex;
    private int startElectricityIndex;
    private int status; // 0..3
    private String note;

    public Contract() {
    }

    public Contract(Integer contractId, int roomId, LocalDate startDate, LocalDate endDate, BigDecimal deposit,
            BigDecimal monthlyRent, int startWaterIndex, int startElectricityIndex, int status, String note) {
        this.contractId = contractId;
        this.roomId = roomId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.deposit = deposit;
        this.monthlyRent = monthlyRent;
        this.startWaterIndex = startWaterIndex;
        this.startElectricityIndex = startElectricityIndex;
        this.status = status;
        this.note = note;
    }

    public Integer getContractId() {
        return contractId;
    }

    public void setContractId(Integer contractId) {
        this.contractId = contractId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public BigDecimal getMonthlyRent() {
        return monthlyRent;
    }

    public void setMonthlyRent(BigDecimal monthlyRent) {
        this.monthlyRent = monthlyRent;
    }

    public int getStartWaterIndex() {
        return startWaterIndex;
    }

    public void setStartWaterIndex(int startWaterIndex) {
        this.startWaterIndex = startWaterIndex;
    }

    public int getStartElectricityIndex() {
        return startElectricityIndex;
    }

    public void setStartElectricityIndex(int startElectricityIndex) {
        this.startElectricityIndex = startElectricityIndex;
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
