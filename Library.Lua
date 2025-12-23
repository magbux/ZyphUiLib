local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Viewport = workspace.CurrentCamera.ViewportSize

local Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Darker = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(170, 170, 170),
    Accent = Color3.fromRGB(0, 120, 215),
    Divider = Color3.fromRGB(50, 50, 50),
    Outline = Color3.fromRGB(20, 20, 20),
    Hover = Color3.fromRGB(45, 45, 45)
}

local function GetTextSize(text, font, size, maxWidth)
    return TextService:GetTextSize(text, size, font, Vector2.new(maxWidth or 99999, 99999))
end

local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(trigger, object)
    local dragging, dragInput, dragStart, startPos
    
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function CreateRipple(parent)
    local Ripple = Create("Frame", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = 9
    })
    local Corner = Create("UICorner", {Parent = Ripple, CornerRadius = UDim.new(1, 0)})
    
    local MouseLocation = UserInputService:GetMouseLocation()
    local RelativeX = MouseLocation.X - parent.AbsolutePosition.X
    local RelativeY = MouseLocation.Y - parent.AbsolutePosition.Y
    
    Ripple.Position = UDim2.new(0, RelativeX, 0, RelativeY)
    
    local MaxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 1.5
    
    Tween(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, MaxSize, 0, MaxSize),
        Position = UDim2.new(0, RelativeX - MaxSize/2, 0, RelativeY - MaxSize/2),
        BackgroundTransparency = 1
    })
    
    task.delay(0.5, function() Ripple:Destroy() end)
end

