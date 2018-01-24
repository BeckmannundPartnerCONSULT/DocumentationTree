package de.beckdev;

import javafx.application.Application;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.TextFieldTreeCell;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.scene.layout.StackPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import javafx.util.Callback;
import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;
import org.luaj.vm2.lib.jse.JsePlatform;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

public class JLuaTableTree extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws URISyntaxException {
        primaryStage.setTitle("Lua Table Tree");

        FileChooser fileChooser = new FileChooser();
        fileChooser.setInitialDirectory(new File("."));
        File file = fileChooser.showOpenDialog(primaryStage);

        StackPane root = new StackPane();
        String message = null;
        String header = null;
        String title = null;
        if (file != null) {

            try {
                Globals globals = JsePlatform.standardGlobals();

                Path input = file.toPath();
                String script = new String(Files.readAllBytes(input));
                LuaValue result = globals.load(script);
                LuaTable table = result.checkfunction().call().checktable();

                Map<String, TextNode> nodes = new HashMap<>();
                final TreeItem<TextNode> rootItem = iterateOnTable(nodes, table);
                final TreeView<TextNode> tree = new TreeView<>(rootItem);
                final LastClickedItemContainer lastClickedItem = new LastClickedItemContainer();
                tree.setCellFactory(new Callback<TreeView<TextNode>,TreeCell<TextNode>>() {
                    @Override
                    public TreeCell<TextNode> call(final TreeView<TextNode> p) {
                        final TextFieldTreeCell textFieldTreeCell = new TextFieldTreeCell() {
                            @Override
                            public void updateItem(Object item, boolean empty) {
                                if (item != null) {
                                    TextNode textNode = (TextNode) item;
                                    setStyle("-fx-base: " + textNode.getColor() + ";");
                                    System.out.println("Changed color " + textNode.getColor() + ": " + textNode.getText());
                                }
                                super.updateItem(item, empty);
                            }
                        };
                        textFieldTreeCell.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
                            @Override
                            public void handle(MouseEvent event) {
                                System.out.println("Clicked item");
                                if (lastClickedItem.lastClickedItem != null) {
                                    setColorParents(lastClickedItem.lastClickedItem, "#ffffff");
                                    setColorChildren(lastClickedItem.lastClickedItem, "#ffffff");
                                }
                                TextFieldTreeCell source = (TextFieldTreeCell) event.getSource();
                                TreeItem<TextNode> treeItem = source.getTreeItem();

                                treeItem.getValue().setColor("blue");
                                setColorParents(treeItem, "red");
                                setColorChildren(treeItem, "green");
                                tree.refresh();
                                lastClickedItem.lastClickedItem = treeItem;
                            }
                        });
                        return textFieldTreeCell;
                    }
                });
                root.getChildren().add(tree);
            } catch (RuntimeException | IOException e) {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);

                title = "Fehler";
                header = "Fehler beim Lesen der Datei";
                message = sw.toString();
            }
        } else {
            title = "Hinweis";
            header = "Keine Datei";
            message = "Es wurde keine Datei ausgewählt.";
        }

        if (message != null) {
            Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setTitle(title);
            alert.setHeaderText(header);
            if (message.length() < 100) {
                alert.setContentText(message);
            } else {
                alert.setAlertType(Alert.AlertType.ERROR);
                Label label = new Label("Eine Ausnahme ist aufgetreten:");
                TextArea textArea = new TextArea(message);
                textArea.setEditable(false);
                textArea.setWrapText(true);

                textArea.setMaxWidth(Double.MAX_VALUE);
                textArea.setMaxHeight(Double.MAX_VALUE);
                GridPane.setVgrow(textArea, Priority.ALWAYS);
                GridPane.setHgrow(textArea, Priority.ALWAYS);

                GridPane expContent = new GridPane();
                expContent.setMaxWidth(Double.MAX_VALUE);
                expContent.add(label, 0, 0);
                expContent.add(textArea, 0, 1);

                alert.getDialogPane().setExpandableContent(expContent);
            }
            alert.showAndWait();
        } else {
            Scene scene = new Scene(root, 300, 250);
            scene.getStylesheets().add("/tree.css");
            primaryStage.setScene(scene);
            primaryStage.show();
        }
    }

    private void setColorParents(TreeItem<TextNode> item, String color) {
        if (item != null) {
            if (item.getParent() != null) {
                item.getParent().getValue().setColor(color);
                setColorParents(item.getParent(), color);
            }
        }
    }

    private void setColorChildren(TreeItem<TextNode> item, String color) {
        if (item != null) {
            if (item.getChildren() != null) {
                for (TreeItem<TextNode> child : item.getChildren()) {
                    child.getValue().setColor(color);
                    setColorChildren(child, color);
                }
            }
        }
    }

    private static TreeItem<TextNode> iterateOnTable(Map<String, TextNode> nodes, LuaTable table) {
        String branchname = table.get("branchname").tojstring();
        TreeItem<TextNode> treeNode = new TreeItem(new TextNode(branchname));
        boolean collapsed = table.get("state") != LuaValue.NIL ? "COLLAPSED".equals(table.get("state").tojstring()) : false;
        Varargs n;
        LuaValue k = LuaValue.NIL;
        while (!(n = table.next(k)).arg1().isnil()) {
            if (!(k = n.arg1()).isnil()) {
                LuaValue v = n.arg(2);

                TreeItem<TextNode> newNode = null;
                if (v.istable()) {
                    LuaTable checktable = v.checktable();
                    newNode = iterateOnTable(nodes, checktable);
                } else if (v.isstring()) {
                    if (!k.checkstring().tojstring().equals("branchname") && !k.checkstring().tojstring().equals("state")) {
                        String text = v.checkstring().tojstring();
                        if (!nodes.containsKey(text)) {
                            TextNode textNode = new TextNode(text);
                            nodes.put(text, textNode);
                        }
                        newNode = new TreeItem(nodes.get(text));
                    }
                }
                if (newNode != null) {
                    treeNode.getChildren().add(newNode);
                }
            }
        }
        treeNode.setExpanded(!collapsed);
        return treeNode;
    }
}
