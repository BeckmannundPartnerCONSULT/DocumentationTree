--This script runs a graphical user interface (GUI) in order to built up a documentation tree of SQL statements or of excel formulas.


--1. basic data

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

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


--2. path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--3. no functions

--4. no dialogs

--5. no context menus

--6 buttons
--6.1 logo image definition and button with logo
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

--6.2 button for building tree with SQL
button_show_sql_as_tree=iup.flatbutton{title="Das SQL als Baum zeigen", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_sql_as_tree:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='brackets tree'
	--example text variable
	text=textfield1.value
	--treat multiple SQL statements with semicolon at the end
	text=text:gsub(";",";)(")
		:gsub(" +$","")
		:gsub(" +\n","\n")
		:gsub("\n+","")
		:gsub(";%)%($",";")
	--read opening and closing brackets and count them and add missing ones
	numberBracketOpen=0
	for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
		numberBracketOpen= numberBracketOpen+1
	end --for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
	numberBracketClose=0
	for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
		numberBracketClose = numberBracketClose +1
	end --for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
	if numberBracketOpen>numberBracketClose then
		text=text .. string.rep("~missing~)",numberBracketOpen-numberBracketClose)
	elseif numberBracketOpen<numberBracketClose then
		text=string.rep("(~missing~",numberBracketClose-numberBracketOpen) .. text
	end --if numberBracketOpen>numberBracketClose then
	--build the outputstring for the tree
	outputText=("tree_sql_script={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[(')
											:gsub("%)",')]====],\n},\n[====[') .. "]====],}")
											:gsub("%[====%[%]====%],","")
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	if _VERSION=='Lua 5.1' then
		loadstring(outputText)()
	else
		load(outputText)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then

	iup.TreeAddNodes(tree,tree_sql_script)
end --function button_show_sql_as_tree:flat_action()

--6.3 button for building tree with Excel formula
button_show_excel_formula_as_tree=iup.flatbutton{title="Die Excel-Formel als Baum zeigen", size="145x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_excel_formula_as_tree:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='brackets tree'
	--example text variable
	text=textfield1.value
	text=text:gsub("(%u+)%(","(%1~~~") --exchange function words in upper cases and brackets
	--read opening and closing brackets and count them and add missing ones
	numberBracketOpen=0
	for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
		numberBracketOpen= numberBracketOpen+1
	end --for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
	numberBracketClose=0
	for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
		numberBracketClose = numberBracketClose +1
	end --for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
	if numberBracketOpen>numberBracketClose then
		text=text .. string.rep("~missing~)",numberBracketOpen-numberBracketClose)
	elseif numberBracketOpen<numberBracketClose then
		text=string.rep("(~missing~",numberBracketClose-numberBracketOpen) .. text
	end --if numberBracketOpen>numberBracketClose then
	--build the outputstring for the tree
	outputText=("tree_sql_script={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[(')
											:gsub("%)",')]====],\n},\n[====[') .. "]====],}")
											:gsub(";",";]====],[====[") --for Excel formulas
											:gsub("%[====%[%]====%],","")
											:gsub("%((%u+)~~~","%1(")
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	if _VERSION=='Lua 5.1' then
		loadstring(outputText)()
	else
		load(outputText)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then

	iup.TreeAddNodes(tree,tree_sql_script)
end --function button_show_excel_formula_as_tree:flat_action()

--6.4 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--7. Main Dialog

--7.1 preview field as scintilla editor
textfield1=iup.scintilla{}
textfield1.SIZE="440x560" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield1.wordwrap="WORD" --enable wordwarp
textfield1.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield1.FONT="Courier New, 8" --font of shown code
textfield1.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
textfield1.KEYWORDS0="SELECT select FROM from ORDER BY order by SORT sort INSERT INTO insert into DELETE delete WENN SUMMEWENN ISTFEHLER" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
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
--example for a SQL statement
textfield1.value="SELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE)); \n\nSELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE));"
--example for an excel formula
textfield1.value='=WENN(1=1;WENN(2<2;"nie";"immer");WENN(3>2;"immer";"nie"))'

--7.2 display empty SQL tree
actualtree={branchname="SQL"}
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


--7.3 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_show_sql_as_tree,
			button_show_excel_formula_as_tree,
			iup.fill{},
			button_logo2,
		},
		iup.hbox{
			iup.frame{title="SQL-Statements",textfield1,},
			iup.frame{title="SQL als Baum",tree,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}

--7.3.1 show the dialog
maindlg:show()

--7.4 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then

