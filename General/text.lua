local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local text = {}

math.randomseed(tick())
local rand = function(len)
    local t = table.create(len)

    for i = 1, len do
        t[i] = string.char(math.random(32, 126))
    end
    return table.concat(t)
end

text.create = function(x, y, str)
    local ins = {}

    ins.gui = Instance.new("ScreenGui", playerGui)
    ins.Name = rand(10)
    ins.gui.DisplayOrder = 999999
    ins.gui.IgnoreGuiInset = true

    ins.frame = Instance.new("Frame", ins.gui)
    ins.frame.Name = rand(10)
    ins.frame.Size = UDim2.fromOffset(x, y)
    ins.frame.Position = UDim2.fromScale(0.7, 0.1)
    ins.frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ins.frame.BackgroundTransparency = 0.2
    ins.frame.BorderSizePixel = 0
    ins.frame.Active = true

    ins.label = Instance.new("TextLabel", ins.frame)
    ins.label.Name = rand(10)
    ins.label.Size = UDim2.fromScale(1, 1)
    ins.label.Position = UDim2.fromScale(0, 0)
    ins.label.BackgroundTransparency = 1
    ins.label.TextWrapped = true
    ins.label.TextSize = 13
    ins.label.Font = Enum.Font.Gotham
    ins.label.TextColor3 = Color3.fromRGB(230, 230, 230)
    ins.label.Text = str

    local dragging = false
    local dragStart, startPos

    ins.frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ins.frame.Position
        end
    end)

    ins.conns = {}
    ins.conns[1] = UIS.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)

    ins.conns[2] = UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            ins.frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    ins.updText = function(self, text)
        self.label.Text = tostring(text)
    end
    ins.destroy = function(self)
        self.frame:Destroy()
        for _, v in next, self.conns do
            v:Disconnect()
        end
    end

    return ins
end

return text
