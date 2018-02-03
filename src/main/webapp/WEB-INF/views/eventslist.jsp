<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Events List</title>
    <link href="<c:url value='/static/css/bootstrap.css' />" rel="stylesheet"></link>
    <link href="<c:url value='/static/css/app.css' />" rel="stylesheet"></link>
    <script type="text/javascript" src="<c:url value='/static/js/jquery-3.2.1.min.js' />"></script>


    <!-- Date Range picker -->
    <link rel="stylesheet" href="<c:url value='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css' />" />
	<link rel="stylesheet" href="<c:url value='/static/css/daterangepicker.min.css' />" />
	<script src="<c:url value='https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js" type="text/javascript' />"></script>
	<script src="<c:url value='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.16.0/moment.min.js" type="text/javascript' />"></script>
	<script src="<c:url value='/static/js/jquery.daterangepicker.js' />"></script>



</head>
 
<body>
<sec:authorize var="loggedIn" access="isAuthenticated()" />

<c:if test="${loggedIn}">
 <script type="text/javascript">
    var csrfParameter = '${_csrf.parameterName}';
    var csrfToken = '${_csrf.token}';    // join to the event
    function join(id) {
    	var jsonParams = {};
    	jsonParams['eventId'] = id;
    	jsonParams[csrfParameter] = csrfToken;
		$.ajax({
			type : "POST",
			contentType : "application/json",
			url : "${home}join",
			data : JSON.stringify(jsonParams),
			timeout : 100000,
			success : function(data) {
				var json = JSON.parse(data);
				console.log("SUCCESS: ", data, " ---- " , json['freeSpaces'], " ---- " , json.freeSpaces);
				document.getElementById(id + "jr").innerHTML = "reject";
				document.getElementById(id + "jr").setAttribute('onclick','reject(' + id + ');return false;');
				document.getElementById(id + "fs").innerHTML = json.freeSpaces;

			},
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
    };
    // reject from the event
    function reject(id) {
		$.ajax({
			type : "POST",
			contentType : "application/json",
			url : "${home}reject",
			data : JSON.stringify({"eventId":id}),
			timeout : 100000,
			success : function(data) {
				var json = JSON.parse(data);
				console.log("SUCCESS: ", data, " ---- " , json['freeSpaces'], " ---- " , json.freeSpaces);
				document.getElementById(id + "jr").innerHTML = "join";
				document.getElementById(id + "jr").setAttribute('onclick','join(' + id + ');return false;')
				document.getElementById(id + "fs").innerHTML = json.freeSpaces;
			},
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
    };
    
    // init date range picker
	$(function()
	{
		$('#date-range').dateRangePicker({
			language:'en'
		}).bind('datepicker-apply',function(event,obj){
			console.log('apply',obj);
			var url = window.location.href;   
			
			url = url.split('?')[0];
            url += '?range=' + obj.value;
			window.location.href = url;
		});
	});
    
</script>
</c:if>

    <div class="generic-container">
    
    
        <%@include file="authheader.jsp" %>
        <div class="panel panel-default">
        
        
        
            <c:if test="${loggedIn}">
                 <label for="date-range">Date Range: </label>
                <input id="date-range" value="${defaultRange}">         
            </c:if>



            <!-- Default panel contents -->
            <div class="panel-heading"><span class="lead">List of Events</span></div>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Organizer</th>
                        <th>Date and Time</th>
                        <th>Duration</th>
                        <th>Place</th>
                        <th>Total Places</th>
                        <th>Free Places</th>
                        <th width="100"></th>
                        <th width="100"></th>
                        <th width="100"></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${events}" var="event">
                    <tr>
                        <td>${event.name}</td>
                        <td>${event.description}</td>
                        <td>${event.organizer.firstName} ${event.organizer.lastName}</td>
                        <td>
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </td>
                        <td>
                            <c:set var="eventDuration" value="${event.duration}"/>
                            <c:set var="eventId" value="${event.id}"/>
							<% java.time.Duration duration = (java.time.Duration) (pageContext.getAttribute("eventDuration"));%>
							<%=String.format("%d:%02d:%02d", duration.getSeconds() / 3600, (duration.getSeconds() % 3600) / 60, (duration.getSeconds() % 60)) %>
                        </td>
                        <td>
                            ${event.place.name}
                        </td>
                        <td>
                            ${event.place.placesQuantity}
                        </td>
                        <td id="${event.id}fs">
                            ${event.place.placesQuantity - fn:length(event.participants)}
                        </td>
                        <sec:authorize access="isAuthenticated()">
	                        <c:if test="${event.organizer.ssoId != loggedinuser}">
	                   
								<c:set var="joined" value="false" />
								<c:forEach var="participant" items="${event.participants}">
								  <c:if test="${participant.ssoId eq loggedinuser}">
								    <c:set var="joined" value="true" />
								  </c:if>
								</c:forEach>	                        
	                        
								<c:if test="${joined}">
			                        <td>
			                            <a id="${event.id}jr" href="#" onclick="reject(${event.id});return false;">reject</a>   
			                        </td>
								</c:if>
	                            
								<c:if test="${joined != true}">
			                        <td>
			                            <a id="${event.id}jr" href="#" onclick="join(${event.id});return false;">join</a>   
			                        </td>
								</c:if>
	                        </c:if>
	                        
	                        <c:if test="${event.organizer.ssoId == loggedinuser}">
		                        <td>
		                            <a href="<c:url value='/edit-event-${event.id}' />" class="btn btn-success custom-width">edit</a>
		                        </td>
		                        <td>
		                            <a href="<c:url value='/delete-event-${event.id}' />" class="btn btn-danger custom-width">delete</a>
		                        </td>
	                        </c:if>
                        </sec:authorize>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <sec:authorize access="isAuthenticated()">
            <div class="well">
                <a href="<c:url value='/newevent' />">Add New Event</a>
            </div>
        </sec:authorize>
    </div>
</body>
</html>