package com.websystique.springmvc.controller;
 
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Set;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.websystique.springmvc.model.Event;
import com.websystique.springmvc.model.Place;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;
import com.websystique.springmvc.service.EmailService;
import com.websystique.springmvc.service.EventService;
import com.websystique.springmvc.service.PlaceService;
import com.websystique.springmvc.service.UserProfileService;
import com.websystique.springmvc.service.UserService;
 
 
 
@Controller
@RequestMapping("/")
@SessionAttributes("roles")
public class AppController {
 
    @Autowired
    UserService userService;
     
    @Autowired
    EventService eventService;

    @Autowired
    EmailService emailService;

    @Autowired
    PlaceService placeService;

    @Autowired
    UserProfileService userProfileService;
     
     
    @Autowired
    MessageSource messageSource;

    @Autowired
    PersistentTokenBasedRememberMeServices persistentTokenBasedRememberMeServices;
     
    @Autowired
    AuthenticationTrustResolver authenticationTrustResolver;

    @Transactional
    @RequestMapping(value = {"/join"}, method = RequestMethod.POST ,consumes = "application/json")
    @ResponseBody
    public String joinLoggedUserToEvent(@RequestBody String requestBody) throws ParseException, MessagingException{
        //parse event id
    	JSONParser parser = new JSONParser();
    	JSONObject json = (JSONObject) parser.parse(requestBody);
    	Integer eventId = Integer.parseInt(json.get("eventId").toString());
    	// get user and join she to event
    	User user = userService.findBySSO(getPrincipal());
    	Event event = eventService.findById(eventId);
    	Set<User> users = event.getParticipants();
    	if(users == null || users.isEmpty()) {
    		users = new HashSet<User>();
    	}
    	users.add(user);
    	event.setParticipants(users);
    	eventService.saveEvent(event);
    	//email to organizer
        emailService.sendEmail(event.getOrganizer().getEmail(), 
        		user.getFirstName() + " " + user.getLastName() + " has Joined", 
        		getEmailBody(event.getParticipants(), 
        				user.getFirstName() + " " + user.getLastName(), 
        				event.getOrganizer().getFirstName() + " " + event.getOrganizer().getLastName(), true));
    	
        return "{\"message\":\"Handled application/json request\", \"freeSpaces\": \"" + (event.getPlace().getPlacesQuantity() - users.size()) + "\" }"; 
    }

    @Transactional
    @RequestMapping(value = {"/reject"}, method = RequestMethod.POST ,consumes = "application/json")
    @ResponseBody
    public String rejectLoggedUserFromEvent(@RequestBody String requestBody) throws ParseException{
        //parse event id
    	JSONParser parser = new JSONParser();
    	JSONObject json = (JSONObject) parser.parse(requestBody);
    	Integer eventId = Integer.parseInt(json.get("eventId").toString());
    	// get user and remove him from event participants
    	User user = userService.findBySSO(getPrincipal());
    	Event event = eventService.findById(eventId);
    	Set<User> users = event.getParticipants();
    	for (Iterator<User> i = users.iterator(); i.hasNext();) {
    	    User participant = i.next();
    	    if (participant.getSsoId().equals(user.getSsoId())) {
    	        i.remove();
    	    }
    	}
    	event.setParticipants(users);
    	eventService.saveEvent(event);
    	//email to organizer
        emailService.sendEmail(event.getOrganizer().getEmail(), 
        		user.getFirstName() + " " + user.getLastName() + " has Left", 
        		getEmailBody(event.getParticipants(), 
        				user.getFirstName() + " " + user.getLastName(), 
        				event.getOrganizer().getFirstName() + " " + event.getOrganizer().getLastName(), false));
    	
        return "{\"message\":\"Handled application/json request\", \"freeSpaces\": \"" + (event.getPlace().getPlacesQuantity() - users.size()) + "\" }"; 
    }    

    private String getEmailBody(Set<User> participants, String hero, String organizer, boolean joined) {
    	StringBuffer emailBody = new StringBuffer();
    	emailBody.append("Hello Dear " + organizer + "\n\n");
    	if (joined) {
    	    emailBody.append(hero + " has joined\n\n");
    	} else {
    	    emailBody.append(hero + " unfortunately has left\n\n");
    	}
    	emailBody.append("Total participants count: " + participants.size() + "\n");
    	for (User user : participants) {
    		emailBody.append(user.getFirstName() + " " + user.getLastName() + "\n");
    	}
    	emailBody.append("\n");
    	emailBody.append("Best Regards,\nenjoyit!");
    	return emailBody.toString();
    }

