local Library = {}

local Services = {
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    HttpService = game:GetService("HttpService"),
    TextService = game:GetService("TextService"),
    StarterGui = game:GetService("StarterGui")
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ViewportSize = workspace.CurrentCamera.ViewportSize

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._connections = {}
    return self
end

function Signal:Connect(callback)
    local connection = {
        callback = callback,
        signal = self,
        connected = true
    }
    table.insert(self._connections, connection)
    return {
        Disconnect = function()
            connection.connected = false
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
        if connection.connected then
            task.spawn(connection.callback, ...)
        end
    end
end

function Signal:Destroy()
    self._connections = {}
end

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
        local Ripple = Utility:Create("ImageLabel", {
            Name = "Ripple",
            Parent = object,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = "rbxassetid://2708891598",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Fit,
            ClipsDescendants = true
        })
        
        local MouseLocation = Services.UserInputService:GetMouseLocation()
        local RelativeX = MouseLocation.X - object.AbsolutePosition.X
        local RelativeY = MouseLocation.Y - object.AbsolutePosition.Y
        
        Ripple.Position = UDim2.new(0, RelativeX, 0, RelativeY)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        
        local MaxSize = math.max(object.AbsoluteSize.X, object.AbsoluteSize.Y) * 1.5
        
        local Tween = Services.TweenService:Create(Ripple, TweenInfo.new(0.5), {
            Position = UDim2.new(0, RelativeX - MaxSize/2, 0, RelativeY - MaxSize/2),
            Size = UDim2.new(0, MaxSize, 0, MaxSize),
            ImageTransparency = 1
        })
        
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
            Services.TweenService:Create(object, TweenInfo.new(0.05), {Position = TargetPosition}):Play()
        end
    end)
end

local ThemeManager = {}
ThemeManager.Colors = {
    Main = Color3.fromRGB(40, 40, 40),
    Header = Color3.fromRGB(30, 30, 30),
    Sidebar = Color3.fromRGB(35, 35, 35),
    Content = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(170, 170, 170),
    Accent = Color3.fromRGB(0, 120, 215),
    Outline = Color3.fromRGB(60, 60, 60),
    Item = Color3.fromRGB(50, 50, 50),
    Hover = Color3.fromRGB(60, 60, 60),
    Click = Color3.fromRGB(70, 70, 70),
    Shadow = Color3.fromRGB(0, 0, 0),
    Warning = Color3.fromRGB(230, 150, 60),
    Error = Color3.fromRGB(230, 60, 60),
    Success = Color3.fromRGB(60, 230, 100)
}

function Library:Window(options)
    local WindowTitle = options.Name or "Zyph UI"
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "ZyphLibrary_" .. tostring(math.random(100000, 999999)),
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })

    local NotificationContainer = Utility:Create("Frame", {
        Name = "NotificationContainer",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 1, -20),
        Size = UDim2.new(0, 300, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })

    local NotificationLayout = Utility:Create("UIListLayout", {
        Parent = NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 10)
    })

    local MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = ThemeManager.Colors.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
        Visible = false
    })

    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = MainFrame
    })

    Utility:Create("UIStroke", {
        Parent = MainFrame,
        Color = ThemeManager.Colors.Outline,
        Thickness = 1
    })

    local ShadowImage = Utility:Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = ThemeManager.Colors.Shadow,
        ImageTransparency = 0.5,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1
    })

    local Header = Utility:Create("Frame", {
        Name = "Header",
        Parent = MainFrame,
        BackgroundColor3 = ThemeManager.Colors.Header,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 35)
    })

    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = Header
    })

    local HeaderFix = Utility:Create("Frame", {
        Name = "HeaderFix",
        Parent = Header,
        BackgroundColor3 = ThemeManager.Colors.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -5),
        Size = UDim2.new(1, 0, 0, 5)
    })

    local TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = WindowTitle,
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseButton = Utility:Create("TextButton", {
        Name = "Close",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0, 0),
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "X",
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 16
    })

    local MinimizeButton = Utility:Create("TextButton", {
        Name = "Minimize",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "-",
        TextColor3 = ThemeManager.Colors.SubText,
        TextSize = 20
    })

    Utility:MakeDraggable(Header, MainFrame)

    local Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = ThemeManager.Colors.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(0, 150, 1, -35)
    })

    local SidebarBorder = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = ThemeManager.Colors.Outline,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0)
    })

    local SearchFrame = Utility:Create("Frame", {
        Name = "SearchFrame",
        Parent = Sidebar,
        BackgroundColor3 = ThemeManager.Colors.Item,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 0, 26)
    })

    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = SearchFrame
    })

    Utility:Create("UIStroke", {
        Parent = SearchFrame,
        Color = ThemeManager.Colors.Outline,
        Thickness = 1
    })

    local SearchBox = Utility:Create("TextBox", {
        Name = "Input",
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0),
        Font = Enum.Font.SourceSans,
        PlaceholderText = "Search...",
        PlaceholderColor3 = ThemeManager.Colors.SubText,
        Text = "",
        TextColor3 = ThemeManager.Colors.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabList = Utility:Create("ScrollingFrame", {
        Name = "TabList",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 42),
        Size = UDim2.new(1, 0, 1, -42),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = ThemeManager.Colors.Accent,
        BorderSizePixel = 0
    })

    Utility:Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })

    Utility:Create("UIPadding", {
        Parent = TabList,
        PaddingTop = UDim.new(0, 0),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    })

    local ContentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 35),
        Size = UDim2.new(1, -150, 1, -35),
        ClipsDescendants = true
    })

    local ResizeGrip = Utility:Create("Frame", {
        Name = "ResizeGrip",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.new(0, 16, 0, 16),
        ZIndex = 50
    })

    local GripImage = Utility:Create("ImageLabel", {
        Parent = ResizeGrip,
        BackgroundTransparency = 1,
        Image = "rbxassetid://7266155502",
        ImageColor3 = ThemeManager.Colors.SubText,
        Size = UDim2.new(1, 0, 1, 0)
    })

    local IsResizing = false
    
    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsResizing = true
        end
    end)

    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsResizing = false
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if IsResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local MousePos = Services.UserInputService:GetMouseLocation()
            local NewX = math.clamp(MousePos.X - MainFrame.AbsolutePosition.X, 400, 1000)
            local NewY = math.clamp(MousePos.Y - MainFrame.AbsolutePosition.Y, 300, 700)
            MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
        end
    end)

    local IsMinimized = false
    local LastSize = UDim2.new(0, 600, 0, 400)

    MinimizeButton.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            LastSize = MainFrame.Size
            Utility:Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, LastSize.X.Offset, 0, 35)})
            Sidebar.Visible = false
            ContentArea.Visible = false
            ResizeGrip.Visible = false
            MinimizeButton.Text = "+"
        else
            Utility:Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = LastSize})
            task.delay(0.3, function()
                Sidebar.Visible = true
                ContentArea.Visible = true
                ResizeGrip.Visible = true
            end)
            MinimizeButton.Text = "-"
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local function Notify(Title, Text, Duration)
        local NFrame = Utility:Create("Frame", {
            Parent = NotificationContainer,
            BackgroundColor3 = ThemeManager.Colors.Main,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true
        })

        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = NFrame
        })

        Utility:Create("UIStroke", {
            Parent = NFrame,
            Color = ThemeManager.Colors.Outline,
            Thickness = 1
        })

        local NTitle = Utility:Create("TextLabel", {
            Parent = NFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.SourceSansBold,
            Text = Title,
            TextColor3 = ThemeManager.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local NText = Utility:Create("TextLabel", {
            Parent = NFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = Text,
            TextColor3 = ThemeManager.Colors.SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })

        local TextSize = Utility:GetTextSize(Text, NText.Font, NText.TextSize, 280)
        NText.Size = UDim2.new(1, -20, 0, TextSize.Y)

        local NBar = Utility:Create("Frame", {
            Parent = NFrame,
            BackgroundColor3 = ThemeManager.Colors.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(0, 0, 0, 2)
        })

        local TargetHeight = 35 + TextSize.Y
        Utility:Tween(NFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, TargetHeight)})
        Utility:Tween(NBar, TweenInfo.new(Duration or 3, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 2)})

        task.delay(Duration or 3, function()
            local OutTween = Utility:Tween(NFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})
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

    function WindowAPI:Tab(name)
        local TabPage = Utility:Create("ScrollingFrame", {
            Name = name,
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ThemeManager.Colors.Accent,
            Visible = false,
            BorderSizePixel = 0
        })

        local TabPageLayout = Utility:Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
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
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 28),
            Font = Enum.Font.SourceSans,
            Text = name,
            TextColor3 = ThemeManager.Colors.SubText,
            TextSize = 14
        })

        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = TabButton
        })

        local TabObject = {
            Page = TabPage,
            Btn = TabButton,
            Layout = TabPageLayout
        }

        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                Utility:Tween(CurrentTab.Btn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Colors.SubText
                })
            end
            
            CurrentTab = TabObject
            TabPage.Visible = true
            
            Utility:Tween(TabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                BackgroundColor3 = ThemeManager.Colors.Item,
                TextColor3 = ThemeManager.Colors.Text
            })
            
            SearchElements(SearchBox.Text)
        end)

        if #Tabs == 0 then
            CurrentTab = TabObject
            TabPage.Visible = true
            TabButton.BackgroundTransparency = 0
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
                BackgroundColor3 = ThemeManager.Colors.Item,
                Size = UDim2.new(1, 0, 0, 28)
            })
            AddSearchTag(WarningFrame, text)

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = WarningFrame
            })

            Utility:Create("UIStroke", {
                Parent = WarningFrame,
                Color = ThemeManager.Colors.Warning,
                Thickness = 1
            })

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
                Size = UDim2.new(1, 0, 0, 32)
            })
            AddSearchTag(ButtonFrame, text)

            local Button = Utility:Create("TextButton", {
                Parent = ButtonFrame,
                BackgroundColor3 = ThemeManager.Colors.Item,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                AutoButtonColor = false
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Button
            })

            Utility:Create("UIStroke", {
                Parent = Button,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
            })

            Button.MouseEnter:Connect(function()
                Utility:Tween(Button, TweenInfo.new(0.2), {BackgroundColor3 = ThemeManager.Colors.Hover})
            end)

            Button.MouseLeave:Connect(function()
                Utility:Tween(Button, TweenInfo.new(0.2), {BackgroundColor3 = ThemeManager.Colors.Item})
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
                Size = UDim2.new(1, 0, 0, 32)
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
                Position = UDim2.new(0, 0, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18)
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = CheckBox
            })

            Utility:Create("UIStroke", {
                Parent = CheckBox,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
            })

            Utility:Create("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 28, 0, 0),
                Size = UDim2.new(1, -28, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            Button.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetColor = Toggled and ThemeManager.Colors.Accent or ThemeManager.Colors.Item
                Utility:Tween(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
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
                Size = UDim2.new(1, 0, 0, 45)
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
                Position = UDim2.new(0, 0, 0, 28),
                Size = UDim2.new(1, 0, 0, 6)
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 3),
                Parent = Track
            })

            local Fill = Utility:Create("Frame", {
                Parent = Track,
                BackgroundColor3 = ThemeManager.Colors.Accent,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 3),
                Parent = Fill
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
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)

            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            Services.UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, 0, 0, 23),
                Font = Enum.Font.SourceSans,
                PlaceholderText = placeholder or "...",
                Text = "",
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Input
            })

            Utility:Create("UIStroke", {
                Parent = Input,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
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
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, 0, 0, 28),
                Font = Enum.Font.SourceSans,
                Text = " Select...",
                TextColor3 = ThemeManager.Colors.SubText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = MainButton
            })

            Utility:Create("UIStroke", {
                Parent = MainButton,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
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
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 3),
                Size = UDim2.new(1, 0, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = ThemeManager.Colors.Accent,
                Visible = false,
                ZIndex = 10
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = ListFrame
            })

            Utility:Create("UIStroke", {
                Parent = ListFrame,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
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
                    Utility:Tween(ListFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.wait(0.2)
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
                    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ItemCount * 25)
                    Utility:Tween(ListFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, NewHeight)})
                else
                    Arrow.Text = "+"
                    Utility:Tween(ListFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.wait(0.2)
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
                Position = UDim2.new(1, -40, 0, 2),
                Size = UDim2.new(0, 40, 0, 21),
                Text = ""
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Preview
            })

            Utility:Create("UIStroke", {
                Parent = Preview,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
            })

            local PickerPopup = Utility:Create("Frame", {
                Parent = ScreenGui,
                BackgroundColor3 = ThemeManager.Colors.Main,
                Size = UDim2.new(0, 180, 0, 170),
                Visible = false,
                ZIndex = 200
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = PickerPopup
            })

            Utility:Create("UIStroke", {
                Parent = PickerPopup,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
            })

            local SaturationMap = Utility:Create("ImageButton", {
                Parent = PickerPopup,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0, 140, 0, 120),
                Image = "rbxassetid://4155801252",
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                BorderColor3 = ThemeManager.Colors.Outline,
                BorderSizePixel = 1,
                ZIndex = 201
            })

            local SatCursor = Utility:Create("Frame", {
                Parent = SaturationMap,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 4, 0, 4),
                ZIndex = 202
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = SatCursor})

            local HueBar = Utility:Create("Frame", {
                Parent = PickerPopup,
                Position = UDim2.new(0, 160, 0, 10),
                Size = UDim2.new(0, 10, 0, 120),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = ThemeManager.Colors.Outline,
                BorderSizePixel = 1,
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
                Position = UDim2.new(0, 10, 0, 140),
                Size = UDim2.new(0, 160, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = "Confirm",
                TextColor3 = ThemeManager.Colors.Text,
                TextSize = 14,
                ZIndex = 201
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ConfirmButton})

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
                Position = UDim2.new(0.7, 0, 0, 0),
                Size = UDim2.new(0.3, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = (default and default.Name) or "None",
                TextColor3 = ThemeManager.Colors.SubText,
                TextSize = 14
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = BindButton
            })

            Utility:Create("UIStroke", {
                Parent = BindButton,
                Color = ThemeManager.Colors.Outline,
                Thickness = 1
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

    Services.UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Utility:Tween(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
    Notify("System", "Library Loaded Successfully", 3)

    return WindowAPI
end

local Window = Library:Window({
    Name = "Zyph Hub",
    KeySystem = false 
})

local Main = Window:Tab("Main")
local Visuals = Window:Tab("Visuals")
local Settings = Window:Tab("Settings")

Main:Label("Movement")
Main:Warning("Risk of ban if used blatantly")

Main:Toggle("Infinite Jump", false, function(v)
    _G.InfJump = v
    if v then
        Window:Notification("Cheat", "Infinite Jump Enabled", 2)
    end
end)

Main:Slider("WalkSpeed", 16, 250, 16, function(v)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

Main:Button("Reset", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

Visuals:Dropdown("ESP Mode", {"Box", "Tracers", "Chams"}, function(v)
    print(v)
end)

Visuals:Colorpicker("ESP Color", Color3.fromRGB(255, 0, 0), function(c)
    print(c)
end)

Settings:Keybind("Menu Toggle", Enum.KeyCode.RightControl, function()
    print("Toggle pressed")
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)
