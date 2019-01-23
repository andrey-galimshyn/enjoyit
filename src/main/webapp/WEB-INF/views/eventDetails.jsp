<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="details.title"/></title>
    <link rel="shortcut icon" href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />

    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
   
    <!--That's all for Date\Time picker-->
    <script src="<c:url value='/static/js/nicEdit.js' />" type="text/javascript"></script>
	<script type="text/javascript" src="<c:url value='/static/js/jquery.simple-dtpicker.js' />"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/static/css/jquery.simple-dtpicker.css' />" />
	

  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 

</head>
 
<body>


    <div align="center">
    
      <%@include file="authheader.jsp" %>
      
      
      <sec:authorize var="loggedIn" access="isAuthenticated()" />
      
      
	  <script type="text/javascript">

		  bkLib.onDomLoaded(function() {
				new nicEditor().panelInstance('description');
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

      <c:choose>
          <c:when test="${edit}">
              <fmt:formatDate value="${event.when}" pattern="dd.MM.yyyy H:m" var="evStarts"/>
          </c:when>
          <c:otherwise>
              <c:set var="evStarts" value=""/>
          </c:otherwise>
      </c:choose>
     
      <div class="body-event-edit-container" align="left">
    
	    <div><h3><spring:message code="details.title"/></h3></div>

	    <c:if test="${ loggedIn && (newEvent || (event.organizer.email == loggedinuserEmail)) }">
		    <form:form method="POST" modelAttribute="event">
		        <form:input type="hidden" path="id" id="id"/>
		         
		        <div>
		            <div>
		                <label for="name"><spring:message code="details.event.name"/></label>
		                <div>
		                    <form:input type="text" path="name" id="name"/>
		                    <div class="error-message">
		                        <form:errors path="name"/>
		                    </div>
		                </div>
		            </div>
		        </div>
		 
		        <div>
		            <div>
		                <label for="description"><spring:message code="details.event.description"/></label>
		                <div>
		                    <form:textarea type="text" path="description" id="description" rows="5" cols="40"/>
		                    <div class="error-message">
		                        <form:errors path="description"/>
		                    </div>
		                </div>
		            </div>
		        </div>
		        
		        <c:choose>
		            <c:when test="${edit}">
		                <fmt:formatDate value="${event.when}" pattern="dd.MM.yyyy H:m" var="evStarts"/>
		            </c:when>
		            <c:otherwise>
		                <c:set var="evStarts" value=""/>
		            </c:otherwise>
		        </c:choose>
	        	        
		        <div>
		            <div>
		                <label for="when"><spring:message code="details.event.when"/></label>
		                <div>
		                    <form:input type="text" path="when" id="when" name="when" value="${evStarts}"/>
							<script type="text/javascript">
								$(function(){
									$('*[name=when]').appendDtpicker(
											{"dateFormat": "DD.MM.YYYY hh:mm"}
											);
								});
							</script>
		                    <div  class="error-message">
		                        <form:errors path="when"/>
		                    </div>
		                </div>
		            </div>
		        </div>
		
	
		        <div>
		            <div>
		                <label for="placeCount"><spring:message code="details.event.quantity"/></label>
		                <div>
		                    <form:input path="placeCount" id="placeCount" type="number" min="1" max="100000"/>
		                    <div  class="error-message">
		                        <form:errors path="placeCount" class="help-inline"/>
		                    </div>
		                </div>
		            </div>
		        </div>
		        
		        
    	        <br/>
		        <div id="submitControls">
		            <div>
		                <c:choose>
		                    <c:when test="${edit}">
		                        <spring:message code="details.event.update" var="update"/>
		                        <input type="submit" value="${update}"/> 
		                        <spring:message code="details.event.or"/>
		                        <a href="<c:url value='/listEvents' />"><spring:message code="details.event.cancel"/></a>
		                    </c:when>
		                    <c:otherwise>
		                        <spring:message code="details.event.create" var="create"/>
		                        <input type="submit" value="${create}"/> 
		                        <spring:message code="details.event.or"/>
		                        <a href="<c:url value='/listEvents' />"><spring:message code="details.event.cancel"/></a>
		                    </c:otherwise>
		                </c:choose>
		            </div>
		        </div>
		        
		    </form:form>
	    
	    </c:if>
	    <!-- ======================= User is not logged in or not the author of event  =============================== -->
	    <c:if test="${ not loggedIn || (event.organizer.email != loggedinuserEmail) }">
	        <div>
	            <div>
	                <span><b> <spring:message code="details.event.name"/> </b> </span>
	                <div>
	                    <span>  ${event.name}  </span>
	                </div>
	            </div>
	        </div>
	 
	        <div>
	            <div>
	                <span>  <b> <spring:message code="details.event.description"/> </b> </span>
	                <div>
	                    <span>  ${event.description}  </span>
	                </div>
	            </div>
	        </div>
	        
	        <div>
	            <div>
	                <span><b> <spring:message code="details.event.when"/> </b> </span>
                    <span>  ${evStarts}  </span>
	            </div>
	        </div>

	        <div>
	            <div>
	                <span> <b> <spring:message code="details.event.quantity"/> </b> </span>
                    <span>  ${event.placeCount}  </span>
	            </div>
	        </div>	    
	    </c:if>
	    
	    
        <!-- =================================================== -->
            
        <div>
            <b> <spring:message code="details.event.organizer"/>: </b>
            <a href="<c:url value='/userprofile-${event.organizer.id}'/>">
                <c:if test="${not empty event.organizer.socialProfImageURL}">
                  <img src="${event.organizer.socialProfImageURL}" alt="Organizer userpic">
                  <br/>
                </c:if>
                ${event.organizer.firstName} ${event.organizer.lastName}
            </a>
	    </div>
	    
	    
        <div id="joinReject">
            <div>
              <c:if test="${loggedIn && ((!newEvent) && (event.organizer.email != loggedinuserEmail))}">
                
				<c:set var="joined" value="false" />
				<c:forEach var="visit" items="${event.visits}">
				  <c:if test="${visit.user.email eq loggedinuserEmail && visit.joined == 1}">
				    <c:set var="joined" value="true" />
				  </c:if>
				</c:forEach>	                        

				<c:if test="${joined}">
                       <div>
                           <a id="${event.id}jr" class="rejectButtonlink" href="#" onclick="reject(${event.id});return false;"><spring:message code="details.event.reject"/></a>   
                       </div>
				</c:if>

				<c:if test="${not joined}">
                       <div>
                           <a id="${event.id}jr" class="joinButtonlink" href="#" onclick="join(${event.id});return false;"><spring:message code="details.event.join"/></a>   
                       </div>
				</c:if>
              </c:if>

            </div>
        </div>
	    
    
    
    <!-- -------------------------------------------------------------------- -->
    
    

        <div>
              <!-- Default panel contents -->
            <div><span><spring:message code="details.event.joinedList"/></span></div>
             <div class="rTable">
                <div class="rTableHeadRow">
                     <div class="rTableHeadCell"><spring:message code="details.event.part.num"/></div>
                     <div class="rTableHeadCell"><spring:message code="details.event.part.upic"/></div>
                     <div class="rTableHeadCell">
                         <spring:message code="details.event.userName"/> 
                         <spring:message code="details.event.userSirname"/> 
                      </div>
                </div>

                <c:set var="visitCount" value="0" />
                <c:forEach items="${event.visits}" var="visit">
                
                    <c:if test="${visit.joined == 1}">
                        <c:set var="visitCount" value="${visitCount + 1}" />
	                    <div class="rTableRow">
	                    
	                        <div class="rTableCellMembers">
                                ${visitCount}
	                        </div>

	                        <div class="rTableCellMembers">
	                           <c:if test="${not empty visit.user.socialProfImageURL}">
						           <a href="<c:url value='/userprofile-${visit.user.id}'/>">
						               <img src="${visit.user.socialProfImageURL}" alt="Organizer userpic">
						               <br/>
						           </a>
	                           </c:if>
	                        </div>

	                        <div class="rTableCellMembers">
					            <a href="<c:url value='/userprofile-${visit.user.id}'/>">
					                ${visit.user.firstName} ${visit.user.lastName}
					            </a>
	                        </div>
	                        
                        </div>
                    </c:if>
                </c:forEach>

            </div>
        </div>
      </div>

      <%@include file="footer.jsp" %>
        
    </div>
</body>
</html>