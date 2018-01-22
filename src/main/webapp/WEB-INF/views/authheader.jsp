<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<sec:authorize var="loggedIn" access="isAuthenticated()" />
<c:choose>
    <c:when test="${loggedIn}">
      <div class="authbar">
          <span>Dear <strong>${loggedinuser}</strong>, Welcome to CrazyUsers.</span> 
          <span class="floatRight"><a href="<c:url value="/logout" />">Logout</a></span>
          <sec:authorize access="hasRole('ADMIN')">
              <span class="floatRight"><a href="<c:url value="/list" />">Users</a></span>
          </sec:authorize>
          <span class="floatRight"><a href="<c:url value="/listEvents" />">Events</a></span>
          <span class="floatRight"><a href="<c:url value="/listPlaces" />">Places</a></span>
      </div>
    </c:when>
    <c:otherwise>
      <div class="authbar">
          <span class="floatRight"><a href="<c:url value="/login" />">Login</a></span>
      </div>
    </c:otherwise>
</c:choose>