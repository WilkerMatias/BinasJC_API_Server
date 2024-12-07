package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.GiftEarnedDTO;
import com.example.BinasJC_API_Server.models.Gift;
import com.example.BinasJC_API_Server.models.GiftEarned;
import com.example.BinasJC_API_Server.models.Type;
import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.repositories.GiftEarnedRepository;
import com.example.BinasJC_API_Server.repositories.GiftRepository;
import com.example.BinasJC_API_Server.repositories.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class GiftEarnedService {

    @Autowired
    private GiftEarnedRepository giftEarnedRepository;

    @Autowired
    private GiftRepository giftRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HistoricalPointsService historicalPointsService;

    // Registrar um Gift Earned
    @Transactional
    public GiftEarned createGiftEarned(Long userId, Long giftId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        if (giftId == null) {
            throw new IllegalArgumentException("Gift ID cannot be null.");
        }

        // Recuperar o usuário
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        // Recuperar o presente
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));

        // Criar o GiftEarned
        GiftEarned giftEarned = new GiftEarned();
        giftEarned.setUser(user);
        giftEarned.setName(gift.getName());
        giftEarned.setPrice(gift.getPrice());
        giftEarned.setDate(new Date());
        giftEarned.setUsed(false);

        // Salvar o GiftEarned
        GiftEarned savedGiftEarned = giftEarnedRepository.save(giftEarned);

        // Criar um registro no HistoricalPoints
        historicalPointsService.createHistoricalPoint(userId,giftEarned.getId(), Type.GIFT, gift.getPrice());

        return savedGiftEarned;

    }

    // Buscar GiftEarned por ID
    public GiftEarnedDTO getGiftEarnedById(Long giftEarnedId) {
        GiftEarned giftEarned = giftEarnedRepository.findById(giftEarnedId)
                .orElseThrow(() -> new IllegalArgumentException("GiftEarned not found with ID: " + giftEarnedId));
        return convertToDTO(giftEarned);
    }

    // Atualizar apenas o status de uso
    @Transactional
    public GiftEarned updateGiftUsedStatus(Long giftEarnedId, boolean newStatus) {
        GiftEarned giftEarned = giftEarnedRepository.findById(giftEarnedId)
                .orElseThrow(() -> new IllegalArgumentException("GiftEarned not found with ID: " + giftEarnedId));
        giftEarned.setUsed(newStatus);

        return giftEarnedRepository.save(giftEarned);
    }

    // Listar todos os GiftsEarned de um usuário
    public List<GiftEarnedDTO> getGiftsEarnedByUser(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        return giftEarnedRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Deletar um GiftEarned
    @Transactional
    public void deleteGiftEarned(Long giftEarnedId) {
        GiftEarned giftEarned = giftEarnedRepository.findById(giftEarnedId)
                .orElseThrow(() -> new IllegalArgumentException("GiftEarned not found with ID: " + giftEarnedId));
        giftEarnedRepository.delete(giftEarned);
    }

    // Converter GiftEarned para GiftEarnedDTO
    private GiftEarnedDTO convertToDTO(GiftEarned giftEarned) {
        GiftEarnedDTO dto = new GiftEarnedDTO();
        dto.setGift(giftEarned.getId());
        dto.setName(giftEarned.getName());
        dto.setPrice(giftEarned.getPrice());
        dto.setDate(giftEarned.getDate());
        dto.setUsed(giftEarned.isUsed());
        return dto;
    }
}
