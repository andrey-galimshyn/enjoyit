package com.websystique.springmvc.service;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;



@Service("emailService")
public class EmailServiceImpl  implements EmailService  {

    @Autowired
    private TaskExecutor taskExecutor;

    @Autowired
    public JavaMailSender emailSender;

    public void sendSimpleMessage(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            message.setFrom("andrey.galimshyn@gmail.com");

            emailSender.send(message);
        } catch (MailException exception) {
            exception.printStackTrace();
        }
    }

    public void sendEmail(final String to, String subject, String msg) {
    	   taskExecutor.execute( new Runnable() {
    		   public void run() {
    		    try {
    		  
    		        final String from ="andrey.galimshyn@gmail.com";
    		        final  String password ="1Heckfyjdf";


    		        Properties props = new Properties();  
    		        props.setProperty("mail.transport.protocol", "smtp");     
    		        props.setProperty("mail.host", "smtp.gmail.com");  
    		        props.put("mail.smtp.auth", "true");  
    		        props.put("mail.smtp.port", "465");  
    		        props.put("mail.debug", "true");  
    		        props.put("mail.smtp.socketFactory.port", "465");  
    		        props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");  
    		        props.put("mail.smtp.socketFactory.fallback", "false");  
    		        Session session = Session.getDefaultInstance(props,  
    		        new javax.mail.Authenticator() {
    		           protected PasswordAuthentication getPasswordAuthentication() {  
    		           return new PasswordAuthentication(from,password);  
    		       }  
    		       });  

    		       //session.setDebug(true);  
    		       Transport transport = session.getTransport();  
    		       InternetAddress addressFrom = new InternetAddress(from);  

    		       MimeMessage message = new MimeMessage(session);  
    		       message.setSender(addressFrom);  
    		       //
    		       message.setSubject(subject, "utf-8");  

    		       message.setContent(msg, "text/html; charset=utf-8");
    		       message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));  

    		       transport.connect();  
    		       Transport.send(message);  
    		       transport.close();

    		    } catch (Exception e) {
    		     e.printStackTrace();
    		    }
    		   }
    		  });
    }
    
    @Override
    public void sendSimpleMessageUsingTemplate(String to,
                                               String subject,
                                               SimpleMailMessage template,
                                               String ...templateArgs) {
        String text = String.format(template.getText(), templateArgs);  
        sendSimpleMessage(to, subject, text);
    }


}
