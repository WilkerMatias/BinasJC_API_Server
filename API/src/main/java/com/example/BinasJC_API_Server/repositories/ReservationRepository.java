package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.Bike;
import com.example.BinasJC_API_Server.models.Reservation;
import com.example.BinasJC_API_Server.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {

    // Verifica se existe uma reserva ativa para uma determinada bicicleta
    boolean existsByBikeAndStatus(Bike bike, boolean status);

    // Retorna todas as reservas de um usuário específico
    List<Reservation> findByUser(User user);

    // Retorna todas as reservas com um status específico
    List<Reservation> findByStatus(boolean status);

}
