-- using greedy and simulated annealing + tabu search
-- not finished yet, still have some bugs
local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local minesweeper = workspace:WaitForChild("objects"):WaitForChild("minesweeper")


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
                state = (Parts[id].Color == Color3.fromRGB(255, 255, 255) and (Parts[id]:FindFirstChild("NumberGUI") and tonumber(Parts[id].NumberGUI:WaitForChild("TextLabel", 2).Text) or 0)) or ((Parts[id]:FindFirstChild("NumberGUI") or (flagged_pos[i][j] == 1)) and -2 or -1),
                obj = Parts[id]
            }
            flagged_pos[i][j] = 0
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

    flagged_pos[x][y] = 1
    grid[x][y].state = -2; grid[x][y].obj.Color = Color3.fromRGB(0, 0, 0)
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
                        if grid[i + dx[k]][j + dy[k]].state == -2 or flagged_pos[i + dx[k]][j + dy[k]] == 1 then
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

    for _, u in ipairs(state) do
        for i = 1, 8 do
            local nx, ny = u.x + dx[i], u.y + dy[i]
            if tmpGrid[ny] and tmpGrid[ny][nx] and tmpGrid[ny][nx].state >= 1 then
                predicted, flagged = 0, 0
                
                for j = 1, 8 do
                    local nnx, nny = nx + dx[j], ny + dy[j]
                    if tmpGrid[nnx] and tmpGrid[nnx][nny] then
                        if tmpGrid[nnx][nny].state == -2 or flagged_pos[nnx][nny] == 1 then
                            flagged = flagged + 1
                        elseif tmpGrid[nnx][nny].state == -3 then
                            predicted = predicted + 1
                        end
                    end
                end

                E = E + (predicted - (tmpGrid[nx][ny].state - flagged))^2
            end
        end
    end

    return E + 1E6 * math.max(0, totalPredicted - totalMine)
end)

local randomId; local tabu = {}
local flip = newcclosure(function(state)
    repeat
        randomId = math.random(1, #state)
    until not table.find(tabu, randomId)
    table.insert(tabu, randomId)
    if #tabu >= #state // 10 then table.remove(tabu, 1) end

    state[randomId].mine = not state[randomId].mine
end)

local state = {}; local data = {}; local finish = false
local thin = 5; local burn_in = 500
local SA = newcclosure(function()
    local T = 1;
    table.clear(tabu)
    updateGrid()
    for i = 1, N do
        for j = 1, N do
            if grid[i][j].obj.Color == Color3.fromRGB(255, 0, 0) then finish = true end
            if grid[i][j].state == -1 and flagged_pos then
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

    for i = 1, 1000 + 10 * #state do
        flip(state)

        if i % thin == 0 then
            NewE = calEnergy(state)
            deltaE = NewE - CurE

            if deltaE < 0 or math.random() < math.exp(-deltaE / T) then
                CurE = NewE
                for j = 1, #state do
                    data[j].times = data[j].times + ((state[j].mine and 1) or 0)
                end
            end
        end

        T = T * 0.99
        if i % 100 == 0 then task.wait() end
    end

    local samples = (1000 + 10 * #state) / thin
    for _, v in ipairs(data) do
        if v.times / samples < 0.05 then
            open(v.x, v.y)
        elseif v.times / samples > 0.95 then
            flag(v.x, v.y)
        end
    end
    
    minesweeper.FlagModeChange:InvokeServer()
    task.wait(0.5)
    for i = 1, N do
        for j = 1, N do
            if flagged_pos[i][j] == 1 then
                fcd(grid[v.x][v.y].obj.ClickDetector)
                flagged_pos[i][j] = 0
            end
        end
    end
    task.wait(2)
    minesweeper.FlagModeChange:InvokeServer()
    task.wait(3)

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



start()
print("finish")
