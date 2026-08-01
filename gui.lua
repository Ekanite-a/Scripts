local SimpleGui = {}
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local coregui = (gethui and gethui()) or game:GetService("CoreGui")

local randGen = Random.new()
local function randStr(len)
    local t = table.create(len)
    for i = 1, len do t[i] = string.char(randGen:NextInteger(32, 126)) end
    return table.concat(t)
end

local function initialInstance(settings)
    local instance = Instance.new(settings.Instance)
    if settings.Settings then
        for k, v in next, settings.Settings do instance[k] = v end
    end
    instance.Parent = settings.Parent
    return instance
end

local function createCountUp()
    local cnt = 0
    return function ()
        cnt += 1
        return cnt
    end
end


local BaseMethods = {}
function BaseMethods:SetOnDestroy(OnDestroy)
    self.OnDestroy = OnDestroy
end
function BaseMethods:Destroy()
    if self.Children then
        for _, child in next, self.Children do child:Destroy() end
    end

    if self.OnDestroy then self.OnDestroy() end

    if self._conns then
        for _, conn in next, self._conns do if conn then conn:Disconnect() end end
        table.clear(self._conns)
    end

    if self._instance then self._instance:Destroy() end
    if self._frame then self._frame:Destroy() end

    if self.Parent and self.Parent.Children then
        self.Parent.Children[self.Name] = nil
    end

    table.clear(self)
end
function BaseMethods:Bind(event, callback)
    local conn = event:Connect(callback)
    table.insert(self._conns, conn)
    return conn
end
function BaseMethods:BindToHeartbeat(callback)
    return self:Bind(RunService.Heartbeat, callback)
end


local ButtonMethods = {}
setmetatable(ButtonMethods, {__index = BaseMethods})


local ToggleMethods = {}
setmetatable(ToggleMethods, {__index = BaseMethods})
function ToggleMethods:Update(State, Sneakly)
    self.Value = State
    if State then self._instance.Text = self.Name .. ": On"
    else self._instance.Text = self.Name .. ": Off" end

    if not Sneakly then self.Callback(self.Text) end
end


local InputMethods = {}
setmetatable(InputMethods, {__index = BaseMethods})
function InputMethods:Update(Text, Sneakly)
    self.Text = Text
    self._instance.Text = Text
    if not Sneakly then self.Callback(self.Text) end
end


local ContainerMethods = {}
setmetatable(ContainerMethods, {__index = BaseMethods})
function ContainerMethods:CreateButton(settings)
    local button = {
        Name = settings.Name,
        Type = "button",
        Parent = self,
        root = self.root,
        _conns = {},
    }
    setmetatable(button, {__index = ButtonMethods})

    button._instance = initialInstance({
        Instance = "TextButton", Parent = self._frame,
        Settings = {
            Name = randStr(10),
            Text = settings.Name,
            Size = UDim2.new(0.9, 0, 0, 30),
            LayoutOrder = self._getLayout(),
        }
    })

    button:Bind(button._instance.Activated, function()
        if settings.Callback then settings.Callback() end
    end)

    self.Children[settings.Name] = button
    return button
end
function ContainerMethods:CreateToggle(settings)
    local toggle = {
        Name = settings.Name,
        Type = "toggle",
        Value = settings.Value or false,
        Parent = self,
        root = self.root,
        _conns = {},
    }
    setmetatable(toggle, {__index = ToggleMethods})

    toggle._instance = initialInstance({
        Instance = "TextButton", Parent = self._frame,
        Settings = {
            Name = randStr(10),
            Text = settings.Name .. ": " .. (toggle.Value and "On" or "Off"),
            Size = UDim2.new(0.9, 0, 0, 30),
            LayoutOrder = self._getLayout(),
        }
    })

    toggle:Bind(toggle._instance.Activated, function()
        toggle.Value = not toggle.Value
        toggle._instance.Text = toggle.Name .. ": " .. (toggle.Value and "On" or "Off")
        if settings.Callback then settings.Callback(toggle.Value) end
    end)

    self.Children[settings.Name] = toggle
    return toggle
end
function ContainerMethods:CreateInput(settings)
    local input = {
        Name = settings.Name,
        Type = "input",
        Text = "",
        Parent = self,
        root = self.root,
        _conns = {},
    }
    setmetatable(input, {__index = InputMethods})

    input._instance = initialInstance({
        Instance = "TextBox", Parent = self._frame,
        Settings = {
            Name = randStr(10),
            Text = settings.Text or "",
            PlaceholderText = settings.Placeholder or "",
            Size = UDim2.new(0.9, 0, 0, 30),
            PlaceholderColor3 = Color3.fromRGB(27, 42, 53),
            LayoutOrder = self._getLayout(),
        }
    })

    input:Bind(input._instance.FocusLost, function(enterPressed)
        input.Text = input._instance.Text
        if enterPressed and settings.Callback then settings.Callback(input.Text) end
    end)

    self.Children[settings.Name] = input
    return input
