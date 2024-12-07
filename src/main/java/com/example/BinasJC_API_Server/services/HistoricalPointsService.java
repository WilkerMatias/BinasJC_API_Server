package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.HistoricalPointsDTO;
import com.example.BinasJC_API_Server.models.*;
import com.example.BinasJC_API_Server.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class HistoricalPointsService {

    @Autowired
    private HistoricalPointsRepository historicalPointsRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PointsChatRepository pointsChatRepository;

    @Autowired
    private GiftEarnedRepository giftEarnedRepository;

    @Autowired
    private TrajectoryRepository trajectoryRepository;

    // Listar todos os registros
    public List<HistoricalPointsDTO> getAllHistoricalPoints() {
        return historicalPointsRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Buscar registros por usuário
    public List<HistoricalPointsDTO> getHistoricalPointsByUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        return historicalPointsRepository.findByUser(user).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Buscar registros por processo
    public List<HistoricalPointsDTO> getHistoricalPointsByProcess(Long processId) {
        return historicalPointsRepository.findByProcess(processId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Criar um novo registro
    public HistoricalPoints createHistoricalPoint(Long userId, Long processId, Type type, int points) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        HistoricalPoints historicalPoint = new HistoricalPoints();
        historicalPoint.setUser(user);
        historicalPoint.setProcess(processId);
        historicalPoint.setType(type);
        historicalPoint.setPoints(points);
        historicalPoint.setUsed(false); // Sempre definido como false na criação

        return historicalPointsRepository.save(historicalPoint);
    }

    // Atualizar o status de uso
    public HistoricalPoints updateUsedStatus(Long id, boolean used) {
        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));

        historicalPoint.setUsed(used);
        return historicalPointsRepository.save(historicalPoint);
    }

    // Atualizar o processo
//    public HistoricalPoints updateProcess(Long id, Long newProcessId) {
//        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));
//
//        historicalPoint.setProcess(newProcessId);
//        return historicalPointsRepository.save(historicalPoint);
//    }
//
//    // Atualizar o tipo
//    public HistoricalPoints updateType(Long id, Type newType) {
//        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));
//
//        historicalPoint.setType(newType);
//        return historicalPointsRepository.save(historicalPoint);
//    }

    // Atualizar os pontos
    public HistoricalPoints updatePoints(Long id, int newPoints) {
        // Verificar se os pontos são positivos
        if (newPoints < 0) {
            throw new IllegalArgumentException("Points must be a positive value.");
        }

        // Buscar o registro pelo ID
        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));

        // Atualizar os pontos
        historicalPoint.setPoints(newPoints);

        switch (historicalPoint.getType()){
            case GIFT:
                GiftEarned giftEarned = giftEarnedRepository.findById(historicalPoint.getProcess())
                        .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + historicalPoint.getProcess()));
                giftEarned.setPrice(newPoints);
                giftEarnedRepository.save(giftEarned);
                break;
            case SEND:
            case RECEIVED:
                PointsChat pointsChat = pointsChatRepository.findById(historicalPoint.getProcess())
                        .orElseThrow(() -> new IllegalArgumentException("PointsChat not found with ID: " + historicalPoint.getProcess()));
                pointsChat.setPoints(newPoints); // Exemplo de lógica
                pointsChatRepository.save(pointsChat);
                break;
//            case TRAJECTORY:
//                Trajectory trajectory = trajectoryRepository.findById(historicalPoint.getProcess())
//                        .orElseThrow(() -> new IllegalArgumentException("Trajectory not found with ID: " + processId));
//                trajectory.setDistance(newPoints); // Exemplo de lógica
//                trajectoryRepository.save(trajectory);
//                break;
            default:
                throw new IllegalStateException("Unhandled HistoricalPoints Type: " + historicalPoint.getType());
        }

        return historicalPointsRepository.save(historicalPoint);
    }


    // Deletar um registro
    public void deleteHistoricalPoint(Long id) {
        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));

        historicalPointsRepository.delete(historicalPoint);
    }

    // Converter HistoricalPoints para HistoricalPointsDTO
    private HistoricalPointsDTO convertToDTO(HistoricalPoints historicalPoint) {
        HistoricalPointsDTO dto = new HistoricalPointsDTO();
        dto.setUser(historicalPoint.getUser().getId());
        dto.setProcess(historicalPoint.getProcess());
        dto.setType(historicalPoint.getType());
        dto.setPoints(historicalPoint.getPoints());
        dto.setUsed(historicalPoint.isUsed());

        return dto;
    }




}
