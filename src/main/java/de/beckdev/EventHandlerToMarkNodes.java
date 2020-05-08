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

import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.scene.control.TreeView;

import static de.beckdev.TreeUtil.*;

public class EventHandlerToMarkNodes<EVENT extends Event> implements EventHandler<EVENT> {
    final TreeView<TextNode> tree;
    final LastMarkedItemContainer lastMarkedItem;

    public EventHandlerToMarkNodes(final TreeView<TextNode> tree, final LastMarkedItemContainer lastMarkedItem) {
        this.tree = tree;
        this.lastMarkedItem = lastMarkedItem;
    }

    @Override
    public void handle(EVENT event) {
        if (tree.getSelectionModel().getSelectedItem() != null) {
            this.lastMarkedItem.item = tree.getSelectionModel().getSelectedItem();
            TreeUtil.reset(tree);
            refresh(tree);
            setColorOtherNodes(tree.getRoot(), lastMarkedItem.item, "grey", lastMarkedItem);
            lastMarkedItem.item.getValue().setColor("blue");
            setColorParents(lastMarkedItem.item, "red");
            setColorChildren(lastMarkedItem.item, "green");
            refresh(tree);
        }
    }
}
