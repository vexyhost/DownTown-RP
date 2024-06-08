defaultMusic = {
    --{ "Hip Hop Radio", "http://mp3uplink.duplexfx.com:8054/listen.pls" },
}

function createUserMusicFile ( doReturn )
	if ( not fileExists ( "@xml/usermusic2.xml" ) ) then
		local file = xmlCreateFile ( "@xml/usermusic2.xml", "list" )
		for i, v in ipairs ( defaultMusic ) do 
			local child = xmlCreateChild ( file, "radio" )
			xmlNodeSetAttribute ( child, "name", v[1] )
			xmlNodeSetAttribute ( child, "url", v[2] )
		end
		xmlSaveFile ( file )
		if doReturn then
			return file
		else
			xmlUnloadFile ( file )
		end
	end
end

function getRadioStations ( )
	local data = { }
	local file = xmlLoadFile ( "@xml/usermusic2.xml" ) or createUserMusicFile ( true )
	for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do 
		table.insert ( data, { tostring ( xmlNodeGetAttribute ( v, "name" ) ), tostring ( xmlNodeGetAttribute ( v, "url" ) ) } )
	end
	xmlUnloadFile ( file )
	return data
end

function removeRadioStation ( name, url )
	local file = xmlLoadFile ( "@xml/usermusic2.xml" ) or createUserMusicFile ( true )
	for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do 
		if ( xmlNodeGetAttribute ( v, "name" ) == name and xmlNodeGetAttribute ( v, "url" ) == url ) then
			xmlDestroyNode ( v )
			xmlSaveFile ( file )
			xmlUnloadFile ( file )
			return true
		end
	end
	xmlSaveFile ( file )
	xmlUnloadFile ( file )
	return false
end

function addRadioStation ( name, url )
	local file = xmlLoadFile ( "@xml/usermusic2.xml" ) or createUserMusicFile ( true )
	local child = xmlCreateChild ( file, "radio" )
	xmlNodeSetAttribute ( child, "name", name )
	xmlNodeSetAttribute ( child, "url", url )
	xmlSaveFile ( file )
	xmlUnloadFile ( file )
end
createUserMusicFile ( )