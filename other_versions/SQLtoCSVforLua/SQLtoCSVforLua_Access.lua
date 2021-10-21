--This script reads the query-SQL statements of an Access database and their name (queries are views in access) and build dependencies from query to table and table to query and from query to the parts of the SQL statements

--The script ist written for Access, but the part 3. and 4. can be used for the treatment of other databases with appropriate textfile with names of views and SQL statements

--1. input and outputfiles
accessDatabase="C:\\Tree\\SQLtoCSVforLua\\test.accdb"
outputFile="C:\\Tree\\SQLtoCSVforLua\\SQLtoCSVforLua_dependencies.csv"
print("Analyse Access Database " .. accessDatabase .. " with Luacom") 

--2. open library Luacom
require("luacom") 
--2.1 open Access
access=luacom.CreateObject("Access.Application") 
access.Visible=true 
--2.2 open Database
access:OpenCurrentDatabase(accessDatabase) 
--2.3 get SQL with Names of queries, i.e. views in Access
rs1=access:CurrentDB().QueryDefs 

--3. get standardised sections in SQL-statements by reserved words
--With ~ the reserved words can be analysed by the gmatch-command in Lua. 
--AS is an exception because it is part of a definition
SQLtable={} 
for i=0,rs1.Count-1 do 
	SQLtable[rs1(i).Name]=rs1(i).SQL
		:gsub("\r\n","")
		:gsub("\n","")
		:gsub("\r","")
		:gsub(";$","~;")
		:gsub('"',"'")
		:gsub("%(SELECT","~SUBLECT")
		:gsub("SELECT","~SELECT")
		:gsub("~SUBLECT","~SUB_SELECT")
		:gsub("INSERT INTO ([^%(]+)%(([^%)]+)%)","~INSERT_INTO %1~INSERT_FIELD(%2)")
		:gsub("INSERT INTO","~INSERT_INTO")
		:gsub(" INTO"," ~INTO")
		:gsub("UNION","~UNION")
		:gsub("UPDATE","~UPDATE")
		:gsub("DELETE","~DELETE")
		:gsub("SET","~SET")
		:gsub("FROM","~FROM")
		:gsub("INNER JOIN","~INNER JOIN")
		:gsub("RIGHT JOIN","~RIGHT JOIN")
		:gsub("LEFT JOIN","~LEFT JOIN")
		:gsub(" ON"," ~ON")
		:gsub("WHERE","~WHERE")
		:gsub("HAVING","~HAVING")
		:gsub("GROUP BY","~GROUP_BY")
		:gsub("ORDER BY","~ORDER_BY")
		:gsub("TRANSFORM","~TRANSFORM")
		:gsub("PIVOT","~PIVOT")
end --for i=0,rs1.Count-1 do

--4. build dependencies in a csv file
--the different Name-SQL relations must be written with child in first column and parent in second column
io.output(outputFile)
for k,v in pairs(SQLtable) do 
	for field in (v .. "~"):gmatch("([^~]+)~") do 
		if field:match("FROM")       then local outputText=tostring(k .. ";" .. field:gsub("FROM ","") .. ";"):gsub(" ;",";"):gsub(";$","")     io.write(outputText .. "\n") 
		elseif field:match("JOIN")   then local outputText=tostring(k .. ";" .. field:gsub(".*JOIN ","") .. ";"):gsub(" ;",";"):gsub(";$","")   io.write(outputText .. "\n") 
		elseif field:match("UPDATE") then local outputText=tostring(k .. ";" .. field:gsub(".*UPDATE ","") .. ";"):gsub(" ;",";"):gsub(";$","") io.write(outputText .. "\n") 
		elseif field:match("INTO")   then local outputText=tostring(field:gsub(".*INTO ","") .. ";" .. k .. ";"):gsub(" ;",";"):gsub(";$","")   io.write(outputText .. "\n") 
		elseif field~=";"            then local outputText=tostring(field .. ";" .. k .. ";"):gsub(" ;",";"):gsub(";$","")                      io.write(outputText .. "\n") 
		end --if field:match("FROM") then
	end --for field in (v .. "~"):gmatch("([^~]+)~") do 
end --for k,v in pairs(SQLtable) do 
io.close()

--5. shut all access processes to be able to reopen the database
access:Quit()
os.execute('taskkill /IM MSACCESS.EXE /F')
