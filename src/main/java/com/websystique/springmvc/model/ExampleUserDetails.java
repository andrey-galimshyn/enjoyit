package com.websystique.springmvc.model;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.social.security.SocialUser;
 
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
 
public class ExampleUserDetails extends SocialUser {
 
    private Long id;
 
    private String firstName;
 
    private String lastName;
 
    private Set<UserProfile> userProfiles;
 
    private SocialMediaService socialSignInProvider;
 
    public ExampleUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }
 
    public static Builder getBuilder() {
        return new Builder();
    }
    
    public static class Builder {
 
        private Long id;
 
        private String username;
 
        private String firstName;
 
        private String lastName;
 
        private String password;
 
        //private UserProfileType role;
        
        private Set<UserProfile> userProfiles;
 
        public Set<UserProfile> getUserProfiles() {
			return userProfiles;
		}

		public void setUserProfiles(Set<UserProfile> userProfiles) {
			this.userProfiles = userProfiles;
		}

		private SocialMediaService socialSignInProvider;
 
        private Set<GrantedAuthority> authorities;
 
        public Builder() {
            this.authorities = new HashSet<>();
        }
 
        public Builder firstName(String firstName) {
            this.firstName = firstName;
            return this;
        }
 
        public Builder id(Long id) {
            this.id = id;
            return this;
        }
 
        public Builder lastName(String lastName) {
            this.lastName = lastName;
            return this;
        }
 
        public Builder password(String password) {
            if (password == null) {
                password = "SocialUser";
            }
 
            this.password = password;
            return this;
        }
 
        public Builder role(Set<GrantedAuthority> authorities) {
            this.authorities = authorities;
 
            return this;
        }
 
        public Builder socialSignInProvider(SocialMediaService socialSignInProvider) {
            this.socialSignInProvider = socialSignInProvider;
            return this;
        }
 
        public Builder username(String username) {
            this.username = username;
            return this;
        }
 
        public ExampleUserDetails build() {
            ExampleUserDetails user = new ExampleUserDetails(username, password, authorities);
 
            user.id = id;
            user.firstName = firstName;
            user.lastName = lastName;
            user.userProfiles = userProfiles;
            user.socialSignInProvider = socialSignInProvider;
 
            return user;
        }

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
    }
}