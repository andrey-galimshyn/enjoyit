package com.websystique.springmvc.dao;

import org.springframework.stereotype.Repository;

import com.websystique.springmvc.model.Visit;

@Repository("visitDao")
public class VisitDaoImpl  extends AbstractDao<Integer, Visit>  implements VisitDao {

	@Override
	public Visit findById(int id) {
		Visit visit = getByKey(id);
        return visit;
	}

	@Override
	public void save(Visit visit) {
		persist(visit);
	}

}
