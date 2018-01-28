<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 
<html>
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>New Event Form</title>
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
</head>
 
<body>
 
    <div class="generic-container">
    <div class="well lead">New Event Form</div>
    <form:form method="POST" modelAttribute="event" class="form-horizontal">
        <form:input type="hidden" path="id" id="id"/>
         
        <div class="row">
            <div class="form-group col-md-12">
                <label class="col-md-3 control-lable" for="name">Event Name</label>
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
                <label class="col-md-3 control-lable" for="description">Description</label>
                <div class="col-md-7">
                    <form:input type="text" path="description" id="description" class="form-control input-sm" />
                    <div class="has-error">
                        <form:errors path="description" class="help-inline"/>
                    </div>
                </div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${edit}">
                <c:set var="durSecs" value="${event.duration.seconds}"/>
                
                
                
                <fmt:formatDate value="${event.when}" pattern="yyyy/MM/dd HH:mm" var="evStarts"/>
               
            </c:when>
            <c:otherwise>
                <c:set var="durSecs" value="0"/>
                <c:set var="evStarts" value=""/>
            </c:otherwise>
        </c:choose>
 
        <div class="row">
            <div class="form-group col-md-12">
                <label class="col-md-3 control-lable" for="when">When Event happens</label>
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


        <div class="row">
            <div class="form-group col-md-12">
                <label class="col-md-3 control-lable" for="duration">Event duration</label>
                <div class="col-md-7">
	                <div class="ui input">
	                    <form:input type="text" path="duration" id="duration" class="form-control input-sm" value="${durSecs}" />
	                    <div class="has-error">
	                        <form:errors path="duration" class="help-inline"/>
	                    </div>
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
                <label class="col-md-3 control-lable" for="place">Places</label>
                <div class="col-md-7">
                    <form:select path="place" items="${places}" multiple="false" itemValue="id" itemLabel="name" class="form-control input-sm" />
                    <div class="has-error">
                        <form:errors path="place" class="help-inline"/>
                    </div>
                </div>
            </div>
        </div>
 
 
        <div class="row">
            <div class="form-actions floatRight">
                <c:choose>
                    <c:when test="${edit}">
                        <input type="submit" value="Update" class="btn btn-primary btn-sm"/> or <a
 
href="<c:url value='/listEvents' />">Cancel</a>
                    </c:when>
                    <c:otherwise>
                        <input type="submit" value="Create" class="btn btn-primary btn-sm"/> or <a
 
href="<c:url value='/listEvents' />">Cancel</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        
        
    </form:form>
    
    
    
    <!-- -------------------------------------------------------------------- -->
    
    

        <div class="panel panel-default">
              <!-- Default panel contents -->
            <div class="panel-heading"><span class="lead">List of joined Users</span></div>
            <table class="table">
                <thead>
                    <tr>
                        <th>Firstname</th>
                        <th>Lastname</th>
                        <th>Email</th>
                        <th>SSO ID</th>
                        <th width="100"></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${event.participants}" var="user">
                    <tr>
                        <td>${user.firstName}</td>
                        <td>${user.lastName}</td>
                        <td>${user.email}</td>
                        <td>${user.ssoId}</td>
                        <td>
                            hello
                        </td>


                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

      
   
   
   
   
    
    
    </div>
    
    
    
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
</body>
</html>