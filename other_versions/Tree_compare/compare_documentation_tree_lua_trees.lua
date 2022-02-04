--This script runs a graphical user interface (GUI) in order to built up a documentation tree of the current repository and a documentation of related files and repositories. It displays the tree saved in documentation_tree.lua
--1. basic data

--1.1 libraries and clipboard
--1.1.1 libraries
require('iuplua')           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

--1.1.3 math.integer for Lua 5.1 and Lua 5.2
if _VERSION=='Lua 5.1' then
	function math.tointeger(a) return a end
elseif _VERSION=='Lua 5.2' then
	function math.tointeger(a) return a end
end --if _VERSION=='Lua 5.1' then


--1.1.4 securisation by allowing only necessary os.execute commands
do --sandboxing
local old=os.date("%H%M%S")
local secureTable={}
secureTable[old]=os.execute
function os.execute(a)
if 
a:lower():match("^sftp ") or
a:lower():match("^dir ") or
a:lower():match("^pause") or
a:lower():match("^title") or
a:lower():match("^md ") or
a:lower():match("^copy ") or
a:lower():match("^color ") or
a:lower():match("^start ") or
a:lower():match("^cls") 
then
return secureTable[old](a)
else
print(a .." ist nicht erlaubt.")
end --if a:match("del") then 
end --function os.execute(a)
secureTable[old .. "1"]=io.popen
function io.popen(a)
if 
a:lower():match("^dir ") or
a:lower():match('^"dir ') 
then
return secureTable[old .. "1"](a)
else
print(a .." ist nicht erlaubt.")
end --if a:match("del") then 
end --function os.execute(a)
end --do --sandboxing

--1.2 color section
--1.2.1 color of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe
os.execute('color 71')

--1.2.2 Beckmann und Partner colors
color_red_bpc="135 31 28"
color_light_color_grey_bpc="196 197 199"
color_grey_bpc="162 163 165"
color_blue_bpc="18 32 86"

--1.2.3 color definitions
color_background=color_light_color_grey_bpc
color_buttons=color_blue_bpc -- works only for flat buttons, "18 32 86" is the blue of BPC
color_button_text="255 255 255"
color_background_tree="246 246 246"


--2.1 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)


--test with (status before installment): for k,v in pairs(installTable) do print(k,v) end



--3 functions

--3.1 general lua-functions

--3.1.1 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)

--3.1.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)



--3.2 function to change expand/collapse relying on depth
--This function is needed in the expand/collapsed dialog. This function relies on the depth of the given level.
function change_state_level(new_state,level,descendants_also)
	if descendants_also=="YES" then
		for i=0,tree.count-1 do
			if tree["depth" .. i]==level then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state}) --changing the state of current node
				iup.TreeSetDescendantsAttributes(tree,i,{state=new_state})
			end --if tree["depth" .. i]==level then
		end --for i=0,tree.count-1 do
	else
		for i=0,tree.count-1 do
			if tree["depth" .. i]==level then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state})
			end --if tree["depth" .. i]==level then
		end --for i=0,tree.count-1 do
	end --if descendants_also=="YES" then
end --function change_state_level(new_state,level,descendants_also)


--3.3 function to change expand/collapse relying on keyword
--This function is needed in the expand/collapsed dialog. This function changes the state for all nodes, which match a keyword. Otherwise it works like change_stat_level.
function change_state_keyword(new_state,keyword,descendants_also)
	if descendants_also=="YES" then
		for i=0,tree.count-1 do
			if tree["title" .. i]:match(keyword)~=nil then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state})
				iup.TreeSetDescendantsAttributes(tree,i,{state=new_state})
			end --if tree["title" .. i]:match(keyword)~=nil then
		end --for i=0,tree.count-1 do
	else
		for i=0,tree.count-1 do
			if tree["title" .. i]:match(keyword)~=nil then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state})
			end --if tree["title" .. i]:match(keyword)~=nil then 
		end --for i=0,tree.count-1 do
	end --if descendants_also=="YES" then
end --function change_state_keyword(new_state,level,descendants_also)

--3 functions end


--4. dialogs

--4.1 expand and collapse dialog

