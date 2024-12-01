package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.CoordsDTO;
import com.example.BinasJC_API_Server.dtos.TrajectoryDTO;
import com.example.BinasJC_API_Server.models.Coords;
import com.example.BinasJC_API_Server.models.Trajectory;
import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.repositories.TrajectoryRepository;
import com.example.BinasJC_API_Server.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class TrajectoryService {

    @Autowired
    private TrajectoryRepository trajectoryRepository;

    @Autowired
    private UserRepository userRepository;

    // Criar uma nova trajetória com uma única coordenada inicial
    public Trajectory createTrajectory(Long userId, Long fromStation, CoordsDTO initialCoords) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        Trajectory trajectory = new Trajectory();
        trajectory.setUser(user);
        trajectory.setFromStation(fromStation);
        trajectory.setToStation(null);
        trajectory.setDistance(0);
        trajectory.setStart(new Date());

        // Adicionar a coordenada inicial na rota
        List<Coords> route = new ArrayList<>();
        route.add(convertToCoords(initialCoords));
        trajectory.setRoute(route);

        return trajectoryRepository.save(trajectory);
    }

    // Adicionar coordenadas à lista de uma trajetória existente
    public Trajectory addCoordsToTrajectory(Long trajectoryId, CoordsDTO newCoords) {
        Trajectory trajectory = trajectoryRepository.findById(trajectoryId)
                .orElseThrow(() -> new IllegalArgumentException("Trajectory not found with ID: " + trajectoryId));

        if (trajectory.getEnd() != null) {
            throw new IllegalArgumentException("Cannot add coordinates to a trajectory that has already ended.");
        }

        // Adicionar a nova coordenada à rota
        List<Coords> route = trajectory.getRoute();
        if (route == null) {
            route = new ArrayList<>();
        }
        route.add(convertToCoords(newCoords));
        trajectory.setRoute(route);

        return trajectoryRepository.save(trajectory);
    }

    // Finalizar uma trajetória
    public Trajectory endTrajectory(Long trajectoryId, Long toStation) {
        Trajectory trajectory = trajectoryRepository.findById(trajectoryId)
                .orElseThrow(() -> new IllegalArgumentException("Trajectory not found with ID: " + trajectoryId));

        if (trajectory.getEnd() != null) {
            throw new IllegalArgumentException("Trajectory already ended.");
        }
        trajectory.setToStation(toStation);
        trajectory.setEnd(new Date());
        return trajectoryRepository.save(trajectory);
    }

    // Listar trajetórias por usuário
    public List<TrajectoryDTO> getTrajectoriesByUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        List<Trajectory> trajectories = trajectoryRepository.findByUser(user);
        return convertToDTOList(trajectories);
    }

    // Converter lista de Trajectory para lista de TrajectoryDTO
    private List<TrajectoryDTO> convertToDTOList(List<Trajectory> trajectories) {
        List<TrajectoryDTO> dtoList = new ArrayList<>();
        for (Trajectory trajectory : trajectories) {
            dtoList.add(convertToDTO(trajectory));
        }
        return dtoList;
    }

    // Converter Trajectory para TrajectoryDTO
    private TrajectoryDTO convertToDTO(Trajectory trajectory) {
        TrajectoryDTO dto = new TrajectoryDTO();
        dto.setId(trajectory.getId());
        dto.setUser(trajectory.getUser().getId());
        dto.setFromStation(trajectory.getFromStation());
        dto.setToStation(trajectory.getToStation());
        dto.setDistance(trajectory.getDistance());
        dto.setStart(trajectory.getStart());
        dto.setEnd(trajectory.getEnd());
        dto.setRoute(convertToCoordsDTOList(trajectory.getRoute()));
        return dto;
    }

    // Converter lista de Coords para lista de CoordsDTO
    private List<CoordsDTO> convertToCoordsDTOList(List<Coords> coordsList) {
        List<CoordsDTO> dtoList = new ArrayList<>();
        for (Coords coords : coordsList) {
            CoordsDTO dto = new CoordsDTO();
            dto.setLat(coords.getLat());
            dto.setLon(coords.getLon());
            dtoList.add(dto);
        }
        return dtoList;
    }

    // Converter CoordsDTO para Coords
    private Coords convertToCoords(CoordsDTO dto) {
        Coords coords = new Coords();
        coords.setLat(dto.getLat());
        coords.setLon(dto.getLon());
        return coords;
    }
}
