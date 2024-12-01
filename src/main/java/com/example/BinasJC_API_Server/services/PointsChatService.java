package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.PointsChatDTO;
import com.example.BinasJC_API_Server.models.PointsChat;
import com.example.BinasJC_API_Server.models.Type;
import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.repositories.PointsChatRepository;
import com.example.BinasJC_API_Server.repositories.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PointsChatService {

    @Autowired
    private PointsChatRepository pointsChatRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HistoricalPointsService historicalPointsService;

    // Enviar pontos
    @Transactional
    public PointsChat sendPoints(Long fromUserId, Long toUserId, int points) {

        if (fromUserId.equals(toUserId)) {
            throw new IllegalArgumentException("Cannot send points to the same user.");
        }

        if (points <= 0) {
            throw new IllegalArgumentException("Points must be greater than 0.");
        }

        // Recuperar usuários
        User fromUser = userRepository.findById(fromUserId)
                .orElseThrow(() -> new IllegalArgumentException("Sender not found with ID: " + fromUserId));
        User toUser = userRepository.findById(toUserId)
                .orElseThrow(() -> new IllegalArgumentException("Receiver not found with ID: " + toUserId));

        // Atualizar pontos usando o método updatePoints
        fromUser.updatePoints(-points); // Deduz pontos do remetente
        toUser.updatePoints(points);   // Adiciona pontos ao destinatário

        // Salvar alterações nos usuários
        userRepository.save(fromUser);
        userRepository.save(toUser);

        // Criar e salvar o registro de PointsChat
        PointsChat pointsChat = new PointsChat();
        pointsChat.setFromUser(fromUserId);
        pointsChat.setToUser(toUserId);
        pointsChat.setPoints(points);
        PointsChat savedPointsChat = pointsChatRepository.save(pointsChat);

        // Criar registros de HistoricalPoints para ambos os usuários
        historicalPointsService.createHistoricalPoint(fromUserId, 1L, Type.SEND, points); // Histórico do remetente
        historicalPointsService.createHistoricalPoint(toUserId, 1L, Type.RECEIVED, points); // Histórico do destinatário

        return savedPointsChat;
    }


    // Recuperar um registro específico de PointsChat pelo ID
    public PointsChatDTO getPointsChat(Long chatId) {
        PointsChat pointsChat = pointsChatRepository.findById(chatId)
                .orElseThrow(() -> new IllegalArgumentException("PointsChat not found with ID: " + chatId));
        return convertToDTO(pointsChat);
    }

    // Listar todos os registros enviados por um usuário específico
    public List<PointsChatDTO> getPointsChatsBySender(Long fromUserId) {
        return pointsChatRepository.findByFromUser(fromUserId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Listar todos os registros recebidos por um usuário específico
    public List<PointsChatDTO> getPointsChatsByReceiver(Long toUserId) {
        return pointsChatRepository.findByToUser(toUserId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Converter PointsChat para PointsChatDTO
    private PointsChatDTO convertToDTO(PointsChat pointsChat) {
        PointsChatDTO dto = new PointsChatDTO();
        dto.setId(pointsChat.getId());
        dto.setFromUser(pointsChat.getFromUser());
        dto.setToUser(pointsChat.getToUser());
        dto.setPoints(pointsChat.getPoints());
        return dto;
    }

    // Deletar um registro de PointsChat (se necessário)
    public void deletePointsChat(Long chatId) {
        PointsChat pointsChat = pointsChatRepository.findById(chatId)
                .orElseThrow(() -> new IllegalArgumentException("PointsChat not found with ID: " + chatId));
        pointsChatRepository.delete(pointsChat);
    }
}
