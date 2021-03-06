package com.websystique.springmvc.model;

import java.time.Duration;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
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
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.format.annotation.DateTimeFormat;

@Entity(name="Event")
@Table(name="EVENT")
public class Event {
	
    @Id 
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Integer id;

    @NotNull
    @Column(name="DATE", nullable=false)
    @DateTimeFormat(pattern = "dd.MM.yyyy H:m")
    @Temporal(TemporalType.TIMESTAMP)
	private Date when;
	
    @Column(name="DURATION", nullable=true)
	private Duration duration;

    @NotEmpty
    @Column(name="NAME", nullable=false, columnDefinition="TEXT")
    private String name;
	
    @Column(name="DESCRIPTION", nullable=true, columnDefinition="TEXT")
    private String description;

    @Column(name="ADDRESS", nullable=true, columnDefinition="TEXT")
    private String address;

    @NotNull
    @Column(name="PLACE_COUNT", nullable=true)
	private Integer placeCount;

	@ManyToOne(optional = false)
	@JoinColumn(name = "ORGANIZER_ID")
	private User organizer;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "event", cascade=CascadeType.ALL)
    private Set<Visit> visits = new HashSet<Visit>();
    
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

	public Duration getDuration() {
		return duration;
	}

	public void setDuration(Duration duration) {
		this.duration = duration;
	}

	public User getOrganizer() {
		return organizer;
	}

	public void setOrganizer(User organizer) {
		this.organizer = organizer;
	}

	public Integer getPlaceCount() {
		return placeCount;
	}

	public void setPlaceCount(Integer placeCount) {
		this.placeCount = placeCount;
	}

	public Set<Visit> getVisits() {
		return visits;
	}

	public void setVisits(Set<Visit> visits) {
		this.visits = visits;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

}
