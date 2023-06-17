package com.workshop.chatapi.model;

import java.util.List;

public class ChatResponse {
    private List<Choice> choices;

    // constructors, getters and setters
    public ChatResponse(List<Choice> choices) {
        this.choices = choices;
    }

    public List<Choice> getChoices() {
        return this.choices;
    }

    public void setChoices(List<Choice> choices) {
        this.choices = choices;
    }

    
    public static class Choice {

        private int index;
        private Message message;

        // constructors, getters and setters
        public Choice(int index, Message message) {
            this.index = index;
            this.message = message;
        }

        public int getIndex() {
            return this.index;
        }

        public Message getMessage() {
            return this.message;
        }

        public void setIndex(int index) {
            this.index = index;
        }

        public void setMessage(Message message) {
            this.message = message;
        }
    }
}
