if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local workspace = game:GetService("Workspace")
local room = workspace:WaitForChild("Debug Room")
local fcd = function(instance) 
    fireclickdetector(instance:FindFirstChild("ClickDetector"))
    task.wait(0.1)
end

fcd(room.Keypad.Buttons[room.DuckTable.DuckTable.Duckies.Value])
fcd(room.Keypad.Buttons[room.AdminGloves.GlovesCode.SurfaceGui.AdminNumber.Text])
fcd(room.Keypad.Buttons[room.Maze.MazePrize.SurfaceGui.MazeNumber.Text])
fcd(room.Keypad.Buttons["7"])
fcd(room.Keypad.Buttons.Enter)