    /**
     * This method will list all existing users.
     */
    @RequestMapping(value = { "/list" }, method = RequestMethod.GET)
    public String listUsers(ModelMap model) {
 
        List<User> users = userService.findAllUsers();
        model.addAttribute("users", users);
        model.addAttribute("loggedinuser", getPrincipal());
        return "userslist";
    }
 
    @RequestMapping(value = {  "/listPlaces" }, method = RequestMethod.GET)
    public String listPlaces(ModelMap model) {
 
        List<Place> places = placeService.findAllPlaces();
        model.addAttribute("places", places);
        model.addAttribute("loggedinuser", getPrincipal());
        return "placeslist";
    }

    @RequestMapping(value = {  "/", "/listEvents" }, method = RequestMethod.GET)
    public String listEvents(ModelMap model, @RequestParam(value = "range", required = false) String range) throws java.text.ParseException {

    	// Piece to process select range
    	String defaultRange = "";
    	String from = "";
    	String to = "";
    	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    	Date dateFrom = new Date();
    	Date dateTo = new Date();
    	Calendar c = Calendar.getInstance();
    	if (range != null) {
    		String [] rangeParsed  = range.split("to");
    		from = rangeParsed[0].trim();
    		to = rangeParsed[1].trim();
    		dateFrom = dateFormat.parse(from);
    		if ("Invalid date".equals(to)) {
    			to = from;
    	    	c.setTime(dateFrom);
    	    	c.add(Calendar.DATE, 1);  // add one day to not make zero range 
    	    	dateTo = c.getTime();
    		} else {
    			dateTo = dateFormat.parse(to);
    		}
    	} else {
	    	from = dateFormat.format(dateFrom);
	    	//
	    	c.setTime(dateFrom);
	    	c.add(Calendar.DATE, 3);  // number of days to add for default period
	    	dateTo = c.getTime();
	    	//
	    	to = dateFormat.format(c.getTime());
    	}
    	defaultRange = from + " to " + to;
    	//

        //List<Event> events = eventService.findAllEvents();
        List<Event> events = eventService.findEventsInRange(dateFrom, dateTo);
        model.addAttribute("defaultRange", defaultRange);
        model.addAttribute("events", events);
        model.addAttribute("loggedinuser", getPrincipal());
        return "eventslist";
    }

    /**
     * This method will provide the medium to add a new user.
     */
    @RequestMapping(value = { "/newuser" }, method = RequestMethod.GET)
    public String newUser(ModelMap model) {
        User user = new User();
        model.addAttribute("user", user);
        model.addAttribute("edit", false);
        model.addAttribute("loggedinuser", getPrincipal());
        return "registration";
    }
 
    /**
     * This method will be called on form submission, handling POST request for
     * saving user in database. It also validates the user input
     */
    @RequestMapping(value = { "/newuser" }, method = RequestMethod.POST)
    public String saveUser(@Valid User user, BindingResult result,
            ModelMap model) {
 
        if (result.hasErrors()) {
            return "registration";
        }
 
        /*
         * Preferred way to achieve uniqueness of field [sso] should be implementing custom @Unique annotation 
         * and applying it on field [sso] of Model class [User].
         * 
         * Below mentioned peace of code [if block] is to demonstrate that you can fill custom errors outside the validation
         * framework as well while still using internationalized messages.
         * 
         */
        if(!userService.isUserSSOUnique(user.getId(), user.getSsoId())){
            FieldError ssoError =new FieldError("user","ssoId",messageSource.getMessage("non.unique.ssoId", new String[]{user.getSsoId()}, Locale.getDefault()));
            result.addError(ssoError);
            return "registration";
        }
         
        userService.saveUser(user);
 
        model.addAttribute("success", "User " + user.getFirstName() + " "+ user.getLastName() + " registered successfully");
        model.addAttribute("loggedinuser", getPrincipal());
        //return "success";
        return "registrationsuccess";
    }
 
