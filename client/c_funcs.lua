Clothingstore = {
    inAction = false,
}; 

function Clothingstore:init()
    while true do 
        local playerPed, loopInterval = PlayerPedId(), 1500; 
        local playerCoords = GetEntityCoords(playerPed);

        for key, value in pairs(Config.Stores) do 
            local distance = #(playerCoords - value.coords); 

            if distance <= 5.0 and not self.inAction then 
                loopInterval = 5; 

                ESX.Game.Utils.DrawText3D(value.coords, 'Press [E] to open the clothing store', 0.4);

                if distance < 1.0 and IsControlJustReleased(0, 38) then 
                    self:open(value.type); 
                end
            end 
        end

        Citizen.Wait(loopInterval); 
    end
end

function Clothingstore:open(type)
    exports.lowkey_appearanceui:displayApp({
        components = Config.Components[type],
        shouldReset = true, 
        callback = function(results)
            if results.success then 
                print('Player has saved skin', results.skin)
            else
                print('Player cancelled, last skin: ', results.skin)
            end
        end
    })
end

