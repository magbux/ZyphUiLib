local Library = {}

--// SERVICES I ADDED THESE COMMENTS SO U CAN UNDERSTAND
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

--// LOCAL PLAYER
local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ViewportSize = workspace.CurrentCamera.ViewportSize

--// THEME MANAGER (Classic Colors)
local ThemeManager = {}
ThemeManager.Colors = {
    Main = Color3.fromRGB(46, 46, 46),       -- Main Background
    Header = Color3.fromRGB(36, 36, 36),     -- Darker Header
    Sidebar = Color3.fromRGB(54, 54, 54),    -- Sidebar
    Content = Color3.fromRGB(46, 46, 46),    -- Content Match Main
    Text = Color3.fromRGB(255, 255, 255),    -- White Text
    SubText = Color3.fromRGB(200, 200, 200), -- Light Gray
    Accent = Color3.fromRGB(0, 120, 215),    -- Classic Blue Accent
    Outline = Color3.fromRGB(20, 20, 20),    -- Dark Borders
    Item = Color3.fromRGB(60, 60, 60),       -- Buttons/Inputs
    Hover = Color3.fromRGB(70, 70, 70),      -- Hover State
    Click = Color3.fromRGB(80, 80, 80),      -- Click State
    Warning = Color3.fromRGB(255, 100, 100)  -- Red Warning
}

--// UTILITY FUNCTIONS
local Utility = {}

function Utility:GetTextSize(text, font, size, maxWidth)
    if not text or not font or not size then return Vector2.new(0,0) end
    return Services.TextService:GetTextSize(text, size, font, Vector2.new(maxWidth or 99999, 99999))
end

function Utility:Create(className, properties)
    local instance = Instance.new(className)
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
    task.spawn(function()
        local Ripple = Utility:Create("Frame", {
            Name = "Ripple",
            Parent = object,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 10
        })
        
        local Tween = Services.TweenService:Create(Ripple, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        Tween:Play()
        Tween.Completed:Wait()
        Ripple:Destroy()
    end)
end

function Utility:MakeDraggable(trigger, object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            local TargetPosition = UDim2.new(
                StartPosition.X.Scale, 
                StartPosition.X.Offset + Delta.X, 
                StartPosition.Y.Scale, 
                StartPosition.Y.Offset + Delta.Y
            )
            Services.TweenService:Create(object, TweenInfo.new(0.0), {Position = TargetPosition}):Play()
        end
    end)
end

--// SNOW SYSTEM
local SnowSystem = {}
function SnowSystem:Start(parent)
    if SnowSystem.Running then return end
    SnowSystem.Running = true
    
    task.spawn(function()
        while SnowSystem.Running do
            if not parent.Parent then break end
            local Flake = Utility:Create("Frame", {
                Parent = parent,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(math.random(), 0, -0.1, 0),
                Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4)),
                BackgroundTransparency = math.random(2, 6) / 10,
                ZIndex = 0
            })
            
            -- Round the snowflake slightly
            Utility:Create("UICorner", {Parent = Flake, CornerRadius = UDim.new(1,0)})
            
            local Duration = math.random(3, 6)
            local TargetPos = UDim2.new(Flake.Position.X.Scale + (math.random(-10, 10)/100), 0, 1.1, 0)
            
            local T = Services.TweenService:Create(Flake, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Position = TargetPos})
            T:Play()
            T.Completed:Connect(function() Flake:Destroy() end)
            
            task.wait(0.1)
        end
    end)
end

function SnowSystem:Stop()
    SnowSystem.Running = false
end

