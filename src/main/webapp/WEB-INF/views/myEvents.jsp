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
    window.onload = function() {
    	if (window.location.href.indexOf('#_=_') > 0) {
    		window.location = window.location.href.replace(/#.*/, '');
    	}
    }
  </script>
</c:if>

    <div class="generic-container">
    
        <%@include file="authheader.jsp" %>
        
        <div class="panel panel-default">
	        <sec:authorize access="isAuthenticated()">
	            <div class="well">
	                <a href="<c:url value='/newevent' />"><spring:message code="myevents.list.addNewEvent"/></a>
	            </div>
	        </sec:authorize>
            <!-- Default panel contents -->
            <div class="panel-heading"><span class="lead"><spring:message code="myevents.list.myListTitle"/></span></div>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th><spring:message code="myevents.list.title"/></th>
                        <th><spring:message code="myevents.list.dateTime"/></th>
                        <th><spring:message code="myevents.list.description"/></th>
                        <th><spring:message code="myevents.list.totalPlaces"/></th>
                        <th><spring:message code="myevents.list.freePlaces"/></th>
                        <th width="100"></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${events}" var="event">
                    <tr>
                        <td>${event.name}</td>
                        <td>
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </td>
                        <td>${event.description}</td>
                        <td>
                            ${event.placeCount}
                        </td>
                        <td id="${event.id}fs">
                            ${event.placeCount - fn:length(event.participants)}
                        </td>
                        <sec:authorize access="isAuthenticated()">
		                    <td>
	                            <a href="<c:url value='/edit-event-${event.id}' />" class="btn btn-success custom-width">edit</a>
	                        </td>
	                        <td>
	                            <a href="<c:url value='/delete-event-${event.id}' />" class="btn btn-danger custom-width">delete</a>
	                        </td>
                        </sec:authorize>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>