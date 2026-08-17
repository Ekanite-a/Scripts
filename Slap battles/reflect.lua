if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local Gui = loadstring(game:HttpGet('https://pastefy.app/pT3jEHFx/raw'))()
local workspace = game:GetService("Workspace")
local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local part = Instance.new("Part")
part.Anchored = true; part.Size = Vector3.new(10, 1, 10); part.CFrame = CFrame.new(450, 300, 100); part.Parent = workspace

local Window = Gui:CreateWindow({Name = "Reflect"})

local Portal = Window:CreateButton({
    Name = "go to portal",
    Callback = function()
        local portal = (workspace:FindFirstChild("Stage1") or workspace:FindFirstChild("Stage2") or workspace:FindFirstChild("Stage3")).Lobby.Portals
        hrp.CFrame = (portal:FindFirstChild("normal") and portal.normal.Teleport1.CFrame) or portal.default.Teleport2.CFrame
    end,
})

local Stage123 = Window:CreateButton({
    Name = "Stage 1 2 3",
    Callback = function()
        local stage = workspace:FindFirstChild("Stage1") or workspace:FindFirstChild("Stage2")
        if not stage then
            part.CFrame = CFrame.new(1300, -40, -60)
            hrp.CFrame = CFrame.new(1300, -35, -60)
            
            while task.wait(0.1) do
                if hrp.CFrame.Y < -40 then hrp.CFrame = CFrame.new(1300, -35, -60) end
                for _, v in ipairs(workspace.BossArena.Arena.mirrors:GetDescendants()) do
                    if v.ClassName ~= "MeshPart" or v.Position.Y < -28 or v.Transparency ~= 0 then continue end
                    hrp.CFrame = v.CFrame
                    repeat task.wait(0.1) until v.Position.Y < -28
                    hrp.CFrame = CFrame.new(1300, -35, -60)
                    break
                end
            end
        elseif stage.Name == "Stage1" then
            hrp.CFrame = CFrame.new(450, 305, 100)
            local mirror = workspace.Stage1.Mirror.Touch

            repeat task.wait(1) until mirror.Transparency == 0

            hrp.CFrame = mirror.CFrame
        elseif stage.Name == "Stage2" then
            part.CFrame = CFrame.new(300, 115, 1000)
            hrp.CFrame = CFrame.new(300, 120, 1000)
            local mirror = workspace.Stage2.Mirror.Touch

            repeat task.wait(1) until mirror.Transparency == 0

            hrp.CFrame = mirror.CFrame
        end
    end
})