--function needed for the expand and collapse dialog
function button_expand_collapse(new_state)
	if toggle_level.value=="ON" then
		if checkbox_descendants_collapse.value=="ON" then
			change_state_level(new_state,tree.depth,"YES")
		else
			change_state_level(new_state,tree.depth)
		end --if checkbox_descendants_collapse.value="ON" then
	elseif toggle_keyword.value=="ON" then
		if checkbox_descendants_collapse.value=="ON" then
			change_state_keyword(new_state,text_expand_collapse.value,"YES")
		else
			change_state_keyword(new_state,text_expand_collapse.value)
		end --if checkbos_descendants_collapse.value=="ON" then
	end --if toggle_level.value="ON" then
end --function button_expand_collapse(new_state)

--button for expanding branches
expand_button=iup.flatbutton{title="Ausklappen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function expand_button:flat_action()
	button_expand_collapse("EXPANDED") --call above function with expand as new state
end --function expand_button:flat_action()

--button for collapsing branches
collapse_button=iup.flatbutton{title="Einklappen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function collapse_button:flat_action()
	button_expand_collapse("COLLAPSED") --call above function with collapsed as new state
end --function collapse_button:flat_action()

--button for cancelling the dialog
cancel_expand_collapse_button=iup.flatbutton{title="Abbrechen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function cancel_expand_collapse_button:flat_action()
	return iup.CLOSE
end --function cancel_expand_collapse_button:flat_action()

--toggle if expand/collapse should be applied to current depth
toggle_level=iup.toggle{title="Nach aktueller Ebene", value="ON"}
function toggle_level:action()
	text_expand_collapse.active="NO"
end --function toggle_level:action()

--toggle if expand/collapse should be applied to search, i.e. to all nodes containing the text in the searchfield
toggle_keyword=iup.toggle{title="Nach Suchwort", value="OFF"}
function toggle_keyword:action()
	text_expand_collapse.active="YES"
end --function toggle_keyword:action()

--radiobutton for toggles, if search field or depth expand/collapse function
radio=iup.radio{iup.hbox{toggle_level,toggle_keyword},value=toggle_level}

--text field for expand/collapse
text_expand_collapse=iup.text{active="NO",expand="YES"}

--checkbox if descendants also be changed
checkbox_descendants_collapse=iup.toggle{title="Auf untergeordnete Knoten anwenden",value="ON"}

--put this together into a dialog
dlg_expand_collapse=iup.dialog{
	iup.vbox{
		iup.hbox{radio},
		iup.hbox{text_expand_collapse},
		iup.hbox{checkbox_descendants_collapse},
		iup.hbox{expand_button,collapse_button,cancel_expand_collapse_button},
	};
	defaultenter=expand_button,
	defaultesc=cancel_expand,
	title="Ein-/Ausklappen",
	size="QUARTER",
	startfocus=searchtext,

}

--4.1 expand and collapse dialog end

--4. dialogs end

--5. no context menus

--6 buttons
--6.1 logo image definition and button wiht logo 
img_logo = iup.image{
  { 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,3,3,1,1,3,3,3,1,1,1,1,1,3,1,1,1,3,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,3,3,1,1,3,1,1,3,1,1,1,1,3,1,1,3,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,3,3,3,3,1,1,1,1,1,3,1,1,3,1,1,1,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,3,3,3,4,4,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,3,3,3,3,4,4,3,3,1,1,1,3,1,1,1,3,1,1,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,3,3,3,3,3,3,3,3,1,1,1,3,1,1,1,3,1,1,1,3,1,1,3,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,3,3,3,3,3,3,3,3,1,1,1,3,3,3,3,1,1,3,1,3,1,1,1,3,1,3,1,1,4,4,4 }, 
  { 4,1,1,1,3,3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,1,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,3,3,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,4,4,4,4,4,4,4,1,1,3,3,1,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,4,4,4,4,4,3,3,4,4,4,4,1,3,3,1,1,1,1,1,1,1,4,4,4,4 },
  { 4,1,1,1,1,1,1,1,4,4,4,4,3,3,3,3,3,3,4,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,4,3,4,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,4,4,4 }, 
  { 4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4 }, 
  { 4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },  
  { 4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 },  
  { 4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },  
  { 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },  
  { 3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },  
  { 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 }  
  ; colors = { color_grey_bpc, color_light_color_grey_bpc, color_blue_bpc, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6.2 button for loading tree 1
button_loading_lua_table_1=iup.flatbutton{title="Ersten Baum aus Lua \nTabelle laden", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_lua_table_1:flat_action()
	tree1.delnode0 = "CHILDREN"
	tree1.title=''
	--build file dialog for reading lua file
	local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.lua",filterinfo="Lua Files",directory=path}
	filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
	if filedlg.status=="1" then
		iup.Message("Neue Datei",filedlg.value)
	elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
		--load tree from file 
		textbox1.value=filedlg.value
		dofile(filedlg.value) --initialize the tree, read from the lua file
		for line in io.lines(filedlg.value) do
			if line:match('=')~= nil then 
				tablename=line:sub(1,line:find('=')-1):gsub(' ', '')
				break
			end --if line:match('=')~= nil then 
		end --for line in io.lines(path_documentation_tree) do
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here	
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..tablename)()	
		else
			load('actualtree='..tablename)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree1,actualtree)
	else
		iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg.status=="1" then
end --function button_loading_lua_table_1:flat_action()

--6.3 button for loading tree 2
button_loading_lua_table_2=iup.flatbutton{title="Zweiten Baum aus Lua \nTabelle laden", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_lua_table_2:flat_action()
	tree2.delnode0 = "CHILDREN"
	tree2.title=''
	--build file dialog for reading lua file
	local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.lua",filterinfo="Lua Files",directory=path}
	filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
	if filedlg.status=="1" then
		iup.Message("Neue Datei",filedlg.value)
	elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
		--load tree2 from file 
		textbox2.value=filedlg.value
		dofile(filedlg.value) --initialize the tree, read from the lua file
		for line in io.lines(filedlg.value) do
			if line:match('=')~= nil then 
				tablename=line:sub(1,line:find('=')-1):gsub(' ', '')
				break
			end --if line:match('=')~= nil then 
		end --for line in io.lines(path_documentation_tree) do
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here	
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..tablename)()	
		else
			load('actualtree='..tablename)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree2,actualtree)
	else
		iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg.status=="1" then
end --function button_loading_lua_table_2:flat_action()

--6.4 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()


--6.5 button for comparing text file of tree and text file of tree2
button_compare=iup.flatbutton{title="Baumstrukturen vergleichen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_compare:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='compare'
	--make the comparison
	--go through tree 2
	tree_script={branchname="compare",{branchname="Vergleich von " .. tostring(textbox1.value) .. " mit " .. tostring(textbox2.value)}}
	local file2existsTable={}
	local file2numberTable={}
	for i=0,tree2.totalchildcount0 do 
		local line=tree2['TITLE' .. i]
		file2numberTable[#file2numberTable+1]=line
		file2existsTable[line]=#file2numberTable
	end --for i=0,tree1.totalchildcount0 do 
	--go through tree 1
	local lineNumber=0
	local file1existsTable={}
	for i=0,tree1.totalchildcount0 do 
		local line=tree1['TITLE' .. i]
		file1existsTable[line]=true
		lineNumber=lineNumber+1
		if line==file2numberTable[lineNumber] then 
			if tree_script[#tree_script].branchname=="gleich" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="gleich"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			end --if tree_script[#tree_script].branchname=="gleich" then
		elseif file2existsTable[line] and lineNumber>file2existsTable[line] then 
			if tree_script[#tree_script].branchname=="gleich siehe oben" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="gleich siehe oben"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			end --if tree_script[#tree_script].branchname=="gleich siehe oben" then
		elseif file2existsTable[line] and lineNumber<file2existsTable[line] then 
			if tree_script[#tree_script].branchname=="gleich siehe unten" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="gleich siehe unten"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			end --if tree_script[#tree_script].branchname=="gleich siehe unten" then
		else
			tree_script[#tree_script+1]={branchname="unterschiedlich",{branchname=lineNumber .. ": " .. line,lineNumber .. ": " .. tostring(file2numberTable[lineNumber])}}
		end --if file2Table[line] then
	end --for i=0,tree1.totalchildcount0 do 
	--go through tree 1 to search for missing lines in tree 2
	local line1Number=0
	for i=0,tree1.totalchildcount0 do 
		local line=tree1['TITLE' .. i]
		line1Number=line1Number+1
		if file2existsTable[line]==nil then
			if tree_script[#tree_script].branchname=="nur in erster Datei" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line1Number .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="nur in erster Datei"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line1Number .. ": " .. line
			end --if tree_script[#tree_script].branchname=="nur in erster Datei" then
		end --if file2existsTable[line] then
	end --for i=0,tree1.totalchildcount0 do
	--go through tree 2 to search for missing lines in tree 1
	local line2Number=0
	for i=0,tree2.totalchildcount0 do 
		local line=tree2['TITLE' .. i]
		line2Number=line2Number+1
		if file1existsTable[line]==nil then
			if tree_script[#tree_script].branchname=="nur in zweiter Datei" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line2Number .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="nur in zweiter Datei"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line2Number .. ": " .. line
			end --if tree_script[#tree_script].branchname=="nur in zweiter Datei" then
		end --if file1existsTable[line] then
	end --for i=0,tree2.totalchildcount0 do
	--build the compare tree
	iup.TreeAddNodes(tree,tree_script)
end --function button_compare:flat_action()

--6.6 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog
--7.1 textboxes 
textbox1 = iup.multiline{value="",size="320x20",WORDWRAP="YES"}
textbox2 = iup.multiline{value="",size="320x20",WORDWRAP="YES"}

--7.2.1 display empty compare tree
actualtree={branchname="compare"}
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="400x320",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--set the background color of the tree
tree.BGCOLOR=color_background_tree
--7.2.2 display empty first tree
actualtree1={branchname="first tree"}
tree1=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree1)
end, --function(self)
SIZE="400x320",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--7.2.3 display empty second tree
actualtree2={branchname="second tree"}
tree2=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree2)
end, --function(self)
SIZE="400x320",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}

--7.3.1 text file field as scintilla editor 1
textfield1=iup.scintilla{}
textfield1.SIZE="280x530" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield1.wordwrap="WORD" --enable wordwarp
textfield1.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield1.FONT="Courier New, 8" --font of shown code
textfield1.LEXERLANGUAGE="lua" --set the programming language to lua for syntax higlighting
textfield1.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
textfield1.STYLEFGCOLOR0="0 0 0"      -- 0-Default
textfield1.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
textfield1.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
textfield1.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
textfield1.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
textfield1.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
textfield1.STYLEFGCOLOR6="160 20 180"  -- 6-String 
textfield1.STYLEFGCOLOR7="128 0 0"    -- 7-Character
textfield1.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
textfield1.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
textfield1.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--textfield1.STYLEBOLD10="YES"
--textfield1.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--textfield1.STYLEITALIC10="YES"
textfield1.MARGINWIDTH0="40"

--7.3.2 text file field as scintilla editor 2
textfield2=iup.scintilla{}
textfield2.SIZE="280x530" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield2.wordwrap="WORD" --enable wordwarp
textfield2.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield2.FONT="Courier New, 8" --font of shown code
textfield2.LEXERLANGUAGE="lua" --set the programming language to lua for syntax higlighting
textfield2.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
textfield2.STYLEFGCOLOR0="0 0 0"      -- 0-Default
textfield2.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
textfield2.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
textfield2.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
textfield2.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
textfield2.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
textfield2.STYLEFGCOLOR6="160 20 180"  -- 6-String 
textfield2.STYLEFGCOLOR7="128 0 0"    -- 7-Character
textfield2.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
textfield2.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
textfield2.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--textfield2.STYLEBOLD10="YES"
--textfield2.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--textfield2.STYLEITALIC10="YES"
textfield2.MARGINWIDTH0="40"


--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_loading_lua_table_1,
			button_loading_lua_table_2,
			button_compare,
			button_expand_collapse_dialog,
			iup.label{size="5x",},
			iup.fill{},
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Erste Textdatei",iup.vbox{textbox1,tree1,},},
			iup.frame{title="Zweite Textdatei",iup.vbox{textbox2,tree2,},},
			iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}


--7.5 show the dialog
maindlg:show()

--7.5.2 go to the main dialog
iup.NextField(maindlg)

--7.6 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then
