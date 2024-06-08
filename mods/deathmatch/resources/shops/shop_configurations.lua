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

shop_configurations =
{
    burger =
    {
        name = "Hamburguesería",
        skin = 205,
        { itemID = 3, itemValue = 10, name = "Pequeño", description = "Contiene las patatas fritas, el menú de pollo y una lata de bebida Sprunk.", price = 2 },
        { itemID = 3, itemValue = 30, name = "Grande", description = "Contiene las patatas fritas, una hamburguesa, a Fowl Wrap y una lata de bebida sprunk.", price = 5 },
        { itemID = 3, itemValue = 55, name = "ExtraGrande", description = "Contiene las patatas fritas, doble hamburguesa, a Wing Pieces y una lata de bebida sprunk.", price = 10 },
        { itemID = 3, itemValue = 40, name = "Salad Meal", description = "Contiene un plato de ensalada, Fowl Wraps, una inmersión y una lata de Sprunk.", price = 10 },
        { itemID = 4, itemValue = 30, name = "Sprunk", description = "Una lata de una deliciosa bebida sprunk.", price = 5 },
        { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 3 },
		{ itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 20 },
    },
    cafe =
    {
        name = "Cafetería",
        skin = 250,
        { itemID = 3, itemValue = 10, name = "Pizza Combo", description = "Un menú de patatas fritas y un trozo de pizza acompa�ado de una spunk.", price = 4 },
        { itemID = 3, itemValue = 30, name = "Burger Combo", description = "Contiene las patatas fritas, una hamburguesa, a Fowl Wrap and a can of Sprunk.", price = 5 },
        { itemID = 3, itemValue = 30, name = "Beef Combo", description = "Contains french fries, a Serloin Steak, a Fowl Wrap and a can of Sprunk.", price = 5 },
        { itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 20 },
		{ itemID = 4, itemValue = 30, name = "Sprunk", description = "Una lata de una deliciosa bebida sprunk.", price = 5 },
        { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 3 },
    }, 
    restaurante =
    {
        name = "Restaurante",
        skin = 168,
        { itemID = 3, itemValue = 10, name = "Pizza Combo", description = "Contiene las patatas fritas, una rebanada de pizza y una lata de Sprunk.", price = 12 },
        { itemID = 3, itemValue = 30, name = "Burger Combo", description = "Contiene las patatas fritas, un filete de hamburguesa, un abrigo de aves y una lata de Sprunk.", price = 10 },
        { itemID = 3, itemValue = 30, name = "Beef Combo", description = "Contiene las patatas fritas, un bistec de solomillo, a Wrap Fowl y una lata de Sprunk.", price = 10 },
        { itemID = 3, itemValue = 40, name = "Salad Meal", description = "Contiene un plato de ensalada, Fowl Wraps, una inmersión y una lata de Sprunk.", price = 10 },
		{ itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 3 },
		{ itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 20 },
		{ itemID = 10, itemValue = 20, name = "Vino", description = "Un buen vino de reserva.", price = 6 },
		{ itemID = 10, itemValue = 30, name = "Champan", description = "Champán de la mejor calidad.", price = 20 },
    },
    pizza =
    {
        name = "Pizzeria",
        skin = 155,
        { itemID = 3, itemValue = 10, name = "Buster", description = "Contiene las patatas fritas, una rebanada de pizza y una lata de Sprunk.", price = 3 },
        { itemID = 3, itemValue = 30, name = "Double D-Luxe", description = "Contiene las patatas fritas, una rebanada de pizza, una ensalada con pechuga de pollo y una lata de Sprunk.", price = 5 },
        { itemID = 3, itemValue = 50, name = "Full Rack", description = "Contiene las patatas fritas, una pizza y una lata de Sprunk.", price = 10 },
        { itemID = 3, itemValue = 70, name = "Large Salad Meal", description = "Contiene un gran plato de ensalada y una lata de Sprunk.", price = 10 },
        { itemID = 4, itemValue = 30, name = "Sprunk", description = "Una lata de esta deliciosa Sprunk.", price = 5 },
        { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de monta�a.", price = 3 },
		{ itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 20 },
    },
    hotdogs =
    {
        name = "Vendedor de perritos",
        skin = 168,
        { itemID = 3, itemValue = 15, name = "Hotdog", description = "Un delicioso perrito caliente.", price = 4 },
    },
	registro =
    {
        name = "Registro Civil",
        skin = 59,
        { itemID = 16, itemValue = 1, name = "D.N.I", description = "Documento Nacional de Identidad", price = 11 },
    },
    restauranteasiatico =
    {
        name = "Vendedor de comida asiática",
        skin = 168,
        { itemID = 3, itemValue = 20, name = "Ramen", description = "Comida japonesa, que bien sienta.", price = 2 },
    },
    helados =
    {
        name = "Vendedor de helados",
        skin = 168,
        { itemID = 3, itemValue = 10, name = "Chocolate", description = "Delicioso helado de chocolate.", price = 1 },
		{ itemID = 3, itemValue = 10, name = "Fresa", description = "Delicioso helado de fresa.", price = 1 },
		{ itemID = 3, itemValue = 10, name = "Vainilla", description = "Delicioso helado de vainilla.", price = 1 },
    },
    electronica =
    {
        name = "Electrónica",   
        skin = 217,
        { itemID = 28, itemValue = 2, name = "Telefono Movil", description = "Con él podrás llamar y escribir sms, utilizando la cobertura de San Fierro", price = 45 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 25 },
		{ itemID = 32, itemValue = 0, name = "Walkie", description = "Podrás hablar con quien quieras, ¡y cambiando de frecuencia!", price = 50 },
		{ itemID = 33, itemValue = 1, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 40 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 150 },
   },
    bar =
	{
		name = "Bar",
		skin = 40,
		{ itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 20 },
		{ itemID = 10, itemValue = 15, name = "Cerveza", description = "Cerveza de barril.", price = 3 },
		{ itemID = 10, itemValue = 20, name = "Vino", description = "Un buen vino de reserva.", price = 6 },
		{ itemID = 10, itemValue = 30, name = "Licor", description = "Un licor moderno, azucarado.", price = 10 },
		{ itemID = 10, itemValue = 50, name = "Wisky", description = "Gran Reserva 1970.", price = 15 },
		{ itemID = 10, itemValue = 30, name = "Champan", description = "Champán de la mejor calidad.", price = 20 },
		{ itemID = 10, itemValue = 80, name = "Ron", description = "Ron-Cola, delicioso.", price = 25 },
		{ itemID = 10, itemValue = 90, name = "Scocht", description = "Un licor moderno, amargo.", price = 30 },
		{ itemID = 4, itemValue = 20, name = "Agua", description = "Una botella llena de refrescante agua.", price = 3 },
        
	},
	cascos =
	{
		name = "Cascos",
		skin = 211,
		{ itemID = 11, itemValue = 2053, name = "Casco 1", description = "Casco deportivo para moto.", price = 65 },
		{ itemID = 11, itemValue = 2052, name = "Casco 2", description = "Casco deportivo para moto.", price = 65 },
		{ itemID = 11, itemValue = 2054, name = "Casco 3", description = "Casco deportivo para moto.", price = 65 },
		{ itemID = 11, itemValue = 3011, name = "Casco 4", description = "Casco deportivo para moto.", price = 65 },
		{ itemID = 11, itemValue = 1248, name = "Casco 5", description = "Casco deportivo para moto.", price = 65 },
		{ itemID = 11, itemValue = 1310, name = "Casco 6", description = "Casco deportivo para moto.", price = 65 },
		{ itemID = 11, itemValue = 2908, name = "Casco 7", description = "Casco deportivo para moto.", price = 65 }, 
	},
	mochilas =
	{
		name = "Compañía de mochilas",
		skin = 211,
		{ itemID = 12, itemValue = 2081, name = "small", description = "Buena para las mini excursiones.", price = 24 },
		{ itemID = 12, itemValue = 2082, name = "alice", description = "Buena para almacenar cosas ahí.", price = 55 },
		{ itemID = 12, itemValue = 2083, name = "czech", description = "Perfecta para ir de camping por los montes.", price = 70 },
		{ itemID = 12, itemValue = 2084, name = "coyote", description = "Genial para perderte en el desierto 1 año.", price = 120 },
	},
	estanco =
	{
		name = "Estanco",
		skin = 30,
		{ itemID = 14, itemValue = 21, name = "Paquete de Cigarros", description = "Un paquete con 20 cigarrillos Lucky Strike .", price = 45 },
	    { itemID = 26, itemValue = 50, name = "Mechero", description = "Si quieres fumar, ten asegurado que ésto te hará falta.", price = 2 },
		{ itemID = 33, itemValue = 0, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 40 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 25 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 150 },
	},
	ferreteria =
	{
		name = "Ferreteria",
		skin = 30,
		{ itemID = 13, itemValue = 1, name = "Copiador de llave", description = "Un ticket para copiar una llave!", price = 300 },
		{ itemID = 42, itemValue = 1, name = "Cerradura", description = "¿Qué? ¿Que alguien tiene copia de la llave de tu casa? Cómpra esta cerradura YA.", price = 400 },
		{ itemID = 25, itemValue = 1, name = "Linterna", description = "Para poder alumbrar tu camino.", price = 25 },
		{ itemID = 32, itemValue = 0, name = "Walkie", description = "Podrás hablar con quien quieras, ¡y cambiando de frecuencia!", price = 50 },
		{ itemID = 33, itemValue = 0, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 40 },
		{ itemID = 9, itemValue = 1, name = "Reloj", description = "Un bonito reloj de pulsera. Sin él, no podrás ver la hora.", price = 25 },
		{ itemID = 29, itemValue = 43, itemValue2 = 100, name = "Camara de Fotos", description = "¿Quieres sacar fotos? ¡A que esperas para comprarla!", price = 150 },
	},
    gasolinera =
    {
        name = "Gasolinera",
        skin = 128,
        { itemID = 44, itemValue = 0, name = "Bidón Gasolina (Vacio)", description = "¿Te vas a quedar tirado? pues compra un bidón y rellenalo", price = 35 },
		{ itemID = 4, itemValue = 1001, name = "Cafe", description = "Un delicioso café que te quitará gran parte del sueño.", price = 20 },
		{ itemID = 4, itemValue = 30, name = "Sprunk", description = "Una lata de una deliciosa bebida sprunk.", price = 5 },
        { itemID = 4, itemValue = 20, name = "Agua", description = "Una botella de agua cristalina de montaña.", price = 3 },
		{ itemID = 33, itemValue = 1, name = "Loteria", description = "¡Con este cupón pueden tocarte 200 dólares!", price = 40 },
		{ itemID = 14, itemValue = 21, name = "Paquete de Cigarros", description = "Un paquete con 20 cigarrillos Lucky Strike .", price = 45 },
	    { itemID = 26, itemValue = 50, name = "Mechero", description = "Si quieres fumar, ten asegurado que ésto te hará falta.", price = 2 },
   },
	supermercado =
	{
		name = "Supermercado",
		skin = 192,
		{ itemID = 6, itemValue = 0, name = "Pan", description = "¿Quieres comprar pan para hacer un bocadillo?", price = 1 },
		{ itemID = 6, itemValue = 1, name = "Pizza Jamon y Queso", description = "Si tienes prisa y necesitas comer rapido.", price = 8 },
		{ itemID = 6, itemValue = 2, name = "Pizza 5 quesos", description = "Si tienes prisa y necesitas comer rapido.", price = 8 },
		{ itemID = 6, itemValue = 3, name = "Pizza Barbacoa", description = "Si tienes prisa y necesitas comer rapido.", price = 8 },
		{ itemID = 6, itemValue = 4, name = "Salchichón", description = "¡Ingrediente esencial para un buen bocadillo!", price = 5 },
		{ itemID = 6, itemValue = 5, name = "Mortadela", description = "¡Ingrediente esencial para un buen bocadillo!", price = 6 },
		{ itemID = 6, itemValue = 6, name = "Tomates", description = "Si quieres hacer una ensalada o en el bocadillo.", price = 12 },
		{ itemID = 6, itemValue = 7, name = "Costillas", description = "Un buen asado o una barbacoa que podrías hacerte.", price = 25 },
		{ itemID = 6, itemValue = 8, name = "Carne Picada", description = "¿Quieres hacerte unas hamburguesas?.", price = 20 },
		{ itemID = 6, itemValue = 9, name = "Jamon Serrano", description = "¡Ingrediente esencial para un buen bocadillo!", price = 21 },
		{ itemID = 6, itemValue = 10, name = "Pepino", description = "Ingrediente estrella para las comidas.", price = 3 },
		{ itemID = 6, itemValue = 11, name = "Limon", description = "Ingrediente estrella para las comidas.", price = 3 },
		{ itemID = 6, itemValue = 12, name = "Arroz", description = "Compra paquetes de arroz y hazte una paella.", price = 40 },
		{ itemID = 6, itemValue = 13, name = "Lechuga", description = "Si quieres hacerte una ensalada.", price = 5 },
		{ itemID = 6, itemValue = 14, name = "Aceite (Virgen Extra)", description = "Esencial para poder hacer de comer.", price = 10 },
	},
    ilegal =
    {
        name = "Vendedor Callejero",
        skin = 21,
		nivel = 3,
        { itemID = 24, itemValue = 1, name = "Bandana", description = "¿No quieres que te vean el careto?.", price = 120 },
		{ itemID = 29, itemValue = 15, name = "Palanca", description = "¿Necesitas abrir algo colega?.", price = 200 },
        { itemID = 29, itemValue = 4, itemValue2 = 1, name = "Cuchillo", description = "¿Quieres rajar alguien loco?", price = 350 },
	    { itemID = 29, itemValue = 41, itemValue2 = 1000, name = "Spray", description = "¿Te van los graffitis?.", price = 160 },
		{ itemID = 29, itemValue = 6, itemValue2 = 1, name = "Pala", description = "¿Quieres desenterrar tesoros? ¿O enterrar algún cadáver?", price = 320 },
		{ itemID = 29, itemValue = 5, itemValue2 = 1, name = "Bate de Beisbol", description = "¿Quieres defenderte tio?", price = 300 },
	}, 
	armas =
    {
        name = "Armas",
        skin = 21,             
		nivel = 14,
	    { itemID = 29, itemValue = 22, itemValue2 = 1, name = "Colt 45", description = "Creo que este artículo no necesita una descripción.", price = 2000 },
		{ itemID = 29, itemValue = 23, itemValue2 = 1, name = "Colt 45 (Silenced)", description = "Creo que este artículo no necesita una descripción.", price = 4000 },
		{ itemID = 29, itemValue = 25, itemValue2 = 1, name = "Escopeta", description = "Creo que este artículo no necesita una descripción.", price = 1500 },
		{ itemID = 29, itemValue = 28, itemValue2 = 1, name = "Uzi", description = "Creo que este artículo no necesita una descripción.", price = 3000 },
		{ itemID = 29, itemValue = 30, itemValue2 = 1, name = "AK-47", description = "Creo que este artículo no necesita una descripción.", price = 5000 },
		{ itemID = 43, itemValue = 22, itemValue2 = 1, name = "Cargador Colt 45", description = "Un arma sin cargador, es como no tener nada.", price = 50 },
		{ itemID = 43, itemValue = 23, itemValue2 = 1, name = "Cargador Colt 45 (Silenced)", description = "Un arma sin cargador, es como no tener nada.", price = 100 },
		{ itemID = 43, itemValue = 25, itemValue2 = 1, name = "Cargador Escopeta", description = "Un arma sin cargador, es como no tener nada.", price = 15 },
		{ itemID = 43, itemValue = 28, itemValue2 = 1, name = "Cargador Uzi", description = "Un arma sin cargador, es como no tener nada.", price = 100 },
		{ itemID = 43, itemValue = 30, itemValue2 = 1, name = "Cargador AK-47", description = "Un arma sin cargador, es como no tener nada.", price = 150 },
	},
	armas_evento =
    {
        name = "Armas Evento",
        skin = 21,             
	    { itemID = 29, itemValue = 32, itemValue2 = 1, name = "Tec 9 (EVENTO)", description = "Creo que este artículo no necesita una descripción.", price = 0 },
		{ itemID = 29, itemValue = 33, itemValue2 = 1, name = "Rifle (EVENTO)", description = "Creo que este artículo no necesita una descripción.", price = 0 },
		{ itemID = 29, itemValue = 26, itemValue2 = 1, name = "Escopeta Recortada (EVENTO)", description = "Creo que este artículo no necesita una descripción.", price = 0 },
		{ itemID = 43, itemValue = 32, itemValue2 = 1, name = "Cargador Tec 9 (EVENTO)", description = "Un arma sin cargador, es como no tener nada.", price = 0 },
		{ itemID = 43, itemValue = 33, itemValue2 = 1, name = "Cargador Rifle (EVENTO)", description = "Un arma sin cargador, es como no tener nada.", price = 0 },
		{ itemID = 43, itemValue = 26, itemValue2 = 1, name = "Cargador Escopeta Recortada (EVENTO)", description = "Un arma sin cargador, es como no tener nada.", price = 0 },
	},
	drogas =
    {
        name = "Drogas",
        skin = 21,
		nivel = 14,
        { itemID = 18, itemValue = 1002, name = "Porro de marihuana", description = "Nada como un buen porro de marihuana.", price = 50 },
		{ itemID = 19, itemValue = 1002, name = "Seta Psicodelica", description = "Tío, esto sí que es vida.", price = 100 },
        { itemID = 20, itemValue = 1002, name = "Extasis", description = "¿Quieres fliparlo loco?", price = 150 },
	    { itemID = 21, itemValue = 1002, name = "Metanfetamina", description = "¿Estás cansado? Esto te irá mejor que el café.", price = 200 },
		{ itemID = 22, itemValue = 1002, name = "Bolsa de marihuana(5g)", description = "Este pack te sale a mejor precio que por separado.", price = 200 },
		{ itemID = 23, itemValue = 1002, name = "Bolsa de meta(5rayas)", description = "Este pack te sale a mejor precio que por separado.", price = 800},
	}, 
}

local function loadBookStore( )
	if shop_configurations.books then
		for key, value in ipairs( shop_configurations.books ) do
			shop_configurations.books[ key ] = nil
		end
    
	
    local languages = exports.players:getLanguages( )
    if languages then
        for key, value in ipairs( languages ) do
            table.insert( shop_configurations.books, { itemID = 8, itemValue = value[2], name = value[1] .. " diccionario", description = "Un diccionario para aprender los conceptos básicos de la lengua " .. value[1] .. ".", price = 100 } )
        end
    end
	end
end

addEventHandler( getResources and "onResourceStart" or "onClientResourceStart", root,
    function( res )
        if res == resource then
            if getResourceFromName( "players" ) and ( not getResourceState or getResourceState( getResourceFromName( "players" ) ) == "running" ) then
                loadBookStore( )
            end
        elseif res == getResourceFromName( "players" ) then
            loadBookStore( )
        end
    end
)
