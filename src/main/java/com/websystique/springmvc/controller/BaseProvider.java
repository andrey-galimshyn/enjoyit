package com.websystique.springmvc.controller;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Facebook;

import com.websystique.springmvc.model.User;
import com.websystique.springmvc.security.Autologin;
import com.websystique.springmvc.security.util.SecurityUtil;
import com.websystique.springmvc.service.UserService;

public class BaseProvider {

	private Facebook facebook;
	private ConnectionRepository connectionRepository;

	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	private UserService userService;

	@Autowired
	protected Autologin autologin;

	public BaseProvider(Facebook facebook, ConnectionRepository connectionRepository) {
		this.facebook = facebook;
		this.connectionRepository = connectionRepository;
	}

	protected void saveUserDetails(User userBean) {
		if (StringUtils.isNotEmpty(userBean.getPassword())) {
			userBean.setPassword(bCryptPasswordEncoder.encode(userBean.getPassword()));
		}
		userService.saveUser(userBean);

	}

	public void autoLoginUser(User userBean) {
		autologin.setSecuritycontext(userBean);
		SecurityUtil.logInUser(userBean);
	}

	public Facebook getFacebook() {
		return facebook;
	}

	public void setFacebook(Facebook facebook) {
		this.facebook = facebook;
	}

	public ConnectionRepository getConnectionRepository() {
		return connectionRepository;
	}

	public void setConnectionRepository(ConnectionRepository connectionRepository) {
		this.connectionRepository = connectionRepository;
	}

}
