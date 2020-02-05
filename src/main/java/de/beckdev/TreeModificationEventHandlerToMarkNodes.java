/*
 * Copyright 2019 Beckmann & Partner CONSULT
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

import javafx.event.EventHandler;
import javafx.scene.control.Button;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeView;

import static de.beckdev.DocumentationTree.toggleButton;
import static de.beckdev.TreeUtil.*;

public class TreeModificationEventHandlerToMarkNodes implements EventHandler<TreeItem.TreeModificationEvent> {
    final TreeView<TextNode> tree;
    final Button mark;
    final LastClickedItemContainer lastClickedItem;

    public TreeModificationEventHandlerToMarkNodes(final TreeView<TextNode> tree, final Button mark, final LastClickedItemContainer lastClickedItem) {
        this.tree = tree;
        this.mark = mark;
        this.lastClickedItem = lastClickedItem;
    }

    @Override
    public void handle(TreeItem.TreeModificationEvent event) {
        if (lastClickedItem.markedNodes) {
            lastClickedItem.markedNodes = false;
            toggleButton(mark, lastClickedItem.markedNodes);
            resetTree(tree);
            refresh(tree);
        } else {
            lastClickedItem.markedNodes = true;
            toggleButton(mark, lastClickedItem.markedNodes);
            resetTree(tree);
            refresh(tree);
            setColorOtherNodes(tree.getRoot(), lastClickedItem.item, "grey", lastClickedItem);
            lastClickedItem.item.getValue().setColor("blue");
            setColorParents(lastClickedItem.item, "red");
            setColorChildren(lastClickedItem.item, "green");
            refresh(tree);
        }
    }
}
