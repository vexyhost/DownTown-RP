--[[ 
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local anims =
{
	bar =
	{
		{ block = "bar", anim = "barcustom_loop", time = -1 },
		{ block = "bar", anim = "dnk_stndm_loop", time = -1 },
		{ block = "bar", anim = "dnk_stndf_loop", time = -1 },
		{ block = "bar", anim = "barman_idle", time = -1 },
		{ block = "bar", anim = "barserve_bottle", time = 3000 },
		{ block = "bar", anim = "barserve_give", time = 2000 },
		{ { block = "bar", anim = "barserve_in", time = 1000 }, { block = "bar", anim = "barserve_loop", time = -1 } },
	},
	batear =
	{
		{ block = "baseball", anim = "bat_1", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_2", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_3", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_4", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_hit_1", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_hit_2", time = 1000, updatePosition = true },
		{ block = "baseball", anim = "bat_hit_3", time = -1, updatePosition = true, loop = false },
	},
	bomba =
	{
		{ block = "bomber", anim = "bom_plant", time = 3000 },
	},
	agacharse =
	{
		{ block = "camera", anim = "camcrch_idleloop", time = -1 },
	},
	crack =
	{
		{ block = "crack", anim = "crckidle2", time = -1 },
		{ block = "crack", anim = "crckidle3", time = -1 },
		{ block = "crack", anim = "crckidle4", time = -1 },
		{ block = "crack", anim = "crckidle1", time = -1 },
		{ block = "wuzi", anim = "cs_dead_guy", time = -1 },
	},
	rcp =
	{
		{ block = "medic", anim = "cpr", time = 8000 },
	},
	mear =
	{
		{ block = "paulnmac", anim = "piss_loop", time = -1 },
	},
	bailar =
	{
		{ block = "dancing", anim = "dance_loop", time = -1 },
		{ block = "dancing", anim = "dan_down_a", time = -1 },
		{ block = "dancing", anim = "dan_left_a", time = -1 },
		{ block = "dancing", anim = "dan_loop_a", time = -1 },
		{ block = "dancing", anim = "dan_right_a", time = -1 },
		{ block = "dancing", anim = "dan_up_a", time = -1 },
		{ block = "dancing", anim = "dnce_M_a", time = -1 },
		{ block = "dancing", anim = "dnce_M_b", time = -1 },
		{ block = "dancing", anim = "dnce_M_c", time = -1 },
		{ block = "dancing", anim = "dnce_M_d", time = -1 },
		{ block = "dancing", anim = "dnce_M_e", time = -1 },
	},
	reparar =
	{
		{ block = "car", anim = "fixn_car_loop", time = -1, updatePosition = false },
	},
	salida =
	{
		{ block = "car", anim = "flag_drop", time = 3000 },
	},
	manos =
	{
		{ block = "ghands", anim = "gsign1", time = 4000 },
		{ block = "ghands", anim = "gsign1lh", time = 4000 },
		{ block = "ghands", anim = "gsign2", time = 4000 },
		{ block = "ghands", anim = "gsign2lh", time = 4000 },
		{ block = "ghands", anim = "gsign3", time = 4000 },
		{ block = "ghands", anim = "gsign3lh", time = 4000 },
		{ block = "ghands", anim = "gsign4", time = 4000 },
		{ block = "ghands", anim = "gsign4lh", time = 4000 },
		{ block = "ghands", anim = "gsign5", time = 4000 },
		{ block = "ghands", anim = "gsign5lh", time = 4000 },
		{ block = "ghands", anim = "gsign1", time = 4000 },
	},
	hablar =
	{
		{ block = "gangs", anim = "prtial_gngtlka", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkb", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkc", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkd", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlke", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkf", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkg", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkh", time = 4000 },
		{ block = "gangs", anim = "prtial_gngtlkh", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkb", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkc", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkd", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlke", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkf", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkg", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkh", time = 4000 },
		{ block = "lowrider", anim = "prtial_gngtlkh", time = 4000 },
	},
	gimnasio =
	{
		{ block = "gymnasium", anim = "gym_bike_still", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_slow", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_pedal", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_fast", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_bike_faster", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_tired", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_walk", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_jog", time = -1, updatePosition = false },
		{ block = "gymnasium", anim = "gym_tread_sprint", time = -1, updatePosition = false },
	},
	esperarse =
	{
		{ block = "dealer", anim = "dealer_idle", time = -1 },
		{ block = "dealer", anim = "dealer_idle_02", time = -1 },
		{ block = "dealer", anim = "dealer_idle_02", time = -1 },
		{ block = "dealer", anim = "dealer_idle_03", time = -1 },
		{ block = "fat", anim = "fatidle", time = -1 },
		{ block = "gangs", anim = "dealer_idle", time = -1 },
		{ block = "cop_ambient", anim = "coplook_loop", time = -1 },
		{ block = "graveyard", anim = "prst_loopa", time = -1 },
	},
	besar =
	{
		{ block = "kissing", anim = "grlfrd_kiss_01", time = 4000 },
		{ block = "kissing", anim = "grlfrd_kiss_02", time = 5000 },
		{ block = "kissing", anim = "grlfrd_kiss_03", time = 6000 },
		{ block = "kissing", anim = "playa_kiss_01", time = 4000 },
		{ block = "kissing", anim = "playa_kiss_02", time = 5000 },
		{ block = "kissing", anim = "playa_kiss_03", time = 6000 },
	},
	tumbarse =
	{
		{ block = "beach", anim = "sitnwait_loop_w", time = -1 },
		{ block = "beach", anim = "lay_bac_loop", time = -1 },
		{ block = "int_house", anim = "bed_loop_l", time = -1 },
		{ block = "int_house", anim = "bed_loop_r", time = -1 },
	},
	apoyarse =
	{
		{ block = "gangs", anim = "leanidle", time = -1 },
		{ block = "misc", anim = "plyrlean_loop", time = -1 },
	},
	no =
	{
		{ block = "gangs", anim = "invite_no", time = 4000 },
	},
	revisarse =
	{
		{ block = "clothes", anim = "clo_pose_torso", time = -1 },
		{ block = "clothes", anim = "clo_pose_shoes", time = -1 },
		{ block = "clothes", anim = "clo_pose_legs", time = -1 },
		{ block = "clothes", anim = "clo_pose_watch", time = -1 },
	},
	sentarse =
	{
		{ block = "food", anim = "ff_Sit_eat1", time = -1 },
		{ block = "ped", anim = "seat_idle", time = -1 },
		{ block = "beach", anim = "parksit_m_loop", time = -1 },
		{ block = "beach", anim = "parksit_w_loop", time = -1 },
		{ block = "sunbathe", anim = "parksit_m_idlec", time = -1 },
		{ block = "sunbathe", anim = "parksit_w_idlea", time = -1 },
		{ { block = "attractors", anim = "stepsit_in", time = 1200 }, { block = "attractors", anim = "stepsit_loop", time = -1 } },
		{ block = "int_house", anim = "lou_loop", time = -1 },
		{ block = "int_office", anim = "off_sit_drink", time = -1 },
		{ block = "int_office", anim = "off_sit_idle_loop", time = -1 },
		{ block = "int_office", anim = "off_sit_read", time = -1 },
		{ block = "int_office", anim = "off_sit_type_loop", time = -1 },
		{ block = "int_office", anim = "off_sit_watch", time = -1 },
		{ block = "jst_buisness", anim = "girl_02", time = -1 },
	},
	fumar =
	{
		{ block = "lowrider", anim = "m_smkstnd_loop", time = -1 },
		{ block = "lowrider", anim = "m_smklean_loop", time = -1 },
		{ block = "lowrider", anim = "f_smklean_loop", time = -1 },
		{ block = "gangs", anim = "smkcig_prtl", time = -1 },
	},
	pensar =
	{
		{ block = "cop_ambient", anim = "coplook_think", time = -1 },
	},
	vomitar =
	{
		{ block = "food", anim = "eat_vomit_p", time = 7000 },
	},
	cansado =
	{
		{ block = "fat", anim = "idle_tired", time = -1 },
	},
	saludar =
	{
		{ block = "kissing", anim = "gfwave2", time = 2500 },
		{ block = "kissing", anim = "bd_gf_wave", time = 4000 },
	},
	si =
	{
		{ block = "gangs", anim = "invite_yes", time = 4000 },
	},
	control =
	{
		{ block = "police", anim = "CopTraf_Come", time = -1 },
		{ block = "police", anim = "CopTraf_Stop", time = -1 },
	},
	apuntar =
	{
		{ block = "police", anim = "COP_getoutcar_LHS", time = 4000 },
		{ block = "police", anim = "Cop_move_FWD", time = 4000 },
	},
	rendirse =
	{
		{ block = "police", anim = "crm_drgbst_01", time = 4000 },
		{ block = "ped", anim = "handsup", time = 4000 },
	},
	patada =
	{
		{ block = "police", anim = "Door_Kick", time = 4000 },
	},
	pelea =
	{
		{ block = "fight_B", anim = "FightB_1", time = 4000 },
		{ block = "fight_B", anim = "FightB_2", time = 4000 },
		{ block = "fight_B", anim = "FightB_3", time = 4000 },
		{ block = "fight_B", anim = "FightB_G", time = 4000 },
		{ block = "fight_B", anim = "FightB_IDLE", time = -1 },
		{ block = "fight_B", anim = "FightB_M", time = 4000 },
	},
	karate =
	{
		{ block = "FIGHT_C", anim = "FightC_1", time = 4000 },
		{ block = "FIGHT_C", anim = "FightC_2", time = 4000 },
		{ block = "FIGHT_C", anim = "FightC_3", time = 4000 },
		{ block = "FIGHT_C", anim = "FightC_G", time = 4000 },
		{ block = "FIGHT_C", anim = "FightC_IDLE", time = -1 },
		{ block = "FIGHT_C", anim = "FightC_M", time = 4000 },
	},
	callejero =
	{
		{ block = "FIGHT_D", anim = "FightD_1", time = 4000 },
		{ block = "FIGHT_D", anim = "FightD_2", time = 4000 },
		{ block = "FIGHT_D", anim = "FightD_3", time = 4000 },
		{ block = "FIGHT_D", anim = "FightD_block", time = 4000 },
		{ block = "FIGHT_D", anim = "FightD_G", time = 4000 },
		{ block = "FIGHT_D", anim = "FightD_IDLE", time = 4000 },
		{ block = "FIGHT_D", anim = "FightD_M", time = 4000 },
		{ block = "FIGHT_D", anim = "HitD_1", time = 4000 },
		{ block = "FIGHT_D", anim = "HitD_2", time = 4000 },
		{ block = "FIGHT_D", anim = "HitD_3", time = 4000 },
	},
	coche =
	{
		{ block = "ped", anim = "CAR_sitp", time = 4000 },
		{ block = "ped", anim = "CAR_LB", time = 4000 },
		{ block = "ped", anim = "endchat_01", time = 4000 },
		{ block = "ped", anim = "KART_drive", time = 4000 },
		{ block = "ped", anim = "tap_hand", time = 4000 },
		{ block = "ped", anim = "tap_handp", time = 4000 },
	},
	escuchar =
	{
		{ block = "bar", anim = "Barserve_order", time = 4000 },
	},
	gritar =
	{
		{ block = "riot", anim = "riot_shout", time = 4000 },
	},
	animar =
	{
		{ block = "riot", anim = "riot_challenge", time = -1 },
		{ block = "riot", anim = "riot_angry", time = -1 },
		{ block = "riot", anim = "riot_angry_b", time = -1 },
	}, 
	asustado =
	{
		{ block = "ped", anim = "cower", time = -1 },
		{ block = "ped", anim = "handscower", time = 4000 },
	},
}

local function stopAnim( player )
	if exports.players:isLoggedIn(player) and not getElementData(player, "tazed") == true and not getElementData(player, "accidente") == true and not getElementData(player, "muerto") == true and not getElementData(player, "sexbot") == true then
		setPedAnimation( player )
		removeElementData( player, "anim" )
	end
end
addCommandHandler( "stopanim", stopAnim )

local function setAnim( player, anim )
	if isElement( player ) and anim then
		setPedAnimation( player, anim.block, anim.anim, anim.time or -1, anim.loop == nil and anim.time == -1 or anim.loop or false, anim.updatePosition or false, false )
		setElementData( player, "anim", true )
	end
end

local function playAnim( player, anim )
	if exports.players:isLoggedIn(player) and not getElementData(player, "tazed") == true and not getElementData(player, "accidente") == true and not getElementData(player, "muerto") == true then
		local time = 0
		for key, value in ipairs( anim ) do
			if time == 0 then
				setAnim( player, value )
			else
				setTimer( setAnim, time, 1, player, value )
			end
			
			if value.time == -1 then
				time = 0
				break
			else
				time = time + value.time
			end
		end
	end
end

for key, value in pairs( anims ) do
	addCommandHandler( key,
		function( player, commandName, num )
			local anim = tonumber( num ) and value[ tonumber( num ) ] or value[ anim ] or #value == 0 and value or value[ 1 ]
				
			if #anim == 0 then
				anim = { anim }
			end
			playAnim( player, anim )
		end
	)
end

addEvent( "anims:reset", true )
addEventHandler( "anims:reset", root,
	function( )
		if client == source then
			stopAnim( source )
			removeElementData( source, "anim" )
		end
	end
)
  
function executeAnimation(block, anim, loop)
	if exports.players:isLoggedIn(source) and not getElementData(source, "tazed") == true and not getElementData(source, "accidente") == true and not getElementData(source, "muerto") == true then
		if loop then
			setPedAnimation( source, block, anim, -1, loop)
		else
			setPedAnimation( source, block, anim, 1, false )
		end
		setElementData( source, "anim", true )
	end
end
addEvent("AnimationSet",true)
addEventHandler("AnimationSet",getRootElement(), executeAnimation)

function bindearBarraStop()
	bindKey(source, "space", "down", stopAnim)
end
addEventHandler("onPlayerJoin", getRootElement(), bindearBarraStop)

function bindAlIniciarSistema()
	for k, v in ipairs(getElementsByType("player")) do
		bindKey(v, "space", "down", stopAnim)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), bindAlIniciarSistema)