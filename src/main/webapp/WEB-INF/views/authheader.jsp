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


    <link rel="image_src" href="<c:url value='/static/images/messengerLogo.png'/>" />    

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <link type="text/css" rel="stylesheet" href="<c:url value='/static/css/app.css' />" />

</head>


<body>

<div class="keeper" align="center" >
	<c:choose>
	    <c:when test="${loggedIn}">
	
	            <header class="joiner">
	              <div id="wrapper">
		              <div class="welcome">
		                <span><spring:message code="authheader.welcome" arguments="${loggedinuser}"/> </span>
		              </div>
		              <div class="logout">
		                  <span> <a href="<c:url value="/logout" />"><spring:message code="authheader.logout"/></a> </span>
		              </div>
	              </div>
	              <br/>

				  <script>
						function foo(select) {
						    var x = document.getElementsByClassName("rTableRow");
							var i;
							for (i = 0; i < x.length; i++) {
							  var optionSelected = select.options[select.selectedIndex].getAttribute("id");
							  
							  x[i].style.visibility = "visible";
							  if (select.options[select.selectedIndex].getAttribute("id") === "typeFilterOwner" &&
									  x[i].children[6].children[0].className !== 'editButtonlink') {
								  x[i].style.visibility = "collapse";
								  continue;
							  }
							  if (select.options[select.selectedIndex].getAttribute("id") === "typeFilterAssigned" &&
									  x[i].children[6].children[0].className !== 'rejectButtonlink') {
								  x[i].style.visibility = "collapse";
								  continue;
							  }
							  if (select.options[select.selectedIndex].getAttribute("id") === "typeFilterNotAssigned" &&
									  x[i].children[6].children[0].className !== 'joinButtonlink') {
								  x[i].style.visibility = "collapse";
								  continue;
							  }
						    }
						}
				  </script>


	              <div class="topper">
	              
	                  <a href="<c:url value="/listEvents" />">
                         <img class="menu-top-logo" alt="Joit It" src="<c:url value="/static/images/Logotip.png" />" align="left">
                      </a>
                      
                      
                      <div class="topper-align">   
		              
				          
						  <select id="eventsTypeFilter" onchange=foo(this)>
							  <option id="typeFilterAll" selected="selected"><spring:message code="authheader.events"/></option>
							  <option id="typeFilterAssigned"><spring:message code="authheader.subscribed"/></option>
							  <option id="typeFilterNotAssigned"><spring:message code="authheader.notsubscribed"/></option>
							  <option id="typeFilterOwner"><spring:message code="authheader.edit"/></option>
						  </select>
						  
						  
						  
				      
				          <sec:authorize access="hasRole('ADMIN')">
				              <span><a id="listOfUsersItem" class="topItem" href="<c:url value="/list" />"><spring:message code="authheader.users"/></a></span>
				          </sec:authorize>
				          
				          <span><a id="listOfEventsItem" class="topItem" href="<c:url value="/listEvents" />">&lt;&lt;<spring:message code="authheader.events"/></a></span>
		              </div>
		              
		              
	              </div>   
	              
           	               
	            </header>
	
	    </c:when>
	    <c:otherwise>
	      <div class="login-container" align="left">
	          <span>
				<form action="<c:url value="/connect/facebook" />" method="POST" style="display: inline">
					<input type="hidden" name="scope" value="public_profile,email" />
					<button type="submit" class="btn btn-primary">
						Facebook <span class="fa fa-facebook"></span>
					</button>
				</form>
	          </span>
	      </div>
	    </c:otherwise>
	</c:choose>
</div>
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
  </script>
</c:if>
