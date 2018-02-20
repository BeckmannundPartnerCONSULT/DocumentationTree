/*
 * Copyright 2018 Jens Kötterheinrich
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package de.beckdev;

import com.sun.javafx.scene.control.skin.TreeViewSkin;
import javafx.application.Application;
import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.TextFieldTreeCell;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
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
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

public class JLuaTableTree extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("DocumentationTree");

        File file = chooseFile(primaryStage);

        Pane treeLayout = null;
        Alert alert = null;

        if (file != null) {
            final Button mark = new Button("Markieren");
            mark.setDisable(true);
            try {
                treeLayout = createTreeLayout(file, mark);
            } catch (RuntimeException | IOException e) {
                String stackTrace = getStackTrace(e);
                alert = getAlert(stackTrace, "Fehler", "Fehler beim Lesen der Datei");
            }
        } else {
            alert = getAlert("Es wurde keine Datei ausgewählt.", "Hinweis", "Keine Datei");
        }

        if (treeLayout == null) {
            alert = getAlert("Tree konnte nicht erzeugt werden.", "Fehler beim Erzeugen des Tress", "Fehler");
        }

        if (alert != null) {
            alert.showAndWait();
        } else if (treeLayout != null) {
            Scene scene = new Scene(treeLayout, 300, 250);
            scene.getStylesheets().add("/tree.css");
            primaryStage.setScene(scene);
            primaryStage.show();
        }
    }

    private String getStackTrace(Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    private Alert getAlert(String message, String header, String title) {
        Alert alert = null;
        if (message.length() < 100) {
            alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setContentText(message);
        } else {
            alert = new Alert(Alert.AlertType.ERROR);
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
        alert.setTitle(title);
        alert.setHeaderText(header);
        return alert;
    }

    private Pane createTreeLayout(File file, final Button mark) throws IOException {
        BorderPane root = new BorderPane();
        final TreeView<TextNode> tree = new TreeView<>();
        final TreeItem<TextNode> rootItem = createTreeFromLuaTable(file);
//        rootItem.addEventHandler(TreeItem.childrenModificationEvent(), new EventHandler<TreeItem.TreeModificationEvent<Object>>() {
//            @Override
//            public void handle(TreeItem.TreeModificationEvent<Object> event) {
//                resetTree(tree);
//            }
//        });
        tree.setRoot(rootItem);
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
                        }
                        super.updateItem(item, empty);
                    }
                };
                textFieldTreeCell.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
                    @Override
                    public void handle(MouseEvent event) {
                        TextFieldTreeCell source = (TextFieldTreeCell) event.getSource();
                        if (source.getTreeItem().equals(tree.getSelectionModel().getSelectedItem())) {
                            mark.setDisable(false);
                            lastClickedItem.markNodes = true;
                            resetTree(tree);
                            refresh(tree);
                            mark.setText("Markieren");

                            refresh(tree);
                            lastClickedItem.lastClickedItem = source.getTreeItem();
                        }
                    }
                });
                return textFieldTreeCell;
            }
        });
        mark.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandler<MouseEvent>() {
            @Override
            public void handle(MouseEvent event) {
                if (!lastClickedItem.markNodes) {
                    lastClickedItem.markNodes = true;
                    resetTree(tree);
                    mark.setText("Markieren");
                    refresh(tree);
                } else {
                    lastClickedItem.markNodes = false;
                    resetTree(tree);
                    refresh(tree);
                    setColorOtherNodes(tree.getRoot(), lastClickedItem.lastClickedItem, "grey", lastClickedItem);
                    lastClickedItem.lastClickedItem.getValue().setColor("blue");
                    setColorParents(lastClickedItem.lastClickedItem, "red");
                    setColorChildren(lastClickedItem.lastClickedItem, "green");
                    mark.setText("Markierungen löschen");
                    refresh(tree);
                }
            }
        });
        StackPane center = new StackPane();
        root.setCenter(center);
        center.getChildren().add(tree);
        HBox bottom = new HBox();
        root.setBottom(bottom);
        bottom.getChildren().add(mark);

        return root;
    }

    private File chooseFile(Stage primaryStage) {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setInitialDirectory(new File("."));
        return fileChooser.showOpenDialog(primaryStage);
    }

    private TreeItem<TextNode> createTreeFromLuaTable(File file) throws IOException {
        Globals globals = JsePlatform.standardGlobals();

        Path input = file.toPath();
        String script = new String(Files.readAllBytes(input));
        LuaValue result = globals.load(script);
        LuaTable table = result.checkfunction().call().checktable();

        Map<String, TextNode> nodes = new HashMap<>();
        return iterateOverLuaTableEntriesRecursively(nodes, table);
    }

    private void setColorOtherNodes(TreeItem<TextNode> node, TreeItem<TextNode> nodeToSearch, String color, LastClickedItemContainer lastClickedItemContainer) {
        ObservableList<TreeItem<TextNode>> children = node.getChildren();
        for (TreeItem<TextNode> child : children) {
            if (!child.equals(lastClickedItemContainer.lastClickedItem)) {
                if (!child.getChildren().isEmpty()) {
                    setColorOtherNodes(child, nodeToSearch, color, lastClickedItemContainer);
                }
                if (child.getValue().equals(nodeToSearch.getValue())) {
                    setColorParents(child, color);
                }
            }

        }
    }

    private static void resetTree(TreeView<TextNode> tree) {
        tree.getRoot().getValue().setColor("#ffffff");
        setColorChildren(tree.getRoot(), "#ffffff");
        setColorParents(tree.getRoot(), "#ffffff");
    }

    private Object refresh(TreeView<TextNode> tree) {
        return tree.getProperties().put(TreeViewSkin.RECREATE, Boolean.TRUE);
    }

    private static void setColorParents(TreeItem<TextNode> item, String color) {
        if (item != null) {
            if (item.getParent() != null) {
                item.getParent().getValue().setColor(color);
                setColorParents(item.getParent(), color);
            }
        }
    }

    private static void setColorChildren(TreeItem<TextNode> item, String color) {
        if (item != null) {
            if (item.getChildren() != null) {
                for (TreeItem<TextNode> child : item.getChildren()) {
                    child.getValue().setColor(color);
                    setColorChildren(child, color);
                }
            }
        }
    }

    private static TreeItem<TextNode> iterateOverLuaTableEntriesRecursively(Map<String, TextNode> textNodes, LuaTable table) {
        String branchname = table.get("branchname").tojstring();
        if (!textNodes.containsKey(branchname)) {
            addTextNode(textNodes, branchname);
        }
        boolean collapsed = isBranchCollapsed(table);
        TreeItem<TextNode> treeNode = new TreeItem(textNodes.get(branchname));
        treeNode.setExpanded(!collapsed);
        LuaValue lastKey = LuaValue.NIL; // start with first item of table
        Varargs tableItem;
        while (!(tableItem = getNextTableItem(table, lastKey)).arg1().isnil()) {
            if (!(lastKey = tableItem.arg1()).isnil()) {
                LuaValue value = tableItem.arg(2); // table or string
                TreeItem<TextNode> newTreeItem = getTextNodeTreeItem(textNodes, lastKey, value);
                if (newTreeItem != null) {
                    treeNode.getChildren().add(newTreeItem);
                }
            }
        }
        return treeNode;
    }

    /**
     * Either recursively iterates over a LuaTables entries and return a TreeItem with other TreeItems
     * or return a single TreeItem (lowest level).
     *
     * @param textNodes
     * @param key
     * @param value
     * @return TreeItem based on the entries of LuaTable
     */
    private static TreeItem<TextNode> getTextNodeTreeItem(Map<String, TextNode> textNodes, LuaValue key, LuaValue value) {
        TreeItem<TextNode> newTreeItem = null;
        if (value.istable()) {
            LuaTable checktable = value.checktable();
            newTreeItem = iterateOverLuaTableEntriesRecursively(textNodes, checktable);
        } else if (value.isstring()) {
            if (!key.checkstring().tojstring().equals("branchname") && !key.checkstring().tojstring().equals("state")) {
                String text = value.checkstring().tojstring();
                if (!textNodes.containsKey(text)) {
                    addTextNode(textNodes, text);
                }
                newTreeItem = new TreeItem(textNodes.get(text));
            }
        }
        return newTreeItem;
    }

    private static Varargs getNextTableItem(LuaTable table, LuaValue key) {
        return table.next(key);
    }

    private static void addTextNode(Map<String, TextNode> nodes, String branchname) {
        TextNode textNode = new TextNode(branchname);
        nodes.put(branchname, textNode);
    }

    private static boolean isBranchCollapsed(LuaTable table) {
        return table.get("state") != LuaValue.NIL ? "COLLAPSED".equals(table.get("state").tojstring()) : false;
    }
}
