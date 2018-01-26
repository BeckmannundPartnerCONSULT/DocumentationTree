package de.beckdev;

import java.util.Objects;

public class TextNode {
    private String text;
    private String color;


    public TextNode(String text) {
        this.text = text;
        this.color = "#ffffff";
    }

    public TextNode(String text, String color) {
        this.text = text;
        this.color = color;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    @Override
    public String toString() {
        return text;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TextNode textNode = (TextNode) o;
        return Objects.equals(text, textNode.text) &&
                Objects.equals(color, textNode.color);
    }

    @Override
    public int hashCode() {

        return Objects.hash(text, color);
    }
}
