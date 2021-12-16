--1. tree structure
--[[Tree={branchname="Testtree",
    "besser",
    "soso",
    {branchname="Ast","Blatt",},
    "testet",
}
--]]
--1. tree from file
dofile("Tree_Baum.lua")

--2. recursive function to read the tree
function readTreetohtmlRecursive(TreeTable)
    AusgabeTabelle[tostring(TreeTable.branchname:match('/mnt[^%.]+%.[^"]+'))]=true
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
            AusgabeTabelle[tostring(v:match('/mnt[^%.]+%.[^"]+'))]=true
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

--3. make html
print('Bitte die Datei Tree_output.lua in html kopieren')
outputfile1=io.open("Tree_output.lua","w")
outputfile1:write('<font size="5"> ')
readTreetohtmlRecursive(Tree)
outputfile1:write("</font>")
outputfile1:close()
--test with: for line in io.lines('Tree_output.lua') do print(line) end

--4. list files and repositories for Touch Lua
if sys then 
        print(sys.docspath())
        print("")
        for k,v in pairs(sys.dir()) do print(k,v) end
end --if sys then
