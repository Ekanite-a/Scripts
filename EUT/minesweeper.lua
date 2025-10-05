-- using greedy and simulated annealing + tabu search
-- it works but suck. still fixing
local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local minesweeper = workspace:WaitForChild("objects"):WaitForChild("minesweeper")


local UserInputService = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui")
local connections = {}
local connectCreate = newcclosure(function(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(connections, conn)
    return conn
end)

-- ScreenGui
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.ResetOnSpawn = false 

-- main frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundTransparency = 1

-- top bar
local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 25)
topBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- dragging button
local dragButton = Instance.new("TextButton", topBar)
dragButton.Size = UDim2.new(1, 0, 1, 0)
dragButton.Position = UDim2.new(0, 0, 0, 0)
dragButton.Text = "v5"
dragButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- collapse button
local collapseButton = Instance.new("TextButton", topBar)
collapseButton.Size = UDim2.new(0, 25, 1, 0)
collapseButton.Position = UDim2.new(0, 0, 0, 0)
collapseButton.Text = "-"

-- close button
local closeButton = Instance.new("TextButton", topBar)
closeButton.Size = UDim2.new(0, 25, 1, 0)
closeButton.Position = UDim2.new(1, -25, 0, 0)
closeButton.Text = "X"

-- content
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -25)
contentFrame.Position = UDim2.new(0, 0, 0, 25)
contentFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = 6
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y

-- UIListLayout
local listLayout = Instance.new("UIListLayout", contentFrame)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- padding
local padding = Instance.new("UIPadding", contentFrame)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

-- layout
local listLayout = Instance.new("UIListLayout", contentFrame)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- greedy
local greedyButton = Instance.new("TextButton", contentFrame)
greedyButton.Size = UDim2.new(1, -20, 0, 30)
greedyButton.LayoutOrder = 2
greedyButton.Text = "greedy"

-- SA
local SAButton = Instance.new("TextButton", contentFrame)
SAButton.Size = UDim2.new(1, -20, 0, 30)
SAButton.LayoutOrder = 2
SAButton.Text = "SA"

local fcd = fireclickdetector

math.randomseed(tick() + player.UserId)
local copy 
copy = newcclosure(function(orig, copies) -- omg why i have to do this myself
    copies = copies or {}
    if type(orig) ~= "table" then
        return orig
    elseif copies[orig] then
        return copies[orig]
    end

    local copyT = {}
    copies[orig] = copyT
    for k, v in pairs(orig) do
        copyT[copy(k, copies)] = copy(v, copies)
    end
    return copyT
end)

local N = tonumber(string.sub(minesweeper:WaitForChild("INTERFACE"):WaitForChild("BoardSize"):WaitForChild("SurfaceGui"):WaitForChild("Number").Text, 1, 2))
local grid, flagged_pos = {}, {}
for i = 1, N do
    grid[i] = {}
    flagged_pos[i] = {}
end
local Parts = minesweeper:WaitForChild("CELLS"):GetChildren()
table.sort(Parts, function(a, b)
    return tonumber(a.Name:sub(5)) < tonumber(b.Name:sub(5))
end)

local id
local updateGrid = newcclosure(function()
    task.wait(0.2)
    id = 1
    for i = 1, N do
        for j = 1, N do
            grid[i][j] = {
                state = (Parts[id].Color == Color3.fromRGB(255, 255, 255) and (Parts[id]:FindFirstChild("NumberGUI") and tonumber(Parts[id].NumberGUI:WaitForChild("TextLabel", 2).Text) or 0)) or ((Parts[id]:FindFirstChild("NumberGUI") or flagged_pos[i][j]) and -2 or -1),
                obj = Parts[id]
            }
            id = id + 1
        end
    end
    task.wait(0.2)
end)


local open = newcclosure(function(x, y)
    if grid[x][y].state ~= -1 then return end

    fcd(grid[x][y].obj.ClickDetector)
end)


local flag = newcclosure(function(x ,y)
    if grid[x][y].state ~= -1 then return end

    flagged_pos[x][y] = true
    grid[x][y].state = -2
end)


local dx = {-1, -1, -1, 0, 0, 1, 1, 1}; local dy = {-1, 0, 1, -1, 1, -1, 0, 1}
local greedy = newcclosure(function()
    local upd = false
    local flagged; local blank

    for i = 1, N do
        for j = 1, N do
            if grid[i][j].state >= 1 then
                flagged, blank = 0, {}
                for k = 1, 8 do
                    if grid[i + dx[k]] and grid[i + dx[k]][j + dy[k]] then
                        if grid[i + dx[k]][j + dy[k]].state == -2 or flagged_pos[i + dx[k]][j + dy[k]] then
                            flagged = flagged + 1
                        elseif grid[i + dx[k]][j + dy[k]].state == -1 then
                            table.insert(blank, {x = i + dx[k], y = j + dy[k]})
                        end
                    end
                end

                if grid[i][j].state - flagged == 0 and #blank > 0 then
                    upd = true
                    for _, v in ipairs(blank) do
                        open(v.x, v.y)
                    end
                elseif grid[i][j].state - flagged == #blank and #blank > 0 then
                    upd = true
                    for _, v in ipairs(blank) do
                        flag(v.x, v.y)
                    end
                end
                table.clear(blank)
            end
        end
    end
    updateGrid()

    return upd
end)

