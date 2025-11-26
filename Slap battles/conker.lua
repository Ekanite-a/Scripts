if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

if game.PlaceId ~= 101113181694564 then 
    game:GetService("TeleportService"):Teleport(101113181694564)
else
    local workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart

    ReplicatedStorage.Remotes.Dialogue.FinishedNPCDialogue:FireServer()

    task.wait(1)
    fireclickdetector(workspace.Map.Props.BasketCollection.Basket.ClickDetector)
    task.wait(7.5)
    firetouchinterest(hrp, workspace.StartRoundPart, 0)
    firetouchinterest(hrp, workspace.StartRoundPart, 1)

    while task.wait() do
        hrp.CFrame = CFrame.new(36, 4, 1.5)
        
        if workspace:FindFirstChild("Conker") then
            firetouchinterest(hrp, workspace.Conker, 0)
            firetouchinterest(hrp, workspace.Conker, 1)
        end

        if workspace.NPCs:FindFirstChild("squirrel") and workspace.NPCs.squirrel:FindFirstChild("HumanoidRootPart") then
            ReplicatedStorage.Remotes.tool.use:FireServer("slap")
            ReplicatedStorage.Remotes.tool.hit:FireServer({
                "slap",
                {["Instance"] = workspace.NPCs.squirrel.HumanoidRootPart}
            })
        end
        fireproximityprompt(workspace.Map.CoreAssets.Bowl.ProximityPrompt)
    end
end

local queue_on_teleport = queue_on_teleport or queueonteleport

queue_on_teleport([[
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart

ReplicatedStorage.Remotes.Dialogue.FinishedNPCDialogue:FireServer()

task.wait(1)
fireclickdetector(workspace.Map.Props.BasketCollection.Basket.ClickDetector)
task.wait(7.5)
firetouchinterest(hrp, workspace.StartRoundPart, 0)
firetouchinterest(hrp, workspace.StartRoundPart, 1)

while task.wait() do
    hrp.CFrame = CFrame.new(36, 4, 1.5)
        
    if workspace:FindFirstChild("Conker") then
        firetouchinterest(hrp, workspace.Conker, 0)
        firetouchinterest(hrp, workspace.Conker, 1)
    end

    if workspace.NPCs:FindFirstChild("squirrel") and workspace.NPCs.squirrel:FindFirstChild("HumanoidRootPart") then
        ReplicatedStorage.Remotes.tool.use:FireServer("slap")
        ReplicatedStorage.Remotes.tool.hit:FireServer({
            "slap",
            {["Instance"] = workspace.NPCs.squirrel.HumanoidRootPart}
        })
    end
    fireproximityprompt(workspace.Map.CoreAssets.Bowl.ProximityPrompt)
end
]])