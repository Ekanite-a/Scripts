local s = [[
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart

ReplicatedStorage.Remotes.Dialogue.FinishedNPCDialogue:FireServer()

task.wait(1)
fireclickdetector(workspace.Map.Props.BasketCollection.Basket.ClickDetector)
task.wait(7.5)

while task.wait() do
    hrp.CFrame = CFrame.new(36, 4, 1.5)

    if workspace:FindFirstChild("Conker") then
        firetouchinterest(hrp, workspace.Conker, 0)
        firetouchinterest(hrp, workspace.Conker, 1)
    end

    ReplicatedStorage.Remotes.tool.use:FireServer("slap")
    for i, v in ipairs(workspace.NPCs:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") then
            ReplicatedStorage.Remotes.tool.hit:FireServer(
                "slap",
                {["Instance"] = v.HumanoidRootPart}
            )
        end
    end
    
    fireproximityprompt(workspace.Map.CoreAssets.Bowl.ProximityPrompt)
end
]]

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)


local qtp = queue_on_teleport or queueonteleport
if game.PlaceId == 101113181694564 then
    loadstring(s)()
else
    qtp(s)
    game:GetService("TeleportService"):Teleport(101113181694564)
end