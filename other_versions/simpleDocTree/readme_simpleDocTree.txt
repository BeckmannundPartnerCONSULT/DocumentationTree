This repository has a simple version of a documentation tree with only one tree and other functionalities to be able to see documentation trees of databases or other trees

1. simple_documentation_tree.lua

The special functionalities are expand/collapse nodes and sort in alphabetic order.

2.  SQLtoCSVforLua_dependencies_tree.lua

The file SQLtoCSVforLua_dependencies_tree.lua is an example file as input for simple_documentation_tree.lua

3.1 simple_documentation_tree_with_file_dialog.lua

This documentation tree has also a button to load a new tree with a file dialog in the tree loaded at the beginning. To change the tree it must be deleted manually, so that the user can build individual trees by himself.

3.2 simple_documentation_tree_with_file_dialog_Linux.lua

This is the Linux version of the simple_documentation_tree_with_file_dialog.lua. There are minor changes: the path names must be in Linux manner and the tree.addbranch and tree.addleaf are substituted by tree['addbranch' .. tree.value] and tree['addleaf' .. tree.value].

This documentation tree has also a button to load a new tree with a file dialog in the tree loaded at the beginning. To change the tree it must be deleted manually, so that the user can build individual trees by himself.

4. simple_documentation_tree_with_webbrowser.lua

This script is a tree on the left side and a html-Webbrowser on the right side, where nodes of the tree can be associated to webpages shown by going to them.

5. example_tree_for_webbrowser.lua

This is an example as input tree for simple_documentation_tree_with_webbrowser.lua.

6. example_HTML_table_for_webbrowser.lua

This is an example as input HTML webpages in Lua table for simple_documentation_tree_with_webbrowser.lua. 

7. simple_documentation_tree_brackets.lua

This script runs a graphical user interface (GUI) in order to built up a documentation tree of SQL statements or of excel formulas.

8. simple_documentation_tree_with_analysis.lua

This script opens a tree and analysis of it can be done, especially the analysis of dublicate nodes.


9. simple_documentation_tree_with_variables_to_be_filed.lua

This script contains a Lua tree with variables that can be filled by determining unknown variables.

10. simple_documentation_tree_output.lua

This script is a simple documentation of a tree in a Lua table. It produces a tree as a Lua table or the mirror tree in a text field.

11. simple_documentation_tree _IDIV_bureau.lua

This script is a simple documentation of a tree in a Lua table of the IDIV-bureau, so that other persons can see it