    /**
     * This method will provide the medium to add a new user.
     */
    @RequestMapping(value = { "/newplace" }, method = RequestMethod.GET)
    public String newPlace(ModelMap model) {
        Place place = new Place();
        model.addAttribute("place", place);
        model.addAttribute("edit", false);
        model.addAttribute("loggedinuser", getPrincipal());
        return "createPlace";
    }

    /**
     * This method will be called on form submission, handling POST request for
     * saving user in database. It also validates the user input
     */
    @RequestMapping(value = { "/newplace" }, method = RequestMethod.POST)
    public String savePlace(@Valid Place place, BindingResult result, ModelMap model) {

        if (result.hasErrors()) {
            return "registration";
        }
        // Set recorder of place as currently logged in user
        User user = userService.findBySSO(getPrincipal());
        place.setRecorder(user);
        //
        placeService.savePlace(place);
 
        model.addAttribute("success", "Place " + place.getName() + " "+ place.getAddress() + " registered successfully");
        model.addAttribute("loggedinuser", getPrincipal());
        //return "success";
        return "createPlaceSuccess";
    }

    //////////////////////////////////////////////////////////////
    /**
     * This method will provide the medium to add a new user.
     */
    @RequestMapping(value = { "/newevent" }, method = RequestMethod.GET)
    public String newEvent(ModelMap model) {
        Event event = new Event();
        model.addAttribute("event", event);
        model.addAttribute("loggedinuser", getPrincipal());
        return "createEvent";
    }

    /**
     * This method will be called on form submission, handling POST request for
     * saving user in database. It also validates the user input
     */
    @RequestMapping(value = { "/newevent" }, method = RequestMethod.POST)
    public String saveEvent(@Valid Event event, BindingResult result, ModelMap model) {

        if (result.hasErrors()) {
            return "createEvent";
        }
 
        // Logged user is organizer of the event
        User organizer = userService.findBySSO(getPrincipal());
        event.setOrganizer(organizer);
        
        eventService.saveEvent(event);
 
        model.addAttribute("success", "Event " + event.getName() + " "+ event.getDescription() + " added successfully");
        model.addAttribute("loggedinuser", getPrincipal());
        return "createEventSuccess";
    }

    /////////////////////////////////////////////////////
    
    @RequestMapping(value = { "/delete-user-{ssoId}" }, method = RequestMethod.GET)
    public String deleteUser(@PathVariable String ssoId) {
        userService.deleteUserBySSO(ssoId);
        return "redirect:/list";
    }

    /**
     * This method will provide the medium to update an existing user.
     */
    @RequestMapping(value = { "/edit-user-{ssoId}" }, method = RequestMethod.GET)
    public String editUser(@PathVariable String ssoId, ModelMap model) {
        User user = userService.findBySSO(ssoId);
        model.addAttribute("user", user);
        model.addAttribute("edit", true);
        model.addAttribute("loggedinuser", getPrincipal());
        return "registration";
    }
     
    /**
     * This method will be called on form submission, handling POST request for
     * updating user in database. It also validates the user input
     */
    @RequestMapping(value = { "/edit-user-{ssoId}" }, method = RequestMethod.POST)
    public String updateUser(@Valid User user, BindingResult result,
            ModelMap model, @PathVariable String ssoId) {
 
        if (result.hasErrors()) {
            return "registration";
        }
 
        /*//Uncomment below 'if block' if you WANT TO ALLOW UPDATING SSO_ID in UI which is a unique key to a User.
        if(!userService.isUserSSOUnique(user.getId(), user.getSsoId())){
            FieldError ssoError =new FieldError("user","ssoId",messageSource.getMessage("non.unique.ssoId", new 
 
String[]{user.getSsoId()}, Locale.getDefault()));
            result.addError(ssoError);
            return "registration";
        }*/
 
        userService.updateUser(user);
 
        model.addAttribute("success", "User " + user.getFirstName() + " "+ user.getLastName() + " updated successfully");
        model.addAttribute("loggedinuser", getPrincipal());
        return "registrationsuccess";
    }
 
 ///////////////////////////////////////////////////////////////    
    /**
     * This method will delete an user by it's SSOID value.
     */
    @RequestMapping(value = { "/delete-place-{id}" }, method = RequestMethod.GET)
    public String deletePlace(@PathVariable Integer id) {
        placeService.deletePlaceById(id);
        return "redirect:/listPlaces";
    }
     
