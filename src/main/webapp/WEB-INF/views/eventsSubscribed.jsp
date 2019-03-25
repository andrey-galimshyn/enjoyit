
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>

    <title><spring:message code="events.list.listTitle"/></title>
    
    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
    
    <link rel="shortcut icon" href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />

</head>
 
<body>
    <sec:authorize var="loggedIn" access="isAuthenticated()" />
    
	    
    <div align="center" >

		<%@include file="authheader.jsp" %>

		<script>

		  var listOfEventsItemShow = document.getElementById("listOfEventsItem");
		  if (listOfEventsItemShow !== null) {
			  listOfEventsItemShow.style.visibility = "visible";
		  }

		  var eventsTypeFilterDropdown = document.getElementById("eventsTypeFilter");
		  if (eventsTypeFilterDropdown !== null) {
			  eventsTypeFilterDropdown.style.display = "none";
		  }

		</script>

        <div class="body-container" align="left">

            <h2><spring:message code="user.events.subscribed.header"/></h2>

            <div class="rTable">

                <div class="rTableHeadRow">

                        <div class="rTableHeadCell"><spring:message code="events.list.title"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.dateTime"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.description"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.occupiedPlaces"/></div>

                </div>
                <c:forEach items="${events}" var="event">
                    <div class="rTableRow">
                        <div class="rTableCell eventHeaderContent">
                            <a href="<c:url value='/event-details-${event.id}' />">${event.name}</a>
                        </div>
                        <div class="rTableCell">
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </div>
                        
                        <c:if test="${ not empty event.description }">
                            <div class="rTableCell">
                                ${event.description}
                            </div>
                        </c:if>
                        <c:if test="${ empty event.description }">
                            <div class="rTableCellEmpty"></div>
                        </c:if>
                        
						<div class="rTableCell">
                            ${fn:length(event.visits)}
                        </div>

                    </div>
                </c:forEach>
                
		    </div>
		    
        </div>
            
            
        <%@include file="footer.jsp" %>

    </div>
</body>
</html>