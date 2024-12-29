package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.BikeDTO;
import com.example.BinasJC_API_Server.models.Bike;
import com.example.BinasJC_API_Server.models.Coords;
import com.example.BinasJC_API_Server.models.StatusBike;
import com.example.BinasJC_API_Server.services.BikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bikes")
public class BikeController {

    @Autowired
    private BikeService bikeService;

    // Listar todas as bikes
    @GetMapping
    public ResponseEntity<List<BikeDTO>> getAllBikes() {
        List<BikeDTO> bikes = bikeService.getAllBikes();
        return ResponseEntity.ok(bikes);
    }

    // Buscar bike por ID
    @GetMapping("/{id}")
    public ResponseEntity<BikeDTO> getBikeById(@PathVariable Long id) {
        BikeDTO bike = bikeService.getBikeById(id);
        return ResponseEntity.ok(bike);
    }

    // Criar nova bike
    @PostMapping
    public ResponseEntity<Bike> createBike(@RequestBody Coords location) {
        Bike bike = bikeService.createBike(location);
        return ResponseEntity.ok(bike);
    }

    // Atualizar localização da bike
    @PatchMapping("/{id}/location")
    public ResponseEntity<Bike> updateBikeCoords(
            @PathVariable Long id,
            @RequestBody Coords newLocation
    ) {
        Bike updatedBike = bikeService.updateBikeCoords(id, newLocation);
        return ResponseEntity.ok(updatedBike);
    }

    // Atualizar status da bike
    @PatchMapping("/{id}/status")
    public ResponseEntity<Bike> updateBikeStatus(
            @PathVariable Long id,
            @RequestParam StatusBike newStatus
    ) {
        Bike updatedBike = bikeService.updateBikeStatus(id, newStatus);
        return ResponseEntity.ok(updatedBike);
    }

    // Deletar bike
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBike(@PathVariable Long id) {
        bikeService.deleteBike(id);
        return ResponseEntity.noContent().build();
    }
}
