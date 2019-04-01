package com.websystique.springmvc.controller;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.http.client.ClientProtocolException;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
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

import com.websystique.springmvc.dto.UserDTO;
import com.websystique.springmvc.model.Event;
import com.websystique.springmvc.model.JoinMeUserDetails;
import com.websystique.springmvc.model.Place;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;
import com.websystique.springmvc.model.Visit;
import com.websystique.springmvc.service.EmailService;
import com.websystique.springmvc.service.EventService;
import com.websystique.springmvc.service.PlaceService;
import com.websystique.springmvc.service.UserProfileService;
import com.websystique.springmvc.service.UserService;
import com.websystique.springmvc.service.VisitService;

import org.apache.poi.ss.usermodel.*;



@Controller
@RequestMapping("/")
@SessionAttributes("roles")
public class AppController {
	
	@Autowired
	UserService userService;

	@Autowired
	EventService eventService;

	@Autowired
	VisitService visitService;

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
	@RequestMapping(value = { "/join" }, method = RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public String joinLoggedUserToEvent(@RequestBody String requestBody, HttpServletRequest request) throws ParseException, MessagingException, MalformedURLException, URISyntaxException {
		// parse event id
	    		
	    		
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(requestBody);
		Integer eventId = Integer.parseInt(json.get("eventId").toString());
		// get user and join she to event
		User user = userService.findByEmail(getPrincipalEmail());
		Event event = eventService.findById(eventId);
		
		// use intermediate entuty
		Set<Visit> visits = event.getVisits();
		boolean returned = false;
		for (Visit visit : event.getVisits()) {
			// user decided to return after reject
			if (visit.getUser().getId().equals(user.getId())) {
				visit.setJoined(1);
				visit.setLastUpdate(new Date());
				returned = true;
				break;
			}
		}
        // new user joined
		if (!returned) {
			Visit visit = new Visit();
			visit.setJoined(1);
			visit.setLastUpdate(new Date());
			visit.setUser(user);
			visit.setEvent(event);
			visits.add(visit);
			event.setVisits(visits);
		}
		//
		eventService.saveEvent(event);

	    URL url = new URL(request.getRequestURL().toString());
	    String host  = url.getHost();
	    String scheme = url.getProtocol();
	    String uri = scheme + "://" + host + "/event-details-" + event.getId();

		emailService.sendEmail(event.getOrganizer().getEmail(),
				user.getFirstName() + " " + user.getLastName() + " has Joined",
				getEmailBody(event, user.getFirstName() + " " + user.getLastName(), uri, true));

		return "{\"message\":\"Handled application/json request\", \"freeSpaces\": \""
				+ (event.getPlaceCount() - visits.size()) + "\" }";
	}

	@Transactional
	@RequestMapping(value = { "/missed" }, method = RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public void blameHookyUser(@RequestBody String requestBody, HttpServletRequest request) throws ParseException, MessagingException, MalformedURLException, URISyntaxException {
        //
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(requestBody);
		Integer visitId = Integer.parseInt(json.get("visitId").toString());
		Boolean checked = Boolean.parseBoolean(json.get("missed").toString());
		
		// get user and join she to event
		Visit visit = visitService.findById(visitId);
		visit.setMissed(checked ? 1 : 0);
		
		visitService.saveVisit(visit);
	}

	@Transactional
	@RequestMapping(value = { "/reject" }, method = RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public String rejectLoggedUserFromEvent(@RequestBody String requestBody, HttpServletRequest request) throws ParseException, MalformedURLException, URISyntaxException {
		// parse event id
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(requestBody);
		Integer eventId = Integer.parseInt(json.get("eventId").toString());
		// get user and remove him from event participants
		User user = userService.findByEmail(getPrincipalEmail());
		Event event = eventService.findById(eventId);

		Set<Visit> visits = event.getVisits();		
		for (Visit visit : visits) {
			// user decided to return after reject
			if (visit.getUser().getId().equals(user.getId())) {
				visit.setJoined(0);
				visit.setLastUpdate(new Date());
				break;
			}
		}
		
		eventService.saveEvent(event);
		// email to organizer
	    URL url = new URL(request.getRequestURL().toString());
	    String host  = url.getHost();
	    String scheme = url.getProtocol();
	    String uri = scheme + "://" + host + "/event-details-" + event.getId();
		emailService.sendEmail(event.getOrganizer().getEmail(),
				user.getFirstName() + " " + user.getLastName() + " has Left",
				getEmailBody(event,	user.getFirstName() + " " + user.getLastName(), uri, false));

		return "{\"message\":\"Handled application/json request\", \"freeSpaces\": \""
				+ (event.getPlaceCount() - visits.size()) + "\" }";
	}

	private String getEmailBody(Event event, String hero, String url, boolean joined) {
		StringBuffer emailBody = new StringBuffer();
		emailBody.append("Hello Dear " + event.getOrganizer().getFirstName() + " " + event.getOrganizer().getLastName() + "<br><br>");
		if (joined) {
			emailBody.append(hero + " has joined <br><br>");
		} else {
			emailBody.append(hero + " unfortunately has left <br><br>");
		}
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		emailBody.append("Event: " + 
				"<a href=\"" + url + "\"> "  + event.getName() + "</a>"  
				 
		
		        + " at " + dateFormat.format(event.getWhen()) + "<br><br>");
		emailBody.append("Total participants count: " + event.getVisits().size() + "<br>");
		for (Visit visit : event.getVisits()) {
			emailBody.append(visit.getUser().getFirstName() + " " + visit.getUser().getLastName() + "<br>");
		}
		emailBody.append("<br>");
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
		model.addAttribute("loggedinuser", getPrincipalName());
		return "userslist";
	}

	@RequestMapping(value = { "/listPlaces" }, method = RequestMethod.GET)
	public String listPlaces(ModelMap model) {
		List<Place> places = placeService.findAllPlaces();
		model.addAttribute("places", places);
		model.addAttribute("loggedinuser", getPrincipalName());
		return "placeslist";
	}

	@RequestMapping(value = { "/", "/listEvents" }, method = RequestMethod.GET)
	public String listEvents(ModelMap model, @RequestParam(value = "subscribed", required = false) String subscribed) throws java.text.ParseException {
		List<Event> events = new ArrayList<Event>();
    	events = eventService.findEventsForVisitor();
		model.addAttribute("events", events);
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("loggedinuserEmail", getPrincipalEmail());
		return "eventslist";
	}

	@RequestMapping(value = { "/subscribed" }, method = RequestMethod.GET)
	public String subscribedEvents(ModelMap model) {
		List<Event> events = new ArrayList<Event>();
    	events = eventService.findSuscribedEvents(getPrincipalEmail());
		model.addAttribute("events", events);
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("loggedinuserEmail", getPrincipalEmail());
		return "eventsSubscribed";
	}

	@RequestMapping(value = {"/report" }, method = RequestMethod.GET)
	public String eventsReport(ModelMap model, @RequestParam(value = "start", required = false) Long start,
			@RequestParam(value = "end", required = false) Long end) {
		List<Event> events = new ArrayList<Event>();

		if (start == null || end == null) {
			LocalDate previousMonthSameDay = LocalDate.now().minus(1, ChronoUnit.MONTHS);
			Date startdate = Date.from(previousMonthSameDay.atStartOfDay(ZoneId.systemDefault()).toInstant());
			LocalDateTime tomorrowIncluding = LocalDate.now().plusDays(1).atTime(LocalTime.MAX); 
			Date endDate = Date.from(tomorrowIncluding.atZone(ZoneId.systemDefault()).toInstant());
			//Date endDate = Date.from(tomorrow.atStartOfDay(ZoneId.systemDefault()).toInstant());
			model.addAttribute("startMs", startdate.getTime());
			model.addAttribute("endMs", endDate.getTime());
			events = eventService.findEventsInRangByOrganizer(startdate, endDate, getPrincipalEmail());
		} else {
			model.addAttribute("startMs", start);
			model.addAttribute("endMs", end);
			events = eventService.findEventsInRangByOrganizer(new Date(start), new Date(end), getPrincipalEmail());
		}

		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("events", events);
		return "eventsReport";
	}

	@RequestMapping(value = {"/report-download" }, produces = MediaType.APPLICATION_OCTET_STREAM_VALUE , method = RequestMethod.GET)
	@ResponseBody
	public void eventsReportDownload(HttpServletResponse response,
			@RequestParam(value = "start", required = false) Long start,
			@RequestParam(value = "end", required = false) Long end) throws IOException {

    	File temp = File.createTempFile("tempfile", ".tmp");
		
		Workbook workbook = new XSSFWorkbook();
		//
		CreationHelper createHelper = workbook.getCreationHelper();
		CellStyle dateCellStyle = workbook.createCellStyle();
        dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));
        //
		Sheet sheet = workbook.createSheet("Report");
		// Create header 
		Row headerRow = sheet.createRow(0);
		Cell cell = headerRow.createCell(0);
		cell.setCellValue("Name");
		cell = headerRow.createCell(1);
		cell.setCellValue("Date");
		cell = headerRow.createCell(2);
		cell.setCellValue("Description");
		cell = headerRow.createCell(3);
		cell.setCellValue("Occupied places");
		//
		List<Event> events = eventService.findEventsInRangByOrganizer(new Date(start), new Date(end), getPrincipalEmail());
		int rowNum = 1;
		for (Event event : events) {
			Row row = sheet.createRow(rowNum++);
			row.createCell(0).setCellValue(event.getName());
			//
			Cell dateCell = row.createCell(1);
			dateCell.setCellStyle(dateCellStyle);
			dateCell.setCellValue(event.getWhen());
			//
			row.createCell(2).setCellValue(event.getDescription());
			row.createCell(3).setCellValue(event.getVisits().size());
						
		    for (Visit visit : event.getVisits()) {
		    	Row rowVisitor = sheet.createRow(rowNum++);
		    	rowVisitor.createCell(0).setCellValue(visit.getUser().getFirstName() + " " + visit.getUser().getLastName());
		    	rowVisitor.createCell(1).setCellValue(visit.getUser().getEmail());
		    }
		}
	    
		// Resize all columns to fit the content size
        for(int i = 0; i < 4; i++) {
            sheet.autoSizeColumn(i);
        }
		
        // Write the output to a file
        FileOutputStream fileOut = new FileOutputStream(temp);
        workbook.write(fileOut);
        fileOut.close();

        // Closing the workbook
        workbook.close();
        Format formatter = new SimpleDateFormat("yyyy-MM-dd");
    	response.setContentType("application/octet-stream");
    	response.setHeader("Content-Disposition", String.format("inline; filename=\"report"  + 
    	    formatter.format(new Date(start)) + "_" +
    	    formatter.format(new Date(end)) +
    	    ".xlsx\""));
    	response.setContentLength((int)temp.length());

    	InputStream inputStream = new BufferedInputStream(new FileInputStream(temp));
    	FileCopyUtils.copy(inputStream, response.getOutputStream());

	}

	/**
	 * This method will provide the medium to add a new user.
	 */
	@RequestMapping(value = { "/userprofile-{id}" }, method = RequestMethod.GET)
	public String editProfile(@PathVariable Integer id, ModelMap model) {
		User user = userService.findById(id);
		UserDTO userDTO = new UserDTO();
		userDTO.setAboutMe(user.getAboutMe());
		userDTO.setEmail(user.getEmail());
		userDTO.setFirstName(user.getFirstName());
		userDTO.setLastName(user.getLastName());
		userDTO.setSocialProfURL(user.getSocialProfURL());
		//
		model.addAttribute("user", userDTO);
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("loggedinuserEmail", getPrincipalEmail());
		return "userProfile";
	}
	
	@RequestMapping(value = { "/userprofile-{id}" }, method = RequestMethod.POST)
	public String saveProfile(@Valid UserDTO user, BindingResult result, ModelMap model) {
		if (result.hasErrors()) {
			return "userProfile";
		}
		User userUpdate = userService.findByEmail(user.getEmail());
		userUpdate.setAboutMe(user.getAboutMe());
		userUpdate.setSocialProfURL(user.getSocialProfURL());
		userUpdate.setFirstName(user.getFirstName());
		userUpdate.setLastName(user.getLastName());

		userService.updateUser(userUpdate);

		return "redirect:/listEvents";
	}

	/**
	 * This method will provide the medium to add a new user.
	 */
	@RequestMapping(value = { "/newuser" }, method = RequestMethod.GET)
	public String newUser(ModelMap model) {
		User user = new User();
		model.addAttribute("user", user);
		model.addAttribute("edit", false);
		model.addAttribute("loggedinuser", getPrincipalName());
		return "createUser";
	}

	/**
	 * This method will be called on form submission, handling POST request for
	 * saving user in database. It also validates the user input
	 */
	@RequestMapping(value = { "/newuser" }, method = RequestMethod.POST)
	public String saveUser(@Valid User user, BindingResult result, ModelMap model) {

		if (result.hasErrors()) {
			return "createUser";
		}

		/*
		 * Preferred way to achieve uniqueness of field [sso] should be implementing
		 * custom @Unique annotation and applying it on field [sso] of Model class
		 * [User].
		 * 
		 * Below mentioned peace of code [if block] is to demonstrate that you can fill
		 * custom errors outside the validation framework as well while still using
		 * internationalized messages.
		 * 
		 */
		if (!userService.isUserSSOUnique(user.getId(), user.getSsoid())) {
			FieldError ssoError = new FieldError("user", "ssoid", messageSource.getMessage("non.unique.ssoId",
					new String[] { user.getSsoid() }, Locale.getDefault()));
			result.addError(ssoError);
			return "createUser";
		}

		userService.saveUser(user);

		model.addAttribute("success",
				"User " + user.getFirstName() + " " + user.getLastName() + " registered successfully");
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("user", user.getFirstName() + " " + user.getLastName());
		model.addAttribute("operation", "new");
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
		model.addAttribute("loggedinuser", getPrincipalName());
		return "createPlace";
	}

	/**
	 * This method will be called on form submission, handling POST request for
	 * saving user in database. It also validates the user input
	 */
	@RequestMapping(value = { "/newplace" }, method = RequestMethod.POST)
	public String savePlace(@Valid Place place, BindingResult result, ModelMap model) {

		if (result.hasErrors()) {
			return "createPlace";
		}
		// Set recorder of place as currently logged in user
		User user = userService.findByEmail(getPrincipalEmail());
		place.setRecorder(user);

		placeService.savePlace(place);

		model.addAttribute("success",
				"Place " + place.getName() + " " + place.getAddress() + " registered successfully");
		model.addAttribute("loggedinuser", getPrincipalName());
		return "createPlaceSuccess";
	}

	/**
	 * This method will provide the medium to add a new user.
	 */
	@RequestMapping(value = { "/newevent" }, method = RequestMethod.GET)
	public String newEvent(ModelMap model) {
		Event event = new Event();
		model.addAttribute("event", event);
		model.addAttribute("newEvent", true);
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("loggedinuserEmail", getPrincipalEmail());
		return "eventDetails";
	}

	/**
	 * This method will be called on form submission, handling POST request for
	 * saving user in database. It also validates the user input
	 */
	@RequestMapping(value = { "/newevent" }, method = RequestMethod.POST)
	public String saveEvent(@Valid Event event, BindingResult result, ModelMap model) {

		if (result.hasErrors()) {
			return "eventDetails";
		}

		// Logged user is organizer of the event
		User organizer = userService.findByEmail(getPrincipalEmail());
		event.setOrganizer(organizer);

		String textToDecode = removeBadChars(event.getDescription());
		event.setDescription(textToDecode);
		textToDecode = removeBadChars(event.getName());
		event.setName(textToDecode);
		
		eventService.saveEvent(event);

		model.addAttribute("create", true);
		model.addAttribute("name", event.getName());

		model.addAttribute("loggedinuser", getPrincipalName());
		return "redirect:/listEvents";
	}

	private static String removeBadChars(String s) {
		  if (s == null) return null;
		  StringBuilder sb = new StringBuilder();
		  for(int i=0;i<s.length();i++){ 
		    if (Character.isHighSurrogate(s.charAt(i))) continue;
		    sb.append(s.charAt(i));
		  }
		  return sb.toString();
	}
	
	@RequestMapping(value = { "/delete-user-{ssoid}" }, method = RequestMethod.GET)
	public String deleteUser(@PathVariable String ssoid) {
		userService.deleteUserBySSO(ssoid);
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
		model.addAttribute("loggedinuser", getPrincipalName());
		return "createUser";
	}

	/**
	 * This method will be called on form submission, handling POST request for
	 * updating user in database. It also validates the user input
	 */
	@RequestMapping(value = { "/edit-user-{ssoId}" }, method = RequestMethod.POST)
	public String updateUser(@Valid User user, BindingResult result, ModelMap model, @PathVariable String ssoId) {

		if (result.hasErrors()) {
			return "createUser";
		}

		/*
		 * //Uncomment below 'if block' if you WANT TO ALLOW UPDATING SSO_ID in UI which
		 * is a unique key to a User. if(!userService.isUserSSOUnique(user.getId(),
		 * user.getSsoId())){ FieldError ssoError =new
		 * FieldError("user","ssoId",messageSource.getMessage("non.unique.ssoId", new
		 * 
		 * String[]{user.getSsoId()}, Locale.getDefault())); result.addError(ssoError);
		 * return "registration"; }
		 */

		userService.updateUser(user);

		model.addAttribute("user", user.getFirstName() + " " + user.getLastName());
		model.addAttribute("operation", "edit");
		model.addAttribute("loggedinuser", getPrincipalName());
		return "registrationsuccess";
	}

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
		model.addAttribute("loggedinuser", getPrincipalName());
		return "createPlace";
	}

