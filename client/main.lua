ESX = exports["es_extended"]:getSharedObject()

local timing, isPlayerWhitelisted, isPlayerPanicWhitelisted, IsDead = math.ceil(Config.Timer * 60000), false, false, false
local streetName, streetNamee, playerGender
local elementscalls = {}

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    if ESX.PlayerData.job then
        isPlayerWhitelisted = refreshPlayerWhitelisted()
        isPlayerPanicWhitelisted = refreshPlayerPanicWhitelisted()
    end

    TriggerEvent('skinchanger:getSkin', function(skin)
        playerGender = skin.sex
    end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

    isPlayerWhitelisted = refreshPlayerWhitelisted()
    isPlayerPanicWhitelisted = refreshPlayerPanicWhitelisted()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    IsDead = true

    isPlayerWhitelisted = refreshPlayerWhitelisted()
    isPlayerPanicWhitelisted = refreshPlayerPanicWhitelisted()
end)

AddEventHandler('playerSpawned', function(spawn)
    IsDead = false

    isPlayerWhitelisted = refreshPlayerWhitelisted()
    isPlayerPanicWhitelisted = refreshPlayerPanicWhitelisted()
end)

local lastCallLocation = nil
RegisterNetEvent('outlawalert:outlawNotify')
AddEventHandler('outlawalert:outlawNotify', function(alert, code, coords)
    if isPlayerWhitelisted then
		lastCallLocation = { code = code, coords = coords }
        table.insert(elementscalls, { title = code .. ' ' .. alert, description = 'Kliknutim označíte miesto callu', arrow = true,
            onSelect = function()
                SetWaypointOff()
                SetNewWaypoint(coords.x, coords.y)
                exports.ox_lib:defaultNotify({
                    description = 'Byla nastavena GPS na poslední ' .. code,
                    status = 'success'
                })
            end
        })
        TriggerEvent("InteractSound_CL:PlayOnOne", "10-1315", 0.4)

        TriggerServerEvent('mdt:newCall', alert, 'Místni', coords, false)

        exports.ox_lib:notify({
            title = 'Dispatch ' .. code,
            description = alert,
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'building-shield',
            iconColor = '#3035c5',
            duration = 15000
        })
    end
end)

RegisterNetEvent('outlawalert:outlawNotifyPanic')
AddEventHandler('outlawalert:outlawNotifyPanic', function(alert, code, coords)
    if isPlayerPanicWhitelisted then
		lastCallLocation = { code = code, coords = coords }
        table.insert(elementscalls, { title = code .. ' ' .. alert, description = 'Kliknutim označíte miesto callu', arrow = true,
            onSelect = function()
                SetWaypointOff()
                SetNewWaypoint(coords.x, coords.y)
                exports.ox_lib:defaultNotify({
                    description = 'Byla nastavena GPS na poslední ' .. code,
                    status = 'success'
                })
            end
        })
        
        TriggerEvent("InteractSound_CL:PlayOnOne", "panic", 0.07)

        TriggerServerEvent('mdt:newCall', alert, 'Místni', coords, false)

        exports.ox_lib:notify({
            title = 'Dispatch ' .. code,
            description = alert,
            style = {
                backgroundColor = '#4d2323',
                color = '#909296'
            },
            icon = 'building-shield',
            iconColor = '#3035c5',
            duration = 45000
        })
    end
end)

RegisterNetEvent('outlawalert:outlawNotifyA')
AddEventHandler('outlawalert:outlawNotifyA', function(alert, code, coords)
    if isPlayerPanicWhitelisted then
		lastCallLocation = { code = code, coords = coords }
        table.insert(elementscalls, { title = code .. ' ' .. alert, description = 'Kliknutim označíte miesto callu', arrow = true,
            onSelect = function()
                SetWaypointOff()
                SetNewWaypoint(coords.x, coords.y)
                exports.ox_lib:defaultNotify({
                    description = 'Byla nastavena GPS na poslední ' .. code,
                    status = 'success'
                })
            end
        })
        
        TriggerEvent("InteractSound_CL:PlayOnOne", "10-1315", 0.4)

        TriggerServerEvent('mdt:newCall', alert, 'Místni', coords, false)

        exports.ox_lib:notify({
            title = 'Dispatch ' .. code,
            description = alert,
            style = {
                backgroundColor = '#4d2324',
                color = '#909296'
            },
            icon = 'truck-medical',
            iconColor = '#3035c5',
            duration = 15000
        })
    end
end)

