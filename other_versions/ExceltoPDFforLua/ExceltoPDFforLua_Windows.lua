--This script converts an excel file in a pdf file by using luacom

--1. library
require("luacom")

--2.1 read excel file names of the directory in a Lua table
excelFileTable={}
p=io.popen('dir C:\\Temp\\*xlsx /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		excelFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read names of excel file exports as pdf in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*xlsx2.pdf /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do
--test with: for k,v in pairs(excelFileTable) do print(secureFileTable[k:gsub(".xlsx","_xlsx2") .. ".pdf"], v) end

--3. export excel files to pdf if there is no export or if the date of the export to pdf is older than the date of the excel file
p=io.popen('dir C:\\Temp\\*.xlsx /b/o/s')
for ExcelFile in p:lines() do
ActiveDocumentText=ExcelFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".xlsx","_xlsx2") .. ".pdf"]==nil or
excelFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".xlsx","_xlsx2") .. ".pdf"] then
print("Sichern von " .. ActiveDocumentText)
excel=luacom.CreateObject("Excel.Application")
excel.Workbooks:Open(ExcelFile)
excel.ActiveWorkbook:ExportAsFixedFormat(0,"C:\\Temp\\Archiv\\" .. ActiveDocumentText:gsub(".xlsx","_xlsx2") .. ".pdf")
excel:Quit()
end --if excelFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".pdf"] then
end --for ExcelFile in p:lines() do
