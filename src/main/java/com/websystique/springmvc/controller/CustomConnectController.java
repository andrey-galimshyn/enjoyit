package com.websystique.springmvc.controller;

import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.web.bind.annotation.RequestMapping;



@RequestMapping("/connect")
public class CustomConnectController  extends org.springframework.social.connect.web.ConnectController {

    public CustomConnectController (ConnectionFactoryLocator connectionFactoryLocator,  ConnectionRepository connectionRepository) {
        super(connectionFactoryLocator, connectionRepository);
    }

    @Override
    protected String connectedView(String providerId) {
        return "redirect:/connect/" + providerId + "/response";
    }

}