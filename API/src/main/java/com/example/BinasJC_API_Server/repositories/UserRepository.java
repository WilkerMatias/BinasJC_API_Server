package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.models.Bike;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
    User findByEmail(String email);
    User findByBike(Bike bike);
}