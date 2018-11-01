package com.websystique.springmvc.controller;

import javax.inject.Inject;
import javax.validation.Valid;

import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.ConnectionKey;

import org.springframework.social.connect.UsersConnectionRepository;
import org.springframework.social.connect.web.ProviderSignInUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
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
import com.websystique.springmvc.service.DuplicateEmailException;
import com.websystique.springmvc.service.UserProfileService;
import com.websystique.springmvc.service.UserService;
 
@Controller
@SessionAttributes("user")
public class RegistrationController {
	
	private final ProviderSignInUtils providerSignInUtils;
	
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
    public String showRegistrationForm(WebRequest request, Model model) {
        Connection<?> connection = providerSignInUtils.getConnectionFromSession(request);
 
        RegistrationForm registration = createRegistrationDTO(connection);
        model.addAttribute("user", registration);
        if (registration == null || 
        		registration.getEmail() == null || 
        		registration.getEmail().isEmpty()) {
            return "registrationForm";
        }

        User registered = createUserAccount(registration, null);

        SecurityUtil.logInUser(registered);
        providerSignInUtils.doPostSignUp(registered.getSsoid(), request);

        return "redirect:/"; 
    }
    @RequestMapping(value ="/user/register", method = RequestMethod.POST)
    public String registerUserAccount(@Valid @ModelAttribute("user") RegistrationForm userAccountData,
                                      BindingResult result,
                                      WebRequest request) throws DuplicateEmailException {
 
        return "redirect:/login";
    }

    private User createUserAccount(RegistrationForm userAccountData, BindingResult result) {
        User registered = null;
 
        UserProfile userProfile = profileService.findByType(UserProfileType.USER.getUserProfileType());
        try {
            registered = service.registerNewUserAccount(userAccountData, userProfile);
        }
        catch (DuplicateEmailException ex) {
            addFieldError(
                    "user",
                    "email",
                    userAccountData.getEmail(),
                    "NotExist.user.email",
                    result);
        }
 
        return registered;
    }    
    
    private void addFieldError(String objectName, String fieldName, String fieldValue,  String errorCode, BindingResult result) {
        FieldError error = new FieldError(
                objectName,
                fieldName,
                fieldValue,
                false,
                new String[]{errorCode},
                new Object[]{},
                errorCode
        );
 
        result.addError(error);
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
