package com.example.BinasJC_API_Server.models;

import jakarta.persistence.*;

@Entity
public class Bike {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Embedded
    private Coords location;

    @Enumerated(EnumType.STRING)
    private StatusBike status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Coords getLocation() {
        return location;
    }

    public void setLocation(Coords location) {
        this.location = location;
    }

    public StatusBike getStatus() {
        return status;
    }

    public void setStatus(StatusBike status) {
        this.status = status;
    }
}
