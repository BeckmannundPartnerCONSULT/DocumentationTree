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

import javafx.scene.control.TreeCell;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeView;
import javafx.scene.control.cell.TextFieldTreeCell;
import javafx.scene.input.MouseEvent;
import javafx.util.Callback;

public class TreeCellFactory implements Callback<TreeView<TextNode>, TreeCell<TextNode>> {
    final TreeView<TextNode> tree;
    final LastMarkedItemContainer lastClickedItem;

    public TreeCellFactory(final TreeView<TextNode> tree, final LastMarkedItemContainer lastClickedItem) {
        this.tree = tree;
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
                } else {
                    setStyle(null);
                }
                super.updateItem(item, empty);
            }
        };
        textFieldTreeCell.addEventHandler(MouseEvent.MOUSE_CLICKED, (event) -> {
            TextFieldTreeCell source = (TextFieldTreeCell) event.getSource();
            TreeItem<TextNode> selectedItem = tree.getSelectionModel().getSelectedItem();
            if (selectedItem != null && selectedItem.equals(source.getTreeItem())) {
                lastClickedItem.item = source.getTreeItem();
            }
        });
        return textFieldTreeCell;
    }
}
