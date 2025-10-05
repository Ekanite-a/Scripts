local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local char = game:GetService("Players").LocalPlayer.Character

local npcs = {}
workspace:WaitForChild("npc")
task.wait(1)
for _, v in ipairs(workspace:GetChildren()) do
    if v.Name == "npc" then
        table.insert(npcs, v)
    end
end

task.spawn(function()
    local args
    while task.wait() do
        args = {"slap"}
        ReplicatedStorage.Remotes.tool.use:FireServer(unpack(args))
    end
end)

task.spawn(function()
    local args
    while task.wait() do
        for _, v in ipairs(npcs) do
            args = {"slap", {["Instance"] = v:FindFirstChild("Head")}
            }
            ReplicatedStorage.Remotes.tool.hit:FireServer(unpack(args))
        end
    end
end)

local target
task.spawn(function()
    while task.wait() do
        if target then
            firetouchinterest(char:FindFirstChild("Hand", true), target.HumanoidRootPart, 0)
            firetouchinterest(char:FindFirstChild("Hand", true), target.HumanoidRootPart, 1)
            char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame

            if target.Head.Transparency == 1 then target = nil end
        end
    end
end)

while task.wait() do
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "npc" and v.Head.Transparency == 0 and not v.HumanoidRootPart.Anchored then
            target = v
        end
    end
end