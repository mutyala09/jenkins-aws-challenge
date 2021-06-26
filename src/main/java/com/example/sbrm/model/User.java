package com.example.sbrm.model;

import java.util.Date;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@Document(collection = "user")
public class User {

	@Id
	private String id;

	private String firstName;
	private String lastName;
	private String email;
	private Integer age;
	private String address;

	@CreatedDate
	private Date createdOn;

	@LastModifiedDate
	private Date updatedOn;

}
