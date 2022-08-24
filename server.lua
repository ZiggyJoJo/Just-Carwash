ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('just_carwash:checkmoney')
AddEventHandler('just_carwash:checkmoney', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.CleaningCost then
		xPlayer.removeMoney(Config.CleaningCost)
		TriggerClientEvent('just_carwash:success', source, Config.CleaningCost)
	else
		moneyleft = Config.CleaningCost - xPlayer.getMoney()
		TriggerClientEvent('just_carwash:notenoughmoney', source, moneyleft)
	end
end)
