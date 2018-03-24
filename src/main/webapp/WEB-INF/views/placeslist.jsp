<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin" />

<html>
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Places List</title>
    <link href="<c:url value='/static/css/bootstrap.css' />" rel="stylesheet"></link>
    <link href="<c:url value='/static/css/app.css' />" rel="stylesheet"></link>
</head>
 
<body>
    <div class="generic-container">

        <%@include file="authheader.jsp" %>




        <div class="panel panel-default">
              <!-- Default panel contents -->
            <div class="panel-heading"><span class="lead">List of Places </span></div>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Number Of Places</th>
                        <th width="100"></th>
                        <th width="100"></th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach items="${places}" var="place">
                    <tr>
                        <td>${place.name}</td>
                        <td>${place.address}</td>
                        <td>${place.placesQuantity}</td>
                        <c:choose>
	                        <c:when test="${(place.recorder.ssoid == loggedinuser) or isAdmin}">
		                        <td>
		                            <a href="<c:url value='/edit-place-${place.id}' />" class="btn btn-success custom-width">edit</a></td>
		                        <td>
		                            <a href="<c:url value='/delete-place-${place.id}' />" class="btn btn-danger custom-width">delete</a>
		                        </td>
	                        </c:when>
	                        <c:otherwise>
		                        <td>
		                        </td>
		                        <td>
		                        </td>
						    </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="well">
            <a href="<c:url value='/newplace' />">Add New Place</a>
        </div>
    </div>
</body>
</html>