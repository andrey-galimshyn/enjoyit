package com.websystique.springmvc.service;

import java.util.List;

import com.websystique.springmvc.model.Event;

public interface EventService {
    List<Event> findAllEvents();

    public void saveEvent(Event event);

    public void deleteEventById(Integer id);

    Event findById(int id);

	void updateEvent(Event event);

}
