-- by MoDeR2014
local texture = dxCreateTexture(1, 1);
local shader = dxCreateShader("shader.fx");
engineApplyShaderToWorldTexture(shader, "shad_ped");
dxSetShaderValue(shader, "reTexture", texture);

addEventHandler("onClientResourceStop", resourceRoot,
function ()
	engineRemoveShaderFromWorldTexture(shader, "shad_ped");
end );