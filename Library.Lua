local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

function Library:Window(text)
	local CurrentTab = nil
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ClassicLib"
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	--// FEATURE: Persist after death
	ScreenGui.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175) -- Centered based on size
	MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Start size 0 for animation
	MainFrame.ClipsDescendants = true
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor point center for better scaling animation

    --// FEATURE: Intro Animation
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)}):Play()

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = MainFrame
	TitleBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	TitleBar.BorderSizePixel = 0
	TitleBar.Size = UDim2.new(1, 0, 0, 25)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Parent = TitleBar
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.Size = UDim2.new(1, -20, 1, 0)
	TitleLabel.Font = Enum.Font.SourceSansBold
	TitleLabel.Text = text
	TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	MakeDraggable(TitleBar, MainFrame)

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.Active = true
	Sidebar.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0, 0, 0, 25)
	Sidebar.Size = UDim2.new(0, 120, 1, -25)
	Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
	Sidebar.ScrollBarThickness = 2
	Sidebar.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Parent = Sidebar
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = MainFrame
	ContentContainer.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Position = UDim2.new(0, 120, 0, 25)
	ContentContainer.Size = UDim2.new(1, -120, 1, -25)

	local ResizeGrip = Instance.new("TextButton")
	ResizeGrip.Name = "ResizeGrip"
	ResizeGrip.Parent = MainFrame
	ResizeGrip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ResizeGrip.BackgroundTransparency = 1
	ResizeGrip.Position = UDim2.new(1, -15, 1, -15)
	ResizeGrip.Size = UDim2.new(0, 15, 0, 15)
	ResizeGrip.Font = Enum.Font.SourceSans
	ResizeGrip.Text = "◢"
	ResizeGrip.TextColor3 = Color3.fromRGB(150, 150, 150)
	ResizeGrip.TextSize = 14
	ResizeGrip.ZIndex = 10

	local Resizing = false
	ResizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Resizing = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Resizing = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local MouseLocation = UserInputService:GetMouseLocation()
            -- Adjust resize logic for AnchorPoint 0.5, 0.5
			local RelativeX = MouseLocation.X - MainFrame.AbsolutePosition.X
			local RelativeY = MouseLocation.Y - MainFrame.AbsolutePosition.Y - 36 
			
            -- Simple size clamp
            local newX = math.max(300, MouseLocation.X - MainFrame.AbsolutePosition.X)
            local newY = math.max(200, MouseLocation.Y - MainFrame.AbsolutePosition.Y)

			MainFrame.Size = UDim2.new(0, newX, 0, newY)
		end
	end)

    --// FEATURE: Toggle Keybind (Right Control)
    local uiToggled = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            uiToggled = not uiToggled
            if uiToggled then
                MainFrame.Visible = true
                TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)}):Play()
            else
                local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
                closeTween:Play()
                closeTween.Completed:Wait()
                if not uiToggled then MainFrame.Visible = false end
            end
        end
    end)

	local NotificationContainer = Instance.new("Frame")
	NotificationContainer.Name = "Notifications"
	NotificationContainer.Parent = ScreenGui
	NotificationContainer.BackgroundTransparency = 1
	NotificationContainer.Position = UDim2.new(0.85, 0, 0.7, 0)
	NotificationContainer.Size = UDim2.new(0.14, 0, 0.3, 0)
	
	local NotificationLayout = Instance.new("UIListLayout")
	NotificationLayout.Parent = NotificationContainer
	NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotificationLayout.Padding = UDim.new(0, 5)

	local WindowFunctions = {}

	function WindowFunctions:Notification(title, msg, duration)
		local NotifFrame = Instance.new("Frame")
		NotifFrame.Name = "Notif"
		NotifFrame.Parent = NotificationContainer
		NotifFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		NotifFrame.BorderSizePixel = 1
		NotifFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifFrame.Size = UDim2.new(1, 0, 0, 60)
		NotifFrame.BackgroundTransparency = 1
		
		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Parent = NotifFrame
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Position = UDim2.new(0, 5, 0, 5)
		NotifTitle.Size = UDim2.new(1, -10, 0, 20)
		NotifTitle.Font = Enum.Font.SourceSansBold
		NotifTitle.Text = title
		NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifTitle.TextSize = 14
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.TextTransparency = 1
		
		local NotifMsg = Instance.new("TextLabel")
		NotifMsg.Parent = NotifFrame
		NotifMsg.BackgroundTransparency = 1
		NotifMsg.Position = UDim2.new(0, 5, 0, 25)
		NotifMsg.Size = UDim2.new(1, -10, 0, 30)
		NotifMsg.Font = Enum.Font.SourceSans
		NotifMsg.Text = msg
		NotifMsg.TextColor3 = Color3.fromRGB(200, 200, 200)
		NotifMsg.TextSize = 14
		NotifMsg.TextWrapped = true
		NotifMsg.TextXAlignment = Enum.TextXAlignment.Left
		NotifMsg.TextTransparency = 1

		TweenService:Create(NotifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
		TweenService:Create(NotifTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
		TweenService:Create(NotifMsg, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
		
		task.delay(duration or 3, function()
			local t1 = TweenService:Create(NotifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
			local t2 = TweenService:Create(NotifTitle, TweenInfo.new(0.5), {TextTransparency = 1})
			local t3 = TweenService:Create(NotifMsg, TweenInfo.new(0.5), {TextTransparency = 1})
			t1:Play() t2:Play() t3:Play()
			t1.Completed:Wait()
			NotifFrame:Destroy()
		end)
	end

	function WindowFunctions:Tab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Name = name .. "_Btn"
		TabButton.Parent = Sidebar
		TabButton.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = name
		TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabButton.TextSize = 14

		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Name = name .. "_Frame"
		TabFrame.Parent = ContentContainer
		TabFrame.Active = true
		TabFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
		TabFrame.BackgroundTransparency = 1
		TabFrame.BorderSizePixel = 0
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabFrame.ScrollBarThickness = 4
		TabFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
		TabFrame.Visible = false
		
		local TabLayout = Instance.new("UIListLayout")
		TabLayout.Parent = TabFrame
		TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabLayout.Padding = UDim.new(0, 5)

		local TabPadding = Instance.new("UIPadding")
		TabPadding.Parent = TabFrame
		TabPadding.PaddingBottom = UDim.new(0, 5)
		TabPadding.PaddingLeft = UDim.new(0, 5)
		TabPadding.PaddingRight = UDim.new(0, 5)
		TabPadding.PaddingTop = UDim.new(0, 5)
		
		TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
		end)

		if CurrentTab == nil then
			CurrentTab = TabFrame
			TabFrame.Visible = true
			TabButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		TabButton.MouseButton1Click:Connect(function()
			if CurrentTab then
				CurrentTab.Visible = false
				local OldBtn = Sidebar:FindFirstChild(string.split(CurrentTab.Name, "_")[1].."_Btn")
				if OldBtn then
                    TweenService:Create(OldBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(54, 54, 54), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
				end
			end
			CurrentTab = TabFrame
			TabFrame.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(46, 46, 46), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)

		local TabFunctions = {}

		function TabFunctions:Label(text)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Parent = TabFrame
			LabelFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
			LabelFrame.BackgroundTransparency = 1
			LabelFrame.Size = UDim2.new(1, 0, 0, 20)

			local Text = Instance.new("TextLabel")
			Text.Parent = LabelFrame
			Text.BackgroundTransparency = 1
			Text.Size = UDim2.new(1, 0, 1, 0)
			Text.Font = Enum.Font.SourceSans
			Text.Text = text
			Text.TextColor3 = Color3.fromRGB(255, 255, 255)
			Text.TextSize = 14
			Text.TextXAlignment = Enum.TextXAlignment.Left
			return LabelFrame
		end
		
		function TabFunctions:Warning(text)
			local WarningFrame = Instance.new("Frame")
			WarningFrame.Parent = TabFrame
			WarningFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
			WarningFrame.BorderSizePixel = 1
			WarningFrame.BorderColor3 = Color3.fromRGB(150, 50, 50)
			WarningFrame.Size = UDim2.new(1, 0, 0, 30)

			local Text = Instance.new("TextLabel")
			Text.Parent = WarningFrame
			Text.BackgroundTransparency = 1
			Text.Size = UDim2.new(1, 0, 1, 0)
			Text.Font = Enum.Font.SourceSansBold
			Text.Text = "⚠ " .. text
			Text.TextColor3 = Color3.fromRGB(255, 100, 100)
			Text.TextSize = 14
			Text.TextWrapped = true
		end

		function TabFunctions:Button(text, callback)
			callback = callback or function() end
			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Parent = TabFrame
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
			ButtonFrame.BackgroundTransparency = 1
			ButtonFrame.Size = UDim2.new(1, 0, 0, 26)

			local Button = Instance.new("TextButton")
			Button.Parent = ButtonFrame
			Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Button.BorderSizePixel = 0
			Button.Position = UDim2.new(0, 0, 0, 2)
			Button.Size = UDim2.new(1, 0, 0, 22)
			Button.Font = Enum.Font.SourceSans
			Button.Text = text
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14
			
			Button.MouseButton1Click:Connect(function()
				local t1 = TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
				t1:Play()
				t1.Completed:Wait()
				TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				pcall(callback)
			end)
		end

		function TabFunctions:Toggle(text, default, callback)
			callback = callback or function() end
			local toggled = default or false
			
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Parent = TabFrame
			ToggleFrame.BackgroundTransparency = 1
			ToggleFrame.Size = UDim2.new(1, 0, 0, 26)

			local Button = Instance.new("TextButton")
			Button.Parent = ToggleFrame
			Button.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
			Button.BackgroundTransparency = 1
			Button.Size = UDim2.new(1, 0, 1, 0)
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextSize = 14

			local Indicator = Instance.new("Frame")
			Indicator.Parent = Button
			Indicator.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
			Indicator.BorderSizePixel = 0
			Indicator.Position = UDim2.new(0, 0, 0.5, -8)
			Indicator.Size = UDim2.new(0, 16, 0, 16)

			local Label = Instance.new("TextLabel")
			Label.Parent = Button
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 24, 0, 0)
			Label.Size = UDim2.new(1, -24, 1, 0)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseButton1Click:Connect(function()
				toggled = not toggled
				local targetColor = toggled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
				TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
				pcall(callback, toggled)
			end)
		end

		function TabFunctions:Slider(text, min, max, default, callback)
			callback = callback or function() end
			local value = default or min
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = TabFrame
			SliderFrame.BackgroundTransparency = 1
			SliderFrame.Size = UDim2.new(1, 0, 0, 36)

			local Label = Instance.new("TextLabel")
			Label.Parent = SliderFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 0, 16)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Parent = SliderFrame
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Size = UDim2.new(1, 0, 0, 16)
			ValueLabel.Font = Enum.Font.SourceSans
			ValueLabel.Text = tostring(value)
			ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			ValueLabel.TextSize = 14
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

			local SlideBG = Instance.new("Frame")
			SlideBG.Parent = SliderFrame
			SlideBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			SlideBG.BorderSizePixel = 0
			SlideBG.Position = UDim2.new(0, 0, 0, 20)
			SlideBG.Size = UDim2.new(1, 0, 0, 10)

			local SlideFill = Instance.new("Frame")
			SlideFill.Parent = SlideBG
			SlideFill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			SlideFill.BorderSizePixel = 0
			SlideFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

			local Trigger = Instance.new("TextButton")
			Trigger.Parent = SlideBG
			Trigger.BackgroundTransparency = 1
			Trigger.Size = UDim2.new(1, 0, 1, 0)
			Trigger.Text = ""

			local dragging = false
			
			local function update(input)
				local pos = UDim2.new(math.clamp((input.Position.X - SlideBG.AbsolutePosition.X) / SlideBG.AbsoluteSize.X, 0, 1), 0, 1, 0)
				SlideFill.Size = pos
				local result = math.floor(min + ((max - min) * pos.X.Scale))
				ValueLabel.Text = tostring(result)
				pcall(callback, result)
			end

			Trigger.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					update(input)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input)
				end
			end)
		end

		function TabFunctions:Textbox(text, placeholder, callback)
			callback = callback or function() end
			local BoxFrame = Instance.new("Frame")
			BoxFrame.Parent = TabFrame
			BoxFrame.BackgroundTransparency = 1
			BoxFrame.Size = UDim2.new(1, 0, 0, 36)

			local Label = Instance.new("TextLabel")
			Label.Parent = BoxFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 0, 16)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Input = Instance.new("TextBox")
			Input.Parent = BoxFrame
			Input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Input.BorderSizePixel = 0
			Input.Position = UDim2.new(0, 0, 0, 18)
			Input.Size = UDim2.new(1, 0, 0, 18)
			Input.Font = Enum.Font.SourceSans
			Input.PlaceholderText = placeholder or ""
			Input.Text = ""
			Input.TextColor3 = Color3.fromRGB(255, 255, 255)
			Input.TextSize = 14

			Input.FocusLost:Connect(function(enter)
				pcall(callback, Input.Text)
			end)
		end

		function TabFunctions:Dropdown(text, list, callback)
			callback = callback or function() end
			local DropFrame = Instance.new("Frame")
			DropFrame.Parent = TabFrame
			DropFrame.BackgroundTransparency = 1
			DropFrame.Size = UDim2.new(1, 0, 0, 44)
			
			local Label = Instance.new("TextLabel")
			Label.Parent = DropFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 0, 16)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local OpenBtn = Instance.new("TextButton")
			OpenBtn.Parent = DropFrame
			OpenBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			OpenBtn.BorderSizePixel = 0
			OpenBtn.Position = UDim2.new(0, 0, 0, 18)
			OpenBtn.Size = UDim2.new(1, 0, 0, 22)
			OpenBtn.Font = Enum.Font.SourceSans
			OpenBtn.Text = "Select..."
			OpenBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			OpenBtn.TextSize = 14
			
			local isOpen = false
			local ListFrame = Instance.new("Frame")
			ListFrame.Parent = DropFrame
			ListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ListFrame.BorderSizePixel = 0
			ListFrame.Position = UDim2.new(0, 0, 0, 42)
			ListFrame.Size = UDim2.new(1, 0, 0, 0)
			ListFrame.Visible = false
			ListFrame.ClipsDescendants = true
			
			local ListLayout = Instance.new("UIListLayout")
			ListLayout.Parent = ListFrame
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			
			for _, item in pairs(list) do
				local ItemBtn = Instance.new("TextButton")
				ItemBtn.Parent = ListFrame
				ItemBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
				ItemBtn.BorderSizePixel = 0
				ItemBtn.Size = UDim2.new(1, 0, 0, 22)
				ItemBtn.Font = Enum.Font.SourceSans
				ItemBtn.Text = item
				ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
				ItemBtn.TextSize = 14
				
				ItemBtn.MouseButton1Click:Connect(function()
					OpenBtn.Text = item
					pcall(callback, item)
					isOpen = false
					ListFrame.Visible = false
					DropFrame.Size = UDim2.new(1, 0, 0, 44)
				end)
			end
			
			OpenBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				ListFrame.Visible = isOpen
				if isOpen then
					local count = #list
					local height = count * 22
					ListFrame.Size = UDim2.new(1, 0, 0, height)
					DropFrame.Size = UDim2.new(1, 0, 0, 44 + height)
				else
					DropFrame.Size = UDim2.new(1, 0, 0, 44)
				end
			end)
		end

		function TabFunctions:Keybind(text, default, callback)
			callback = callback or function() end
			local BindFrame = Instance.new("Frame")
			BindFrame.Parent = TabFrame
			BindFrame.BackgroundTransparency = 1
			BindFrame.Size = UDim2.new(1, 0, 0, 26)
			
			local Label = Instance.new("TextLabel")
			Label.Parent = BindFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(0.6, 0, 1, 0)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local BindBtn = Instance.new("TextButton")
			BindBtn.Parent = BindFrame
			BindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			BindBtn.BorderSizePixel = 0
			BindBtn.Position = UDim2.new(0.7, 0, 0, 2)
			BindBtn.Size = UDim2.new(0.3, 0, 0, 22)
			BindBtn.Font = Enum.Font.SourceSans
			BindBtn.Text = default and default.Name or "None"
			BindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			BindBtn.TextSize = 14
			
			local listening = false
			
			BindBtn.MouseButton1Click:Connect(function()
				listening = true
				BindBtn.Text = "..."
				BindBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
			end)
			
			UserInputService.InputBegan:Connect(function(input)
				if listening then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						BindBtn.Text = input.KeyCode.Name
						BindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
						pcall(callback, input.KeyCode)
					end
				end
			end)
		end
		
		function TabFunctions:Colorpicker(text, default, callback)
			callback = callback or function() end
			local ColorFrame = Instance.new("Frame")
			ColorFrame.Parent = TabFrame
			ColorFrame.BackgroundTransparency = 1
			ColorFrame.Size = UDim2.new(1, 0, 0, 80)
			
			local Label = Instance.new("TextLabel")
			Label.Parent = ColorFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 0, 16)
			Label.Font = Enum.Font.SourceSans
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local Preview = Instance.new("Frame")
			Preview.Parent = ColorFrame
			Preview.BackgroundColor3 = default or Color3.new(1,1,1)
			Preview.BorderSizePixel = 0
			Preview.Position = UDim2.new(1, -40, 0, 0)
			Preview.Size = UDim2.new(0, 40, 0, 16)
			
			local function makeSlider(yPos, colorType)
				local slider = Instance.new("Frame")
				slider.Parent = ColorFrame
				slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				slider.BorderSizePixel = 0
				slider.Position = UDim2.new(0, 0, 0, yPos)
				slider.Size = UDim2.new(1, 0, 0, 10)
				
				local fill = Instance.new("Frame")
				fill.Parent = slider
				fill.BackgroundColor3 = colorType == "R" and Color3.fromRGB(255,50,50) or (colorType == "G" and Color3.fromRGB(50,255,50) or Color3.fromRGB(50,50,255))
				fill.BorderSizePixel = 0
				fill.Size = UDim2.new(1, 0, 1, 0)
				
				local trigger = Instance.new("TextButton")
				trigger.Parent = slider
				trigger.BackgroundTransparency = 1
				trigger.Size = UDim2.new(1, 0, 1, 0)
				trigger.Text = ""
				return trigger, fill
			end
			
			local rTrig, rFill = makeSlider(20, "R")
			local gTrig, gFill = makeSlider(35, "G")
			local bTrig, bFill = makeSlider(50, "B")
			
			local rgb = {R = 1, G = 1, B = 1}
			if default then rgb = {R = default.R, G = default.G, B = default.B} end
			
			local function updateColor()
				local c = Color3.new(rgb.R, rgb.G, rgb.B)
				Preview.BackgroundColor3 = c
				pcall(callback, c)
			end
			
			local function setSlider(input, type, fill)
				local pos = math.clamp((input.Position.X - fill.Parent.AbsolutePosition.X) / fill.Parent.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(pos, 0, 1, 0)
				rgb[type] = pos
				updateColor()
			end
			
			rTrig.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then setSlider(input, "R", rFill) end end)
			gTrig.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then setSlider(input, "G", gFill) end end)
			bTrig.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then setSlider(input, "B", bFill) end end)
		end

		return TabFunctions
	end

	return WindowFunctions
end

return Library
