package com.example.BinasJC_API_Server.controllers;

import com.example.BinasJC_API_Server.dtos.UserDTO;
import com.example.BinasJC_API_Server.models.User;
import com.example.BinasJC_API_Server.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // Login
    @PostMapping("/login")
    public ResponseEntity<UserDTO> login(@RequestParam String username, @RequestParam String password) {
        UserDTO user = userService.login(username, password);
        return ResponseEntity.ok(user);
    }

    // Criar usuário
    @PostMapping("/create")
    public ResponseEntity<User> createUser(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String bi,
            @RequestParam String password
    ) {
        User newUser = userService.createUser(username, email, bi, password);
        return ResponseEntity.ok(newUser);
    }

    // Obter usuário por ID
    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        UserDTO user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    // Obter usuário por email
    @GetMapping("/email")
    public ResponseEntity<UserDTO> getUserByEmail(@RequestParam String email) {
        UserDTO user = userService.getUserByEmail(email);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/{email}/password")
    public ResponseEntity<String> getUserPassword(@PathVariable String email){
        String password = userService.getPassword(email);
        return ResponseEntity.ok(password);
    }

    // Obter usuário por username
    @GetMapping("/username")
    public ResponseEntity<UserDTO> getUserByUsername(@RequestParam String username) {
        UserDTO user = userService.getUserByUsername(username);
        return ResponseEntity.ok(user);
    }

    // Atualizar username
    @PutMapping("/{id}/username")
    public ResponseEntity<User> updateUsername(@PathVariable Long id, @RequestParam String newUsername) {
        User updatedUser = userService.updateUsername(id, newUsername);
        return ResponseEntity.ok(updatedUser);
    }

    // Atualizar senha
    @PutMapping("/{id}/password")
    public ResponseEntity<User> updatePassword(@PathVariable Long id, @RequestParam String newPassword) {
        User updatedUser = userService.updatePassword(id, newPassword);
        return ResponseEntity.ok(updatedUser);
    }

    // Atualizar bicicleta
    @PutMapping("/{userId}/bike")
    public ResponseEntity<User> updateBike(@PathVariable Long userId, @RequestParam Long bikeId) {
        User updatedUser = userService.updateBike(userId, bikeId);
        return ResponseEntity.ok(updatedUser);
    }

    // Atualizar presentes
    @PutMapping("/{userId}/gifts")
    public ResponseEntity<User> updateGifts(@PathVariable Long userId, @RequestParam Long giftId) {
        User updatedUser = userService.updateGifts(userId, giftId);
        return ResponseEntity.ok(updatedUser);
    }

    // Desativar usuário
    @PutMapping("/{id}/deactivate")
    public ResponseEntity<User> deactivateUser(@PathVariable Long id) {
        User updatedUser = userService.deactivateUser(id);
        return ResponseEntity.ok(updatedUser);
    }

    // Reativar usuário
    @PutMapping("/{id}/reactivate")
    public ResponseEntity<User> reactivateUser(@PathVariable Long id) {
        User updatedUser = userService.reactivateUser(id);
        return ResponseEntity.ok(updatedUser);
    }

    // Deletar usuário
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}
