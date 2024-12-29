package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.GiftEarned;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface GiftEarnedRepository extends JpaRepository<GiftEarned, Long> {
    List<GiftEarned> findByUserId(Long userId);
}
