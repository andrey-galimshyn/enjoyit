<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title><spring:message code="login.title"/></title>
        <link href="<c:url value='/static/css/bootstrap.css' />"  rel="stylesheet"></link>
        <link href="<c:url value='/static/css/app.css' />" rel="stylesheet"></link>
    </head>
 
    <body>
        <div id="mainWrapper">
        
            <sec:authorize access="isAnonymous()">
	            <div>
	                <div>
	                    <div>
	                        <c:url var="loginUrl" value="/login" />
	                        <form action="${loginUrl}" method="post">
	                            <c:if test="${param.error != null}">
	                                <div>
	                                    <p><spring:message code="login.error.inalidCredentials"/></p>
	                                </div>
	                            </c:if>
	                            <c:if test="${param.logout != null}">
	                                <div>
	                                    <p><spring:message code="login.logOutSuccess"/></p>
	                                </div>
	                            </c:if>
	                            <div>
	                                <label for="username"></label>
	                                <input type="text" id="username" name="ssoid" required>
	                            </div>
	                            <div>
	                                <label for="password"></label> 
	                                <input type="password" id="password" name="password" required>
	                            </div>

	                            <input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}" />
	                                 
	                            <div>
	                                <input type="submit" value="Log in">
	                            </div>
	                        </form>
	                        

	                        
	                        
	                    </div>
	                </div>
	            </div>
	            
	            
			    <!-- Social Sign In -->
			    <div>
		            <h2><spring:message code="login.signin.facebook"/></h2>
		            <div>
	                    <!-- Add Facebook sign in button -->
	                    <a href="${pageContext.request.contextPath}/auth/facebook">
	                        <button>
	                            FACEBOOK
	                        </button>
	                    </a>
		            </div>
			    </div>	            
	            
            </sec:authorize>

            <!--  -->            
			<sec:authorize access="isAuthenticated()">
			    <p><spring:message code="login.alreadyLoggedIn"/></p>
			</sec:authorize>            
            
            
        </div>
 
    </body>
</html>