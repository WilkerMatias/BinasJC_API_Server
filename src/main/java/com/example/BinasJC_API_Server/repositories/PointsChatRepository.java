package com.example.BinasJC_API_Server.repositories;

import com.example.BinasJC_API_Server.models.PointsChat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Arrays;
import java.util.List;

public interface PointsChatRepository extends JpaRepository<PointsChat, Long> {
    List<PointsChat> findByFromUser(Long fromUserId);
    List<PointsChat> findByToUser(Long toUserId);
}
