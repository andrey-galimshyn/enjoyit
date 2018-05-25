package com.websystique.springmvc.model;

public enum UserProfileType {
    USER("USER"),
    ADMIN("ADMIN");
     
    String userProfileType;
     
    private UserProfileType(String userProfileType){
        this.userProfileType = userProfileType;
    }
     
    public String getUserProfileType(){
        return userProfileType;
    }
     
}