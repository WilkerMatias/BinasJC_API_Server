package com.example.BinasJC_API_Server.dtos;

import com.example.BinasJC_API_Server.models.Type;

public class HistoricalPointsDTO {
    private Long user;
    private Long process; // gift, trajectory, etc
    private Type type;
    private int points;
    private boolean used;

    public Long getUser() {
        return user;
    }

    public void setUser(Long user) {
        this.user = user;
    }

    public Long getProcess() {
        return process;
    }

    public void setProcess(Long process) {
        this.process = process;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }
}