RegisterNetEvent('outlawalert:outlawNotifyRob')
AddEventHandler('outlawalert:outlawNotifyRob', function(alert, code, coords)
    if isPlayerWhitelisted then
		lastCallLocation = { code = code, coords = coords }
        table.insert(elementscalls, { title = code .. ' ' .. alert, description = 'Kliknutim označíte miesto callu', arrow = true,
            onSelect = function()
                SetWaypointOff()
                SetNewWaypoint(coords.x, coords.y)
                exports.ox_lib:defaultNotify({
                    description = 'Byla nastavena GPS na poslední ' .. code,
                    status = 'success'
                })
            end
        })

        TriggerEvent("InteractSound_CL:PlayOnOne", "10-1315", 0.4)

        exports.ox_lib:notify({
            title = 'Dispatch ' .. code,
            description = alert,
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'building-shield',
            iconColor = '#3035c5',
            duration = 25000
        })
    end
end)

RegisterKeyMapping('setlastcall', 'Set waypoint to last call', 'keyboard', 'Y')

---@diagnostic disable-next-line: missing-parameter
RegisterCommand('setlastcall', function()
	if isPlayerWhitelisted then
		if lastCallLocation and lastCallLocation.coords and lastCallLocation.code then
			SetWaypointOff()
			SetNewWaypoint(lastCallLocation.coords.x, lastCallLocation.coords.y)
			exports.ox_lib:defaultNotify({
				description = 'Byla nastavena GPS na poslední ' .. lastCallLocation.code,
				status = 'success'
			})
		else
			exports.ox_lib:defaultNotify({
				description = 'Žádné informace o posledním hlášení',
				status = 'error'
			})
		end
	end
end, false)

RegisterCommand('lastcalls', function()
	if isPlayerWhitelisted then
		if lastCallLocation and lastCallLocation.coords and lastCallLocation.code then
			exports.ox_lib:registerContext({
                id = 'outlawalert-calls',
                title = 'Dispatch Calls',
                options = elementscalls
            })
            exports.ox_lib:showContext('outlawalert-calls')
		else
			exports.ox_lib:defaultNotify({
				description = 'Žádné informace o posledním hlášení',
				status = 'error'
			})
		end
	end
end, false)

-- Gets the player's current street.
-- Aaalso get the current player gender
function getstreetname()
    local playerCoords = GetEntityCoords(PlayerPedId())
    streetNamee = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    streetName = GetStreetNameFromHashKey(streetNamee)    

    return streetName
end

AddEventHandler('skinchanger:loadSkin', function(character)
    playerGender = character.sex
end)

function refreshPlayerWhitelisted()
    if not ESX.PlayerData then
        return false
    end

    if not ESX.PlayerData.job then
        return false
    end

    for k, v in ipairs(Config.WhitelistedCops) do
        if v == ESX.PlayerData.job.name then
            return true
        end
    end

    return false
end

function refreshPlayerPanicWhitelisted()
    if not ESX.PlayerData then
        return false
    end

    if not ESX.PlayerData.job then
        return false
    end

    for k, v in ipairs(Config.WhitelistedPanic) do
        if v == ESX.PlayerData.job.name then
            return true
        end
    end

    return false
end

RegisterNetEvent('outlawalert:RobberyInProgress')
AddEventHandler('outlawalert:RobberyInProgress', function(targetCoords)
    if isPlayerWhitelisted then
        local alpha = 250
        local deadBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipDeadRadius)

        SetBlipHighDetail(deadBlip, true)
        SetBlipColour(deadBlip, 17)
        SetBlipAlpha(deadBlip, alpha)
        SetBlipAsShortRange(deadBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipDeadTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(deadBlip, alpha)

            if alpha == 0 then
                RemoveBlip(deadBlip)
                return
            end
        end
    end
end)

