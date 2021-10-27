--This script converts a word file in a text file (TXT) by using luacom

--1. library
require("luacom")

--2.1 read word file names of the directory in a Lua table
wordFileTable={}
p=io.popen('dir C:\\Temp\\*docx /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		wordFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read text file names of the securisations in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*docx2.txt /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if file:match("docx2.txt") then
end --for file in p:lines() do
--test with: for k,v in pairs(wordFileTable) do print(secureFileTable[k .. ".txt"], v) end

--3. export word files to text if there is no export or if the date of the export to text is older than the date of the word file
--and make a copy of the previous version of the text file
p=io.popen('dir C:\\Temp\\*.docx /b/o/s')
for WordFile in p:lines() do 
ActiveDocumentText=WordFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".docx","_docx2") .. ".txt"]==nil or
wordFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".docx","_docx2") .. ".txt"] then
print("securisation of " .. ActiveDocumentText)
os.execute('copy "C:\\Temp\\Archiv\\' .. ActiveDocumentText:gsub(".docx","_docx2") .. '.txt" "C:\\Temp\\Archiv\\' .. ActiveDocumentText:gsub(".docx","_docx1") .. '.txt"')
word=luacom.CreateObject("Word.Application")
word.Documents:Open(WordFile)
word.ActiveDocument:SaveAs2("C:\\Temp\\Archiv\\" .. ActiveDocumentText:gsub(".docx","_docx2") .. ".txt",2)
word:Quit()
end --if wordFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".txt"] then
end --for WordFile in p:lines() do
