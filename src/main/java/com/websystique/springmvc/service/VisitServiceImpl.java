package com.websystique.springmvc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.websystique.springmvc.dao.VisitDao;
import com.websystique.springmvc.model.Visit;

@Service("visitService")
@Transactional
public class VisitServiceImpl  implements VisitService  {
	
    @Autowired
    private VisitDao dao;
	
	@Override
	public Visit findById(int id) {
		return dao.findById(id);
	}

	@Override
	public void saveVisit(Visit visit) {
		dao.save(visit);
	}

}
