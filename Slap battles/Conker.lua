if game.PlaceId ~= 101113181694564 then game:GetService("TeleportService"):Teleport(101113181694564) end

queue_on_teleport([[
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local hrp = player.Character.HumanoidRootPart

ReplicatedStorage.Remotes.Dialogue.FinishedNPCDialogue:FireServer()

task.wait(1)
fireclickdetector(workspace.Map.Props.BasketCollection.Basket.ClickDetector)
task.wait(5)
firetouchinterest(hrp, workspace.StartRoundPart, 0)
firetouchinterest(hrp, workspace.StartRoundPart, 1)

while task.wait() do
    hrp.CFrame = CFrame.new(36, 4, 1.5)
    
    if workspace:FindFirstChild("Conker") then
        firetouchinterest(hrp, workspace.Conker, 0)
        firetouchinterest(hrp, workspace.Conker, 1)
    end

    if workspace.NPCs:FindFirstChild("squirrel") then
        ReplicatedStorage.Remotes.tool.use:FireServer("slap")

        local args = {
            [1] = "slap",
            [2] = {
                ["Instance"] = workspace.NPCs.squirrel.HumanoidRootPart
            }
        }
        ReplicatedStorage.Remotes.tool.hit:FireServer(unpack(args))
    end
    fireproximityprompt(workspace.Map.CoreAssets.Bowl.ProximityPrompt)
end
]])