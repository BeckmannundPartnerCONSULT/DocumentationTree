
--Variablen ohne Umlaute und Sonderzeichen
--Makros
Haircut100Prozent__Makro0_Textdateikopie_und_Mlc_rlpco_dirty_geladen_branchname =
{branchname="K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent__Makro0_Textdateikopie_und_Mlc_rlpco_dirty_geladen.lua51",
{branchname=[[os.execute('start "Textdatei" "K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent.txt"')]],
'Macro Tool Abfrage als Input: 100% internalHaircut_ADBAggTrWER_v',},
}

Haircut100Prozent__Makro1_GPueberzogen_Ausnahmen_kennzeichnen_branchname =
{branchname ="K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent__Makro1_GPueberzogen_Ausnahmen_kennzeichnen.lua51",
{branchname ='dofile("K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent_löschen.lua51")',
'Delete from Haircut100Prozent',
},
{branchname ='dofile("K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent_Import.lua51")',
{branchname ='.read K:/Themen/THE007/INTERNAL/Unterstuetzung_Tagesarbeit/Ablaeufe/CoPs/DB/Haircut100Prozent_Import.pgm',
'.import K:/Themen/THE007/INTERNAL/Unterstuetzung_Tagesarbeit/Ablaeufe/CoPs/DB/Haircut100Prozent.txt Haircut100Prozent',
},
},
{branchname ='dofile("K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent_Mlc_rlpco_löschen.lua51")',
'Delete from Mlc_rlpco',
},
{branchname ='dofile("K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent_Mlc_rlpco_Import.lua51")',
{branchname ='.read K:/Themen/THE007/INTERNAL/Unterstuetzung_Tagesarbeit/Ablaeufe/CoPs/DB/Haircut100Prozent_Mlc_rlpco_Import.pgm',
'.import K:/Themen/THE007/INTERNAL/Unterstuetzung_Tagesarbeit/Ablaeufe/CoPs/DB/Mlc_rlpco.txt Mlc_rlpco',
},
},
'Delete from Haircut100Prozent_GPueberzogen',
'insert into Haircut100Prozent_GPueberzogen (SAP_GP,Auslastung,Laufzeitenband,Linie) select distinct Mlc_rlpco.SAP_GP, Mlc_rlpco.Feld6/Mlc_rlpco.Linie as Auslastung, Mlc_rlpco.Laufzeitenband, Mlc_rlpco.Linie',
}


Haircut100Prozent__Makro2_Referenz_pflegen_branchname =
{branchname="K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent__Makro2_Referenz_pflegen.lua51",
'Delete from Haircut100Prozent_ISINueberzogen',
'insert into Haircut100ProzentISINueberzogen (ISIN) select distinct ISIN',
}


Haircut100Prozent__Makro3_Auswahl_mit_Referenz_fuer_CoPS_branchname =
{branchname="K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent__Makro3_Auswahl_mit_Referenz_fuer_CoPS.lua51",
"select tradeID, notionalCcyLeg1, 'Default Haircut. Original-Haircut nicht angemessen. ' || KommentarISIN AS Beurteilung, Haircut, Haircut100Prozent.ISIN, KommentarISIN, Haircut100ProzentReferenz.Quelle, collPrice, headSapGpNr",
[[os.execute('start "Output" "K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent_Export.iup319lua51"')]],
}



--Tabellen Create Table suchen und anpassen in SQLite

Haircut100Prozent_branchname ={branchname="Haircut100Prozent", state = 'COLLAPSED',
{'valDate', prefix="Präfix: "},
{prefix="Präfix: ", 'aggMode'},
'RM',
'confidenceLevel',
'originalTradeID',
'tradeID',
'headSapGpNr',
'grp',
'pillar',
'pillarIndex',
'npv',
'ao',
'abr',
'ledisProductType',
'frontOfficeProduct',
'maID',
'csaLedis',
'portfolio',
'maturityDate',
'traderXN',
'sapGpNr',
'riskKind',
'ccy',
'notional',
'addOnFamily',
'maturityDateAddOn',
'tradeStatus',
'pvMode',
'exposurePillar',
'deckungsStockFlag',
'modified',
'book',
'addOnInstrument',
'buyOrSell',
'murexOriginalID',
'lpaPubType',
'isVrCross',
'certificate',
'pillarEndDate',
'tradeDate',
'startDate',
'ISIN',
'underlying',
'collCcy',
'sectorCode',
'hcLookUpRating',
'wal',
'duration',
'riskHorizon',
'hcPrice',
'hcFx',
'hcCorrel',
'internalHaircut',
'collPrice',
'notionalLeg1',
'notionalCcyLeg1',
'notionalLeg2',
'notionalCcyLeg2',
'ownEntityBranch',
'protection',
'linkedTradeID',
'externalHaircut',
'entity',
'isEmirCA',
'uniqueTradeID',
'breakDate',
'maturityDateRaw',
'csaID',
'typology',
'contractTypology',
'packageTypology',
'contractOriginalID',
'contractID',
'packageOriginalID',
'packageID',
'rootContractID',
'isMainTrade',
'hasAdditionalRisk',
'originalLinkedTradeID',
'sumPV',
'componentNPV',
'breakBy',
'cancBy',
'cancelDate',
'breakDateRaw',
'cancelDateRaw',
}

