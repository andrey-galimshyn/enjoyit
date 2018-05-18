package com.websystique.springmvc.dao;

import java.util.Date;
import java.util.List;

import com.websystique.springmvc.model.Event;


public interface EventDao {
	
	Event findById(int id);
    
    void save(Event event);
    
    List<Event> findAllEvents();
    
    List<Event> findEventsInRange(Date from, Date to);
    
	List<Event> findEventsInRangByOrganizer(Date from, Date to, String organizerEmail);
    
    void deleteById(int id);

	List<Event> findEventsForAssign();

	List<Event> findEventsByOrganizer(String organizerEmail);

	List<Event> findEventsForVisitor();
	
	List<Event> findSuscribedEvents(String email);
	
	List<Event> findNotSubsribedEvents(String email);
	
}
