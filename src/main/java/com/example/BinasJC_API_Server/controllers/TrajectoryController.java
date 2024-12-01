package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.TrajectoryDTO;
import com.example.BinasJC_API_Server.dtos.CoordsDTO;
import com.example.BinasJC_API_Server.models.Trajectory;
import com.example.BinasJC_API_Server.services.TrajectoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trajectories")
public class TrajectoryController {

    @Autowired
    private TrajectoryService trajectoryService;

    // Criar nova trajetória com coordenada inicial
    @PostMapping("/create")
    public ResponseEntity<Trajectory> createTrajectory(
            @RequestParam Long userId,
            @RequestParam Long fromStation,
            @RequestBody CoordsDTO initialCoords
    ) {
        Trajectory trajectory = trajectoryService.createTrajectory(userId, fromStation, initialCoords);
        return ResponseEntity.ok(trajectory);
    }

    // Adicionar coordenada à trajetória existente
    @PutMapping("/{trajectoryId}/add-coords")
    public ResponseEntity<Trajectory> addCoordsToTrajectory(
            @PathVariable Long trajectoryId,
            @RequestBody CoordsDTO newCoords
    ) {
        Trajectory trajectory = trajectoryService.addCoordsToTrajectory(trajectoryId, newCoords);
        return ResponseEntity.ok(trajectory);
    }

    // Finalizar trajetória
    @PutMapping("/{trajectoryId}/end")
    public ResponseEntity<Trajectory> endTrajectory(
            @PathVariable Long trajectoryId,
            @RequestParam Long toStation
    ) {
        Trajectory trajectory = trajectoryService.endTrajectory(trajectoryId, toStation);
        return ResponseEntity.ok(trajectory);
    }

    // Listar trajetórias por usuário
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<TrajectoryDTO>> getTrajectoriesByUser(@PathVariable Long userId) {
        List<TrajectoryDTO> trajectories = trajectoryService.getTrajectoriesByUser(userId);
        return ResponseEntity.ok(trajectories);
    }
}
