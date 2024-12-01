package com.example.BinasJC_API_Server.dtos;

import java.util.Date;
import java.util.List;

public class TrajectoryDTO {
    private Long id;
    private Long user;
    private Long fromStation;
    private Long toStation;
    private double distance;
    private Date start;
    private Date end;
    private List<CoordsDTO> route;

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

    public Long getFromStation() {
        return fromStation;
    }

    public void setFromStation(Long fromStation) {
        this.fromStation = fromStation;
    }

    public Long getToStation() {
        return toStation;
    }

    public void setToStation(Long toStation) {
        this.toStation = toStation;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public List<CoordsDTO> getRoute() {
        return route;
    }

    public void setRoute(List<CoordsDTO> route) {
        this.route = route;
    }

}
