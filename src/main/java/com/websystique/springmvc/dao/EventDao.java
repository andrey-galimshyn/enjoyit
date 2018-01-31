package com.websystique.springmvc.dao;

import java.util.Date;
import java.util.List;

import com.websystique.springmvc.model.Event;


public interface EventDao {
	
	Event findById(int id);
    
    void save(Event event);
    
    List<Event> findAllEvents();
    
    List<Event> findEventsInRange(Date to, Date from);
    
    void deleteById(int id);
}
