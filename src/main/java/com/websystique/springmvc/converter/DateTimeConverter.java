package com.websystique.springmvc.converter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.core.convert.converter.Converter;

public class DateTimeConverter   implements Converter<String, Date> {

	@Override
	public Date convert(String dateTime) {
		// 2018-02-24 01:30 - format example
        SimpleDateFormat formatter = new SimpleDateFormat("dd.MM.yyyy H:m");

        try {

            Date date = formatter.parse(dateTime);
            return date;

        } catch (ParseException e) {
            e.printStackTrace();
        }

		return null;
	}

}