	@RequestMapping(value = { "/delete-event" }, method = RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public String deleteEvent(@RequestBody String requestBody) throws ParseException {
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(requestBody);
		Integer id = Integer.parseInt(json.get("id").toString());
		Event event = eventService.findById(id);
		if (event.getOrganizer().getEmail().equals(getPrincipalEmail()) ) {
		    eventService.deleteEventById(id);
		}
		return "redirect:/listEvents";
	}

	/**
	 * This method will provide the medium to update an existing user.
	 */
	@RequestMapping(value = { "/event-details-{id}" }, method = RequestMethod.GET)
	public String editEvent(@PathVariable Integer id, ModelMap model) {
		//
        //
		Event event = eventService.findById(id);
		List<Visit> visits = new ArrayList<Visit>(event.getVisits());
		Collections.sort(visits);
		model.addAttribute("event", event);
		model.addAttribute("visits", visits);
		model.addAttribute("edit", true);
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("loggedinuserEmail", getPrincipalEmail());
		return "eventDetails";
	}

	@RequestMapping(value = { "copy-event-{id}" }, method = RequestMethod.GET)
	public String copyEvent(@PathVariable Integer id, ModelMap model) {
		//
		Event event = eventService.findById(id);
		Set<Visit> visits = new HashSet<Visit>();
		//
		Event copiedEvent = new Event();
		copiedEvent.setVisits(visits);
		copiedEvent.setDescription(event.getDescription());
		copiedEvent.setDuration(event.getDuration());
		copiedEvent.setName("COPY " + event.getName());
		copiedEvent.setOrganizer(event.getOrganizer());
		copiedEvent.setPlaceCount(event.getPlaceCount());
		copiedEvent.setWhen(event.getWhen());
		copiedEvent.setAddress(event.getAddress());
		//
		model.addAttribute("event", copiedEvent);
		model.addAttribute("visits", visits);
		model.addAttribute("edit", false);
		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("loggedinuserEmail", getPrincipalEmail());
		return "eventDetails";
	}

	@RequestMapping(value = { "copy-event-{id}" }, method = RequestMethod.POST)
	public String copyEventSave(@Valid Event event, BindingResult result, ModelMap model, @PathVariable Integer id) {
		if (result.hasErrors()) {
			return "eventDetails";
		}
		String textToDecode = removeBadChars(event.getDescription());
		event.setDescription(textToDecode);
		textToDecode = removeBadChars(event.getName());
		event.setName(textToDecode);
		
		User organizer = userService.findByEmail(getPrincipalEmail());
		event.setOrganizer(organizer);
		
		eventService.saveEvent(event);

		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("create", false);
		model.addAttribute("name", event.getName());

		return "redirect:/listEvents";
	}
	
	@RequestMapping(value = { "/event-details-{id}" }, method = RequestMethod.POST)
	public String updateEvent(@Valid Event event, BindingResult result, ModelMap model, @PathVariable Integer id) {

		if (result.hasErrors()) {
			return "eventDetails";
		}
		String textToDecode = removeBadChars(event.getDescription());
		event.setDescription(textToDecode);
		textToDecode = removeBadChars(event.getName());
		event.setName(textToDecode);
		
		eventService.updateEvent(event);

		model.addAttribute("loggedinuser", getPrincipalName());
		model.addAttribute("create", false);
		model.addAttribute("name", event.getName());

		return "redirect:/listEvents";
	}

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
		model.addAttribute("loggedinuser", getPrincipalName());
		return "accessDenied";
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginPage(HttpServletRequest request) {
		if (isCurrentAuthenticationAnonymous()) {
			return "login";
		} else {
			return "redirect:/list";
		}
	}

	/**
	 * This method handles logout requests. Toggle the handlers if you are
	 * RememberMe functionality is useless in your app.
	 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			persistentTokenBasedRememberMeServices.logout(request, response, auth);
			SecurityContextHolder.getContext().setAuthentication(null);
		}
		return "redirect:/login?logout";
	}

	/**
	 * This method returns the principal[user-name] of logged-in user.
	 */
	private String getPrincipalEmail() {
		String userName = null;
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

		if (principal instanceof UserDetails) {
			userName = ((UserDetails) principal).getUsername();
		} else {
			userName = principal.toString();
		}
		return userName;
	}

	@ModelAttribute("principalId")
	public String getPrincipalId(){
		String principalId = null;

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth == null) {
			return principalId;
		}

		Object principal = auth.getPrincipal();
		if (principal instanceof JoinMeUserDetails) {
			principalId = ((JoinMeUserDetails) principal).getId().toString();
		} 		
		return principalId;
	}

	private String getPrincipalName() {
		String userName = null;
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

		if (principal instanceof JoinMeUserDetails) {
			userName = ((JoinMeUserDetails) principal).getFirstName() + " " + ((JoinMeUserDetails) principal).getLastName();
		} else {
			userName = principal.toString();
		}
		return userName;
	}

	/**
	 * This method returns true if users is already authenticated [logged-in], else
	 * false.
	 */
	private boolean isCurrentAuthenticationAnonymous() {
		final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		return authenticationTrustResolver.isAnonymous(authentication);
	}

}