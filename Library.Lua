local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")local CurrentTab = nil
    
    local function UpdateSearch(query)
        query = query:lower()
        if
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Theme = {
    Main = Color3.fromRGB(35, 35, 35),
    Sidebar = Color CurrentTab then
            for _, frame in pairs(CurrentTab.Frame:GetChildren()) do
                if frame3.fromRGB(30, 30, 30),
    Background = Color3.fromRGB(:IsA("Frame") and frame:FindFirstChild("SearchTag") then
                    local tag = frame.Search25, 25, 25),
    Item = Color3.fromRGB(40, Tag.Value:lower()
                    if query == "" then
                        frame.Visible = true
                    else
                        if string40, 40),
    Hover = Color3.fromRGB(50, 50, 5.find(tag, query) then
                            frame.Visible = true
                        else
                            frame.Visible =0),
    Border = Color3.fromRGB(60, 60, 60),
     false
                        end
                    end
                end
            end
            CurrentTab.Frame.CanvasSize = UDimText = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Accent =2.new(0, 0, 0, CurrentTab.Layout.AbsoluteContentSize.Y +  Color3.fromRGB(0, 120, 215),
    Success = Color3.fromRGB(0, 200, 100),
    Error = Color3.fromRGB(200, 60, 60)
}

local function Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property]20)
        end
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        UpdateSearch(SearchBox.Text)
    end)
    
    local WindowAPI = {}
    
    function WindowAPI:Tab(name)
        local TabFrame = Utility:Create("ScrollingFrame", {
            Name = name,
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2. = value
    end
    return instance
end

local function Tween(instance, info, properties)
    local tween =new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBar TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

ImageColor3 = Theme.Stroke,
            Visible = false
        })
        
        local TabLayout = Utility:Createlocal function MakeDraggable(trigger, object)
    local dragging, dragInput, dragStart, startPos
    
("UIListLayout", {
            Parent = TabFrame,
            SortOrder = Enum.SortOrder.Layout    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputOrder,
            Padding = UDim.new(0, 5)
        })
        
        localType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
             TabPadding = Utility:Create("UIPadding", {
            Parent = TabFrame,
            PaddingTop =dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect( UDim.new(0, 10),
            PaddingLeft = UDim.new(0, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    trigger.InputChanged:Connect(function10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom =(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == UDim.new(0, 10)
        })
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
     0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        end)
        UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            
        local TabButton = Utility:Create("TextButton", {
            Name = name,
            Parent =local delta = input.Position - dragStart
            Tween(object, TweenInfo.new(0.05 TabContainer,
            BackgroundColor3 = Theme.SecondaryBackground,
            BorderSizePixel = 0,
            Size), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
end

function Library:Window(options)
    options = options or {}
    .SourceSans,
            Text = name,
            TextColor3 = Theme.SubText,
            TextSizelocal TitleText = options.Name or "Zyph UI"
    local KeySystem = options.KeySystem or false
     = 14
        })
        
        local TabObj = {Frame = TabFrame, Button = TabButton, Layout = TabLayout}
        table.insert(Tabs, TabObj)
        
        TabButton.local Key = options.Key or ""
    local KeyNote = options.KeyNote or "Get key from Discord"
    
    local ScreenGui = Create("ScreenGui", {
        Name = "ZyphLibrary",
        Parent = LocalPlayerMouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Frame.:WaitForChild("PlayerGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetVisible = false
                Utility:Tween(t.Button, TweenInfo.new(0.2), {BackgroundColorOnSpawn = false
    })
    
    local MainFrame = Create("Frame", {
        Name =3 = Theme.SecondaryBackground, TextColor3 = Theme.SubText})
            end
            CurrentTab = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        BorderSizePixel TabObj
            TabFrame.Visible = true
            Utility:Tween(TabButton, TweenInfo.new( = 0,
        Position = UDim2.new(0.5, -300, 0.2), {BackgroundColor3 = Theme.TertiaryBackground, TextColor3 = Theme.Text})
            0.5, -200),
        Size = UDim2.new(0, 60UpdateSearch(SearchBox.Text)
        end)
        
        if #Tabs == 1 then
0, 0, 400),
        ClipsDescendants = true,
        Visible = false            CurrentTab = TabObj
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Theme.
    })
    
    local MainStroke = Create("UIStroke", {
        Parent = MainFrame,TertiaryBackground
            TabButton.TextColor3 = Theme.Text
        end
        
        local ElementAPI
        Color = Theme.Border,
        Thickness = 1
    })
    
    local TitleBar = Create(" = {}
        
        local function AddSearchTag(frame, keyword)
            local tag = Utility:Create("StringValueFrame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0,", {
                Name = "SearchTag",
                Value = keyword,
                Parent = frame
            })
 0, 30)
    })
    
    local TitleLabel = Create("TextLabel", {        end
        
        function ElementAPI:Label(text)
            local Frame = Utility:Create("Frame", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            AddSearchTag(Frame,(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansBold, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency
        Text = TitleText,
        TextColor3 = Theme.Text,
        TextSize = 16 = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    MakeDraggable(TitleBar, MainFrame)
    
    local MinimizeBtn = Create("TextButton", {
        Parent = Title.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Bar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -3Left
            })
            return Frame
        end
        
        function ElementAPI:Warning(text)
            local0, 0, 0),
        Size = UDim2.new(0, 30, Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundColor3 = Color3. 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "-",
fromRGB(60, 40, 40),
                BorderSizePixel = 0,
                Size        TextColor3 = Theme.SubText,
        TextSize = 20
    })
    
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor = UDim2.new(1, 0, 0, 26)
            })
            Utility:Create("UIStroke", {Parent = Frame, Color = Color3.fromRGB(150, 3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0,50, 50), Thickness = 1})
            AddSearchTag(Frame, text)
             150, 1, -30)
    })
    
    local SidebarBorder = Create
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Border,
        BorderSizePixel =
                Position = UDim2.new(0, 5, 0, 0),
                Size = U 0,
        Position = UDim2.new(1, -1, 0, 0),Dim2.new(1, -5, 1, 0),
                Font = Enum.Font.Source
        Size = UDim2.new(0, 1, 1, 0)
    })SansBold,
                Text = "WARNING: " .. text,
                TextColor3 = Color3.fromRGB(
    
    local SearchFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Item255, 100, 100),
                TextSize = 14,
