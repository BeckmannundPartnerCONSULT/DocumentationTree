--This script converts a PDF file in a text file (TXT) by using luacom and Word

--1. library
require("luacom")

--2.1 read pdf file names of the directory in a Lua table
PDFFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*pdf* /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		PDFFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read text file names of the securisations in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*pdf2.txt /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do
--test with: for k,v in pairs(PDFFileTable) do print(secureFileTable[k:gsub(".pdf","_pdf2") .. ".txt"], v) end

--3. export pdf files to text if there is no export or if the date of the export to text is older than the date of the pdf file
--and make a copy of the previous version of the text file
p=io.popen('dir C:\\Temp\\Archiv\\*.pdf /b/o/s')
for PDFFile in p:lines() do 
ActiveDocumentText=PDFFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".pdf","_pdf2") .. ".txt"]==nil or
PDFFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".pdf","_pdf2") .. ".txt"] then
print("securisation of " .. ActiveDocumentText)
os.execute('copy "C:\\Temp\\Archiv\\' .. ActiveDocumentText:gsub(".pdf","_pdf2") .. '.txt" "C:\\Temp\\Archiv\\' .. ActiveDocumentText:gsub(".pdf","_pdf1") .. '.txt"')
word=luacom.CreateObject("Word.Application")
word.Documents:Open(PDFFile)
word.ActiveDocument:SaveAs2("C:\\Temp\\Archiv\\" .. ActiveDocumentText:gsub(".pdf","_pdf2") .. ".txt",2)
word:Quit()
end --if PDFFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".txt"] then
end --for PDFFile in p:lines() do


