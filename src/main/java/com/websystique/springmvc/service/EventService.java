package com.websystique.springmvc.service;

import java.util.Date;
import java.util.List;

import com.websystique.springmvc.model.Event;

public interface EventService {
    List<Event> findAllEvents();

    List<Event> findEventsInRange(Date to, Date from);

    public List<Event> findEventsInRangByOrganizer(Date to, Date from, String organizerEmail);
    	 
    public void saveEvent(Event event);

    public void deleteEventById(Integer id);

    Event findById(int id);

	void updateEvent(Event event);

	List<Event> findEventsByOrganizer(String organizerEmail);

	List<Event> findSuscribedEvents(String organizerEmail);
	
	List<Event> findNotSubsribedEvents(String organizerEmail);
	
	List<Event> findEventsForVisitor();

}
