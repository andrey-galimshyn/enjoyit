<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><spring:message code="registration.title" /></title>
<link rel="shortcut icon"
	href="<c:url value='/static/images/favicon_liF_icon.ico'/>" />
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<link type="text/css" rel="stylesheet"
	href="<c:url value='/static/css/app.css' />" />
</head>
<body>


	<div align="center">
		<div class="body-event-edit-container" align="left">


			<sec:authorize access="isAnonymous() or hasRole('ROLE_ADMIN')">

                <div class = "error-message">
                    <h3>
                        <spring:message code="registration.failed.page.title"/> 
                        <br>
                        ${exception}
                    </h3>
                </div>

				<div class="rTable">

					<form:form
						action="${pageContext.request.contextPath}/user/register"
						commandName="user" method="POST" enctype="utf8" role="form">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" />
						<c:if test="${user.signInProvider != null}">
							<form:hidden path="signInProvider" />
						</c:if>
						
						<div>
	                        <div>
								<label for="user-firstName"><spring:message	code="label.user.firstName" />:</label>
	   	                        <div>
									<form:input id="user-firstName" path="firstName" disabled="true" />
									<div class = "error-message">
									    <form:errors id="error-firstName" path="firstName" />
									</div>
								</div>
						    </div>
						</div>
						
						<div>
	                        <div>
								<label for="user-lastName"><spring:message code="label.user.lastName" />:</label>
	   	                        <div>
									<form:input id="user-lastName" path="lastName" disabled="true" />
									<div class = "error-message">
									    <form:errors id="error-lastName" path="lastName" />
									</div>
								</div>
						    </div>
						</div>
						
						<div>
	                        <div>
								<label for="user-email"><spring:message	code="label.user.email" />:</label>
	   	                        <div>
									<form:input id="user-email" path="email" disabled="true" />
									<div class = "error-message">
									    <form:errors id="error-email" path="email" />
									</div>
								</div>
						    </div>
						</div>
						
												
						<c:if test="${user.signInProvider == null}">
							<div>
    	                        <div>
									<label for="user-password"><spring:message code="label.user.password" />:</label>
	    	                        <div>
										<form:password id="user-password" path="password" />
										<div class = "error-message">
										    <form:errors id="error-password" path="password" />
										</div>
									</div>
							    </div>
							</div>
							<div>
    	                        <div>
									<label for="user-passwordVerification"><spring:message code="label.user.passwordVerification" />:</label>
	    	                        <div>
										<form:password id="user-passwordVerification" path="passwordVerification" />
										<div class = "error-message">
										    <form:errors id="error-passwordVerification" path="passwordVerification" />
										</div>
									</div>
						        </div>
						    </div>
						</c:if>
						<br/>
						<button type="submit">
							<spring:message code="label.user.registration.submit.button" />
						</button>
					</form:form>


				</div>

			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<p>
					<spring:message
						code="text.registration.page.authenticated.user.help" />
				</p>
			</sec:authorize>

		</div>
	</div>

</body>
</html>