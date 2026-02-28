local createButton = loadstring(game:HttpGet("https://pastefy.app/2uZzncgf/raw"))()


createButton("Speedy Sam quest", function()
    local workspace = game:GetService("Workspace")
    local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    for i, v in next, workspace.Fih:GetChildren() do
        if v:FindFirstChild("Fish") then
            firetouchinterest(hrp, v.Fish, 0)
            firetouchinterest(hrp, v.Fish, 1)
        end
    end

    firetouchinterest(hrp, workspace.FinishPart, 0)
end)

createButton("Smaet Aleck quest", function()
    local workspace = game:GetService("Workspace")
    local lp = game:GetService("Players").LocalPlayer
    local char = lp.Character
    local hrp = char.HumanoidRootPart
    local fpp = function(proximity, sec)
    hrp.CFrame = proximity.Parent:GetPivot()
        task.wait(sec or 1)
        fireproximityprompt(proximity)
    end

    local acc = {}
    for i, v in next, workspace.Snowman.Models.DisplaySnowman.Accessories:GetDescendants () do
        if v.Name == "Handle" and v.Transparency == 0 then
            table.insert(acc, workspace.Accessories:FindFirstChild(v.Parent.Name). ProximityPrompt)
        end
    end

    local playerSnowman = workspace.Snowman.Models.PlayerSnowman.ProximityPrompt

    fpp(workspace.Interactables.SnowObject.ProximityPrompt, 0.5)
    char.Humanoid:EquipTool(lp.Backpack:WaitForChild("Snow"))
    for i = 1, 3 do fpp(playerSnowman) end

    for i, v in acc do
        fpp(v, 0.5)
        fpp(playerSnowman)
    end
end)

createButton("Claim", function()
    fireproximityprompt(game:GetService("workspace").Chest.Bottom.MetalBottom.Attachment.ProximityPrompt)
end)

local ids = {
    86643839793301,
    95356852680586,
    113228834069218
}

qtp = queue_on_teleport or queueonteleport
if table.find(ids, game.PlaceId) then
    qtp([[loadstring(game:HttpGet("https://raw.githubusercontent.com/Ekanite-a/Scripts/refs/heads/main/Slap%20battles/snowman.lua"))()]])
end