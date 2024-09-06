Clothingstore = {}; 

function Clothingstore:init()
    while true do 
        local playerPed, loopInterval = PlayerPedId(), 1500; 
        local playerCoords = GetEntityCoords(playerPed);

        for key, value in pairs(Config.Stores) do 
            local distance = #(playerCoords - value.coords); 

            if distance <= 5.0 then 
                loopInterval = 5; 

                ESX.Game.Utils.DrawText3D(value.coords, 'Press [E] to open the clothing store', 0.4);

                if distance < 1.0 and IsControlJustReleased(0, 38) then 
                    self:open(value.type, value.price); 
                end
            end 
        end

        Citizen.Wait(loopInterval); 
    end
end

function Clothingstore:open(type, price)    
    self.lastSkin = nil; 

    TriggerEvent('skinchanger:getSkin', function(skin)
        self.lastSkin = skin; 
    end)

    exports.lowkey_appearanceui:displayApp({
        components = Config.Components[type],
        shouldReset = true, 
        tabs = { 'clothing' }, 
        callback = function(results)
            if results.success then 
                self:labelOutfit(results.skin, price)
            end
        end
    })
end

function Clothingstore:pay(label, playerSkin, price)
    if not playerSkin then return end; 

    local elements = {
        { label = 'Pay', value = 'pay' }, 
        { label = 'Cancel', value = 'cancel' }
    }; 

    ESX.UI.Menu.CloseAll(); 
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pay', 
    {
        title = 'Clothing Store',
        align = 'right', 
        elements = elements
    }, function(menuData, menuIndex)
        local value = menuData.current.value;

        if value == 'pay' then 
            local p = promise:new(); 
            
            ESX.TriggerServerCallback('lowkey_clothingstore:pay', function(results) 
                p:resolve(results)
            end, label, playerSkin, price)

            local results = Citizen.Await(p);

            if not results.success then 
                ESX.ShowNotification(results.message)
                return 
            end

            ESX.ShowNotification(results.message)

            TriggerEvent('skinchanger:loadSkin', playerSkin);

            menuIndex.close()
        end
    
    end, function(menuData, menuIndex)
        if self.lastSkin ~= nil then 
            TriggerEvent('skinchanger:loadSkin', self.lastSkin);
        end

        menuIndex.close()
    end)
end

function Clothingstore:labelOutfit(playerSkin, price)
    exports.lowkey_appearanceui:closeApp();

    Citizen.Wait(150); 

    AddTextEntry('OUTFIT', 'Give your outfit a name!')
                
    DisplayOnscreenKeyboard(1, 'OUTFIT', '', '', '', '', '', 30)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        DisableAllControlActions(0)
        Wait(0)
        DisplayHelpTextThisFrame('mod_menu_help_text', false)
    end

    local outfitName = GetOnscreenKeyboardResult()

    Citizen.Wait(500)

    self:pay(outfitName, playerSkin, price)
end