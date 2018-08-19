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
        
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <link type="text/css" rel="stylesheet" href="<c:url value='/static/css/app.css' />" />
        
    </head>
 
    <body>
        <div align="center">
          <div class="body-container" align="left">
            <sec:authorize access="isAnonymous()">
            
                <c:if test="${param.logout != null}">
                    <div>
                        <p><spring:message code="login.logOutSuccess"/></p>
                    </div>
                </c:if>

                <table class="login-table">
	                <thead>
	                    <tr>
	                    <th>
  			                <h3><spring:message code="login.signin.facebook"/></h3>
	                    </th>
	                    <th>
				            <h3><spring:message code="login.signin.admin"/></h3>
	                    </th>
	                    </tr>
	                </thead>
	                <tr>
		                <td>
						    <!-- Social Sign In -->
						    <div>
					            <div>
				                    <!-- Add Facebook sign in button -->
				                    <a href="${pageContext.request.contextPath}/auth/facebook">
				                        <button>
				                            FACEBOOK
				                        </button>
				                    </a>
					            </div>
						    </div>	            
		                </td>
		                <td>
				            <div>
				                <div>
				                    <div>
				                        <c:url var="loginUrl" value="/login" />
				                        <form action="${loginUrl}" method="post">
				                            <c:if test="${param.error != null}">
				                                <div class="error-message">
				                                    <p><spring:message code="login.error.inalidCredentials"/></p>
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
				                            <br/>     
				                            <div>
				                                <input type="submit" value="Log in">
				                            </div>
				                        </form>
				                        
			
				                        
				                        
				                    </div>
				                </div>
				            </div>
			            
			            </td>
	                </tr>
                </table>
	            
	            
            </sec:authorize>

            <!--  -->            
			<sec:authorize access="isAuthenticated()">
			    <p><spring:message code="login.alreadyLoggedIn"/></p>
			</sec:authorize>            
            
            
          </div>
        </div>
 
    </body>
</html>