    /**
     * This method will provide the medium to update an existing user.
     */
    @RequestMapping(value = { "/edit-place-{id}" }, method = RequestMethod.GET)
    public String editPlace(@PathVariable Integer id, ModelMap model) {
        Place place = placeService.findById(id);
        model.addAttribute("place", place);
        model.addAttribute("edit", true);
        model.addAttribute("loggedinuser", getPrincipal());
        return "createPlace";
    }

    @RequestMapping(value = { "/edit-place-{id}" }, method = RequestMethod.POST)
    public String updatePlace(@Valid Place place, BindingResult result,
            ModelMap model, @PathVariable Integer id) {
 
        if (result.hasErrors()) {
            return "createPlace";
        }

        // Set recorder of place as currently logged in user
        User user = userService.findBySSO(getPrincipal());
        place.setRecorder(user);

        placeService.updatePlace(place);
 
        model.addAttribute("success", "Place " + place.getName() + " "+ place.getAddress() + " updated successfully");
        model.addAttribute("loggedinuser", getPrincipal());
        return "createPlaceSuccess";
    }

///////////////////////////////////////////////////////////////    
    /**
     * This method will delete an event by it's SSOID value.
     */
    @RequestMapping(value = { "/delete-event-{id}" }, method = RequestMethod.GET)
    public String deleteEvent(@PathVariable Integer id) {
        eventService.deleteEventById(id);
        return "redirect:/listEvents";
    }
     
    /**
     * This method will provide the medium to update an existing user.
     */
    @RequestMapping(value = { "/edit-event-{id}" }, method = RequestMethod.GET)
    public String editEvent(@PathVariable Integer id, ModelMap model) {
        Event event = eventService.findById(id);
        model.addAttribute("event", event);
        model.addAttribute("edit", true);
        model.addAttribute("loggedinuser", getPrincipal());
        return "createEvent";
    }

    @RequestMapping(value = { "/edit-event-{id}" }, method = RequestMethod.POST)
    public String updateEvent(@Valid Event event, BindingResult result,
            ModelMap model, @PathVariable Integer id) {
 
        if (result.hasErrors()) {
            return "createEvent";
        }

        eventService.updateEvent(event);
 
        model.addAttribute("success", "Event " + event.getName() + " "+ event.getDescription() + " updated successfully");
        model.addAttribute("loggedinuser", getPrincipal());
        return "createEventSuccess";
    }
 

////////////////////////////////////////////////////
    
    
    
    /**
     * This method will provide UserProfile list to views
     */
    @ModelAttribute("roles")
    public List<UserProfile> initializeProfiles() {
        return userProfileService.findAll();
    }


    @ModelAttribute("places")
    public List<Place> initializePlaces() {
        return placeService.findAllPlaces();
    }

    /**
     * This method handles Access-Denied redirect.
     */
    @RequestMapping(value = "/Access_Denied", method = RequestMethod.GET)
    public String accessDeniedPage(ModelMap model) {
        model.addAttribute("loggedinuser", getPrincipal());
        return "accessDenied";
    }
 
    /**
     * This method handles login GET requests.
     * If users is already logged-in and tries to goto login page again, will be redirected to list page.
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String loginPage() {
        if (isCurrentAuthenticationAnonymous()) {
            return "login";
        } else {
            return "redirect:/list";  
        }
    }
 
    /**
     * This method handles logout requests.
     * Toggle the handlers if you are RememberMe functionality is useless in your app.
     */
    @RequestMapping(value="/logout", method = RequestMethod.GET)
    public String logoutPage (HttpServletRequest request, HttpServletResponse response){
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null){    
            //new SecurityContextLogoutHandler().logout(request, response, auth);
            persistentTokenBasedRememberMeServices.logout(request, response, auth);
            SecurityContextHolder.getContext().setAuthentication(null);
        }
        return "redirect:/login?logout";
    }
 
    
    /**
     * This method returns the principal[user-name] of logged-in user.
     */
    private String getPrincipal(){
        String userName = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
 
        if (principal instanceof UserDetails) {
            userName = ((UserDetails)principal).getUsername();
        } else {
            userName = principal.toString();
        }
        return userName;
    }
     
    /**
     * This method returns true if users is already authenticated [logged-in], else false.
     */
    private boolean isCurrentAuthenticationAnonymous() {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authenticationTrustResolver.isAnonymous(authentication);
    }    
    
    
}