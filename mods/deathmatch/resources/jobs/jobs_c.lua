function abrirGUIJob(job)
local job = tostring(job)
local gui = "jobs_"..job
exports.gui:show( gui )
end

addEvent("onAbrirJob", true)
addEventHandler("onAbrirJob", getLocalPlayer(), abrirGUIJob)