,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10                TextXAlignment = Enum.TextXAlignment.Left
            })
            return Frame
        end
        
, 0, 10),
        Size = UDim2.new(1, -20,        function ElementAPI:Button(text, callback)
            callback = callback or function() end
            local Frame 0, 25)
    })
    
    Create("UICorner", {
        Corner = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
Radius = UDim.new(0, 4),
        Parent = SearchFrame
    })
    
    local SearchBox = Create("TextBox", {
        Parent = SearchFrame,
        BackgroundTransparency = 1                Size = UDim2.new(1, 0, 0, 32)
            }),
        Position = UDim2.new(0, 5, 0, 0),
        Size = U
            AddSearchTag(Frame, text)
            
            local Btn = Utility:Create("TextButton",Dim2.new(1, -10, 1, 0),
        Font = Enum.Font {
                Parent = Frame,
                BackgroundColor3 = Theme.TertiaryBackground,
                BorderSizePixel = 0,
.SourceSans,
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = Theme.                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.LeftTextSize = 14
            })
            Utility:Create("UIStroke", {Parent = Btn, Color
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0 = Theme.Stroke, Thickness = 1})
            
            Btn.MouseEnter:Connect(function()
                , 45),
        Size = UDim2.new(1, 0, 1, -Utility:Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover})
45),
        CanvasSize = UDim2.new(0, 0, 0, 0            end)
            
            Btn.MouseLeave:Connect(function()
                Utility:Tween(Btn,),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent
    })
     TweenInfo.new(0.2), {BackgroundColor3 = Theme.TertiaryBackground})
            end)

    local TabLayout = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder =            
            Btn.MouseButton1Click:Connect(function()
                Utility:Ripple(Btn)
                task Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    .spawn(callback)
            end)
        end
        
        function ElementAPI:Toggle(text,})
    
    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = default, callback)
            callback = callback or function() end
            local Toggled = default or false
            
 MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,             local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)150, 0, 30),
        Size = UDim2.new(1, -
            })
            AddSearchTag(Frame, text)
            
            local Btn = Utility:Create("150, 1, -30),
        ClipsDescendants = true
    })
    TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim
    local ResizeGrip = Create("TextButton", {
        Parent = MainFrame,
        BackgroundTransparency = 12.new(1, 0, 1, 0),
                Text = ""
            })
