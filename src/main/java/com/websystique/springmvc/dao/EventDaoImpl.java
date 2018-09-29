package com.websystique.springmvc.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.websystique.springmvc.model.Event;
import com.websystique.springmvc.model.User;

@Repository("eventDao")
public class EventDaoImpl  extends AbstractDao<Integer, Event> implements EventDao {

	@Override
	public Event findById(int id) {
		Event event = getByKey(id);
        return event;
	}

	@Override
	public void save(Event event) {
		persist(event);	}

	@Override
	public List<Event> findAllEvents() {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
	}

	/**
	 * Get events for those who whants to assign. So all events should be in the future.
	 * @return
	 */
	@Override
	public List<Event> findEventsForAssign() {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
	}

	@Override
	public List<Event> findEventsInRange(Date from, Date to) {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        criteria.add(Restrictions.ge("when", from)); 
        criteria.add(Restrictions.lt("when", to));
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
	}

	private Date getCurrDayMidnight() {
	    // Get Calendar object set to the date and time of the given Date object
	    Calendar cal = Calendar.getInstance();
        Date date = new Date();
	    cal.setTime(date);
	      
	    // Set time fields to zero
	    cal.set(Calendar.HOUR_OF_DAY, 0);
	    cal.set(Calendar.MINUTE, 0);
	    cal.set(Calendar.SECOND, 0);
	    cal.set(Calendar.MILLISECOND, 0);
	      
	    // Put it back in the Date object
	    return cal.getTime();
		
	}
	
	@Override
	public List<Event> findEventsForVisitor() {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        
        criteria.add(Restrictions.ge("when", new Date())); 
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
	}

	@Override
	public List<Event> findEventsInRangByOrganizer(Date to, Date from, String organizerEmail) {
        Criteria criteria = createEntityCriteria().addOrder(Order.desc("when")); //organizer sees freshest events first
        criteria.createAlias("organizer", "org");
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        criteria.add(Restrictions.ge("when", to)); 
        criteria.add(Restrictions.lt("when", from));
        criteria.add(Restrictions.eq("org.email", organizerEmail));
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
	}

	@Override
	public List<Event> findEventsByOrganizer(String organizerEmail) {
        Criteria criteria = createEntityCriteria().addOrder(Order.desc("when")); //organizer sees freshest events first
        criteria.createAlias("organizer", "org");
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        criteria.add(Restrictions.eq("org.email", organizerEmail));
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
	}

	@Override
	public void deleteById(int id) {
        Criteria crit = createEntityCriteria();
        crit.add(Restrictions.eq("id", id));
        Event event = (Event)crit.uniqueResult();
        delete(event);
	}

	@Override
	public List<Event> findSuscribedEvents(String email) {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        criteria.createAlias("participants", "participant");
        criteria.add(Restrictions.eq("participant.email", email));
        criteria.add(Restrictions.ge("when", new Date())); 
        List<Event> events = (List<Event>) criteria.list();
         
        return events;
    }

	@Override
	public List<Event> findNotSubsribedEvents(String email) {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        //criteria.createAlias("participants", "participant");
        criteria.add(Restrictions.ge("when", new Date())); 
        List<Event> events = new ArrayList<Event>();
        List<Event> events2 = (List<Event>) criteria.list();
        for (Event event : events2) {
        	if (event.getOrganizer().getEmail().equals(email)) {
        		continue;
        	}
        	boolean add = true;
        	for (User user : event.getParticipants()) {
        		if (user.getEmail().equals(email)) {
        			add = false;
        			break;
        		}
        	}
        	if (add) {
        		events.add(event);
        	}
        }
        return events;
	}

}
