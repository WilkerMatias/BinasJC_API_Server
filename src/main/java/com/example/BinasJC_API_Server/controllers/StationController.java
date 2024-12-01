package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.StationDTO;
import com.example.BinasJC_API_Server.models.Coords;
import com.example.BinasJC_API_Server.models.Station;
import com.example.BinasJC_API_Server.services.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stations")
public class StationController {

    @Autowired
    private StationService stationService;

    // Listar todas as estações
    @GetMapping
    public ResponseEntity<List<StationDTO>> getAllStations() {
        List<StationDTO> stations = stationService.getAllStations();
        return ResponseEntity.ok(stations);
    }

    // Buscar estação por ID
    @GetMapping("/{id}")
    public ResponseEntity<StationDTO> getStationById(@PathVariable Long id) {
        StationDTO station = stationService.getStationById(id);
        return ResponseEntity.ok(station);
    }

    // Criar nova estação
    @PostMapping("/create")
    public ResponseEntity<Station> createStation(
            @RequestParam String name,
            @RequestBody Coords location
    ) {
        Station station = stationService.createStation(name, location);
        return ResponseEntity.ok(station);
    }

    // Atualizar nome da estação
    @PutMapping("/{id}/update-name")
    public ResponseEntity<Station> updateStationName(
            @PathVariable Long id,
            @RequestParam String newName
    ) {
        Station station = stationService.updateStationName(id, newName);
        return ResponseEntity.ok(station);
    }

    // Atualizar localização da estação
    @PutMapping("/{id}/update-location")
    public ResponseEntity<Station> updateStationLocation(
            @PathVariable Long id,
            @RequestBody Coords newLocation
    ) {
        Station station = stationService.updateStationLocation(id, newLocation);
        return ResponseEntity.ok(station);
    }

    // Adicionar bike à estação
    @PutMapping("/{stationId}/add-bike/{bikeId}")
    public ResponseEntity<Station> addBikeToStation(
            @PathVariable Long stationId,
            @PathVariable Long bikeId
    ) {
        Station station = stationService.addBikeToStation(stationId, bikeId);
        return ResponseEntity.ok(station);
    }

    // Remover bike da estação
    @PutMapping("/{stationId}/remove-bike/{bikeId}")
    public ResponseEntity<Station> removeBikeFromStation(
            @PathVariable Long stationId,
            @PathVariable Long bikeId
    ) {
        Station station = stationService.removeBikeFromStation(stationId, bikeId);
        return ResponseEntity.ok(station);
    }

    // Deletar estação
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStation(@PathVariable Long id) {
        stationService.deleteStation(id);
        return ResponseEntity.noContent().build();
    }
}