,
        Position = UDim2.new(1, -15, 1, -15),            
            local CheckFrame = Utility:Create("Frame", {
                Parent = Btn,
                BackgroundColor3 = T
        Size = UDim2.new(0, 15, 0, 15),
oggled and Theme.Accent or Theme.TertiaryBackground,
                BorderSizePixel = 0,
                Position =        Text = "◢",
        TextColor3 = Theme.Border,
        TextSize = 14, UDim2.new(0, 0, 0.5, -9),
                Size = U
        ZIndex = 10
    })
    
    local NotificationArea = Create("Frame", {
        Dim2.new(0, 18, 0, 18)
            })
            UtilityParent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1:Create("UIStroke", {Parent = CheckFrame, Color = Theme.Stroke, Thickness = 1})
            
            local Label = Utility:Create("TextLabel", {
                Parent = Btn,
                BackgroundTransparency, -320, 1, -20),
        Size = UDim2.new(0, 3 = 1,
                Position = UDim2.new(0, 28, 0, 0),
00, 1, 0),
        AnchorPoint = Vector2.new(0, 1)                Size = UDim2.new(1, -28, 1, 0),
                Font
    })
    
    local NotifLayout = Create("UIListLayout", {
        Parent = Notification = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
Area,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }).Bottom,
        Padding = UDim.new(0, 10)
    })
    

            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                    local WindowFunctions = {}
    local CurrentTab = nil
    local IsMinimized = false
    local OldSizeUtility:Tween(CheckFrame, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Theme = MainFrame.Size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        if Is.Accent or Theme.TertiaryBackground})
                task.spawn(callback, Toggled)
            end)Minimized then
            Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad
        end
        
        function ElementAPI:Slider(text, min, max, default, callback)
, Enum.EasingDirection.Out), {Size = OldSize})
            MinimizeBtn.Text = "-"
                        callback = callback or function() end
            local Value = math.clamp(default or min, min, maxSidebar.Visible = true
            ContentContainer.Visible = true
            ResizeGrip.Visible = true
            )
            
            local Frame = Utility:Create("Frame", {
                Parent = TabFrame,
                IsMinimized = false
        else
            OldSize = MainFrame.Size
            Sidebar.Visible = false
BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0,            ContentContainer.Visible = false
            ResizeGrip.Visible = false
            Tween(MainFrame, Tween 45)
            })
            AddSearchTag(Frame, text)
            
            local Label =Info.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                 = UDim2.new(0, OldSize.X.Offset, 0, 30)})
Size = UDim2.new(1, 0, 0, 20),
                Font =            MinimizeBtn.Text = "+"
            IsMinimized = true
        end
    end)
    
     Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                local Resizing = false
    ResizeGrip.InputBegan:Connect(function(input)
        ifTextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
 input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = true
        end
                
            local ValLabel = Utility:Create("TextLabel", {
                Parent = Frame,
                Backgroundend)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = tostring(Value),
Type == Enum.UserInputType.MouseButton1 then
            Resizing = false
        end
    end)
                TextColor3 = Theme.SubText,
                TextSize = 14,
                TextXAlignment =    
    UserInputService.InputChanged:Connect(function(input)
        if Resizing and input.UserInput Enum.TextXAlignment.Right
            })
            
            local SliderBg = Utility:Create("Frame",Type == Enum.UserInputType.MouseMovement then
            local Location = UserInputService:GetMouseLocation()
            local {
                Parent = Frame,
                BackgroundColor3 = Theme.TertiaryBackground,
                BorderSizePixel =  NewX = math.max(400, Location.X - MainFrame.AbsolutePosition.X)
            0,
                Position = UDim2.new(0, 0, 0, 28),
                Sizelocal NewY = math.max(300, Location.Y - MainFrame.AbsolutePosition.Y) = UDim2.new(1, 0, 0, 6)
            })
            

            MainFrame.Size = UDim2.new(0, NewX, 0, NewY)            local SliderFill = Utility:Create("Frame", {
                Parent = SliderBg,
                BackgroundColor3 =
        end
    end)
    
    function WindowFunctions:Notification(title, msg, duration)
 Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((Value -        local NotifFrame = Create("Frame", {
            Parent = NotificationArea,
            BackgroundColor3 = Theme min) / (max - min), 0, 1, 0)
            })
            
            .Main,
            Size = UDim2.new(1, 0, 0, 0),
            local Trigger = Utility:Create("TextButton", {
                Parent = SliderBg,
                BackgroundTransparency = ClipsDescendants = true,
            BorderSizePixel = 0
        })
        
        Create("UIStroke", {1,
                Size = UDim2.new(1, 0, 1, 0),

            Parent = NotifFrame,
            Color = Theme.Border,
            Thickness = 1
                        Text = ""
            })
            
            local Dragging = false
            
            local function Update(})
        
        local Title = Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency =input)
                local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X 1,
            Position = UDim2.new(0, 10, 0, 5) / SliderBg.AbsoluteSize.X, 0, 1)
                local val = math.floor),
            Size = UDim2.new(1, -20, 0, 20),(min + ((max - min) * pos))
                Value = val
                ValLabel.Text = tostring(val)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0
            Font = Enum.Font.SourceSansBold,
            Text = title,
            TextColor3 = Theme)
                task.spawn(callback, val)
            end
            
            Trigger.InputBegan:.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local Message = Create("TextLabel", {
            Parent = NotifFrameConnect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10Dragging = true
                    Update(input)
                end
            end)
            
            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton, 0, 25),
            Size = UDim2.new(1, -20, 0, 30),
            Font = Enum.Font.SourceSans,
            Text = msg,1 then
                    Dragging = false
                end
            end)
            
            Services.UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.
            TextColor3 = Theme.SubText,
            TextSize = 14,
            TextWrapped =MouseMovement then
                    Update(input)
                end
            end)
        end
        
        function true,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local Bar = Create("Frame", {
            Parent = NotifFrame,
            BackgroundColor3 = Theme.Accent,
 ElementAPI:Textbox(text, placeholder, callback)
            callback = callback or function() end
            
            local Frame =            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1 Utility:Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                , -2),
            Size = UDim2.new(0, 0, 0, 2)
        Size = UDim2.new(1, 0, 0, 40)
            })
})
        
        Tween(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle            AddSearchTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent = Frame.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0,, 0, 60)})
        Tween(Bar, TweenInfo.new(duration or 5, 0, 20),
                Font = Enum.Font.SourceSans,
                Text = text, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = 2)})
        
        task.delay(duration or 5, function()
            local closeTween = Tween(Not Enum.TextXAlignment.Left
            })
            
            local Input = Utility:Create("TextBox", {ifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection
                Parent = Frame,
                BackgroundColor3 = Theme.TertiaryBackground,
                BorderSizePixel = 0.In), {Size = UDim2.new(1, 0, 0, 0)})
