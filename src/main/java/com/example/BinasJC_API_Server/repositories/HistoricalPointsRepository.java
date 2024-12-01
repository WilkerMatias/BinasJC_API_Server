package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.HistoricalPoints;
import com.example.BinasJC_API_Server.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HistoricalPointsRepository extends JpaRepository<HistoricalPoints, Long> {

    List<HistoricalPoints> findByUser(User user);
}
