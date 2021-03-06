
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

    <link rel="shortcut icon" href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />

</head>
 
<body>
    <sec:authorize var="loggedIn" access="isAuthenticated()" />
    
	<script type="text/javascript">
	  $(document).ready(function() {
		  Confirm = new CustomConfirm();
		  //hide passed today events
		  var currTime = Date.now();
		  var x = document.getElementsByClassName("rTableRow");
		  var i = 0;

		  for (i = 0; i < x.length; i++) {
			  if (currTime > (x[i].getAttribute("data-event-timestamp") - 3600000)) { //minus 1 hour
		          x[i].style.display = "none";
			  }
		  }		  
		  ////
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
	            <div class="fillParent">
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
                        <div class="rTableHeadCell"></div>
                        <sec:authorize access="isAuthenticated()">
                            <div class="rTableHeadCell"></div>
                            <div class="rTableHeadCell"></div>
                        </sec:authorize>

                </div>

                <c:forEach items="${events}" var="event">
                    <div class="rTableRow" data-event-timestamp="${event.when.time}">
                        <div class="rTableCell eventHeaderContent">
                            <a href="<c:url value='/event-details-${event.id}' />">${event.name}</a>
                        </div>
                        <div class="rTableCell">
                            <fmt:formatDate type = "both" dateStyle = "short" timeStyle = "short" value = "${event.when}" />
                        </div>
                        
                        <div class="rTableCell">
                           <a href="<c:url value='/userprofile-${event.organizer.id}'/>">
	                           <c:if test="${not empty event.organizer.socialProfImageURL}">
	                               <img src="${event.organizer.socialProfImageURL}" alt="Organizer userpic">
	                               <br/>
	                           </c:if>
                               ${event.organizer.firstName} ${event.organizer.lastName}
                           </a>
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

						<c:set var="freePlaceCount" value="0" />
						<c:forEach var="visit" items="${event.visits}">
							<c:if test="${visit.joined == 1}">
								<c:set var="freePlaceCount" value="${freePlaceCount + 1}" />
							</c:if>
						</c:forEach>

						<div class="rTableCell" id="${event.id}fs">
                            ${event.placeCount - freePlaceCount}
                        </div>

						<c:if test="${!loggedIn}">
							<div class="rTableCell">
								Join via Facebook
							</div>
						</c:if>


						<sec:authorize access="isAuthenticated()">
	                        <c:if test="${event.organizer.email != loggedinuserEmail}">
	                   
								<c:set var="joined" value="false" />
								<c:forEach var="visit" items="${event.visits}">
								  <c:if test="${visit.user.email eq loggedinuserEmail && visit.joined == 1}">
								    <c:set var="joined" value="true" />
								  </c:if>
								</c:forEach>	                        
	                        
								<c:if test="${joined}">
			                        <div class="rTableCell">
			                            <a class="rejectButtonlink"  id="${event.id}jr" href="#" onclick="reject(${event.id});return false;"><spring:message code="events.list.reject"/></a>   
			                        </div>
								</c:if>
	                            
								<c:if test="${not joined}">
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
		                            <a class="copyButtonlink" href="<c:url value='/copy-event-${event.id}' />">
		                                <spring:message code="myevents.list.copyEvent"/>
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