Start des Documentation Trees

1. ansicht_documentation_tree.lua

Herunterladen des IUP-Lua-Frameworks und des Documentation Trees
Anlegen des Ordners C:\Lua
 
Internetseite öffnen: sourceforge.net/projects/iup/files/3.30/ -> Tools Executables -> Lua54
 
Herunterladen von: iup-3.30-Lua54_Win64_bin.zip
 
Das Herunterladen dauert ein wenig. Zip-komprimierten Ordner im Download-Ordner öffnen.
 
Alle Extrahieren auf den eigenen Rechner auf das C:-Laufwerk
 
Pfad ändern auf: C:\Lua
 
Die Datei ansicht_documentation_tree.lua herunterladen.
 
Im Download-Ordner Doppelklicken, "Wie soll diese Datei geöffnet werden?" -> "Weitere Apps" blättern nach unten
"Andere App auf diesem PC suchen" -> C:\Lua Lua54.exe anklicken.
 
2. Tree.jar
Herunterladen und Starten der LuaJ-Version als Jar-Archiv
Das Jar-Archiv Tree.jar wird heruntergeladen und in einen Ordner der Wahl des Anwenders verschoben.
 
Das Jar-Archiv wird mit einer Starter-Datei als Tree oder als Lua-Konsole gestartet. Ein Beispiel für Bash-Dateien für Linux oder Mac (.sh-Dateien) ist zum Downloaden bereit. Die Windows-Versionen sind Batch-Dateien (.bat). Die Dateien sind im Ordner Tree_jar_Starter zu finden.
 
Beim ersten Starten werden die erforderlichen Lua-Skripte im Startordner angelegt. Die Bäume in der Oberfläche bleiben leer. Beim zweiten Öffnen sind die Bäume gefüllt, und die Verwendung kann starten.

3. html_build_Linux.lua

Dieses Skript verwandelt einen Lua tree in eine html Seite mit Baumansicht. Das ist insbesonders auf mobilen Geräten hilfreich.

Starten des Lua-Skriptes mit den richtigen Pfadangaben der Input- und Outputdateien.

4. html_Tree_relative.lua

Dieses Skript verwandelt einen Lua tree in eine html Seite mit Baumansicht mit relativen Pfadangaben. Das ist insbesonders auf mobilen Geräten wie dem iPhone hilfreich, wo Dateien z.B. mit der App Touch Lua nicht direkt gespeichert werden können. Das Ergebnis ist eine Datei mit der Endung .lua, die in eine html-Datei mit copy and paste eingefügt werden kann.


