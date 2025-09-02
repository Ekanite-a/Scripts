-- using greedy and simulated annealing
-- not finished yet
local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local minesweeper = workspace:WaitForChild("objects"):WaitForChild("minesweeper")


local fcd = fireclickdetector

local copy = newcclosure(function(orig, copies) -- omg why i have to do this myself
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
local grid = {}
for i = 1, N do
    grid[i] = {}
end
local Parts = minesweeper:WaitForChild("CELLS"):GetChildren()
table.sort(Parts, function(a, b)
    return tonumber(a.Name:gsub("Part", "")) < tonumber(b.Name:gsub("Part", ""))
end)

local id = 1
local updateGrid = newcclosure(function()
    id = 1
    for i = 1, N do
        for j = 1, N do
            grid[i][j] = {
                state = (Parts[id].Color == Color3.fromRGB(255, 255, 255)) and 0 or (Parts[id]:FindFirstChild("NumberGui") and (Parts[id].NumberGui.TextLabel.Text ~= "🚩" and tonumber(Parts[id].NumberGui.TextLabel.Text) or -2) or -1),
                obj = Parts[id]
            }
            id = id + 1
        end
    end
end)


local open = newcclosure(function(y, x)
    if grid[y][x].state ~= -1 then return end

    fcd(grid[y][x].obj.ClickDetector)
    updateGrid()
end)


local flag = newcclosure(function(y, x)
    if grid[y][x].state ~= -1 then return end

    minesweeper.FlagModeChange:FireServer()
    fcd(grid[y][x].obj.ClickDetector)
    minesweeper.FlagModeChange:FireServer()
    grid[y][x].state = -2
end)


local dy = {-1, 0, 1, -1, 1, -1, 0, 1}; local dx = {-1, 0, 1, -1, 1, -1, 0, 1}
local greedy = newcclosure(function()
    local upd = false;
    local flagged; local blank = {}

    for i = 1, N do
        for j = 1, N do
            flagged = 0
            for k = 1, 8 do
                if grid[i + dy[k]] and grid[i + dy[k]][j + dx[k]] then
                    if grid[i + dy[k]][j + dx[k]].state == -2 then
                        flagged = flagged + 1
                    elseif grid[i + dy[k]][j + dx[k]].state == -1 then
                        table.insert(blank, {i + dy[k], j + dx[k]})
                    end
                end
            end

            if grid[i][j].state - flagged == 0 and #blank > 0 then
                upd = true
                for _, v in ipairs(blank) do
                    open(v[1], v[2])
                end
            elseif grid[i][j].state == #blank then
                upd = true
                for _, v in ipairs(blank) do
                    flag(v[1], v[2])
                end
            end
            table.clear(blank)
        end
    end

    return upd
end)

local tmpGrid
local calEnergy = newcclosure(function(state)
    local E = 0
    local totalMine, totalPredicted, predicted, flagged = tonumber(minesweeper.INTERFACE.Flags.SurfaceGui.Number), 0, 0, 0

    tmpGrid = copy(grid)
    for _, v in ipairs(state) do
        if v.mine then
            tmpGrid[v.y][v.x].state = -3
            totalPredicted = totalPredicted + 1
        end
    end

    for _, u in ipairs(state) do
        for i = 1, 8 do
            local ny, nx = u.y + dy[i], u.x + dx[i]
            if tmpGrid[ny] and tmpGrid[ny][nx] and tmpGrid[ny][nx].state >= 1 then
                predicted, flagged = 0, 0
                
                for j = 1, 8 do
                    local nny, nnx = ny + dy[j], nx + dx[j]
                    if tmpGrid[nny] and tmpGrid[nny][nnx] then
                        if tmpGrid[nny][nnx].state == -2 then
                            flagged = flagged + 1
                        elseif tmpGrid[nny][nnx].state == -3 then
                            predicted = predicted + 1
                        end
                    end
                end

                E = E + (predicted - (tmpGrid[ny][nx].state - flagged))^2
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
    if #tabu >= #state / 10 then table.remove(tabu, 1) end

    state[randomId].mine = not state[randomId].mine
end)

local state = {}; local data = {}; local finish = false
local thin = 5; local burn_in = 500
local SA = newcclosure(function()
    local T = 1;
    for i = 1, N do
        for j = 1, N do
            if grid[i][j].obj.Color == Color3.new(255, 0, 0) then finish = true end
            if grid[i][j].state == -1 then
                table.insert(state, {y = i, x = j, mine = false})
                table.insert(data, {y = i, x = j, mineP = 0})
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
        task.wait()
    end

    for i = 1, 500 * #state do
        flip(state)

        if i % thin == 0 then
            NewE = calEnergy(state)
            deltaE = NewE - CurE

            if deltaE < 0 or math.random() < math.exp(-deltaE / T) then
                CurE = NewE
                for j = 1, #state do
                    data[j].mineP = data[j].mineP + ((state[j].mine and 1) or 0)
                end
            end
        end

        T = 1 / math.log(2 + i / #state)
        task.wait()
    end

    local samples = 500 * #state / thin
    for _, v in ipairs(data) do
        if v.mineP / samples < 0.05 then
            open(v.y, v.x)
        elseif v.mineP / samples > 0.95 then
            flag(v.y, v.x)
        end
    end
end)


local start = newcclosure(function()
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

    while task.wait() and not finish do
        if not greedy() then
            SA()
        end
    end
end)



start() -- Let's goooo
