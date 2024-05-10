ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('medSystem:print')
AddEventHandler('medSystem:print', function(req, pulse, area, blood, x, y, z, bleeding)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	Wait(100)
	local name = getIdentity(_source)
	local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('medSystem:near', xPlayers[i] ,x ,y ,z , pulse, blood, name.firstname, name.lastname, area, bleeding)	
		end
end)

RegisterCommand('med', function(source, args)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for k,v in pairs(Config.job) do
		if v.ambulance and xPlayer.job.name == 'ambulance' then
		if args[1] ~= nil then
		TriggerClientEvent('medSystem:send', args[1], source)
		else
		TriggerClientEvent('ox_lib:notify', source, { 
				type = 'error', 
				title = 'Correct command is: /med (id)',
				duration = 5000,
				position = 'center-right',
				style = {
					backgroundColor = '#1C1C1C',
					color = '#C1C2C5',
					borderRadius = '8px',
					['.description'] = {
						fontSize = '16px',
						color = '#B0B3B8'
					},
				},
			})
		end				
	else
		TriggerClientEvent('ox_lib:notify', source, { 
			type = 'error', 
			title = 'Your job is not Whitelisted!',
			duration = 5000,
            position = 'center-right',
            style = {
                backgroundColor = '#1C1C1C',
                color = '#C1C2C5',
                borderRadius = '8px',
                ['.description'] = {
                    fontSize = '16px',
                    color = '#B0B3B8'
                },
            },
        })
		end
	end
end, false)

function getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
	if result[1] ~= nil then
		local identity = result[1]
		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
		}
	else
		return nil
	end
end