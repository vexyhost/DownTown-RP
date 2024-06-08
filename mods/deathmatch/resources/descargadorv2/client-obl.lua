--[[
LISTADO DE MODS OBLIGATORIOS PARA EL JUGADOR:
 ID 88 PERRO 1
 ID 89 PERRO 2
 ID 243 PERRO 3
 ID 244 PERRO 4
 ID 252 PERRO 5
 ID 279 TRAJE BUZO
 ID 431 BUS
 ID 525 GRUA CON COLOR
 ID 578 DFT-30 ES GRUA NUEVA
 ID 604 PATRULLA 5 SUSTITUYE AL DAMAGED GLENDALE, POR ESO ES OBLIGATORIO
 ID 9 Uniforme PD Femenino Blanco
 ID 10 Uniforme PD Femenino Negro
 ID 278 Uniforme MD Femenino
 ID 416 AMBULANCIA
 ID 508 CARAVANA ENTRABLE
]]

function reemplazarModelosObligatorios() 
  txd1 = engineLoadTXD("mods/Mascotas/88.txd", 88 )
  engineImportTXD(txd1, 88)
  dff1 = engineLoadDFF("mods/Mascotas/88.dff", 88 )
  engineReplaceModel(dff1, 88)
  
  txd2 = engineLoadTXD("mods/Mascotas/89.txd", 89 )
  engineImportTXD(txd2, 89)
  dff2 = engineLoadDFF("mods/Mascotas/89.dff", 89 )
  engineReplaceModel(dff2, 89)
  
  txd3 = engineLoadTXD("mods/Mascotas/243.txd", 243 )
  engineImportTXD(txd3, 243)
  dff3 = engineLoadDFF("mods/Mascotas/243.dff", 243 )
  engineReplaceModel(dff3, 243)
  
  txd4 = engineLoadTXD("mods/Mascotas/244.txd", 244 )
  engineImportTXD(txd4, 244)
  dff4 = engineLoadDFF("mods/Mascotas/244.dff", 244 )
  engineReplaceModel(dff4, 244)
  
  txd5 = engineLoadTXD("mods/Mascotas/252.txd", 252 )
  engineImportTXD(txd5, 252)
  dff5 = engineLoadDFF("mods/Mascotas/252.dff", 252 )
  engineReplaceModel(dff5, 252)
  
  txd6 = engineLoadTXD("mods/Skins/279.txd", 279 )
  engineImportTXD(txd6, 279)
  dff6 = engineLoadDFF("mods/Skins/279.dff", 279 )
  engineReplaceModel(dff6, 279)
  
  -- txd7 = engineLoadTXD("mods/Vehs Facciones/431.txd", 431 )
  -- engineImportTXD(txd7, 431)
  -- dff7 = engineLoadDFF("mods/Vehs Facciones/431.dff", 431 )
  -- engineReplaceModel(dff7, 431)
  
  txd8 = engineLoadTXD("mods/Vehs Facciones/525.txd", 525 )
  engineImportTXD(txd8, 525)
  dff8 = engineLoadDFF("mods/Vehs Facciones/525.dff", 525 )
  engineReplaceModel(dff8, 525)
  
  txd9 = engineLoadTXD("mods/Vehs Facciones/578.txd", 578 )
  engineImportTXD(txd9, 578)
  dff9 = engineLoadDFF("mods/Vehs Facciones/578.dff", 578 )
  engineReplaceModel(dff9, 578)
  
  txd10 = engineLoadTXD("mods/Vehs Facciones/604.txd", 604 )
  engineImportTXD(txd10, 604)
  dff10 = engineLoadDFF("mods/Vehs Facciones/604.dff", 604 )
  engineReplaceModel(dff10, 604)
  
  txd11 = engineLoadTXD("mods/Skins/278.txd", 278 )
  engineImportTXD(txd11, 278)
  dff11 = engineLoadDFF("mods/Skins/278.dff", 278 )
  engineReplaceModel(dff11, 278)
  
  txd12 = engineLoadTXD("mods/Skins/9.txd", 9 )
  engineImportTXD(txd12, 9)
  dff12 = engineLoadDFF("mods/Skins/9.dff", 9 )
  engineReplaceModel(dff12, 9)
  
  txd13 = engineLoadTXD("mods/Vehs Facciones/416.txd", 416 )
  engineImportTXD(txd13, 416)
  dff13 = engineLoadDFF("mods/Vehs Facciones/416.dff", 416 )
  engineReplaceModel(dff13, 416)
  
  txd14 = engineLoadTXD("mods/Vehs LowPoly/journey.txd", 508 )
  engineImportTXD(txd14, 508)
  dff14 = engineLoadDFF("mods/Vehs LowPoly/journey.dff", 508 )
  engineReplaceModel(dff14, 508)
  
  txd15 = engineLoadTXD("mods/Skins/10.txd", 10 )
  engineImportTXD(txd15, 10)
  dff15 = engineLoadDFF("mods/Skins/10.dff", 10 )
  engineReplaceModel(dff15, 10)
  
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarModelosObligatorios)