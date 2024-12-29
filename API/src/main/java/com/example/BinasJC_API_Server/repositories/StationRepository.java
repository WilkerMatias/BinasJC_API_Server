package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.Station;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StationRepository extends JpaRepository<Station, Long> {
}
