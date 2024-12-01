package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.Bike;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BikeRepository extends JpaRepository<Bike, Long> {
}
