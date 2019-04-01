package com.websystique.springmvc.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.websystique.springmvc.dao.EventDao;
import com.websystique.springmvc.model.Event;

@Service("eventService")
@Transactional
public class EventServiceImpl implements EventService {
	
    @Autowired
    private EventDao dao;

    public List<Event> findAllEvents() {
        return dao.findAllEvents();
    }

    public List<Event> findEventsInRange(Date to, Date from) {
    	return dao.findEventsInRange(to, from);
    }

    public List<Event> findEventsInRangByOrganizer(Date to, Date from, String organizerEmail) {
    	return dao.findEventsInRangByOrganizer(to, from, organizerEmail);
    }

    @Override
    public List<Event> findEventsForVisitor() {
    	return dao.findEventsForVisitor();
    }
    
    @Override
    public List<Event> findEventsByOrganizer(String organizerEmail) {
    	return dao.findEventsByOrganizer(organizerEmail);
    }

    public void saveEvent(Event event) {
        dao.save(event);
    }

    public void deleteEventById(Integer id) {
        dao.deleteById(id);
    }

    @Override
    public Event findById(int id) {
        return dao.findById(id);
    }

    @Override
    public void updateEvent(Event event) {
    	Event entity = dao.findById(event.getId());
        if(entity!=null){
            entity.setName(event.getName());
            entity.setDescription(event.getDescription());
            entity.setPlaceCount(event.getPlaceCount());
            entity.setWhen(event.getWhen());
            entity.setDuration(event.getDuration());
            entity.setAddress(event.getAddress());
        }
    }

	@Override
	public List<Event> findSuscribedEvents(String email) {
		return dao.findSuscribedEvents(email);
	}

	@Override
	public List<Event> findNotSubsribedEvents(String email) {
		return dao.findNotSubsribedEvents(email);
	}

}
