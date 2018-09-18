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

    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
   
    <!--That's all for Date\Time picker-->
	<script type="text/javascript" src="<c:url value='/static/js/jquery.simple-dtpicker.js' />"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/static/css/jquery.simple-dtpicker.css' />" />
	

  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 

</head>
 
<body>

    <div align="center">
    
      <%@include file="authheader.jsp" %>
        
      <div class="body-event-edit-container" align="left">
    
	    <div><h3><spring:message code="details.title"/></h3></div>

	    <c:if test="${ (!newEvent) && (event.organizer.email != loggedinuserEmail) }">
	
		  <script type="text/javascript">
		    window.onload = function() {
		    	
		    	document.getElementById("name").readOnly = true;
		    	document.getElementById("description").readOnly = true;
		    	document.getElementById("when").disabled = true;
		    	document.getElementById("placeCount").readOnly = true;
		    	document.getElementById("submitControls").style.display = 'none';
		    	
		    }
		  </script>
	
	    </c:if>
    
    
    
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
	                <fmt:formatDate value="${event.when}" pattern="yyyy/MM/dd HH:mm" var="evStarts"/>
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
								$('*[name=when]').appendDtpicker();
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
	        
	        
	    <c:if test="${ newEvent || (event.organizer.email == loggedinuserEmail) }">
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
	      </c:if>   
	        
	        
	    </form:form>
	    
        <div>
            <spring:message code="details.event.organizer"/>: 
            <a href="${event.organizer.socialProfURL}" target="_blank" rel="noopener noreferrer">
                ${event.organizer.firstName} ${event.organizer.lastName}
            </a>
            
	    </div>
	    
	    
        <div id="joinReject">
            <div>
              <c:if test="${(!newEvent) && (event.organizer.email != loggedinuserEmail)}">
                
				<c:set var="joined" value="false" />
				<c:forEach var="participant" items="${event.participants}">
				  <c:if test="${participant.email eq loggedinuserEmail}">
				    <c:set var="joined" value="true" />
				  </c:if>
				</c:forEach>	                        
                     
				<c:if test="${joined}">
                       <div>
                           <a id="${event.id}jr" class="rejectButtonlink" href="#" onclick="reject(${event.id});return false;"><spring:message code="details.event.reject"/></a>   
                       </div>
				</c:if>
                         
				<c:if test="${joined != true}">
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
                     <div class="rTableHeadCell"></div>
                     <div class="rTableHeadCell"><spring:message code="details.event.userName"/></div>
                     <div class="rTableHeadCell"><spring:message code="details.event.userSirname"/></div>
                </div>

                <c:forEach items="${event.participants}" var="user">
                    <div class="rTableRow">
                    
                        <div class="rTableCell">
                           <c:if test="${not empty user.socialProfImageURL}">
                               <img src="${user.socialProfImageURL}" alt="Organizer userpic">
                           </c:if>
                        </div>
                    
                        <div class="rTableCell">${user.firstName}</div>
                        <div class="rTableCell">${user.lastName}</div>

                    </div>
                </c:forEach>

            </div>
        </div>
      </div>

      <%@include file="footer.jsp" %>
        
    </div>
</body>
</html>