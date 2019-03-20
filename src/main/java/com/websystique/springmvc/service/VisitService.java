package com.websystique.springmvc.service;

import com.websystique.springmvc.model.Visit;

public interface VisitService {
	
    Visit findById(int id);

	void saveVisit(Visit visit);

}
