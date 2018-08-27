
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="events.list.listTitle"/></title>
    
    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 

</head>
 
<body>
<sec:authorize var="loggedIn" access="isAuthenticated()" />

    <div align="center" >
    
        <%@include file="authheader.jsp" %>
        
        <div class="body-container" align="left">

            <div class="rTable">

                <div class="rTableHeadRow">

                        <div class="rTableHeadCell"><spring:message code="events.list.title"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.dateTime"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.organizer"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.description"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.totalPlaces"/></div>
                        <div class="rTableHeadCell"><spring:message code="events.list.freePlaces"/></div>
                        <sec:authorize access="isAuthenticated()">
                            <div class="rTableHeadCell"></div>
                        </sec:authorize>

                </div>

                <c:forEach items="${events}" var="event">
                    <div class="rTableRow">
                        <sec:authorize access="isAuthenticated()">
                            <div class="rTableCell">
                                <a href="<c:url value='/edit-event-${event.id}' />">${event.name}</a>
                            </div>
                        </sec:authorize>
                        <sec:authorize access="!isAuthenticated()">
                            <div class="rTableCell">
                                ${event.name}
                            </div>
                        </sec:authorize>
                        <div class="rTableCell">
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </div>
                        <div class="rTableCell">
                           <c:if test="${not empty event.organizer.socialProfImageURL}">
                               <img src="${event.organizer.socialProfImageURL}" alt="Organizer userpic">
                           </c:if>
                           <c:if test="${event.organizer.email != loggedinuserEmail}">
                               ${event.organizer.firstName} ${event.organizer.lastName}
                           </c:if>
                           <c:if test="${event.organizer.email eq loggedinuserEmail}">
                              <spring:message code="events.list.mine"/>
                           </c:if>
                        </div>
                        <div class="rTableCell">${event.description}</div>
                        <div class="rTableCell">
                            ${event.placeCount}
                        </div>
                        <div class="rTableCell" id="${event.id}fs">
                            ${event.placeCount - fn:length(event.participants)}
                        </div>
                        <sec:authorize access="isAuthenticated()">
	                        <c:if test="${event.organizer.email != loggedinuserEmail}">
	                   
								<c:set var="joined" value="false" />
								<c:forEach var="participant" items="${event.participants}">
								  <c:if test="${participant.email eq loggedinuserEmail}">
								    <c:set var="joined" value="true" />
								  </c:if>
								</c:forEach>	                        
	                        
								<c:if test="${joined}">
			                        <div class="rTableCell">
			                            <a class="rejectButtonlink"  id="${event.id}jr" href="#" onclick="reject(${event.id});return false;"><spring:message code="events.list.reject"/></a>   
			                        </div>
								</c:if>
	                            
								<c:if test="${joined != true}">
			                        <div class="rTableCell">
			                            <a class="joinButtonlink"  id="${event.id}jr" href="#" onclick="join(${event.id});return false;"><spring:message code="events.list.join"/></a>   
			                        </div>
								</c:if>
	                        </c:if>

	                        <c:if test="${event.organizer.email == loggedinuserEmail}">
	                            <div class="rTableCell"></div>
	                        </c:if>
                        </sec:authorize>
                    </div>
                </c:forEach>


            </div>
            
        </div>
        
        
        
        

        
        
        
        
        <%@include file="footer.jsp" %>

    </div>
</body>
</html>