--// MAIN WINDOW FUNCTION
function Library:Window(options)
    local WindowTitle = options.Name or "Classic Lib"
    
    -- Main ScreenGui (Persist after death)
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "ClassicLibrary_" .. tostring(math.random(100000, 999999)),
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })

    -- Notification Container
    local NotificationContainer = Utility:Create("Frame", {
        Name = "NotificationContainer",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -250, 1, -20),
        Size = UDim2.new(0, 230, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })

    local NotificationLayout = Utility:Create("UIListLayout", {
        Parent = NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 5)
    })

    -- Main Frame (Square, Sharp, Classic)
    local MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = ThemeManager.Colors.Main,
        BorderSizePixel = 1,
        BorderColor3 = ThemeManager.Colors.Outline,
        Position = UDim2.new(0.5, -350, 0.5, -200),
        Size = UDim2.new(0, 700, 0, 400),
        ClipsDescendants = true,
        Visible = false
    })

    -- Header
    local Header = Utility:Create("Frame", {
        Name = "Header",
        Parent = MainFrame,
        BackgroundColor3 = ThemeManager.Colors.Header,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 25)
    })

    local TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = WindowTitle,
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Buttons Area
    local CloseButton = Utility:Create("TextButton", {
        Name = "Close",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "X",
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 14
    })

    local MinimizeButton = Utility:Create("TextButton", {
        Name = "Minimize",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "-",
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 18
    })

    local SettingsButton = Utility:Create("TextButton", {
        Name = "Settings",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -75, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "*", -- Gear icon representation
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 18
    })

    Utility:MakeDraggable(Header, MainFrame)

    -- Sidebar
    local Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = ThemeManager.Colors.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(0, 140, 1, -25)
    })

    -- Sidebar Border Line
    local SidebarLine = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = ThemeManager.Colors.Outline,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0)
    })

    -- Search Bar
    local SearchFrame = Utility:Create("Frame", {
        Name = "SearchFrame",
        Parent = Sidebar,
        BackgroundColor3 = ThemeManager.Colors.Item,
        BorderSizePixel = 1,
        BorderColor3 = ThemeManager.Colors.Outline,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 0, 22)
    })

    local SearchBox = Utility:Create("TextBox", {
        Name = "Input",
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -5, 1, 0),
        Font = Enum.Font.SourceSans,
        PlaceholderText = "Search...",
        PlaceholderColor3 = ThemeManager.Colors.SubText,
        Text = "",
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container
    local TabList = Utility:Create("ScrollingFrame", {
        Name = "TabList",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = ThemeManager.Colors.Accent,
        BorderSizePixel = 0
    })

    Utility:Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    -- Content Area
    local ContentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 141, 0, 25),
        Size = UDim2.new(1, -141, 1, -25),
        ClipsDescendants = true
    })

    -- Settings Overlay
    local SettingsFrame = Utility:Create("Frame", {
        Name = "SettingsFrame",
        Parent = MainFrame,
        BackgroundColor3 = ThemeManager.Colors.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 141, 0, 25),
        Size = UDim2.new(1, -141, 1, -25),
        Visible = false,
        ZIndex = 50
    })

    Utility:Create("UIListLayout", {
        Parent = SettingsFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    Utility:Create("UIPadding", {
        Parent = SettingsFrame,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })

    -- Resize Grip (Triangle visual)
    local ResizeGrip = Utility:Create("TextButton", {
        Name = "ResizeGrip",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 15, 0, 15),
        Text = "◢",
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 14,
        ZIndex = 50
    })

    -- Resize Logic
    local IsResizing = false
    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsResizing = true
        end
    end)

    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsResizing = false
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if IsResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local MousePos = Services.UserInputService:GetMouseLocation()
            local NewX = math.clamp(MousePos.X - MainFrame.AbsolutePosition.X, 400, 1000)
            local NewY = math.clamp(MousePos.Y - MainFrame.AbsolutePosition.Y, 250, 700)
            MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
        end
    end)

    -- Minimize Logic
    local IsMinimized = false
    local LastSize = UDim2.new(0, 700, 0, 400)

    MinimizeButton.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            LastSize = MainFrame.Size
            MainFrame.Size = UDim2.new(0, LastSize.X.Offset, 0, 25)
            Sidebar.Visible = false
            ContentArea.Visible = false
            ResizeGrip.Visible = false
            SettingsFrame.Visible = false
            MinimizeButton.Text = "+"
        else
            MainFrame.Size = LastSize
            Sidebar.Visible = true
            ContentArea.Visible = true
            ResizeGrip.Visible = true
            MinimizeButton.Text = "-"
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Settings Logic
    local SettingsOpen = false
    SettingsButton.MouseButton1Click:Connect(function()
        SettingsOpen = not SettingsOpen
        SettingsFrame.Visible = SettingsOpen
        ContentArea.Visible = not SettingsOpen
        if SettingsOpen then
            SettingsButton.TextColor3 = ThemeManager.Colors.Accent
        else
            SettingsButton.TextColor3 = ThemeManager.Colors.SubText
        end
    end)

    -- Notification Function
    local function Notify(Title, Text, Duration)
        local NFrame = Utility:Create("Frame", {
            Parent = NotificationContainer,
            BackgroundColor3 = ThemeManager.Colors.Main,
            BorderSizePixel = 1,
            BorderColor3 = ThemeManager.Colors.Outline,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true
        })

        local NTitle = Utility:Create("TextLabel", {
            Parent = NFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 5),
            Size = UDim2.new(1, -16, 0, 20),
            Font = Enum.Font.SourceSansBold,
            Text = Title,
            TextColor3 = ThemeManager.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local NText = Utility:Create("TextLabel", {
            Parent = NFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 25),
            Size = UDim2.new(1, -16, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = Text,
            TextColor3 = ThemeManager.Colors.SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })

        local TextSize = Utility:GetTextSize(Text, NText.Font, NText.TextSize, 210)
        NText.Size = UDim2.new(1, -16, 0, TextSize.Y)

        local NBar = Utility:Create("Frame", {
            Parent = NFrame,
            BackgroundColor3 = ThemeManager.Colors.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(0, 0, 0, 2)
        })

        local TargetHeight = 35 + TextSize.Y
        
        -- Animation In
        Utility:Tween(NFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, TargetHeight)})
        Utility:Tween(NBar, TweenInfo.new(Duration or 3, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 2)})

        task.delay(Duration or 3, function()
            local OutTween = Utility:Tween(NFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)})
            OutTween.Completed:Wait()
            NFrame:Destroy()
        end)
    end

    local WindowAPI = {}
    local Tabs = {}
    local CurrentTab = nil

    local function SearchElements(query)
        if not CurrentTab then return end
        query = string.lower(query)
        
        for _, object in pairs(CurrentTab.Page:GetChildren()) do
            if object:IsA("Frame") then
                local Tag = object:FindFirstChild("SearchTag")
                if Tag then
                    if string.find(string.lower(Tag.Value), query) then
                        object.Visible = true
                    else
                        object.Visible = false
                    end
                end
            end
        end
        
        CurrentTab.Layout:ApplyLayout()
        CurrentTab.Page.CanvasSize = UDim2.new(0, 0, 0, CurrentTab.Layout.AbsoluteContentSize.Y + 20)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        SearchElements(SearchBox.Text)
    end)

    function WindowAPI:Notification(title, text, duration)
        Notify(title, text, duration)
    end
    
    function WindowAPI:Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end

    -- Tab Creation
    function WindowAPI:Tab(name)
        local TabPage = Utility:Create("ScrollingFrame", {
            Name = name,
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = ThemeManager.Colors.Outline,
            Visible = false,
            BorderSizePixel = 0
        })

        local TabPageLayout = Utility:Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        Utility:Create("UIPadding", {
            Parent = TabPage,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })

        TabPageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPageLayout.AbsoluteContentSize.Y + 20)
        end)

        local TabButton = Utility:Create("TextButton", {
            Parent = TabList,
            BackgroundColor3 = ThemeManager.Colors.Sidebar,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 25),
            Font = Enum.Font.SourceSans,
            Text = name,
            TextColor3 = ThemeManager.Colors.SubText,
            TextSize = 14
        })

        local TabObject = {
            Page = TabPage,
            Btn = TabButton,
            Layout = TabPageLayout
        }

        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                CurrentTab.Btn.TextColor3 = ThemeManager.Colors.SubText
                CurrentTab.Btn.BackgroundColor3 = ThemeManager.Colors.Sidebar
            end
            
            CurrentTab = TabObject
            TabPage.Visible = true
            
            TabButton.BackgroundColor3 = ThemeManager.Colors.Item
            TabButton.TextColor3 = ThemeManager.Colors.Text
            
            SettingsOpen = false
            SettingsFrame.Visible = false
            ContentArea.Visible = true
            SettingsButton.TextColor3 = ThemeManager.Colors.SubText
            
            SearchElements(SearchBox.Text)
        end)

        if #Tabs == 0 then
            CurrentTab = TabObject
            TabPage.Visible = true
            TabButton.BackgroundColor3 = ThemeManager.Colors.Item
            TabButton.TextColor3 = ThemeManager.Colors.Text
        end

        table.insert(Tabs, TabObject)

        local Elements = {}

        local function AddSearchTag(instance, keyword)
            local Tag = Instance.new("StringValue")
            Tag.Name = "SearchTag"
            Tag.Value = keyword
            Tag.Parent = instance
        end

        function Elements:Label(text)
            local LabelFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            AddSearchTag(LabelFrame, text)

            Utility:Create("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            return LabelFrame
        end

        function Elements:Warning(text)
            local WarningFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(60, 40, 40),
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Warning,
                Size = UDim2.new(1, 0, 0, 28)
            })
            AddSearchTag(WarningFrame, text)

            Utility:Create("TextLabel", {
                Parent = WarningFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.SourceSansBold,
                Text = "WARNING: " .. text,
                TextColor3 = ThemeManager.Colors.Warning,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            return WarningFrame
        end

        function Elements:Button(text, callback)
            callback = callback or function() end
            
            local ButtonFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28)
            })
            AddSearchTag(ButtonFrame, text)

            local Button = Utility:Create("TextButton", {
                Parent = ButtonFrame,
                BackgroundColor3 = ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                AutoButtonColor = false
            })

            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = ThemeManager.Colors.Hover
            end)

            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = ThemeManager.Colors.Item
            end)

            Button.MouseButton1Click:Connect(function()
                Utility:Ripple(Button)
                task.spawn(callback)
            end)
            return ButtonFrame
        end

        function Elements:Toggle(text, default, callback)
            callback = callback or function() end
            local Toggled = default or false

            local ToggleFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28)
            })
            AddSearchTag(ToggleFrame, text)

            local Button = Utility:Create("TextButton", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local CheckBox = Utility:Create("Frame", {
                Parent = Button,
                BackgroundColor3 = Toggled and ThemeManager.Colors.Accent or ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0, 0, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })

            Utility:Create("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 24, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            Button.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetColor = Toggled and ThemeManager.Colors.Accent or ThemeManager.Colors.Item
                CheckBox.BackgroundColor3 = TargetColor
                task.spawn(callback, Toggled)
            end)
            return ToggleFrame
        end

        function Elements:Slider(text, min, max, default, callback)
            callback = callback or function() end
            local Value = math.clamp(default or min, min, max)

            local SliderFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            AddSearchTag(SliderFrame, text)

            Utility:Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Utility:Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.7, 0, 0, 0),
                Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = tostring(Value),
                TextColor3 = ThemeManager.Colors.SubText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Track = Utility:Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 8)
            })

            local Fill = Utility:Create("Frame", {
                Parent = Track,
                BackgroundColor3 = ThemeManager.Colors.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            })

            local Trigger = Utility:Create("TextButton", {
                Parent = Track,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local Dragging = false

            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + ((max - min) * pos))
                Value = newVal
                ValueLabel.Text = tostring(Value)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                task.spawn(callback, Value)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)

            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)

            Services.UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            return SliderFrame
        end

        function Elements:Textbox(text, placeholder, callback)
            callback = callback or function() end
            
            local TextboxFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            AddSearchTag(TextboxFrame, text)

            Utility:Create("TextLabel", {
                Parent = TextboxFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Input = Utility:Create("TextBox", {
                Parent = TextboxFrame,
                BackgroundColor3 = ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, 0, 0, 22),
                Font = Enum.Font.SourceSans,
                PlaceholderText = placeholder or "...",
                Text = "",
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            Input.FocusLost:Connect(function(enter)
                if enter then
                    task.spawn(callback, Input.Text)
                end
            end)
            return TextboxFrame
        end

        function Elements:Dropdown(text, list, callback)
            callback = callback or function() end
            local IsOpen = false
            
            local DropFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                ZIndex = 5
            })
            AddSearchTag(DropFrame, text)

            Utility:Create("TextLabel", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local MainButton = Utility:Create("TextButton", {
                Parent = DropFrame,
                BackgroundColor3 = ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.SourceSans,
                Text = " Select...",
                TextColor3 = ThemeManager.Colors.SubText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })

            local Arrow = Utility:Create("TextLabel", {
                Parent = MainButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = "+",
                TextColor3 = ThemeManager.Colors.SubText,
                TextSize = 18
            })

            local ListFrame = Utility:Create("ScrollingFrame", {
                Parent = MainButton,
                BackgroundColor3 = ThemeManager.Colors.Hover,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0, 0, 1, 2),
                Size = UDim2.new(1, 0, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = ThemeManager.Colors.Accent,
                Visible = false,
                ZIndex = 10
            })

            local ListLayout = Utility:Create("UIListLayout", {
                Parent = ListFrame,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            for _, item in pairs(list) do
                local ItemButton = Utility:Create("TextButton", {
                    Parent = ListFrame,
                    BackgroundColor3 = ThemeManager.Colors.Hover,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.SourceSans,
                    Text = " " .. item,
                    TextColor3 = ThemeManager.Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11
                })

                ItemButton.MouseButton1Click:Connect(function()
                    MainButton.Text = " " .. item
                    Arrow.Text = "+"
                    ListFrame.Visible = false
                    IsOpen = false
                    task.spawn(callback, item)
                end)
            end

            MainButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    ListFrame.Visible = true
                    Arrow.Text = "-"
                    local ItemCount = #list
                    local NewHeight = math.min(ItemCount * 25, 150)
                    ListFrame.Size = UDim2.new(1, 0, 0, NewHeight)
                    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ItemCount * 25)
                else
                    Arrow.Text = "+"
                    ListFrame.Visible = false
                end
            end)
            return DropFrame
        end

        function Elements:Colorpicker(text, default, callback)
            callback = callback or function() end
            local DefaultColor = default or Color3.fromRGB(255, 255, 255)
            
            local ColorFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                ZIndex = 2
            })
            AddSearchTag(ColorFrame, text)

            Utility:Create("TextLabel", {
                Parent = ColorFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Preview = Utility:Create("TextButton", {
                Parent = ColorFrame,
                BackgroundColor3 = DefaultColor,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(1, -40, 0, 2),
                Size = UDim2.new(0, 40, 0, 21),
                Text = ""
            })

            local PickerPopup = Utility:Create("Frame", {
                Parent = ScreenGui,
                BackgroundColor3 = ThemeManager.Colors.Main,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Size = UDim2.new(0, 180, 0, 170),
                Visible = false,
                ZIndex = 200
            })

            local SaturationMap = Utility:Create("ImageButton", {
                Parent = PickerPopup,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0, 140, 0, 120),
                Image = "rbxassetid://4155801252",
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                ZIndex = 201
            })

            local SatCursor = Utility:Create("Frame", {
                Parent = SaturationMap,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 4, 0, 4),
                ZIndex = 202
            })

            local HueBar = Utility:Create("Frame", {
                Parent = PickerPopup,
                Position = UDim2.new(0, 160, 0, 10),
                Size = UDim2.new(0, 10, 0, 120),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                ZIndex = 201
            })
            
            local HueGradient = Utility:Create("UIGradient", {
                Parent = HueBar,
                Rotation = 90,
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                }
            })

            local HueTrigger = Utility:Create("TextButton", {
                Parent = HueBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Text = "",
                ZIndex = 205
            })

            local HueCursor = Utility:Create("Frame", {
                Parent = HueBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, 0, 0, 2),
                ZIndex = 202
            })

            local ConfirmButton = Utility:Create("TextButton", {
                Parent = PickerPopup,
                BackgroundColor3 = ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0, 10, 0, 140),
                Size = UDim2.new(0, 160, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = "Confirm",
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                ZIndex = 201
            })

            local HSV = {H = 0, S = 1, V = 1}
            local function UpdateColor()
                local color = Color3.fromHSV(HSV.H, HSV.S, HSV.V)
                Preview.BackgroundColor3 = color
                SaturationMap.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
                task.spawn(callback, color)
            end

            local DraggingHue, DraggingSat = false, false

            HueTrigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    DraggingHue = true
                end
            end)

            SaturationMap.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    DraggingSat = true
                end
            end)

            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    DraggingHue = false
                    DraggingSat = false
                end
            end)

            Services.UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if DraggingHue then
                        local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                        HSV.H = 1 - y
                        HueCursor.Position = UDim2.new(0, 0, y, 0)
                        UpdateColor()
                    elseif DraggingSat then
                        local x = math.clamp((input.Position.X - SaturationMap.AbsolutePosition.X) / SaturationMap.AbsoluteSize.X, 0, 1)
                        local y = math.clamp((input.Position.Y - SaturationMap.AbsolutePosition.Y) / SaturationMap.AbsoluteSize.Y, 0, 1)
                        HSV.S = x
                        HSV.V = 1 - y
                        SatCursor.Position = UDim2.new(x, -2, y, -2)
                        UpdateColor()
                    end
                end
            end)

            ConfirmButton.MouseButton1Click:Connect(function()
                PickerPopup.Visible = false
            end)

            Preview.MouseButton1Click:Connect(function()
                PickerPopup.Visible = not PickerPopup.Visible
                PickerPopup.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
            end)
            return ColorFrame
        end

        function Elements:Keybind(text, default, callback)
            callback = callback or function() end
            
            local KeyFrame = Utility:Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25)
            })
            AddSearchTag(KeyFrame, text)

            Utility:Create("TextLabel", {
                Parent = KeyFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local BindButton = Utility:Create("TextButton", {
                Parent = KeyFrame,
                BackgroundColor3 = ThemeManager.Colors.Item,
                BorderSizePixel = 1,
                BorderColor3 = ThemeManager.Colors.Outline,
                Position = UDim2.new(0.7, 0, 0, 0),
                Size = UDim2.new(0.3, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = (default and default.Name) or "None",
                TextColor3 = ThemeManager.Colors.SubText,
                TextSize = 14
            })

            local IsListening = false

            BindButton.MouseButton1Click:Connect(function()
                IsListening = true
                BindButton.Text = "..."
                BindButton.TextColor3 = ThemeManager.Colors.Accent
            end)

            Services.UserInputService.InputBegan:Connect(function(input)
                if IsListening and input.UserInputType == Enum.UserInputType.Keyboard then
                    IsListening = false
                    BindButton.Text = input.KeyCode.Name
                    BindButton.TextColor3 = ThemeManager.Colors.SubText
                    task.spawn(callback, input.KeyCode)
                end
            end)
            return KeyFrame
        end

        return Elements
    end

    -- SETTINGS MENU POPULATION
    local SettingsLabel = Utility:Create("TextLabel", {
        Parent = SettingsFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.SourceSansBold,
        Text = "Settings",
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Blur Toggle
    local BlurFrame = Utility:Create("Frame", {
        Parent = SettingsFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })
    local BlurBtn = Utility:Create("TextButton", {
        Parent = BlurFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    local BlurCheck = Utility:Create("Frame", {
        Parent = BlurBtn,
        BackgroundColor3 = ThemeManager.Colors.Item,
        BorderSizePixel = 1,
        BorderColor3 = ThemeManager.Colors.Outline,
        Position = UDim2.new(0, 0, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16)
    })
    Utility:Create("TextLabel", {
        Parent = BlurBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 0),
        Size = UDim2.new(1, -25, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "UI Blur",
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local BlurEffect = Instance.new("BlurEffect", Services.Lighting)
    BlurEffect.Enabled = false
    BlurEffect.Size = 15
    local BlurEnabled = false
    BlurBtn.MouseButton1Click:Connect(function()
        BlurEnabled = not BlurEnabled
        BlurEffect.Enabled = BlurEnabled
        BlurCheck.BackgroundColor3 = BlurEnabled and ThemeManager.Colors.Accent or ThemeManager.Colors.Item
    end)

    -- Snow Toggle
    local SnowFrame = Utility:Create("Frame", {
        Parent = SettingsFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })
    local SnowBtn = Utility:Create("TextButton", {
        Parent = SnowFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    local SnowCheck = Utility:Create("Frame", {
        Parent = SnowBtn,
        BackgroundColor3 = ThemeManager.Colors.Item,
        BorderSizePixel = 1,
        BorderColor3 = ThemeManager.Colors.Outline,
        Position = UDim2.new(0, 0, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16)
    })
    Utility:Create("TextLabel", {
        Parent = SnowBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 0),
        Size = UDim2.new(1, -25, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "Snow Effect",
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local Snowing = false
    SnowBtn.MouseButton1Click:Connect(function()
        Snowing = not Snowing
        SnowCheck.BackgroundColor3 = Snowing and ThemeManager.Colors.Accent or ThemeManager.Colors.Item
        if Snowing then SnowSystem:Start(ScreenGui) else SnowSystem:Stop() end
    end)

    -- Credits
    Utility:Create("TextLabel", {
        Parent = SettingsFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Font = Enum.Font.SourceSans,
        Text = "Created by Magbux\nClassic Style",
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom
    })

    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Utility:Tween(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 400)})
    Notify("System", "Library Loaded Successfully", 3)

    return WindowAPI
end

return Library
