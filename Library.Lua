local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}
local UI_Name = "CustomUI_" .. tostring(math.random(1, 100000))

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
	end

	topbarobject.InputBegan:Connect(function(input)
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

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

function Library:Init()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = UI_Name
	ScreenGui.ResetOnSpawn = false
	
	if RunService:IsStudio() then
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	else
		pcall(function()
			ScreenGui.Parent = CoreGui
		end)
		if not ScreenGui.Parent then
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end
	end

	local NotifyHolder = Instance.new("Frame")
	NotifyHolder.Name = "Notifications"
	NotifyHolder.Parent = ScreenGui
	NotifyHolder.BackgroundTransparency = 1
	NotifyHolder.Position = UDim2.new(0.85, 0, 0.7, 0)
	NotifyHolder.Size = UDim2.new(0, 200, 0, 300)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = NotifyHolder
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Padding = UDim.new(0, 5)

	Library.ScreenGui = ScreenGui
	Library.NotifyHolder = NotifyHolder
	
	-- CREDITS SETTINGS GUI
	local SettingsFrame = Instance.new("Frame")
	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.Parent = ScreenGui
	SettingsFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
	SettingsFrame.BorderSizePixel = 0
	SettingsFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
	SettingsFrame.Size = UDim2.new(0, 250, 0, 150)
	SettingsFrame.Visible = false
	
	MakeDraggable(SettingsFrame, SettingsFrame)
	
	local SettingsTitle = Instance.new("TextLabel")
	SettingsTitle.Parent = SettingsFrame
	SettingsTitle.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	SettingsTitle.BorderSizePixel = 0
	SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
	SettingsTitle.Font = Enum.Font.SourceSansBold
	SettingsTitle.Text = "Settings"
	SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	SettingsTitle.TextSize = 16
	
	local CreditsLabel = Instance.new("TextLabel")
	CreditsLabel.Parent = SettingsFrame
	CreditsLabel.BackgroundTransparency = 1
	CreditsLabel.Position = UDim2.new(0, 10, 0, 40)
	CreditsLabel.Size = UDim2.new(1, -20, 1, -50)
	CreditsLabel.Font = Enum.Font.SourceSans
	CreditsLabel.Text = "Credits to:\nmagbux\nn0xxi\nryusai\nrozui\n\nfor making ts wih me"
	CreditsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	CreditsLabel.TextSize = 14
	CreditsLabel.TextWrapped = true
	CreditsLabel.TextYAlignment = Enum.TextYAlignment.Top
	
	local CloseSettings = Instance.new("TextButton")
	CloseSettings.Parent = SettingsFrame
	CloseSettings.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	CloseSettings.BorderSizePixel = 0
	CloseSettings.Position = UDim2.new(1, -25, 0, 0)
	CloseSettings.Size = UDim2.new(0, 25, 0, 30)
	CloseSettings.Font = Enum.Font.SourceSansBold
	CloseSettings.Text = "X"
	CloseSettings.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseSettings.TextSize = 14
	CloseSettings.MouseButton1Click:Connect(function()
		SettingsFrame.Visible = false
	end)
	
	Library.SettingsFrame = SettingsFrame
end

function Library:Notify(text, isWarning)
	local Label = Instance.new("TextLabel")
	Label.Parent = Library.NotifyHolder
	Label.BackgroundColor3 = isWarning and Color3.fromRGB(200, 120, 0) or Color3.fromRGB(49, 49, 49)
	Label.BorderSizePixel = 0
	Label.Size = UDim2.new(1, 0, 0, 0) 
	Label.Font = Enum.Font.SourceSans
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 14
	Label.TextTransparency = 1
	Label.BackgroundTransparency = 1
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = Label

	local TweenIn = TweenService:Create(Label, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 50), TextTransparency = 0, BackgroundTransparency = 0})
	TweenIn:Play()
	
	task.delay(4, function()
		local TweenOut = TweenService:Create(Label, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 0), TextTransparency = 1, BackgroundTransparency = 1})
		TweenOut:Play()
		TweenOut.Completed:Connect(function()
			Label:Destroy()
		end)
	end)
end

