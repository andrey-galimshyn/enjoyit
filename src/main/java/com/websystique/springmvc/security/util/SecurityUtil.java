package com.websystique.springmvc.security.util;

import com.websystique.springmvc.model.JoinMeUserDetails;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;

import java.util.HashSet;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(SecurityUtil.class);

    public static void logInUser(User user) {
        LOGGER.info("Logging in user: {}", user);

        JoinMeUserDetails userDetails = JoinMeUserDetails.getBuilder()
                .firstName(user.getFirstName())
                .id(new Long(user.getId()))
                .lastName(user.getLastName())
                .password(user.getPassword())
                .role(getGrantedAuthorities(user))
                .socialSignInProvider(user.getSignInProvider())
                .username(user.getEmail())
                .build();
        LOGGER.debug("Logging in principal: {}", userDetails);

        Authentication authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);

        LOGGER.info("User: {} has been logged in.", userDetails);
    }

    public static Set<GrantedAuthority> getGrantedAuthorities(User user){
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();
         
        for(UserProfile userProfile : user.getUserProfiles()){
        	LOGGER.info("UserProfile : {}", userProfile);
            authorities.add(new SimpleGrantedAuthority("ROLE_"+userProfile.getType()));
        }
        LOGGER.info("authorities : {}", authorities);
        return authorities;
    }

}
