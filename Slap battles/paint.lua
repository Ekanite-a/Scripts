local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local char = game:GetService("Players").LocalPlayer.Character

local npcs = {}
workspace:WaitForChild("npc")
task.wait(1)
for _, v in ipairs(workspace:GetChildren()) do
    if v.Name == "npc" then
        table.insert(npcs, v)
    end
end

local target
RunService.Heartbeat:Connect(function()
    ReplicatedStorage.Remotes.tool.use:FireServer("slap")
    for _, v in ipairs(npcs) do
        args = {"slap", {["Instance"] = v:FindFirstChild("Head")}}
        ReplicatedStorage.Remotes.tool.hit:FireServer(unpack(args))

        if not target and v.Head.Transparency == 0 and not v.HumanoidRootPart.Anchored then
            target = v
        end
    end
    if target then
        firetouchinterest(char:FindFirstChild("Hand", true), target.HumanoidRootPart, 0)
        firetouchinterest(char:FindFirstChild("Hand", true), target.HumanoidRootPart, 1)
        char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame

        target = (target.Head.Transparency == 0 and target) or nil
    end
end)