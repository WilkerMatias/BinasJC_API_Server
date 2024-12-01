package com.example.BinasJC_API_Server.dtos;

import java.util.List;

public class UserDTO {
    private Long id;
    private String username;
    private String email;
    private String bi;
    private int points;
    private BikeDTO bike;
    private List<GiftEarnedDTO> gifts;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBi() {
        return bi;
    }

    public void setBi(String bi) {
        this.bi = bi;
    }

    public int getPoints() {
        return points;
    }

    public void updatePoints(int pointsChange) {
        if (this.points + pointsChange < 0) {
            throw new IllegalStateException("Insufficient points. User's points cannot be negative.");
        }
        this.points += pointsChange;    }

    public BikeDTO getBike() {
        return bike;
    }

    public void setBike(BikeDTO bike) {
        this.bike = bike;
    }

    public List<GiftEarnedDTO> getGifts() {
        return gifts;
    }

    public void setGifts(List<GiftEarnedDTO> gifts) {
        this.gifts = gifts;
    }
}
