This repository contains different versions of the documentation tree.

IUP-Lua is taken from https://webserver2.tecgraf.puc-rio.br/iup/ with the licence:

Copyright © 1994-2020 Tecgraf/PUC-Rio.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

1.1 IDIV_package.zip and IDIV_package_zip.lua

This zip file contains easy to use package to start with the interactive dynamic table of contents.

The script IDIV_package_zip.lua is used to build IDIV_package.zip.

1.2 ansicht_documentation_tree.lua and nachschlagen_documentation_tree.lua

Download the IUP Lua framework and the documentation tree. Build a directory C:\Lua

Open internet sitesourceforge.net/projects/iup/files/3.30/ -> Tools Executables -> Lua54

Download iup-3.30-Lua54_Win64_bin.zip
 
Download takes a little time. Open zip file in Download directory.

Extract all files on C: path on the local computer.

Change path to C:\Lua

Download the file ansicht_documentation_tree.lua.

Double click on ansicht_documentation_tree.lua and link it to C:\Lua Lua54.exe.

2. Tree.jar

Download and start the LuaJ version as a jar archive. The jar archive has to be downloaded and to be moved in a directory of the choice of the user.

The jar archive is started with a start file as a Tree or as a Lua console. Examples of bash files for Linux and Mac (.sh files) can be downloaded. The windows versions are batch files (.bat).

At the first start the needed Lua scripts are written in the start directory. The trees stay empty. At the second start the trees are filled and the use of them can begin.

3. html_build.lua

This skript converts a Lua tree in a html page with tree. This is especially helpful on mobile devices.

Start of the Lua script with the right informations for path of input and output data.

4. html_Tree_relative.lua

This skript converts a Lua tree in a html page with tree with relative paths. This is especially helpful on mobile devices as the iPhone where such apps as Touch Lua cannot save directly on the target path. The result is stored in a file with extension .lua which can be transfered by copy and paste in a html file on the target path.



