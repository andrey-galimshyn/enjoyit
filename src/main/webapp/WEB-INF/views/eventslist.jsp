
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="events.list.listTitle"/></title>
    
    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 

    <script src="<c:url value='/static/js/confirmDialog.js' />"></script> 
    <link type="text/css" rel="stylesheet" href="<c:url value='/static/css/customDialog.css' />" />

</head>
 
<body>
    <sec:authorize var="loggedIn" access="isAuthenticated()" />
    
	<script type="text/javascript">
	  $(document).ready(function() {
		  Confirm = new CustomConfirm();
	  });
	  abc= '<spring:message code="myevents.list.removeEvent"/>';
	</script>      
	
	<div id="dialogoverlay"></div>
	<div id="dialogbox">
	  <div>
	    <div id="dialogboxhead"></div>
	    <div id="dialogboxbody"></div>
	    <div id="dialogboxfoot"></div>
	  </div>
	</div>

    <div align="center" >
    
        <%@include file="authheader.jsp" %>
        
        <div class="body-container" align="left">
	        <sec:authorize access="isAuthenticated()">
	            <div>
	                <a class="addEventButtonlink" href="<c:url value='/newevent' />"><spring:message code="myevents.list.addNewEvent"/></a>
	            </div>
	        </sec:authorize>
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
                            <div class="rTableHeadCell"></div>
                        </sec:authorize>

                </div>

                <c:forEach items="${events}" var="event">
                    <div class="rTableRow">
                        <div class="rTableCell eventHeaderContent">
                            <a href="<c:url value='/event-details-${event.id}' />">${event.name}</a>
                        </div>
                        <div class="rTableCell">
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </div>
                        <div class="rTableCell">
                           <c:if test="${not empty event.organizer.socialProfImageURL}">
                               <img src="${event.organizer.socialProfImageURL}" alt="Organizer userpic">
                               <br/>
                           </c:if>
                           <c:if test="${loggedIn && not empty event.organizer.socialProfURL}">
                               <a href="${event.organizer.socialProfURL}" target="_blank" rel="noopener noreferrer">
                                   ${event.organizer.firstName} ${event.organizer.lastName}
                               </a>
                           </c:if>
                           <c:if test="${not loggedIn || empty event.organizer.socialProfURL}">
                                ${event.organizer.firstName} ${event.organizer.lastName}
                           </c:if>
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
								<div class="rTableCell"></div>
	                        </c:if>

	                        <c:if test="${event.organizer.email == loggedinuserEmail}">
		                    <div class="rTableCell">
	                            <a class="editButtonlink" href="<c:url value='/event-details-${event.id}' />">
	                                <spring:message code="myevents.list.editEvent"/>
	                            </a>
	                        </div>
	                        <div class="rTableCell">
	                            <a class="deleteButtonlink" onclick="Confirm.render('<spring:message code="myevents.list.confirmAction"/>',
	                            '<spring:message code="myevents.list.removeEventFull"/>',
	                            '<spring:message code="myevents.list.yesRemove"/>',
	                            '<spring:message code="myevents.list.noRemove"/>',
	                            'delete_event',${event.id})" href='#'>
	                                <spring:message code="myevents.list.removeEvent"/>
	                            </a>
	                        </div>
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