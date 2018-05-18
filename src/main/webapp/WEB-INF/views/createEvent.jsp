<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 
<html>
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Event Details</title>
    <link href="<c:url value='/static/css/bootstrap.css' />" rel="stylesheet"></link>
    <link href="<c:url value='/static/css/app.css' />" rel="stylesheet"></link>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.1.4/semantic.min.css"/>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.1.4/semantic.min.js"></script>
    <link href="http://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">


    <!-- That's all for duration picker -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" crossorigin="anonymous">
    <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="<c:url value='/static/css/bootstrap-duration-picker.css' />"></link>
    <script src="<c:url value='/static/js/bootstrap-duration-picker.js' />"></script>
   
   
    <!--That's all for Date\Time picker-->
	<script type="text/javascript" src="<c:url value='/static/js/jquery.simple-dtpicker.js' />"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/static/css/jquery.simple-dtpicker.css' />" />
	
  	<script src="<c:url value='/static/js/join_reject.js' />"></script> 
	
</head>
 
<body>
 
    <div class="generic-container">
    
        <%@include file="authheader.jsp" %>
    
	    <div class="well lead"><spring:message code="details.title"/></div>

	    <c:if test="${ (!newEvent) && (event.organizer.email != loggedinuser) }">
	
		  <script type="text/javascript">
		    window.onload = function() {
		    	
		    	document.getElementById("name").readOnly = true;
		    	document.getElementById("description").readOnly = true;
		    	document.getElementById("when").readOnly = true;
		    	document.getElementById("placeCount").readOnly = true;
		    	document.getElementById("submitControls").style.display = 'none';
		    	
		    }
		  </script>
	
	    </c:if>
    
    
    
	    <form:form method="POST" modelAttribute="event" class="form-horizontal">
	        <form:input type="hidden" path="id" id="id"/>
	         
	        <div class="row">
	            <div class="form-group col-md-12">
	                <label class="col-md-3 control-lable" for="name"><spring:message code="details.event.name"/></label>
	                <div class="col-md-7">
	                    <form:input type="text" path="name" id="name" class="form-control input-sm"/>
	                    <div class="has-error">
	                        <form:errors path="name" class="help-inline"/>
	                    </div>
	                </div>
	            </div>
	        </div>
	 
	        <div class="row">
	            <div class="form-group col-md-12">
	                <label class="col-md-3 control-lable" for="description"><spring:message code="details.event.description"/></label>
	                <div class="col-md-7">
	                    <form:input type="text" path="description" id="description" class="form-control input-sm" />
	                    <div class="has-error">
	                        <form:errors path="description" class="help-inline"/>
	                    </div>
	                </div>
	            </div>
	        </div>
	        
	        
	        <div class="row">
	            <div class="form-group col-md-12">
	                <label class="col-md-3 control-lable" for="when"><spring:message code="details.event.when"/></label>
	                <div class="col-md-7">
	                    <form:input type="text" path="when" id="when" name="when" class="form-control input-sm" value="${evStarts}"/>
	
		<script type="text/javascript">
			$(function(){
				$('*[name=when]').appendDtpicker();
			});
		</script>
	                    
	                    
	                    <div class="has-error">
	                        <form:errors path="when" class="help-inline"/>
	                    </div>
	                </div>
	            </div>
	        </div>
	
	<script type="text/javascript">
	    
	    $('#duration').durationPicker({
	        showDays: false,
	        onChanged: function (newVal) {
	        }
	      });
	
	</script>
	
	
	        <div class="row">
	            <div class="form-group col-md-12">
	                <label class="col-md-3 control-lable" for="placeCount"><spring:message code="details.event.quantity"/></label>
	                <div class="col-md-7">
	                    <form:input type="text" path="placeCount" id="placeCount" class="form-control input-sm" />
	                    <div class="has-error">
	                        <form:errors path="placeCount" class="help-inline"/>
	                    </div>
	                </div>
	            </div>
	        </div>
	        
	        
	    <c:if test="${ newEvent || (event.organizer.email == loggedinuser) }">
	 
	        <div class="row" id="submitControls">
	            <div class="form-actions floatRight">
	                <c:choose>
	                    <c:when test="${edit}">
	                        <spring:message code="details.event.update" var="update"/>
	                        <input type="submit" value="${update}" class="btn btn-primary btn-sm"/> <spring:message code="details.event.or"/>
	                        <a href="<c:url value='/listEvents' />"><spring:message code="details.event.cancel"/></a>
	                    </c:when>
	                    <c:otherwise>
	                        <spring:message code="details.event.create" var="create"/>
	                        <input type="submit" value="${create}" class="btn btn-primary btn-sm"/> <spring:message code="details.event.or"/>
	                        <a href="<c:url value='/listEvents' />"><spring:message code="details.event.cancel"/></a>
	                    </c:otherwise>
	                </c:choose>
	            </div>
	        </div>
	      </c:if>   
	        
	        
	    </form:form>
	    
        <div>
            <spring:message code="details.event.organizer"/>: ${event.organizer.firstName} ${event.organizer.lastName} 
	    </div>
	    
	    
        <div class="row" id="joinReject">
            <div class="form-actions floatRight">
              <c:if test="${(!newEvent) && (event.organizer.email != loggedinuser)}">
                
				<c:set var="joined" value="false" />
				<c:forEach var="participant" items="${event.participants}">
				  <c:if test="${participant.email eq loggedinuser}">
				    <c:set var="joined" value="true" />
				  </c:if>
				</c:forEach>	                        
                     
				<c:if test="${joined}">
                       <div>
                           <a id="${event.id}jr" href="#" onclick="reject(${event.id});return false;"><spring:message code="details.event.reject"/></a>   
                       </div>
				</c:if>
                         
				<c:if test="${joined != true}">
                       <div>
                           <a id="${event.id}jr" href="#" onclick="join(${event.id});return false;"><spring:message code="details.event.join"/></a>   
                       </div>
				</c:if>
              </c:if>
                
            </div>
        </div>
	    
    
    
    <!-- -------------------------------------------------------------------- -->
    
    

        <div class="panel panel-default">
              <!-- Default panel contents -->
            <div class="panel-heading"><span class="lead"><spring:message code="details.event.joinedList"/></span></div>
            <table class="table">
                <thead>
                    <tr>
                        <th><spring:message code="details.event.userSirname"/></th>
                        <th><spring:message code="details.event.userName"/></th>
                        <th><spring:message code="details.event.userEmail"/></th>
                        <th><spring:message code="details.event.userSsoId"/></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${event.participants}" var="user">
                    <tr>
                        <td>${user.firstName}</td>
                        <td>${user.lastName}</td>
                        <td>${user.email}</td>
                        <td>${user.ssoid}</td>


                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>