local players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local activeLoops = {}
local LOCKED_CHARACTER = "Hong Lu"
local SLOCKED_CHARACTER = "Lei Heng"
local LOCKED_IDENTITY = "LCB Sinner"
local SLOCKED_IDENTITY = "The Thumb East Capo IIII"

local TARGET = {}
local STARGET = {}

local success, result = pcall(function()
	return HttpService:GetAsync("https://raw.githubusercontent.com/Termelia/evildoers/refs/heads/main/evil")
end)

if success then
	local decoded = HttpService:JSONDecode(result)
	for _, name in ipairs(decoded) do
		table.insert(TARGET, name)
	end
end

local ssuccess, sresult = pcall(function()
	return HttpService:GetAsync("https://raw.githubusercontent.com/Termelia/evildoers/refs/heads/main/evildoer")
end)

if ssuccess then
	local decoded = HttpService:JSONDecode(sresult)
	for _, name in ipairs(decoded) do
		table.insert(STARGET, name)
	end
end

local function lockAttributes(plr, playerName, lockedChar, lockedIdent)
	if not plr then return end
	plr:SetAttribute("Character", lockedChar)
	plr:SetAttribute("Identity", lockedIdent)
	local connCharacter = plr:GetAttributeChangedSignal("Character"):Connect(function()
		if activeLoops[playerName] and plr:GetAttribute("Character") ~= lockedChar then
			plr:SetAttribute("Character", lockedChar)
		end
	end)
	local connIdentity = plr:GetAttributeChangedSignal("Identity"):Connect(function()
		if activeLoops[playerName] and plr:GetAttribute("Identity") ~= lockedIdent then
			plr:SetAttribute("Identity", lockedIdent)
		end
	end)
	plr.AncestryChanged:Connect(function()
		if not plr.Parent then
			connCharacter:Disconnect()
			connIdentity:Disconnect()
		end
	end)
end

local function applyToPlayer(plr, playerName, lockedChar, lockedIdent)
	lockAttributes(plr, playerName, lockedChar, lockedIdent)
end

function m(main, lockedChar, lockedIdent)
	activeLoops[main] = true

	local plr = players:FindFirstChild(main)
	if plr then
		applyToPlayer(plr, main, lockedChar, lockedIdent)
	end

	players.PlayerAdded:Connect(function(player)
		if player.Name == main and activeLoops[main] then
			applyToPlayer(player, main, lockedChar, lockedIdent)
		end
	end)
end

local function run(playerName, lockedChar, lockedIdent)
	m(playerName, lockedChar, lockedIdent)
end

local function kickstart(plr)
	plr:LoadCharacterAsync()
	run(plr.Name, LOCKED_CHARACTER, LOCKED_IDENTITY)
end

local function kickstartS(plr)
	run(plr.Name, SLOCKED_CHARACTER, SLOCKED_IDENTITY)
end

function NoMoreAura()
	for _, name in ipairs(TARGET) do
		local plr = players:FindFirstChild(name)
		if plr then
			kickstart(plr)
		else
			local conn
			conn = players.PlayerAdded:Connect(function(player)
				if player.Name == name then
					conn:Disconnect()
					kickstart(player)
				end
			end)
		end
	end

	for _, name in ipairs(STARGET) do
		local plr = players:FindFirstChild(name)
		if plr then
			kickstartS(plr)
		else
			local conn
			conn = players.PlayerAdded:Connect(function(player)
				if player.Name == name then
					conn:Disconnect()
					kickstartS(player)
				end
			end)
		end
	end
end

NoMoreAura()
