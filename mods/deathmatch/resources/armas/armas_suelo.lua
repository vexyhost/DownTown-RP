function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM armas_suelo ORDER BY ID ASC" )
		for x, t in ipairs (result) do
			createWeaponOnFloor (t.ID, t.model, t.x, t.y, t.z, t.interior, t.dimension )
		end
	end
)

local ids = {
{wid = 1, mid = 331 },
{wid = 2, mid = 333 },
{wid = 3, mid = 334 },
{wid = 4, mid = 335 },
{wid = 5, mid = 336 },
{wid = 6, mid = 337 },
{wid = 7, mid = 338 },
{wid = 8, mid = 339 },
{wid = 9, mid = 341 },
{wid = 14, mid = 325 },
{wid = 16, mid = 342 },
{wid = 17, mid = 343 },
{wid = 18, mid = 344 },
{wid = 22, mid = 346 },
{wid = 23, mid = 347 },
{wid = 24, mid = 348 },
{wid = 25, mid = 349 },
{wid = 26, mid = 350 },
{wid = 27, mid = 351 },
{wid = 28, mid = 352 },
{wid = 29, mid = 353 },
{wid = 30, mid = 355 },
{wid = 31, mid = 356 },
{wid = 32, mid = 372 },
{wid = 33, mid = 357 },
{wid = 34, mid = 358 },
{wid = 39, mid = 363 },
{wid = 41, mid = 365 },
{wid = 42, mid = 366 },
{wid = 43, mid = 367 },
}

function getModelFromID (id)
    if id then
		for k, v in ipairs(ids) do
			if id > 0 and id < 44 then
				if v.wid == id then return v.mid end
			else
				if v.mid == id then return v.wid end
			end
		end
    end
end
 
function createWeaponOnFloor ( id, model, x, y, z, inter, dim )
	if model and x and y and z and inter and dim then
		local model = getModelFromID ( model )
		if model then
			local object = createObject ( model, x, y, z-0.9, 90, 0, 0 )
			setElementInterior( object, inter)
			setElementDimension( object, dim)
			setElementData(object, "sqlIDarma", tonumber(id))
			return true
		end
	else
		return false
	end
end
  
function tirararma ( source )
    local Arma = getPedWeapon ( source )
    local Municion = getPedTotalAmmo ( source )
	local int = getElementInterior ( source )
	local dim = getElementDimension ( source )
	local cid = exports.players:getCharacterID(source)
	if isPedInVehicle ( source ) then outputChatBox  ( "No puedes tirar un arma desde un coche.", source, 255, 255, 255, true ) return end
    if takeWeapon ( source, Arma ) then
		removeElementData(source, "wid")
	    exports.chat:me ( source, "deja el arma en el suelo." )
        setPedAnimation ( source, "BOMBER", "BOM_Plant", 3000, false )
		x, y, z = getElementPosition(source)
		local ID, error = exports.sql:query_insertid( "INSERT INTO armas_suelo (model, ammo, x, y, z, interior, dimension, characterID) VALUES (".. Arma..","..Municion..",".. x..","..y..","..z ..","..int..","..dim..","..cid..")" )
		if ID and not error then
			createWeaponOnFloor (ID, Arma, x, y, z, int, dim )
		end
	end
end
addCommandHandler ( "tirararma", tirararma )
addCommandHandler ( "dejararma", tirararma )
 
function recogerArma ( thePlayer )
	local armaARetirar = nil
	for k, v in ipairs (getElementsByType("object")) do
		local x, y, z = getElementPosition(thePlayer)
		if v and getElementData(v, "sqlIDarma") and getElementDimension(thePlayer) == getElementDimension(v) and isElementInRange(v, x, y, z, 1.3) and not armaARetirar then
			armaARetirar = true
			local sql = exports.sql:query_assoc_single("SELECT * FROM armas_suelo WHERE ID = "..getElementData(v, "sqlIDarma"))
			if sql.ID then
				if (exports.players:getCharacterID(thePlayer) == sql.characterID) or getElementData(thePlayer, "account:gmduty") == true then
					exports.chat:me ( thePlayer, "recoge un arma del suelo." )
					setPedAnimation ( thePlayer, "BOMBER", "BOM_Plant", 3000, false )
					exports.items:give( thePlayer , 29, tostring(sql.model), "Arma " .. tostring(sql.model), sql.ammo)
					exports.sql:query_free( "DELETE FROM armas_suelo WHERE ID = " .. sql.ID )
					destroyElement ( v )
				else
					outputChatBox("Este arma no es tuya.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Se ha producido un error grave. Inténtalo más tarde.", thePlayer, 255, 0, 0)
			end
		end
	end
	if not armaARetirar then
		outputChatBox("No estás cerca de ningún arma", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("cogerarma", recogerArma)
addCommandHandler("recogerarma", recogerArma)