package com.websystique.springmvc.model;

import java.io.Serializable;

import javax.persistence.Embeddable;
import javax.persistence.ManyToOne;



@Embeddable
public  class VisitId implements Serializable{
	@ManyToOne
    private Event event;
 
	@ManyToOne
    private User user;

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event event) {
		this.event = event;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
 
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        VisitId that = (VisitId) o;

        if (event != null ? !event.equals(that.event) : that.event != null) return false;
        if (user != null ? !user.equals(that.user) : that.user != null)
            return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = (event != null ? event.hashCode() : 0);
        result = 31 * result + (user != null ? user.hashCode() : 0);
        return result;
    }
}
