package com.websystique.springmvc.dao;

import com.websystique.springmvc.model.Visit;

public interface VisitDao {

	Visit findById(int id);

	void save(Visit visit);

}
