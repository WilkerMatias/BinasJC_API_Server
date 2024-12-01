package com.example.BinasJC_API_Server.models;
import jakarta.persistence.*;
import java.util.List;
import java.util.*;

@Entity
public class Trajectory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    private Long fromStation;

    private Long toStation;

    private double distance;

    @Temporal(TemporalType.TIMESTAMP)
    private Date start;

    @Temporal(TemporalType.TIMESTAMP)
    private Date end;

    @ElementCollection
    private List<Coords> route;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
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

    public List<Coords> getRoute() {
        return route;
    }

    public void setRoute(List<Coords> route) {
        this.route = route;
    }
}
