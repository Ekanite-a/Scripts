if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local workspace = game:GetService("Workspace")
local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local part = Instance.new("Part", workspace)
part.Anchored = true; part.Size = Vector3.new(10, 1, 10); part.CFrame = CFrame.new(450, 300, 100)

local Window = Rayfield:CreateWindow({
    Name = "Reflect",
    Icon = "sparkle",
    LoadingTitle = "Reflect",
    LoadingSubtitle = "made by ekanite",
    Theme = "Default",
    ToggleUIKeybind = "L",
})

local MainTab = Window:CreateTab("Main", "album")

local stage
local Portal = MainTab:CreateButton({
    Name = "go to portal",
    Callback = function()
        stage = workspace:FindFirstChild("Stage1") or workspace:FindFirstChild("Stage2") or workspace:FindFirstChild("Stage3")
        hrp.CFrame = stage.Lobby.Portals.normal.Teleport1.CFrame
    end
})

local Stage123 = MainTab:CreateButton({
    Name = "Stage 1 2 3",
    Callback = function()
        stage = workspace:FindFirstChild("Stage1") or workspace:FindFirstChild("Stage2") or workspace:FindFirstChild("Stage3")
        if stage.Name == "Stage1" then
            hrp.CFrame = CFrame.new(450, 305, 100)

            repeat task.wait(1) until workspace.Stage1.Mirror.Touch.Transparency == 0

            hrp.CFrame = workspace.Stage1.Mirror.Touch.CFrame
        elseif stage.Name == "Stage2" then
            part.CFrame = CFrame.new(300, 115, 1000)
            hrp.CFrame = CFrame.new(300, 120, 1000)

            repeat task.wait(1) until workspace.Stage2.Mirror.Touch.Transparency == 0

            hrp.CFrame = workspace.Stage2.Mirror.Touch.CFrame
        else
            part.CFrame = CFrame.new(1300, -40, -60)
            hrp.CFrame = CFrame.new(1300, -35, -60)
            
            while task.wait(0.1) do
                hrp.CFrame = (hrp.CFrame.Y < -40 and CFrame.new(1300, -35, -60)) or hrp.CFrame
                for _, v in ipairs(workspace.BossArena.Arena.mirrors:GetDescendants()) do
                    if v.ClassName == "MeshPart" and v.Position.Y >= -28 and v.Transparency == 0 then
                        hrp.CFrame = v.CFrame
                        repeat task.wait(0.1) until v.Position.Y < -28
                        hrp.CFrame = CFrame.new(1300, -35, -60)
                        break
                    end
                end
            end
        end
    end
})
