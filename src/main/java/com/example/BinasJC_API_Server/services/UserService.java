package com.example.BinasJC_API_Server.services;

import com.example.BinasJC_API_Server.dtos.BikeDTO;
import com.example.BinasJC_API_Server.dtos.CoordsDTO;
import com.example.BinasJC_API_Server.dtos.GiftEarnedDTO;
import com.example.BinasJC_API_Server.dtos.UserDTO;

import com.example.BinasJC_API_Server.models.Bike;
import com.example.BinasJC_API_Server.models.Gift;
import com.example.BinasJC_API_Server.models.GiftEarned;
import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.repositories.BikeRepository;
import com.example.BinasJC_API_Server.repositories.GiftEarnedRepository;
import com.example.BinasJC_API_Server.repositories.GiftRepository;
import com.example.BinasJC_API_Server.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BikeRepository bikeRepository;

    @Autowired
    private GiftEarnedRepository giftEarnedRepository;

    @Autowired
    private GiftRepository giftRepository;

    // Login
    public UserDTO login(String username, String password) {
        User user = userRepository.findByUsername(username);

        if (user == null || !user.getPassword().equals(password)) {
            throw new RuntimeException("Invalid email or password.");
        }

        if (!user.isActive()) {
            throw new RuntimeException("User is not active. Please contact support.");
        }

        return convertToDTO(user);
    }

    // Criar User
    public User createUser(String username, String email, String bi, String password) {
        if (userRepository.findByUsername(username) != null) {
            throw new IllegalArgumentException("Username is already in use.");
        }
        if (userRepository.findByEmail(email) != null) {
            throw new IllegalArgumentException("Email is already in use.");
        }
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setBi(bi);
        newUser.setPassword(password); // Sem codificação da senha
        newUser.updatePoints(0);
        newUser.setBike(null);
        newUser.setGifts(null);
        newUser.setActive(true);
        newUser.setDeleted(false);
        return userRepository.save(newUser);
    }

    // Converte User para UserDTO
    private UserDTO convertToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setBi(user.getBi());
        dto.updatePoints(user.getPoints());

        // Converter Bike para BikeDTO
        if (user.getBike() != null) {
            Bike bike = user.getBike();
            BikeDTO bikeDTO = new BikeDTO();
            bikeDTO.setId(bike.getId());
            bikeDTO.setStatus(bike.getStatus());

            // Converter Coords para CoordsDTO
            if (bike.getLocation() != null) {
                CoordsDTO coordsDTO = new CoordsDTO();
                coordsDTO.setLat(bike.getLocation().getLat());
                coordsDTO.setLon(bike.getLocation().getLon());
                bikeDTO.setActualLocation(coordsDTO);
            }

            dto.setBike(bikeDTO);
        }

        // Converter Gifts para GiftEarnedDTO
        if (user.getGifts() != null && !user.getGifts().isEmpty()) {
            List<GiftEarnedDTO> giftDTOs = new ArrayList<>();
            for (GiftEarned gift : user.getGifts()) {
                GiftEarnedDTO giftDTO = new GiftEarnedDTO();
                giftDTO.setGift(gift.getId());
                giftDTO.setName(gift.getName());
                giftDTO.setDate(gift.getDate());
                giftDTO.setUsed(gift.isUsed());
                giftDTOs.add(giftDTO);
            }
            dto.setGifts(giftDTOs);
        }

        return dto;
    }

    // Listar User por ID
    public UserDTO getUserById(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
        return convertToDTO(user);
    }

    // Listar User por email
    public UserDTO getUserByEmail(String email) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new RuntimeException("User not found with email: " + email);
        }
        return convertToDTO(user);
    }

    // Listar User por username
    public UserDTO getUserByUsername(String username) {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new RuntimeException("User not found with email: " + username);
        }
        return convertToDTO(user);
    }

    // Atualizar username
    public User updateUsername(Long id, String newUsername) {
        if (userRepository.findByUsername(newUsername) != null) {
            throw new IllegalArgumentException("Username is already in use.");
        }
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
        user.setUsername(newUsername);
        return userRepository.save(user);
    }

    // Atualizar senha
    public User updatePassword(Long id, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
        user.setPassword(newPassword); // Sem codificação da senha
        return userRepository.save(user);
    }

    // Atualizar bicicleta
    public User updateBike(Long userId, Long bikeId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        Bike newBike = bikeRepository.findById(bikeId)
                .orElseThrow(() -> new IllegalArgumentException("Bike not found with ID: " + bikeId));

        // Verificar se outro usuário já está com esta bike
        User existingUserWithBike = userRepository.findByBike(newBike);
        if (existingUserWithBike != null && !existingUserWithBike.getId().equals(userId)) {
            throw new IllegalArgumentException("Bike is already assigned to another user with ID: " + existingUserWithBike.getId());
        }

        user.setBike(newBike);

        return userRepository.save(user);
    }

    // Atualizar presentes
    public User updateGifts(Long userId, Long giftId) {
        // Buscar o usuário
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        // Buscar o presente base
        Gift gift = giftRepository.findById(giftId)
                .orElseThrow(() -> new IllegalArgumentException("Gift not found with ID: " + giftId));

        // Criar uma nova instância de GiftEarned associada ao presente
        GiftEarned newGift = new GiftEarned();
        newGift.setName(gift.getName());
        newGift.setDate(new Date());
        newGift.setUsed(false);
        newGift.setUser(user);

        // Salvar o GiftEarned no repositório (caso necessário)
        newGift = giftEarnedRepository.save(newGift);

        // Inicializar a lista de gifts, se necessário
        if (user.getGifts() == null) {
            user.setGifts(new ArrayList<>());
        }

        // Adicionar o novo presente à lista
        user.getGifts().add(newGift);

        // Salvar alterações no usuário
        return userRepository.save(user);
    }

    // Retorna a senha do usuário
    public String getPassword(String email) {
        User user = userRepository.findByEmail(email);

        if(user == null){
            throw new RuntimeException("User not found with email: " + email);
        }

        return user.getPassword();
    }


    // Desativar usuário
    public User deactivateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
        user.setActive(false);
        return userRepository.save(user);
    }

    // Reacivar usuaário
    public User reactivateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + id));

        if (user.isDeleted()) {
            throw new RuntimeException("Cannot reactivate a deleted user.");
        }

        if (user.isActive()) {
            throw new RuntimeException("User is already active.");
        }

        user.setActive(true);
        return userRepository.save(user);
    }


    // Deletar usuário
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
        user.setDeleted(true);
        userRepository.save(user);
    }
}
