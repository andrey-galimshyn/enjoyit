<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<sec:authorize var="loggedIn" access="isAuthenticated()" />

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />
    
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <link type="text/css" rel="stylesheet" href="<c:url value='/static/css/app.css' />" />

</head>


<body>

<div class="keeper" align="center" >
	<c:choose>
	    <c:when test="${loggedIn}">
	
	            <header class="joiner">
	              <br/>	
	              <div class="logout">
	                  <span> <a href="<c:url value="/logout" />"><spring:message code="authheader.logout"/></a> </span>
	              </div>
	              <div class="welcome">
	                <span><spring:message code="authheader.welcome" arguments="${loggedinuser}"/> </span>
	              </div>
	              <br/>
	              <div class="topper" align="right">
	                  <a href="<c:url value="/listEvents" />">
                         <img class="menu-top-logo" alt="Joit It" src="<c:url value="/static/images/Logotip.png" />" align="left">
                      </a>
		              <div class="topper-align">
				          
				          
				          <sec:authorize access="hasRole('ADMIN')">
				              <span><a id="listOfUsersItem" class="topItem" href="<c:url value="/list" />"><spring:message code="authheader.users"/></a></span>
				          </sec:authorize>
				          
				          <span><a id="listOfEventsItem" class="topItem" href="<c:url value="/listEvents" />"><spring:message code="authheader.events"/></a></span>
				          <span><a id="listOfEventsSubscribed" class="topItem" href="<c:url value="/listEvents?subscribed=true" />"><spring:message code="authheader.subscribed"/></a></span>
				          <span><a id="listOfEventsNotSubscribed" class="topItem" href="<c:url value="/listEvents?free=true" />"><spring:message code="authheader.notsubscribed"/></a></span>
				          <span><a id="listOfMyEvents" class="topItem" href="<c:url value="/myEvents" />"><spring:message code="authheader.edit"/></a></span>
		              </div>
	              </div>   
	              
           	               
	            </header>
	
	    </c:when>
	    <c:otherwise>
	      <div class="body-container" align="left">
	          <span><a href="<c:url value="/login" />"><spring:message code="authheader.login"/></a></span>
	      </div>
	    </c:otherwise>
	</c:choose>
</div>
<br/>
</body>

<c:if test="${loggedIn}">
  <script type="text/javascript">
    var csrfParameter = '${_csrf.parameterName}';
    var csrfToken = '${_csrf.token}';    // join to the event
    window.onload = function() {
    	if (window.location.href.indexOf('#_=_') > 0) {
    		window.location = window.location.href.replace(/#.*/, '');
    	}
    }
    
    if (window.location.pathname == "/list") {
    	var link = document.getElementById("listOfUsersItem");
    	link.className += " selectedItem";
    } else if (window.location.pathname.includes("/myEvents") || window.location.pathname.includes("/enjoyit/event-details")) {
    	var link = document.getElementById("listOfMyEvents");
    	link.className += " selectedItem";
    } else if (window.location.pathname.includes("/listEvents") && !window.location.search) {
    	var link = document.getElementById("listOfEventsItem");
    	link.className += " selectedItem";
    } else if (window.location.pathname.includes("/listEvents") 
    		&& window.location.search == "?subscribed=true") {
    	var link = document.getElementById("listOfEventsSubscribed");
    	link.className += " selectedItem";
    } else if (window.location.pathname.includes("/listEvents") 
		    && window.location.search == "?free=true") {
	    var link = document.getElementById("listOfEventsNotSubscribed");
	    link.className += " selectedItem";
    }
  </script>
</c:if>
