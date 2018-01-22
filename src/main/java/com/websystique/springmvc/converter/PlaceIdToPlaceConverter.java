package com.websystique.springmvc.converter;

import com.websystique.springmvc.model.Place;
import com.websystique.springmvc.service.PlaceService;

import org.springframework.core.convert.converter.Converter;

public class PlaceIdToPlaceConverter  implements Converter<String, Place> {
	
    private PlaceService placeService;

    public PlaceIdToPlaceConverter (PlaceService placeService) {
        this.placeService = placeService;
    }

	@Override
	public Place convert(String id) {
        try {
            Integer placeId = Integer.valueOf(id);
            return placeService.findById(placeId);
        } catch (NumberFormatException e) {
            return null;
        }
	}
	
}
