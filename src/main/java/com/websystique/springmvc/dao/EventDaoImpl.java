package com.websystique.springmvc.dao;

import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.websystique.springmvc.model.Event;

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

	public List<Event> findEventsInRange(Date to, Date from) {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("when"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        criteria.add(Restrictions.ge("when", to)); 
        criteria.add(Restrictions.lt("when", from));
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

}
