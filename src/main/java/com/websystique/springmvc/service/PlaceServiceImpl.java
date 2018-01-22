package com.websystique.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.websystique.springmvc.dao.PlaceDao;
import com.websystique.springmvc.model.Place;
import com.websystique.springmvc.model.User;

@Service("placeService")
@Transactional
public class PlaceServiceImpl implements PlaceService {

    @Autowired
    private PlaceDao dao;

    public List<Place> findAllPlaces() {
        return dao.findAllPlaces();
    }

    public void savePlace(Place place) {
        dao.save(place);
    }

    public void deletePlaceById(Integer id) {
        dao.deleteById(id);
    }

    @Override
    public Place findById(int id) {
        return dao.findById(id);
    }

    @Override
    public void updatePlace(Place place) {
        Place entity = dao.findById(place.getId());
        if(entity!=null){
            entity.setName(place.getName());
            entity.setAddress(place.getAddress());
            entity.setPlacesQuantity(place.getPlacesQuantity());
        }
    }

}
