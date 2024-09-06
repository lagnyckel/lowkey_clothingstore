ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback('lowkey_clothingstore:pay', function(source, callback, label, skin, price)
    local player = ESX.GetPlayerFromId(source);

    if not player then 
        callback({ success = false, message = 'Could not find your character, try to relogg' })
        return 
    end

    local playerCash = player.getMoney();

    if playerCash < price then 
        callback({ success = false, message = 'You do not have enough money' })
        return 
    end

    TriggerEvent('esx_datastore:getDataStore', 'property', player.identifier, function(store)
        local dressing = store.get('dressing')

        if dressing == nil then 
            dressing = {}
        end

        table.insert(dressing, {
            label = label,
            skin = skin
        })  

        store.set('dressing', dressing)
        store.save()

        player.removeMoney(price)

        callback({ success = true, message = 'You have successfully paid' })
    end)
end)