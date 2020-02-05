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
        primaryStage.setTitle("DocumentationTree");

        Path file = chooseFile(primaryStage);

        Pane treeLayout = null;
        Alert alert = null;

        if (file != null) {
            try {
                if (file.getFileName().toString().endsWith("lua")) {
                    treeLayout = createTreeLayout(new LuaTableDocumentation(file));
                } else if (file.getFileName().toString().endsWith("xml")) {
                    throw new RuntimeException("Es werden aktuell keine XML-Dateien unterstützt.");
                }
            } catch (RuntimeException | IOException e) {
                String stackTrace = getStackTrace(e);
                alert = getAlert(stackTrace, "Fehler", "Fehler beim Lesen der Datei");
            }
        } else {
            alert = getAlert("Es wurde keine Datei ausgewählt.", "Hinweis", "Keine Datei");
        }

        if (treeLayout == null && alert == null) {
            alert = getAlert("Tree konnte nicht erzeugt werden.", "Fehler beim Erzeugen des Trees", "Fehler");
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

    private Pane createTreeLayout(DocumentationInformation documentation) {
        BorderPane root = new BorderPane();
        final TreeItem<TextNode> rootItem = documentation.getTreeItem();

        final TreeView<TextNode> tree = new TreeView<>();
        tree.setRoot(rootItem);
        final Button mark = new Button("Markieren");
        mark.setDisable(true);
        final LastClickedItemContainer lastClickedItem = new LastClickedItemContainer();
        lastClickedItem.markedNodes = false;
        tree.setCellFactory(new TreeCellFactory(tree, mark, lastClickedItem));
        tree.addEventHandler(TreeItem.branchCollapsedEvent(), new TreeModificationEventHandlerToMarkNodes(tree, mark, lastClickedItem));
        tree.addEventHandler(TreeItem.branchExpandedEvent(), new TreeModificationEventHandlerToMarkNodes(tree, mark, lastClickedItem));
        mark.addEventHandler(MouseEvent.MOUSE_CLICKED, new MouseEventHandlerToMarkNodes(tree, mark, lastClickedItem));
        StackPane center = new StackPane();
        root.setCenter(center);
        center.getChildren().add(tree);
        HBox bottom = new HBox();
        root.setBottom(bottom);
        bottom.getChildren().add(mark);

        return root;
    }

    static void toggleButton(Button mark, boolean markedNodes) {
        if (markedNodes) {
            mark.setText("Markierungen löschen");
        } else {
            mark.setText("Markieren");
        }
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
