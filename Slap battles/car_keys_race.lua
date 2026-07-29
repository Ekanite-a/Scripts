if not game:IsLoaded() then game.Loaded:Wait() end

local Map = game:GetService("Workspace"):WaitForChild("Map")
Map.Racetrack:Destroy(); Map.kill_bricks:Destroy()
local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart

local align = Instance.new("AlignPosition", hrp)
align.Attachment0 = Instance.new("Attachment", hrp)
align.Mode = Enum.PositionAlignmentMode.OneAttachment
align.MaxForce = math.huge

for i = 1, #Map.Waypoints:GetChildren() do
    align.Position = Map.Waypoints[tostring(i)].CFrame.Position
    repeat task.wait() until (hrp.CFrame.Position - Map.Waypoints[tostring(i)].CFrame.Position).Magnitude <= 100
end
align.Position = Vector3.new(-1431, 425, -859)