,
                Position = UDim2.new(0, 0, 0, 20),
                Size            closeTween.Completed:Wait()
            NotifFrame:Destroy()
        end)
    end
 = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                PlaceholderText = placeholder or "",
                Text = "",
                TextColor3 =    
    local function UpdateSearch(text)
        if CurrentTab then
            for _, item in pairs(CurrentTab. Theme.Text,
                TextSize = 14
            })
            Utility:Create("UIStroke",Frame:GetChildren()) do
                if item:IsA("Frame") and item:FindFirstChild("SearchTag {Parent = Input, Color = Theme.Stroke, Thickness = 1})
            
            Input.FocusLost") then
                    if string.find(string.lower(item.SearchTag.Value), string.lower(text)):Connect(function(enter)
                task.spawn(callback, Input.Text)
            end)
 then
                        item.Visible = true
                    else
                        item.Visible = false
                    end
                end        end
        
        function ElementAPI:Dropdown(text, list, callback)
            callback = callback or
            end
        end
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect( function() end
            local IsOpen = false
            
            local Frame = Utility:Create("Frame", {function()
        UpdateSearch(SearchBox.Text)
    end)
    
    function WindowFunctions:
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50),
                ZIndex = 5
            })
Tab(name)
        local TabFrame = Create("ScrollingFrame", {
            Name = name,
            Parent = Content            AddSearchTag(Frame, text)
            
            Utility:Create("TextLabel", {
                ParentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0 = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, , 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0, 20),
                Font = Enum.Font.SourceSans,
                Text =0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent, text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextX
            Visible = false
        })
        
        local Layout = Create("UIListLayout", {
            Alignment = Enum.TextXAlignment.Left
            })
            
            local MainBtn = Utility:Create("Parent = TabFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
        
        local Padding = Create("UIPadding",TextButton", {
                Parent = Frame,
                BackgroundColor3 = Theme.TertiaryBackground,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0,  {
            Parent = TabFrame,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)22),
                Size = UDim2.new(1, 0, 0, 24),
                Font = Enum.Font.SourceSans,
                Text = "Select...",
                TextColor3 = Theme.
        })
        
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabSubText,
                TextSize = 14
            })
            Utility:Create("UIStroke", {Frame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSizeParent = MainBtn, Color = Theme.Stroke, Thickness = 1})
            
            local ListFrame = Utility:Create.Y + 20)
        end)
        
        local TabBtn = Create("TextButton",("Frame", {
                Parent = MainBtn,
                BackgroundColor3 = Theme.SecondaryBackground,
                BorderSizePixel =  {
            Parent = TabContainer,
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 00,
                Position = UDim2.new(0, 0, 1, 2),
,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.SourceSans,
            Text = name,
            TextColor3 = Theme.Sub                Size = UDim2.new(1, 0, 0, 0),
                Visible = false,
Text,
            TextSize = 14
        })
        
        TabBtn.MouseButton1Click:                ZIndex = 10,
                ClipsDescendants = true
            })
            Utility:Create("UIStroke", {Parent = ListFrame, Color = Theme.Stroke, Thickness = 1})
            
Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                v.Visible            local ListLayout = Utility:Create("UIListLayout", {
                Parent = ListFrame,
                Sort = false
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, TweenInfo.new(0.2), {Order = Enum.SortOrder.LayoutOrder
            })
            
            for _, item in pairs(list)TextColor3 = Theme.SubText, BackgroundColor3 = Theme.Sidebar})
                end
            end
            
 do
                local ItemBtn = Utility:Create("TextButton", {
                    Parent = ListFrame,
                                CurrentTab = {Frame = TabFrame, Btn = TabBtn}
            TabFrame.Visible = true
            Tween(BackgroundColor3 = Theme.SecondaryBackground,
                    BorderSizePixel = 0,
                    Size = UDim2.TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundColor3 =new(1, 0, 0, 24),
                    Font = Enum.Font.SourceSans Theme.Item})
            UpdateSearch(SearchBox.Text)
        end)
        
        if Current,
                    Text = item,
                    TextColor3 = Theme.SubText,
                    TextSize = 1Tab == nil then
            CurrentTab = {Frame = TabFrame, Btn = TabBtn}
            TabFrame4,
                    ZIndex = 11
                })
                
                ItemBtn.MouseButton1Click:.Visible = true
            TabBtn.TextColor3 = Theme.Text
            TabBtn.BackgroundColor3 = Theme.Item
