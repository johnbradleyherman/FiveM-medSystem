ESX = exports["es_extended"]:getSharedObject()

local health
local multi
local pulse = 70
local area = "Unknown"
local lastHit
local blood = 100
local bleeding = 0
local dead = false
local timer = 0

local cPulse = -1
local cBlood = -1
local cNameF = ""
local cNameL = ""
local cArea = ""
local cBleeding = "NONE"

AddEventHandler('esx:onPlayerDeath', function(data)
	multi = 2.0
	blood = 100
	health = GetEntityHealth(GetPlayerPed(-1))
	area = "LEGS/ARMS"
	local hit, bone = GetPedLastDamageBone(GetPlayerPed(-1))
	bleeding = 1
	if (bone == 31086) then
		multi = 0.0
		bleeding = 5
		area = "HEAD"
	end
	if bone == 24817 or bone == 24818 or bone == 10706 or bone == 24816 or bone == 11816 then
		multi = 1.0
		bleeding = 2
		area = "BODY"
	end
	pulse = ((health / 4 + 20) * multi) + math.random(0, 4)
	dead = true
end)

Citizen.CreateThread( function()
while true do
	Wait(5000)
	local hp = GetEntityHealth(GetPlayerPed(-1))
	if hp >= 1 and dead then
		dead = false
		bleeding = 0
		blood = 100
	end
	if dead and blood > 0 then
	blood = blood - bleeding
	end
end
end)

RegisterNetEvent('medSystem:near')
AddEventHandler('medSystem:near', function(x,y,z, pulse, blood, nameF, nameL, area, bldn)
local md = Config.Declared
		if blood <= 5 and pulse <= 10 or area == "HEAD" then
		cBlood = blood
		cPulse = pulse
		cNameF = nameF
		cNameL = nameL
		cArea = area
		message = nameF..' '..nameL..' '..Config.Declared
		TriggerEvent('chat:addMessage',  {
            template = '<div class="chat-message ambulance"><b>Medical Center </b>: <b>'..message..'</b></div>',
            args = { -1, message }
        })
	end
	local a,b,c = GetEntityCoords(PlayerPedId())
	
	if GetDistanceBetweenCoords(x,y,z,a,b,c,false) < 1 then
		timer = Config.Timer
		cBlood = blood
		cPulse = pulse
		cNameF = nameF
		cNameL = nameL
		cArea = area
		
		if bldn == 1 then
		cBleeding = "SLOW"
		elseif bldn == 2 then
		cBleeding = "MEDIUM"
		elseif bldn == 5 then
		cBleeding = "FAST"
		elseif bldn == 0 then
		cBleeding = "NONE"
		end	
	else
		timer = 0
		cBlood = -1
		cPulse = -1
		cNameF = ""
		cNameL = ""
		cArea = ""
		cBleeding = "SLOW"
	end
end)

Citizen.CreateThread( function()
	while true do
		Wait(0)
			while timer >= 1 do
				Wait(0)
				if cPulse ~= -1 and cBlood ~= -1 then
					lib.registerContext({
						id = 'medMenu',
						title = 'Medical Report',
						options = {
						  {
							title = 'Player Name: ' .. cNameF .. ' ' .. cNameL ..'',
							icon = 'user-md'
						  },
						  {
							title = 'Pulse: '.. cPulse ..'',
							icon = 'heartbeat'
						  },
						  {
							title = 'Blood: ' .. cBlood .. '',
							icon = 'heartbeat'
						  },
						  {
							title = 'Hurt Area: ' .. cArea .. '',
							icon = 'heartbeat'
						  },
						  {
							title = 'Bleeding: ' .. cBleeding .. '',
							icon = 'heartbeat'
						  }
						}
					  })
			lib.showContext('medMenu')
			end
		end
	end
end)

Citizen.CreateThread( function()
	while true do
		Wait(0)
		if timer >= 1 then
			timer = timer - 1
		end	
	end
end)

RegisterNetEvent('medSystem:send')
AddEventHandler('medSystem:send', function(req)
	local health = GetEntityHealth(GetPlayerPed(-1))
	if health > 0 then
		pulse = (health / 4 + math.random(19, 28)) 
	end
	local a, b, c = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	TriggerServerEvent('medSystem:print', req, math.floor(pulse * (blood / 90)), area, blood, a, b, c, bleeding)
end)
