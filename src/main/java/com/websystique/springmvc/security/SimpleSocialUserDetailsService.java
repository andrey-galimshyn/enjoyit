package com.websystique.springmvc.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.social.security.SocialUserDetails;
import org.springframework.social.security.SocialUserDetailsService;

public class SimpleSocialUserDetailsService implements SocialUserDetailsService {
	
    @Autowired
	UserDetailsService customUserDetailsService;
	
	
	@Override
	public SocialUserDetails loadUserByUserId(String ssoid) throws UsernameNotFoundException {
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(ssoid);
        return (SocialUserDetails) userDetails;	
    }

}
