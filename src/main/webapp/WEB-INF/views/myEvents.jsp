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
            <div class="rTable">
                 <div class="rTableHeadRow">

                        <div class="rTableHeadCell"><spring:message code="myevents.list.title"/></div>
                        <div class="rTableHeadCell"><spring:message code="myevents.list.dateTime"/></div>
                        <div class="rTableHeadCell"><spring:message code="myevents.list.description"/></div>
                        <div class="rTableHeadCell"><spring:message code="myevents.list.totalPlaces"/></div>
                        <div class="rTableHeadCell"><spring:message code="myevents.list.freePlaces"/></div>
                        <div class="rTableHeadCell"></div>
                        <div class="rTableHeadCell"></div>

                </div>

                <c:forEach items="${events}" var="event">
                    <div class="rTableRow">
                        <div class="rTableCell">${event.name}</div>
                        <div class="rTableCell">
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </div>
                        <div class="rTableCell">${event.description}</div>
                        <div class="rTableCell">
                            ${event.placeCount}
                        </div>
                        <div class="rTableCell" id="${event.id}fs">
                            ${event.placeCount - fn:length(event.participants)}
                        </div>
                        <sec:authorize access="isAuthenticated()">
		                    <div class="rTableCell">
	                            <a class="editButtonlink" href="<c:url value='/edit-event-${event.id}' />">edit</a>
	                        </div>
	                        <div class="rTableCell">
	                            <a class="deleteButtonlink" href="<c:url value='/delete-event-${event.id}' />">delete</a>
	                        </div>
                        </sec:authorize>
                    </div>
                </c:forEach>

            </div>
        </div>

        <%@include file="footer.jsp" %>

    </div>
</body>
</html>