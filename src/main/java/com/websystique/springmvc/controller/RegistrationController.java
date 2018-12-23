package com.websystique.springmvc.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.ConnectionKey;
import org.springframework.social.connect.UsersConnectionRepository;
import org.springframework.social.connect.web.ProviderSignInUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.websystique.springmvc.dto.RegistrationForm;
import com.websystique.springmvc.model.SocialMediaService;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;
import com.websystique.springmvc.model.UserProfileType;
import com.websystique.springmvc.security.util.SecurityUtil;
import com.websystique.springmvc.service.UserProfileService;
import com.websystique.springmvc.service.UserService;

 
@Controller
@SessionAttributes("user")
public class RegistrationController {
	
	private final ProviderSignInUtils providerSignInUtils;
	
    @Autowired
    FacebookProvider facebookProvider;
	
    private UserService service;
    private UserProfileService profileService;
	
	@Inject
    public RegistrationController(
    		UserService service,
    		UserProfileService profileService,
    		ConnectionFactoryLocator connectionFactoryLocator,
    		UsersConnectionRepository connectionRepository) {
		this.providerSignInUtils = new ProviderSignInUtils(connectionFactoryLocator, connectionRepository);;
        this.service = service;
        this.profileService = profileService;
	}
	@RequestMapping(value = "/user/register", method = RequestMethod.GET)
    public String showRegistrationForm(WebRequest request, Model model) throws Exception {
        Connection<?> connection = providerSignInUtils.getConnectionFromSession(request);
 
        RegistrationForm registration = createRegistrationDTO(connection);
        model.addAttribute("user", registration);
        if (registration == null || 
        		registration.getEmail() == null || 
        		registration.getEmail().isEmpty()) {
            return "registrationForm";
        }
        User registered = null;
        try {
           registered = createUserAccount(registration);
        } catch (Exception e){
           model.addAttribute("exception", e.getMessage());
           return "registrationForm";
        }
        SecurityUtil.logInUser(registered);
        providerSignInUtils.doPostSignUp(registered.getSsoid(), request);


        return "redirect:/"; 
    }

	@RequestMapping(value ="/user/register", method = RequestMethod.POST)
    public String registerUserAccount(@Valid @ModelAttribute("user") RegistrationForm userAccountData,
                                      BindingResult result,
                                      WebRequest request) throws Exception {
 
        return "redirect:/login";
    }

    @RequestMapping(value = "/connect/facebook/response", method = RequestMethod.GET)
    public String loginToFacebook(Model model, HttpServletRequest request) {
        String page = request.getHeader("Referer");
        facebookProvider.getFacebookUserData(model, new User());
        if (page.contains("login")) {
        	return "redirect:/";
        }
        return "redirect:" + page;
    }
	
    private User createUserAccount(RegistrationForm userAccountData) throws Exception {
        User registered = null;
 
        UserProfile userProfile = profileService.findByType(UserProfileType.USER.getUserProfileType());
        registered = service.registerNewUserAccount(userAccountData, userProfile);
 
        return registered;
    }    
    

    private RegistrationForm createRegistrationDTO(Connection<?> connection) {
        RegistrationForm dto = new RegistrationForm();
 
        if (connection != null) {
        	org.springframework.social.connect.UserProfile socialMediaProfile = connection.fetchUserProfile();
        	dto.setSocialProfImageURL(connection.getImageUrl());
        	dto.setSocialProfURL(connection.getProfileUrl());
        	dto.setEmail(socialMediaProfile.getEmail());
            dto.setFirstName(socialMediaProfile.getFirstName());
            dto.setLastName(socialMediaProfile.getLastName());
            if (socialMediaProfile.getEmail() != null) {
                dto.setSsoid(socialMediaProfile.getEmail().split("@")[0]);
            }
            ConnectionKey providerKey = connection.getKey();
            dto.setSignInProvider(SocialMediaService.valueOf(providerKey.getProviderId().toUpperCase()));
        }
 
        return dto;
    }
}
