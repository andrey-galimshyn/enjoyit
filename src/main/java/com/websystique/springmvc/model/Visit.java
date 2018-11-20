package com.websystique.springmvc.model;

import java.util.Date;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.springframework.format.annotation.DateTimeFormat;

@Entity(name = "Visit")
@Table(name = "VISIT")
public class Visit implements Comparable<Visit>{
	
    private int id;
    
    private User user;
    private Event event;    
    
    
    @Id
    @GeneratedValue
    @Column(name = "USER_GROUP_ID")
    public int getId() {
        return id;
    }
 
    public void setId(int id) {
        this.id = id;
    }




	public Visit() {
	}
	




	@Column(name = "JOINED")
	private Boolean joined;

	@NotNull
	@Column(name = "LAST_UPDATE", nullable = false)
	@DateTimeFormat(pattern = "dd.MM.yyyy H:m:s")
	@Temporal(TemporalType.TIMESTAMP)
	private Date lastUpdate;

	public Boolean getJoined() {
		return joined;
	}

	public void setJoined(Boolean joined) {
		this.joined = joined;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "USER_ID")  
    public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "EVENT_ID")
    public Event getEvent() {
		return event;
	}

	public void setEvent(Event event) {
		this.event = event;
	}
	
	@Override
	public int compareTo(Visit o) {
	    return getLastUpdate().compareTo(o.getLastUpdate());
	}
}
