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

import javafx.scene.control.TreeItem;
import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;
import org.luaj.vm2.lib.jse.JsePlatform;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

public class LuaTableDocumentation implements DocumentationInformation {

    private Map<String, TextNode> nodes = new HashMap<>();
    private Globals globals = JsePlatform.standardGlobals();
    private TreeItem<TextNode> items;


    public LuaTableDocumentation(Path input) throws IOException {

        String script = new String(Files.readAllBytes(input));
        LuaValue result = globals.load(script);
        LuaTable table = result.checkfunction().call().checktable();

        items = iterateOverLuaTableEntriesRecursively(nodes, table);
    }

    @Override
    public TreeItem<TextNode> getTreeItem() {
        return items;
    }

    private TreeItem<TextNode> iterateOverLuaTableEntriesRecursively(Map<String, TextNode> textNodes, LuaTable table) {
        String branchname = table.get("branchname").tojstring();
        if (!textNodes.containsKey(branchname)) {
            addTextNode(textNodes, null, branchname);
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
    private TreeItem<TextNode> getTextNodeTreeItem(Map<String, TextNode> textNodes, LuaValue key, LuaValue value) {
        TreeItem<TextNode> newTreeItem = null;
        if (value.istable()) {
            LuaTable checktable = value.checktable();
            if (!checkTableForPrefix(checktable)) {
                newTreeItem = iterateOverLuaTableEntriesRecursively(textNodes, checktable);
            } else {
                LuaValue luaValue = value.checktable().get(1);
                if (!luaValue.isnil()) {
                    String prefix = getPrefix(checktable);
                    String text = luaValue.tojstring();
                    newTreeItem = createTextNodeTreeItem(textNodes, prefix, text);
                }
            }
        } else if (value.isstring()) {
            String text = value.checkstring().tojstring();
            if (!key.checkstring().tojstring().equals("branchname") && !key.checkstring().tojstring().equals("state")) {
                newTreeItem = createTextNodeTreeItem(textNodes, null, text);
            }
        }
        return newTreeItem;
    }

    private boolean checkTableForPrefix(LuaTable table) {
        return getPrefix(table) != null;
    }

    private String getPrefix(LuaTable table) {
        LuaValue lastKey = LuaValue.NIL;
        Varargs tableItem;
        while (!(tableItem = getNextTableItem(table, lastKey)).arg1().isnil()) {
            if (!(lastKey = tableItem.arg1()).isnil()) {
                String key = lastKey.checkstring().tojstring();
                if (key.equals("prefix")) {
                    return table.get("prefix").tojstring();
                }
            }
        }
        return null;
    }

    private TreeItem<TextNode> createTextNodeTreeItem(Map<String, TextNode> textNodes, String prefix, String text) {
        if (!textNodes.containsKey((prefix == null ? text : prefix.concat(text)))) {
            addTextNode(textNodes, prefix, text);
        }
        if (prefix == null) {
            return new TreeItem(textNodes.get(text));
        } else {
            return new TreeItem(textNodes.get(prefix.concat(text)));
        }
    }

    private Varargs getNextTableItem(LuaTable table, LuaValue key) {
        return table.next(key);
    }

    private void addTextNode(Map<String, TextNode> nodes, String prefix, String text) {
        TextNode textNode = new TextNode(text);
        if (prefix != null) {
            textNode.setPrefix(prefix);
        }
        nodes.put((prefix == null ? text : prefix.concat(text)), textNode);
    }

    private boolean isBranchCollapsed(LuaTable table) {
        return table.get("state") != LuaValue.NIL ? "COLLAPSED".equals(table.get("state").tojstring()) : false;
    }
}
