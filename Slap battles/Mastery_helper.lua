local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local window = WindUI:CreateWindow({
    Title = "This is outdated",
    Icon = "moon-star",
    Author = "Ekanite",
})

local mainTab = window:Tab({
    Title = "Main",
    Icon = "geist:home",
    Locked = false,
})

local newScriptButton = mainTab:Button({
    Title = "click to copy",
    Desc = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Ekanite-a/Scripts/refs/heads/main/loader.lua"))()',
    IconAlign = "Left",
    Locked = false,
    Callback = function() setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/Ekanite-a/Scripts/refs/heads/main/loader.lua"))()') end,
})