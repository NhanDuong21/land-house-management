package Models.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Contract {

    private int contractId;
    private int roomId;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal deposit;
    private BigDecimal monthlyRent;
    private Integer startWaterIndex;
    private Integer startElectricityIndex;
    private byte status; // 0 1 2             
    private String note;

    public Contract() {
    }

    public Contract(int contractId, int roomId, LocalDate startDate, LocalDate endDate, BigDecimal deposit,
            BigDecimal monthlyRent, Integer startWaterIndex, Integer startElectricityIndex, byte status, String note) {
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

    public Integer getStartWaterIndex() {
        return startWaterIndex;
    }

    public void setStartWaterIndex(Integer startWaterIndex) {
        this.startWaterIndex = startWaterIndex;
    }

    public Integer getStartElectricityIndex() {
        return startElectricityIndex;
    }

    public void setStartElectricityIndex(Integer startElectricityIndex) {
        this.startElectricityIndex = startElectricityIndex;
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

}
