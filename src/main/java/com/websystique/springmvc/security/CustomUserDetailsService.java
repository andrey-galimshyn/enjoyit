package com.websystique.springmvc.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.websystique.springmvc.model.JoinMeUserDetails;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.security.util.SecurityUtil;
import com.websystique.springmvc.service.UserService;

@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

	static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

	@Autowired
	private UserService userService;

	@Transactional(readOnly = true)
	public UserDetails loadUserByUsername(String ssoId) throws UsernameNotFoundException {
		User user = userService.findBySSO(ssoId);
		logger.info("User : {}", user);
		if (user == null) {
			logger.info("User not found");
			throw new UsernameNotFoundException("Username not found");
		}

		JoinMeUserDetails principal = JoinMeUserDetails.getBuilder().firstName(user.getFirstName())
				.id(new Long(user.getId())).lastName(user.getLastName()).password(user.getPassword())
				.role(SecurityUtil.getGrantedAuthorities(user)).socialSignInProvider(user.getSignInProvider())
				.username(user.getEmail()).build();

		return principal;
	}

}