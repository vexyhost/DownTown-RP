local ropaActivada = false -- Por defecto, el tipo no será blanco.
local shaderRopa0 = {}
local shaderRopa1 = {}
local shaderRopa2 = {}
local shaderRopa3 = {}
local shaderRopa13 = {}
local shaderRopa14 = {}
local shaderRopa15 = {}
local shaderRopa16 = {}
local texturaRopa0 = {}
local texturaRopa1 = {}
local texturaRopa2 = {}
local texturaRopa3 = {}
local texturaRopa13 = {}
local texturaRopa14 = {}
local texturaRopa15 = {}
local texturaRopa16 = {}

 
function aplicarRopaBlanco()
	local trabajontext, trabajonmodel = getPedClothes(source, 17)
	for i = 0, 16 do
		local ntext, nmodel = getPedClothes(source, i)
		--if tostring(ntext) ~= "false" then
			if fileExists("material/support/img/"..tostring(ntext)..".png") then
				if i == 0 and not trabajontext then -- Camiseta (cj_ped_torso)
					if shaderRopa0[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa0[source],"cj_ped_torso", source)
						if texturaRopa0[source] and isElement(texturaRopa0[source]) then
							destroyElement(texturaRopa0[source])
						end
						texturaRopa0[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa0[source],"gTexture",texturaRopa0[source])
						engineApplyShaderToWorldTexture(shaderRopa0[source],"cj_ped_torso", source)
					else
						shaderRopa0[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa0[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa0[source],"gTexture",texturaRopa0[source])			
						engineApplyShaderToWorldTexture(shaderRopa0[source],"cj_ped_torso", source)
					end
				elseif i == 1 then -- Cabeza (cj_ped_head)
					if shaderRopa1[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa1[source],"cj_ped_head", source)
						if texturaRopa1[source] and isElement(texturaRopa1[source]) then
							destroyElement(texturaRopa1[source])
						end
						texturaRopa1[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa1[source],"gTexture",texturaRopa1[source])
						engineApplyShaderToWorldTexture(shaderRopa1[source],"cj_ped_head", source)
					else
						shaderRopa1[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa1[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa1[source],"gTexture",texturaRopa1[source])			
						engineApplyShaderToWorldTexture(shaderRopa1[source],"cj_ped_head", source)
					end
				elseif i == 2 and not trabajontext then -- Pantalones (cj_ped_legs)
					if shaderRopa2[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa2[source],"cj_ped_legs", source)
						if texturaRopa2[source] and isElement(texturaRopa2[source]) then
							destroyElement(texturaRopa2[source])
						end
						texturaRopa2[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa2[source],"gTexture",texturaRopa2[source])
						engineApplyShaderToWorldTexture(shaderRopa2[source],"cj_ped_legs", source)
					else
						shaderRopa2[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa2[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa2[source],"gTexture",texturaRopa2[source])			
						engineApplyShaderToWorldTexture(shaderRopa2[source],"cj_ped_legs", source)
					end
				elseif i == 3 then -- Zapatos (cj_ped_feet)
					if shaderRopa3[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa3[source],"cj_ped_feet", source)
						if texturaRopa3[source] and isElement(texturaRopa3[source]) then
							destroyElement(texturaRopa3[source])
						end
						texturaRopa3[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa3[source],"gTexture",texturaRopa3[source])
						engineApplyShaderToWorldTexture(shaderRopa3[source],"cj_ped_feet", source)
					else
						shaderRopa3[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa3[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa3[source],"gTexture",texturaRopa3[source])			
						engineApplyShaderToWorldTexture(shaderRopa3[source],"cj_ped_feet", source)
					end
				elseif i == 13 then -- Collares (cj_ped_necklace)
					if shaderRopa13[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa13[source],"cj_ped_necklace", source)
						if texturaRopa13[source] and isElement(texturaRopa13[source]) then
							destroyElement(texturaRopa13[source])
						end
						texturaRopa13[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa13[source],"gTexture",texturaRopa13[source])
						engineApplyShaderToWorldTexture(shaderRopa13[source],"cj_ped_necklace", source)
					else
						shaderRopa13[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa13[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa13[source],"gTexture",texturaRopa13[source])			
						engineApplyShaderToWorldTexture(shaderRopa13[source],"cj_ped_necklace", source)
					end
				elseif i == 14 then -- Relojes (cj_ped_watch)
					if shaderRopa14[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa14[source],"cj_ped_watch", source)
						if texturaRopa14[source] and isElement(texturaRopa14[source]) then
							destroyElement(texturaRopa14[source])
						end
						texturaRopa14[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa14[source],"gTexture",texturaRopa14[source])
						engineApplyShaderToWorldTexture(shaderRopa14[source],"cj_ped_watch", source)
					else
						shaderRopa14[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa14[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa14[source],"gTexture",texturaRopa14[source])			
						engineApplyShaderToWorldTexture(shaderRopa14[source],"cj_ped_watch", source)
					end
				elseif i == 15 then -- Gafas (cj_ped_glasses)
					if shaderRopa15[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa15[source],"cj_ped_glasses", source)
						if texturaRopa15[source] and isElement(texturaRopa15[source]) then
							destroyElement(texturaRopa15[source])
						end
						texturaRopa15[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa15[source],"gTexture",texturaRopa15[source])
						engineApplyShaderToWorldTexture(shaderRopa15[source],"cj_ped_glasses", source)
					else
						shaderRopa15[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa15[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa15[source],"gTexture",texturaRopa15[source])			
						engineApplyShaderToWorldTexture(shaderRopa15[source],"cj_ped_glasses", source)
					end
				elseif i == 16 then -- Sombreros (cj_ped_hat)
					if shaderRopa16[source] then
						engineRemoveShaderFromWorldTexture(shaderRopa16[source],"cj_ped_hat", source)
						if texturaRopa16[source] and isElement(texturaRopa16[source]) then
							destroyElement(texturaRopa16[source])
						end
						texturaRopa16[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa16[source],"gTexture",texturaRopa16[source])
						engineApplyShaderToWorldTexture(shaderRopa16[source],"cj_ped_hat", source)
					else
						shaderRopa16[source] = dxCreateShader( "material/effect.fx", 0, 0, true,"ped")
						texturaRopa16[source] = dxCreateTexture( "material/support/img/"..tostring(ntext)..".png")
						dxSetShaderValue(shaderRopa16[source],"gTexture",texturaRopa16[source])			
						engineApplyShaderToWorldTexture(shaderRopa16[source],"cj_ped_hat", source)
					end
				end
			end
		--end
	end  
	if trabajontext then -- Tiene una ropa de trabajo, nos cargamos los shader pertinentes.
		if shaderRopa0[source] then
			engineRemoveShaderFromWorldTexture(shaderRopa0[source],"cj_ped_torso", source)
			if texturaRopa0[source] then
				destroyElement(texturaRopa0[source])
			end
		end
		if shaderRopa2[source] then
			engineRemoveShaderFromWorldTexture(shaderRopa2[source],"cj_ped_legs", source)
			if texturaRopa2[source] then
				destroyElement(texturaRopa2[source])
			end
		end   
		-- Reaplicamos ropa (otro parche mas xd)
		addPedClothes(source, tostring(trabajontext), tostring(trabajonmodel), 17)
	end
end
addEvent("onSolicitarRopaBlanco", true)
addEventHandler("onSolicitarRopaBlanco", getRootElement(), aplicarRopaBlanco)

function resetRopaBlanco()
	-- 0
	if shaderRopa0[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa0[source],"cj_ped_torso", source)
	end
	if texturaRopa0[source] and isElement(texturaRopa0[source]) then
		destroyElement(texturaRopa0[source])
	end
	-- 1
	if shaderRopa1[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa1[source],"cj_ped_head", source)
	end
	if texturaRopa1[source] and isElement(texturaRopa1[source]) then
		destroyElement(texturaRopa1[source])
	end
	-- 2
	if shaderRopa2[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa2[source],"cj_ped_legs", source)
	end
	if texturaRopa2[source] and isElement(texturaRopa2[source]) then
		destroyElement(texturaRopa2[source])
	end
	-- 3
	if shaderRopa3[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa3[source],"cj_ped_feet", source)
	end
	if texturaRopa3[source] and isElement(texturaRopa3[source]) then
		destroyElement(texturaRopa3[source])
	end
	-- 13
	if shaderRopa13[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa13[source],"cj_ped_necklace", source)
	end
	if texturaRopa13[source] and isElement(texturaRopa13[source]) then
		destroyElement(texturaRopa13[source])
	end
	-- 14
	if shaderRopa14[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa14[source],"cj_ped_watch", source)
	end
	if texturaRopa14[source] and isElement(texturaRopa14[source]) then
		destroyElement(texturaRopa14[source])
	end
	-- 15
	if shaderRopa15[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa15[source],"cj_ped_glasses", source)
	end
	if texturaRopa15[source] and isElement(texturaRopa15[source]) then
		destroyElement(texturaRopa15[source])
	end
	-- 16
	if shaderRopa16[source] then
		engineRemoveShaderFromWorldTexture(shaderRopa16[source],"cj_ped_hat", source)
	end
	if texturaRopa16[source] and isElement(texturaRopa16[source]) then
		destroyElement(texturaRopa16[source])
	end
end
addEvent("onResetRopaBlanco", true)
addEventHandler("onResetRopaBlanco", getRootElement(), resetRopaBlanco)

addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()),
    function (  )
        setTimer(triggerServerEvent, 1500, 1, "onAplicarRopaAlIniciar", getLocalPlayer(), getLocalPlayer())
    end
)

--[[
function resetClothes()
	if theShader then
		engineRemoveShaderFromWorldTexture ( theShader, "cj_ped_head", getLocalPlayer())
	end 
end
addCommandHandler("nochica", resetClothes)

--addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()),resetClothes )
]]