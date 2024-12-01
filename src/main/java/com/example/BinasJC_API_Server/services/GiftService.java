package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.GiftDTO;
import com.example.BinasJC_API_Server.models.Gift;
import com.example.BinasJC_API_Server.repositories.GiftRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class GiftService {

    @Autowired
    private GiftRepository giftRepository;

    // Criar um novo Gift
    public Gift createGift(String name, String description, int price) {
        if (name == null || name.isEmpty()) {
            throw new IllegalArgumentException("Gift name cannot be null or empty.");
        }
        if (price <= 0) {
            throw new IllegalArgumentException("Gift price must be greater than 0.");
        }

        Gift gift = new Gift();
        gift.setName(name);
        gift.setDescription(description);
        gift.setPrice(price);

        return giftRepository.save(gift);
    }

    // Buscar Gift por ID
    public GiftDTO getGiftById(Long giftId) {
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));
        return convertToDTO(gift);
    }

    // Atualizar apenas o nome de um Gift
    public Gift updateGiftName(Long giftId, String newName) {
        if (newName == null || newName.isEmpty()) {
            throw new IllegalArgumentException("Gift name cannot be null or empty.");
        }

        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));
        gift.setName(newName);

        return giftRepository.save(gift);
    }

    // Atualizar apenas a descrição de um Gift
    public Gift updateGiftDescription(Long giftId, String newDescription) {
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));
        gift.setDescription(newDescription);

        return giftRepository.save(gift);
    }

    // Atualizar apenas o preço de um Gift
    public Gift updateGiftPrice(Long giftId, int newPrice) {
        if (newPrice <= 0) {
            throw new IllegalArgumentException("Gift price must be greater than 0.");
        }

        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));
        gift.setPrice(newPrice);

        return giftRepository.save(gift);
    }

    // Listar todos os Gifts
    public List<GiftDTO> getAllGifts() {
        return giftRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Deletar um Gift por ID
    public void deleteGift(Long giftId) {
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));
        giftRepository.delete(gift);
    }

    // Converter Gift para GiftDTO
    private GiftDTO convertToDTO(Gift gift) {
        GiftDTO dto = new GiftDTO();
        dto.setId(gift.getId());
        dto.setName(gift.getName());
        dto.setDescription(gift.getDescription());
        dto.setPrice(gift.getPrice());
        return dto;
    }
}
