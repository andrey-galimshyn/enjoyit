
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
        
            <table class="zui-table">
                <thead>
                    <tr>
                        <th><spring:message code="events.list.title"/></th>
                        <th><spring:message code="events.list.dateTime"/></th>
                        <th><spring:message code="events.list.organizer"/></th>
                        <th><spring:message code="events.list.description"/></th>
                        <th><spring:message code="events.list.totalPlaces"/></th>
                        <th><spring:message code="events.list.freePlaces"/></th>
                        <sec:authorize access="isAuthenticated()">
                            <th width="100"></th>
                        </sec:authorize>
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
                           <c:if test="${event.organizer.email != loggedinuserEmail}">
                               ${event.organizer.firstName} ${event.organizer.lastName}
                           </c:if>
                           <c:if test="${event.organizer.email eq loggedinuserEmail}">
                              <spring:message code="events.list.mine"/>
                           </c:if>
                        </td>
                        <td>${event.description}</td>
                        <td>
                            ${event.placeCount}
                        </td>
                        <td id="${event.id}fs">
                            ${event.placeCount - fn:length(event.participants)}
                        </td>
                        <sec:authorize access="isAuthenticated()">
	                        <c:if test="${event.organizer.email != loggedinuserEmail}">
	                   
								<c:set var="joined" value="false" />
								<c:forEach var="participant" items="${event.participants}">
								  <c:if test="${participant.email eq loggedinuserEmail}">
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
	                        <!-- empty cell if logged user is organizer -->
	                        <c:if test="${event.organizer.email == loggedinuserEmail}">
	                            <td/>
	                        </c:if>
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