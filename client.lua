ESX = nil
display = false
maxLength = 100
minLength = 30

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
    Citizen.Wait(1000)
  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(1000)
  end

  ESX.PlayerData = ESX.GetPlayerData()
      Citizen.Wait(1000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local distanceToForm = 30000

        for k, v in pairs(Config.Forms) do
          local distance = #(coords - v.pos)
          if distance < distanceToForm then
            distanceToForm = distance
          end
          if not display then
            if distance < 1.0 then
              if ESX.PlayerData.job then
                if ESX.PlayerData.job.name ~= k then
                  DrawText3D(v.pos, '~g~[E]~w~ '..v.label)
                  if IsControlJustReleased(0, 38) then
                    SetDisplay(true, k, v.label)
                  end
                end
              end
            end
          end
        end
        if distanceToForm > Config.LoadDistance then
          Citizen.Wait(2000)
        end
    end
end)

RegisterNUICallback("send_form", function(data)
    SetDisplay(false)
    if data ~= nil then
      local wayjocLength = string.len(data.wayjoc)
      local tuabyLength = string.len(data.tuaby)
      if (wayjocLength < minLength) or (tuabyLength < minLength) then
        ESX.ShowNotification('~r~Your form is too short - '..minLength..' min. characters!')
      else
        if (wayjocLength > maxLength) or (tuabyLength > maxLength) then
          ESX.ShowNotification('~r~Your form is too long - '..maxLength..' max. characters!')
        else
          sendForm(data)
          ESX.ShowNotification('~g~Your form has been sent to - '..data.job)
        end
      end
    else
      ESX.ShowNotification('~r~Your form is empty!')
    end
end)

RegisterNUICallback("exit_form", function(data)
    if data.error ~= nil then
      ESX.ShowNotification(data.error)
    end
    SetDisplay(false)
end)

function SetDisplay(bool, form_job, form_label)
    display = bool
    SetNuiFocus(bool, bool)
    local firstname, lastname, phone
    ESX.TriggerServerCallback('strin_jobform:getInfo', function(info)
      firstname = info["firstname"]
      lastname = info["lastname"]
      phone = info["phone_number"]
    end)
    while phone == nil do
      Citizen.Wait(100)
    end
    SendNUIMessage({
        type = "ui",
        status = bool,
        job = form_job,
        label = form_label,
        player = {
          firstname = firstname,
          lastname = lastname,
          phone = phone
        }
    })
end

function sendForm(data)
  TriggerServerEvent('strin_jobform:sendWebhook', GetPlayerServerId(PlayerId()), data)
end

function DrawText3D(coords, text)
  local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
  
  SetTextScale(Config.DrawTextScale.x, Config.DrawTextScale.y)
  SetTextFont(Config.DrawTextFont)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  if Config.DrawRect then
    local factor = (string.len(text)) / 200
    DrawRect(_x,_y+0.0105, 0.015+ factor, 0.035, 44, 44, 44, 100)
  end
end
