package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.GiftDTO;
import com.example.BinasJC_API_Server.models.Gift;
import com.example.BinasJC_API_Server.services.GiftService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/gifts")
public class GiftController {

    @Autowired
    private GiftService giftService;

    // Criar um novo Gift
    @PostMapping
    public ResponseEntity<Gift> createGift(
            @RequestParam String name,
            @RequestParam String description,
            @RequestParam int price
    ) {
        Gift gift = giftService.createGift(name, description, price);
        return ResponseEntity.ok(gift);
    }

    // Buscar Gift por ID
    @GetMapping("/{giftId}")
    public ResponseEntity<GiftDTO> getGiftById(@PathVariable Long giftId) {
        GiftDTO gift = giftService.getGiftById(giftId);
        return ResponseEntity.ok(gift);
    }

    // Atualizar o nome de um Gift
    @PatchMapping("/{giftId}/name")
    public ResponseEntity<Gift> updateGiftName(
            @PathVariable Long giftId,
            @RequestParam String newName
    ) {
        Gift updatedGift = giftService.updateGiftName(giftId, newName);
        return ResponseEntity.ok(updatedGift);
    }

    // Atualizar a descrição de um Gift
    @PatchMapping("/{giftId}/description")
    public ResponseEntity<Gift> updateGiftDescription(
            @PathVariable Long giftId,
            @RequestParam String newDescription
    ) {
        Gift updatedGift = giftService.updateGiftDescription(giftId, newDescription);
        return ResponseEntity.ok(updatedGift);
    }

    // Atualizar o preço de um Gift
    @PatchMapping("/{giftId}/price")
    public ResponseEntity<Gift> updateGiftPrice(
            @PathVariable Long giftId,
            @RequestParam int newPrice
    ) {
        Gift updatedGift = giftService.updateGiftPrice(giftId, newPrice);
        return ResponseEntity.ok(updatedGift);
    }

    // Listar todos os Gifts
    @GetMapping
    public ResponseEntity<List<GiftDTO>> getAllGifts() {
        List<GiftDTO> gifts = giftService.getAllGifts();
        return ResponseEntity.ok(gifts);
    }

    // Deletar um Gift por ID
    @DeleteMapping("/{giftId}")
    public ResponseEntity<Void> deleteGift(@PathVariable Long giftId) {
        giftService.deleteGift(giftId);
        return ResponseEntity.noContent().build();
    }
}
