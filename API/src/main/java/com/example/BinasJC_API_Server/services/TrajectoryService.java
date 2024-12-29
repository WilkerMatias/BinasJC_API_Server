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

        // Obter a rota atual
        List<Coords> route = trajectory.getRoute();
        if (route == null) {
            route = new ArrayList<>();
        }

        // Converter o novo ponto
        Coords newPoint = convertToCoords(newCoords);

        // Calcular a distância entre o último ponto e o novo ponto
        if (!route.isEmpty()) {
            Coords lastPoint = route.get(route.size() - 1);
            double additionalDistance = calculateDistance(
                    lastPoint.getLat(), lastPoint.getLon(),
                    newPoint.getLat(), newPoint.getLon()
            );
            trajectory.setDistance(trajectory.getDistance() + additionalDistance);
        }

        // Adicionar o novo ponto à rota
        route.add(newPoint);
        trajectory.setRoute(route);

        return trajectoryRepository.save(trajectory);
    }


    // Finalizar uma trajetória
    public TrajectoryDTO endTrajectory(Long trajectoryId, Long toStation) {
        // Buscar a trajetória
        Trajectory trajectory = trajectoryRepository.findById(trajectoryId)
                .orElseThrow(() -> new IllegalArgumentException("Trajectory not found with ID: " + trajectoryId));

        // Verificar se a trajetória já foi encerrada
        if (trajectory.getEnd() != null) {
            throw new IllegalArgumentException("Trajectory is already ended.");
        }

        // Atualizar a estação final e data de término
        trajectory.setToStation(toStation);
        trajectory.setEnd(new Date());

        trajectoryRepository.save(trajectory);

        // Retornar a trajetória atualizada como DTO
        return convertToDTO(trajectory);
    }


    // Método auxiliar para calcular a distância entre dois pontos geográficos
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int EARTH_RADIUS = 6371; // Raio médio da Terra em km

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS * c; // Retorna a distância em quilômetros
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
