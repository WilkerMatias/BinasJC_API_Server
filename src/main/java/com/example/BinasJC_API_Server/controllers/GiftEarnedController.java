package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.GiftEarnedDTO;
import com.example.BinasJC_API_Server.models.GiftEarned;
import com.example.BinasJC_API_Server.services.GiftEarnedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/gift-earned")
public class GiftEarnedController {

    @Autowired
    private GiftEarnedService giftEarnedService;

    // Registrar um Gift Earned
    @PostMapping
    public ResponseEntity<GiftEarned> createGiftEarned(
            @RequestParam Long userId,
            @RequestParam Long giftId
    ) {
        GiftEarned giftEarned = giftEarnedService.createGiftEarned(userId, giftId);
        return ResponseEntity.ok(giftEarned);
    }

    // Buscar GiftEarned por ID
    @GetMapping("/{giftEarnedId}")
    public ResponseEntity<GiftEarnedDTO> getGiftEarnedById(@PathVariable Long giftEarnedId) {
        GiftEarnedDTO giftEarned = giftEarnedService.getGiftEarnedById(giftEarnedId);
        return ResponseEntity.ok(giftEarned);
    }

    // Atualizar o status de uso de um GiftEarned
    @PatchMapping("/{giftEarnedId}/used")
    public ResponseEntity<GiftEarned> updateGiftUsedStatus(
            @PathVariable Long giftEarnedId,
            @RequestParam boolean newStatus
    ) {
        GiftEarned updatedGiftEarned = giftEarnedService.updateGiftUsedStatus(giftEarnedId, newStatus);
        return ResponseEntity.ok(updatedGiftEarned);
    }

    // Listar todos os GiftsEarned de um usuário
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<GiftEarnedDTO>> getGiftsEarnedByUser(@PathVariable Long userId) {
        List<GiftEarnedDTO> giftsEarned = giftEarnedService.getGiftsEarnedByUser(userId);
        return ResponseEntity.ok(giftsEarned);
    }

    // Deletar um GiftEarned por ID
    @DeleteMapping("/{giftEarnedId}")
    public ResponseEntity<Void> deleteGiftEarned(@PathVariable Long giftEarnedId) {
        giftEarnedService.deleteGiftEarned(giftEarnedId);
        return ResponseEntity.noContent().build();
    }
}
