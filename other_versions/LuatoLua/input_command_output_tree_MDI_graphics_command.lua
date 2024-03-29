lua_tree_command={ branchname="command", 
{ branchname="C:\\Tree\\LuatoLua\\input_command_output_tree_MDI_graphics_command.lua", 
state="COLLAPSED",
},
{ branchname="historische Ergebnisse", 
{ branchname="for i=15,#a do b[i]=b[i-1]+a[i] end", 
{ branchname="for i,v in ipairs(a) do print(os.date(\"%d.%m.%Y\",os.time{year=2021,month=11,day=8+i}) .. \": \" .. tostring(b[i]) .. \": \" .. v) end", 
{ branchname="schaetzAnfang=#a+1 --print(schaetzAnfang)", 
state="COLLAPSED",
},
},
},
},
{ branchname="Plot der täglichen Neuinfektionen", 
{ branchname="plot = iup.plot{TITLE = \"Tägliche Neuinfektionen\",MARGINLEFT = 50,MARGINRIGHT = 50,MARGINBOTTOM = 55,MARGINTOP = 85,AXS_XAUTOMIN = \"YES\",AXS_XAUTOMAX = \"YES\",AXS_YAUTOMIN = \"NO\", AXS_YAUTOMAX = \"YES\",--[[AXS_YMAX=1500,]]AXS_YMIN=0,}", 
{ branchname="plot:Begin(0) for i=0,schaetzAnfang-1 do plot:Add(i, tonumber(a[i])) end plot:End()  plot.DS_MODE=\"LINE\" ", 
{ branchname="MDI1Form = iup.dialog{TITLE = \'MDI1\', SIZE = \'250x210\', MDICHILD = \'YES\', PARENTDIALOG = console.dialog,iup.vbox{plot,},}", 
{ branchname="MDI1Form:show()", 
state="COLLAPSED",
},
},
},
},
},
{ branchname="Plot der kumulierten Infektionen", 
{ branchname="plot = iup.plot{TITLE = \"Kumulierte Infektionen\",MARGINLEFT = 50,MARGINRIGHT = 50,MARGINBOTTOM = 55,MARGINTOP = 85,AXS_XAUTOMIN = \"YES\",AXS_XAUTOMAX = \"YES\",AXS_YAUTOMIN = \"NO\", AXS_YAUTOMAX = \"YES\",--[[AXS_YMAX=1500,]]AXS_YMIN=0,}", 
{ branchname="plot:Begin(0) for i=14,schaetzAnfang-1 do plot:Add(i,tonumber(b[i])) end plot:End()  plot.DS_MODE=\"LINE\" ", 
{ branchname="MDI1Form = iup.dialog{TITLE = \'MDI1\', SIZE = \'250x210\', MDICHILD = \'YES\', PARENTDIALOG = console.dialog,iup.vbox{plot,},}", 
{ branchname="MDI1Form:show()", 
state="COLLAPSED",
},
},
},
},
},
{ branchname="Matrix herstellen", 
{ branchname="matrix1 = iup.matrixex {numcol=4, numlin=100, numcol_visible=4, numlin_visible=24, expand = \"HORIZONTAL\", resizematrix = \"YES\", markmode = \"CELL\", markmultiple=\"YES\",EDITFITVALUE=\"YES\",MULTILINE=\"YES\",}", 
{ branchname="iup.MatrixSetDynamic(matrix1) matrix1.NOSCROLLASTITLE=\"YES\" matrix1.NUMLIN_NOSCROLL=\"1\" matrix1.NUMCOL_NOSCROLL=\"1\"", 
{ branchname="matrix1.WIDTH0=\"1\" matrix1.WIDTH1=\"12\" matrix1.WIDTH2=\"56\" matrix1.WIDTH3=\"56\" matrix1.WIDTH4=\"56\" matrix1.NUMERICQUANTITY3=\"YES\" matrix1.NUMERICFORMAT3=\"%.0f\"matrix1.NUMERICQUANTITY4=\"YES\" matrix1.NUMERICFORMAT4=\"%.0f\"", 
{ branchname="for i=1,matrix1.numlin do matrix1[\'ALIGN\' .. i .. \':1\']=\"ACENTER:ALEFT\" end", 
{ branchname="matrix1:setcell(0,0,\"    Ergebnisse\")  matrix1:setcell(1,2,\"Datum\") matrix1:setcell(1,3,\"Anzahl Neu\") matrix1:setcell(1,4,\"Anzahl Gesamt\")", 
state="COLLAPSED",
},
{ branchname="for i,v in ipairs(a) do matrix1:setcell(i+1,1,i) matrix1:setcell(i+1,2,os.date(\"%d.%m.%Y\",os.time{year=2021,month=11,day=8+i}))		matrix1:setcell(i+1,3,v) matrix1:setcell(i+1,4,b[i]) end", 
state="COLLAPSED",
},
{ branchname="MDI1Form = iup.dialog{TITLE = \'MDI1\', SIZE = \'300x350\', MDICHILD = \'YES\', PARENTDIALOG = console.dialog,iup.vbox{matrix1,},shrink=\"yes\",}", 
{ branchname="function MDI1Form:resize_cb(w, h) iup.Refresh(MDI1Form) matrix1.rasterwidth1 = nil matrix1.rasterwidth2 = nil matrix1.rasterwidth3 = nil matrix1.rasterwidth4 = nil matrix1.rasterwidth5 = nil matrix1.fittosize = \"columns\" return iup.IGNORE end", 
state="COLLAPSED",
},
{ branchname="MDI1Form:show()", 
state="COLLAPSED",
},
},
},
},
},
},
},
{ branchname="Schätzergebnisse", 
{ branchname="for i=schaetzAnfang,1092 do a[i]=a[i-7]/a[i-14]*a[i-7] b[i]=b[i-1]+a[i] print( os.date(\"%d.%m.%Y\",os.time{year=2021,month=11,day=8+i}) .. \": \" .. i .. \": \" .. math.floor((i-1)/7)+1 .. \": \" .. math.ceil(b[i]) .. \": \" .. os.date(\"%d.%m.%Y\")) end", 
state="COLLAPSED",
},
},
{ branchname="Plot der kumulierten geschätzten Infektionen", 
{ branchname="plot = iup.plot{TITLE = \"Kumulierte geschätzte Infektionen\",MARGINLEFT = 50,MARGINRIGHT = 50,MARGINBOTTOM = 55,MARGINTOP = 85,AXS_XAUTOMIN = \"YES\",AXS_XAUTOMAX = \"YES\",AXS_YAUTOMIN = \"NO\", AXS_YAUTOMAX = \"YES\",--[[AXS_YMAX=1500,]]AXS_YMIN=0,}", 
{ branchname="plot:Begin(0) for i=schaetzAnfang,744 do plot:Add(i,tonumber(b[i])) end plot:End()  plot.DS_MODE=\"LINE\" ", 
{ branchname="MDI1Form = iup.dialog{TITLE = \'MDI1\', SIZE = \'250x210\', MDICHILD = \'YES\', PARENTDIALOG = console.dialog,iup.vbox{plot,},}", 
{ branchname="MDI1Form:show()", 
state="COLLAPSED",
}}}}}}
