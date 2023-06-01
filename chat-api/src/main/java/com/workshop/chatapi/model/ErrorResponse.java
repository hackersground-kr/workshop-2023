package com.workshop.chatapi.model;
import io.swagger.v3.oas.annotations.media.Schema;

public class ErrorResponse {
    @Schema(nullable = true)
    private String message;

    public ErrorResponse(String message) {
        this.message = message;
    }

    public String getMessage() {
        return this.message;
    }
}
