function Text(text)
		SetTextColour(186, 186, 186, 255)
		SetTextFont(0)
		SetTextScale(0.378, 0.378)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.017, 0.250)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if showcoord then
	    	x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			heading = GetEntityHeading(GetPlayerPed(-1))
	    	roundx = tonumber(string.format("%.2f", x))
	    	roundy = tonumber(string.format("%.2f", y))
	    	roundz = tonumber(string.format("%.2f", z))
			roundh = tonumber(string.format("%.2f", heading))
			Text("~r~X~w~: " ..roundx.." ~r~Y~w~: " ..roundy.." ~r~Z~w~: " ..roundz.." ~r~H~w~: " ..roundh.."")
		end
		
	end
end)

function qalleShowcoords()
	if showcoord then
		showcoord = false
	else
		showcoord = true
	end
end

RegisterCommand("coords", function(source)
    qalleShowcoords()
end, false)