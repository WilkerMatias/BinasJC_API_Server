package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.ReservationDTO;
import com.example.BinasJC_API_Server.services.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    // Criar nova reserva
    @PostMapping("/create")
    public ResponseEntity<ReservationDTO> createReservation(
            @RequestParam Long userId,
            @RequestParam Long stationId,
            @RequestParam Long bikeId
    ) {
        ReservationDTO reservation = reservationService.createReservation(userId, stationId, bikeId);
        return ResponseEntity.ok(reservation);
    }

    // Cancelar reserva
    @PutMapping("/{reservationId}/cancel")
    public ResponseEntity<Void> cancelReservation(@PathVariable Long reservationId) {
        reservationService.cancelReservation(reservationId);
        return ResponseEntity.noContent().build();
    }

    // Obter todas as reservas de um usuário
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ReservationDTO>> getReservationsByUser(@PathVariable Long userId) {
        List<ReservationDTO> reservations = reservationService.getReservationsByUser(userId);
        return ResponseEntity.ok(reservations);
    }

    // Obter todas as reservas ativas
    @GetMapping("/active")
    public ResponseEntity<List<ReservationDTO>> getActiveReservations() {
        List<ReservationDTO> reservations = reservationService.getActiveReservations();
        return ResponseEntity.ok(reservations);
    }
}
