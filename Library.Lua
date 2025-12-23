--[[ 
    IMPROVED UI LIBRARY 
    Designed for reliability and aesthetics.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ViewportSize = workspace.CurrentCamera.ViewportSize

local Library = {
    Accent = Color3.fromRGB(0, 122, 255), -- Default Blue Accent
    Theme = {
        Main = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(35, 35, 35),
        Stroke = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150)
    },
    OpenKey = Enum.KeyCode.RightControl
}

local UI_Name = "HyperionUI_" .. tostring(math.random(1, 100000))

--// UTILITY FUNCTIONS //--
local function Tween(obj, props, time)
    local info = TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            Tween(object, {Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)}, 0.1)
        end
    end)
end

function Library:Init()
    -- Protection
    if game:GetService("CoreGui"):FindFirstChild(UI_Name) then
        game:GetService("CoreGui"):FindFirstChild(UI_Name):Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = UI_Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if RunService:IsStudio() then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    else
        pcall(function() ScreenGui.Parent = CoreGui end)
        if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    end
    
    Library.Gui = ScreenGui
    
    --// NOTIFICATION SYSTEM //--
    local NotifyList = Instance.new("Frame")
    NotifyList.Name = "Notifications"
    NotifyList.Parent = ScreenGui
    NotifyList.BackgroundTransparency = 1
    NotifyList.Position = UDim2.new(1, -220, 1, -20)
    NotifyList.AnchorPoint = Vector2.new(1, 1)
    NotifyList.Size = UDim2.new(0, 200, 0, 0) -- Grows upwards

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = NotifyList
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIList.Padding = UDim.new(0, 5)

    Library.NotifyList = NotifyList
end

