<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="myevents.list.myListTitle"/></title>
    <link rel="shortcut icon" href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />

    <script src="<c:url value='/static/js/confirmDialog.js' />"></script> 
    <script src="<c:url value='/static/js/jquery-3.2.1.min.js' />"></script> 
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


    <div align="center">
    
        <%@include file="authheader.jsp" %>
        
        <div class="body-container" align="left">
	        <sec:authorize access="isAuthenticated()">
	            <div>
	                <a class="addEventButtonlink" href="<c:url value='/newevent' />"><spring:message code="myevents.list.addNewEvent"/></a>
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
                            ${event.placeCount}
                        </div>
                        
						<c:set var="freePlaceCount" value="0" />
						<c:forEach var="visit" items="${event.visits}">
							<c:if test="${visit.joined == 1}">
								<c:set var="freePlaceCount" value="${freePlaceCount + 1}" />
							</c:if>
						</c:forEach>
						<div class="rTableCell" id="${event.id}fs">
                            ${freePlaceCount}
                        </div>
                        <sec:authorize access="isAuthenticated()">
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
                        </sec:authorize>
                    </div>
                </c:forEach>

            </div>
        </div>

        <%@include file="footer.jsp" %>

    </div>
</body>
</html>