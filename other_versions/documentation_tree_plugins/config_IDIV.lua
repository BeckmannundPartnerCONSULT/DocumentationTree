
--1. size of buttons
button_logo=button_logo or {} button_logo.size="23x20"
button_save_lua_table= button_save_lua_table or {} button_save_lua_table.size="95x20"
button_search= button_search or {} button_search.size="55x20"--"85x20"
button_replace= button_replace or {} button_replace.size="85x20"--"105x20"
button_compare= button_compare or {} button_compare.size="85x20"--"105x20"
button_copy_title= button_copy_title or {} button_copy_title.size="105x20"--"105x20"
button_edit_treescript= button_edit_treescript or {} button_edit_treescript.size="75x20"--"105x20"
button_statisticsupdate= button_statisticsupdate or {} button_statisticsupdate.size="65x20"--"105x20"
button_edit_treestatistics= button_edit_treestatistics or {} button_edit_treestatistics.size="75x20"--"105x20"
button_logo2= button_logo2 or {} button_logo2.size="23x20"
tree= tree or {} tree.size="400x300"--"300x200"
textfield1= textfield1 or {} textfield1.size="580x220"--"340x120"
textbox1= textbox1 or {} textbox1.size="300x20"--"340x120"
maindlg.size = 'FULLxFULL'


--5.1.9 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
button_compare.title="Notepad++ öffnen\n(Strg+T: Vergleich)"
function button_compare:flat_action()
	--C:\\notepad++npp.6.8.3.bin\\notepad++.exe oder C:\\Program Files (x86)\\Notepad++\\notepad++.exe
	if file_exists(tree['title']) then inputfile=io.open(tree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(tree['title']) and ErsteZeile then 
		os.execute('start "d" "C:\\Program Files (x86)\\Notepad++\\notepad++.exe" "' .. tree['title'] .. '"')
	elseif file_exists(tree['title']) then 
		os.execute('start "d" "C:\\Program Files (x86)\\Notepad++\\notepad++.exe" "' .. tree['title'] .. '"')
	else
		os.execute('start "d" "C:\\Program Files (x86)\\Notepad++\\notepad++.exe" ')
	end --if file_exists(tree['title']) and ErsteZeile then 
end --function button_compare:flat_action()


--5.1.8.1 start node of tree as a tree GUI or save a new one if not existing
startastree.title = "Als Tree starten"
function startastree:action()
	--look for a tree GUI in the repositories in the path
	--copy the GUI to have the GUI update to the last version used by the GUI from which it starts
	if file_exists(tree['title'] .. '\\' .. thisfilename ) then
	--g:match(".:\\[^\\]+")
		os.execute('copy "' .. path .. '\\' .. thisfilename .. '" "' .. tree['title'] .. '\\' .. thisfilename .. '"')
		--test with: iup.Message("Benutzeroberfläche kopiert",tree['title'] .. '\\' .. thisfilename)
		os.execute('start "D" "' .. tree['title'] .. '\\' .. thisfilename .. '"')
	elseif tree['title']:lower():match("\\archiv")==nil and tree['title']:match("\\[^\\%.]+$") then
		BenutzeroberflaechenText=""
		p=io.popen('dir "' .. tree['title']:match(".:\\[^\\]+") .. '\\' .. thisfilename .. '" /b/o/s')
		for Ordner in p:lines() do BenutzeroberflaechenText=BenutzeroberflaechenText .. Ordner .. "\n" end
		--tree GUI only if user want it
		AnlegeAlarm=iup.Alarm("Benutzeroberfläche angelegen?","Es gibt folgende Benutzeroberflächen:\n" .. BenutzeroberflaechenText .. "\nWas möchten Sie für das Verzeichnis mit der neuen Benutzeroberfläche tun??","Anlegen","Nicht anlegen")
		if AnlegeAlarm==1 then 
			os.execute('copy "' .. path .. '\\' .. thisfilename .. '" "' .. tree['title'] .. '\\' .. thisfilename .. '"')
			iup.Message("Benutzeroberfläche angelegt",tree['title'] .. '\\' .. thisfilename)
		elseif AnlegeAlarm==2 then
			iup.Message("Benutzeroberfläche wird nicht angelegt","Danke, nicht zu viele Benutzeroberflächen anzulegen.")
		end --if AnlegeAlarm==1 then 
	elseif tree['title']:lower():match("\\archiv") then
		iup.Message("Kein Tree bei einem Archiv","Bei einem Archiv (" .. tree['title'] .. ") wird kein Tree angelegt.")
	elseif tree['title']:lower():match("\\[^\\]*tree.*%.lua") then
		inputfile1=io.open(tree['title'],"r")
		textInput=inputfile1:read("*all")
		inputfile1:close()
		if textInput:match('^[^=]*=[^=]*{[^{]*branchname=.*}[^=]*$') then
			os.execute('start "D" C:\\Lua\\lua54.exe C:\\Tree\\simpleDocTree\\simple_documentation_tree.lua "' .. tree['title'] .. '"') 
		else
			iup.Message("Kein Tree", tree['title'] .. " hat keine Baumstruktur als Lua-Tabelle.")
		end --if textInput:match('={branchname=".*}' then
	else 
		iup.Message("Kein Tree","Bei " .. tree['title'] .. " wird kein Tree angelegt.")
	end --if file_exists(tree['title'] .. '\\' .. thisfilename ) then
end --function startastree:action()

