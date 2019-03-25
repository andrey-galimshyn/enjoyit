<%@ page isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
 
<html>
 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title><spring:message code="user.profile.edit.title"/></title>
    
</head>
 
<body>
    <div align="center" >
    

        <%@include file="authheader.jsp" %>
        
        <sec:authorize var="loggedIn" access="isAuthenticated()" />
        
	  <script type="text/javascript">

		  var listOfEventsItemShow = document.getElementById("listOfEventsItem");
		  if (listOfEventsItemShow !== null) {
			  listOfEventsItemShow.style.visibility = "visible";
		  }

		  var eventsTypeFilterDropdown = document.getElementById("eventsTypeFilter");
		  if (eventsTypeFilterDropdown !== null) {
			  eventsTypeFilterDropdown.style.display = "none";
		  }

	  </script>

        <div class="body-event-edit-container" align="left">
        
           <h2><spring:message code="user.profile.header"/></h2>

           <c:if test="${ loggedIn && user.email == loggedinuserEmail }">

		        <form:form method="POST" modelAttribute="user">
		            <form:input type="hidden" path="email" id="email"/>
		             
		            <div>
		                <div>
		                    <br/>
		                    <label for="firstName"><spring:message code="user.profile.edit.firstName"/></label>
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
		                    <br/>
		                    <label for="lastName"><spring:message code="user.profile.edit.lastName"/></label>
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
		                    <br/>
			                <span><b> <spring:message code="user.profile.edit.email"/> </b> </span>
			                <div>
			                    <span> ${user.email} </span>
			                </div>
		                </div>
		            </div>
	
		            <div>
		                <div>
		                    <br/>
		                    <label for="socialProfURL"><spring:message code="user.profile.edit.socprofileurl"/></label>
		                    <div>
		                        <form:input type="url" path="socialProfURL" id="socialProfURL" />
		                        <div>
		                            <form:errors path="socialProfURL"/>
		                        </div>
		                    </div>
		                </div>
		            </div>
	
		            <div>
		                <div>
		                    <br/>
		                    <label for="aboutMe"><spring:message code="user.profile.edit.aboutme"/></label>
		                    <div>
			                    <form:textarea type="text" path="aboutMe" id="aboutMe" rows="5" cols="40"/>
		                        <div>
		                            <form:errors path="aboutMe"/>
		                        </div>
		                    </div>
		                </div>
		            </div>
	    
		            <div>
		                <div>
		                    <br/>
	                        <spring:message code="user.profile.edit.update" var="update"/>
	                        <input type="submit" value="${update}"/> or <a href="<c:url value='/list' />"><spring:message code="user.edit.cancel"/></a>
		                </div>
		            </div>
		        </form:form>
		        
		        <!-- Reports -->
	            <div>
	                <div>
	                    <a href="<c:url value='/report'/>">
	                        <spring:message code="user.profile.events.report"/>
	                    </a>
	                </div>
	            </div>
		        <!-- Subscribed -->
	            <div>
	                <div>
	                    <a href="<c:url value='/subscribed'/>">
	                        <spring:message code="user.profile.events.subscribed"/>
	                    </a>
	                </div>
	            </div>

	        </c:if>
	        
	        
	        <c:if test="${ not loggedIn || user.email != loggedinuserEmail }">
	        
		        <div>
		            <div>
		                <span><b> <spring:message code="user.profile.edit.firstName"/> </b> </span>
		                <div>
		                    <span> ${user.firstName} </span>
		                </div>
		            </div>
		            <div>
		                <span><b> <spring:message code="user.profile.edit.lastName"/> </b> </span>
		                <div>
		                    <span><span> ${user.lastName} </span></span>
		                </div>
		            </div>
		            <div>
		                <span><b> <spring:message code="user.profile.edit.email"/> </b> </span>
		                <div>
		                    <span> ${user.email} </span>
		                </div>
		            </div>
		            <div>
		                <span><b> <spring:message code="user.profile.edit.socprofileurl"/> </b> </span>
		                <div>
		                    <span> 
		                        <c:if test="${ not empty user.socialProfURL }">
		                            <a href="<c:url value='${user.socialProfURL}' />">${user.socialProfURL}</a>
		                        </c:if>
		                    </span>
		                </div>
		            </div>
		            <div>
		                <span><b> <spring:message code="user.profile.edit.aboutme"/> </b> </span>
		                <div>
		                    <span> ${user.aboutMe} </span>
		                </div>
		            </div>
		        </div>
	        
	        </c:if>

        </div>
        
        
        <%@include file="footer.jsp" %>        
        
    </div>
</body>
</html>