Connect(function()
                    MainBtn.Text = item
                    IsOpen = false
                    Utility:Tween(List        end
        
        local TabElements = {}
        
        function TabElements:Label(text)
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0
                Size = UDim2.new(1, 0, 0, 25)
            }), 0, 0)})
                    task.delay(0.2, function() ListFrame.Visible =
            
            local Tag = Create("StringValue", {
                Parent = Frame,
                Name = " false end)
                    task.spawn(callback, item)
                end)
            end
            
            MainBtn.SearchTag",
                Value = text
            })
            
            Create("TextLabel", {
                ParentMouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    List = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, Frame.Visible = true
                    local height = math.min(#list * 24, 1500, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text)
                    Utility:Tween(ListFrame, TweenInfo.new(0.2), {Size = UDim,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            return Frame
        end
        
        function Tab2.new(1, 0, 0, height)})
                else
                    Utility:Tween(ListElements:Warning(text)
            local Frame = Create("Frame", {
                Parent = TabFrame,
Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0                BackgroundColor3 = Color3.fromRGB(50, 30, 30),
                Size = UDim, 0, 0)})
                    task.delay(0.2, function() ListFrame.Visible =2.new(1, 0, 0, 30)
            })
            
            Create("UIC false end)
                end
            end)
        end
        
        function ElementAPI:Keybind(orner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Frametext, default, callback)
            callback = callback or function() end
            
            local Frame = Utility:Create("
            })
            
            Create("UIStroke", {
                Parent = Frame,
                Color = ThemeFrame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim.Error,
                Thickness = 1
            })
            
            local Tag = Create("StringValue", {
                Parent = Frame,
                Name = "SearchTag",
                Value = text
            })
2.new(1, 0, 0, 30)
            })
            AddSearchTag(Frame,            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
 text)
            
            Utility:Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency                Position = UDim2.new(0, 10, 0, 0),
                Size = 1,
                Size = UDim2.new(1, 0, 1, 0 = UDim2.new(1, -20, 1, 0),
                Font = Enum),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Font.SourceSansBold,
                Text = "WARNING: " .. text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment..Error,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local BindBtn = Utility:Create("TextButton", {
                Parent =Left
            })
        end
        
        function TabElements:Button(text, callback)
            callback Frame,
                BackgroundColor3 = Theme.TertiaryBackground,
                BorderSizePixel = 0,
                Position = callback or function() end
            
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0,  = UDim2.new(1, -80, 0.5, -11),
                0, 35)
            })
            
            local Tag = Create("StringValue", {
                Size = UDim2.new(0, 80, 0, 22),
                FontParent = Frame,
                Name = "SearchTag",
                Value = text
            })
            
             = Enum.Font.SourceSans,
                Text = default and default.Name or "None",
                TextColorlocal Btn = Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = Theme.Item,3 = Theme.SubText,
                TextSize = 14
            })
            Utility:Create("
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, UIStroke", {Parent = BindBtn, Color = Theme.Stroke, Thickness = 1})
            
            1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                local Listening = false
            
            BindBtn.MouseButton1Click:Connect(function()
                Listening = trueTextColor3 = Theme.Text,
                TextSize = 14
            })
            
            Create("
                BindBtn.Text = "..."
                BindBtn.TextColor3 = Theme.Accent
            end)UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent =
            
            Services.UserInputService.InputBegan:Connect(function(input)
                if Listening and Btn
            })
            
            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, input.UserInputType == Enum.UserInputType.Keyboard then
                    Listening = false
                    BindBtn.Text = TweenInfo.new(0.1), {BackgroundColor3 = Theme.Hover})
                task.wait(0 input.KeyCode.Name
                    BindBtn.TextColor3 = Theme.SubText
                    task.spawn(callback.1)
                Tween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme., input.KeyCode)
                end
            end)
        end
        
        function ElementAPI:ColorItem})
                pcall(callback)
            end)
        end
        
        function TabElements:picker(text, default, callback)
            callback = callback or function() end
            default = default or ColorToggle(text, default, callback)
            callback = callback or function() end
            local toggled = default or false
            
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency3.new(1, 1, 1)
            
            local Frame = Utility:Create("Frame", {
 = 1,
                Size = UDim2.new(1, 0, 0, 3                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(5)
            })
            
            local Tag = Create("StringValue", {
                Parent = Frame,1, 0, 0, 32),
                ZIndex = 4
            })
            
                Name = "SearchTag",
                Value = text
            })
            
            local Btn = CreateAddSearchTag(Frame, text)
            
            Utility:Create("TextLabel", {
                Parent =("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = U Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0Dim2.new(1, 0, 1, 0),
                Text = ""
            }), 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
            
            local Label = Create("TextLabel", {
                Parent = Btn,
                BackgroundTransparency = 1
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment =,
                Position = UDim2.new(0, 30, 0, 0),
 Enum.TextXAlignment.Left
            })
            
            local Preview = Utility:Create("TextButton",                Size = UDim2.new(1, -30, 1, 0),
                Font {
                Parent = Frame,
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                 = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
Position = UDim2.new(1, -40, 0.5, -9),
                                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })Size = UDim2.new(0, 40, 0, 18),
                Text
            
            local Indicator = Create("Frame", {
                Parent = Btn,
                BackgroundColor3 = togg = ""
            })
            Utility:Create("UIStroke", {Parent = Preview, Color = Theme.Strokeled and Theme.Accent or Theme.Item,
                BorderSizePixel = 0,
                Position = UDim, Thickness = 1})
            
            local Popup = Utility:Create("Frame", {
                Parent =2.new(0, 0, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20)
            })
            
             ScreenGui,
                BackgroundColor3 = Theme.MainBackground,
                BorderSizePixel = 0,
                SizeCreate("UICorner", {
                CornerRadius = UDim.new(0, 4),
                 = UDim2.new(0, 180, 0, 160),
                Visible = false,
                ZIndex = 100
            })
            Utility:Create("UIStrokeParent = Indicator
            })
            
            Btn.MouseButton1Click:Connect(function()
                toggled", {Parent = Popup, Color = Theme.Stroke, Thickness = 2})
            
            local function Create = not toggled
                local targetColor = toggled and Theme.Accent or Theme.Item
                Tween(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
                pcall(callbackGradientSlider(y, gradient, updateFunc)
                local Bg = Utility:Create("Frame", {
                    Parent, toggled)
            end)
        end
        
        function TabElements:Slider(text, min = Popup,
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel =, max, default, callback)
            callback = callback or function() end
            local value = default or min 0,
                    Position = UDim2.new(0, 10, 0, y),
                    Size = UDim2.new(0, 160, 0, 10),
            
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundTransparency =
                    ZIndex = 101
                })
                local Grad = Utility:Create("UIGrad 1,
                Size = UDim2.new(1, 0, 0, 50)
            ient", {Parent = Bg, Color = gradient})
                local Ind = Utility:Create("Frame", {Parent})
            
            local Tag = Create("StringValue", {
                Parent = Frame,
                Name = = Bg, BackgroundColor3 = Color3.new(1,1,1), BorderColor3 = Color3.new( "SearchTag",
                Value = text
            })
            
            Create("TextLabel", {
                Parent0,0,0), Size = UDim2.new(0, 2, 1, 4 = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, ), Position = UDim2.new(0,0,0,-2), ZIndex = 1020, 0, 20),
                Font = Enum.Font.SourceSans,
                Text =})
                local Trig = Utility:Create("TextButton", {Parent = Bg, BackgroundTransparency = 1, text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextX Size = UDim2.new(1,0,1,0), Text="", ZIndex = 103})
                
                local dragging = false
                Trig.InputBegan:Connect(function(iAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateFunc(i, Ind", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2., Bg) end end)
                Services.UserInputService.InputEnded:Connect(function(i) if inew(1, 0, 0, 20),
                Font = Enum.Font.SourceSans.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                Services.UserInputService,
                Text = tostring(value),
                TextColor3 = Theme.SubText,
                TextSize.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.Mouse = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
Movement then updateFunc(i, Ind, Bg) end end)
            end
            
            local h,            local SliderBar = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Theme.Item s, v = default:ToHSV()
            local function Update()
                local c = Color3.from,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0,HSV(h, s, v)
                Preview.BackgroundColor3 = c
                task.spawn(callback, 0, 30),
                Size = UDim2.new(1, 0, 0 c)
            end
            
            CreateGradientSlider(15, ColorSequence.new{
                Color, 6)
            })
            
            Create("UICorner", {
                CornerRadius = UDim.newSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint(0, 3),
                Parent = SliderBar
            })
            
            local Fill = Create(".new(0.2, Color3.fromHSV(0.2,1,1)),
                ColorFrame", {
                Parent = SliderBar,
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel =SequenceKeypoint.new(0.4, Color3.fromHSV(0.4,1,1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6,1,1 0,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            })
            
            Create("UICorner", {
                )),
                ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1CornerRadius = UDim.new(0, 3),
                Parent = Fill
            })
            
))
            }, function(i, ind, bg)
                local p = math.clamp((i.Position            local Trigger = Create("TextButton", {
                Parent = SliderBar,
                BackgroundTransparency = 1.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
,
                Size = UDim2.new(1, 0, 1, 0),
                                ind.Position = UDim2.new(p, -1, 0, -2)
                Text = ""
            })
            
            local dragging = false
            
            local function UpdateSlider(input)
h = p
                Update()
            end)
            
            CreateGradientSlider(40, ColorSequence                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / Slider.new(Color3.new(1,1,1), Color3.new(1,0,0)), function(Bar.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min +i, ind, bg)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
                ind.Position = U ((max - min) * pos))
                Fill.Size = UDim2.new(pos, 0, 1Dim2.new(p, -1, 0, -2)
                s = p
                Update, 0)
                ValueLabel.Text = tostring(newValue)
                pcall(callback, newValue()
            end)
            
            CreateGradientSlider(65, ColorSequence.new(Color3.)
            end
            
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)new(0,0,0), Color3.new(1,1,1)), function(i, ind
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
, bg)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
                ind.Position = UDim2.                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
