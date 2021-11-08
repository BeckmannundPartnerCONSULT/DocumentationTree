lua_tree_output={ branchname="example of a reflexive tree", 
{ branchname="Node 1", 
{ branchname="Neuer Ast", 
{ branchname="1", 
state="COLLAPSED",
},
},
{ branchname="Node 2", 
{ branchname="Test", 
 "Neuer Ast", "2", 
 "3", 
},
 "Leaf",}}}--lua_tree_output



TextHTMLtable={
[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Documentation Tree </h1>

<ul><li>Inhaltsverzeichnis

<ul><li>IUP-Lua-Installation

</li></ul>

<ul><li>Herunterladen der Oberfläche
<ul><li>ansicht_documentation_tree.lua</li></ul>
<ul><li>simple_webbrowser.lua</li></ul>
</li></ul>

<ul><li>Verwendungen im Büroalltag
</li></ul>

</li></ul>



</body></html> ]====],
[====[<!DOCTYPE html> <head></head><html> <body leftmargin="150">
<br><h1><font size="32">Präsentation </font></h1>

<font size="25">

<ul><li>Einleitung</li></ul>

<ul><li>Kompatibilität mit Office-Produkten
<ul><li>Word</li></ul>
<ul><li>Excel</li></ul>
<ul><li>Powerpoint</li></ul>
</li></ul>

<ul><li>Ausblick</li></ul>

</font>

</body></html> ]====],
[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====],
["Node 2"]=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====],
["Test"]=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Test Seite </h1>

</body></html> ]====],
["Neuer Ast"]=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

Diese wird jetzt verändert.

</body></html> ]====],
}--TextHTMLtable<!--



