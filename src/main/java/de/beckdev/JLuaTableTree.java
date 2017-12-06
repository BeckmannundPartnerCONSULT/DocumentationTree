package de.beckdev;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.scene.layout.StackPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
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

public class JLuaTableTree extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
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

                TreeItem<String> rootItem = iterateOnTable(table);
                TreeView<String> tree = new TreeView<>(rootItem);
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
            primaryStage.setScene(new Scene(root, 300, 250));
            primaryStage.show();
        }
    }



    private static TreeItem iterateOnTable(LuaTable table) {
        String branchname = table.get("branchname").tojstring();
        TreeItem treeNode = new TreeItem(branchname);
        boolean collapsed = table.get("state") != LuaValue.NIL ? "COLLAPSED".equals(table.get("state").tojstring()) : false;
        Varargs n;
        LuaValue k = LuaValue.NIL;
        while (!(n = table.next(k)).arg1().isnil()) {
            if (!(k = n.arg1()).isnil()) {
                LuaValue v = n.arg(2);

                TreeItem newNode = null;
                if (v.istable()) {
                    LuaTable checktable = v.checktable();
                    newNode = iterateOnTable(checktable);
                } else if (v.isstring()) {
                    if (!k.checkstring().tojstring().equals("branchname")) {
                        newNode = new TreeItem(v.checkstring().tojstring());
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
