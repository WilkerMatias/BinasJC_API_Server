package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.Gift;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GiftRepository extends JpaRepository<Gift, Long> {
}
