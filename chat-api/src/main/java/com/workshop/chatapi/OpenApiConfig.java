package com.workshop.chatapi;

import java.util.Arrays;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityScheme.Type;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.Operation;
import io.swagger.v3.oas.models.PathItem;

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

        // Modify the POST operation for 'chat/completions' to include the specific security requirements
        Operation chatCompletionsPostOperation = new Operation()
            .security(Arrays.asList(securityItems));

        return new OpenAPI().info(info).
            components(new Components().
            addSecuritySchemes("aoai_token", aoaiToken).
            addSecuritySchemes("api_key", apiKey)).
            addSecurityItem(securityItems).
            path("/chat/completions", new PathItem().post(chatCompletionsPostOperation));
    }
}