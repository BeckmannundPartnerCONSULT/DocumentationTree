--This script converts a powerpoint file in a pdf file by using luacom

--1. library
require("luacom")

--2.1 read powerpoint file names of the directory in a Lua table
powerpointFileTable={}
p=io.popen('dir C:\\Temp\\*pptx /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		powerpointFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read names of powerpoint file exports as pdf in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*pptx2.pdf /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do
--test with: for k,v in pairs(powerpointFileTable) do print(secureFileTable[k:gsub(".pptx","_pptx2") .. ".pdf"], v) end

--3. export powerpoint files to pdf if there is no export or if the date of the export to pdf is older than the date of the powerpoint file
p=io.popen('dir C:\\Temp\\*.pptx /b/o/s')
for powerpointFile in p:lines() do 
ActiveDocumentText=powerpointFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".pptx","_pptx2") .. ".pdf"]==nil or
powerpointFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".pptx","_pptx2") .. ".pdf"] then
print("Sichern von " .. ActiveDocumentText)
powerpoint=luacom.CreateObject("Powerpoint.Application")
powerpoint.Presentations:Open(powerpointFile)
powerpoint.ActivePresentation:SaveAs("C:\\Temp\\Archiv\\" .. ActiveDocumentText:gsub(".pptx","_pptx2") .. ".pdf",32)
powerpoint:Quit()
end --if powerpointFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".pdf"] then
end --for powerpointFile in p:lines() do

