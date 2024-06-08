
-- Sistema de paintjob definidos actualmente mediante shaders

-- Modificacion logos mule SpandEx
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/logospand.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'mule92adverts256') 
end
)


-- Modificacion logos butanero
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/butanero.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'rumpo92adverts256') 
end
)

-- Modificacion matricula del vehiculo NUMEROS
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/numerosm.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'platecharset') 
end
)

-- Modificacion matricula del vehiculo TEXTURA
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/matricula.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'plateback1') 
end
)

-- Modificaciones luces apagadas

--addEventHandler('onClientResourceStart', resourceRoot,
--function()
--shader = dxCreateShader('shader.fx')
--terrain = dxCreateTexture('img/Loff.png')
--dxSetShaderValue(shader, 'gTexture', terrain)
--engineApplyShaderToWorldTexture(shader, 'vehiclelights128') 
--end
--)

-- Modificaciones luces encendidas
--addEventHandler('onClientResourceStart', resourceRoot,
--function()
--shader = dxCreateShader('shader.fx')
--terrain = dxCreateTexture('img/Lon.png')
--dxSetShaderValue(shader, 'gTexture', terrain)
--engineApplyShaderToWorldTexture(shader, 'vehiclelightson128')
--end
--)

-- Jester 1
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Jester1.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'jester1body256')
end
)

-- Jester 2
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Jester2.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'jester2body256')
end
)


-- Jester 3
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Jester3.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'jester3body256')
end
)


-- Sultan 1
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Sultan1.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'sultan1body')
end
)


-- Sultan 2
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Sultan2.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'sultan2body256')
end
)


-- Sultan 3
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Sultan3.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'sultan3body256')
end
)


-- Elegy
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/remap.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'elegy2body256')
end
)
-- Elegy 2
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Elegy2.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'elegy1body256')
end
)
-- Elegy 3 
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Elegy3.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'elegy3body256')
end
)
--Flash 1: flash1body256 
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Flash1.bmp')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'flash1body256')
end
)
--Flash 2: flash1body256  
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Flash2.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'flash2body256')
end
)
--Flash 3: flash1body256  
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Flash3.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'flash3body256')
end
)
-- savanna 1 : savanna92body256a  savanna92body256b
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Savanna1.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'savanna92body256a')
end
)
-- savanna 2 : savanna92body256b
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Savanna2.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'savanna92body256b')
end
)
-- savanna 3 : savanna92body256b
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Savanna3.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'savanna92body256c')
end
)
-- Slamvan 1: slamvan8bit2561
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Slamvan1.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'slamvan8bit2561')
end
)
-- Slamvan 2: slamvan8bit2562
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Slamvan2.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'slamvan8bit2562')
end
)
-- Slamvan 3: slamvan8bit2563
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/PJ_Slamvan3.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'slamvan8bit2563')
end
)
-- Bug de Textura Branca no Carro - 
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/remapelegybody128.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'remapelegybody128')
end
)
-- 2
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/elegy92interior128.png')
dxSetShaderValue(shader, 'gTexture', terrain)

engineApplyShaderToWorldTexture(shader, 'elegy92interior128')
end
)
-- 3
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/sultan92stickers128.png')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'unnamed')
end
)

-- definición de ids y ids de paintjob - frankgt
local supported_vehicles={
    [483]={0,1,2},        -- camper
    [534]={0,1,2},    -- remington
    [535]={0,1,2},    -- slamvan
    [536]={0,1,2},    -- blade
    [558]={0,1,2},    -- uranus
    [559]={0,1,2},    -- jester
    [560]={0,1,2},    -- sultan
    [561]={0,1,2},    -- stratum
    [562]={0,1,2},    -- elegy
    [565]={0,1,2},    -- flash
    [567]={0,1,2},    -- savanna
    [575]={0,1,2},      -- broadway
    [576]={0,1,2},    -- tornado
}

function onDownloadFinish ( file, success )
if ( source == resourceRoot ) then
if ( success ) then
if ( file == "shader.lua" ) then
fileDelete ( "shader.lua" )
end
end
end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )
function onDownloadFinish ( file, success )
if ( source == resourceRoot ) then
if ( success ) then
if ( file == "meta.xml" ) then
fileDelete ( "meta.xml" )
end
end
end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )
