package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.CoordsDTO;
import com.example.BinasJC_API_Server.dtos.StationDTO;
import com.example.BinasJC_API_Server.models.Bike;
import com.example.BinasJC_API_Server.models.Coords;
import com.example.BinasJC_API_Server.models.Station;
import com.example.BinasJC_API_Server.repositories.BikeRepository;
import com.example.BinasJC_API_Server.repositories.StationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StationService {

    @Autowired
    private StationRepository stationRepository;

    @Autowired
    private BikeRepository bikeRepository;

    // Listar todas as estações
    public List<StationDTO> getAllStations() {
        return stationRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Buscar estação por ID
    public StationDTO getStationById(Long id) {
        Station station = stationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + id));
        return convertToDTO(station);
    }

    // Criar nova estação
    public Station createStation(String name, Coords location) {
        if (name == null || name.isEmpty()) {
            throw new IllegalArgumentException("Station name cannot be null or empty.");
        }
        if (location == null) {
            throw new IllegalArgumentException("Location cannot be null.");
        }

        Station station = new Station();
        station.setName(name);
        station.setLocation(location);
        station.setBikes(new ArrayList<>()); // Inicializar a lista de bikes
        return stationRepository.save(station);
    }

    // Atualizar nome da estação
    public Station updateStationName(Long id, String newName) {
        Station station = stationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + id));

        if (newName == null || newName.isEmpty()) {
            throw new IllegalArgumentException("New name cannot be null or empty.");
        }

        station.setName(newName);
        return stationRepository.save(station);
    }

    // Atualizar localização da estação
    public Station updateStationLocation(Long id, Coords newLocation) {
        Station station = stationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + id));

        if (newLocation == null) {
            throw new IllegalArgumentException("New location cannot be null.");
        }

        station.setLocation(newLocation);
        return stationRepository.save(station);
    }

    // Adicionar bike à estação
    public Station addBikeToStation(Long stationId, Long bikeId) {
        Station station = stationRepository.findById(stationId)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + stationId));

        Bike bike = bikeRepository.findById(bikeId)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + bikeId));

        if (!station.getBikes().contains(bike)) {
            station.getBikes().add(bike);
            return stationRepository.save(station);
        } else {
            throw new IllegalArgumentException("Bike is already assigned to this station.");
        }
    }

    // Remover bike da estação
    public Station removeBikeFromStation(Long stationId, Long bikeId) {
        Station station = stationRepository.findById(stationId)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + stationId));

        Bike bike = bikeRepository.findById(bikeId)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + bikeId));

        if (station.getBikes().remove(bike)) {
            return stationRepository.save(station);
        } else {
            throw new IllegalArgumentException("Bike is not assigned to this station.");
        }
    }

    // Deletar estação
    public void deleteStation(Long id) {
        Station station = stationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Station not found with ID: " + id));
        stationRepository.delete(station);
    }

    // Converter Station para StationDTO
    private StationDTO convertToDTO(Station station) {
        StationDTO dto = new StationDTO();
        dto.setId(station.getId());
        dto.setName(station.getName());

        // Converter localização
        if (station.getLocation() != null) {
            CoordsDTO coordsDTO = new CoordsDTO();
            coordsDTO.setLat(station.getLocation().getLat());
            coordsDTO.setLon(station.getLocation().getLon());
            dto.setLocation(coordsDTO);
        }

        // Contar o número de bikes
        if (station.getBikes() != null) {
            dto.setBikes(station.getBikes().size());
        } else {
            dto.setBikes(0);
        }

        return dto;
    }
}
