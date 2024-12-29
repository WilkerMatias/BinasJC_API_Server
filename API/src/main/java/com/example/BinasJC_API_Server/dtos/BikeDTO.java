package com.example.BinasJC_API_Server.dtos;

import com.example.BinasJC_API_Server.models.StatusBike;

public class BikeDTO {
    private Long id;
    private CoordsDTO actualLocation;
    private StatusBike status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public CoordsDTO getActualLocation() {
        return actualLocation;
    }

    public void setActualLocation(CoordsDTO actualLocation) {
        this.actualLocation = actualLocation;
    }

    public StatusBike getStatus() {
        return status;
    }

    public void setStatus(StatusBike status) {
        this.status = status;
    }
}
