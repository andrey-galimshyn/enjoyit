
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="events.list.listTitle"/></title>
    
    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
    
    <!-- Range picker -->
	<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
	<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />    
    <!-- ***************************** -->
    
  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 

    <script src="<c:url value='/static/js/confirmDialog.js' />"></script> 
    <link type="text/css" rel="stylesheet" href="<c:url value='/static/css/customDialog.css' />" />

    <link rel="shortcut icon" href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />

</head>
 
<body>
    <sec:authorize var="loggedIn" access="isAuthenticated()" />
    
	    
    <div align="center" >

		<%@include file="authheader.jsp" %>

		<script>

		    function set_missed(id, checked) {
		    	
		    	var jsonParams = {};
		    	jsonParams['visitId'] = id;
		    	jsonParams['missed'] = checked;
		    	jsonParams[csrfParameter] = csrfToken;
				$.ajax({
					type : "POST",
					contentType : "application/json",
					async: false,
					url : "missed",
					data : JSON.stringify(jsonParams),
					timeout : 100000,
					success : function(data) {
						console.log("SUCCESS Update Visit");
					},
					error : function(e) {
						console.log("ERROR: ", e);
					},
					done : function(e) {
						console.log("DONE");
					}
				});
				
		    };

			function replaceUrlParam(url, paramName, paramValue)
			{
			    if (paramValue == null) {
			        paramValue = '';
			    }
			    var pattern = new RegExp('\\b('+paramName+'=).*?(&|#|$)');
			    if (url.search(pattern)>=0) {
			        return url.replace(pattern,'$1' + paramValue + '$2');
			    }
			    url = url.replace(/[?#]$/,'');
			    return url + (url.indexOf('?')>0 ? '&' : '?') + paramName + '=' + paramValue;
			};
		
		
			$(function() {
			  
			  $('input[name="daterange"]').daterangepicker({

				    startDate: moment(new Date(${startMs})),
				    endDate: moment(new Date(${endMs}))

				  },

				  function(start, end, label) {
                      // alert("start " + start + " end " + end + "   label" + label);
                      var url = window.location.href;   
                      url = replaceUrlParam(url,'start', start);
                      url = replaceUrlParam(url,'end', end);
                      window.location.href = url;
				  }
			  );
			});

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
        
            <input type="text" name="daterange"/>

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

                    <c:if test="${fn:length(event.visits) gt 0}">

					    <c:forEach var="visit" items="${event.visits}">
						    <div class="rTableRowVisitor">
								<div class="rTableCell">
								    <a href="<c:url value='/userprofile-${visit.user.id}'/>">
			                            ${visit.user.firstName}
			                            ${visit.user.lastName}
		                            </a>
		                        </div>
								<div class="rTableCell">
		                            ${visit.user.email}
		                        </div>
						        <div class="rTableCell">
						            <input id="${visit.id}_hooky" type="checkbox" onclick="set_missed(${visit.id}, this.checked)" name="${event.name}_${visit.user.firstName}_hooky" 
						            
						                <c:if test="${visit.missed == 1}">checked</c:if>
						            
						            />
						            <spring:message code="user.events.report.missed"/>
						        </div>
						        <div class="rTableCellEmpty"></div>
								
						    </div>
					    </c:forEach>

					</c:if>                       

                </c:forEach>
                
		    </div>
		    
	        <span> 
	            <a href="<c:url value="/report-download?start=${startMs}&end=${endMs}" />">
	                <spring:message code="user.profile.events.downloadreportCSV"/>
	            </a>
	        </span>


        </div>
            
            
        <%@include file="footer.jsp" %>

    </div>
</body>
</html>