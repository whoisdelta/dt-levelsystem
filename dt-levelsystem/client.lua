RegisterNetEvent("sendNUIMessage")

local sendUi = function(data)
    SendNUIMessage(data)
end AddEventHandler("sendNUIMessage", sendUi);