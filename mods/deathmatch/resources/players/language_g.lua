--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

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

local languages =
{
	{ "Árabe", "ar" },
	{ "Chino", "cn" }, -- China
	{ "Holandés", "nl" },
	{ "Inglés", "en" },
	{ "Finlandés", "fi" },
	{ "Francés", "fr" },
	{ "Alemán", "de" },
	{ "Griego", "gr" },
	{ "Hindú", "in" }, -- India, Pakistan
	{ "Italiano", "it" },
	{ "Japonés", "jp" },
	{ "Coreano", "kr" },
	{ "Polaco", "pl" },
	{ "Portugés", "pt" },
	{ "Ruso", "ru" },
	{ "Español", "es" },
	{ "Sueco", "se" },
	{ "Vietnamita", "vn" },
}

function getLanguageName( tag )
	for key, value in ipairs( languages ) do
		if value[2] == tag then
			return value[1]
		end
	end
	return false
end

function isValidLanguage( tag )
	return getLanguageName( tag ) ~= false
end

function getLanguages( )
	return languages
end