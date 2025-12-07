local Zyph = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Section = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(115, 80, 255),
    Text = Color3.fromRGB(230, 230, 230),
    TextDark = Color3.fromRGB(150, 150, 150),
    Outline = Color3.fromRGB(50, 50, 60)
}

local function GetParent()
    local success, result = pcall(function()
        return CoreGui
    end)
    if not success then
        return Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    return result
end

local function Create(instance, properties, children)
    local obj = Instance.new(instance)
    for i, v in pairs(properties or {}) do
        obj[i] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

function Zyph:CreateWindow(name)
    local ScreenGui = Create("ScreenGui", {
        Name = "ZyphUI",
        Parent = GetParent(),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350),
        ClipsDescendants = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIStroke", {Color = Theme.Outline, Thickness = 1})
    })

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35)
    }, {
        Create("TextLabel", {
            Name = "Title",
            Text = name or "Zyph UI",
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 200, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })

    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)

    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 40),
        Size = UDim2.new(0, 130, 1, -50),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0)
    }, {
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Section,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -162, 1, -50)
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 4)})
    })

    local Tabs = {}
    local FirstTab = true
    local Window = {}

    function Window:Tab(tabName)
        local Tab = {}
        
        local TabBtn = Create("TextButton", {
            Name = tabName,
            Parent = TabContainer,
            BackgroundColor3 = Theme.Section,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.GothamMedium,
            Text = tabName,
            TextColor3 = Theme.TextDark,
            TextSize = 13,
            AutoButtonColor = false
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        })

        local TabFrame = Create("ScrollingFrame", {
            Name = tabName .. "Frame",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0,0,0,0)
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, 
                Padding = UDim.new(0, 6),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }),
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 10), 
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        })

        local SearchFrame = Create("Frame", {
            Name = "SearchFrame",
            Parent = TabFrame,
            LayoutOrder = -1,
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(1, 0, 0, 30)
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Create("UIStroke", {Color = Theme.Outline, Thickness = 1}),
            Create("ImageLabel", {
                Image = "rbxassetid://3926305904",
                ImageRectOffset = Vector2.new(964, 324),
                ImageRectSize = Vector2.new(36, 36),
                ImageColor3 = Theme.TextDark,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 6, 0.5, -10)
            })
        })

        local SearchBox = Create("TextBox", {
            Parent = SearchFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 32, 0, 0),
            Size = UDim2.new(1, -38, 1, 0),
            Font = Enum.Font.Gotham,
            PlaceholderText = "Search...",
            Text = "",
            TextColor3 = Theme.Text,
            PlaceholderColor3 = Theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Theme.TextDark, BackgroundColor3 = Theme.Section}):Play()
                end
            end
            
            TabFrame.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundColor3 = Theme.Accent}):Play()
        end)

        if FirstTab then
            FirstTab = false
            TabBtn.TextColor3 = Theme.Text
            TabBtn.BackgroundColor3 = Theme.Accent
            TabFrame.Visible = true
        end
        
        local function UpdateCanvas()
            local layout = TabFrame:FindFirstChild("UIListLayout")
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end
        TabFrame.ChildAdded:Connect(UpdateCanvas)
        
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = SearchBox.Text:lower()
            for _, item in pairs(TabFrame:GetChildren()) do
                if item:IsA("Frame") and item.Name ~= "SearchFrame" then
                    local label = item:FindFirstChild("Title")
                    if label then
                        if label.Text:lower():find(query) then
                            item.Visible = true
                        else
                            item.Visible = false
                        end
                    end
                end
            end
            UpdateCanvas()
        end)

        function Tab:Label(text)
            local LabelFrame = Create("Frame", {
                Name = "Label",
                Parent = TabFrame,
                BackgroundColor3 = Theme.Background,
                Size = UDim2.new(1, 0, 0, 30)
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Create("TextLabel", {
                    Name = "Title",
                    Text = text,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0)
                })
            })
        end

        function Tab:Button(text, callback)
            local BtnFrame = Create("Frame", {
                Name = "Button",
                Parent = TabFrame,
                BackgroundColor3 = Theme.Background,
                Size = UDim2.new(1, 0, 0, 32)
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Create("UIStroke", {Color = Theme.Outline, Thickness = 1})
            })
            
            local Btn = Create("TextButton", {
                Name = "Title",
                Parent = BtnFrame,
                Text = text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 13
            })
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                task.wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Background}):Play()
                pcall(callback)
            end)
        end

        function Tab:Toggle(text, default, callback)
            local Toggled = default or false
            
            local ToggleFrame = Create("Frame", {
                Name = "Toggle",
                Parent = TabFrame,
                BackgroundColor3 = Theme.Background,
                Size = UDim2.new(1, 0, 0, 32)
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Create("UIStroke", {Color = Theme.Outline, Thickness = 1}),
                Create("TextLabel", {
                    Name = "Title",
                    Text = text,
                    Parent = ToggleFrame,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local CheckBox = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40,40,40),
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -32, 0.5, -11)
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)})
            })
            
            local Btn = Create("TextButton", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40,40,40)}):Play()
                pcall(callback, Toggled)
            end)
        end

        function Tab:Slider(text, min, max, default, callback)
            local Value = default or min
            
            local SliderFrame = Create("Frame", {
                Name = "Slider",
                Parent = TabFrame,
                BackgroundColor3 = Theme.Background,
                Size = UDim2.new(1, 0, 0, 45)
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Create("UIStroke", {Color = Theme.Outline, Thickness = 1}),
                Create("TextLabel", {
                    Name = "Title",
                    Text = text,
                    Parent = SliderFrame,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 10, 0, 4),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                Text = tostring(Value),
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 4),
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SlideBack = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 30)
            }, { Create("UICorner", {CornerRadius = UDim.new(0, 3)}) })
            
            local SlideFill = Create("Frame", {
                Parent = SlideBack,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            }, { Create("UICorner", {CornerRadius = UDim.new(0, 3)}) })
            
            local Trigger = Create("TextButton", {
                Parent = SlideBack,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local dragging = false
            Trigger.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local SizeScale = math.clamp((input.Position.X - SlideBack.AbsolutePosition.X) / SlideBack.AbsoluteSize.X, 0, 1)
                    local NewValue = math.floor(min + ((max - min) * SizeScale))
                    ValueLabel.Text = tostring(NewValue)
                    TweenService:Create(SlideFill, TweenInfo.new(0.05), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()
                    pcall(callback, NewValue)
                end
            end)
        end

        function Tab:Dropdown(text, options, callback)
            local Dropped = false
            
            local DropFrame = Create("Frame", {
                Name = "Dropdown",
                Parent = TabFrame,
                BackgroundColor3 = Theme.Background,
                Size = UDim2.new(1, 0, 0, 32),
                ClipsDescendants = true
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Create("UIStroke", {Color = Theme.Outline, Thickness = 1}),
                Create("TextLabel", {
                    Name = "Title",
                    Text = text .. "...",
                    Parent = DropFrame,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -40, 0, 32),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local DropBtn = Create("TextButton", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                Text = ""
            })
            
            local List = Create("Frame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 0, 0)
            }, {
                Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})
            })
            
            DropBtn.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                if Dropped then
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35 + (#options * 25) + 5)}):Play()
                else
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                end
            end)
            
            for _, option in pairs(options) do
                local OptBtn = Create("TextButton", {
                    Parent = List,
                    BackgroundColor3 = Theme.Background,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Theme.TextDark,
                    TextSize = 12,
                    BorderSizePixel = 0
                })
                
                OptBtn.MouseButton1Click:Connect(function()
                    Dropped = false
                    DropFrame.Title.Text = text .. ": " .. option
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                    pcall(callback, option)
                end)
            end
        end

        function Tab:ColorPicker(text, default, callback)
            local ColorVal = default or Color3.fromRGB(255, 255, 255)
            local Picking = false
            
            local ColorFrame = Create("Frame", {
                Name = "ColorPicker",
                Parent = TabFrame,
                BackgroundColor3 = Theme.Background,
                Size = UDim2.new(1, 0, 0, 32),
                ClipsDescendants = true
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Create("UIStroke", {Color = Theme.Outline, Thickness = 1}),
                Create("TextLabel", {
                    Name = "Title",
                    Text = text,
                    Parent = ColorFrame,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -50, 0, 32),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local ColorPreview = Create("TextButton", {
                Parent = ColorFrame,
                BackgroundColor3 = ColorVal,
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -32, 0, 5),
                Text = "",
                AutoButtonColor = false
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 4)})
            })

            local function UpdateColor()
                pcall(callback, ColorVal)
            end
            
            local RVal, GVal, BVal = ColorVal.R * 255, ColorVal.G * 255, ColorVal.B * 255
            
            local SlidersFrame = Create("Frame", {
                Parent = ColorFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 0, 100)
            })
            
            local function CreateColorSlider(yPos, colorType)
                local SFrame = Create("Frame", {
                    Parent = SlidersFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, yPos)
                })
                
                local Bar = Create("Frame", {
                    Parent = SFrame,
                    BackgroundColor3 = Color3.fromRGB(40,40,40),
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0.5, -2)
                }, { Create("UICorner", {CornerRadius = UDim.new(0, 2)}) })
                
                local Fill = Create("Frame", {
                    Parent = Bar,
                    BackgroundColor3 = colorType == "R" and Color3.fromRGB(255,50,50) or colorType == "G" and Color3.fromRGB(50,255,50) or Color3.fromRGB(50,50,255),
                    Size = UDim2.new(0, 0, 1, 0)
                })

                local InitVal = colorType == "R" and RVal or colorType == "G" and GVal or BVal
                Fill.Size = UDim2.new(InitVal/255, 0, 1, 0)
                
                local Trig = Create("TextButton", {
                    Parent = SFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                local draggingS = false
                Trig.MouseButton1Down:Connect(function() draggingS = true end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingS = false end end)
                
                UserInputService.InputChanged:Connect(function(i)
                    if draggingS and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local scale = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        Fill.Size = UDim2.new(scale, 0, 1, 0)
                        local val = math.floor(scale * 255)
                        if colorType == "R" then RVal = val elseif colorType == "G" then GVal = val else BVal = val end
                        ColorVal = Color3.fromRGB(RVal, GVal, BVal)
                        ColorPreview.BackgroundColor3 = ColorVal
                        UpdateColor()
                    end
                end)
            end
            
            CreateColorSlider(0, "R")
            CreateColorSlider(25, "G")
            CreateColorSlider(50, "B")
            
            ColorPreview.MouseButton1Click:Connect(function()
                Picking = not Picking
                if Picking then
                    TweenService:Create(ColorFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 120)}):Play()
                else
                    TweenService:Create(ColorFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                end
            end)
        end

        return Tab
    end

    return Window
end

return Zyph
