package com.websystique.springmvc.dao;

import java.util.List;

import com.websystique.springmvc.model.Place;

public interface PlaceDao {

	Place findById(int id);
     
    void save(Place place);
    
    List<Place> findAllPlaces();
    
    void deleteById(int id);

}
