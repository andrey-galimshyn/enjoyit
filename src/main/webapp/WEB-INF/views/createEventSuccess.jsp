 <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
 
<html>
<head>

    <title><spring:message code="event.edit.confirmation.title"/></title>

</head>
<body>
<div align="center">


    <%@include file="authheader.jsp" %>
    
    <div class="body-container" align="left">

	    <div>
	        <c:if test="${create}">
	            <spring:message code="event.create.success" arguments="<strong>${name}</strong>"/> 
	        </c:if>
	        <c:if test="${!create}">
	            <spring:message code="event.edit.success" arguments="<strong>${name}</strong>"/> 
	        </c:if>
	    </div>
	     
	    <span>
	        <spring:message code="event.edit.confirmation.goto"/>
	        <a href="<c:url value='/listEvents' />">
	        <spring:message code="event.edit.confirmation.eventlist"/>
	        </a>
	    </span>
    </div>   

    <%@include file="footer.jsp" %>

</div>

</body>
 
</html>