<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<sec:authorize var="loggedIn" access="isAuthenticated()" />

<head>


</head>


<body>
    <br/>
	<div class="footer" align="center" >
		<div class="footer-align">
		    Contact: andrey.galimshyn@gmail.com
		</div>
	</div>
</body>
