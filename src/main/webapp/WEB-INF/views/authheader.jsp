<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<sec:authorize var="loggedIn" access="isAuthenticated()" />
<c:choose>
    <c:when test="${loggedIn}">
      <div>
          <span><spring:message code="authheader.welcome" arguments="<strong>${loggedinuser}</strong>"/> </span> 
          
          <div>
	          <span><a href="<c:url value="/logout" />"><spring:message code="authheader.logout"/></a></span>
	          <sec:authorize access="hasRole('ADMIN')">
	              <span><a href="<c:url value="/list" />"><spring:message code="authheader.users"/></a></span>
	          </sec:authorize>
	          <span><a href="<c:url value="/listEvents" />"><spring:message code="authheader.events"/></a></span>
	          <span><a href="<c:url value="/listEvents?subscribed=true" />"><spring:message code="authheader.subscribed"/></a></span>
	          <span><a href="<c:url value="/listEvents?free=true" />"><spring:message code="authheader.notsubscribed"/></a></span>
	          <span><a href="<c:url value="/myEvents" />"><spring:message code="authheader.edit"/></a></span>
          </div>
      </div>
    </c:when>
    <c:otherwise>
      <div>
          <span><a href="<c:url value="/login" />"><spring:message code="authheader.login"/></a></span>
      </div>
    </c:otherwise>
</c:choose>
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
