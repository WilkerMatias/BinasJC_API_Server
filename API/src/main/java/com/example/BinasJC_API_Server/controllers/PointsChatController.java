package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.PointsChatDTO;
import com.example.BinasJC_API_Server.models.PointsChat;
import com.example.BinasJC_API_Server.services.PointsChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/points-chat")
public class PointsChatController {

    @Autowired
    private PointsChatService pointsChatService;

    // Enviar pontos entre usuários
    @PostMapping("/send")
    public ResponseEntity<PointsChat> sendPoints(
            @RequestParam Long fromUserId,
            @RequestParam Long toUserId,
            @RequestParam int points
    ) {
        PointsChat pointsChat = pointsChatService.sendPoints(fromUserId, toUserId, points);
        return ResponseEntity.ok(pointsChat);
    }

    // Recuperar um registro específico de PointsChat
    @GetMapping("/{chatId}")
    public ResponseEntity<PointsChatDTO> getPointsChat(@PathVariable Long chatId) {
        PointsChatDTO pointsChat = pointsChatService.getPointsChat(chatId);
        return ResponseEntity.ok(pointsChat);
    }

    // Listar todos os registros enviados por um usuário
    @GetMapping("/sender/{fromUserId}")
    public ResponseEntity<List<PointsChatDTO>> getPointsChatsBySender(@PathVariable Long fromUserId) {
        List<PointsChatDTO> pointsChats = pointsChatService.getPointsChatsBySender(fromUserId);
        return ResponseEntity.ok(pointsChats);
    }

    // Listar todos os registros recebidos por um usuário
    @GetMapping("/receiver/{toUserId}")
    public ResponseEntity<List<PointsChatDTO>> getPointsChatsByReceiver(@PathVariable Long toUserId) {
        List<PointsChatDTO> pointsChats = pointsChatService.getPointsChatsByReceiver(toUserId);
        return ResponseEntity.ok(pointsChats);
    }

    // Deletar um registro de PointsChat
    @DeleteMapping("/{chatId}")
    public ResponseEntity<Void> deletePointsChat(@PathVariable Long chatId) {
        pointsChatService.deletePointsChat(chatId);
        return ResponseEntity.noContent().build();
    }
}