new(p, -1, 0, -2)
                v = p
                Update()
                        end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
end)
            
            local ClosePick = Utility:Create("TextButton", {
                Parent = Popup,
            end)
        end
        
        function TabElements:Dropdown(text, list, callback)
                            BackgroundColor3 = Theme.TertiaryBackground,
                BorderSizePixel = 0,
                Position = UDimcallback = callback or function() end
            
            local Frame = Create("Frame", {
                Parent = Tab2.new(0, 10, 0, 120),
                Size = UDimFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 02.new(0, 160, 0, 30),
                Font = Enum., 0, 55),
                ZIndex = 2
            })
            
            local Tag = Create("Font.SourceSans,
                Text = "Done",
                TextColor3 = Theme.Text,
                TextSize = StringValue", {
                Parent = Frame,
                Name = "SearchTag",
                Value = text
14
            })
            
            ClosePick.MouseButton1Click:Connect(function() Popup.Visible =            })
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency =  false end)
            
            Preview.MouseButton1Click:Connect(function()
                Popup.Position = U1,
                Size = UDim2.new(1, 0, 0, 20),Dim2.new(0, Preview.AbsolutePosition.X + 50, 0, Preview.Absolute
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Position.Y)
                Popup.Visible = true
            end)
        end
        
        return ElementText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.LeftAPI
    end
    
    local function InitWindow()
        MainFrame.Visible = true
        Main
            })
            
            local MainBtn = Create("TextButton", {
                Parent = Frame,
Frame.Size = UDim2.new(0, 0, 0, 0)
        Utility                BackgroundColor3 = Theme.Item,
                BorderSizePixel = 0,
                Position = UDim2.:Tween(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.new(0, 0, 0, 25),
                Size = UDim2.new(EasingDirection.Out), {Size = UDim2.new(0, 600, 0,1, 0, 0, 30),
                Font = Enum.Font.SourceSans,
                Text = "   Select...",
                TextColor3 = Theme.SubText,
                TextSize = 14 400)})
        Notification("System", "Library initialized successfully.", 5)
    end
    
    ,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            Create("UICif KeySystem then
        local KeyFrame = Utility:Create("Frame", {
            Name = "KeySystemorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Main",
            Parent = ScreenGui,
            BackgroundColor3 = Theme.MainBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -150, 0.Btn
            })
            
            local Arrow = Create("TextLabel", {
                Parent = MainBtn,5, -75),
            Size = UDim2.new(0, 300, 
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 00, 150),
            AnchorPoint = Vector2.new(0.5, 0., 0),
                Size = UDim2.new(0, 30, 1, 5)
        })
        Utility:Create("UIStroke", {Parent = KeyFrame, Color = Theme.0),
                Font = Enum.Font.SourceSans,
                Text = "v",
                TextColor3 = Theme.Stroke, Thickness = 2})
        Utility:MakeDraggable(KeyFrame, KeyFrame)
        
