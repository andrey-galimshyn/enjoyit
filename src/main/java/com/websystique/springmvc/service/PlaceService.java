package com.websystique.springmvc.service;

import java.util.List;

import com.websystique.springmvc.model.Place;

public interface PlaceService {
 
    List<Place> findAllPlaces();

    public void savePlace(Place place);

    public void deletePlaceById(Integer id);

	Place findById(int id);

	void updatePlace(Place place);
}