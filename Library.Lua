local Library = {}

local Services = {
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    HttpService = game:GetService("HttpService")
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ViewportSize = workspace.CurrentCamera.ViewportSize

local Theme = {
    Background = Color3.fromRGB(35, 35, 35),
    DarkBackground = Color3.fromRGB(25, 25, 25),
    Header = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(0, 120, 215),
    Hover = Color3.fromRGB(45, 45, 45),
    Click = Color3.fromRGB(50, 50, 50),
    Border = Color3.fromRGB(60, 60, 60),
    Error = Color3.fromRGB(255, 60, 60),
    Success = Color3.fromRGB(60, 255, 60)
}

local Utility = {}

function Utility:Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

function Utility:Tween(instance, tweenInfo, properties)
    local tween = Services.TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:Ripple(object)
    spawn(function()
        local Ripple = Utility:Create("ImageLabel", {
            Name = "Ripple",
            Parent = object,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.0,
            BorderSizePixel = 0,
            Image = "rbxassetid://2708891598",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 9
        })
        
        Ripple.Position = UDim2.new((Mouse.X - Ripple.AbsolutePosition.X) / object.AbsoluteSize.X, 0, (Mouse.Y - Ripple.AbsolutePosition.Y) / object.AbsoluteSize.Y, 0)
        Ripple.Position = UDim2.new(0, Mouse.X - object.AbsolutePosition.X, 0, Mouse.Y - object.AbsolutePosition.Y)
        
        local Size = math.max(object.AbsoluteSize.X, object.AbsoluteSize.Y) * 1.5
        local Tween = Services.TweenService:Create(Ripple, TweenInfo.new(0.5), {Position = UDim2.new(0, Mouse.X - object.AbsolutePosition.X - Size/2, 0, Mouse.Y - object.AbsolutePosition.Y - Size/2), Size = UDim2.new(0, Size, 0, Size), ImageTransparency = 1})
        
        Tween:Play()
        Tween.Completed:Wait()
        Ripple:Destroy()
    end)
end

function Utility:MakeDraggable(topBar, mainFrame)
    local Dragging, DragInput, DragStart, StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        Services.TweenService:Create(mainFrame, TweenInfo.new(0.15), {Position = Position}):Play()
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._connections = {}
    return self
end

function Signal:Connect(callback)
    local connection = {
        Callback = callback,
        Signal = self,
        Connected = true
    }
    table.insert(self._connections, connection)
    return {
        Disconnect = function()
            connection.Connected = false
            for i, v in ipairs(self._connections) do
                if v == connection then
                    table.remove(self._connections, i)
                    break
                end
            end
        end
    }
end

function Signal:Fire(...)
    for _, connection in ipairs(self._connections) do
        if connection.Connected then
            coroutine.wrap(connection.Callback)(...)
        end
    end
end

function Library:Window(options)
    options = options or {}
    local Title = options.Name or "Library"
    local KeySystem = options.KeySystem or false
    local Key = options.Key or ""
    local KeyNote = options.KeyNote or "Enter Key"
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "ZyphLib_" .. tostring(math.random(100000, 999999)),
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local NotificationContainer = Utility:Create("Frame", {
        Name = "Notifications",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 1, -20),
        Size = UDim2.new(0, 300, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })
    
    local NotifLayout = Utility:Create("UIListLayout", {
        Parent = NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 10)
    })

    local MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    
    local Shadow = Utility:Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277)
    })

    local MainCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MainFrame
    })

    local Header = Utility:Create("Frame", {
        Name = "Header",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 35)
    })

    local HeaderCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Header
    })
    
    local HeaderFix = Utility:Create("Frame", {
        Parent = Header,
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -5),
        Size = UDim2.new(1, 0, 0, 5)
    })

    local TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local ControlContainer = Utility:Create("Frame", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 70, 1, 0)
    })
    
    local MinimizeButton = Utility:Create("TextButton", {
        Parent = ControlContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "-",
        TextColor3 = Theme.SubText,
        TextSize = 22
    })
    
    local CloseButton = Utility:Create("TextButton", {
        Parent = ControlContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 35, 0, 0),
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "X",
        TextColor3 = Theme.SubText,
        TextSize = 18
    })
    
    local Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.DarkBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(0, 160, 1, -35)
    })
    
    local SidebarBorder = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0)
    })
    
    local SearchContainer = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 0, 30)
    })
    
    local SearchCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SearchContainer})
    
    local SearchBox = Utility:Create("TextBox", {
        Parent = SearchContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.SourceSans,
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local TabScroll = Utility:Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(1, 0, 1, -50),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent
    })
    
    local TabLayout = Utility:Create("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local TabPadding = Utility:Create("UIPadding", {
        Parent = TabScroll,
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    local ContentContainer = Utility:Create("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 35),
        Size = UDim2.new(1, -160, 1, -35),
        ClipsDescendants = true
    })
    
    local ResizeGrip = Utility:Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 15, 0, 15),
        ZIndex = 10
    })
    
    local GripCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 15), Parent = ResizeGrip})
    
    Utility:MakeDraggable(Header, MainFrame)
    
    local WindowData = {
        IsMinimized = false,
        OldSize = MainFrame.Size,
        Tabs = {},
        CurrentTab = nil
    }
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if WindowData.IsMinimized then
            Utility:Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = WindowData.OldSize})
            MinimizeButton.Text = "-"
            WindowData.IsMinimized = false
            for _, v in pairs(ContentContainer:GetChildren()) do v.Visible = (v == WindowData.CurrentTab.Frame) end
            Sidebar.Visible = true
            ResizeGrip.Visible = true
        else
            WindowData.OldSize = MainFrame.Size
            Sidebar.Visible = false
            for _, v in pairs(ContentContainer:GetChildren()) do v.Visible = false end
            ResizeGrip.Visible = false
            Utility:Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, WindowData.OldSize.X.Offset, 0, 35)})
            MinimizeButton.Text = "+"
            WindowData.IsMinimized = true
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local Resizing = false
    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Resizing = true end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Resizing = false end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local MouseLoc = Services.UserInputService:GetMouseLocation()
            local NewX = math.clamp(MouseLoc.X - MainFrame.AbsolutePosition.X, 400, 1000)
            local NewY = math.clamp(MouseLoc.Y - MainFrame.AbsolutePosition.Y, 300, 800)
            MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
        end
    end)
    
    local function Notify(title, message, duration)
        local NotifFrame = Utility:Create("Frame", {
            Parent = NotificationContainer,
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true
        })
        
        local NotifStroke = Utility:Create("UIStroke", {
            Parent = NotifFrame,
            Color = Theme.Border,
            Thickness = 1
        })
        
        local NotifCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = NotifFrame})
        
        local NotifTitle = Utility:Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.SourceSansBold,
            Text = title,
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NotifMsg = Utility:Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 0, 30),
            Font = Enum.Font.SourceSans,
            Text = message,
            TextColor3 = Theme.SubText,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NotifBar = Utility:Create("Frame", {
            Parent = NotifFrame,
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2)
        })
        
        local CloseNotif = Utility:Create("TextButton", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -25, 0, 5),
            Size = UDim2.new(0, 20, 0, 20),
            Font = Enum.Font.SourceSansBold,
            Text = "X",
            TextColor3 = Theme.SubText,
            TextSize = 14
        })
        
        Utility:Tween(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 65)})
        Utility:Tween(NotifBar, TweenInfo.new(duration or 5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
        
        local Closed = false
        local function Close()
            if Closed then return end
            Closed = true
            local t = Utility:Tween(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
            t.Completed:Wait()
            NotifFrame:Destroy()
        end
        
        CloseNotif.MouseButton1Click:Connect(Close)
        
        task.delay(duration or 5, Close)
    end
    
    local function UpdateSearch(query)
        query = query:lower()
        if WindowData.CurrentTab then
            for _, frame in pairs(WindowData.CurrentTab.Frame:GetChildren()) do
                if frame:IsA("Frame") and frame:FindFirstChild("SearchTag") then
                    local tag = frame.SearchTag.Value:lower()
                    if string.find(tag, query) then
                        frame.Visible = true
                    else
                        frame.Visible = false
                    end
                end
            end
        end
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        UpdateSearch(SearchBox.Text)
    end)
    
    local TabHandler = {}
    
    function TabHandler:Tab(name)
        local TabFrame = Utility:Create("ScrollingFrame", {
            Name = name,
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = false
        })
        
        local TabContentLayout = Utility:Create("UIListLayout", {
            Parent = TabFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
        
        local TabContentPadding = Utility:Create("UIPadding", {
            Parent = TabFrame,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local TabButton = Utility:Create("TextButton", {
            Parent = TabScroll,
            BackgroundColor3 = Theme.DarkBackground,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.SourceSans,
            Text = name,
            TextColor3 = Theme.SubText,
            TextSize = 14
        })
        
        local TabButtonCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = TabButton})
        
        local function Select()
            for _, tab in pairs(WindowData.Tabs) do
                tab.Frame.Visible = false
                Utility:Tween(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.DarkBackground, TextColor3 = Theme.SubText})
            end
            TabFrame.Visible = true
            WindowData.CurrentTab = {Frame = TabFrame, Button = TabButton}
            Utility:Tween(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover, TextColor3 = Theme.Text})
            UpdateSearch(SearchBox.Text)
        end
        
        TabButton.MouseButton1Click:Connect(Select)
        
        if #WindowData.Tabs == 0 then
            Select()
        end
        
        table.insert(WindowData.Tabs, {Frame = TabFrame, Button = TabButton})
        
        local ElementHandler = {}
        
        local function AddTag(obj, text)
            local tag = Instance.new("StringValue")
            tag.Name = "SearchTag"
            tag.Value = text
            tag.Parent = obj
        end
        
        function ElementHandler:Label(text)
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            AddTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        function ElementHandler:Button(text, callback)
            callback = callback or function() end
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            })
            AddTag(Frame, text)
            
            local Btn = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14
            })
            
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Btn})
            Utility:Create("UIStroke", {Parent = Btn, Color = Theme.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
            
            Btn.MouseEnter:Connect(function()
                Utility:Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Click})
            end)
            
            Btn.MouseLeave:Connect(function()
                Utility:Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover})
            end)
            
            Btn.MouseButton1Click:Connect(function()
                Utility:Ripple(Btn)
                task.spawn(callback)
            end)
        end
        
        function ElementHandler:Toggle(text, default, callback)
            callback = callback or function() end
            local Toggled = default or false
            
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            })
            AddTag(Frame, text)
            
            local Btn = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local Label = Utility:Create("TextLabel", {
                Parent = Btn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 28, 0, 0),
                Size = UDim2.new(1, -28, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local CheckBox = Utility:Create("Frame", {
                Parent = Btn,
                BackgroundColor3 = Toggled and Theme.Accent or Theme.Hover,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18)
            })
            
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = CheckBox})
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Utility:Tween(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Theme.Accent or Theme.Hover})
                task.spawn(callback, Toggled)
            end)
        end
        
        function ElementHandler:Slider(text, min, max, default, callback)
            callback = callback or function() end
            local Value = math.clamp(default or min, min, max)
            
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            AddTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = tostring(Value),
                TextColor3 = Theme.SubText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SlideTrack = Utility:Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 28),
                Size = UDim2.new(1, 0, 0, 6)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = SlideTrack})
            
            local SlideFill = Utility:Create("Frame", {
                Parent = SlideTrack,
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = SlideFill})
            
            local Trigger = Utility:Create("TextButton", {
                Parent = SlideTrack,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local Dragging = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - SlideTrack.AbsolutePosition.X) / SlideTrack.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + ((max - min) * pos))
                Value = newVal
                ValueLabel.Text = tostring(Value)
                Utility:Tween(SlideFill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)})
                task.spawn(callback, Value)
            end
            
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    Update(input)
                end
            end)
            
            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            Services.UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end
        
        function ElementHandler:Dropdown(text, list, callback)
            callback = callback or function() end
            local IsOpen = false
            
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                ZIndex = 5
            })
            AddTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local MainButton = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, 0, 0, 26),
                Font = Enum.Font.SourceSans,
                Text = "  Select...",
                TextColor3 = Theme.SubText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = MainButton})
            Utility:Create("UIStroke", {Parent = MainButton, Color = Theme.Border, Thickness = 1})
            
            local Arrow = Utility:Create("TextLabel", {
                Parent = MainButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = "+",
                TextColor3 = Theme.SubText,
                TextSize = 18
            })
            
            local DropContainer = Utility:Create("Frame", {
                Parent = MainButton,
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 2),
                Size = UDim2.new(1, 0, 0, 0),
                ClipsDescendants = true,
                ZIndex = 10,
                Visible = false
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DropContainer})
            Utility:Create("UIStroke", {Parent = DropContainer, Color = Theme.Border, Thickness = 1})
            
            local DropLayout = Utility:Create("UIListLayout", {
                Parent = DropContainer,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            for _, item in pairs(list) do
                local ItemBtn = Utility:Create("TextButton", {
                    Parent = DropContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    Font = Enum.Font.SourceSans,
                    Text = "  " .. item,
                    TextColor3 = Theme.SubText,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11
                })
                
                ItemBtn.MouseEnter:Connect(function() ItemBtn.TextColor3 = Theme.Text ItemBtn.BackgroundColor3 = Theme.Click end)
                ItemBtn.MouseLeave:Connect(function() ItemBtn.TextColor3 = Theme.SubText ItemBtn.BackgroundTransparency = 1 end)
                
                ItemBtn.MouseButton1Click:Connect(function()
                    MainButton.Text = "  " .. item
                    IsOpen = false
                    Arrow.Text = "+"
                    DropContainer.Visible = false
                    Utility:Tween(DropContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.spawn(callback, item)
                end)
            end
            
            MainButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    Arrow.Text = "-"
                    DropContainer.Visible = true
                    local height = math.min(#list * 26, 150)
                    Utility:Tween(DropContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, height)})
                else
                    Arrow.Text = "+"
                    local t = Utility:Tween(DropContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    t.Completed:Wait()
                    if not IsOpen then DropContainer.Visible = false end
                end
            end)
        end
        
        function ElementHandler:Colorpicker(text, default, callback)
            callback = callback or function() end
            default = default or Color3.new(1, 1, 1)
            
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                ZIndex = 4
            })
            AddTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Preview = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -40, 0.5, -9),
                Size = UDim2.new(0, 40, 0, 18),
                Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Preview})
            
            local PickerFrame = Utility:Create("Frame", {
                Parent = ScreenGui,
                BackgroundColor3 = Theme.Background,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 180, 0, 150),
                Visible = false,
                ZIndex = 50
            })
            Utility:Create("UIStroke", {Parent = PickerFrame, Color = Theme.Border, Thickness = 2})
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = PickerFrame})
            
            local function CreateGradientSlider(name, y, gradient, updateFunc)
                local Bg = Utility:Create("Frame", {
                    Parent = PickerFrame,
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 10, 0, y),
                    Size = UDim2.new(0, 160, 0, 10),
                    ZIndex = 51
                })
                local Grad = Utility:Create("UIGradient", {Parent = Bg, Color = gradient})
                local Ind = Utility:Create("Frame", {Parent = Bg, BackgroundColor3 = Color3.new(1,1,1), BorderColor3 = Color3.new(0,0,0), Size = UDim2.new(0, 2, 1, 4), Position = UDim2.new(0,0,0,-2), ZIndex = 52})
                local Trig = Utility:Create("TextButton", {Parent = Bg, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text="", ZIndex = 53})
                
                local dragging = false
                Trig.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateFunc(i, Ind, Bg) end end)
                Services.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                Services.UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateFunc(i, Ind, Bg) end end)
                return Ind
            end
            
            local h, s, v = default:ToHSV()
            local function UpdateColor()
                local c = Color3.fromHSV(h, s, v)
                Preview.BackgroundColor3 = c
                task.spawn(callback, c)
            end
            
            local hInd = CreateGradientSlider("Hue", 15, ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2,1,1)),
                ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4,1,1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6,1,1)),
                ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
            }, function(i, ind, bg)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
                ind.Position = UDim2.new(p, -1, 0, -2)
                h = p
                UpdateColor()
            end)
            
            local sInd = CreateGradientSlider("Sat", 40, ColorSequence.new(Color3.new(1,1,1), Color3.new(1,0,0)), function(i, ind, bg)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
                ind.Position = UDim2.new(p, -1, 0, -2)
                s = p
                UpdateColor()
            end)
            
            local vInd = CreateGradientSlider("Val", 65, ColorSequence.new(Color3.new(0,0,0), Color3.new(1,1,1)), function(i, ind, bg)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
                ind.Position = UDim2.new(p, -1, 0, -2)
                v = p
                UpdateColor()
            end)
            
            local DoneBtn = Utility:Create("TextButton", {
                Parent = PickerFrame,
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 110),
                Size = UDim2.new(0, 160, 0, 30),
                Font = Enum.Font.SourceSans,
                Text = "Confirm",
                TextColor3 = Theme.Text,
                TextSize = 14,
                ZIndex = 51
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = DoneBtn})
            
            DoneBtn.MouseButton1Click:Connect(function() PickerFrame.Visible = false end)
            
            Preview.MouseButton1Click:Connect(function()
                PickerFrame.Position = UDim2.new(0, Preview.AbsolutePosition.X + 50, 0, Preview.AbsolutePosition.Y)
                PickerFrame.Visible = true
            end)
        end

        function ElementHandler:Keybind(text, default, callback)
            callback = callback or function() end
            local Binding = false
            
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            })
            AddTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local BindBtn = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -80, 0.5, -11),
                Size = UDim2.new(0, 80, 0, 22),
                Font = Enum.Font.SourceSans,
                Text = default and default.Name or "None",
                TextColor3 = Theme.SubText,
                TextSize = 14
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = BindBtn})
            
            BindBtn.MouseButton1Click:Connect(function()
                Binding = true
                BindBtn.Text = "..."
                BindBtn.TextColor3 = Theme.Accent
            end)
            
            Services.UserInputService.InputBegan:Connect(function(input)
                if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    Binding = false
                    BindBtn.Text = input.KeyCode.Name
                    BindBtn.TextColor3 = Theme.SubText
                    task.spawn(callback, input.KeyCode)
                end
            end)
        end
        
        function ElementHandler:Textbox(text, placeholder, callback)
            callback = callback or function() end
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            AddTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Input = Utility:Create("TextBox", {
                Parent = Frame,
                BackgroundColor3 = Theme.DarkBackground,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 20),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                PlaceholderText = placeholder or "",
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 14
            })
            
            Input.FocusLost:Connect(function(enter)
                if enter then
                    task.spawn(callback, Input.Text)
                end
            end)
        end
        
        return ElementHandler
    end
    
    local function LoadMain()
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Utility:Tween(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
        Notify("Welcome", "Library loaded successfully.", 5)
    end
    
    if KeySystem then
        local KeyFrame = Utility:Create("Frame", {
            Name = "KeySystem",
            Parent = ScreenGui,
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -150, 0.5, -75),
            Size = UDim2.new(0, 300, 0, 150),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ClipsDescendants = true
        })
        
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeyFrame})
        Utility:Create("UIStroke", {Parent = KeyFrame, Color = Theme.Border, Thickness = 2})
        Utility:MakeDraggable(KeyFrame, KeyFrame)
        
        local KeyTitle = Utility:Create("TextLabel", {
            Parent = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 10),
            Size = UDim2.new(1, 0, 0, 20),
            Font = Enum.Font.SourceSansBold,
            Text = "Verification Required",
            TextColor3 = Theme.Text,
            TextSize = 18
        })
        
        local KeyNoteLbl = Utility:Create("TextLabel", {
            Parent = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.SourceSans,
            Text = KeyNote,
            TextColor3 = Theme.SubText,
            TextSize = 14
        })
        
        local KeyInput = Utility:Create("TextBox", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.DarkBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0.1, 0, 0.45, 0),
            Size = UDim2.new(0.8, 0, 0, 30),
            Font = Enum.Font.SourceSans,
            PlaceholderText = "Enter Key here...",
            Text = "",
            TextColor3 = Theme.Text,
            TextSize = 14
        })
        
        local KeySubmit = Utility:Create("TextButton", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.Hover,
            BorderSizePixel = 0,
            Position = UDim2.new(0.2, 0, 0.75, 0),
            Size = UDim2.new(0.6, 0, 0, 28),
            Font = Enum.Font.SourceSans,
            Text = "Submit",
            TextColor3 = Theme.Text,
            TextSize = 14
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = KeySubmit})
        
        local ExitKey = Utility:Create("TextButton", {
            Parent = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -25, 0, 5),
            Size = UDim2.new(0, 20, 0, 20),
            Text = "X",
            TextColor3 = Theme.SubText,
            TextSize = 16
        })
        ExitKey.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
        
        KeySubmit.MouseButton1Click:Connect(function()
            if KeyInput.Text == Key then
                Utility:Tween(KeyFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
                task.wait(0.3)
                KeyFrame:Destroy()
                LoadMain()
            else
                KeySubmit.Text = "Incorrect"
                KeySubmit.TextColor3 = Theme.Error
                task.wait(1)
                KeySubmit.Text = "Submit"
                KeySubmit.TextColor3 = Theme.Text
            end
        end)
    else
        LoadMain()
    end
    
    Services.UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return TabHandler, Notify, ScreenGui
end

return Library
