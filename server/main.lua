ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('outlawalert:carJackInProgress')
AddEventHandler('outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, playerGender)
	if playerGender == 1 then
		playerGender = _U('female')
	else
		playerGender = _U('male')
	end

	TriggerClientEvent('outlawalert:outlawNotify', -1, _U('carjack', playerGender, vehicleLabel, streetName), '10-16', targetCoords)
	TriggerClientEvent('outlawalert:carJackInProgress', -1, targetCoords)
end)

RegisterServerEvent('outlawalert:combatInProgress')
AddEventHandler('outlawalert:combatInProgress', function(targetCoords, streetName, playerGender)
	if playerGender == 1 then
		playerGender = _U('female')
	else
		playerGender = _U('male')
	end

	TriggerClientEvent('outlawalert:outlawNotify', -1, _U('combat', playerGender, streetName), '10-10', targetCoords)
	TriggerClientEvent('outlawalert:combatInProgress', -1, targetCoords)
end)

RegisterServerEvent('outlawalert:gunshotInProgress')
AddEventHandler('outlawalert:gunshotInProgress', function(targetCoords, streetName, playerGender)
	if playerGender == 1 then
		playerGender = _U('female')
	else
		playerGender = _U('male')
	end

	TriggerClientEvent('outlawalert:outlawNotify', -1, _U('gunshot', playerGender, streetName), '10-13', targetCoords)
	TriggerClientEvent('outlawalert:gunshotInProgress', -1, targetCoords)
end)

RegisterServerEvent('outlawalert:deadInProgress')
AddEventHandler('outlawalert:deadInProgress', function(targetCoords, streetName, playerGender)
	if playerGender == 1 then
		playerGender = _U('female')
	else
		playerGender = _U('male')
	end

	TriggerClientEvent('outlawalert:outlawNotifyA', -1, _U('dead', playerGender, streetName), '10-52', targetCoords)
	TriggerClientEvent('outlawalert:DeadInProgress', -1, targetCoords)
end)

RegisterServerEvent('outlawalert:panicInProgress')
AddEventHandler('outlawalert:panicInProgress', function(targetCoords, streetName, playerGender)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('outlawalert:outlawNotifyPanic', -1, xPlayer.getName()..'┃'..xPlayer.getJob().label..'/'..xPlayer.getJob().grade_label..' stisknul panic button. Ulice: '..streetName, '10-99', targetCoords)
	TriggerClientEvent('outlawalert:panicInProgress', -1, targetCoords)
end)

ESX.RegisterServerCallback('outlawalert:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)
