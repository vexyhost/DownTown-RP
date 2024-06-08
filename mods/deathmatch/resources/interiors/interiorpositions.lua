--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 Downtown Roleplay -- V.1.1 BETA.
]]

-- Tipos de interiores definidos por clase.
interiorPositions =
{
	-- Casas Privadas Interiores --
	house1  = { x =   235.25, y =  1186.68, z = 1080.26, interior = 3, price = 50000 },
	house2  = { x =   226.79, y =  1240.02, z = 1082.14, interior = 2, price = 20000 },
	house3  = { x =   223.07, y =  1287.09, z = 1082.14, interior = 1, price = 13000 },
	house4  = { x =   327.94, y =  1477.73, z = 1084.44, interior = 15, price = 15000 },
	house5  = { x =  2468.84, y = -1698.29, z = 1013.51, interior = 2, price = 15000 },
	house6  = { x =  226.34, y = 1114.23, z = 1080.89, interior = 5, price = 65000 },
	house7  = { x =   387.23, y =  1471.79, z = 1080.19, interior = 15, price = 18000 },
	house8  = { x =   225.79, y =  1021.46, z = 1084.02, interior = 7, price = 150000 },
	house9  = { x =   295.16, y =  1472.26, z = 1080.26, interior = 15, price = 40000 },
	house10 = { x =  2807.58, y = -1174.75, z = 1025.57, interior = 8, price = 20000 },
	house11 = { x = 1298.95, y = -797.01, z = 1084.01, interior = 5, price = 350000 },
	house12 = { x =  2270.42, y = -1210.52, z = 1047.56, interior = 10, price = 30000 },
	house13 = { x =  2496.02, y = -1692.08, z = 1014.74, interior = 3, price = 30000 },
	house14 = { x =  387.22, y = 1471.75, z = 1080.18, interior = 15, price = 18000 },
	house15 = { x =  2365.21, y = -1135.60, z = 1050.88, interior = 8, price = 30000 },
	house16 = { x =  2807.68, y = -1174.57, z = 1025.57, interior = 8, price = 20000 },
	house17 = { x =  260.76, y = 1237.23, z = 1084.25, interior = 9, price = 15000 },
	house18 = { x =  2282.90, y = -1140.27, z = 1050.9, interior = 11, price = 10000 },
	house19 = { x =  2196.75, y = -1204.34, z = 1048.84, interior = 6, price = 35000 },
	house20 = { x =  2308.78, y = -1212.91, z = 1048.82, interior = 6, price = 6000 },
	house21 = { x =  2237.61, y = -1081.48, z = 1048.91, interior = 2, price = 25000 },
	house22 = { x =  2317.82, y = -1026.75, z = 1049.88, interior = 9, price = 60000 },
	house23 = { x =  260.98, y = 1284.40, z = 1080.08, interior = 4, price = 20000 },
	house24 = { x =  140.18, y = 1366.58, z = 1083.86, interior = 5, price = 170000 },
	house25 = { x =  82.95, y = 1322.38, z = 1083.48, interior = 9, price = 50000 },
	house26 = { x =  -42.56, y = 1405.64, z = 1084.60, interior = 8, price = 18000 },
	house27 = { x =  2333.03, y = -1077.22, z = 1048.86, interior = 6, price = 12000 },
	house28 = { x =  447.09, y = 1397.06, z = 1084.3, interior = 2, price = 40000 },
	house29 = { x =  2324.47, y = -1149.55, z = 1050.71, interior = 12, price = 90000 },
	house30 = { x =  234.06, y = 1063.72, z = 1084.21, interior = 6, price = 145000 },
	
	-- Habitaciones --
	room1 = { x = 243.71, y = 304.95, z = 999.14, interior = 1, price = 5000 }, -- Denise
	room2 = { x = 266.50, y = 305.01, z = 999.14, interior = 2, price = 8000 }, -- Katie
	room3 = { x =  2259.38, y = -1135.84, z = 1050.64, interior = 10, price = 7000 }, -- Es una habitacion
	room4 = { x =  2233.8, y = -1115.36, z = 1050.89, interior = 5, price = 7000 }, -- Es una habitacion
	room5 = { x =  2217.85, y = -1076.29, z = 1050.48, interior = 1, price = 12000 }, -- Es una habitacion
	room6 = { x = 343.71, y = 304.98, z = 999.14, interior = 6, price = 15000 }, -- Millie/Sex room
	
	-- Garajes Privados - - -
	garage1 =     { x =  608.15,  y = -10.09, z = 1000.91, interior = 1, price = 30000 },
	garage2 =     { x =  612.4, y = -76.48, z = 997.99, interior = 2, price = 7000 },
	garage3 =     { x =  612.11, y = -125.25, z = 997.99, interior = 3, price = 5000 },
	garage4 =    { x =  -2022.79, y = -116.29, z = 1039.2, interior = 26, price = 9000 },
	garage5 =    { x =  502.46, y = -112.07, z = 1005.82, interior = 15, price = 15000 },
	
	-- Oficinas --
	
	office1 =     { x = -2026.86, y =  -103.60, z = 1035.18, interior = 3, price = 0 }, -- Driving School
	office2 =     { x =  1494.36, y =  1303.57, z = 1093.28, interior = 3, price = 0 }, -- Bike School
	
	-- Negocios --
	-- Bares--
	local1 =         { x = 501.99, y =  -67.56, z =  998.75, interior = 11, price = 60000 },
	local2 =        { x = -229.3, y = 1401.28, z =   27.76, interior = 18, price = 50000 },
	local3 =        { x = 681.44, y = -450.21, z =   -25.77, interior = 1, price = 50000 },
	local4 =        { x = -199.02, y = 1119.87, z = 225.94, interior = 36, price = 55000 },
	local5 = { x =  1681.71, y = 256.02, z = 7094.75, interior = 18, price = 90000 },
	-- Restaurantes --
	local6 =  { x = 363.84, y =  -74.13, z = 1001.50, interior = 10, price = 75000 },
	local7 = { x = 364.98, y = -11.84, z = 1001.85, interior = 9, price = 65000 },
	local8      =  { x = 460.53, y =  -88.62, z =  999.55, interior = 4, price = 50000 },
	local9 =       { x =   372.33, y =  -133.52, z = 1001.49, interior = 5, price = 75000 },
	local10      =  { x = 377.08, y = -193.30, z = 1000.63, interior = 17, price = 50000 },
	-- Tiendas de ropa --
	local11 =    { x = 204.32, y = -168.85, z = 1000.52, interior = 14, price = 90000 }, -- Pro Laps
	local12 =    { x = 207.07, y = -140.37, z = 1003.51, interior = 3, price = 90000 }, -- Didier Sachs
	local13 =    { x = 203.81, y =  -50.66, z = 1001.80, interior = 1, price = 90000 }, -- Suburban
	local14 =    { x = 227.56, y =   -8.06, z = 1002.21, interior = 5, price = 90000 }, -- Victim
	local15 =    { x = 161.37, y =  -97.11, z = 1001.80, interior = 18, price = 90000 }, -- Zip
	local16 =    { x = 207.63, y = -111.26, z = 1005.13, interior = 15, price = 90000 }, -- Binco
	-- Otros --
	local17 = { x = -2240.77, y = 137.20, z = 1035.41, interior = 6, price = 120000 },
	local18 =        { x = 493.50, y =  -24.95, z = 1000.67, interior = 17, price = 120000 },
	local19 =       { x =  -2636.66, y =   1402.36, z = 906.50, interior = 3, price = 180000 },
	local20 =     { x =   390.76, y =   173.79, z = 1008.38, interior = 3, price = 250000 }, -- City Planning Department
	local21 = { x = 322.18, y = 302.35, z = 999.14, interior = 5, price = 150000 }, -- Barbara, some PD stuff
	
	
	
	
	
	
	-- Industriales
	container = { x = -1288.84045, y = -61.50443, z = 14.15341, interior = 12, price = 0 },

	--bombero = { x = -1329.55261, y = -107.04150, z = 14.25156, interior = 15, price = 0 },

    -- Policiales - -
	armeria = { x = 1581.28796, y = 1318.36426, z = 10.97289, interior = 18, price = 0 },
	interrogatorios = { x = -1330.49438, y = -248.23068, z = -11.54646, interior = 23},
	carcel = { x = 325.94, y =  2031.23, z = -15.89, interior = 3, price = 0 },
	lspd = { x = 246.75, y =  62.32, z = 1003.64, interior = 6, price = 0 },
	sfpd = { x = 246.35, y = 107.30, z = 1003.22, interior = 10, price = 0 },
	lvpd = { x = 238.72, y = 138.62, z = 1003.02, interior = 3, price = 0 },
	
	['24/7-2'] =  { x = -25.89, y = -188.24, z = 1003.54, interior = 17, price = 0 },
	['24/7-2'] =  { x =   6.11, y =  -31.75, z = 1003.54, interior = 10, price = 0 },
	['24/7-3'] =  { x = -25.89, y = -188.24, z = 1003.54, interior = 17, price = 0 },
	['24/7-4'] =  { x = -25.77, y = -141.55, z = 1003.55, interior = 16, price = 0 },
	['24/7-5'] =  { x = -27.30, y =  -31.76, z = 1003.56, interior = 4, price = 0 },
	['24/7-6'] =  { x = -27.34, y =  -58.26, z = 1003.55, interior = 6, price = 0 },
	ammunation1 = { x = 285.50, y =  -41.80, z = 1001.52, interior = 1, blip = 6, price = 0 },
	ammunation2 = { x = 285.87, y =  -86.78, z = 1001.52, interior = 4, blip = 6, price = 0 }, 
	ammunation3 = { x = 296.84, y = -112.06, z = 1001.52, interior = 6, blip = 6, price = 0 },
	ammunation4 = { x = 315.70, y = -143.66, z =  999.60, interior = 7, blip = 6, price = 0 },
	ammunation5 = { x = 316.32, y = -170.30, z =  999.60, interior = 6, blip = 6, price = 0 },
	atrium =      { x = 1727.04, y = -1637.84, z = 20.22, interior = 18, price = 0 },
	
	

	meatfactory = { x = 964.93, y = 2160.09, z = 1011.03, interior = 1, price = 0 },
	sexshop =     { x =  -100.34, y =   -25.03, z = 1000.72, interior = 3, price = 0 },
	strip =       { x =  1204.67, y =  -13.84,  z = 1000.92, interior = 2, price = 0 },
	strip2 =      { x = 1212.12, y = -26.14, z =   1000.99, interior = 3, price = 0 },
	strip3 =      { x = 964.106994, y =  -53.205497, z = 1001.124572, interior = 3, price = 0 },
	strip4 =      { x = 1204.809936, y =  13.897239, z = 1000.921875, interior = 2, price = 0 },
	strip5 =      { x =  744.44, y = 1436.33,  z = 1102.7, interior = 6},
	reeces =      { x =  412, y =   -23, z = 1002, interior = 2, price = 0 },
	barber =      { x =  418.6, y =   -84.17, z = 1001.70, interior = 3, price = 0 },
	tattoo =      { x =  -204.37, y =   -8.90, z = 1002.26, interior = 17, price = 0 },
	factory =     { x =  2541.71, y =   -1304.07, z = 1025.08, interior = 2, price = 0 },
	battlefield = { x =  -977.72, y =   1052.96, z = 1345.22, interior = 10, price = 0 },
	hallway =     { x =  2266.05, y =   1648.2, z = 1084.23, interior = 1, price = 0 },
	betting =     { x =  834.78, y =   7.42, z = 1003.97, interior = 3, price = 0 },
	betting2 =    { x =  -2158.58, y =   643.15, z = 1052.33, interior = 1, price = 0 },
	motel =       { x =  2214.42, y =   -1150.51, z = 1025.41, interior = 15, price = 0 },
	gym =         { x =  773.57, y =   -78.12, z = 1000.88, interior = 7, price = 0 },
	gym2 =        { x =  772.11, y =   -5, z = 1000.42, interior = 5, price = 0 },
	gym3 =        { x =  774.18, y =   -50.42, z = 1000.60, interior = 6, price = 0 },
	gym4 =        { x = 3023.06, y = -3244.12, z = 37.58, interior = 10, price = 0 },
	gym5 =        { x = -1325.3759765625, y = -41.9501953125, z = 14.16562461853, interior = 14, price = 0 },
	sex =         { x =  -100.33, y =   -24.94, z = 1000.33, interior = 3, price = 0 },
	stadium =     { x =  -1426.14, y =   928.44, z = 1036.35, interior = 15, price = 0 },
	stadium2 =    { x =  -1426.13, y =   44.16, z = 1036.23, interior = 1, price = 0 },
	stadium3 =    { x =  -1464.72, y =   1555.93, z = 1052.68, interior = 14, price = 0 },
    
	-- Especiales --
	crack =       { x =  2543.46, y =   -1308.38, z = 1026.73, interior = 2, price = 0 },
	andromada =   { x =  315.9, y =   985.08, z = 1958.89, interior = 9, price = 0 },
	shamal =      { x =  3.01, y =   33.15, z = 1199.59, interior = 1, price = 0 },
	casino2 =     { x =  1133.12, y = -15.83, z = 1000.67, interior = 12},
	casino3 =     { x =  2019.07, y = 1017.84, z = 996.87, interior = 10},
	casino4 =     { x =  1221.23, y = 291.45, z = -27.83, interior = 17},
	woozie =      { x = -2158.68, y = 643.14, z = 1052.37, interior = 1},
	wardrobe =    { x =  254.17,  y = -41.58, z = 1002.03, interior = 14},
	storage =     { x =  301.81, y = 300.38, z = 999.14, interior = 4},
	almacen =     { x =  973.24, y = 2073.17, z = 10.86, interior = 35},
	warehouse =   { x =  1292.62, y = -0.69, z = 1001.01, interior = 18},
	journey =     { x =  2.05, y = -3.11, z = 999.42, interior = 3},
	sacf =        { x =  -3943.45, y = 886.01, z = 4.5, interior = 0},
	zulo =        { x =  4322.83, y = -1797.04, z = 33.6, interior = 16},
	labdrogas =   { x =  4323.74, y = 220.37, z = 8.81, interior = 4},
	vestidor =   { x =  1732.48, y = 233.62, z = 7101.41, interior = 18},
	pasillo =   { x =  1656.17, y =  230.58, z = 7094.75, interior = 18},
	dormitorio =   { x =  1731.38, y =  256.69, z = 7106.42, interior = 18},
	perrera =   { x =  -1624.88, y =  -634.4, z = 15.04, interior = 6},
	
	-- Mapeados de facciones --
	ayuntamiento =        { x = 595.89, y = -19.83, z = -40.27, interior = 3},
	hospital =        { x = -286.04, y = 1056.26, z = 508.42, interior = 5, price = 0 },
	radio =        { x =  1368.5703125, y = 436.5205078125, z = -51.092185974121, interior = 3},
	radio2 =        { x =  3728.703125, y = -1683.7919921875, z = 584.06872558594, interior = 3},
	repartos  = { x = -1231.05, y =  -26.91, z = 14.22, interior = 1, price = 0 },
	oficina = { x = -1308.5068359375, y = -11.51171875, z = 14.21875, interior = 3},
	discoteca = { x =  -1356.1416015625, y = -32.5654296875, z = 14.307812690735, interior = 3},
	banco = { x =  1755.943359375, y = -2587.6298828125, z = 66.51831817627, interior = 3},
	banco2 = { x = -296.63494873047, y = 1482.3851318359, z = 1071.1059570312, interior = 14},
	sd = { x =  2301.6689453125, y = 2497.818359375, z = 3.2734375, interior = 0}, 
	iglesia = { x = 387.47641, y = 2324.33154, z = 1889.58337, interior = 3},
	pdint = { x = 2002.89, y = 1954.29, z = -14.13, interior = 6},
	pdint2 = { x = 1523.07, y = 1565.08, z = -11.02, interior = 10},
	corte = { x = 1695.49, y = -2519.19, z = 44.53, interior = 3},        
	clubmotero = { x = 2584.73, y = -2445.97, z = 13.7, interior = 3, price = 0 },
}