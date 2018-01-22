package com.websystique.springmvc.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.websystique.springmvc.model.Place;
import com.websystique.springmvc.model.User;

@Repository("placeDao")
public class PlaceDaoImpl extends AbstractDao<Integer, Place> implements PlaceDao {

	@Override
	public Place findById(int id) {
		Place place = getByKey(id);
        return place;
	}

	@Override
	public void save(Place place) {
		persist(place);	}

	@Override
	public List<Place> findAllPlaces() {
        Criteria criteria = createEntityCriteria().addOrder(Order.asc("name"));
        criteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);//To avoid duplicates.
        List<Place> places = (List<Place>) criteria.list();
         
        return places;
	}

	@Override
	public void deleteById(int id) {
        Criteria crit = createEntityCriteria();
        crit.add(Restrictions.eq("id", id));
        Place place = (Place)crit.uniqueResult();
        delete(place);
	}

}
