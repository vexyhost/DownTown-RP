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
local connection = nil
local connection = nil
local null = nil
local results = { }
local max_results = 3000
local enabled = false

-- connection functions
local function connect( )
 
	local server = "127.0.0.1"
	local user = "USUARIO_DB"
	local password = "CLAVE_DB"
	local db = "NOMBRE_DB"
	local port = 3306
	local socket = "/var/lib/mysql/mysql.sock"


	connection = mysql_connect ( server, user, password, db, port, socket )
	if connection then
		mysql_set_character_set(connection, "utf8")
		if user == "root" then
			setTimer( outputDebugString, 100, 1, "ATENCIÓN: Se ha conectado usando el usuario root, y no es recomendable.", 2 )
		end
		return true
	else
		outputDebugString ( "Connection to MySQL Failed.", 1 )
		return false
	end
end

local function disconnect( )
	if connection and mysql_ping( connection ) then
		mysql_close( connection )
	end
end

local function checkConnection( )
	if not connection or not mysql_ping( connection ) then
		return connect( )
	end
	return true
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		if enabled == true then
			if not mysql_connect then
				cancelEvent( true, "MySQL module missing." )
			elseif not hasObjectPermissionTo( resource, "function.mysql_connect" ) then
				cancelEvent( true, "Insufficient ACL rights for mysql resource." )
			elseif not connect( ) then
				if connection then
					outputDebugString( mysql_error( connection ), 1 )
				end
				cancelEvent( true, "MySQL failed to connect." )
			else
				null = mysql_null( )
			end
		end
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		for key, value in pairs( results ) do
			mysql_free_result( value.r )
			outputDebugString( "Query not free()'d: " .. value.q, 2 )
		end
		
		disconnect( )
	end
)

--

function escape_string( str )
	if type( str ) == "string" then
		return mysql_escape_string( connection, str )
	elseif type( str ) == "number" then
		return tostring( str )
	end
end

local function query( str, ... )
	checkConnection( )
	
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end
	
	local result = mysql_query( connection, str )
	if result then
		for num = 1, max_results do
			if not results[ num ] then
				results[ num ] = { r = result, q = str }
				return num
			end
		end
		mysql_free_result( result )
		return false, "Unable to allocate result in pool"
	end
	return false, mysql_error( connection )
end

function query_free( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	checkConnection( )
	
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end
	
	local result = mysql_query( connection, str )
	if result then
		mysql_free_result( result )
		return true
	end
	return false, mysql_error( connection )
end

function free_result( result )
	if results[ result ] then
		mysql_free_result( results[ result ].r )
		results[ result ] = nil
	end
end

function query_assoc( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	local t = { }
	local result, error = query( str, ... )
	if result then
		for result, row in mysql_rows_assoc( results[ result ].r ) do
			local num = #t + 1
			t[ num ] = { }
			for key, value in pairs( row ) do
				if value ~= null then
					t[ num ][ key ] = tonumber( value ) or value
				end
			end
		end
		free_result( result )
		return t
	end 
	return false, error
end

function query_assoc_single( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	local t = { }
	local result, error = query( str, ... )
	if result then
		local row = mysql_fetch_assoc( results[ result ].r )
		if row then
			for key, value in pairs( row ) do
				if value ~= null then
					t[ key ] = tonumber( value ) or value
				end
			end
			free_result( result )
			return t
		end
		free_result( result )
		return false
	end
	return false, error
end

function query_insertid( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	local result, error = query( str, ... )
	if result then
		local id = mysql_insert_id( connection )
		free_result( result )
		return id
	end
	return false, error
end

function query_affected_rows( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	local result, error = query( str, ... )
	if result then
		local rows = mysql_affected_rows( connection )
		free_result( result )
		return rows
	end
	return false, error
end
