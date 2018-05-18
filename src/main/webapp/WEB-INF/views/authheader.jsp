<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<sec:authorize var="loggedIn" access="isAuthenticated()" />
<c:choose>
    <c:when test="${loggedIn}">
      <div class="authbar">
          <span><spring:message code="authheader.welcome" arguments="<strong>${loggedinuser}</strong>"/> </span> 
          
          <div>
	          <span class="floatRight"><a href="<c:url value="/logout" />"><spring:message code="authheader.logout"/></a></span>
	          <sec:authorize access="hasRole('ADMIN')">
	              <span class="floatRight"><a href="<c:url value="/list" />"><spring:message code="authheader.users"/></a></span>
	          </sec:authorize>
	          <span class="floatRight"><a href="<c:url value="/listEvents" />"><spring:message code="authheader.events"/></a></span>
	          <span class="floatRight"><a href="<c:url value="/listEvents?subscribed=true" />"><spring:message code="authheader.subscribed"/></a></span>
	          <span class="floatRight"><a href="<c:url value="/listEvents?free=true" />"><spring:message code="authheader.notsubscribed"/></a></span>
	          <span class="floatRight"><a href="<c:url value="/myEvents" />"><spring:message code="authheader.edit"/></a></span>
          </div>
      </div>
    </c:when>
    <c:otherwise>
      <div class="authbar">
          <span class="floatRight"><a href="<c:url value="/login" />"><spring:message code="authheader.login"/></a></span>
      </div>
    </c:otherwise>
</c:choose>