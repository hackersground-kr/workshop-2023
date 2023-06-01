package com.workshop.chatapi;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityScheme.Type;
import io.swagger.v3.oas.models.security.SecurityRequirement;

@Configuration
public class OpenApiConfig {
    @Bean
    public OpenAPI myOpenAPI() {
        Info info = new Info()
            .title("Chat Completion API")
            .version("v1");

        SecurityScheme aoaiToken = new SecurityScheme().type(Type.APIKEY).description("Please enter your AOAI token").name("x-aoai-token").in(SecurityScheme.In.HEADER);
        SecurityScheme apiKey = new SecurityScheme().type(Type.APIKEY).description("Please enter valid API Key").name("x-webapi-key").in(SecurityScheme.In.HEADER);
        SecurityRequirement securityItems = new SecurityRequirement().addList("aoai_token", "api_key");
        
        return new OpenAPI().info(info).components(new Components().addSecuritySchemes("aoai_token", aoaiToken).addSecuritySchemes("api_key", apiKey)).addSecurityItem(securityItems);
    }
}