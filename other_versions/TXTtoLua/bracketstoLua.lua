--This script converts a text with brackets, for instance with SQL-statements, into a Lua tree with

--example text variable
text="SELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE)s)d(a)(w(s(b)a)d)d(w(c)q(a(c(dd)r)f(ee)e)s);"

--1. read opening and closing brackets and count them and add missing ones
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

--2. show all parts of brackets
pos=1
while true do 
	findText,pos=("(" .. text .. ")"):find("%(",pos) 
	if pos then 
		pos=pos+1 
		print(("(" .. text .. ")"):sub(pos-1):match("%b()")) 
	else 
		break 
	end --if pos then
end --while true do 

--3. build the outputstring for the tree
outputfile1=io.open("C:\\Temp\\bracketsTree.lua","w") 
outputText=("Tree={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[('):gsub("%)",')]====],\n},\n[====[') .. "]====],}"):gsub("%[====%[%]====%],","")
outputfile1:write(outputText)
outputfile1:close()

