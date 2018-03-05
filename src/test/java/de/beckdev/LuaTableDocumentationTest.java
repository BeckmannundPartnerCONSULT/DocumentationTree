package de.beckdev;

import javafx.scene.control.TreeItem;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class LuaTableDocumentationTest {

    @Test
    public void getTreeItem() throws URISyntaxException, IOException {
        String filename = "/iupluaBaumObjektorientiertAlleAbfragenSchnittstelleLuaTabellen.lua";
        LuaTableDocumentation documentation = new LuaTableDocumentation(Paths.get(getClass().getResource(filename).toURI()));
        TreeItem<TextNode> treeItem = documentation.getTreeItem();

        assertNotNull(treeItem);
        TextNode node = treeItem.getValue();
        assertEquals("Datenbankzusammenhänge objektorientiert", node.getText());
        assertEquals("#ffffff", node.getColor());
    }
}