RegisterNetEvent('outlawalert:carJackInProgress')
AddEventHandler('outlawalert:carJackInProgress', function(targetCoords)
    if isPlayerWhitelisted then
        if Config.CarJackingAlert then
            local alpha = 250
            local thiefBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipJackingRadius)

            SetBlipHighDetail(thiefBlip, true)
            SetBlipColour(thiefBlip, 1)
            SetBlipAlpha(thiefBlip, alpha)
            SetBlipAsShortRange(thiefBlip, true)

            while alpha ~= 0 do
                Citizen.Wait(Config.BlipJackingTime * 4)
                alpha = alpha - 1
                SetBlipAlpha(thiefBlip, alpha)

                if alpha == 0 then
                    RemoveBlip(thiefBlip)
                    return
                end
            end

        end
    end
end)

RegisterNetEvent('outlawalert:gunshotInProgress')
AddEventHandler('outlawalert:gunshotInProgress', function(targetCoords)
    if isPlayerWhitelisted and Config.GunshotAlert then
        local alpha = 250
        local gunshotBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipGunRadius)

        SetBlipHighDetail(gunshotBlip, true)
        SetBlipColour(gunshotBlip, 1)
        SetBlipAlpha(gunshotBlip, alpha)
        SetBlipAsShortRange(gunshotBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipGunTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(gunshotBlip, alpha)

            if alpha == 0 then
                RemoveBlip(gunshotBlip)
                return
            end
        end
    end
end)

RegisterNetEvent('outlawalert:combatInProgress')
AddEventHandler('outlawalert:combatInProgress', function(targetCoords)
    if isPlayerWhitelisted and Config.MeleeAlert then
        local alpha = 250
        local meleeBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipMeleeRadius)

        SetBlipHighDetail(meleeBlip, true)
        SetBlipColour(meleeBlip, 17)
        SetBlipAlpha(meleeBlip, alpha)
        SetBlipAsShortRange(meleeBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipMeleeTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(meleeBlip, alpha)

            if alpha == 0 then
                RemoveBlip(meleeBlip)
                return
            end
        end
    end
end)

RegisterNetEvent('outlawalert:DeadInProgress')
AddEventHandler('outlawalert:DeadInProgress', function(targetCoords)
    if isPlayerWhitelisted and Config.DeadAlert then
        local alpha = 250
        local deadBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipDeadRadius)

        SetBlipHighDetail(deadBlip, true)
        SetBlipColour(deadBlip, 17)
        SetBlipAlpha(deadBlip, alpha)
        SetBlipAsShortRange(deadBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipDeadTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(deadBlip, alpha)

            if alpha == 0 then
                RemoveBlip(deadBlip)
                return
            end
        end
    end
end)

RegisterNetEvent('outlawalert:panicInProgress')
AddEventHandler('outlawalert:panicInProgress', function(targetCoords)
    if isPlayerPanicWhitelisted and Config.PanicAlert then
        local alpha = 250
        local panicBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipPanicRadius)

		SetBlipRoute(panicBlip, true)

		CreateThread(function()
			while panicBlip do
				SetBlipRouteColour(panicBlip, 1)
				Citizen.Wait(150)
				SetBlipRouteColour(panicBlip, 6)
				Citizen.Wait(150)
				SetBlipRouteColour(panicBlip, 35)
				Citizen.Wait(150)
				SetBlipRouteColour(panicBlip, 6)
			end
		end)	

        SetBlipHighDetail(panicBlip, true)
        SetBlipColour(panicBlip, 17)
        SetBlipAlpha(panicBlip, alpha)
        SetBlipAsShortRange(panicBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipPanicTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(panicBlip, alpha)

            if alpha == 0 then
                RemoveBlip(panicBlip)
                return
            end
        end
    end
end)

Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local count = 0
    local sleep = 100    
    while true do
        -- is jackin'
        if (IsPedJacking(playerPed) and Config.CarJackingAlert) or (IsPedGettingIntoAVehicle(playerPed) and IsVehicleNeedsToBeHotwired(GetVehiclePedIsEntering(playerPed))) then
            sleep = 10

            count = #GetNearbyPeds(playerCoords.x, playerCoords.y, playerCoords.z, 20)

            Citizen.Wait(3000)
            local vehicle = GetVehiclePedIsIn(playerPed, true)

            if (count > 0) then
                if vehicle and ((isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted) then
                    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

                    ESX.TriggerServerCallback('outlawalert:isVehicleOwner', function(owner)
                        if not owner then

                            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                            vehicleLabel = GetLabelText(vehicleLabel)

                            TriggerServerEvent('outlawalert:carJackInProgress', {
                                x = ESX.Math.Round(playerCoords.x, 1),
                                y = ESX.Math.Round(playerCoords.y, 1),
                                z = ESX.Math.Round(playerCoords.z, 1)
                            }, getstreetname(), vehicleLabel, playerGender)
                        end
                    end, plate)
                end
            end

        elseif IsPedInMeleeCombat(playerPed) and HasPedBeenDamagedByWeapon(GetMeleeTargetForPed(playerPed), 0, 1) and Config.MeleeAlert then
            sleep = 10

            count = #GetNearbyPeds(playerCoords.x, playerCoords.y, playerCoords.z, 20)

            Citizen.Wait(3000)

            if (count > 0) then
                if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then

                    TriggerServerEvent('outlawalert:combatInProgress', {
                        x = ESX.Math.Round(playerCoords.x, 1),
                        y = ESX.Math.Round(playerCoords.y, 1),
                        z = ESX.Math.Round(playerCoords.z, 1)
                    }, getstreetname(), playerGender)
                end
            end

        elseif IsPedShooting(playerPed) and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and Config.GunshotAlert then
            sleep = 10

            count = #GetNearbyPeds(playerCoords.x, playerCoords.y, playerCoords.z, 20)

            Citizen.Wait(3000)

            if (count > 0) then
                if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then

                    TriggerServerEvent('outlawalert:gunshotInProgress', {
                        x = ESX.Math.Round(playerCoords.x, 1),
                        y = ESX.Math.Round(playerCoords.y, 1),
                        z = ESX.Math.Round(playerCoords.z, 1)
                    }, getstreetname(), playerGender)
                end
            end
        else 
            sleep = 100 
        end
        Citizen.Wait(sleep)
    end
end)

