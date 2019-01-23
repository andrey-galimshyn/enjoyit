package com.websystique.springmvc.dto;

public class UserDTO {
	
    private String firstName;
 
    private String lastName;
 
    private String email;
 
    private String socialProfURL;
    
    private String aboutMe;

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSocialProfURL() {
		return socialProfURL;
	}

	public void setSocialProfURL(String socialProfURL) {
		this.socialProfURL = socialProfURL;
	}

	public String getAboutMe() {
		return aboutMe;
	}

	public void setAboutMe(String aboutMe) {
		this.aboutMe = aboutMe;
	}

}
