skinTable = 
{
	[1] = {normal=41, naked=272},
	[2] = {normal=93, naked=293}, 
	[3] = {normal=69, naked=291}, 
	[4] = {normal=40, naked=271}, 
	[5] = {normal=251, naked=296}, 
	[6] = {normal=92, naked=297}, 
	[7] = {normal=91, naked=298}, 
	[8] = {normal=148, naked=266}, 
	[9] = {normal=13, naked=267}, 
	[10] = {normal=131, naked=268}, 
	[11] = {normal=64, naked=270}, 
	[12] = {normal=238, naked=290}, 
	[13] = {normal=69, naked=291}, 
	[14] = {normal=237, naked=292}, 
	[15] = {normal=85, naked=294}, 
	[16] = {normal=211, naked=295}, 
	[17] = {normal=307, naked=299}, --not skin 
	[18] = {normal=191, naked=300}, 
	[19] = {normal=307, naked=301},  --not skin 
	[20] = {normal=190, naked=302},  
	[21] = {normal=192, naked=303},  
	[22] = {normal=193, naked=304}
}

function getSkinsNumbers (thePlayer)
	for k, skins in ipairs (skinTable) do
		outputChatBox ("( "..(skins.normal)..", "..(skinTable[k+1].normal)..", "..(skinTable[k+2].normal)..", "..(skinTable[k+3].normal)..", "..(skinTable[k+4].normal).." )", thePlayer, 0, 255, 0)
		outputChatBox ("( "..(skinTable[k+5].normal)..", "..(skinTable[k+6].normal)..", "..(skinTable[k+7].normal)..", "..(skinTable[k+8].normal)..", "..(skinTable[k+9].normal).." )", thePlayer, 0, 255, 0)
		outputChatBox ("( "..(skinTable[k+10].normal)..", "..(skinTable[k+11].normal)..", "..(skinTable[k+12].normal)..", "..(skinTable[k+13].normal)..", "..(skinTable[k+14].normal).." )", thePlayer, 0, 255, 0)
		outputChatBox ("( "..(skinTable[k+15].normal)..", "..(skinTable[k+16].normal)..", "..(skinTable[k+17].normal)..", "..(skinTable[k+18].normal)..", "..(skinTable[k+19].normal).." )", thePlayer, 0, 255, 0)
		outputChatBox ("( "..(skinTable[k+20].normal).." )", thePlayer, 0, 255, 0)
		break
	end
end
--addCommandHandler ("hs", getSkinsNumbers)