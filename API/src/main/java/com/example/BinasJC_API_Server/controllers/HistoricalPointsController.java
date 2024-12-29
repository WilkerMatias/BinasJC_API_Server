package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.HistoricalPointsDTO;
import com.example.BinasJC_API_Server.models.HistoricalPoints;
import com.example.BinasJC_API_Server.models.Type;
import com.example.BinasJC_API_Server.services.HistoricalPointsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/historical-points")
public class HistoricalPointsController {

    @Autowired
    private HistoricalPointsService historicalPointsService;

    // Listar todos os registros
    @GetMapping
    public ResponseEntity<List<HistoricalPointsDTO>> getAllHistoricalPoints() {
        List<HistoricalPointsDTO> historicalPoints = historicalPointsService.getAllHistoricalPoints();
        return ResponseEntity.ok(historicalPoints);
    }

    // Buscar registros por usuário
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<HistoricalPointsDTO>> getHistoricalPointsByUser(@PathVariable Long userId) {
        List<HistoricalPointsDTO> historicalPoints = historicalPointsService.getHistoricalPointsByUser(userId);
        return ResponseEntity.ok(historicalPoints);
    }

    // Criar um novo registro
    @PostMapping
    public ResponseEntity<HistoricalPoints> createHistoricalPoint(
            @RequestParam Long userId,
            @RequestParam Long processId,
            @RequestParam Type type,
            @RequestParam int points
    ) {
        HistoricalPoints historicalPoint = historicalPointsService.createHistoricalPoint(userId, processId, type, points);
        return ResponseEntity.ok(historicalPoint);
    }

    // Atualizar o status de uso de um registro
    @PatchMapping("/{id}")
    public ResponseEntity<HistoricalPoints> updateUsedStatus(
            @PathVariable Long id,
            @RequestParam boolean used
    ) {
        HistoricalPoints updatedHistoricalPoint = historicalPointsService.updateUsedStatus(id, used);
        return ResponseEntity.ok(updatedHistoricalPoint);
    }

    // Deletar um registro
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteHistoricalPoint(@PathVariable Long id) {
        historicalPointsService.deleteHistoricalPoint(id);
        return ResponseEntity.noContent().build();
    }
}
