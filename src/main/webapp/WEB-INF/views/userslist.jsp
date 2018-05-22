<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
 
<head>
    <title><spring:message code="users.list.listTitle"/></title>
</head>
 
<body>
    <div>
        <%@include file="authheader.jsp" %>   
        <div>
              <!-- Default panel contents -->
            <div><span><spring:message code="users.list.listTitle"/></span></div>
            <table>
                <thead>
                    <tr>
                        <th><spring:message code="users.list.firstName"/></th>
                        <th><spring:message code="users.list.lastName"/></th>
                        <th><spring:message code="users.list.email"/></th>
                        <th><spring:message code="users.list.ssoid"/></th>
                        <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                            <th width="100"></th>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ADMIN')">
                            <th width="100"></th>
                        </sec:authorize>
                         
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td>${user.firstName}</td>
                        <td>${user.lastName}</td>
                        <td>${user.email}</td>
                        <td>${user.ssoid}</td>
                        <sec:authorize access="hasRole('ADMIN') or hasRole('DBA')">
                            <td><a href="<c:url value='/edit-user-${user.ssoid}' />">edit</a></td>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ADMIN')">
                            <td><a href="<c:url value='/delete-user-${user.ssoid}' />">delete</a></td>
                        </sec:authorize>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <sec:authorize access="hasRole('ADMIN')">
            <div>
                <a href="<c:url value='/newuser' />"><spring:message code="users.list.addNewuser"/></a>
            </div>
        </sec:authorize>
    </div>
</body>
</html>