local canSendDistress  = true
RegisterCommand('alert_dead', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    if IsDead and canSendDistress then
        canSendDistress = false
        Citizen.Wait(2000)
        TriggerServerEvent('outlawalert:deadInProgress', {
            x = ESX.Math.Round(playerCoords.x, 1),
            y = ESX.Math.Round(playerCoords.y, 1),
            z = ESX.Math.Round(playerCoords.z, 1)
        }, getstreetname(), playerGender)
        Citizen.Wait(20000)
        canSendDistress = true
    end
end, false)

RegisterKeyMapping('alert_dead', 'Send distress signal to Police/EMS', 'keyboard', 'G')

RegisterCommand('panic', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if isPlayerPanicWhitelisted then

        TriggerServerEvent('outlawalert:panicInProgress', {
            x = ESX.Math.Round(playerCoords.x, 1),
            y = ESX.Math.Round(playerCoords.y, 1),
            z = ESX.Math.Round(playerCoords.z, 1)
        }, getstreetname(), playerGender)
    end
end, false)



local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {
            handle = iter,
            destructor = disposeFunc
        }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetPlayerFromPed(ped)
    for a = 0, 255 do
        if GetPlayerPed(a) == ped then
            return a
        end
    end
    return -1
end

function GetNearbyPeds(X, Y, Z, Radius)
    local NearbyPeds = {}
    if tonumber(X) and tonumber(Y) and tonumber(Z) then
        if tonumber(Radius) then
            for Ped in EnumeratePeds() do
                if DoesEntityExist(Ped) and not IsPedAPlayer(Ped) and not IsPedDeadOrDying(Ped, true) and
                    GetPedType(Ped) ~= 28 then
                    local PedPosition = GetEntityCoords(Ped, false)
                    if Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z) <= Radius then
                        if GetPlayerFromPed(Ped) == -1 then
                            table.insert(NearbyPeds, Ped)
                        end
                    end
                end
            end
        else
            print("GetNearbyPeds was given an invalid radius!")
        end
    else
        print("GetNearbyPeds was given invalid coordinates!")
    end
    return NearbyPeds
end

function BlacklistedWeapon(playerPed)
	for i = 1, #Config.WeaponBlacklist do
		local weaponHash = GetHashKey(Config.WeaponBlacklist[i])
		if GetSelectedPedWeapon(playerPed) == weaponHash then
			return true -- Is a blacklisted weapon
		end
	end
	return false -- Is not a blacklisted weapon
end