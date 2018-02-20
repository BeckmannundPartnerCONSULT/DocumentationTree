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

import javafx.event.EventHandler;
import javafx.scene.control.Button;
import javafx.scene.control.TreeCell;
import javafx.scene.control.TreeView;
import javafx.scene.control.cell.TextFieldTreeCell;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;

import static de.beckdev.JLuaTableTree.toggleButton;
import static de.beckdev.TreeUtil.refresh;
import static de.beckdev.TreeUtil.resetTree;

public class TreeCellFactory implements Callback<TreeView<TextNode>,TreeCell<TextNode>> {
    final TreeView<TextNode> tree;
    final Button mark;
    final LastClickedItemContainer lastClickedItem;

    public TreeCellFactory(final TreeView<TextNode> tree, final Button mark, final LastClickedItemContainer lastClickedItem) {
        this.tree = tree;
        this.mark = mark;
        this.lastClickedItem = lastClickedItem;
    }

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
                    lastClickedItem.markedNodes = false;
                    resetTree(tree);
                    refresh(tree);
                    toggleButton(mark, lastClickedItem.markedNodes);

                    refresh(tree);
                    lastClickedItem.lastClickedItem = source.getTreeItem();
                }
            }
        });
        return textFieldTreeCell;
    }
}
