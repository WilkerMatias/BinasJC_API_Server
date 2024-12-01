package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.ReservationDTO;
import com.example.BinasJC_API_Server.models.*;
import com.example.BinasJC_API_Server.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StationRepository stationRepository;

    @Autowired
    private BikeRepository bikeRepository;

    // Criar nova reserva
    public ReservationDTO createReservation(Long userId, Long stationId, Long bikeId) {
        // Verificar se o usuário existe
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        // Verificar se a estação existe
        Station station = stationRepository.findById(stationId)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + stationId));

        // Verificar se a bicicleta existe
        Bike bike = bikeRepository.findById(bikeId)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + bikeId));

        // Verificar se a bicicleta já está reservada
        if (reservationRepository.existsByBikeAndStatus(bike, true)) {
            throw new IllegalArgumentException("Bike is already reserved.");
        }

        // Criar nova reserva
        Reservation reservation = new Reservation();
        reservation.setUser(user);
        reservation.setStation(station);
        reservation.setBike(bike);
        reservation.setDate(new Date());
        reservation.setStatus(true);

        // Salvar a reserva
        reservation = reservationRepository.save(reservation);

        return convertToDTO(reservation);
    }

    // Cancelar reserva
    public void cancelReservation(Long reservationId) {
        Reservation reservation = reservationRepository.findById(reservationId)
                .orElseThrow(() -> new IllegalArgumentException("Reservation not found with ID: " + reservationId));

        if (!reservation.isStatus()) {
            throw new IllegalArgumentException("Reservation is already canceled.");
        }

        reservation.setStatus(false);
        reservationRepository.save(reservation);
    }

    // Obter todas as reservas de um usuário
    public List<ReservationDTO> getReservationsByUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        List<Reservation> reservations = reservationRepository.findByUser(user);
        List<ReservationDTO> dtos = new ArrayList<>();
        for (Reservation reservation : reservations) {
            dtos.add(convertToDTO(reservation));
        }
        return dtos;
    }

    // Obter todas as reservas ativas
    public List<ReservationDTO> getActiveReservations() {
        List<Reservation> reservations = reservationRepository.findByStatus(true);
        List<ReservationDTO> dtos = new ArrayList<>();
        for (Reservation reservation : reservations) {
            dtos.add(convertToDTO(reservation));
        }
        return dtos;
    }

    // Converter Reservation para ReservationDTO
    private ReservationDTO convertToDTO(Reservation reservation) {
        ReservationDTO dto = new ReservationDTO();
        dto.setId(reservation.getId());
        dto.setUser(reservation.getUser().getId());
        dto.setStation(reservation.getStation().getId());
        dto.setBike(reservation.getBike().getId());
        dto.setDate(reservation.getDate());
        dto.setStatus(reservation.isStatus());
        return dto;
    }
}