end
function ContainerMethods:CreatePage(settings)
    local page = {
        Name = settings.Name,
        Type = "page",
        Children = {},
        Parent = self,
        root = self.root,
        _getLayout = createCountUp(),
        _conns = {},
    }
    setmetatable(page, {__index = ContainerMethods})

    page._instance = initialInstance({
        Instance = "TextButton", Parent = self._frame,
        Settings = {
            Name = randStr(10),
            Text = settings.Name .. " >",
            Size = UDim2.new(0.9, 0, 0, 30),
            LayoutOrder = self._getLayout(),
        }
    })

    page._frame = initialInstance({
        Instance = "ScrollingFrame", Parent = self.root._container,
        Settings = {
            Name = randStr(20),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(240, 240, 240),
            ScrollBarThickness = 6,
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
        }
    })
    initialInstance({
        Instance = "UIListLayout", Parent = page._frame,
        Settings = {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }
    })
    initialInstance({
        Instance = "UIPadding", Parent = page._frame,
        Settings = {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        }
    })

    page:Bind(page._instance.Activated, function() self.root:PushPage(page) end)

    self.Children[settings.Name] = page
    return page
end


function SimpleGui:CreateWindow(windowSettings)
    local window = {
        Name = windowSettings.Name or "Window",
        Type = "window",
        Children = {},
        _getLayout = createCountUp(),
        _pageStack = {},
        _conns = {},
    }
    window.root = window
    window.Parent = window
    setmetatable(window, {__index = ContainerMethods})

    window._instance = initialInstance({Instance = "ScreenGui", Parent = coregui, Settings = {Name = randStr(20), ResetOnSpawn = false}})

    local mainFrame = initialInstance({Instance = "Frame", Parent = window._instance, Settings = {
        Size = UDim2.new(0, 200, 0, 150), Position = UDim2.new(0.5, -100, 0.5, -75), BackgroundTransparency = 1
    }})
    local topBar = initialInstance({Instance = "Frame", Parent = mainFrame, Settings = {
        Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    }})
    local dragButton = initialInstance({Instance = "TextButton", Parent = topBar, Settings = {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), Text = "", BackgroundColor3 = Color3.fromRGB(200, 200, 200), ZIndex = 1
    }})
    local titleLabel = initialInstance({Instance = "TextLabel", Parent = topBar, Settings = {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), Text = window.Name, BackgroundTransparency = 1, ZIndex = 2
    }})
    local backButton = initialInstance({Instance = "TextButton", Parent = topBar, Settings = {
        Size = UDim2.new(0, 25, 1, 0), Position = UDim2.new(0, 5, 0, 0), Text = "<", BackgroundTransparency = 1, Visible = false, ZIndex = 3
    }})
    local collapseButton = initialInstance({Instance = "TextButton", Parent = topBar, Settings = {
        Size = UDim2.new(0, 25, 1, 0), Position = UDim2.new(1, -50, 0, 0), Text = "-", BackgroundTransparency = 1, ZIndex = 3
    }})
    local closeButton = initialInstance({Instance = "TextButton", Parent = topBar, Settings = {
        Size = UDim2.new(0, 25, 1, 0), Position = UDim2.new(1, -25, 0, 0), Text = "X", BackgroundTransparency = 1, ZIndex = 3
    }})
    window._container = initialInstance({Instance = "Frame", Parent = mainFrame, Settings = {
        Size = UDim2.new(1, 0, 1, -25), Position = UDim2.new(0, 0, 0, 25)
    }})
    window._frame = initialInstance({Instance = "ScrollingFrame", Parent = window._container, Settings = {
        Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        ScrollBarThickness = 6, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, BorderSizePixel = 0
    }})
    initialInstance({Instance = "UIListLayout", Parent = window._frame, Settings = {Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder}})
    initialInstance({Instance = "UIPadding", Parent = window._frame, Settings = {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)}})

    function window:PushPage(pageObject)
        local currentTop = #self._pageStack > 0 and self._pageStack[#self._pageStack]._frame or self._frame

        currentTop.Visible = false
        table.insert(self._pageStack, pageObject)
        pageObject._frame.Visible = true
        titleLabel.Text = pageObject.Name
        backButton.Visible = true
    end

    function window:PopPage()
        if #self._pageStack == 0 then return end
        local poppedPage = table.remove(self._pageStack)
        poppedPage._frame.Visible = false

        local newTop = #self._pageStack > 0 and self._pageStack[#self._pageStack] or nil
        if newTop then
            newTop._frame.Visible = true
            titleLabel.Text = newTop.Name
        else
            self._frame.Visible = true
            titleLabel.Text = self.Name
            backButton.Visible = false
        end
    end

    window:Bind(backButton.Activated, function() window:PopPage() end)

    local dragStart, dragInput, startPos
    window:Bind(dragButton.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragInput, dragStart, startPos = input, input.Position, mainFrame.Position
            local changeConn; changeConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragInput = nil
                    changeConn:Disconnect()
                end
            end)
        end
    end)
    window:Bind(UIS.InputChanged, function(input)
        if input == dragInput then
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X,
                startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y
            )
        end
    end)

    local collapsed = false
    window:Bind(collapseButton.Activated, function()
        collapsed = not collapsed
        collapseButton.Text = collapsed and "+" or "-"
        window._container.Visible = not collapsed
    end)

    window:Bind(closeButton.Activated, function() window:Destroy() end)

    return window
end

return SimpleGui
