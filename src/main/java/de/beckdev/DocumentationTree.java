/*
 * Copyright 2018 Beckmann & Partner CONSULT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package de.beckdev;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.*;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.file.Path;

public class DocumentationTree extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
        BorderPane content = new BorderPane();
        LastMarkedItemContainer lastMarkedItem = new LastMarkedItemContainer();
        TreeView<TextNode> tree = createTree(new EmptyDocumentation(), lastMarkedItem);
        MenuBar menuBar = createMenuBar(primaryStage, tree, lastMarkedItem);
        content.setTop(menuBar);
        content.setCenter(createTreeLayout(tree));

        primaryStage.setTitle("DocumentationTree");
        Scene scene = createScene(primaryStage, new VBox(content));
        primaryStage.setScene(scene);
        content.prefHeightProperty().bind(scene.heightProperty());
        content.prefWidthProperty().bind(scene.widthProperty());
        primaryStage.show();
    }

    private MenuBar createMenuBar(Stage primaryStage, TreeView<TextNode> tree, LastMarkedItemContainer lastMarkedItem) {
        MenuBar menuBar = new MenuBar();
        Menu menu = new Menu("Datei");
        MenuItem menuItem = new MenuItem("Öffnen...");
        menu.getItems().add(menuItem);
        menuBar.getMenus().add(menu);
        menuItem.setOnAction(e -> {
            Path file = chooseFile(primaryStage);
            if (file != null) {
                try {
                    DocumentationInformation documentation = createDocumentation(file);
                    if (documentation != null) {
                        tree.setRoot(documentation.getTreeItem());
                        lastMarkedItem.item = null;
                    } else {
                        getAlert("Tree konnte nicht erzeugt werden.", "Fehler beim Erzeugen des Trees", "Fehler").showAndWait();
                    }
                } catch (Exception exception) {
                    String stackTrace = getStackTrace(exception);
                    getAlert(stackTrace, "Fehler", "Fehler beim Lesen der Datei").showAndWait();
                }
            } else {
                getAlert("Es wurde keine Datei ausgewählt.", "Hinweis", "Keine Datei").showAndWait();
            }
        });
        Label mark = new Label("Markieren");
        Menu markMenu = new Menu("", mark);
        mark.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandlerToMarkNodes<>(tree, lastMarkedItem));
        menuBar.getMenus().add(markMenu);
        Label reset = new Label("Markierung zurücksetzen");
        Menu resetMenu = new Menu("", reset);
        reset.addEventHandler(MouseEvent.MOUSE_CLICKED, new EventHandlerToResetNodes<>(tree, lastMarkedItem));
        menuBar.getMenus().add(resetMenu);
        return menuBar;
    }

    private DocumentationInformation createDocumentation(Path file) throws IOException {
        if (file.getFileName().toString().endsWith("lua")) {
            return new LuaTableDocumentation(file);
        } else if (file.getFileName().toString().endsWith("xml")) {
            throw new RuntimeException("Es werden aktuell keine XML-Dateien unterstützt.");
        }
        return null;
    }

    private Scene createScene(Stage primaryStage, VBox vBox) {
        Scene scene = new Scene(vBox, 300, 250);
        scene.getStylesheets().add("/tree.css");
        return scene;
    }

    private TreeView<TextNode> createTree(DocumentationInformation documentation, LastMarkedItemContainer lastMarkedItem) {
        final TreeItem<TextNode> rootItem = documentation.getTreeItem();

        final TreeView<TextNode> tree = new TreeView<>();
        tree.setRoot(rootItem);
        tree.setCellFactory(new TreeCellFactory(tree, lastMarkedItem));
        tree.addEventHandler(TreeItem.branchCollapsedEvent(), new EventHandlerToMarkNodes<TreeItem.TreeModificationEvent>(tree, lastMarkedItem));
        tree.addEventHandler(TreeItem.branchExpandedEvent(), new EventHandlerToMarkNodes<TreeItem.TreeModificationEvent>(tree, lastMarkedItem));
        tree.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);

        return tree;
    }

    private String getStackTrace(Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    private Alert getAlert(String message, String header, String title) {
        Alert alert;
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

    private Pane createTreeLayout(TreeView<TextNode> tree) {
        BorderPane root = new BorderPane();
        StackPane center = new StackPane();
        root.setCenter(center);
        center.getChildren().add(tree);

        return root;
    }

    private Path chooseFile(Stage primaryStage) {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setInitialDirectory(new File("."));
        fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("Lua-Table", "*.lua"));
        fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("XML", "*.xml"));
        File file = fileChooser.showOpenDialog(primaryStage);
        if (file != null) {
            return file.toPath();
        } else {
            return null;
        }
    }
}
