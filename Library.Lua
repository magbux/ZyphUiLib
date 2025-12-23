local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Theme = {
    Main = Color3.fromRGB(40, 40, 40),
    Sidebar = Color3.fromRGB(31, 31, 31),
    Header = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(170, 170, 170),
    Accent = Color3.fromRGB(0, 120, 215),
    Border = Color3.fromRGB(0, 0, 0),
    Hover = Color3.fromRGB(50, 50, 50),
    Item = Color3.fromRGB(45, 45, 45),
    Warning = Color3.fromRGB(215, 175, 0)
}

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function MakeDraggable(trigger, obj)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
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
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Window(options)
    local Name = options.Name or "Library"
    local ScreenGui = Create("ScreenGui", {
        Name = "ZyphClassic",
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })
    
    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 1,
        BorderColor3 = Theme.Border,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true
    })
    
    local Header = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local Title = Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseBtn = Create("TextButton", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "X",
        TextColor3 = Theme.Text,
        TextSize = 14
    })
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    local MiniBtn = Create("TextButton", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "-",
        TextColor3 = Theme.Text,
        TextSize = 18
    })
    
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 130, 1, -30)
    })
    
    local SearchCont = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 1,
        BorderColor3 = Theme.Border,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 0, 25)
    })
    
    local SearchBox = Create("TextBox", {
        Parent = SearchCont,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -5, 1, 0),
        Font = Enum.Font.SourceSans,
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local TabCont = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0
    })
    Create("UIListLayout", {Parent = TabCont, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0)})
    
    local Content = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 130, 0, 30),
        Size = UDim2.new(1, -130, 1, -30),
        ClipsDescendants = true
    })
    
    local ResizeGrip = Create("TextButton", {
        Parent = Main,
        BackgroundTransparency = 1,
        TextColor3 = Theme.SubText,
        Text = "◢",
        TextSize = 14,
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 15, 0, 15),
        ZIndex = 10
    })
    
    local Resizing = false
    ResizeGrip.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Resizing = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Resizing = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if Resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local pos = UserInputService:GetMouseLocation()
            local mx = math.max(400, pos.X - Main.AbsolutePosition.X)
            local my = math.max(300, pos.Y - Main.AbsolutePosition.Y)
            Main.Size = UDim2.new(0, mx, 0, my)
        end
    end)
    
    MakeDraggable(Header, Main)
    
    local IsMin = false
    local OldSize = Main.Size
    MiniBtn.MouseButton1Click:Connect(function()
        IsMin = not IsMin
        if IsMin then
            OldSize = Main.Size
            ResizeGrip.Visible = false
            Sidebar.Visible = false
            Content.Visible = false
            Tween(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, OldSize.X.Offset, 0, 30)})
        else
            ResizeGrip.Visible = true
            Sidebar.Visible = true
            Content.Visible = true
            Tween(Main, TweenInfo.new(0.3), {Size = OldSize})
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
    
    local WindowAPI = {}
    local CurrentTab = nil
    
    local function UpdateSearch(text)
        if not CurrentTab then return end
        for _, obj in pairs(CurrentTab.Page:GetChildren()) do
            if obj:IsA("Frame") and obj:FindFirstChild("STag") then
                if string.find(string.lower(obj.STag.Value), string.lower(text)) then
                    obj.Visible = true
                else
                    obj.Visible = false
                end
            end
        end
        CurrentTab.Page.CanvasSize = UDim2.new(0, 0, 0, CurrentTab.Layout.AbsoluteContentSize.Y + 20)
    end
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function() UpdateSearch(SearchBox.Text) end)
    
    function WindowAPI:Notification(title, text, duration)
        local NF = Create("Frame", {
            Parent = NotifHolder, BackgroundColor3 = Theme.Main, Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, BorderSizePixel = 1, BorderColor3 = Theme.Border
        })
        local T = Create("TextLabel", {
            Parent = NF, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.SourceSansBold, Text = title, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
        })
        local M = Create("TextLabel", {
            Parent = NF, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 0, 0),
            Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.SubText, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        M.Size = UDim2.new(1, -20, 0, TextService:GetTextSize(text, 14, Enum.Font.SourceSans, Vector2.new(180, 999)).Y)
        local Bar = Create("Frame", {
            Parent = NF, BackgroundColor3 = Theme.Accent, Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(0, 0, 0, 2), BorderSizePixel = 0
        })
        Tween(NF, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35 + M.Size.Y.Offset)})
        Tween(Bar, TweenInfo.new(duration or 3), {Size = UDim2.new(1, 0, 0, 2)})
        task.delay(duration or 3, function()
            local t = Tween(NF, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)})
            t.Completed:Wait()
            NF:Destroy()
        end)
    end
    
    function WindowAPI:Tab(name)
        local Page = Create("ScrollingFrame", {
            Name = name, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, Visible = false, BorderSizePixel = 0
        })
        local Layout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20) end)
        
        local Btn = Create("TextButton", {
            Parent = TabCont, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Font = Enum.Font.SourceSans,
            Text = name, TextColor3 = Theme.SubText, TextSize = 14
        })
        local TabData = {Page = Page, Btn = Btn, Layout = Layout}
        
        Btn.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                CurrentTab.Btn.TextColor3 = Theme.SubText
                CurrentTab.Btn.BackgroundColor3 = Theme.Sidebar
                CurrentTab.Btn.BackgroundTransparency = 1
            end
            CurrentTab = TabData
            Page.Visible = true
            Btn.TextColor3 = Theme.Text
            Btn.BackgroundColor3 = Theme.Item
            Btn.BackgroundTransparency = 0
            UpdateSearch(SearchBox.Text)
        end)
        
        if CurrentTab == nil then
            CurrentTab = TabData
            Page.Visible = true
            Btn.TextColor3 = Theme.Text
            Btn.BackgroundColor3 = Theme.Item
            Btn.BackgroundTransparency = 0
        end
        
        local Elements = {}
        
        function Elements:AddSTag(obj, t)
            local tag = Instance.new("StringValue")
            tag.Name = "STag"
            tag.Value = t
            tag.Parent = obj
        end
        
        function Elements:Label(text)
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20)})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.SourceSans,
                Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        function Elements:Warning(text)
            local F = Create("Frame", {Parent = Page, BackgroundColor3 = Color3.fromRGB(60, 40, 40), Size = UDim2.new(1, 0, 0, 25), BorderSizePixel = 1, BorderColor3 = Theme.Warning})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), Font = Enum.Font.SourceSansBold,
                Text = "⚠ " .. text, TextColor3 = Theme.Warning, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        function Elements:Button(text, callback)
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
            Elements:AddSTag(F, text)
            local B = Create("TextButton", {
                Parent = F, BackgroundColor3 = Theme.Item, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.SourceSans,
                Text = text, TextColor3 = Theme.Text, TextSize = 14, AutoButtonColor = false, BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            B.MouseEnter:Connect(function() Tween(B, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover}) end)
            B.MouseLeave:Connect(function() Tween(B, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Item}) end)
            B.MouseButton1Click:Connect(function()
                Tween(B, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80,80,80)})
                task.wait(0.1)
                Tween(B, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Hover})
                task.spawn(callback)
            end)
        end
        
        function Elements:Toggle(text, default, callback)
            local s = default or false
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
            Elements:AddSTag(F, text)
            local B = Create("TextButton", {Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
            local Box = Create("Frame", {
                Parent = B, BackgroundColor3 = s and Theme.Accent or Theme.Item, Position = UDim2.new(0, 0, 0.5, -8), Size = UDim2.new(0, 16, 0, 16), BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            Create("TextLabel", {
                Parent = B, BackgroundTransparency = 1, Position = UDim2.new(0, 25, 0, 0), Size = UDim2.new(1, -25, 1, 0),
                Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            B.MouseButton1Click:Connect(function()
                s = not s
                Tween(Box, TweenInfo.new(0.2), {BackgroundColor3 = s and Theme.Accent or Theme.Item})
                task.spawn(callback, s)
            end)
        end
        
        function Elements:Slider(text, min, max, default, callback)
            local value = default or min
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40)})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 0, 20),
                Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValLbl = Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0.7, 0, 0, 0), Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.SourceSans, Text = tostring(value), TextColor3 = Theme.SubText, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right
            })
            local Trk = Create("Frame", {
                Parent = F, BackgroundColor3 = Theme.Item, Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 10), BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            local Fil = Create("Frame", {
                Parent = Trk, BackgroundColor3 = Theme.Accent, Size = UDim2.new((value-min)/(max-min), 0, 1, 0), BorderSizePixel = 0
            })
            local Grip = Create("TextButton", {Parent = Trk, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
            local drag = false
            local function move(i)
                local p = math.clamp((i.Position.X - Trk.AbsolutePosition.X)/Trk.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + ((max-min)*p))
                Fil.Size = UDim2.new(p, 0, 1, 0)
                ValLbl.Text = tostring(v)
                task.spawn(callback, v)
            end
            Grip.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true move(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
            UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then move(i) end end)
        end
        
        function Elements:Dropdown(text, list, callback)
            local open = false
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50), ZIndex = 5})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Main = Create("TextButton", {
                Parent = F, BackgroundColor3 = Theme.Item, Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.SourceSans, Text = " Select...", TextColor3 = Theme.SubText, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            local Scroll = Create("ScrollingFrame", {
                Parent = Main, BackgroundColor3 = Theme.Hover, Position = UDim2.new(0, 0, 1, 2), Size = UDim2.new(1, 0, 0, 0),
                Visible = false, CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 2, ZIndex = 10, BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder})
            for _, v in pairs(list) do
                local B = Create("TextButton", {
                    Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.SourceSans, Text = v, TextColor3 = Theme.Text, TextSize = 14, ZIndex = 11
                })
                B.MouseButton1Click:Connect(function()
                    Main.Text = "  " .. v
                    task.spawn(callback, v)
                    open = false
                    Tween(Scroll, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.wait(0.2)
                    Scroll.Visible = false
                end)
            end
            Main.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Scroll.Visible = true
                    Tween(Scroll, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.min(#list*25, 150))})
                    Scroll.CanvasSize = UDim2.new(0,0,0,#list*25)
                else
                    Tween(Scroll, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
                    task.wait(0.2)
                    Scroll.Visible = false
                end
            end)
        end
        
        function Elements:Colorpicker(text, default, callback)
            local col = default or Color3.new(1,1,1)
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), ZIndex = 2})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), Font = Enum.Font.SourceSans,
                Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Prev = Create("TextButton", {
                Parent = F, BackgroundColor3 = col, Position = UDim2.new(1, -40, 0, 2), Size = UDim2.new(0, 40, 0, 21), Text = "", BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            local Pick = Create("Frame", {
                Parent = ScreenGui, BackgroundColor3 = Theme.Main, Size = UDim2.new(0, 200, 0, 220), Visible = false, ZIndex = 100, BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            local H, S, V = col:ToHSV()
            local function Upd()
                local c = Color3.fromHSV(H, S, V)
                Prev.BackgroundColor3 = c
                pcall(callback, c)
            end
            local Sat = Create("ImageButton", {
                Parent = Pick, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(0, 150, 0, 150), Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.fromHSV(H, 1, 1), BorderSizePixel = 1
            })
            local Hue = Create("Frame", {
                Parent = Pick, Position = UDim2.new(0, 170, 0, 10), Size = UDim2.new(0, 20, 0, 150), BorderSizePixel = 1
            })
            Create("UIGradient", {Parent = Hue, Rotation = 90, Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,0,255)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
            }})
            local HueBtn = Create("TextButton", {Parent = Hue, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
            local Close = Create("TextButton", {
                Parent = Pick, BackgroundColor3 = Theme.Item, Position = UDim2.new(0, 10, 0, 180), Size = UDim2.new(0, 180, 0, 30), Font = Enum.Font.SourceSans, Text = "Confirm", TextColor3 = Theme.Text, TextSize = 14, BorderSizePixel = 1
            })
            local SDrag = false
            Sat.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then SDrag=true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then SDrag=false end end)
            UserInputService.InputChanged:Connect(function(i)
                if SDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    S = math.clamp((i.Position.X - Sat.AbsolutePosition.X)/Sat.AbsoluteSize.X,0,1)
                    V = 1 - math.clamp((i.Position.Y - Sat.AbsolutePosition.Y)/Sat.AbsoluteSize.Y,0,1)
                    Upd()
                end
            end)
            local HDrag = false
            HueBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then HDrag=true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then HDrag=false end end)
            UserInputService.InputChanged:Connect(function(i)
                if HDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    H = 1 - math.clamp((i.Position.Y - Hue.AbsolutePosition.Y)/Hue.AbsoluteSize.Y,0,1)
                    Sat.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    Upd()
                end
            end)
            Prev.MouseButton1Click:Connect(function() Pick.Visible = not Pick.Visible Pick.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y) end)
            Close.MouseButton1Click:Connect(function() Pick.Visible = false end)
        end
        
        function Elements:Keybind(text, default, callback)
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(0.6, 0, 1, 0), Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local B = Create("TextButton", {
                Parent = F, BackgroundColor3 = Theme.Item, Position = UDim2.new(0.7, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0), Font = Enum.Font.SourceSans, Text = default and default.Name or "None", TextColor3 = Theme.SubText, TextSize = 14, BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            local list = false
            B.MouseButton1Click:Connect(function() list = true B.Text = "..." B.TextColor3 = Theme.Accent end)
            UserInputService.InputBegan:Connect(function(i)
                if list and i.UserInputType == Enum.UserInputType.Keyboard then
                    list = false
                    B.Text = i.KeyCode.Name
                    B.TextColor3 = Theme.SubText
                    pcall(callback, i.KeyCode)
                end
            end)
        end
        
        function Elements:Textbox(text, placeholder, callback)
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40)})
            Elements:AddSTag(F, text)
            Create("TextLabel", {
                Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Enum.Font.SourceSans, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local B = Create("TextBox", {
                Parent = F, BackgroundColor3 = Theme.Item, Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 20), Font = Enum.Font.SourceSans, PlaceholderText = placeholder, Text = "", TextColor3 = Theme.Text, TextSize = 14, BorderSizePixel = 1, BorderColor3 = Theme.Border
            })
            B.FocusLost:Connect(function(e) if e then pcall(callback, B.Text) end end)
        end
        
        return Elements
    end
    
    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
    WindowAPI:Notification("System", "Library Loaded", 3)
    
    return WindowAPI
end

return Library