SubText,
                TextSize = 14
            })
            
            local DropList = Create("        local KeyTitle = Utility:Create("TextLabel", {
            Parent = KeyFrame,
            BackgroundTransparencyFrame", {
                Parent = MainBtn,
                BackgroundColor3 = Theme.Item,
                BorderSizePixel = = 1,
            Position = UDim2.new(0, 0, 0, 1 0,
                Position = UDim2.new(0, 0, 1, 2),0),
            Size = UDim2.new(1, 0, 0, 20),
                Size = UDim2.new(1, 0, 0, 0),
                Cl
            Font = Enum.Font.SourceSansBold,
            Text = "Key System",
            TextColor3ipsDescendants = true,
                Visible = false,
                ZIndex = 5
            })
            
            Create = Theme.Text,
            TextSize = 18
        })
        
        local KeyNoteLbl("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Utility:Create("TextLabel", {
            Parent = KeyFrame,
            BackgroundTransparency = 1, = DropList
            })
            
            local ListLayout = Create("UIListLayout", {
                Parent
            Position = UDim2.new(0, 10, 0, 35),
            Size = = DropList,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            local UDim2.new(1, -20, 0, 20),
            Font = Enum opened = false
            
            for _, item in pairs(list) do
                local ItemBtn = Create("Text.Font.SourceSans,
            Text = KeyNote,
            TextColor3 = Theme.SubText,
Button", {
                    Parent = DropList,
                    BackgroundColor3 = Theme.Item,
                    BorderSizePixel =            TextSize = 14
        })
        
        local KeyBox = Utility:Create("TextBox", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.TertiaryBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0.1, 0, 0.5 0,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.SourceSans,
                    Text = item,
                    TextColor3 = Theme.SubText,
                    TextSize = 14,
                    ZIndex = 6
                })