function Library:CreateWindow(title)
	if not Library.ScreenGui then Library:Init() end
	
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Library.ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.225, 0, 0.229, 0)
	MainFrame.Size = UDim2.new(0, 738, 0, 343)
	
	MakeDraggable(MainFrame, MainFrame)
	
	-- Header Elements
	local UserImage = Instance.new("ImageLabel")
	UserImage.Parent = MainFrame
	UserImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserImage.BackgroundTransparency = 1
	UserImage.Position = UDim2.new(0.01, 0, 0.02, 0)
	UserImage.Size = UDim2.new(0, 37, 0, 37)
	
	local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	if isReady then UserImage.Image = content end
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(1,0)
	Corner.Parent = UserImage
	
	local WelcomeText = Instance.new("TextLabel")
	WelcomeText.Parent = MainFrame
	WelcomeText.BackgroundTransparency = 1
	WelcomeText.Position = UDim2.new(0.08, 0, 0.02, 0)
	WelcomeText.Size = UDim2.new(0, 200, 0, 37)
	WelcomeText.Font = Enum.Font.SourceSansBold
	WelcomeText.Text = "Welcome, " .. LocalPlayer.DisplayName
	WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	WelcomeText.TextSize = 16
	WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
	
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Parent = MainFrame
	CloseBtn.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Position = UDim2.new(0.94, 0, 0.02, 0)
	CloseBtn.Size = UDim2.new(0, 39, 0, 37)
	CloseBtn.Font = Enum.Font.SourceSans
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 14
	CloseBtn.MouseButton1Click:Connect(function()
		Library.ScreenGui:Destroy()
	end)

	local MinBtn = Instance.new("TextButton")
	MinBtn.Parent = MainFrame
	MinBtn.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	MinBtn.BorderSizePixel = 0
	MinBtn.Position = UDim2.new(0.88, 0, 0.02, 0)
	MinBtn.Size = UDim2.new(0, 39, 0, 37)
	MinBtn.Font = Enum.Font.SourceSans
	MinBtn.Text = "-"
	MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinBtn.TextSize = 14
	
	local SettingsBtn = Instance.new("TextButton")
	SettingsBtn.Parent = MainFrame
	SettingsBtn.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	SettingsBtn.BorderSizePixel = 0
	SettingsBtn.Position = UDim2.new(0.82, 0, 0.02, 0)
	SettingsBtn.Size = UDim2.new(0, 39, 0, 37)
	SettingsBtn.Font = Enum.Font.SourceSans
	SettingsBtn.Text = "⚙️"
	SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SettingsBtn.TextSize = 14
	SettingsBtn.MouseButton1Click:Connect(function()
		Library.SettingsFrame.Visible = not Library.SettingsFrame.Visible
	end)
	
	-- Sidebar (Right Side)
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Parent = MainFrame
	Sidebar.Active = true
	Sidebar.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0.686, 0, 0.27, 0)
	Sidebar.Size = UDim2.new(0, 215, 0, 230)
	Sidebar.ScrollBarThickness = 2
	
	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Parent = Sidebar
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarLayout.Padding = UDim.new(0, 5)

	-- Content Area (Left Side)
	local Container = Instance.new("Frame")
	Container.Parent = MainFrame
	Container.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
	Container.BorderSizePixel = 0
	Container.Position = UDim2.new(0.02, 0, 0.27, 0)
	Container.Size = UDim2.new(0, 480, 0, 230)
	
	-- Logic for Minimizing
	local Expanded = true
	local OriginalSize = MainFrame.Size
	MinBtn.MouseButton1Click:Connect(function()
		Expanded = not Expanded
		if Expanded then
			MainFrame:TweenSize(OriginalSize, "Out", "Quad", 0.3)
			Container.Visible = true
			Sidebar.Visible = true
		else
			MainFrame:TweenSize(UDim2.new(0, 738, 0, 50), "Out", "Quad", 0.3)
			Container.Visible = false
			Sidebar.Visible = false
		end
	end)

	local Window = {}
	local FirstTab = true

	function Window:Tab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Parent = Sidebar
		TabButton.BackgroundColor3 = Color3.fromRGB(101, 101, 101)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, -5, 0, 36)
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = name
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.TextSize = 14
		
		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Parent = Container
		TabFrame.BackgroundTransparency = 1
		TabFrame.BorderSizePixel = 0
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.ScrollBarThickness = 4
		TabFrame.Visible = false
		
		local TabList = Instance.new("UIListLayout")
		TabList.Parent = TabFrame
		TabList.SortOrder = Enum.SortOrder.LayoutOrder
		TabList.Padding = UDim.new(0, 5)
		TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		
		local TabPadding = Instance.new("UIPadding")
		TabPadding.Parent = TabFrame
		TabPadding.PaddingTop = UDim.new(0, 10)
		
		if FirstTab then
			FirstTab = false
			TabFrame.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		end
		
		TabButton.MouseButton1Click:Connect(function()
			for _, v in pairs(Container:GetChildren()) do
				if v:IsA("ScrollingFrame") then v.Visible = false end
			end
			for _, v in pairs(Sidebar:GetChildren()) do
				if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(101, 101, 101) end
			end
			TabFrame.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		end)
		
		local Elements = {}
		
		function Elements:Button(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Parent = TabFrame
			Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Btn.Size = UDim2.new(0, 450, 0, 35)
			Btn.Font = Enum.Font.SourceSans
			Btn.Text = text
			Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
			Btn.TextSize = 14
			
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.Parent = Btn
			
			Btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end
		
		function Elements:Toggle(text, default, callback)
			local Toggled = default or false
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Frame.Size = UDim2.new(0, 450, 0, 35)
			
			local Corner = Instance.new("UICorner")
			Corner.Parent = Frame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = Frame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.Size = UDim2.new(0, 300, 1, 0)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Parent = Frame
			ToggleBtn.BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
			ToggleBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
			ToggleBtn.Size = UDim2.new(0, 50, 0, 20)
			ToggleBtn.Text = ""
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.Parent = ToggleBtn
			
			ToggleBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				ToggleBtn.BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
				pcall(callback, Toggled)
			end)
		end
		
		function Elements:Slider(text, min, max, default, callback)
			local Value = default or min
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Frame.Size = UDim2.new(0, 450, 0, 50)
			
			local Corner = Instance.new("UICorner")
			Corner.Parent = Frame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = Frame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.Size = UDim2.new(1, -20, 0, 25)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text .. ": " .. tostring(Value)
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local SliderBar = Instance.new("TextButton")
			SliderBar.Parent = Frame
			SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			SliderBar.Position = UDim2.new(0, 10, 0, 30)
			SliderBar.Size = UDim2.new(1, -20, 0, 10)
			SliderBar.Text = ""
			SliderBar.AutoButtonColor = false
			
			local BarCorner = Instance.new("UICorner")
			BarCorner.Parent = SliderBar
			
			local Fill = Instance.new("Frame")
			Fill.Parent = SliderBar
			Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
			
			local FillCorner = Instance.new("UICorner")
			FillCorner.Parent = Fill
			
			local function UpdateSlider(input)
				local SizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				Fill.Size = UDim2.new(SizeX, 0, 1, 0)
				Value = math.floor(min + ((max - min) * SizeX))
				Label.Text = text .. ": " .. tostring(Value)
				pcall(callback, Value)
			end
			
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local moveCon, releaseCon
					UpdateSlider(input)
					moveCon = UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							UpdateSlider(input)
						end
					end)
					releaseCon = UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							moveCon:Disconnect()
							releaseCon:Disconnect()
						end
					end)
				end
			end)
		end

		function Elements:TextBox(placeholder, callback)
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Frame.Size = UDim2.new(0, 450, 0, 40)
			
			local Corner = Instance.new("UICorner")
			Corner.Parent = Frame

			local Box = Instance.new("TextBox")
			Box.Parent = Frame
			Box.BackgroundTransparency = 1
			Box.Size = UDim2.new(1, 0, 1, 0)
			Box.Font = Enum.Font.SourceSans
			Box.PlaceholderText = placeholder
			Box.Text = ""
			Box.TextColor3 = Color3.fromRGB(255, 255, 255)
			Box.TextSize = 14
			
			Box.FocusLost:Connect(function(enterPressed)
				pcall(callback, Box.Text)
			end)
		end
		
		function Elements:ColorPicker(text, default, callback)
			local Open = false
			local ColorVal = default or Color3.fromRGB(255,255,255)
			
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Frame.Size = UDim2.new(0, 450, 0, 35)
			Frame.ClipsDescendants = true
			
			local Corner = Instance.new("UICorner")
			Corner.Parent = Frame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = Frame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.Size = UDim2.new(0, 300, 0, 35)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local Preview = Instance.new("TextButton")
			Preview.Parent = Frame
			Preview.BackgroundColor3 = ColorVal
			Preview.Position = UDim2.new(0.85, 0, 0.2, 0)
			Preview.Size = UDim2.new(0, 50, 0, 20)
			Preview.Text = ""
			
			local PreCorner = Instance.new("UICorner")
			PreCorner.Parent = Preview

			-- Sliders Container
			local SliderContainer = Instance.new("Frame")
			SliderContainer.Parent = Frame
			SliderContainer.BackgroundTransparency = 1
			SliderContainer.Position = UDim2.new(0, 0, 0, 35)
			SliderContainer.Size = UDim2.new(1, 0, 0, 90)
			
			local function MakeCSlider(yPos, colorType)
				local SFrame = Instance.new("Frame")
				SFrame.Parent = SliderContainer
				SFrame.BackgroundTransparency = 1
				SFrame.Position = UDim2.new(0, 10, 0, yPos)
				SFrame.Size = UDim2.new(1, -20, 0, 20)
				
				local Bar = Instance.new("TextButton")
				Bar.Parent = SFrame
				Bar.BackgroundColor3 = Color3.fromRGB(20,20,20)
				Bar.Size = UDim2.new(1, 0, 0, 10)
				Bar.Position = UDim2.new(0, 0, 0, 5)
				Bar.Text = ""
				Bar.AutoButtonColor = false
				
				local Fill = Instance.new("Frame")
				Fill.Parent = Bar
				Fill.BackgroundColor3 = colorType == "R" and Color3.new(1,0,0) or (colorType == "G" and Color3.new(0,1,0) or Color3.new(0,0,1))
				Fill.Size = UDim2.new(1, 0, 1, 0) -- starts full
				
				local function UpdateColor()
					local r = colorType == "R" and Fill.Size.X.Scale or (ColorVal.R)
					local g = colorType == "G" and Fill.Size.X.Scale or (ColorVal.G)
					local b = colorType == "B" and Fill.Size.X.Scale or (ColorVal.B)
					
					-- Recalculate full color based on all slides (simplified for this compact lib)
					-- Actually, better to just let the slider define the value 0-1
					ColorVal = Color3.new(
						SliderContainer:FindFirstChild("R_Slider").Bar.Fill.Size.X.Scale,
						SliderContainer:FindFirstChild("G_Slider").Bar.Fill.Size.X.Scale,
						SliderContainer:FindFirstChild("B_Slider").Bar.Fill.Size.X.Scale
					)
					Preview.BackgroundColor3 = ColorVal
					pcall(callback, ColorVal)
				end

				SFrame.Name = colorType .. "_Slider"
				Bar.Name = "Bar"
				Fill.Name = "Fill"

				Bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local function UpdateSlide(inp)
							local SizeX = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
							Fill.Size = UDim2.new(SizeX, 0, 1, 0)
							UpdateColor()
						end
						UpdateSlide(input)
						local move = UserInputService.InputChanged:Connect(function(inp)
							if inp.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlide(inp) end
						end)
						local endc = UserInputService.InputEnded:Connect(function(inp)
							if inp.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
						end)
					end
				end)
			end
			
			MakeCSlider(5, "R")
			MakeCSlider(35, "G")
			MakeCSlider(65, "B")

			Preview.MouseButton1Click:Connect(function()
				Open = not Open
				if Open then
					Frame:TweenSize(UDim2.new(0, 450, 0, 130), "Out", "Quad", 0.3)
				else
					Frame:TweenSize(UDim2.new(0, 450, 0, 35), "Out", "Quad", 0.3)
				end
			end)
		end
		
		return Elements
	end
	
	return Window
end


-----------------------------------------------------------
-- EXAMPLE USAGE
-----------------------------------------------------------

local MyWindow = Library:CreateWindow("Main")

local MainTab = MyWindow:Tab("Main")
local VisualsTab = MyWindow:Tab("Visuals")

MainTab:Button("Print Hello", function()
	print("Hello World")
	Library:Notify("Printed Hello to Console", false)
end)

MainTab:Toggle("God Mode", false, function(state)
	print("God mode is:", state)
	if state then
		Library:Notify("God Mode Enabled", false)
	else
		Library:Notify("God Mode Disabled", true) -- Warning color
	end
end)

MainTab:Slider("Speed", 16, 200, 16, function(val)
	LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

MainTab:TextBox("Enter User to Kill", function(text)
	print("Targeting: " .. text)
	Library:Notify("Targeting " .. text, true)
end)

VisualsTab:ColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
	print("New Color:", color)
end)

-- Initial notification
Library:Notify("UI Loaded Successfully", false)