----[====[This programm has webpages within the Lua script which can contain a tree in html

--1. basic data

--1.1.1 libraries
require( "iuplua" )
require( "iupluaweb" )
--iup.SetGlobal("UTF8MODE","NO")

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


--1.3 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--2. global data definition
aktuelleSeite=1


--3. functions
--3.1 simplified version of table.move for Lua 5.1 and Lua 5.2 that is enough for using of table.move here
if _VERSION=='Lua 5.1' or _VERSION=='Lua 5.2' then
	function table.move(a,f,e,t)
	for i=f,e do
		local j=i-f
		a[t+j]=a[i]
	end --for i=f,e do
	return a 
	end --function table.move(a,f,e,t)
end --if _VERSION=='Lua 5.1' then

--3.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.3 function which saves the current iup htmlTexts as a lua table.
function save_html_to_lua(htmlTexts, outputfile_path)
	--read the programm of the file itself, commentSymbol is used to have another pattern here as searched
	inputfile=io.open(path .. "\\" .. thisfilename,"r")
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("lua_tree_output={.*}%-%-lua_tree_output.*TextHTMLtable={.*}(%-%-)TextHTMLtable<!%-%-(.*)")
	inputfile:close()
	--build the new htmlTexts
	local output_htmlTexts_text="TextHTMLtable={" --the output string
	local outputfile=io.output(outputfile_path) --a output file
	--save the tree
	local output_tree_text="lua_tree_output=" --the output string
	local outputfile=io.output(outputfile_path) --a output file
	for i=0,tree.count - 1 do --loop for all nodes
		if tree["KIND" .. i ]=="BRANCH" then --consider cases, if actual node is a branch
			if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then --consider cases if depth increases
				output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' -- we open a new branch
				--save state
				if tree["STATE" .. i ]=="COLLAPSED" then
					output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
				end --if tree["STATE" .. i ]=="COLLAPSED" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then --if depth decreases
				if tree["KIND" .. i-1 ] == "BRANCH" then --depending if the predecessor node was a branch we need to close one bracket more
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do -- or if the predecessor node was a leaf
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then --or if depth stays the same
				if tree["KIND" .. i-1 ] == "BRANCH" then --again consider if the predecessor node was a branch
					output_tree_text = output_tree_text .. '},\n{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else --or a leaf
					output_tree_text = output_tree_text .. '\n{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			end --if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then
		elseif tree["KIND" .. i ]=="LEAF" then --or if actual node is a leaf
			if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
				output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --we add the leaf
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then --in the same manner as above, depending if the predecessor node was a leaf or branch, we have to close a different number of brackets
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --and in each case we add the new leaf
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
				else
					output_tree_text = output_tree_text .. '},\n "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			end --if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
		end --if tree["KIND" .. i ]=="BRANCH" then
	end --for i=0,tree.count - 1 do
	for j=1, tonumber(tree["DEPTH" .. tree.count-1]) do
		output_tree_text = output_tree_text .. "}" --close as many brackets as needed
	end --for j=1, tonumber(tree["DEPTH" .. tree.count-1]) do
	if tree["KIND" .. tree.count-1]=="BRANCH" then
		output_tree_text = output_tree_text .. "}" -- we need to close one more bracket if last node was a branch
	end --if tree["KIND" .. tree.count-1]=="BRANCH" then
	--output_tree_text=string.escape_forbidden_char(output_tree_text)
	outputfile:write(output_tree_text .. "--lua_tree_output\n\n\n\n") --write everything into the outputfile
	--save the html pages
	for k,v in pairs(TextHTMLtable) do 
		if type(k)=="number" then
		output_htmlTexts_text=output_htmlTexts_text .. "\n[====[" .. v .. "]====],"
		else
		output_htmlTexts_text=output_htmlTexts_text .. '\n["' .. k .. '"]=[====[' .. v .. "]====],"
		end --if type(k)=="number" then
	end --for k,v in pairs(TextHTMLtable) do 

	output_htmlTexts_text=output_htmlTexts_text .. "\n}"
	outputfile:write(output_htmlTexts_text .. "--TextHTMLtable<!--") --write everything into the outputfile
	--write the programm for the data in itself
	outputfile:write(inputTextProgramm)
	outputfile:close()
end --function save_html_to_lua(htmlTexts, outputfile_path)


--4. dialogs
--4.1 rename dialog
--ok button
ok = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok:flat_action()
	tree.title = text.value
	return iup.CLOSE
end --function ok:flat_action()

--cancel button
cancel = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel:flat_action()
	return iup.CLOSE
end --function cancel:flat_action()

text = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1 = iup.label{title="Name:"}--label for textfield

--open the dialog for renaming branch/leaf
dlg_rename = iup.dialog{
	iup.vbox{label1, text, iup.hbox{ok,cancel}}; 
	title="Knoten bearbeiten",
	size="QUARTER",
	startfocus=text,
	}

--4.1 rename dialog end

--4.2 change page dialog
--ok_change_page button
ok_change_page = iup.flatbutton{title = "Seite verändern",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok_change_page:flat_action()
	webbrowser1.HTML= text1.value
	if tonumber(textbox1.value) then
		TextHTMLtable[aktuelleSeite]= text1.value
	else
		TextHTMLtable[textbox1.value]= text1.value
	end --if tonumber(textbox1.value) then
	return iup.CLOSE
end --function ok_change_page:flat_action()

--cancel_change_page button
cancel_change_page = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel_change_page:flat_action()
	return iup.CLOSE
end --function cancel_change_page:flat_action()

--search searchtext.value in textfield1
search_in_text = iup.flatbutton{title = "Suche in der Seite",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition=1
function search_in_text:flat_action()
	from,to=text1.value:find(textbox2.value,searchPosition)
	searchPosition=to
	if from==nil then 
		searchPosition=1 
		iup.Message("Suchtext in der Seite nicht gefunden","Suchtext in der Seite nicht gefunden")
	else
		text1.SELECTIONPOS=from-1 .. ":" .. to
	end --if from==nil then 
end --	function search_in_text:flat_action()

text1 = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1 = iup.label{title="Blattinhalt:"}--label for textfield

--open the dialog for renaming page
dlg_change_page = iup.dialog{
	iup.vbox{label1, text1, iup.hbox{ok_change_page,search_in_text,cancel_change_page}}; 
	title="Seite bearbeiten",
	size="400x350",
	startfocus=text1,
	}

--4.2 change page dialog end

--5. context menus (menus for right mouse click)

--5.1 menu of tree
--5.1.1 copy node of tree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = tree['title']
end --function startcopy:action()

--5.1.2 rename node and rename action for other needs of tree
renamenode = iup.item {title = "Knoten bearbeiten"}
function renamenode:action()
	text.value = tree['title']
	dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(tree)
end --function renamenode:action()

--5.1.3 add branch to tree
addbranch = iup.item {title = "Ast hinzufügen"}
function addbranch:action()
	tree.addbranch = ""
	tree.value=tree.value+1
	renamenode:action()
end --function addbranch:action()

--5.1.4 add branch of tree from clipboard
addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function addbranch_fromclipboard:action()
	tree.addbranch = clipboard.text
	tree.value=tree.value+1
end --function addbranch_fromclipboard:action()

--5.1.5 add leaf of tree
addleaf = iup.item {title = "Blatt hinzufügen"}
function addleaf:action()
	tree.addleaf = ""
	tree.value=tree.value+1
	renamenode:action()
end --function addleaf:action()

--5.1.6 add leaf of tree from clipboard
addleaf_fromclipboard = iup.item {title = "Blatt aus Zwischenablage"}
function addleaf_fromclipboard:action()
	tree.addleaf = clipboard.text
	tree.value=tree.value+1
end --function addleaf_fromclipboard:action()

--5.1.7 copy a version of the file selected in the tree and give it the next version number
startversion = iup.item {title = "Version Archivieren"}
function startversion:action()
	--get the version of the file
	if tree['title']:match(".:\\.*%.[^\\]+") then
		Version=0
		p=io.popen('dir "' .. tree['title']:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren der Version:",tree['title']:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('copy "' .. tree['title'] .. '" "' .. tree['title']:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if tree['title']:match(".:\\.*%.[^\\]+") then
end --function startversion:action()

--5.1.7 button for building new page
menu_new_page = iup.item {title = "Neue Seite"}
function menu_new_page:action()
local newText=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>]====] .. tree['title'] .. [====[</h1>

</body></html> ]====]
	if TextHTMLtable[tree['title']]==nil then
		webbrowser1.HTML=newText
		TextHTMLtable[tree['title']]= newText
	end --if TextHTMLtable[tree['title']]==nil then
	if tonumber(tree['title']) then 
		actualPage=math.tointeger(tonumber(tree['title'])) 
		webbrowser1.HTML=TextHTMLtable[actualPage]
		textbox1.value=tree['title']
		actualPage=tonumber(tree['title'])
	else
		webbrowser1.HTML=TextHTMLtable[tree['title']]
		textbox1.value=tree['title']
	end --if tonumber(tree['title']) then 
end --function menu_new_page:action()


--5.1.8 button for go to webbrowser page
menu_goto_page=iup.item {title="Gehe zu Seite vom Knoten", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function menu_goto_page:action()
	if tonumber(tree['title']) then 
		actualPage=math.tointeger(tonumber(tree['title'])) 
		webbrowser1.HTML=TextHTMLtable[actualPage]
		textbox1.value=tree['title']
		actualPage=tonumber(tree['title'])
	else
		--test with: iup.Message("Text",tostring(TextHTMLtable[textbox1.value]))
		if TextHTMLtable[tree['title']] then
			webbrowser1.HTML=TextHTMLtable[tree['title']]
			textbox1.value=tree['title']
		else
			textbox1.value=tree['title'] .. " hat keine Webpage"
			webbrowser1.HTML=tree['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree['title']] then
	end --if tonumber(tree['title']) then 
end --function menu_goto_page:flat_action()

--5.1.9 start the file or repository of the node of tree 
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then os.execute('start "D" "' .. tree['title'] .. '"') end
end --function startnode:action()

--5.1.10 start the url in webbrowser
startnode_url = iup.item {title = "Starten URL"}
function startnode_url:action() 
	if tree['title']:match("http") then
		webbrowser1.value=tree['title'] --for instance: "https://www.lua.org"
	end --if tree['title']:match("http") then
end --function startnode_url:action()

--5.1.11 put the buttons together in the menu for tree
menu = iup.menu{
		startcopy,
		renamenode, 
		addbranch, 
		addbranch_fromclipboard, 
		addleaf,
		addleaf_fromclipboard,
		startversion,
		menu_new_page, 
		menu_goto_page, 
		startnode_url, 
		startnode, 
		}
--5.1 menu of tree end


--5. context menus (menus for right mouse click) end

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

--6.2 button for saving TextHTMLtable
button_save_lua_table=iup.flatbutton{title="Datei speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_html_to_lua(TextHTMLtable, path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()

--6.3 button for going to first page
button_go_to_first_page = iup.flatbutton{title = "Startseite",size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_first_page:flat_action()
	webbrowser1.HTML=TextHTMLtable[1]
	aktuelleSeite=1
	textbox1.value=aktuelleSeite
end --function button_go_to_first_page:action()

--6.4 button for going one page back
button_go_back = iup.flatbutton{title = "Eine Seite zurück",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_back:flat_action()
	if aktuelleSeite>1 then aktuelleSeite=aktuelleSeite-1 end
	webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
	textbox1.value=aktuelleSeite
end --function button_go_back:action()

--6.5 button for going to the page and edit the page
button_edit_page = iup.flatbutton{title = "Editieren der Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		TextErsatz=TextHTMLtable[textbox1.value]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
	text1.value=TextErsatz
	dlg_change_page:popup(iup.CENTER, iup.CENTER) --popup rename dialog
end --function button_edit_page:action()

--6.6 button for going to the page
button_go_to_page = iup.flatbutton{title = "Gehe zu Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
end --function button_go_to_page:action()

--6.7 button for deleting the page
button_delete = iup.flatbutton{title = "Löschen der Seite",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete:flat_action()
	LoeschAlarm=iup.Alarm("Soll die Seite " .. tonumber(textbox1.value) .. " wirklich gelöscht werden?","Soll die Seite " .. tonumber(textbox1.value) .. " wirklich gelöscht werden?","Löschen","Nicht Löschen")
	if LoeschAlarm==1 then 
		if tonumber(textbox1.value) and tonumber(textbox1.value)<=#TextHTMLtable then
			aktuelleSeite=math.tointeger(tonumber(textbox1.value))
			table.move(TextHTMLtable,aktuelleSeite+1,#TextHTMLtable,aktuelleSeite)--move following elements to begin with index from aktuelleSeite
			TextHTMLtable[#TextHTMLtable]=nil --delete last element
			--test with: iup.Message(aktuelleSeite, tostring(math.floor(aktuelleSeite/2)*2==aktuelleSeite))
			webbrowser1.HTML="Seite gelöscht"
		else
			iup.Message("Keine Seite zum Löschen","Keine Seite zum Löschen")
		end --if tonumber(textbox1.value) and tonumber(textbox1.value)<=#TextHTMLtable then
	end --if LoeschAlarm==1 then 
end --function button_delete:flat_action()

--6.8 button for saving TextHTMLtable
button_save_as_html=iup.flatbutton{title="Als html speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_as_html:flat_action()
	local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua$",".html"),"w")
	for k,v in pairs(TextHTMLtable) do
		outputfile1:write(v .. "\n")
	end --for k,v in pairs(TextHTMLtable) do
	outputfile1:close()
end --function button_save_as_html:flat_action()

--6.9 button for search in TextHTMLtable
button_search=iup.flatbutton{title="Suche in Seiten", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	aktuelleSeite=math.tointeger(tonumber(textbox1.value))
	if aktuelleSeite<=#TextHTMLtable then
		for i=aktuelleSeite+1,#TextHTMLtable do
			if TextHTMLtable[i]:gsub("<[^>]+>",""):lower():match(textbox2.value:lower()) then
				textbox1.value=i
				aktuelleSeite=math.tointeger(tonumber(textbox1.value))
				webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
				break 
			end --if TextHTMLtable[i]:gsub("<[^>]+>",""):lower():match(textbox2.value:lower()) then
		end --for i=aktuelleSeite,#TextHTMLtable do
	end --if aktuelleSeite<=#TextHTMLtable then
end --function button_search:flat_action()


--6.10 button for going to the next page
button_go_forward = iup.flatbutton{title = "Eine Seite vor",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_forward:flat_action()
	if aktuelleSeite<#TextHTMLtable then aktuelleSeite=aktuelleSeite+1 end
	webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
	textbox1.value=aktuelleSeite
end --function button_go_forward:action()

--6.11 button for building new page
button_new_page = iup.flatbutton{title = "Neue Seite",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_page:flat_action()
	aktuelleSeite=#TextHTMLtable+1
	textbox1.value=aktuelleSeite
local newText=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====]
	webbrowser1.HTML=newText
	TextHTMLtable[aktuelleSeite]= newText
end --function button_new_page:action()

--6.12 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes 
textbox1 = iup.text{value="1",size="20x20",WORDWRAP="NO",alignment="ACENTER"}
textbox2 = iup.multiline{value="",size="90x20",WORDWRAP="YES"}

--7.2 webbrowser
webbrowser1=iup.webbrowser{HTML=TextHTMLtable[1],MAXSIZE="750x750"}

--7.3 load tree from self file
actualtree=lua_tree_output
--builde tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="400x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--set colors of tree
tree.BGCOLOR=color_background_tree --set the background color of the tree
-- Callback of the right mouse button click
function tree:rightclick_cb(id)
	tree.value = id
	menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)
-- Callback called when a node will be doubleclicked
function tree:executeleaf_cb(id)
	if tree['title' .. id]:match("^.:\\.*%.[^\\ ]+$") or tree['title' .. id]:match("^.:\\.*[^\\]+$") or tree['title' .. id]:match("^.:\\$") or tree['title' .. id]:match("^[^ ]*//[^ ]+$") then os.execute('start "d" "' .. tree['title' .. id] .. '"') end
end --function tree:executeleaf_cb(id)
-- Callback for pressed keys
function tree:k_any(c)
	if c == iup.K_DEL then
		-- do a totalchildcount of marked node. Then pop the table entries, which correspond to them.
		for j=0,tree.totalchildcount do
			--table.remove(attributes, tree.value+1)
		end --for j=0,tree.totalchildcount do
		tree.delnode = "MARKED"
	elseif c == iup.K_cP then -- added output of current table to a text file
		printtree()
	elseif c == iup.K_cF then
		searchtext.value=tree.title
		searchtext.SELECTION="ALL"
		dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cH then
		searchtext_replace.value=tree.title
		replacetext_replace.SELECTION="ALL"
		dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)


--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog {
	iup.vbox{
		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_go_to_first_page,
			button_go_back,
			button_edit_page,
			button_go_to_page,
			textbox1,
			button_delete,
			iup.fill{},
			button_save_as_html,
			button_search,
			textbox2,
			button_go_forward,
			button_new_page,
			button_logo2,
		}, --iup.hbox{
		iup.hbox{iup.frame{title="Manuelle Zuordnung als Baum",tree,},webbrowser1,},
	}, --iup.vbox{
	icon = img_logo,
	title = path .. " Documentation Tree",
	size="FULLxFULL" ;
	gap="3",
	alignment="ARIGHT",
	margin="5x5" 
}--maindlg = iup.dialog {

--7.5 show the dialog
maindlg:showxy(iup.CENTER,iup.CENTER) 

--7.6 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end

--]====]
