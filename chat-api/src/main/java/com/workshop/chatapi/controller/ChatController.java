package com.workshop.chatapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import com.workshop.chatapi.model.ChatCompletionRequest;
import com.workshop.chatapi.model.ChatCompletionResponse;
import com.workshop.chatapi.model.ChatRequest;
import com.workshop.chatapi.model.ChatResponse;
import com.workshop.chatapi.model.ErrorResponse;


@Tag(name = "Chat", description = "Related to chat completion")
@RestController
// @RequestMapping("/")
@SecurityRequirement(name="aoai_token")
@SecurityRequirement(name="api_key")
public class ChatController {

    @Qualifier("openaiRestTemplate")
    @Autowired
    private RestTemplate restTemplate;

    @Value("${CHATGPT_API_ENDPOINT}")
    private String chatGPTApiEndpoint;

    @Value("${CHATGPT_API_DEPLOYMENT_ID}")
    private String chatGPTApiDeploymentId;

    @Value("${CHATGPT_API_KEY}")
    private String chatGPTApiKey;

    @Value("${Auth__ApiKey}")
    private String apiKey;

    @ApiResponses(
        value = {
            @ApiResponse(
                responseCode = "200",
                description = "Chat completion response",
                content = @Content(mediaType = "application/json", schema = @Schema(implementation = ChatCompletionResponse.class))
            ),
            @ApiResponse(
                responseCode = "401",
                description = "Unauthorized",
                content = @io.swagger.v3.oas.annotations.media.Content(mediaType = "application/json", schema = @Schema(implementation = ErrorResponse.class))
            ),
            @ApiResponse(
                responseCode = "403",
                description = "Forbidden",
                content = @io.swagger.v3.oas.annotations.media.Content(mediaType = "application/json", schema = @Schema(implementation = ErrorResponse.class))
            )
        }
    )

    @PostMapping("/chat/completions")
    public ResponseEntity<Object> chatCompletions(
        @Parameter(hidden=true) @RequestHeader(value="x-aoai-token", required = false) String aoaiToken,
        @Parameter(hidden=true) @RequestHeader(value="x-webapi-key", required=false) String apiKey,
        @RequestBody ChatCompletionRequest request) {

        // Check if aoai_token is empty
        if (aoaiToken == null || aoaiToken.isEmpty()) {
            ErrorResponse errorResponse = new ErrorResponse("Missing or empty aoai_token");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        } 

        // Check if api_key is empty
        if (apiKey == null || apiKey.isEmpty()) {
            ErrorResponse errorResponse = new ErrorResponse("Missing or empty api_key");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }

        // Check if aoai_token is valid
        if (!aoaiToken.equals(this.chatGPTApiKey)) {
            ErrorResponse errorResponse = new ErrorResponse("Invalid aoai_token");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
        }

        // Check if api_key is valid
        if (!apiKey.equals(this.apiKey)) {
            ErrorResponse errorResponse = new ErrorResponse("Invalid api_key");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
        }


        // Get issue body from the frontend
        String issueBody = request.getPrompt();
        // Set prompt message for chatGPT to generate the completion
        String prompt = "이슈 내용:" + issueBody;

        // Create ChatGPT request
        ChatRequest chatRequest = new ChatRequest(chatGPTApiDeploymentId, prompt);
        // Call ChatGPT API
        ChatResponse chatResponse = this.restTemplate.postForObject(chatGPTApiEndpoint, chatRequest, ChatResponse.class);

        // Handle ChatGPT API response
        if (chatResponse == null || chatResponse.getChoices() == null || chatResponse.getChoices().isEmpty()) {
            return ResponseEntity.ok(new ChatCompletionResponse("ChatGPT API response is empty"));
        }

        // Get the response content only
        String responseContent = chatResponse.getChoices().get(0).getMessage().getContent();

        // Create the response object
        ChatCompletionResponse response = new ChatCompletionResponse(responseContent);

        return ResponseEntity.ok(response);
    }

}