function Library:Notify(title, text, type)
    local Color = Library.Accent
    if type == "Warn" then Color = Color3.fromRGB(255, 170, 0) end
    if type == "Error" then Color = Color3.fromRGB(255, 50, 50) end
    if type == "Success" then Color = Color3.fromRGB(50, 255, 100) end

    local Frame = Instance.new("Frame")
    Frame.Parent = Library.NotifyList
    Frame.BackgroundColor3 = Library.Theme.Secondary
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, 0) -- Animate Open
    Frame.ClipsDescendants = true
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Frame
    Stroke.Color = Library.Theme.Stroke
    
    local Corner = Instance.new("UICorner")
    Corner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Desc = Instance.new("TextLabel")
    Desc.Parent = Frame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 10, 0, 25)
    Desc.Size = UDim2.new(1, -20, 0, 30)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = text
    Desc.TextColor3 = Library.Theme.Text
    Desc.TextSize = 13
    Desc.TextWrapped = true
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame")
    Bar.Parent = Frame
    Bar.BackgroundColor3 = Color
    Bar.BorderSizePixel = 0
    Bar.Position = UDim2.new(0, 0, 1, -2)
    Bar.Size = UDim2.new(1, 0, 0, 2)
    
    -- Animation
    Tween(Frame, {Size = UDim2.new(1, 0, 0, 60)}, 0.3)
    Tween(Bar, {Size = UDim2.new(0, 0, 0, 2)}, 4) -- 4 seconds duration
    
    task.delay(4, function()
        Tween(Frame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        Frame:Destroy()
    end)
end

function Library:Window(options)
    if not Library.Gui then Library:Init() end
    
    local WindowName = options.Name or "Library"
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Library.Gui
    MainFrame.BackgroundColor3 = Library.Theme.Main
    MainFrame.Size = UDim2.new(0, 600, 0, 375)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -187)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(0,0,0)
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.5

    -- Header
    local Header = Instance.new("Frame")
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Library.Theme.Secondary
    Header.Size = UDim2.new(1, 0, 0, 50)
    
    MakeDraggable(Header, MainFrame)
    
    local HeaderCorner = Instance.new("UICorner", Header)
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    
    -- Flatten bottom corners of header
    local BottomCover = Instance.new("Frame")
    BottomCover.Parent = Header
    BottomCover.BackgroundColor3 = Library.Theme.Secondary
    BottomCover.BorderSizePixel = 0
    BottomCover.Position = UDim2.new(0, 0, 1, -10)
    BottomCover.Size = UDim2.new(1, 0, 0, 10)
    
    -- User Profile
    local PFP = Instance.new("ImageLabel")
    PFP.Parent = Header
    PFP.BackgroundColor3 = Library.Theme.Main
    PFP.Position = UDim2.new(0, 10, 0, 8)
    PFP.Size = UDim2.new(0, 34, 0, 34)
    PFP.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    
    local PFPCorner = Instance.new("UICorner", PFP)
    PFPCorner.CornerRadius = UDim.new(1, 0)
    
    local PFPStroke = Instance.new("UIStroke", PFP)
    PFPStroke.Color = Library.Accent
    PFPStroke.Thickness = 1.5

    local WelcomeTitle = Instance.new("TextLabel")
    WelcomeTitle.Parent = Header
    WelcomeTitle.BackgroundTransparency = 1
    WelcomeTitle.Position = UDim2.new(0, 55, 0, 8)
    WelcomeTitle.Size = UDim2.new(0, 200, 0, 20)
    WelcomeTitle.Font = Enum.Font.GothamBold
    WelcomeTitle.Text = WindowName
    WelcomeTitle.TextColor3 = Library.Theme.Text
    WelcomeTitle.TextSize = 16
    WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left

    local UserSubtitle = Instance.new("TextLabel")
    UserSubtitle.Parent = Header
    UserSubtitle.BackgroundTransparency = 1
    UserSubtitle.Position = UDim2.new(0, 55, 0, 28)
    UserSubtitle.Size = UDim2.new(0, 200, 0, 12)
    UserSubtitle.Font = Enum.Font.Gotham
    UserSubtitle.Text = "Welcome, " .. LocalPlayer.DisplayName
    UserSubtitle.TextColor3 = Library.Theme.TextDark
    UserSubtitle.TextSize = 12
    UserSubtitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Window Controls
    local Controls = Instance.new("Frame")
    Controls.Parent = Header
    Controls.BackgroundTransparency = 1
    Controls.Position = UDim2.new(1, -100, 0, 0)
    Controls.Size = UDim2.new(0, 100, 1, 0)

    local function CreateControl(text, color, offset, callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = Controls
        Btn.BackgroundTransparency = 1
        Btn.Position = UDim2.new(1, offset, 0, 0)
        Btn.Size = UDim2.new(0, 40, 1, 0)
        Btn.Font = Enum.Font.GothamMedium
        Btn.Text = text
        Btn.TextColor3 = Library.Theme.TextDark
        Btn.TextSize = 16
        
        Btn.MouseEnter:Connect(function() Tween(Btn, {TextColor3 = color}) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, {TextColor3 = Library.Theme.TextDark}) end)
        Btn.MouseButton1Click:Connect(callback)
    end

    CreateControl("✕", Color3.fromRGB(255, 60, 60), -40, function() Library.Gui:Destroy() end)
    
    local Minimized = false
    local OldSize = MainFrame.Size
    CreateControl("−", Color3.fromRGB(255, 255, 255), -80, function()
        Minimized = not Minimized
        if Minimized then
            MainFrame:TweenSize(UDim2.new(0, 600, 0, 50), "Out", "Quad", 0.3)
        else
            MainFrame:TweenSize(OldSize, "Out", "Quad", 0.3)
        end
    end)
    
    CreateControl("⚙", Library.Accent, -120, function()
        Library.SettingsFrame.Visible = not Library.SettingsFrame.Visible
    end)
    
    -- Container Layout
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Library.Theme.Secondary
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 140, 1, -50)
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Library.Accent
    
    local SidebarPadding = Instance.new("UIPadding", Sidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 5)
    
    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 150, 0, 55)
    ContentArea.Size = UDim2.new(1, -160, 1, -65)

    --// SETTINGS POPUP //--
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "Settings"
    SettingsFrame.Parent = Library.Gui
    SettingsFrame.BackgroundColor3 = Library.Theme.Main
    SettingsFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
    SettingsFrame.Size = UDim2.new(0, 250, 0, 200)
    SettingsFrame.Visible = false
    SettingsFrame.ClipsDescendants = true
    SettingsFrame.ZIndex = 10
    
    Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", SettingsFrame).Color = Library.Theme.Stroke
    MakeDraggable(SettingsFrame, SettingsFrame)

    local SHeader = Instance.new("TextLabel", SettingsFrame)
    SHeader.BackgroundTransparency = 1
    SHeader.Size = UDim2.new(1,0,0,30)
    SHeader.Text = "Settings"
    SHeader.TextColor3 = Color3.fromRGB(255,255,255)
    SHeader.Font = Enum.Font.GothamBold
    SHeader.TextSize = 16
    SHeader.ZIndex = 11
    
    local SCreds = Instance.new("TextLabel", SettingsFrame)
    SCreds.BackgroundTransparency = 1
    SCreds.Position = UDim2.new(0, 15, 0, 40)
    SCreds.Size = UDim2.new(1, -30, 1, -50)
    SCreds.Font = Enum.Font.Gotham
    SCreds.Text = "Credits to:\n\n<font color='#5ca3ff'>magbux</font>\n<font color='#5ca3ff'>n0xxi</font>\n<font color='#5ca3ff'>ryusai</font>\n<font color='#5ca3ff'>rozui</font>\n\nfor making this with me"
    SCreds.RichText = true
    SCreds.TextColor3 = Library.Theme.TextDark
    SCreds.TextSize = 14
    SCreds.TextYAlignment = Enum.TextYAlignment.Top
    SCreds.ZIndex = 11
    
    Library.SettingsFrame = SettingsFrame

    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Library.OpenKey then
            Library.Gui.Enabled = not Library.Gui.Enabled
        end
    end)
    
    --// TAB HANDLING //--
    local WinData = {}
    local FirstTab = true
    
    function WinData:Tab(name, iconId)
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name .. "Frame"
        TabFrame.Parent = ContentArea
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.ScrollBarThickness = 2
        TabFrame.ScrollBarImageColor3 = Library.Accent
        
        local TabList = Instance.new("UIListLayout", TabFrame)
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 6)
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Library.Theme.Main
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -10, 0, 32)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Library.Theme.TextDark
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false
        
        local BtnCorner = Instance.new("UICorner", TabBtn)
        BtnCorner.CornerRadius = UDim.new(0, 6)
        
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.BackgroundColor3 = Library.Accent
        Indicator.Position = UDim2.new(0, 0, 0.25, 0)
        Indicator.Size = UDim2.new(0, 3, 0.5, 0)
        Indicator.Transparency = 1
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

        if FirstTab then
            FirstTab = false
            TabFrame.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Library.Theme.Text
            Indicator.Transparency = 0
        end
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentArea:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {BackgroundTransparency = 1, TextColor3 = Library.Theme.TextDark})
                    Tween(v.Frame, {Transparency = 1}) -- The Indicator
                end
            end
            
            TabFrame.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = Library.Theme.Text})
            Tween(Indicator, {Transparency = 0})
        end)
        
        --// ELEMENTS //--
        local Elements = {}
        
        function Elements:Section(text)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Parent = TabFrame
            SecLabel.BackgroundTransparency = 1
            SecLabel.Size = UDim2.new(1, 0, 0, 25)
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.Text = "  " .. text
            SecLabel.TextColor3 = Library.Theme.TextDark
            SecLabel.TextSize = 12
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        function Elements:Button(text, callback)
            local Container = Instance.new("Frame")
            Container.Parent = TabFrame
            Container.BackgroundColor3 = Library.Theme.Secondary
            Container.Size = UDim2.new(1, -5, 0, 38)
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = Container
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = text
            Btn.TextColor3 = Library.Theme.Text
            Btn.TextSize = 13
            
            Btn.MouseEnter:Connect(function() Tween(Container, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}) end)
            Btn.MouseLeave:Connect(function() Tween(Container, {BackgroundColor3 = Library.Theme.Secondary}) end)
            
            Btn.MouseButton1Click:Connect(function()
                local Ripple = Instance.new("Frame")
                Ripple.Parent = Container
                Ripple.BackgroundColor3 = Color3.fromRGB(255,255,255)
                Ripple.BackgroundTransparency = 0.8
                Ripple.Position = UDim2.new(0, 0, 0, 0)
                Ripple.Size = UDim2.new(0,0,0,0)
                Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1,0)
                
                Ripple.Position = UDim2.new(0, Mouse.X - Btn.AbsolutePosition.X, 0, Mouse.Y - Btn.AbsolutePosition.Y)
                Tween(Ripple, {Size = UDim2.new(0, 400, 0, 400), BackgroundTransparency = 1}, 0.5)
                task.delay(0.5, function() Ripple:Destroy() end)
                
                pcall(callback)
            end)
        end
        
        function Elements:Toggle(text, default, callback)
            local Toggled = default or false
            local Container = Instance.new("Frame")
            Container.Parent = TabFrame
            Container.BackgroundColor3 = Library.Theme.Secondary
            Container.Size = UDim2.new(1, -5, 0, 38)
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Container
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Switch = Instance.new("Frame")
            Switch.Parent = Container
            Switch.BackgroundColor3 = Toggled and Library.Accent or Color3.fromRGB(60, 60, 60)
            Switch.Position = UDim2.new(1, -45, 0.5, -10)
            Switch.Size = UDim2.new(0, 36, 0, 20)
            
            local SwitchCorner = Instance.new("UICorner", Switch)
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            
            local Dot = Instance.new("Frame")
            Dot.Parent = Switch
            Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Dot.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Dot.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = Container
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Text = ""
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetColor = Toggled and Library.Accent or Color3.fromRGB(60, 60, 60)
                
                Tween(Dot, {Position = TargetPos})
                Tween(Switch, {BackgroundColor3 = TargetColor})
                pcall(callback, Toggled)
            end)
        end
        
        function Elements:Slider(text, min, max, default, callback)
            local Value = default or min
            local Container = Instance.new("Frame")
            Container.Parent = TabFrame
            Container.BackgroundColor3 = Library.Theme.Secondary
            Container.Size = UDim2.new(1, -5, 0, 50)
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Container
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextBox") -- Editable
            ValueLabel.Parent = Container
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = Library.Accent
            ValueLabel.TextSize = 13
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local BarBack = Instance.new("Frame")
            BarBack.Parent = Container
            BarBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BarBack.Position = UDim2.new(0, 10, 0, 32)
            BarBack.Size = UDim2.new(1, -20, 0, 6)
            Instance.new("UICorner", BarBack).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame")
            Fill.Parent = BarBack
            Fill.BackgroundColor3 = Library.Accent
            Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local ClickPad = Instance.new("TextButton")
            ClickPad.Parent = BarBack
            ClickPad.BackgroundTransparency = 1
            ClickPad.Size = UDim2.new(1, 0, 1, 0)
            ClickPad.Text = ""
            
            local function Update(input)
                local SizeX = math.clamp((input.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(min + ((max - min) * SizeX))
                Tween(Fill, {Size = UDim2.new(SizeX, 0, 1, 0)}, 0.1)
                Value = NewValue
                ValueLabel.Text = tostring(Value)
                pcall(callback, Value)
            end
            
            ClickPad.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Update(input)
                    local move = UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement then Update(inp) end
                    end)
                    local endc; endc = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            move:Disconnect()
                            endc:Disconnect()
                        end
                    end)
                end
            end)
            
            ValueLabel.FocusLost:Connect(function()
                local n = tonumber(ValueLabel.Text)
                if n then
                    n = math.clamp(n, min, max)
                    Value = n
                    ValueLabel.Text = tostring(n)
                    Tween(Fill, {Size = UDim2.new((n - min) / (max - min), 0, 1, 0)})
                    pcall(callback, n)
                end
            end)
        end
        
        function Elements:TextBox(text, placeholder, callback)
            local Container = Instance.new("Frame")
            Container.Parent = TabFrame
            Container.BackgroundColor3 = Library.Theme.Secondary
            Container.Size = UDim2.new(1, -5, 0, 38)
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Container
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0, 150, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Parent = Container
            BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BoxFrame.Position = UDim2.new(1, -160, 0.5, -12)
            BoxFrame.Size = UDim2.new(0, 150, 0, 24)
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 4)
            Instance.new("UIStroke", BoxFrame).Color = Library.Theme.Stroke
            
            local Box = Instance.new("TextBox")
            Box.Parent = BoxFrame
            Box.BackgroundTransparency = 1
            Box.Position = UDim2.new(0, 5, 0, 0)
            Box.Size = UDim2.new(1, -10, 1, 0)
            Box.Font = Enum.Font.Gotham
            Box.PlaceholderText = placeholder or ""
            Box.Text = ""
            Box.TextColor3 = Library.Theme.Text
            Box.TextSize = 13
            
            Box.FocusLost:Connect(function()
                pcall(callback, Box.Text)
            end)
        end
        
        function Elements:Dropdown(text, list, callback)
            local Dropped = false
            local Container = Instance.new("Frame")
            Container.Parent = TabFrame
            Container.BackgroundColor3 = Library.Theme.Secondary
            Container.Size = UDim2.new(1, -5, 0, 38)
            Container.ClipsDescendants = true
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Container
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.6, 0, 0, 38)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = Container
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -30, 0, 9)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Image = "rbxassetid://6034818372" -- Down arrow
            Arrow.ImageColor3 = Library.Theme.TextDark
            
            local OpenBtn = Instance.new("TextButton")
            OpenBtn.Parent = Container
            OpenBtn.BackgroundTransparency = 1
            OpenBtn.Size = UDim2.new(1, 0, 0, 38)
            OpenBtn.Text = ""
            
            local DropList = Instance.new("UIListLayout", Container)
            DropList.SortOrder = Enum.SortOrder.LayoutOrder
            DropList.Padding = UDim.new(0, 3)
            
            -- Padding for list
            local Pad = Instance.new("UIPadding", Container)
            Pad.PaddingTop = UDim.new(0, 38)
            Pad.PaddingLeft = UDim.new(0, 10)
            Pad.PaddingRight = UDim.new(0, 10)
            Pad.PaddingBottom = UDim.new(0, 5)
            
            local Buttons = {}
            
            local function Refresh()
                local Count = 0
                for _,v in pairs(Container:GetChildren()) do
                    if v.Name == "DropOption" then v:Destroy() end
                end
                
                for _, item in pairs(list) do
                    local Op = Instance.new("TextButton")
                    Op.Name = "DropOption"
                    Op.Parent = Container
                    Op.BackgroundColor3 = Color3.fromRGB(45,45,45)
                    Op.Size = UDim2.new(1, 0, 0, 30)
                    Op.Font = Enum.Font.Gotham
                    Op.Text = item
                    Op.TextColor3 = Library.Theme.TextDark
                    Op.TextSize = 13
                    Instance.new("UICorner", Op).CornerRadius = UDim.new(0, 4)
                    
                    Op.MouseButton1Click:Connect(function()
                        Label.Text = text .. ": " .. item
                        pcall(callback, item)
                        Dropped = false
                        Tween(Container, {Size = UDim2.new(1, -5, 0, 38)}, 0.2)
                        Tween(Arrow, {Rotation = 0})
                    end)
                    Count = Count + 1
                end
                return Count
            end
            
            Refresh()

            OpenBtn.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                if Dropped then
                    local c = Refresh()
                    Tween(Container, {Size = UDim2.new(1, -5, 0, 38 + (c*33) + 5)}, 0.2)
                    Tween(Arrow, {Rotation = 180})
                else
                    Tween(Container, {Size = UDim2.new(1, -5, 0, 38)}, 0.2)
                    Tween(Arrow, {Rotation = 0})
                end
            end)
        end
        
        function Elements:ColorPicker(text, default, callback)
            local ColorVal = default or Color3.new(1,1,1)
            local Opened = false
            local Container = Instance.new("Frame")
            Container.Parent = TabFrame
            Container.BackgroundColor3 = Library.Theme.Secondary
            Container.Size = UDim2.new(1, -5, 0, 38)
            Container.ClipsDescendants = true
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Container
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0, 150, 0, 38)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Preview = Instance.new("TextButton")
            Preview.Parent = Container
            Preview.BackgroundColor3 = ColorVal
            Preview.Position = UDim2.new(1, -45, 0, 9)
            Preview.Size = UDim2.new(0, 35, 0, 20)
            Preview.Text = ""
            Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)
            
            -- Sliders
            local RGBBox = Instance.new("Frame")
            RGBBox.Parent = Container
            RGBBox.BackgroundTransparency = 1
            RGBBox.Position = UDim2.new(0, 0, 0, 40)
            RGBBox.Size = UDim2.new(1, 0, 0, 90)
            
            local function MakeSlide(name, y, color)
                local SFrame = Instance.new("Frame")
                SFrame.Parent = RGBBox
                SFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
                SFrame.Position = UDim2.new(0, 10, 0, y)
                SFrame.Size = UDim2.new(1, -20, 0, 10)
                Instance.new("UICorner", SFrame).CornerRadius = UDim.new(1,0)
                
                local Fill = Instance.new("Frame")
                Fill.Parent = SFrame
                Fill.Name = name
                Fill.BackgroundColor3 = color
                Fill.Size = UDim2.new(default and (name=="R" and default.R or (name=="G" and default.G or default.B)) or 1, 0, 1, 0)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)
                
                local Btn = Instance.new("TextButton")
                Btn.Parent = SFrame
                Btn.BackgroundTransparency = 1
                Btn.Size = UDim2.new(1,0,1,0)
                Btn.Text = ""
                
                Btn.MouseButton1Click:Connect(function() end) -- block click through
                
                local function UpdateC(input)
                    local sx = math.clamp((input.Position.X - SFrame.AbsolutePosition.X) / SFrame.AbsoluteSize.X, 0, 1)
                    Tween(Fill, {Size = UDim2.new(sx,0,1,0)}, 0.05)
                    
                    local r = RGBBox:FindFirstChild("R") and RGBBox.R.Size.X.Scale or 0
                    local g = RGBBox:FindFirstChild("G") and RGBBox.G.Size.X.Scale or 0
                    local b = RGBBox:FindFirstChild("B") and RGBBox.B.Size.X.Scale or 0
                    
                    ColorVal = Color3.new(r,g,b)
                    Preview.BackgroundColor3 = ColorVal
                    pcall(callback, ColorVal)
                end
                
                Btn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateC(input)
                        local m = UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then UpdateC(i) end end)
                        local e; e = UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end)
                    end
                end)
            end
            
            MakeSlide("R", 10, Color3.fromRGB(255, 80, 80))
            MakeSlide("G", 35, Color3.fromRGB(80, 255, 80))
            MakeSlide("B", 60, Color3.fromRGB(80, 80, 255))
            
            Preview.MouseButton1Click:Connect(function()
                Opened = not Opened
                Tween(Container, {Size = UDim2.new(1, -5, 0, Opened and 120 or 38)}, 0.2)
            end)
        end
        
        return Elements
    end
    
    return WinData
