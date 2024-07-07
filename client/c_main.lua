ESX = exports.es_extended:getSharedObject()

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end
    
    Clothingstore:init(); 
end)