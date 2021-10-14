-- Locals
local showCoords = false
local coordsX, coordsY, coordsZ, coordsH = 0.0, 0.0, 0.0, 0.0
local playerPed



-- RGB text function
-- Big thanks to Jorji Costava: https://github.com/jorjic
-- https://github.com/jorjic/fivem-docs/wiki/Making-Rainbow-Text
function RGBText()
    local retval = {Config.ColourR, Config.ColourG, Config.ColourB, Config.ColourA}

    if Config.RGB then
        local time = GetGameTimer() / 1000

        retval[1] = math.floor(math.sin(time * Config.RGBSpeed + 0) * 127 + 128)
        retval[2] = math.floor(math.sin(time * Config.RGBSpeed + 2) * 127 + 128)
        retval[3] = math.floor(math.sin(time * Config.RGBSpeed + 4) * 127 + 128)
    end

    return retval
end



-- Update values thread
function StartUpdateThread()
    Citizen.CreateThread(function()
        while showCoords do
            playerPed = PlayerPedId()
            coordsX, coordsY, coordsZ = table.unpack(GetEntityCoords(playerPed))
            coordsH = GetEntityHeading(playerPed)
            Citizen.Wait(0)
        end
    end)
end



-- Display coordinates thread
function StartDisplayThread()
    Citizen.CreateThread(function()
        while showCoords do
            if Config.CustomSpacing then
                for i = 1, 4 do
                    SetTextOutline()
                    SetTextFont(Config.Font)
                    SetTextScale(Config.Scale, Config.Scale)
                    SetTextColour(table.unpack(RGBText()))
                    BeginTextCommandDisplayText("STRING")

                    if i == 1 then
                        AddTextComponentString(string.format("X: %." .. Config.Decimals .. "f", coordsX))
                        EndTextCommandDisplayText(Config.PositionX, Config.PositionY)
                    elseif i == 2 then
                        AddTextComponentString(string.format("Y: %." .. Config.Decimals .. "f", coordsY))
                        EndTextCommandDisplayText(Config.PositionX, Config.PositionY + Config.Spacing)
                    elseif i == 3 then
                        AddTextComponentString(string.format("Z: %." .. Config.Decimals .. "f", coordsZ))
                        EndTextCommandDisplayText(Config.PositionX, Config.PositionY + (Config.Spacing * 2))
                    elseif i == 4 then
                        AddTextComponentString(string.format("H: %." .. Config.Decimals .. "f", coordsH))
                        EndTextCommandDisplayText(Config.PositionX, Config.PositionY + (Config.Spacing * 3))
                    end
                end
            else
                SetTextOutline()
                SetTextFont(Config.Font)
                SetTextScale(Config.Scale, Config.Scale)
                SetTextColour(table.unpack(RGBText()))
                BeginTextCommandDisplayText("STRING")
                AddTextComponentString(string.format("X: %." .. Config.Decimals .. "f\nY: %." .. Config.Decimals .. "f\nZ: %." .. Config.Decimals .. "f\nH: %." .. Config.Decimals .. "f\n", coordsX, coordsY, coordsZ, coordsH))
                EndTextCommandDisplayText(Config.PositionX, Config.PositionY)
            end
            Citizen.Wait(0)
        end
    end)
end



-- Register "coords" command
RegisterCommand("coords", function()
    showCoords = not showCoords

    if showCoords then
        StartUpdateThread()
        StartDisplayThread()
    end
end)