end

--------------------------------------------------------------------------------------
--// EXAMPLE USAGE //--
--------------------------------------------------------------------------------------

local MyWindow = Library:Window({Name = "My Script Hub"})

local MainTab = MyWindow:Tab("Main")
local WeaponTab = MyWindow:Tab("Weapons")
local VisualsTab = MyWindow:Tab("Visuals")

MainTab:Section("Player Stats")

MainTab:Toggle("God Mode", false, function(v)
    if v then
        Library:Notify("Success", "God mode enabled!", "Success")
    else
        Library:Notify("Warning", "God mode disabled", "Warn")
    end
end)

MainTab:Slider("WalkSpeed", 16, 200, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

MainTab:Slider("JumpPower", 50, 500, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

MainTab:Section("Interactions")

MainTab:TextBox("Target Player", "Enter name...", function(text)
    Library:Notify("System", "Target set to: " .. text, "Info")
end)

MainTab:Dropdown("Select Team", {"Red", "Blue", "Spectator"}, function(opt)
    print("Selected: "..opt)
end)

VisualsTab:ColorPicker("ESP Color", Color3.fromRGB(255,0,0), function(c)
    -- set esp color
end)

MainTab:Button("Kill All (Example)", function()
    Library:Notify("Action", "Kill all function executed.", "Info")
end)

Library:Notify("Welcome", "Script loaded successfully.", "Success")
