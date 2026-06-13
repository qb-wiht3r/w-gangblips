local QBCore = exports['qb-core']:GetCoreObject()

local PlayerGang = nil
local Blips = {}

local function RemoveBlips()
    for _, blip in pairs(Blips) do
        RemoveBlip(blip)
    end
    Blips = {}
end

local function CreateBlips()
    for gang, data in pairs(Config.Gangs) do
        if PlayerGang == gang then
            local blip = AddBlipForCoord(data.coords)

            SetBlipSprite(blip, data.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, data.scale)
            SetBlipColour(blip, data.color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.label)
            EndTextCommandSetBlipName(blip)

            Blips[#Blips + 1] = blip
        end
    end
end

local function UpdateGang()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData and PlayerData.gang then
        PlayerGang = PlayerData.gang.name
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1000)
    UpdateGang()
    CreateBlips()
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerGang = gang.name
    RemoveBlips()
    CreateBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    RemoveBlips()
    PlayerGang = nil
end)
