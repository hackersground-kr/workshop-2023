package com.workshop.chatapi.model;

import java.util.List;
import java.util.ArrayList;
import com.workshop.chatapi.model.Message;

public class ChatRequest {
    private String model;
    private List<Message> messages;
    private int n;
    private double temperature;

    public ChatRequest(String model, String prompt) {
        this.model = model;
        
        this.messages = new ArrayList<>();
        this.messages.add(new Message("user", prompt));
    }


    //getters and setters
    public String getModel() {
        return this.model;
    }

    public List<Message> getMessages() {
        return this.messages;
    }

    public int getN() {
        return this.n;
    }

    public double getTemperature() {
        return this.temperature;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }

    public void setN(int n) {
        this.n = n;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }
}
