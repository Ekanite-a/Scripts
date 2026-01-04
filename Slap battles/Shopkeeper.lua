if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)


local s = [[
local workspace = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local runs = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local pack = player:WaitForChild("Backpack")
local hrp = player.Character:WaitForChild("HumanoidRootPart")
local hum = player.Character:WaitForChild("Humanoid")
local playerGui = player.PlayerGui
local UIS = game:GetService("UserInputService")
playerGui.News.Canvas.Topbar.ExitButton.Interactable = false


local gui = Instance.new("ScreenGui", playerGui)
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(150, 50)
frame.Position = UDim2.fromScale(0.7, 0.1)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.fromScale(1, 1)
label.Position = UDim2.fromScale(0, 0)
label.BackgroundTransparency = 1
label.TextWrapped = true
label.TextSize = 13
label.Font = Enum.Font.Gotham
label.TextColor3 = Color3.fromRGB(230, 230, 230)
label.Text = ""

local dragging = false
local dragOffset

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

updText = function(text)
    label.Text = tostring(text)
end

player.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local cleaning = false

local BadGloves, days = "/bob/Bubble/Lamp/L.O.L.B.O.M.B/OVERKILL/Plague/Sbeve/UFO/", playerGui.Displays.subBarHolder.day.Text
local work = function()
    cleaning = false

    local WholeSalerGui = player.PlayerGui:WaitForChild("WholesaleOrdering"):WaitForChild("Canvas"):WaitForChild("Listings"):WaitForChild("ScrollingFrame")
    WholeSalerGui:WaitForChild("listing_1")
    task.wait(0.5)
    local list = {}
    for i, v in next, WholeSalerGui:GetChildren() do
        if v.Name:match("listing") then
            local glove = v.Topbar.ItemName.Text:sub(1, #v.Topbar.ItemName.Text - 8)
            if BadGloves:match(glove) and not days:match("5") then continue end

            list[#list + 1] = {v, tonumber(v.ExpectedProfit.Text:sub(2)), tonumber(v.Cost.Text:sub(2))}
        end
    end

    table.sort(list, function(a, b)
        return a[2] > b[2]
    end)

    local cash = tonumber(playerGui.Displays.topBarHolder.cash.Text:sub(2))
    for _, v in next, list do
        if cash - v[3] >= 0 then
            firesignal(v[1].Activated)
            cash -= v[3]
        end
    end

    task.wait(0.2)

    firesignal(playerGui.WholesaleOrdering.Canvas.PurchaseButton.Activated)

    repeat
        task.wait(1)
    until workspace:FindFirstChild("GloveShipment") and workspace.GloveShipment:FindFirstChild("Root") and (workspace.GloveShipment.Root.Position - Vector3.new(-19, 9, -11)).Magnitude < 10
    task.wait(1)

    shelf = 1
    for _, v in next, workspace.GloveShipment:GetChildren() do
        if v.Name:match("StockBox") then
            rs.Remotes.PickupBox:FireServer(v)
            task.wait(0.2)
            hrp.CFrame = workspace.Shelves[tostring(shelf)].Base.CFrame
            task.wait(0.2)
            rs.Remotes.StockShelf:FireServer(workspace.Shelves[tostring(shelf)])
            shelf += 1
        end
    end

    cleaning = true
end

if workspace.Tools and workspace.Tools.Prompts then
    local prompt = workspace.Tools.Prompts

    hrp.CFrame = prompt.Broom.CFrame

    task.wait(0.5)
    fireproximityprompt(prompt.Broom.ProximityPrompt)

    task.wait(0.5)
    hrp.CFrame = prompt.Mop.CFrame

    task.wait(0.5)
    fireproximityprompt(prompt.Mop.ProximityPrompt)
end
task.wait(3)

local trashes = workspace.Trash.Instances
local main; main = runs.Heartbeat:Connect(function()
    local cnt = 0
    for _, v in next, workspace.Shelves:GetDescendants() do
        if v.Name == "Handle" then cnt += 1 end
    end
    updText(cnt .. " gloves left")

    if not cleaning then return end

    if trashes:FindFirstChild("TrashSpill") then
        local trash = trashes.TrashSpill

        hrp.CFrame = trash:GetPivot()
        if pack:FindFirstChild("Mop") then hum:EquipTool(pack.Mop) end
        rs.Remotes.CleanTrash:FireServer(trash)
    elseif trashes:FindFirstChild("TrashPile") then
        local trash = trashes.TrashPile
        
        hrp.CFrame = trash:GetPivot()
        if pack:FindFirstChild("Broom") then hum:EquipTool(pack.Broom) end
        rs.Remotes.CleanTrash:FireServer(trash)
    else
        for _, v in workspace:GetChildren() do
            if v:FindFirstChild("Handle") and (v:GetPivot().Position - Vector3.new(57, 6, -38)).Magnitude < 10 then
                cleaning = false
                local name = v.Name:lower()
                rs.Remotes.PickupCheckoutItem:FireServer(v)
                task.wait(0.1)
                rs.Remotes.ScanCheckoutItem:FireServer(name)
                task.wait(0.2)
                cleaning = true

                break
            end
        end

        hum:UnequipTools()
        hrp.CFrame = CFrame.new(Vector3.new(53, 5.7, -42), Vector3.new(0, 0, 1))
    end
end)

for i = 1, 5 do
    repeat
        task.wait(0.2)
    until playerGui.News.Canvas.Visible
    playerGui.News.Canvas.Topbar.ExitButton.Interactable = false
    task.wait(0.2)
    firesignal(playerGui.News.Canvas.Topbar.ExitButton.MouseButton1Click)
    task.wait(0.2)

    days = playerGui.Displays.subBarHolder.day.Text
    work()

    repeat
        task.wait(0.2)
    until playerGui.DayReview.Canvas.Visible
    task.wait(0.2)
    firesignal(playerGui.DayReview.Canvas.ContinueButton.Activated)
    task.wait(0.2)

    if days:match("5") then main:Disconnect() end
end

task.wait(1)
hrp.CFrame = CFrame.new(-51, 5, -33)
task.wait(1)
fireproximityprompt(workspace["Merchant_" .. player.Name].Head.EscapePrompt)
]]


if game.PlaceId == 122901288403496 then

loadstring(s)()

else

game:GetService("TeleportService"):Teleport(122901288403496)
queue_on_teleport(s)

end
