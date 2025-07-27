if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local workspace = game:GetService("Workspace")
local chara = game:GetService("Players").LocalPlayer.Character
local hrp = chara:WaitForChild("HumanoidRootPart")
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

local Portal = MainTab:CreateButton({
    Name = "go to portal",
    Callback = function()
        if workspace:FindFirstChild("Stage1") then
            hrp.CFrame = workspace.Stage1.Lobby.Portals.normal.Teleport1.CFrame
        elseif workspace:FindFirstChild("Stage2") then
            hrp.CFrame = workspace.Stage2.Lobby.Portals.normal.Teleport1.CFrame
        else
            hrp.CFrame = workspace.Stage3.Lobby.Portals.default.Teleport2.CFrame
        end
    end
})

local Stage1 = MainTab:CreateButton({
    Name = "Stage 1",
    Callback = function()
        hrp.CFrame = CFrame.new(450, 305, 100)

        repeat task.wait(1) until workspace.Stage1.Mirror.Touch.Transparency == 0

        hrp.CFrame = workspace.Stage1.Mirror.Touch.CFrame
    end
})

local Stage2 = MainTab:CreateButton({
    Name = "Stage 2",
    Callback = function()
        part.CFrame = CFrame.new(300, 115, 1000)
        hrp.CFrame = CFrame.new(300, 120, 1000)

        repeat task.wait(1) until workspace.Stage2.Mirror.Touch.Transparency == 0

        hrp.CFrame = workspace.Stage2.Mirror.Touch.CFrame
    end
})

local Stage1 = MainTab:CreateButton({
    Name = "Stage 3",
    Callback = function()
        part.Size = Vector3.new(50, 1, 50)
        part.CFrame = CFrame.new(1300, -40, -60)
        hrp.CFrame = CFrame.new(1300, -35, -60)
        while task.wait(0.1) do
            if hrp.Position.Y < -40 then hrp.CFrame = CFrame.new(1300, -35, -60) end
            for i, v in ipairs(workspace.BossArena.Arena.mirrors:GetDescendants()) do
                if v.ClassName == "MeshPart" and v.Position.Y >= -28 and v.Transparency == 0 then
                    hrp.CFrame = v.CFrame
                    repeat task.wait(0.1) until v.Position.Y < -28
                    hrp.CFrame = CFrame.new(1300, -35, -60)
                    break
                end
            end
        end
    end
})
