
--build the product package for the interactive dynamic table of contents products

packageTable={}
--1. product
packageTable["C:\\Tree\\GUI_Dokumentation_Verzeichnis\\ansicht_documentation_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Bibliothek"

--2. product
packageTable["C:\\Tree\\reflexiveDocTree\\reflexive_documentation_tree_with_directory.lua"]="C:\\Tree\\IDIV_package\\IDIV_Ordnergliederung"

--3. product
packageTable["C:\\Tree\\GUI_Dokumentation_Verzeichnis\\nachschlagen_documentation_tree.lua"]="C:\\Tree\\IDIV_package\\IDIV_Arbeitsplatz"

--4. product
packageTable["C:\\Tree\\Tree_compare\\compare_documentation_tree_text_files.lua"]="C:\\Tree\\IDIV_package\\IDIV_Textdateivergleich"

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
os.execute('"C:\\Program Files\\7-Zip\\7z.exe" a C:\\Tree\\IDIV_package_starter_kit.zip ' .. v .. ' -r ')
anzahlDateien=anzahlDateien+1
end --for k,v in pairs(packageTable) do


for k,v in pairs(productTable) do
	if packageTable[k]==nil and v:match("Prototyp")==nil then
		print(k,v)
	end --if packageTable[k]==nil then

end --for k,v in pairs(productTable) do

print("Anzahl Dateien im IDIV-Package Starterkit: " .. anzahlDateien)
os.execute('pause')