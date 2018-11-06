package com.websystique.springmvc.service;

import java.util.List;

import com.websystique.springmvc.dto.RegistrationForm;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;
 
 
public interface UserService {
     
    User findById(int id);
     
    User findBySSO(String sso);
     
    User findByEmail(String email);
    
    void saveUser(User user);
     
    void updateUser(User user);
     
    void deleteUserBySSO(String sso);
 
    List<User> findAllUsers(); 
     
    boolean isUserSSOUnique(Integer id, String sso);
    
    public User registerNewUserAccount(RegistrationForm userAccountData, UserProfile userProfile) 
    		throws Exception;

}