, 0),
            Size = UDim2.new(0.8, 0, 0,                
                ItemBtn.MouseButton1Click:Connect(function()
                    MainBtn.Text = "   " 30),
            Font = Enum.Font.SourceSans,
            PlaceholderText = "Enter Key...", .. item
                    pcall(callback, item)
                    opened = false
                    Tween(DropList, Tween
            Text = "",
            TextColor3 = Theme.Text,
            TextSize = 14
        Info.new(0.2), {Size = UDim2.new(1, 0, 0})
        
        local SubmitBtn = Utility:Create("TextButton", {
            Parent = KeyFrame,, 0)})
                    task.wait(0.2)
                    DropList.Visible = false
                
            BackgroundColor3 = Theme.Hover,
            BorderSizePixel = 0,
            Position = UDim2.new(0.3, 0, 0.8, 0),
            Size = UDimend)
            end
            
            MainBtn.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    DropList.Visible = true
                    Tween(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0,2.new(0.4, 0, 0, 25),
            Font = Enum.Font.SourceSans,
            Text = "Submit",
            TextColor3 = Theme.Text,
            Text math.min(#list * 30, 150))})
                else
                    Tween(DropListSize = 14
        })
        
        local CloseKey = Utility:Create("TextButton", {
            Parent, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0)})
                    task.wait(0.2)
                    DropList.Visible = false -25, 0, 5),
            Size = UDim2.new(0, 2
                end
            end)
        end
        
        function TabElements:Colorpicker(text, default0, 0, 20),
            Text = "X",
            TextColor3 = Theme.Sub, callback)
            callback = callback or function() end
            default = default or Color3.new(1, Text,
            TextSize = 16
        })
        CloseKey.MouseButton1Click:Connect(1, 1)
            
            local Frame = Create("Frame", {
                Parent = TabFrame,function() ScreenGui:Destroy() end)
        
        SubmitBtn.MouseButton1Click:Connect(function()
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                ZIndex = 2
            })
            
            local Tag = Create("StringValue", {
                Parent = Frame,
                Name = "SearchTag",
                Value = text
            })
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency =
            if KeyBox.Text == Key then
                KeyFrame:Destroy()
                InitWindow()
            else
                KeyBox.Text = "Incorrect"
                task.wait(1)
                KeyBox.Text = ""
            end
        end)
    else
        InitWindow()
    end
    
    Services.UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    return WindowAPI
end

return Library
