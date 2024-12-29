package com.example.BinasJC_API_Server.dtos;

public class StationDTO {
    private Long id;
    private String name;
    private CoordsDTO location;
    private int bikes;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public CoordsDTO getLocation() {
        return location;
    }

    public void setLocation(CoordsDTO location) {
        this.location = location;
    }

    public int getBikes() {
        return bikes;
    }

    public void setBikes(int bikes) {
        this.bikes = bikes;
    }
}
