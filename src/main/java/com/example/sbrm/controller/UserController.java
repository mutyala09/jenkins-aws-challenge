package com.example.sbrm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.sbrm.model.User;
import com.example.sbrm.repository.UserRepository;

@RestController
@RequestMapping("/api")
public class UserController {

	@Autowired
	private UserRepository userRepository;


	@GetMapping(value = "/users")
	public Map<String, Object> getAllUsers() {

		List<User> users =  userRepository.findAll();
		Map<String, Object> responseMap = new HashMap<>();

		responseMap.put("users", users);
		responseMap.put("status", 200);
		responseMap.put("message", "Success");

		return responseMap;
	}

	@GetMapping(value = "/user/{id}")
	public Map<String, Object> findUser(@PathVariable String id) {

		User user = userRepository.findById(id);
		Map<String, Object> responseMap = new HashMap<>();

		responseMap.put("user", user);
		responseMap.put("status", 200);
		responseMap.put("message", "Success");
	    return responseMap;
	}

	@PostMapping(value = "/user")
	public Map<String, Object> saveUser(@RequestBody User user) {
		User savedUser = userRepository.save(user);
		Map<String, Object> responseMap = new HashMap<>();

		responseMap.put("user", savedUser);
		responseMap.put("status", 200);
		responseMap.put("message", "Success");
	    return responseMap;
	}

	@PutMapping(value = "/user")
	public Map<String, Object> updateUser(@RequestBody User user) {
		User updatedUser = userRepository.save(user);
		Map<String, Object> responseMap = new HashMap<>();

		responseMap.put("user", updatedUser);
		responseMap.put("status", 200);
		responseMap.put("message", "Success");
	    return responseMap;
	}

	@DeleteMapping(value = "/user/{id}")
	public Map<String, Object> deleteUser(@PathVariable String id) {

		Map<String, Object> responseMap = new HashMap<>();

		try {
			userRepository.deleteById(id);

			responseMap.put("user", true);
			responseMap.put("status", 200);
			responseMap.put("message", "Success");

		} catch (Exception e) {
			responseMap.put("user", false);
			responseMap.put("status", 500);
			responseMap.put("message", "Error");
		}


	    return responseMap;
	}

}
