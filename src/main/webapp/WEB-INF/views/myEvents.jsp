<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="myevents.list.myListTitle"/></title>
</head>
 
<body>
    <sec:authorize var="loggedIn" access="isAuthenticated()" />


    <div align="center">
    
        <%@include file="authheader.jsp" %>
        
        <div class="body-container" align="left">
	        <sec:authorize access="isAuthenticated()">
	            <div>
	                <a class="buttonlink" href="<c:url value='/newevent' />"><spring:message code="myevents.list.addNewEvent"/></a>
	            </div>
	        </sec:authorize>
            <!-- Default panel contents -->
            <table class="zui-table">
                <thead>
                    <tr>
                        <th><spring:message code="myevents.list.title"/></th>
                        <th><spring:message code="myevents.list.dateTime"/></th>
                        <th><spring:message code="myevents.list.description"/></th>
                        <th><spring:message code="myevents.list.totalPlaces"/></th>
                        <th><spring:message code="myevents.list.freePlaces"/></th>
                        <th colspan="2"></th>
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
	                            <a class="editButtonlink" href="<c:url value='/edit-event-${event.id}' />">edit</a>
	                        </td>
	                        <td>
	                            <a class="deleteButtonlink" href="<c:url value='/delete-event-${event.id}' />">delete</a>
	                        </td>
                        </sec:authorize>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <%@include file="footer.jsp" %>

    </div>
</body>
</html>