local sX, sY	= guiGetScreenSize()
local x, y		= sX/1366,sY/768
local fontsize	= sX/1920
local loginError = ""

local lp = {
			hasAccount		= true,
			blur			= {
							shader 			= dxCreateShader("img/blur.fx"),
							screensource	= dxCreateScreenSource(sX,sY),
			},
			
			login			= {
							showpass		= false,
							savepass		= false,
			},
			
			register 		= {
							
			},
			
			forgotpass		= {
			
			},

}

function showLogin(serialRegistered)
	showCursor(true)
	
	lp.login.button = dxCreateButton(sX/2 - (150*x)/2,( sY/2 - (410*y)/2 ) + (260*y),150*x,30*y,"Login",tocolor(0,0,0,255))
	lp.login.username = dxCreateEdit(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + 105*y,270*x,30*y,1.5*fontsize,"Usuario")
	if serialRegistered then
		lp.hasAccount = true
	else
		lp.hasAccount = false
	end
	lp.login.password = dxCreateEdit(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,270*x,30*y,1.5*fontsize,"Clave")
	dxSetEditMask(lp.login.password,true)
	
	lp.register.button = dxCreateButton((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (100*x)/2,( sY/2 - (250*y)/2 ) + (200*y),100*x,30*y,"Registrar",tocolor(0,0,0,255))
	lp.register.username = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (60*y),170*x,30*y,1.5*fontsize,"Usuario")
	lp.register.password = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (100*y),170*x,30*y,1.5*fontsize,"Clave")
	dxSetEditMask(lp.register.password,true)
	lp.register.repassword = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (140*y),170*x,30*y,1.5*fontsize,"Confirma clave")
	dxSetEditMask(lp.register.repassword,true)
	
	lp.forgotpass.fpass = dxCreateButton(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,"¿Olvidaste tu clave?",tocolor(41,130,206,255),1*fontsize)
	lp.forgotpass.pass = dxCreateEdit((sX/2 - (230*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 20*y,230*x,30*y,1.5*fontsize,"Nueva clave")
	lp.forgotpass.button = dxCreateButton((sX/2 - (100*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 70*y,100*x,20*y,"Continuar",tocolor(0,0,0,255),1*fontsize)
	
	addEventHandler("onClientRender",root,blurRender)
	addEventHandler("onClientRender",root,drawLogin)
	addEventHandler("onClientRender",root,drawRegister)
	
end

function resetLoginError()
	loginError = ""
end

addEvent( "players:loginResult", true )
addEventHandler( "players:loginResult", getLocalPlayer( ),
	function( code )
		if code == 1 then
			loginError = "Usuario o contraseña incorrectos."
			dxSetButtonEnabled(lp.login.button,true)
			setTimer(resetLoginError, 2000, 1)
		elseif code == 2 then
			--show( 'banned', true )
			loginError = "El usuario se encuentra baneado."
		elseif code == 3 then
            --showChat(true)
            --show( 'activation_required', false )
			--iniTest()
			loginError = "El usuario requiere pasar test de rol."
			dxSetButtonEnabled(lp.login.button,true)
			setTimer(resetLoginError, 2000, 1)
		elseif code == 4 then
			loginError = "Error desconocido, inténtalo de nuevo."
		elseif code == 5 then
			loginError = "Otra persona está usando tu cuenta."
			dxSetButtonEnabled(lp.login.button,true)
			setTimer(resetLoginError, 2000, 1)
		elseif code == 6 then
			--show( 'deactivation', true )
			loginError = "El usuario está desactivado."
			dxSetButtonEnabled(lp.login.button,true)
			setTimer(resetLoginError, 2000, 1)
		end
	end
)
	
addEvent( "players:registrationResult", true )
addEventHandler( "players:registrationResult", getLocalPlayer( ),
	function( code, message )
		if code == 0 then
			local username = dxGetEditText(lp.register.username)
			local password = dxGetEditText(lp.register.password)
			triggerServerEvent("server:login",getLocalPlayer(),username,password)
		elseif code == 1 then
			loginError = "Error en el registro, prueba más tarde."
			dxSetButtonEnabled(lp.register.button,true)
			setTimer(resetLoginError, 2000, 1)
		elseif code == 2 then
			loginError = "Error, el registro está deshabilitado."
		elseif code == 3 then
			loginError = "Error, este usuario ya existe."
			dxSetButtonEnabled(lp.register.button,true)
			setTimer(resetLoginError, 2000, 1)
		elseif code == 4 then
			loginError = "Error en el registro, prueba más tarde."
			dxSetButtonEnabled(lp.register.button,true)
			setTimer(resetLoginError, 2000, 1)
		elseif code == 5 then
			loginError = "Solo se permite una cuenta por serial."
		elseif code == 6 then
			loginError = "Solo se permiten dos cuentas por IP."
	    end
	end	
)

addEvent( "client:recoverFailed", true )
addEventHandler( "client:recoverFailed", getLocalPlayer( ),
	function( )
		loginError = "Error grave, inténtalo más tarde."
		setTimer(resetLoginError, 2000, 1)
	end	
)

addEvent("client:init:callBack",true)
addEventHandler("client:init:callBack",root,
function(serialRegistered)
	showLogin(serialRegistered)
end
)

addEvent("onDestroyLoginPanel",true)
addEventHandler("onDestroyLoginPanel",root,
function()
	showCursor(false)
	removeEventHandler("onClientRender",root,blurRender)
	removeEventHandler("onClientRender",root,drawLogin)
	removeEventHandler("onClientRender",root,drawRegister)
	removeEventHandler("onClientRender",root,drawForgot)
	if isElement(lp.blur.screensource) then
		destroyElement(lp.blur.screensource)
	end
	if isElement(lp.blur.shader) then
		destroyElement(lp.blur.shader)
	end
end
)

addEvent("client:forgotpass:callBack",true)
addEventHandler("client:forgotpass:callBack",root,
function(usernameCheck)
	if usernameCheck == true then
		addEventHandler("onClientRender",root,drawForgot)
	else
		loginError = "No puedes cambiar la clave de ese usuario."
		setTime(resetLoginError, 2000, 1)
	end
end
)

addEvent("onClientdxButtonClick",true)
addEventHandler("onClientdxButtonClick",root,
function(plr)
	if plr == localPlayer then
		if source == lp.login.button then
			local username = dxGetEditText(lp.login.username)
			local password = dxGetEditText(lp.login.password)
			if #username >= 3 and #password >= 5 then
				triggerServerEvent("server:login",plr,username,password)
				dxSetButtonEnabled(lp.login.button,false)
			else
				if #username < 3 then
					loginError = "El usuario debe de ser de 3 caracteres o más."
				elseif #password < 5 then
					loginError = "La clave debe de ser de 5 caracteres o más."
				end
				setTimer(resetLoginError, 2000, 1)
			end
		elseif source == lp.register.button then
			local username = dxGetEditText(lp.register.username)
			local password = dxGetEditText(lp.register.password)
			local repassword = dxGetEditText(lp.register.repassword)
			if #username >= 3 and #password >= 8 then
				if password == repassword then
					triggerServerEvent("server:register",plr,username,password)
					dxSetButtonEnabled(lp.register.button,false)
				end
			else
				if #username < 3 then
					loginError = "El usuario debe de ser de 3 caracteres o más."
				elseif #password < 8 then
					loginError = "La clave debe de ser de 8 caracteres o más."
				end
				setTimer(resetLoginError, 2000, 1)
			end
		elseif source == lp.forgotpass.fpass then
			local username = dxGetEditText(lp.login.username)
			if #username > 0 then
				triggerServerEvent("server:forgotpass",plr,username)
			else
				loginError = "¡Introduce primero tu usuario!"
				setTimer(resetLoginError, 2000, 1)
			end
		elseif source == lp.forgotpass.button then
			local username = dxGetEditText(lp.login.username)
			if #username > 0 then
				local password = dxGetEditText(lp.forgotpass.pass)
				if #password >= 8 then
					triggerServerEvent("server:changePassword",plr,username,password)
					removeEventHandler("onClientRender",root,drawForgot)
				else
					if password > 0 then
						loginError = "La clave debe de ser de 8 caracteres o más."
						setTimer(resetLoginError, 2000, 1)
					else
						loginError = "¡Introduce tu nueva clave!"
						setTimer(resetLoginError, 2000, 1)
					end
				end
			else
				loginError = "¡Introduce primero tu usuario!"
				setTimer(resetLoginError, 2000, 1)
			end
		end
	end
end
)

function blurRender ()
    if isElement( lp.blur.shader ) and isElement( lp.blur.screensource ) then
		dxUpdateScreenSource(lp.blur.screensource)
		dxSetShaderValue(lp.blur.shader, "ScreenSource", lp.blur.screensource)
		dxSetShaderValue(lp.blur.shader, "UVSize", sX, sY)
		dxSetShaderValue(lp.blur.shader, "BlurStrength", 9 )	
        dxDrawImage(0, 0, sX, sY, lp.blur.shader)
    else
		if not isElement( lp.blur.shader ) then
			lp.blur.shader = dxCreateShader("img/blur.fx")
		end
		if not isElement( lp.blur.screensource ) then
			lp.blur.screensource = dxCreateScreenSource(sX,sY)
		end		
		dxSetShaderValue(lp.blur.shader, "ScreenSource", lp.blur.screensource)
		dxSetShaderValue(lp.blur.shader, "UVSize", sX, sY)
		dxSetShaderValue(lp.blur.shader, "BlurStrength", 9 )	
        dxDrawImage(0, 0, sX, sY, lp.blur.shader)
	end
end       

function drawLogin()
	dxDrawText2("DownTown RolePlay",sX/2 - (400*x)/2,0,400*x,160*y,tocolor(255,255,255,255),3*fontsize,"arial","center","bottom")
	dxDrawRectangle(sX/2 - (400*x)/2,sY/2 - (410*y)/2,400*x,410*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle(sX/2 - (400*x)/2,sY/2 - (410*y)/2,400*x,410*y,tocolor(0,0,0,100),8*x)
	
	dxDrawEdit(lp.login.username)
	dxDrawImage(sX/2 - (270*x)/2 - 35*y,( sY/2 - (410*y)/2 ) + 105*y,30*y,30*y,"img/username.png")
	
	dxDrawEdit(lp.login.password)
	dxDrawImage(sX/2 - (270*x)/2 - 35*y,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,30*y,30*y,"img/password.png")
	                                  
	dxDrawText2(tostring(loginError),(sX/2 - (270*x)/2),sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,255),1.8*fontsize,"default-bold","center","center")
	
	dxDrawButton(lp.login.button)
	
	dxDrawButton(lp.forgotpass.fpass)
	dxDrawEmptyRectangle(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,tocolor(0,0,0,255),1)
end

function drawRegister()
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 25*y,22*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 125*y,22*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 225*y,22*x,2,tocolor(0,0,0,150))
	dxDrawText2("¿No tienes cuenta? ¡Crea una!",(sX/2 - (400*x)/2) - 280*x,0,250*x,250*y,tocolor(255,255,255,255),1.5*fontsize,"arial","center","bottom")
	dxDrawRectangle((sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(0,0,0,100),1)
	
	if not lp.hasAccount then               
		dxDrawEdit(lp.register.username)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (60*y),30*y,30*y,"img/username.png")
		
		dxDrawEdit(lp.register.password)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (100*y),30*y,30*y,"img/password.png")
		
		dxDrawEdit(lp.register.repassword)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (140*y),30*y,30*y,"img/password.png")

		dxDrawButton(lp.register.button)
	else
		dxDrawText2("¡Sólo 1 cuenta por PC!",(sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,255),1.8*fontsize,"default-bold","center","center")
	end
end

function drawForgot()
	dxDrawRectangle((sX/2 - (400*x)/2) + 200*x,sY/2 + (410*y)/2 + 8*x,2,22*x,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (250*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x,250*x,100*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (250*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x,250*x,100*y,tocolor(0,0,0,100),1)
	dxDrawEdit(lp.forgotpass.pass)
	dxDrawButton(lp.forgotpass.button)
end