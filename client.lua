local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = QBCore.Functions.GetPlayerData().job

-- Job Checking
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

local selectedQuestJob = nil
local selectedQuest = 0
local amountOfBoxes = nil
local pointToDelivery = nil
local lastzone = nil

RegisterNetEvent("sh_businessQuests:giveQuest",function()
    for k,v in pairs(Config.Jobs) do
        if PlayerJob.name == k then
            selectedQuestJob = PlayerJob.name
            print(selectedQuestJob)
            if selectedQuest < 1 then
                CreatePathDelivery()
            end
        end
    end
    
end)

RegisterNetEvent("sh_businessQuests:none",function()
    selectedQuest = 0
    pointToDelivery = nil
    amountOfBoxes = nil
    selectedQuestJob = nil
    if lastzone ~= nil then
        exports['qb-target']:RemoveZone(lastzone)
        lastzone = nil
    end
end)


function CreatePathDelivery()
    
    if lastzone ~= nil then
        exports['qb-target']:RemoveZone(lastzone)
        lastzone = nil
    end

    local currentzone = selectedQuestJob.."_delivery"
    pointToDelivery = Config.Jobs[selectedQuestJob].spawnSpeedo
    lastzone =  currentzone
    selectedQuest = 1
    amountOfBoxes = math.random(1, Config.MaxBoxes)
    
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
    end, Config.Car, pointToDelivery, false)
    TriggerEvent('QBCore:Notify', Config.Translations[Config.Lang]["gotoloc"], "success", 1000)
    SetNewWaypoint(Config.Jobs[selectedQuestJob].deliveryCoords.x, Config.Jobs[selectedQuestJob].deliveryCoords.y)

    exports['qb-target']:AddBoxZone(currentzone, Config.Jobs[selectedQuestJob].deliveryCoords, 3.5, 3.6, {
        name = currentzone,
        heading = 12.0,
        debugPoly = false,
        minZ = 0,
        maxZ = 100
    }, {
        options = {
            {
                --icon = 'fa-solid fa-bolt',
                label = Config.Translations[Config.Lang]["needtopickup"],
                canInteract = function()
                    return selectedQuestJob and not isWorking
                end,
                action = function()
                    GetDelivery(amountOfBoxes)
                end
            }
        },
        distance = 2.5
    })

end

function GetDelivery(amountOfBoxes)
    isWorking = true
    amount = amountOfBoxes
    QBCore.Functions.Progressbar(selectedQuestJob.."_dojob", Config.Translations[Config.Lang]["pickupbox"], math.random(3000, 7000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
     --   animDict = "anim@gangops@facility@servers@",
    --    anim = "hotwire",
    --    flags = 16,
    }, {}, {}, function() -- Done
        isWorking = false
       -- exports['anims-main']:Cancel()
        DeliverComplete(amount)
    end, function() -- Cancel
        isWorking = false
        --exports['anims-main']:Cancel()
        QBCore.Functions.Notify(Config.Translations[Config.Lang]["canceled"], "error")
    end)
end


function DeliverComplete(amount)
    deliveryboxes = amount
    selectedQuest = 2
    jobName = selectedQuestJob
    SetNewWaypoint(pointToDelivery.x, pointToDelivery.y)
    TriggerServerEvent('sh_businessQuests_sv:GetDeliver', amountOfBoxes, jobName)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local coordsPly = GetEntityCoords(GetPlayerPed(-1))
        if selectedQuest > 1 then
            if selectedQuestJob and GetDistanceBetweenCoords(pointToDelivery.x, pointToDelivery.y, pointToDelivery.z, coordsPly.x, coordsPly.y, coordsPly.z, false) < 30 then
                Draw3DText(pointToDelivery.x, pointToDelivery.y, pointToDelivery.z, 0.7, "~r~[E]~w~ "..Config.Translations[Config.Lang]["depositvan"])
                if IsControlJustPressed(0, 38) then
                    
                    if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == GetHashKey(Config.Car) then
                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                    end
                    TriggerEvent("sh_businessQuests:none")
                end
            else
                Citizen.Wait(4000)
            end
        end
    end
end)


function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


TriggerEvent("sh_businessQuests:none")
