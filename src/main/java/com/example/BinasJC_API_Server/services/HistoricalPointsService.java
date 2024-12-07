package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.HistoricalPointsDTO;
import com.example.BinasJC_API_Server.models.HistoricalPoints;
import com.example.BinasJC_API_Server.models.Type;
import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.repositories.HistoricalPointsRepository;
import com.example.BinasJC_API_Server.repositories.UserRepository;
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
    public HistoricalPoints updateProcess(Long id, Long newProcessId) {
        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));

        historicalPoint.setProcess(newProcessId);
        return historicalPointsRepository.save(historicalPoint);
    }

    // Atualizar o tipo
    public HistoricalPoints updateType(Long id, Type newType) {
        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));

        historicalPoint.setType(newType);
        return historicalPointsRepository.save(historicalPoint);
    }

    // Atualizar os pontos
    public HistoricalPoints updatePoints(Long id, int newPoints) {
        HistoricalPoints historicalPoint = historicalPointsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("HistoricalPoint not found with ID: " + id));

        historicalPoint.setPoints(newPoints);
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
