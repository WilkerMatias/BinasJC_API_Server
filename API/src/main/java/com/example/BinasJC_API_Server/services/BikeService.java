package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.BikeDTO;
import com.example.BinasJC_API_Server.dtos.CoordsDTO;
import com.example.BinasJC_API_Server.models.Bike;
import com.example.BinasJC_API_Server.models.Coords;
import com.example.BinasJC_API_Server.models.StatusBike;
import com.example.BinasJC_API_Server.repositories.BikeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class BikeService {

    @Autowired
    private BikeRepository bikeRepository;

    // Listar todas as bikes
    public List<BikeDTO> getAllBikes() {
        return bikeRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Buscar bike por ID
    public BikeDTO getBikeById(Long id) {
        Bike bike = bikeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + id));
        return convertToDTO(bike);
    }

    // Criar nova bike (status definido como "Station" por padrão)
    public Bike createBike(Coords location) {
        Bike bike = new Bike();
        bike.setLocation(location);
        bike.setStatus(StatusBike.STATION); // Define o status como "Station"
        return bikeRepository.save(bike);
    }

    // Atualizar localização da bike
    public Bike updateBikeCoords(Long id, Coords newLocation) {
        Bike bike = bikeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + id));

        if (newLocation == null) {
            throw new IllegalArgumentException("New location cannot be null.");
        }

        bike.setLocation(newLocation);
        return bikeRepository.save(bike);
    }

    // Atualizar status da bike
    public Bike updateBikeStatus(Long id, StatusBike newStatus) {
        Bike bike = bikeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + id));

        if (newStatus == null) {
            throw new IllegalArgumentException("New status cannot be null.");
        }

        bike.setStatus(newStatus);
        return bikeRepository.save(bike);
    }

    // Deletar bike
    public void deleteBike(Long id) {
        Bike bike = bikeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + id));
        bikeRepository.delete(bike);
    }

    // Converter Bike para BikeDTO
    private BikeDTO convertToDTO(Bike bike) {
        BikeDTO dto = new BikeDTO();
        dto.setId(bike.getId());
        dto.setStatus(bike.getStatus());

        // Verificar e converter a localização
        if (bike.getLocation() != null) {
            CoordsDTO coordsDTO = new CoordsDTO();
            coordsDTO.setLat(bike.getLocation().getLat());
            coordsDTO.setLon(bike.getLocation().getLon());
            dto.setActualLocation(coordsDTO);
        }

        return dto;
    }
}
