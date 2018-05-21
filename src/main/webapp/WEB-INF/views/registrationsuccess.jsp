<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>
        <spring:message code="registration.success.title"/>
    </title>
</head>
<body>
    <div>
        <%@include file="authheader.jsp" %>
         
        <div>
            <c:if test="${operation == 'new'}">
                <spring:message code="registration.success.new" arguments="<strong>${user}</strong>"/> 
            </c:if>
            <c:if test="${operation == 'edit'}">
                <spring:message code="registration.success.edit" arguments="<strong>${user}</strong>"/> 
            </c:if>
        </div>
         
        <span>
            <spring:message code="registration.success.goto"/>
            <a href="<c:url value='/list' />">
                <spring:message code="registration.success.usersList"/>
            </a>
        </span>
    </div>
</body>
 
</html>