package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.Trajectory;
import com.example.BinasJC_API_Server.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;

public interface TrajectoryRepository extends JpaRepository<Trajectory, Long> {
    // Lista trajetórias de um usuário específico
    List<Trajectory> findByUser(User user);

    // Lista trajetórias entre duas estações específicas
    List<Trajectory> findByFromStationAndToStation(Long fromStation, Long toStation);

    // Lista trajetórias iniciadas em um intervalo de tempo
    List<Trajectory> findByStartBetween(Date start, Date end);

}
