if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local queue_on_teleport = queue_on_teleport or queueonteleport
if queue_on_teleport and game.PlaceId ~= 106620300132058 then
    queue_on_teleport(
    [[if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(0.5)
    game.Workspace:WaitForChild("Obstacles"):Destroy()
    while task.wait() do
        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Glove Model"].Hand, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Glove Model"].Hand, 1)
    end
    ]])
end

if game.PlaceId == 106620300132058 then
    game.Workspace:WaitForChild("Obstacles"):Destroy()
    while task.wait() do
        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Glove Model"].Hand, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Glove Model"].Hand, 1)
    end
else
    game:GetService("TeleportService"):Teleport(106620300132058)
end