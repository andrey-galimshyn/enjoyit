package com.websystique.springmvc.security;
 
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.websystique.springmvc.model.ExampleUserDetails;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;
import com.websystique.springmvc.security.util.SecurityUtil;
import com.websystique.springmvc.service.UserService;
 
 
@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService{
 
    static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);
     
    @Autowired
    private UserService userService;
    
    @Transactional(readOnly=true)
    public UserDetails loadUserByUsername(String ssoId)
            throws UsernameNotFoundException {
        User user = userService.findBySSO(ssoId);
        logger.info("User : {}", user);
        if(user==null){
            logger.info("User not found");
            throw new UsernameNotFoundException("Username not found");
        }
        
        
        ExampleUserDetails principal = ExampleUserDetails.getBuilder()
                .firstName(user.getFirstName())
                .id(new Long(user.getId()))
                .lastName(user.getLastName())
                .password(user.getPassword())
                .role(SecurityUtil.getGrantedAuthorities(user))
                .socialSignInProvider(user.getSignInProvider())
                .username(user.getEmail())
                .build();
        
        
        return principal;
    }
 
     
     
    
}