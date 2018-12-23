package com.websystique.springmvc.socialproviders;

import org.springframework.data.jpa.repository.JpaRepository;


import com.websystique.springmvc.model.User;

public interface UserRepository extends JpaRepository<User, String> {
    	User findByEmail(String email);
}

