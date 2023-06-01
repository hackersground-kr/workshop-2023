package com.workshop.chatapi.model;
import io.swagger.v3.oas.annotations.media.Schema;

public class ChatCompletionRequest {
    @Schema(required=true, minLength = 1)
    private String prompt;

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }
}
