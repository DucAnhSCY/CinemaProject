package com.N07.CinemaProject.config;

import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;

import jakarta.servlet.MultipartConfigElement;

@Configuration
public class MultipartConfig {

    /**
     * Tùy chỉnh cấu hình multipart cho Tomcat
     */
    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
        return factory -> {
            factory.addContextCustomizers(context -> {
                // Tăng giới hạn số lượng file và parameter
                context.addParameter("maxParameterCount", "10000");
                context.addParameter("maxPostSize", "52428800"); // 50MB
            });
            
            // Cấu hình connector
            factory.addConnectorCustomizers(connector -> {
                connector.setMaxPostSize(52428800); // 50MB
                connector.setMaxParameterCount(10000);
            });
        };
    }

    /**
     * Cấu hình MultipartResolver
     */
    @Bean
    public MultipartResolver multipartResolver() {
        StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
        resolver.setResolveLazily(true);
        return resolver;
    }

    /**
     * Cấu hình MultipartConfigElement
     */
    @Bean
    public MultipartConfigElement multipartConfigElement() {
        return new MultipartConfigElement(
            System.getProperty("java.io.tmpdir"),    // location
            10485760L,                               // maxFileSize (10MB)
            52428800L,                               // maxRequestSize (50MB)
            2048                                     // fileSizeThreshold (2KB)
        );
    }
}
