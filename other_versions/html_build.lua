
dofile("/mnt/sdcard/Tree/Tree_Baum.lua")
--test with: print(Tree[1][1][2])
outputfile1=io.open("/mnt/sdcard/Tree/Tree_Baum.html","w")
outputfile1:write('<font size="5"> ')
function readTreetohtmlRecursive(TreeTable)
AusgabeTabelle[TreeTable.branchname]=true
outputfile1:write("<ul><li>" ..
tostring(TreeTable.branchname)
:gsub("ä","&auml;")
:gsub("Ä","&Auml;")
:gsub("ö","&ouml;")
:gsub("Ö","&Ouml;")
:gsub("ü","&uuml;")
:gsub("Ü","&Uuml;")
:gsub("ß","&szlig;")
.. "\n")
for k,v in ipairs(TreeTable) do
if type(v)=="table" then
readTreetohtmlRecursive(v)
else
AusgabeTabelle[v]=true
outputfile1:write("<ul><li>" .. v
:gsub("ä","&auml;")
:gsub("Ä","&Auml;")
:gsub("ö","&ouml;")
:gsub("Ö","&Ouml;")
:gsub("ü","&uuml;")
:gsub("Ü","&Uuml;")
:gsub("ß","&szlig;")
.. "</li></ul>" .. "\n")
end --if type(v)=="table" then
end --for k, v in ipairs(TreeTable) do
outputfile1:write("</li></ul>" .. "\n")
end --readTreetohtmlRecursive(TreeTable)
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)
outputfile1:write("</font>")


outputfile1:close()
    