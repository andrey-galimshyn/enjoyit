package com.websystique.springmvc.model;

import java.time.Duration;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name="EVENT")
public class Event {
	
    @Id @GeneratedValue(strategy=GenerationType.AUTO)
    private Integer id;

    @Column(name="DATE", nullable=false)
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    @Temporal(TemporalType.DATE)
	private Date when;
	
    @Column(name="DURATION", nullable=false)
	private Duration duration;

    @Column(name="NAME")
    private String name;
	
    @NotEmpty
    @Column(name="DESCRIPTION", nullable=false)
    private String description;

	@ManyToOne(optional = false)
	@JoinColumn(name = "PLACE_ID")
	private Place place;

	@ManyToOne(optional = false)
	@JoinColumn(name = "ORGANIZER_ID")
	private User organizer;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "EVENT_PARTICIPANT", 
             joinColumns = { @JoinColumn(name = "EVENT_ID") }, 
             inverseJoinColumns = { @JoinColumn(name = "USER_ID") })
    private Set<User> participants = new HashSet<User>();

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Date getWhen() {
		return when;
	}

	public void setWhen(Date when) {
		this.when = when;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Place getPlace() {
		return place;
	}

	public void setPlace(Place place) {
		this.place = place;
	}

	public Duration getDuration() {
		return duration;
	}

	public void setDuration(Duration duration) {
		this.duration = duration;
	}

	public Set<User> getParticipants() {
		return participants;
	}

	public void setParticipants(Set<User> participants) {
		this.participants = participants;
	}

	public User getOrganizer() {
		return organizer;
	}

	public void setOrganizer(User organizer) {
		this.organizer = organizer;
	}

}
