package com.example.sbrm;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.config.EnableMongoAuditing;

@SpringBootApplication
@EnableMongoAuditing
public class SpringBootRestMongodbApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootRestMongodbApplication.class, args);
	}

}