function Library:Window(options)
    local Title = options.Name or "Library"
    local KeySystem = options.KeySystem or false
    local Key = options.Key or ""
    local KeyNote = options.KeyNote or "Enter Key"
    
    local ScreenGui = Create("ScreenGui", {
        Name = "ZyphLib_" .. tostring(math.random(10000,99999)),
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
        Visible = false
    })
    
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 6)})
    
    local Shadow = Create("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.4,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1
    })
    
    local TopBar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Darker,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 35)
    })
    Create("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0, 6)})
    
    local TopBarFix = Create("Frame", {
        Parent = TopBar,
        BackgroundColor3 = Theme.Darker,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -5),
        Size = UDim2.new(1, 0, 0, 5)
    })
    
    local TitleLbl = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    MakeDraggable(TopBar, Main)
    
    local CloseBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0, 0),
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "X",
        TextColor3 = Theme.SubText,
        TextSize = 16
    })
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(0, 150, 1, -35)
    })
    
    local SearchCont = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Darker,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 0, 26)
    })
    Create("UICorner", {Parent = SearchCont, CornerRadius = UDim.new(0, 4)})
    
    local SearchBox = Create("TextBox", {
        Parent = SearchCont,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0),
        Font = Enum.Font.SourceSans,
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 42),
        Size = UDim2.new(1, 0, 1, -42),
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0
    })
    Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    
    local Content = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 35),
        Size = UDim2.new(1, -150, 1, -35),
        ClipsDescendants = true
    })
    
    local ResizeGrip = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 15, 0, 15),
        ZIndex = 20
    })
    
    local Triangle = Create("ImageLabel", {
        Parent = ResizeGrip,
        BackgroundTransparency = 1,
        Image = "rbxassetid://7266155502", 
        ImageColor3 = Theme.SubText,
        Size = UDim2.new(1, 0, 1, 0),
        Rotation = 0
    })
    
    local resizing = false
    ResizeGrip.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then resizing = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then resizing = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local mouse = UserInputService:GetMouseLocation()
            local x = math.max(400, mouse.X - Main.AbsolutePosition.X)
            local y = math.max(300, mouse.Y - Main.AbsolutePosition.Y)
            Main.Size = UDim2.new(0, x, 0, y)
        end
    end)
    
    local NotifHolder = Create("Frame", {
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -220, 1, -20),
        Size = UDim2.new(0, 200, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })
    Create("UIListLayout", {Parent = NotifHolder, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5)})
    
    local Lib = {}
    local CurrentTab = nil
    
    function Lib:Notification(title, text, duration)
        local NFrame = Create("Frame", {
            Parent = NotifHolder,
            BackgroundColor3 = Theme.Darker,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true
        })
        Create("UICorner", {Parent = NFrame, CornerRadius = UDim.new(0, 4)})
        
        local NStroke = Create("UIStroke", {
            Parent = NFrame,
            Color = Theme.Outline,
            Thickness = 1,
            Transparency = 0.5
        })
        
        local NTitle = Create("TextLabel", {
            Parent = NFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.SourceSansBold,
            Text = title,
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NText = Create("TextLabel", {
            Parent = NFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = text,
            TextColor3 = Theme.SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        NText.Size = UDim2.new(1, -20, 0, GetTextSize(text, NText.Font, NText.TextSize, 180).Y)
        
        local TargetSize = 35 + NText.Size.Y.Offset
        
        local NBar = Create("Frame", {
            Parent = NFrame,
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(0, 0, 0, 2)
        })
        
        Tween(NFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, TargetSize)})
        Tween(NBar, TweenInfo.new(duration or 3), {Size = UDim2.new(1, 0, 0, 2)})
        
        task.delay(duration or 3, function()
            local out = Tween(NFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)})
            out.Completed:Wait()
            NFrame:Destroy()
        end)
    end
    
    local function UpdateSearch(text)
        if not CurrentTab then return end
        for _, child in pairs(CurrentTab.Page:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("STag") then
                if string.find(string.lower(child.STag.Value), string.lower(text)) then
                    child.Visible = true
                else
                    child.Visible = false
                end
            end
        end
        CurrentTab.Page.CanvasSize = UDim2.new(0, 0, 0, CurrentTab.Layout.AbsoluteContentSize.Y + 20)
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        UpdateSearch(SearchBox.Text)
    end)
    
    function Lib:Tab(name)
        local Page = Create("ScrollingFrame", {
            Name = name,
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = false,
            BorderSizePixel = 0
        })
        
        local PageLayout = Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 28),
            Font = Enum.Font.SourceSans,
            Text = name,
            TextColor3 = Theme.SubText,
            TextSize = 14
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 4)})
        
        local TabData = {Page = Page, Btn = TabBtn, Layout = PageLayout}
        
        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                Tween(CurrentTab.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.SubText, BackgroundTransparency = 1})
            end
            CurrentTab = TabData
            Page.Visible = true
            Tween(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0})
            UpdateSearch(SearchBox.Text)
        end)
        
        if CurrentTab == nil then
            CurrentTab = TabData
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
            TabBtn.BackgroundTransparency = 0
        end
        
        local Elements = {}
        
        local function AddSTag(obj, txt)
            local t = Instance.new("StringValue")
            t.Name = "STag"
            t.Value = txt
            t.Parent = obj
        end
        
        function Elements:Label(text)
            local F = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            AddSTag(F, text)
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        function Elements:Button(text, callback)
            local F = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            })
            AddSTag(F, text)
            local B = Create("TextButton", {
                Parent = F,
                BackgroundColor3 = Theme.Darker,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
            
            B.MouseEnter:Connect(function() Tween(B, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover}) end)
            B.MouseLeave:Connect(function() Tween(B, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Darker}) end)
            B.MouseButton1Click:Connect(function()
                CreateRipple(B)
                task.spawn(callback)
            end)
        end
        
        function Elements:Toggle(text, default, callback)
            local state = default or false
            local F = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            })
            AddSTag(F, text)
            local B = Create("TextButton", {
                Parent = F,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            local Box = Create("Frame", {
                Parent = B,
                BackgroundColor3 = state and Theme.Accent or Theme.Darker,
                Position = UDim2.new(0, 0, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18)
            })
            Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
            Create("TextLabel", {
                Parent = B,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 26, 0, 0),
                Size = UDim2.new(1, -26, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            B.MouseButton1Click:Connect(function()
                state = not state
                Tween(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Darker})
                task.spawn(callback, state)
            end)
        end
        
        function Elements:Slider(text, min, max, default, callback)
            local value = default or min
            local F = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 0, 20),
                Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValLbl = Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0.7, 0, 0, 0), Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.SourceSans, Text = tostring(value), TextColor3 = Theme.SubText, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right
            })
            local Track = Create("Frame", {
                Parent = F, BackgroundColor3 = Theme.Darker, Position = UDim2.new(0, 0, 0, 28), Size = UDim2.new(1, 0, 0, 6)
            })
            Create("UICorner", {Parent = Track, CornerRadius = UDim.new(0, 3)})
            local Fill = Create("Frame", {
                Parent = Track, BackgroundColor3 = Theme.Accent, Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 3)})
            local Grip = Create("TextButton", {
                Parent = Track, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
            })
            local drag = false
            local function move(input)
                local p = math.clamp((input.Position.X - Track.AbsolutePosition.X)/Track.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + ((max-min)*p))
                Fill.Size = UDim2.new(p, 0, 1, 0)
                ValLbl.Text = tostring(v)
                task.spawn(callback, v)
            end
            Grip.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true move(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
            UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then move(i) end end)
        end
        
        function Elements:Dropdown(text, list, callback)
            local open = false
            local F = Create("Frame", {
                Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50), ZIndex = 5
            })
            AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Btn = Create("TextButton", {
                Parent = F, BackgroundColor3 = Theme.Darker, Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 28),
                Font = Enum.Font.SourceSans, Text = " Select...", TextColor3 = Theme.SubText, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
            
            local List = Create("ScrollingFrame", {
                Parent = Btn, BackgroundColor3 = Theme.Hover, Position = UDim2.new(0, 0, 1, 2), Size = UDim2.new(1, 0, 0, 0),
                Visible = false, CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 2, ZIndex = 10, BorderSizePixel = 0
            })
            Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 4)})
            Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})
            
            for _, v in pairs(list) do
                local IB = Create("TextButton", {
                    Parent = List, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.SourceSans, Text = v, TextColor3 = Theme.Text, TextSize = 14, ZIndex = 11
                })
                IB.MouseButton1Click:Connect(function()
                    Btn.Text = "  " .. v
                    task.spawn(callback, v)
                    open = false
                    Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.wait(0.2)
                    List.Visible = false
                end)
            end
            
            Btn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    List.Visible = true
                    local h = math.min(#list*25, 150)
                    Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, h)})
                    List.CanvasSize = UDim2.new(0,0,0,#list*25)
                else
                    Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.wait(0.2)
                    List.Visible = false
                end
            end)
        end
        
        function Elements:Colorpicker(text, default, callback)
            local col = default or Color3.new(1,1,1)
            local F = Create("Frame", {
                Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), ZIndex = 2
            })
            AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Prev = Create("TextButton", {
                Parent = F, BackgroundColor3 = col, Position = UDim2.new(1, -40, 0, 2), Size = UDim2.new(0, 40, 0, 21), Text = ""
            })
            Create("UICorner", {Parent = Prev, CornerRadius = UDim.new(0, 4)})
            
            local Picker = Create("Frame", {
                Parent = ScreenGui, BackgroundColor3 = Theme.Background, Size = UDim2.new(0, 200, 0, 220), Visible = false, ZIndex = 200
            })
            Create("UICorner", {Parent = Picker, CornerRadius = UDim.new(0, 6)})
            
            local PTitle = Create("TextLabel", {
                Parent = Picker, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Font = Enum.Font.SourceSansBold, Text = text, TextColor3 = Theme.Text, TextSize = 14
            })
            
            local SatVal = Create("ImageButton", {
                Parent = Picker, Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(0, 150, 0, 150), Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.new(1,0,0)
            })
            local SVCursor = Create("Frame", {
                Parent = SatVal, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(0,0,0,0), BorderSizePixel = 0, ZIndex = 201
            })
            Create("UICorner", {Parent = SVCursor, CornerRadius = UDim.new(1,0)})
            
            local HueBar = Create("ImageButton", {
                Parent = Picker, Position = UDim2.new(0, 170, 0, 30), Size = UDim2.new(0, 20, 0, 150), Image = "rbxassetid://5028857472"
            })
            local HueCursor = Create("Frame", {
                Parent = HueBar, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0,0,0,0), BorderSizePixel = 0, ZIndex = 201
            })
            
            local RGBBox = Create("Frame", {
                Parent = Picker, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 190), Size = UDim2.new(1, -20, 0, 25)
            })
            local Confirm = Create("TextButton", {
                Parent = RGBBox, BackgroundColor3 = Theme.Darker, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.SourceSans, Text = "Confirm", TextColor3 = Theme.Text
            })
            Create("UICorner", {Parent = Confirm, CornerRadius = UDim.new(0, 4)})
            
            local h, s, v = col:ToHSV()
            SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            
            local function UpdateColor()
                local c = Color3.fromHSV(h, s, v)
                Prev.BackgroundColor3 = c
                SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                pcall(callback, c)
            end
            
            local draggingSV = false
            SatVal.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSV = true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSV = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if draggingSV and (i.UserInputType==Enum.UserInputType.MouseMovement) then
                    local x = math.clamp((i.Position.X - SatVal.AbsolutePosition.X)/SatVal.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((i.Position.Y - SatVal.AbsolutePosition.Y)/SatVal.AbsoluteSize.Y, 0, 1)
                    s = x
                    v = 1-y
                    SVCursor.Position = UDim2.new(x, -2, y, -2)
                    UpdateColor()
                end
            end)
            
            local draggingH = false
            HueBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingH = true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingH = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if draggingH and (i.UserInputType==Enum.UserInputType.MouseMovement) then
                    local y = math.clamp((i.Position.Y - HueBar.AbsolutePosition.Y)/HueBar.AbsoluteSize.Y, 0, 1)
                    h = 1-y
                    HueCursor.Position = UDim2.new(0, 0, y, 0)
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    UpdateColor()
                end
            end)
            
            Confirm.MouseButton1Click:Connect(function() Picker.Visible = false end)
            Prev.MouseButton1Click:Connect(function() Picker.Visible = not Picker.Visible Picker.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y) end)
        end
        
        function Elements:Keybind(text, default, callback)
            local F = Create("Frame", {
                Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25)
            })
            AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(0.6, 0, 1, 0), Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local B = Create("TextButton", {
                Parent = F, BackgroundColor3 = Theme.Darker, Position = UDim2.new(0.7, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0), Font = Enum.Font.SourceSans, Text = default and default.Name or "None", TextColor3 = Theme.SubText, TextSize = 14
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
            
            local listening = false
            B.MouseButton1Click:Connect(function()
                listening = true
                B.Text = "..."
                B.TextColor3 = Theme.Accent
            end)
            UserInputService.InputBegan:Connect(function(i)
                if listening and i.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    B.Text = i.KeyCode.Name
                    B.TextColor3 = Theme.SubText
                    pcall(callback, i.KeyCode)
                end
            end)
        end
        
        function Elements:Textbox(text, placeholder, callback)
            local F = Create("Frame", {
                Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40)
            })
            AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local B = Create("TextBox", {
                Parent = F, BackgroundColor3 = Theme.Darker, Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 25), Font = Enum.Font.SourceSans, PlaceholderText = placeholder, Text = "", TextColor3 = Theme.Text, TextSize = 14
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
            B.FocusLost:Connect(function(enter) if enter then pcall(callback, B.Text) end end)
        end
        
        return Elements
    end
    
    local function Init()
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Tween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 701, 0, 400)})
        Lib:Notification("System", "Loaded successfully", 3)
    end
    
    if KeySystem then
        local KFrame = Create("Frame", {
            Parent = ScreenGui, BackgroundColor3 = Theme.KeySystem, Position = UDim2.new(0.5, -257, 0.5, -115), Size = UDim2.new(0, 514, 0, 231)
        })
        Create("UICorner", {Parent = KFrame, CornerRadius = UDim.new(0, 6)})
        MakeDraggable(KFrame, KFrame)
        
        Create("TextLabel", {
            Parent = KFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.1, 0), Size = UDim2.new(1, 0, 0, 30), Font = Enum.Font.SourceSansBold, Text = "Key System", TextColor3 = Theme.Text, TextSize = 20
        })
        Create("TextLabel", {
            Parent = KFrame, BackgroundTransparency = 1, Position = UDim2.new(0.1, 0, 0.3, 0), Size = UDim2.new(0.8, 0, 0, 40), Font = Enum.Font.SourceSans, Text = KeyNote, TextColor3 = Theme.SubText, TextSize = 14, TextWrapped = true
        })
        
        local Box = Create("TextBox", {
            Parent = KFrame, BackgroundColor3 = Theme.Main, Position = UDim2.new(0.2, 0, 0.5, 0), Size = UDim2.new(0.6, 0, 0, 40), Font = Enum.Font.SourceSans, PlaceholderText = "Enter Key", Text = "", TextColor3 = Theme.Text, TextSize = 14
        })
        Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
        
        local Btn = Create("TextButton", {
            Parent = KFrame, BackgroundColor3 = Theme.Accent, Position = UDim2.new(0.3, 0, 0.75, 0), Size = UDim2.new(0.4, 0, 0, 35), Font = Enum.Font.SourceSansBold, Text = "Submit", TextColor3 = Theme.Text, TextSize = 14
        })
        Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
        
        Btn.MouseButton1Click:Connect(function()
            if Box.Text == Key then
                Tween(KFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0)})
                task.wait(0.3)
                KFrame:Destroy()
                Init()
            else
                Btn.Text = "Incorrect"
                task.wait(1)
                Btn.Text = "Submit"
            end
        end)
    else
        Init()
    end
    
    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    return Lib
end

return Library