Haircut100Prozent_GPueberzogen_branchname=
{branchname="Haircut100Prozent_GPueberzogen", state ='COLLAPSED',
'SAP_GP',
'Auslastung',
'Laufzeitenband',
'Linie',
'Ausnahme',
}

Haircut100Prozent_ISINueberzogen_branchname=
{branchname="Haircut100Prozent_ISINueberzogen", state ='COLLAPSED',
'ISIN',
}

Mlc_rlpco_branchname=
{branchname="Mlc_rlpco", state ='COLLAPSED',
'ID',
'SAP_GP',
'Feld3',
'Laufzeitenband',
'Feld5',
'Feld6',
'Feld7',
'Feld8',
'Feld9',
'Linie_DS',
'IA_DS',
'Available_DS',
'Linie',
'IA',
'Available',
'Feld16',
'Feld17',
'Feld18',
'Feld19',
'Feld20',
'Feld21',
'Feld22',
'Feld23',
'Feld24',
'Feld25',
'Feld26',
'Feld27',
}

Haircut100ProzentReferenz_branchname=
{branchname="Haircut100ProzentReferenz", state = 'COLLAPSED',
'ISIN',
'KommentarISIN',
'Quelle',
'Haircut',
'Korrekturbedarf',
}


--Abfragen und Exporte
insert_into_Haircut100Prozent_GPueberzogen_branchname=
{branchname="insert_into_Haircut100Prozent_GPueberzogen", state ='COLLAPSED',
'Mlc_rlpco.SAP_GP',
'Mlc_rlpco.Feld6/Mlc_rlpco.Linie as Auslastung',
'Mlc_rlpco.Laufzeitenband',
'Mlc_rlpco.Linie',
Mlc_rlpco_branchname,
Haircut100Prozent_branchname,
}

Ziel_Haircut100Prozent_GPueberzogen_branchname=
{branchname="Ziel: Haircut100Prozent_GPueberzogen",
insert_into_Haircut100Prozent_GPueberzogen_branchname,
}

insert_into_Haircut100Prozent_ISINueberzogen_branchname=
{branchname="insert_into_Haircut100Prozent_ISINueberzogen", state ='COLLAPSED',
'ISIN',
Haircut100Prozent_GPueberzogen_branchname,
Haircut100Prozent_branchname,
}

Ziel_Haircut100Prozent_ISINueberzogen_branchname=
{branchname="Ziel: Haircut100Prozent_ISINueberzogen",
insert_into_Haircut100Prozent_ISINueberzogen_branchname,}

insert_into_Haircut100ProzentReferenz_branchname=
{branchname="insert_into_Haircut100ProzentReferenz", state ='COLLAPSED',
'ISIN',
Haircut100Prozent_ISINueberzogen_branchname,
}

Ziel_Haircut100ProzentReferenz_branchname=
{branchname="Ziel: Haircut100ProzentReferenz",
insert_into_Haircut100ProzentReferenz_branchname,}


select_fuer_output_branchname=
{branchname="select_fuer_output", state = 'COLLAPSED',
'tradeID',
'notionalCcyLeg1',
[['Default Haircut. Original-Haircut nicht angemessen. ' || KommentarISIN as Beurteilung]],
'Haircut',
'Haircut100Prozent.ISIN',
'KommentarISIN',
'Haircut100ProzentReferenz.Quelle',
'collPrice',
'headSapGpNr',
Haircut100Prozent_branchname,
Haircut100Prozent_ISINueberzogen_branchname,
Haircut100ProzentReferenz_branchname,
}


Haircut100Prozent_Export_branchname=
{branchname="K:\\Themen\\THE007\\INTERNAL\\Unterstuetzung_Tagesarbeit\\Ablaeufe\\CoPs\\DB\\Haircut100Prozent_Export.iup319lua51",
'Nr',
'tableName',
'columnName',
'type/Währung',
'Haircut',
'tradeID',
'Beurteilung',
'ISIN',
'Kommentar ISIN',
'Quelle',
'Haircut wiederholt',
'headSapGpNr',
'Kopie Access',
select_fuer_output_branchname,
}

--Gesamtbaum
list_branchname={branchname="Datenbankzusammenhänge objektorientiert",
{branchname="Makros",
Haircut100Prozent__Makro0_Textdateikopie_und_Mlc_rlpco_dirty_geladen_branchname,
Haircut100Prozent__Makro1_GPueberzogen_Ausnahmen_kennzeichnen_branchname,
Haircut100Prozent__Makro2_Referenz_pflegen_branchname,
Haircut100Prozent__Makro3_Auswahl_mit_Referenz_fuer_CoPS_branchname,
},
{branchname="Hauptabfragen und Exporte",
Ziel_Haircut100Prozent_GPueberzogen_branchname,
Ziel_Haircut100Prozent_ISINueberzogen_branchname,
Ziel_Haircut100ProzentReferenz_branchname,
Ziel_Haircut100Prozent_Export_branchname,
},
{branchname="Weitere Abfragen", state = 'COLLAPSED',
insert_into_Haircut100Prozent_GPueberzogen_branchname,
insert_into_Haircut100Prozent_ISINueberzogen_branchname,
insert_into_Haircut100ProzentReferenz_branchname,
select_fuer_output_branchname,
},
{branchname="Tabellen",
Haircut100Prozent_branchname,
Haircut100Prozent_GPueberzogen_branchname,
Haircut100Prozent_ISINueberzogen_branchname,
Haircut100ProzentReferenz_branchname,
Mlc_rlpco_branchname,
},
}

return list_branchname

