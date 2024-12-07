package com.example.BinasJC_API_Server.dtos;

import java.util.Date;

public class ReservationDTO {
    private Long id;
    private Long user;
    private Long station;
    private Long bike;
    private Date date;
    private Date plannedDate; // Data planejada
    private boolean status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUser() {
        return user;
    }

    public void setUser(Long user) {
        this.user = user;
    }

    public Long getStation() {
        return station;
    }

    public void setStation(Long station) {
        this.station = station;
    }

    public Long getBike() {
        return bike;
    }

    public void setBike(Long bike) {
        this.bike = bike;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Date getPlannedDate() {
        return plannedDate;
    }

    public void setPlannedDate(Date plannedDate) {
        this.plannedDate = plannedDate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
