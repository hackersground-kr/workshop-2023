package com.workshop.chatapi.model;
import io.swagger.v3.oas.annotations.media.Schema;

public class ChatCompletionResponse {
    @Schema(nullable = true)
    private String completion;

    public ChatCompletionResponse(String completion) {
        this.completion = completion;
    }

    public String getCompletion() {
        return completion;
    }

    public void setCompletion(String completion) {
        this.completion = completion;
    }
}
