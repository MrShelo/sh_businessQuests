local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("sh_businessQuests_sv:GetDeliver")
AddEventHandler("sh_businessQuests_sv:GetDeliver", function(itemAmount, jobName)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	local info = {
		jobName = jobName,
		packageName= Config.Jobs[jobName].packageName
	}
	Player.Functions.AddItem("deliverybox", itemAmount, false, info)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["deliverybox"], 'add')

end)

QBCore.Functions.CreateUseableItem("deliverybox" , function(source, item)   
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        local jobName = item.info.jobName
		for k,v in pairs(Config.Jobs[jobName].packageItems) do
			Player.Functions.RemoveItem("deliverybox", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["deliverybox"], 'remove')
			Player.Functions.AddItem(v, Config.ItemsDropAmount)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v], 'add')
		end
    end
end)
