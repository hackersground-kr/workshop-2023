package com.workshop.chatapi.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import com.workshop.chatapi.model.ChatCompletionRequest;
import com.workshop.chatapi.model.ChatCompletionResponse;
import com.workshop.chatapi.model.ErrorResponse;


@Tag(name = "Chat", description = "Related to chat completion")
@RestController
@RequestMapping("/chat")
public class ChatController {

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
    @PostMapping("/completions")
    public ChatCompletionResponse chatCompletions(@RequestBody ChatCompletionRequest request) {
        //Get x-aoai-token header
        //Get x-api-key header
        //if there is no api_key or aoai_token in header, return code 401 with ErrorResponse

        //if the api_key or aoai_token is invalid, return code 403 with ErrorResponse

        // Process the completion request and generate the response
        String completion = generateCompletion(request.getPrompt());
        return new ChatCompletionResponse(completion);
    }

    private String generateCompletion(String prompt) {
        // Logic to generate completion based on the prompt
        // You can use Azure OpenAI or any other method to generate the completion

        //Add Error Handling with ErrorResponse

        return "Generated completion for prompt: " + prompt;
    }

}