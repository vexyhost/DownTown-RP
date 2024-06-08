local precios = {
{m = "Admiral", p = 40000, c = 4, vip = false},
{m = "Alpha", p = 77000, c = 2, vip = false},
{m = "Bandito", p = 35000, c = 8, vip = false},
{m = "Banshee", p = 118000, c = 2, vip = false},
{m = "BF-400", p = 10000, c = 9, vip = false},
{m = "BF Injection", p = 45000, c = 8, vip = false},
{m = "Bike", p = 1200, c = 10, vip = false},
{m = "Blade", p = 45000, c = 4, vip = false},
{m = "Blista Compact", p = 40000, c = 5, vip = false},
{m = "BMX", p = 1450, c = 10, vip = false},
{m = "Bobcat", p = 22000, c = 7, vip = false},
{m = "Bravura", p = 10000, c = 5, vip = false},
{m = "Broadway", p = 18000, c = 5, vip = false},
{m = "Buccaneer", p = 45000, c = 4, vip = false},
{m = "Buffalo", p = 88000, c = 2, vip = false},
{m = "Bullet", p = 100000, c = 2, vip = false},
{m = "Burrito", p = 30000, c = 7, vip = false},
{m = "Camper", p = 16000, c = 7, vip = false},
{m = "Cadrona", p = 25000, c = 5, vip = false},
{m = "Cheetah", p = 99000, c = 2, vip = false},
{m = "Clover", p = 21000, c = 5, vip = false},
{m = "Club", p = 26000, c = 5, vip = false},
{m = "Comet", p = 109000, c = 2, vip = false},
{m = "Dinghy", p = 15000, c = 11, vip = false},
{m = "Elegant", p = 48000, c = 4, vip = false},
{m = "Elegy", p = 75000, c = 2, vip = false},
{m = "Emperor", p = 48000, c = 4, vip = false},
{m = "Esperanto", p = 39000, c = 4, vip = false},
{m = "Euros", p = 83000, c = 2, vip = false},
{m = "FCR-900", p = 16000, c = 9, vip = false},
{m = "Faggio", p = 2500, c = 1, vip = false},
{m = "Feltzer", p = 49000, c = 4, vip = false},
{m = "Flash", p = 76000, c = 2, vip = false},
{m = "Fortune", p = 18000, c = 5, vip = false},
{m = "Freeway", p = 12000, c = 9, vip = false},
{m = "Glendale", p = 8000, c = 1, vip = false},
{m = "Greenwood", p = 35000, c = 4, vip = false},
{m = "Hermes", p = 16000, c = 5, vip = false},
{m = "Huntley", p = 40000, c = 6, vip = false},
{m = "Hustler", p = 60000, c = 2, vip = false},
{m = "Intruder", p = 31000, c = 4, vip = false},  
{m = "Jester", p = 73000, c = 2, vip = false},
{m = "Jetmax", p = 400000, c = 11, vip = false},
{m = "Journey", p = 25000, c = 6, vip = false},
{m = "Landstalker", p = 25000, c = 6, vip = false},
{m = "Majestic", p = 38000, c = 4, vip = false},
{m = "Manana", p = 5500, c = 1, vip = false},
{m = "Marquis", p = 500000, c = 11, vip = false},
{m = "Maverick", p = 800000, c = 12, vip = false},
{m = "Merit", p = 35000, c = 4, vip = false},
{m = "Mesa", p = 35000, c = 6, vip = false},
{m = "Moonbeam", p = 15000, c = 7, vip = false},
{m = "Mountain Bike", p = 1800, c = 10, vip = false},
{m = "Nebula", p = 38000, c = 4, vip = false},
{m = "NRG-500", p = 80000, c = 2, vip = false},
{m = "Oceanic", p = 36000, c = 4, vip = false},
{m = "PCJ-600", p = 12000, c = 9, vip = false},
{m = "Perennial", p = 30000, c = 3, vip = false},
{m = "Phoenix", p = 72000, c = 2, vip = false},
{m = "Picador", p = 18000, c = 7, vip = false},
{m = "Pony", p = 15000, c = 7, vip = false},
{m = "Premier", p = 42000, c = 4, vip = false},
{m = "Primo", p = 40000, c = 4, vip = false},
{m = "Quadbike", p = 20000, c = 8, vip = false},
{m = "Rancher", p = 30000, c = 6, vip = false},
{m = "Regina", p = 27000, c = 3, vip = false},
{m = "Remington", p = 32000, c = 4, vip = false},
{m = "Rumpo", p = 22000, c = 7, vip = false},
{m = "Sandking", p = 75000, c = 6, vip = false},
{m = "Sabre", p = 72000, c = 2, vip = false},
{m = "Sadler", p = 5500, c = 1, vip = false},
{m = "Sanchez", p = 40000, c = 8, vip = false},
{m = "Savanna", p = 35000, c = 4, vip = false},
{m = "Sentinel", p = 43500, c = 4, vip = false},
{m = "Slamvan", p = 30000, c = 4, vip = false},
{m = "Solair", p = 40000, c = 3, vip = false},
{m = "Sparrow", p = 600000, c = 12, vip = false},
{m = "Stafford", p = 44000, c = 4, vip = false},
{m = "Stallion", p = 32000, c = 5, vip = false},
{m = "Stratum", p = 50000, c = 3, vip = false},
{m = "Squalo", p = 380000, c = 11, vip = false},
{m = "Sultan", p = 87000, c = 2, vip = false},
{m = "Super GT", p = 95000, c = 2, vip = false},
{m = "Sunrise", p = 56000, c = 2, vip = false},
{m = "Tahoma", p = 32000, c = 4, vip = false},
{m = "Tampa", p = 6000, c = 1, vip = false},
{m = "Tornado", p = 45000, c = 4, vip = false},
{m = "Tropic", p = 480000, c = 11, vip = false},
{m = "Turismo", p = 140000, c = 2, vip = false},
{m = "Infernus", p = 200000, c = 2, vip = false},
{m = "Uranus", p = 70000, c = 2, vip = false},
{m = "Vincent", p = 39000, c = 4, vip = false},
{m = "Voodoo", p = 45000, c = 4, vip = false},
{m = "Washington", p = 40000, c = 4, vip = false},
{m = "Wayfarer", p = 13000, c = 9, vip = false},
{m = "Windsor", p = 64000, c = 2, vip = false},
{m = "Willard", p = 32000, c = 4, vip = false},
{m = "Yosemite", p = 30000, c = 7, vip = false},
{m = "ZR-350", p = 90000, c = 2, vip = false},
}

function getDatos()
	return precios
end	

function getPrecioFromModel(model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return v.p
			end	
		end
	end
end

function getClaseFromModel(model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return v.c
			end	
		end
	end
end

function isModelVIP (model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return v.vip
			end
		end
	end
end

function getCosteRenovacionFromModel(model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return math.floor(v.p*0.1667)
			end
		end
	end
end