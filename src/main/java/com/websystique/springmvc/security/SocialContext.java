package com.websystique.springmvc.security;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.*;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.encrypt.Encryptors;
import org.springframework.social.UserIdSource;
import org.springframework.social.config.annotation.ConnectionFactoryConfigurer;
import org.springframework.social.config.annotation.EnableSocial;
import org.springframework.social.config.annotation.SocialConfigurer;
import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.connect.UsersConnectionRepository;
import org.springframework.social.connect.jdbc.JdbcUsersConnectionRepository;
import org.springframework.social.connect.web.ConnectController;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.connect.FacebookConnectionFactory;
import org.springframework.social.security.AuthenticationNameUserIdSource;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import com.websystique.springmvc.controller.BaseProvider;
import com.websystique.springmvc.controller.CustomConnectController;

import java.util.UUID;

import javax.sql.DataSource;
 
@Configuration
@EnableSocial
public class SocialContext implements SocialConfigurer {
	
    @Autowired
    private DataSource dataSource;
 
    @Override
    public void addConnectionFactories(ConnectionFactoryConfigurer cfConfig, Environment env) {
    	FacebookConnectionFactory fcf = new FacebookConnectionFactory(
                env.getProperty("facebook.app.id"),
                env.getProperty("facebook.app.secret")
        );
    	fcf.setScope("public_profile,email");
        cfConfig.addConnectionFactory(fcf);
    }
 
    @Override
    public UserIdSource getUserIdSource() {
    	return new SessionIdUserIdSource();
    }
    
    private static final class SessionIdUserIdSource implements UserIdSource {
    	@Override
        public String getUserId() {
            RequestAttributes request = RequestContextHolder.currentRequestAttributes();
            String uuid = (String) request.getAttribute("_socialUserUUID", RequestAttributes.SCOPE_SESSION);
            if (uuid == null) {
                uuid = UUID.randomUUID().toString();
                request.setAttribute("_socialUserUUID", uuid, RequestAttributes.SCOPE_SESSION);
            }
            return uuid;
        }
    }
 
    @Override
    public UsersConnectionRepository getUsersConnectionRepository(ConnectionFactoryLocator connectionFactoryLocator) {
        return new JdbcUsersConnectionRepository(
                dataSource,
                connectionFactoryLocator,
                Encryptors.noOpText()
        );
    }

    @Bean
    public ConnectController connectController(ConnectionFactoryLocator connectionFactoryLocator, ConnectionRepository connectionRepository) {
    	ConnectController connectController = new CustomConnectController(connectionFactoryLocator, connectionRepository);
        return connectController;
    }
    
    @Bean
    public BaseProvider baseProvider(Facebook facebook, ConnectionRepository connectionRepository) {
    	BaseProvider baseProvider = new BaseProvider(facebook, connectionRepository);
        return baseProvider;
    }

	@Bean
	@Scope(value="request", proxyMode=ScopedProxyMode.INTERFACES)	
	public Facebook facebook(ConnectionRepository connectionRepository) {
	    return connectionRepository.getPrimaryConnection(Facebook.class).getApi();
	}

}