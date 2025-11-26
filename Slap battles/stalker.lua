local players = game:GetService("Players")
local player = players.LocalPlayer
local mod = require(game:GetService("ReplicatedFirst").Dependencies.GloveMasteryClient)

local old = mod.IsMasteredVersionEnabled
mod.IsMasteredVersionEnabled = function(self, ...)
    local args = {...}
    if args[1] == "Stalker" then return true end

    return old(self, ...)
end

game["Run Service"].Heartbeat:Connect(function()
    if player.leaderstats.Glove.Value == "Stalker" and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character:SetAttribute("GhostInvisible", false)
        player.Character.Humanoid.WalkSpeed = (player.Character.Humanoid.WalkSpeed <= 20 and 20.1) or player.Character.Humanoid.WalkSpeed
        for i, v in next, players:GetPlayers() do
            if v ~= player and v.Character then
                local meter = v.Character:FindFirstChild("StalkMeter") or Instance.new("IntValue", v.Character)
                meter.Name = "StalkMeter"
                meter.Value = 100
            end
        end
    end
end)