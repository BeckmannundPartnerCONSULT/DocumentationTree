

--delete the zip file
os.execute('del C:\\Tree\\IDIV_package.zip')


--build the product package for the interactive dynamic table of contents products

packageTable={}

--reflexive scripts are special
packageTable["C:\\Tree\\reflexiveDocTree\\reflexive_documentation_tree_search.lua"]="C:\\Tree\\IDIV_package\\IDIV_Suchergebnisse_Internet"
packageTable["C:\\Tree\\reflexiveDocTree\\reflexive_documentation_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Basiskomponente"
packageTable["C:\\Tree\\reflexiveDocTree\\reflexive_documentation_tree_with_directory.lua"]="C:\\Tree\\IDIV_package\\IDIV_Ordnergliederung"
packageTable["C:\\Tree\\reflexiveDocTree\\reflexive_documentation_tree_with_webbrowser.lua"]="C:\\Tree\\IDIV_package\\IDIV_Browser"
packageTable["C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Praesentation"

--non reflexive scripts can be easily updated, but they need aditional files
packageTable["C:\\Tree\\GUI_Dokumentation_Verzeichnis\\nachschlagen_documentation_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Arbeitsplatz"
packageTable["C:\\Tree\\GUI_Dokumentation_Verzeichnis\\ansicht_documentation_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Bibliothek"
packageTable["C:\\Tree\\Tree_compare\\compare_documentation_tree_lua_trees.lua"]="C:\\Tree\\IDIV_package\\IDIV_Baumansichtvergleich"
packageTable["C:\\Tree\\Tree_compare\\compare_documentation_tree_text_files.lua"]="C:\\Tree\\IDIV_package\\IDIV_Textdateivergleich"
packageTable["C:\\Tree\\Tree_News\\Tree_news_categorisation.lua"]="C:\\Tree\\IDIV_package\\IDIV_Nachrichtenverarbeitung"
packageTable["C:\\Tree\\simpleDocTree\\simple_documentation_tree_webpage_search.lua"]="C:\\Tree\\IDIV_package\\IDIV_Suchergebnisse_Webpage"
packageTable["C:\\Tree\\simpleDocTree\\simple_documentation_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Basiskomponente"
packageTable["C:\\Tree\\simpleDocTree\\simple_documentation_tree_with_file_dialog.lua"]="C:\\Tree\\IDIV_package\\IDIV_Basiskomponente"
packageTable["C:\\Tree\\simpleDocTree\\simple_documentation_tree_with_webbrowser.lua"]="C:\\Tree\\IDIV_package\\IDIV_Basiskomponente"
packageTable["C:\\Tree\\LuatoLua\\Tree_console.lua"]="C:\\Tree\\IDIV_package\\IDIV_Skripter"
packageTable["C:\\Tree\\LuatoLua\\ansicht_documentation_tree_balance.lua"]="C:\\Tree\\IDIV_package\\IDIV_Bilanzanalysewerkzeug"
packageTable["C:\\Tree\\LuatoLua\\Tree_calculator_with_interests.lua"]="C:\\Tree\\IDIV_package\\IDIV_Zinskalkulationsschema"
packageTable["C:\\Tree\\LuatoLua\\input_command_output_tree_MDI_graphics.lua"]="C:\\Tree\\IDIV_package\\IDIV_Analysewerkzeug_mit_Darstellung"
packageTable["C:\\Tree\\LuatoLua\\reflexive_Tree_calculator_with_interests.lua"]="C:\\Tree\\IDIV_package\\IDIV_Entwicklungsumgebung_fuer_Kalkulationsschemata"
packageTable["C:\\Tree\\LuatoLua\\input_command_output_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Analysewerkzeug"
packageTable["C:\\Zinsrechner\\Tree_calculator_with_interests.html"]="C:\\Tree\\IDIV_package\\IDIV_Zinsrechner"



--1. function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--2. collect data for the tree
productTable={}
for line in io.lines("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_Produktpalette.lua") do
	line=string.escape_forbidden_char(line)
	if line:match("<.*<!--") then
		if line:match("%(.*%)") then UnterGruppe="_" .. line:match("%([^%)]*%)") else UnterGruppe="" end
		line=line:gsub("&nbsp;","")
			:gsub("<tr><td>","<ul><li>IDIV-Hilfsprogramm ")
			:gsub(" ?</td><td>&#8594; </td><td> ?"," zu ")
			:gsub("</td></tr>"," zu Lua </li></ul>")
			:gsub("<ul><li>",'{branchname="')
			:gsub("</li></ul>",'",')
			:gsub("<!%-%-",'"')
			:gsub("%-%->",'"},')
			:gsub("%([^%)]*%)",'')
		--test with: print(line:gsub("&nbsp;",""))
		productTable[tostring(line:match('"([^"]*)"}')):gsub(" ",""):gsub("\\\\","\\")]=tostring(line:match('{branchname="([^"]*)"')):gsub(" +"," "):gsub(" $","") 
	end --if line:match("<!--") then
end --for line in io.lines("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree.lua") do


anzahlDateien=0
for k,v in pairs(packageTable) do
os.execute('md ' .. v )
os.execute('copy ' .. k .. '  ' .. v )
os.execute('"C:\\Program Files\\7-Zip\\7z.exe" a C:\\Tree\\IDIV_package.zip ' .. v .. ' -r ')
anzahlDateien=anzahlDateien+1
end --for k,v in pairs(packageTable) do


for k,v in pairs(productTable) do
	if packageTable[k]==nil and v:match("Prototyp")==nil then
		print(k,v)
	end --if packageTable[k]==nil then

end --for k,v in pairs(productTable) do

print("Anzahl Dateien im IDIV-Package: " .. anzahlDateien)
os.execute('pause')