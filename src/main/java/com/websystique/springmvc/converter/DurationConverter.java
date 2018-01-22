package com.websystique.springmvc.converter;

import java.time.Duration;

import org.springframework.core.convert.converter.Converter;

public class DurationConverter implements Converter<Object, Duration>{
    public Duration convert(Object element) {
        Long seconds = Long.parseLong((String)element);
        Duration duration = Duration.ofSeconds(seconds);
        return duration;
    }

}
