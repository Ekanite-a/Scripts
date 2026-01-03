local workspace = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local runs = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local pack = player:WaitForChild("Backpack")
local hrp = player.Character:WaitForChild("HumanoidRootPart")
local hum = player.Character:WaitForChild("Humanoid")
local playerGui = player.PlayerGui

local cleaning = false


local BadGloves, days = "/bob/Bubble/Lamp/L.O.L.B.O.M.B/OVERKILL/Plague/Sbeve/UFO/", playerGui.Displays.subBarHolder.day.Text
local work = function()
    cleaning = false

    local WholeSalerGui = player.PlayerGui:WaitForChild("WholesaleOrdering").Canvas.Listings.ScrollingFrame
    task.wait(2)
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
                task.wait(0.2)
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