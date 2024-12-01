package com.example.BinasJC_API_Server.dtos;

import java.util.Date;

public class GiftEarnedDTO {
    private long gift;
    private String name;
    private Date date;
    private boolean used;

    public long getGift() {
        return gift;
    }

    public void setGift(long gift) {
        this.gift = gift;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }
}
