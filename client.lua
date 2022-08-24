
local inCarwash = false
local UIShown = false
local BeingWashed = false

local function Blips(coords, type, label, job, blipOptions)
    if job then return end
    if blip == false then return end
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipOptions?.sprite or 357)
    SetBlipScale(blip, blipOptions?.scale or 0.8)
    SetBlipColour(blip, blipOptions?.colour ~= nil and blipOptions.colour or type == 'car' and Config.BlipColors.Car or type == 'boat' and Config.BlipColors.Boat or Config.BlipColors.Aircraft)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Carwash")
    EndTextCommandSetBlipName(blip)
end

for k, v in pairs(Config.CarWash) do
    exports["bt-polyzone"]:AddBoxZone(v.zone.name, vector3(v.zone.x, v.zone.y, v.zone.z), v.zone.l, v.zone.w, {
        name = v.zone.name,
        heading = v.zone.h,
        debugPoly = false,
        minZ = v.zone.minZ,
        maxZ = v.zone.maxZ
	    }
    )

    if v.blip ~= false then
        Blips(vector3(v.zone.x, v.zone.y, v.zone.z), v.type, v.label, v.job, v.blip)
    end
end

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
    for k, v in pairs(Config.CarWash) do
        if v.zone.name == name then
			inCarwash = true
			TriggerEvent('just_carwash:enteredWash')
            break
        end
    end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
    for k, v in pairs(Config.CarWash) do
        if v.zone.name == name then
			inCarwash = false
			TriggerEvent('cd_drawtextui:HideUI')
            break
        end
    end
end)

local timer2 = false
local mycie = false
RegisterNetEvent('just_carwash:enteredWash')
AddEventHandler('just_carwash:enteredWash', function (price)
	UIShown = false
	Citizen.CreateThread(function ()
		while inCarwash do
			Citizen.Wait(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then 
				if UIShown == false then
					TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] Clean Vehicle for $"..Config.CleaningCost.."")
					UIShown = true
				end
				if mycie == false then
				
					if IsControlJustPressed(1, 38) and BeingWashed == false then
						TriggerServerEvent('just_carwash:checkmoney')
					end
				else
					if IsControlJustPressed(1, 38) then
						mycie = false
						timer2 = false
						StopParticleFxLooped(particles, 0)
						StopParticleFxLooped(particles2, 0)
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
					end
				end
			else 
				UIShown = false
				TriggerEvent('cd_drawtextui:HideUI')
			end
		end
	end)
end)

RegisterNetEvent('just_carwash:success')
AddEventHandler('just_carwash:success', function (price)
	BeingWashed = true
	local car = GetVehiclePedIsUsing(PlayerPedId())
	local coords = GetEntityCoords(PlayerPedId())
	mycie = true
	FreezeEntityPosition(car, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
	UseParticleFxAssetNextCall("core")
	particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("core")
	particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x + 2, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	if Config.UseMythicProgbar == true then 
		TriggerEvent('cd_drawtextui:ShowUI', 'show', "[X] To Stop")
        TriggerEvent("mythic_progbar:client:progress", {
            name = "cleaning_vehicle",
            duration = (Config.CleaningTime * 1000),
            label = "Cleaning Vehicle",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
				WashDecalsFromVehicle(car, 1.0)
				SetVehicleDirtLevel(car)
				FreezeEntityPosition(car, false)
				StopParticleFxLooped(particles, 0)
				StopParticleFxLooped(particles2, 0)
                if Config.UseMythicNotify == true then 
                    TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = '"Your vehicle has been cleaned you filthy animal.', length = 2500})
                else
                    -- ESX.ShowNotification('"Your vehicle has been cleaned you filthy animal.')
                    TriggerEvent("swt_notifications:Icon", "Your vehicle has been cleaned you filthy animal.","top-right",4000,"green-8","white",true,"mdi-car-wash")
                end
                UIShown = false
				TriggerEvent('cd_drawtextui:HideUI')
				BeingWashed = false
			else 
				FreezeEntityPosition(car, false)
				StopParticleFxLooped(particles, 0)
				StopParticleFxLooped(particles2, 0)
				UIShown = false
				TriggerEvent('cd_drawtextui:HideUI')
				BeingWashed = false
            end
        end)
    else
		TriggerEvent('cd_drawtextui:ShowUI', 'show', "[E] To Stop")
		timer = Config.CleaningTime
		timer2 = true
		Citizen.CreateThread(function()
			while timer2 do
				Citizen.Wait(0)
				Citizen.Wait(1000)
				if(timer > 0)then
					timer = timer - 1
				elseif (timer == 0) then
					mycie = false
					WashDecalsFromVehicle(car, 1.0)
					SetVehicleDirtLevel(car)
					FreezeEntityPosition(car, false)
					if Config.UseMythicNotify == true then 
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'Your vehicle has been cleaned you filthy animal.', length = 2500})
					else
						-- ESX.ShowNotification('Your vehicle has been cleaned you filthy animal.')
						TriggerEvent("swt_notifications:Icon", "Your vehicle has been cleaned you filthy animal.","top-right",4000,"green-8","white",true,"mdi-car-wash")
					end
					--exports['mythic_notify']:SendAlert('inform', 'Your vehicle has been cleaned! For 25$')
					StopParticleFxLooped(particles, 0)
					StopParticleFxLooped(particles2, 0)
					timer2 = false
					UIShown = false
					TriggerEvent('cd_drawtextui:HideUI')
					BeingWashed = false
				end
			end
		end)
		Citizen.CreateThread(function()
			local playerCoord = GetEntityCoords(PlayerPedId())
			while mycie do
				Citizen.Wait(0)
				DrawText3D(playerCoord.x, playerCoord.y, playerCoord.z + 1, '~b~Cleaning... ~s~Time:~b~ '.. timer ..' ~s~seconds.')
			end
		end)
	end
end)

RegisterNetEvent('just_carwash:notenoughmoney')
AddEventHandler('just_carwash:notenoughmoney', function (moneyleft)
	if Config.UseMythicNotify == true then 
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = "You don't have enough money! You need: $" .. moneyleft .." more.", length = 2500})
	else
		-- ESX.ShowNotification("You don't have enough money! You need: $" .. moneyleft .." more.")
		TriggerEvent("swt_notifications:Icon", "You don't have enough money! You need: $" .. moneyleft .." more.","top-right",4000,"green-8","white",true,"mdi-car-wash")
	end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end