local tmpGrid
local calEnergy = newcclosure(function(state)
    local E = 0
    local totalMine, totalPredicted, predicted, flagged = tonumber(minesweeper.INTERFACE.Flags.SurfaceGui.Number.Text), 0, 0, 0

    tmpGrid = copy(grid)
    for _, v in ipairs(state) do
        if v.mine then
            tmpGrid[v.x][v.y].state = -3
            totalPredicted = totalPredicted + 1
        end
    end
    if totalPredicted > totalMine then
        return 1E7
    end

    for _, u in ipairs(state) do
        for i = 1, 8 do
            local nx, ny = u.x + dx[i], u.y + dy[i]
            if tmpGrid[nx] and tmpGrid[nx][ny] and tmpGrid[nx][ny].state >= 1 and not tmpGrid[nx][ny].alrCal then
                predicted, flagged = 0, 0
                
                for j = 1, 8 do
                    if tmpGrid[nx + dx[j]] and tmpGrid[nx + dx[j]][ny + dy[j]] then
                        if tmpGrid[nx + dx[j]][ny + dy[j]].state == -2 or flagged_pos[nx + dx[j]][ny + dy[j]] then
                            flagged = flagged + 1
                        elseif tmpGrid[nx + dx[j]][ny + dy[j]].state == -3 then
                            predicted = predicted + 1
                        end
                    end
                end

                tmpGrid[nx][ny].alrCal = true
                E = E + (predicted - (tmpGrid[nx][ny].state - flagged))^2
            end
        end
    end

    return E
end)

local randomId; local tabu = {}
local flip = newcclosure(function(state)
    repeat
        randomId = math.random(1, #state)
    until not table.find(tabu, randomId)
    table.insert(tabu, randomId)
    if #tabu >= #state // 5 then table.remove(tabu, 1) end

    state[randomId].mine = not state[randomId].mine
end)

local state = {}; local data = {}; local finish = false; local opened; local min
local thin = 5; local burn_in = 500
local SA = newcclosure(function()
    local T = 1; opened = false; min = {x = 0, y = 0, times = 1E7}
    table.clear(tabu); table.clear(state); table.clear(data)
    updateGrid()
    for i = 1, N do
        for j = 1, N do
            if grid[i][j].obj.Color == Color3.fromRGB(255, 0, 0) then finish = true end
            if grid[i][j].state == -1 then
                for k = 1, 8 do
                    if grid[i + dx[k]] and grid[i + dx[k]][j + dy[k]] and grid[i + dx[k]][j + dy[k]].state >= 1 then
                        table.insert(state, {x = i, y = j, mine = false})
                        table.insert(data, {x = i, y = j, times = 0})
                        break
                    end
                end
            end
        end
    end
    if #state == 0 then
        finish = true
    end
    if finish then
        return
    end

    local CurE = calEnergy(state)
    local NewE; local deltaE
    
    for i = 1, burn_in do
        flip(state)
        if i % 100 == 0 then task.wait() end
    end
    
    task.wait(0.1)

    local samples = 0
    for i = 1, 1000 + 100 * #state do
        flip(state)

        if i % thin == 0 then
            NewE = calEnergy(state)
            deltaE = NewE - CurE

            if deltaE < 0 or math.random() < math.exp(-deltaE / T) then
                samples += 1
                CurE = NewE
                for j = 1, #state do
                    data[j].times = data[j].times + ((state[j].mine and 1) or 0)
                end
            end
        end

        T = T * 0.95
        if i % 100 == 0 then task.wait() end
    end

    for _, v in ipairs(data) do
        if v.times / samples < 0.05 then
            open(v.x, v.y)
            opened = true
        elseif v.times / samples > 0.95 then
            flag(v.x, v.y)
        end
        
        if math.min(min.times, v.times) == v.times then
            min = copy(v)
        end
    end
    
    if not opened and min.times / samples < 0.2 then
        open(min.x, min.y)
    end

    task.wait(0.1)
    minesweeper.FlagModeChange:InvokeServer()
    task.wait(0.4)
    for i = 1, N do
        for j = 1, N do
            if flagged_pos[i][j] then
                fcd(grid[i][j].obj.ClickDetector)
                flagged_pos[i][j] = false
            end
        end
    end
    task.wait(0.6)
    minesweeper.FlagModeChange:InvokeServer()
    task.wait(0.9)

    updateGrid()
    print("sa end")
end)


local start = newcclosure(function()
    updateGrid()
    local first = false
    for i = 1, N do
        for j = 1, N do
            if grid[i][j].obj.Color == Color3.fromRGB(140, 255, 134) then
                open(i, j)
                first = true
                break
            end
        end
        if first then break end
    end
    updateGrid()

    while task.wait(0.2) and not finish do
        if not greedy() then
            print("start sa")
            SA()
        end
    end
end)

-- start()

connectCreate(player.CharacterAdded, function(Character)
    char = Character
end)


-- dragging area
connectCreate(dragButton.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

connectCreate(UserInputService.InputChanged, function(input)
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

connectCreate(UserInputService.InputEnded, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)

connectCreate(UserInputService.InputChanged, function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- collapse button
local collapsed = false
connectCreate(collapseButton.MouseButton1Click, function()
    collapsed = not collapsed
    collapseButton.Text = collapsed and "+" or "-"
    contentFrame.Visible = not collapsed
end)

-- close button
connectCreate(closeButton.MouseButton1Click, function()
    for _, v in ipairs(connections) do
        v:Disconnect()
    end
    screenGui:Destroy()
end)

-- greedy button
connectCreate(greedyButton.MouseButton1Click, function()
    updateGrid()
    greedy()
end)

-- SA button
connectCreate(SAButton.MouseButton1Click, function()
    SA()
end)
