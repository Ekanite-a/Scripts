local s = [[
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

game.Workspace:WaitForChild("Obstacles"):Destroy()
while task.wait() do
    firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Glove Model"].Hand, 0)
    firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Glove Model"].Hand, 1)
end
]]

local qtp = queue_on_teleport or queueonteleport

if game.PlaceId == 106620300132058 then
    loadstring(s)()
else
    qtp(s)
    game:GetService("TeleportService"):Teleport(106620300132058)
end