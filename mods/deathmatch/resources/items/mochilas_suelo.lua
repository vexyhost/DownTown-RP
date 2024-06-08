function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end
  
addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM mochilas_suelo ORDER BY mochilaID ASC" )
		for x, t in ipairs (result) do
			createMochilaOnFloor (t.mochilaID, t.model, t.x, t.y, t.z, t.interior, t.dimension )
		end
	end
)
 
function createMochilaOnFloor ( id, model, x, y, z, inter, dim )
	if id and model and x and y and z and inter and dim then
		local object = createObject ( model, x, y, z, 0, 0, 0 )
		setElementInterior( object, inter)
		setElementDimension( object, dim)
		setElementData(object, "sqlIDmochila", tonumber(id))
		setElementCollisionsEnabled(object, false)
		return true
	else
		return false
	end
end
  
function tirarMochila ()
	local mochilaID = getElementData(source, "mochilaID")
	local mochilaModel = getElementData(source, "mochilaModel")
    if mochilaID and mochilaModel then
	    exports.chat:me ( source, "deja la mochila en el suelo." )
		outputChatBox("Usa /recogermochila para recoger la mochila que has tirado.", source, 0, 255, 0)
        setPedAnimation ( source, "BOMBER", "BOM_Plant", 3000, false )
		local dim = getElementDimension ( source )
		local cid = exports.players:getCharacterID(source)
		local int = getElementInterior ( source )
		local x, y, z = getElementPosition(source)
		local ID, error = exports.sql:query_insertid( "INSERT INTO mochilas_suelo (mochilaID, model, x, y, z, interior, dimension, characterID) VALUES ("..mochilaID..","..mochilaModel..",".. x..","..y..","..(z-0.5)..","..int..","..dim..","..cid..")" )
		if ID and not error then
			createMochilaOnFloor(mochilaID, mochilaModel, x, y, (z-0.7), int, dim)
			exports.sql:query_free("DELETE FROM `items` WHERE `item` = 12 AND `value2` = " .. tonumber(mochilaID))
			exports.items:load(source, true)
			removeElementData(source, "mochilaID")
			removeElementData(source, "mochilaModel")
		end
	end
end
addEvent("onTirarMochila", true)
addEventHandler("onTirarMochila", getRootElement(), tirarMochila)
 
function recogerMochila ( thePlayer )
	local mochilaARetirar = nil
	for k, v in ipairs (getElementsByType("object")) do
		local x, y, z = getElementPosition(thePlayer)
		if v and isElement(v) and getElementData(v, "sqlIDmochila") and getElementDimension(thePlayer) == getElementDimension(v) and isElementInRange(v, x, y, z, 1.3) and not armaARetirar then
			mochilaARetirar = true
			local sql = exports.sql:query_assoc_single("SELECT * FROM mochilas_suelo WHERE mochilaID = "..getElementData(v, "sqlIDmochila"))
			if sql.mochilaID then
				exports.chat:me ( thePlayer, "recoge una mochila del suelo." )
				setPedAnimation ( thePlayer, "BOMBER", "BOM_Plant", 3000, false )
				if tonumber(sql.model) == 2081 then
					nombreM = "small"
				elseif tonumber(sql.model) == 2082 then
					nombreM = "alice"
				elseif tonumber(sql.model) == 2083 then
					nombreM = "czech"
				elseif tonumber(sql.model) == 2084 then
					nombreM = "coyote"
				end
				exports.items:give(thePlayer , 12, tonumber(sql.model), tostring(nombreM), sql.mochilaID)
				exports.sql:query_free( "DELETE FROM mochilas_suelo WHERE mochilaID = " .. sql.mochilaID )
				destroyElement(v)
				exports.items:load(thePlayer, true)
			else
				outputChatBox("Se ha producido un error grave. Inténtalo más tarde.", thePlayer, 255, 0, 0)
			end
		end
	end
	if not mochilaARetirar then
		outputChatBox("No estás cerca de ninguna mochila.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("cogermochila", recogerMochila)
addCommandHandler("recogermochila", recogerMochila)