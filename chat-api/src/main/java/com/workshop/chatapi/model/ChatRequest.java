package com.workshop.chatapi.model;

import java.util.ArrayList;
import java.util.List;

public class ChatRequest {
    private String model;
    private List<Message> messages;

    public ChatRequest(String model, String prompt) {
        this.model = model;

        this.messages = new ArrayList<>();
        this.messages.add(new Message("system", "너는 깃헙 이슈 요약 봇이야. 내가 전달하는 깃헙 레포 이슈 내용을 한국어로 요약해서 알려줘. 요약 내용은 bullet point 형식으로 알려줘."));
        this.messages.add(new Message("user", prompt));
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public List<Message> getMessages() {
        return messages;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }
}