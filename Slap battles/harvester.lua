if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local fpp = fireproximityprompt

local workspace = game:GetService("Workspace")
local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")

local wait = function(path)
    val = workspace
    for v in string.gmatch(path, "([^/]+)") do
        val = val:WaitForChild(v)
    end

    return val
end

for i = 1, 5 do
    hrp.CFrame = workspace.Shed.StartDoor["Cylinder.025"].CFrame
    task.wait(0.5)
    fpp(workspace.Shed.StartDoor["Cylinder.025"].Attachment.ProximityPrompt)

    if i == 5 then break end

    hrp.CFrame = wait("Maze/transition/visual/Shed/Door/Cylinder.025").CFrame
    task.wait(0.5)
    fpp(workspace.Maze.transition.visual.Shed.Door["Cylinder.025"].EndPromptAttachment.EndPrompt)

    repeat task.wait(0.1) until (hrp.Position - workspace.Shed.StartDoor["Cylinder.025"].Position).Magnitude <= 50
    task.wait(1)
end

hrp.CFrame = wait("Maze/BarnMaze/CoreParts/ChaseOutroStart").CFrame