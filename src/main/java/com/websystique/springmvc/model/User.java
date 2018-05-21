package com.websystique.springmvc.model;
import java.util.HashSet;
import java.util.Set;
 
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
 
import org.hibernate.validator.constraints.NotEmpty;
 
@Entity
@Table(name="APP_USER")
public class User {
 
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Integer id;
 
    @NotEmpty
    @Column(name="SSO_ID", unique=true, nullable=false)
    private String ssoid;
     
    @Column(name="PASSWORD")
    private String password;
         
    @NotEmpty
    @Column(name="FIRST_NAME", nullable=false)
    private String firstName;
 
    @NotEmpty
    @Column(name="LAST_NAME", nullable=false)
    private String lastName;
 
    @NotEmpty
    @Column(name="EMAIL", nullable=false)
    private String email;
 
    @Column(name="SOC_UPIC_URL", nullable=true)
    private String socialProfImageURL;

    @NotEmpty
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "APP_USER_USER_PROFILE", 
             joinColumns = { @JoinColumn(name = "USER_ID") }, 
             inverseJoinColumns = { @JoinColumn(name = "USER_PROFILE_ID") })
    private Set<UserProfile> userProfiles = new HashSet<UserProfile>();
 
    @Enumerated(EnumType.STRING)
    @Column(name = "sign_in_provider", length = 20)
    private SocialMediaService signInProvider;
    
    public Integer getId() {
        return id;
    }
 
    public void setId(Integer id) {
        this.id = id;
    }
 
    public String getSsoid() {
        return ssoid;
    }
 
    public void setSsoid(String ssoId) {
        this.ssoid = ssoId;
    }
 
    public String getPassword() {
        return password;
    }
 
    public void setPassword(String password) {
        this.password = password;
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
 
    public String getEmail() {
        return email;
    }
 
    public void setEmail(String email) {
        this.email = email;
    }
 
    public Set<UserProfile> getUserProfiles() {
        return userProfiles;
    }
 
    public void setUserProfiles(Set<UserProfile> userProfiles) {
        this.userProfiles = userProfiles;
    }
 
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + ((ssoid == null) ? 0 : ssoid.hashCode());
        return result;
    }
 
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (!(obj instanceof User))
            return false;
        User other = (User) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        if (ssoid == null) {
            if (other.ssoid != null)
                return false;
        } else if (!ssoid.equals(other.ssoid))
            return false;
        return true;
    }
 
    @Override
    public String toString() {
        return "User [id=" + id + ", ssoId=" + ssoid + ", password=" + password
                + ", firstName=" + firstName + ", lastName=" + lastName
                + ", email=" + email + "]";
    }

	public SocialMediaService getSignInProvider() {
		return signInProvider;
	}

	public void setSignInProvider(SocialMediaService signInProvider) {
		this.signInProvider = signInProvider;
	}

	public String getSocialProfImageURL() {
		return socialProfImageURL;
	}

	public void setSocialProfImageURL(String socialURL) {
		this.socialProfImageURL = socialURL;
	}
 
}