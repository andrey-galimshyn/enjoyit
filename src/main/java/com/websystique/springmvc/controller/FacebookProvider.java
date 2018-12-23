package com.websystique.springmvc.controller;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.User;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.websystique.springmvc.model.SocialMediaService;
import com.websystique.springmvc.model.UserProfile;
import com.websystique.springmvc.model.UserProfileType;
import com.websystique.springmvc.service.UserProfileService;
import com.websystique.springmvc.service.UserService;

@Service
public class FacebookProvider  {

	private static final String REDIRECT_LOGIN = "redirect:/login";

	@Autowired
	BaseProvider baseProvider ;
	@Autowired
    private UserService service;
	@Autowired
    private UserProfileService profileService;

	public String getFacebookUserData(Model model, com.websystique.springmvc.model.User userForm) {

		ConnectionRepository connectionRepository = baseProvider.getConnectionRepository();
		
		Connection<Facebook> connection = connectionRepository.findPrimaryConnection(Facebook.class);
		
		if (connection == null) {
			return REDIRECT_LOGIN;
		}
		//Populate the Bean
		populateUserDetailsFromFacebook(userForm, connection);
		
		com.websystique.springmvc.model.User dbFetchedUser =  service.findByEmail(userForm.getEmail());
		
		if (dbFetchedUser == null) {
			//Save the details in DB
			baseProvider.saveUserDetails(userForm);
			dbFetchedUser = userForm;
		}
		
		//Login the User
		baseProvider.autoLoginUser(dbFetchedUser);
		model.addAttribute("loggedInUser",dbFetchedUser);
		
		//fetch stored session and forward there
		return "redirect:/";
		
	}

	protected void populateUserDetailsFromFacebook(com.websystique.springmvc.model.User userForm, Connection<Facebook> connection) {
		Facebook facebook = baseProvider.getFacebook();
		User user = facebook.userOperations().getUserProfile();
		userForm.setEmail(user.getEmail());
		userForm.setFirstName(user.getFirstName());
		userForm.setLastName(user.getLastName());
		
        if (user.getEmail() != null) {
        	userForm.setSsoid(user.getEmail().split("@")[0]);
        }
        // profiles section
        UserProfile userProfile = profileService.findByType(UserProfileType.USER.getUserProfileType());
        Set<UserProfile> userProfiles = new HashSet<UserProfile>();
        userProfiles.add(userProfile);
        userForm.setUserProfiles(userProfiles);
        //
        userForm.setSocialType(SocialMediaService.FACEBOOK.name());
        userForm.setSignInProvider(SocialMediaService.FACEBOOK);
        // set social profile url
		// profile is hidden by facebook for now
        //userForm.setSocialProfURL( "https://www.facebook.com/app_scoped_user_id/" + ((java.util.LinkedHashMap) user.getExtraData().get("context")).get("id").toString());
        //
        userForm.setSocialProfImageURL(connection.getImageUrl());
	}

	 

}
