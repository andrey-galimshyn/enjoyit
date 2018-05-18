
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

  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 

</head>
 
<body>
<sec:authorize var="loggedIn" access="isAuthenticated()" />

    <div class="generic-container">
    
        <%@include file="authheader.jsp" %>
        <div class="panel panel-default">
        
            <!-- Default panel contents -->
            <div class="panel-heading"><span class="lead"><spring:message code="events.list.listTitle"/></span></div>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th><spring:message code="events.list.title"/></th>
                        <th><spring:message code="events.list.dateTime"/></th>
                        <th><spring:message code="events.list.organizer"/></th>
                        <th><spring:message code="events.list.description"/></th>
                        <th><spring:message code="events.list.totalPlaces"/></th>
                        <th><spring:message code="events.list.freePlaces"/></th>
                        <th width="100"></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${events}" var="event">
                    <tr>
                        <sec:authorize access="isAuthenticated()">
                            <td>
                                <a href="<c:url value='/edit-event-${event.id}' />">${event.name}</a>
                            </td>
                        </sec:authorize>
                        <sec:authorize access="!isAuthenticated()">
                            <td>
                                ${event.name}
                            </td>
                        </sec:authorize>
                        <td>
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </td>
                        <td>
                           <c:if test="${not empty event.organizer.socialProfImageURL}">
                               <img src="${event.organizer.socialProfImageURL}" alt="Organizer userpic">
                           </c:if>
                           ${event.organizer.firstName} ${event.organizer.lastName} 
                        </td>
                        <td>${event.description}</td>
                        <td>
                            ${event.placeCount}
                        </td>
                        <td id="${event.id}fs">
                            ${event.placeCount - fn:length(event.participants)}
                        </td>
                        <sec:authorize access="isAuthenticated()">
	                        <c:if test="${event.organizer.email != loggedinuser}">
	                   
								<c:set var="joined" value="false" />
								<c:forEach var="participant" items="${event.participants}">
								  <c:if test="${participant.email eq loggedinuser}">
								    <c:set var="joined" value="true" />
								  </c:if>
								</c:forEach>	                        
	                        
								<c:if test="${joined}">
			                        <td>
			                            <a id="${event.id}jr" href="#" onclick="reject(${event.id});return false;"><spring:message code="events.list.reject"/></a>   
			                        </td>
								</c:if>
	                            
								<c:if test="${joined != true}">
			                        <td>
			                            <a id="${event.id}jr" href="#" onclick="join(${event.id});return false;"><spring:message code="events.list.join"/></a>   
			                        </td>
								</c:if>
	                        </c:if>
	                            
                        </sec:authorize>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>