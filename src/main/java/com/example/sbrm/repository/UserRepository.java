package com.example.sbrm.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.example.sbrm.model.User;


public interface UserRepository extends MongoRepository<User, Long> {

	public User findById(String id);
	public Long deleteById(String id);
}
