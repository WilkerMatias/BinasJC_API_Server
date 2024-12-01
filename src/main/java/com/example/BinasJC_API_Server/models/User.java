package com.example.BinasJC_API_Server.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String email;

    @Column(unique = true, nullable = false)
    private String bi;

    private String password;

    private int points;

    @OneToOne
    private Bike bike; //Agora será um Long para referenciar a bike associada

    @OneToMany(mappedBy = "user")
    private List<GiftEarned> gifts;

    private boolean active;

    private boolean deleted;

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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getPoints() {
        return points;
    }

    public void updatePoints(int pointsChange) {
        if (this.points + pointsChange < 0) {
            throw new IllegalStateException("Insufficient points. User's points cannot be negative.");
        }
        this.points += pointsChange;    }

    public Bike getBike() {
        return bike;
    }

    public void setBike(Bike bike) {
        this.bike = bike;
    }

    public List<GiftEarned> getGifts() {
        return gifts;
    }

    public void setGifts(List<GiftEarned> gifts) {
        this.gifts = gifts;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }


}