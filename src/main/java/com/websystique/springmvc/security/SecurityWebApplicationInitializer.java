package com.websystique.springmvc.security;
 
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContext;

import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;
import org.springframework.web.filter.CharacterEncodingFilter;
 
public class SecurityWebApplicationInitializer extends AbstractSecurityWebApplicationInitializer {
	@Override
	protected void beforeSpringSecurityFilterChain(ServletContext servletContext) {
	    FilterRegistration.Dynamic characterEncodingFilter = servletContext.addFilter("encodingFilter", new CharacterEncodingFilter());
	    characterEncodingFilter.setInitParameter("encoding", "UTF-8");
	    characterEncodingFilter.setInitParameter("forceEncoding", "true");
	    characterEncodingFilter.addMappingForUrlPatterns(null, false, "/*");
	}
}