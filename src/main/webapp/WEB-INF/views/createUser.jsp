<%@ page isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
 
<html>
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title><spring:message code="user.edit.title"/></title>
</head>
 
<body>
    <div>
        <%@include file="authheader.jsp" %>
 
        <form:form method="POST" modelAttribute="user">
            <form:input type="hidden" path="id" id="id"/>
             
            <div>
                <div>
                    <label for="firstName"><spring:message code="user.edit.firstName"/></label>
                    <div>
                        <form:input type="text" path="firstName" id="firstName"/>
                        <div>
                            <form:errors path="firstName"/>
                        </div>
                    </div>
                </div>
            </div>
     
            <div>
                <div>
                    <label for="lastName"><spring:message code="user.edit.lastName"/></label>
                    <div>
                        <form:input type="text" path="lastName" id="lastName" />
                        <div>
                            <form:errors path="lastName"/>
                        </div>
                    </div>
                </div>
            </div>
     
            <div>
                <div>
                    <label for="ssoid"><spring:message code="user.edit.ssoid"/></label>
                    <div>
                                <form:input type="text" path="ssoid" id="ssoid"/>
                                <div>
                                    <form:errors path="ssoid" />
                                </div>
                    </div>
                </div>
            </div>
     
            <div>
                <div>
                    <label for="password"><spring:message code="user.edit.password"/></label>
                    <div>
                        <form:input type="password" path="password" id="password" />
                        <div>
                            <form:errors path="password"/>
                        </div>
                    </div>
                </div>
            </div>
     
            <div>
                <div>
                    <label for="email"><spring:message code="user.edit.email"/></label>
                    <div>
                        <form:input type="text" path="email" id="email" />
                        <div>
                            <form:errors path="email"/>
                        </div>
                    </div>
                </div>
            </div>
     
            <div>
                <div>
                    <label for="userProfiles"><spring:message code="user.edit.role"/></label>
                    <div>
                        <form:select path="userProfiles" items="${roles}" multiple="true" itemValue="id" itemLabel="type" />
                        <div>
                            <form:errors path="userProfiles" />
                        </div>
                    </div>
                </div>
            </div>
     
            <div>
                <div>
                    <c:choose>
                        <c:when test="${edit}">
                            <spring:message code="user.edit.update" var="update"/>
                            <input type="submit" value="${update}"/> or <a href="<c:url value='/list' />"><spring:message code="user.edit.cancel"/></a>
                        </c:when>
                        <c:otherwise>
                            <spring:message code="user.edit.create" var="create"/>
                            <input type="submit" value="${create}"/> or <a href="<c:url value='/list' />"><spring:message code="user.edit.cancel"/></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </form:form>
    </div>
</body>
</html>