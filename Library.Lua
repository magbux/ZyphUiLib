local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Helper: Make UI Draggable //
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
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

-- // Main Function: Create Window //
function Library:CreateWindow(Config)
	-- 1. Create ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ZyphLibrary"
	ScreenGui.ResetOnSpawn = false

	-- Security check for executors
	if syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = game:GetService("CoreGui")
	elseif getgenv and getgenv().gethui then
		ScreenGui.Parent = getgenv().gethui()
	else
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	-- 2. Create Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -420, 0.5, -256)
	MainFrame.Size = UDim2.new(0, 840, 0, 512)
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame

	MakeDraggable(MainFrame, MainFrame)

	-- 3. Profile Picture
	local UserImage = Instance.new("ImageLabel")
	UserImage.Name = "UserImage"
	UserImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserImage.BackgroundTransparency = 1
	UserImage.Position = UDim2.new(0.02, 0, 0.02, 0)
	UserImage.Size = UDim2.new(0, 42, 0, 42)
	UserImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	UserImage.Parent = MainFrame

	local UserImageCorner = Instance.new("UICorner")
	UserImageCorner.CornerRadius = UDim.new(1, 0) -- Circle
	UserImageCorner.Parent = UserImage

	-- Fetch Avatar Thumbnail
	task.spawn(function()
		local content, isReady = pcall(function()
			return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end)
		if isReady then
			UserImage.Image = content
		end
	end)

	-- 4. Welcome Label
	local WelcomeLabel = Instance.new("TextLabel")
	WelcomeLabel.Name = "WelcomeLabel"
	WelcomeLabel.BackgroundTransparency = 1
	WelcomeLabel.Position = UDim2.new(0.08, 0, 0.02, 0)
	WelcomeLabel.Size = UDim2.new(0, 200, 0, 42)
	WelcomeLabel.Font = Enum.Font.SourceSans
	WelcomeLabel.Text = "Welcome, " .. LocalPlayer.Name
	WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	WelcomeLabel.TextSize = 18
	WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
	WelcomeLabel.Parent = MainFrame

	-- 5. Close Button (X)
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	CloseButton.Position = UDim2.new(0.93, 0, 0.02, 0)
	CloseButton.Size = UDim2.new(0, 42, 0, 42)
	CloseButton.Font = Enum.Font.SourceSansBold
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 18
	CloseButton.Parent = MainFrame

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseButton

	CloseButton.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	-- 6. Minimize Button (-)
	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	MinimizeButton.Position = UDim2.new(0.87, 0, 0.02, 0)
	MinimizeButton.Size = UDim2.new(0, 42, 0, 42)
	MinimizeButton.Font = Enum.Font.SourceSansBold
	MinimizeButton.Text = "-"
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.TextSize = 24
	MinimizeButton.Parent = MainFrame

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 8)
	MinCorner.Parent = MinimizeButton

	local Minimized = false
	local ContentFrameRef = nil

	MinimizeButton.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		if ContentFrameRef then
			ContentFrameRef.Visible = not Minimized
			if Minimized then
				TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 840, 0, 60)}):Play()
			else
				TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 840, 0, 512)}):Play()
			end
		end
	end)

	-- 7. Search Bar
	local SearchBar = Instance.new("TextBox")
	SearchBar.Name = "SearchBar"
	SearchBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBar.Position = UDim2.new(0.5, -100, 0.02, 0)
	SearchBar.Size = UDim2.new(0, 200, 0, 42)
	SearchBar.Font = Enum.Font.SourceSans
	SearchBar.PlaceholderText = "Search..."
	SearchBar.Text = ""
	SearchBar.TextColor3 = Color3.fromRGB(0, 0, 0)
	SearchBar.TextSize = 14
	SearchBar.Parent = MainFrame

	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 8)
	SearchCorner.Parent = SearchBar

	-- 8. Content Area
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "ContentFrame"
	ContentFrame.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
	ContentFrame.Position = UDim2.new(0.02, 0, 0.12, 0)
	ContentFrame.Size = UDim2.new(0.96, 0, 0.85, 0)
	ContentFrame.Parent = MainFrame
	ContentFrameRef = ContentFrame

	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 8)
	ContentCorner.Parent = ContentFrame

	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0.02, 0, 0.02, 0)
	TabContainer.Size = UDim2.new(0.96, 0, 0.96, 0)
	TabContainer.ScrollBarThickness = 4
	TabContainer.Parent = ContentFrame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = TabContainer
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 6)

	-- Search Functionality
	SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
		local Input = SearchBar.Text:lower()
		for _, item in pairs(TabContainer:GetDescendants()) do
			if item:IsA("Frame") and item:FindFirstChild("Title") then
				if Input == "" then
					item.Visible = true
				else
					if string.find(item.Title.Text:lower(), Input) then
						item.Visible = true
					else
						item.Visible = false
					end
				end
			end
		end
	end)

	-- 9. Tab System
	local Window = {}

	function Window:AddTab(TabName)
		local Tab = {}

		function Tab:AddLabel(Text)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Name = Text .. "Label"
			LabelFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			LabelFrame.Size = UDim2.new(1, 0, 0, 30)
			LabelFrame.Parent = TabContainer

			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, 6)
			LabelCorner.Parent = LabelFrame

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.Position = UDim2.new(0, 10, 0, 0)
			Title.Font = Enum.Font.SourceSans
			Title.Text = Text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = LabelFrame
		end

		function Tab:AddWarning(Text)
			local WarningFrame = Instance.new("Frame")
			WarningFrame.Name = Text .. "Warning"
			WarningFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			WarningFrame.Size = UDim2.new(1, 0, 0, 30)
			WarningFrame.Parent = TabContainer

			local WarningCorner = Instance.new("UICorner")
			WarningCorner.CornerRadius = UDim.new(0, 6)
			WarningCorner.Parent = WarningFrame

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.Position = UDim2.new(0, 10, 0, 0)
			Title.Font = Enum.Font.SourceSansBold
			Title.Text = "⚠️ " .. Text
			Title.TextColor3 = Color3.fromRGB(255, 200, 0)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = WarningFrame
		end

		function Tab:AddButton(Text, Callback)
			Callback = Callback or function() end

			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Name = Text .. "Button"
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
			ButtonFrame.Parent = TabContainer

			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 6)
			ButtonCorner.Parent = ButtonFrame

			local Btn = Instance.new("TextButton")
			Btn.Name = "Title"
			Btn.BackgroundTransparency = 1
			Btn.Size = UDim2.new(1, 0, 1, 0)
			Btn.Font = Enum.Font.SourceSans
			Btn.Text = Text
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.TextSize = 16
			Btn.Parent = ButtonFrame

			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
				Callback()
				wait(0.1)
				TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(48, 48, 48)}):Play()
			end)
		end

		function Tab:AddToggle(Text, Default, Callback)
			Callback = Callback or function() end
			local Toggled = Default or false

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = Text .. "Toggle"
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
			ToggleFrame.Parent = TabContainer

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = ToggleFrame

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(0.7, 0, 1, 0)
			Title.Position = UDim2.new(0, 10, 0, 0)
			Title.Font = Enum.Font.SourceSans
			Title.Text = Text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = ToggleFrame

			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Text = ""
			ToggleBtn.BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
			ToggleBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
			ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
			ToggleBtn.Parent = ToggleFrame

			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(1, 0)
			BtnCorner.Parent = ToggleBtn

			ToggleBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)}):Play()
				Callback(Toggled)
			end)
		end

		function Tab:AddSlider(Text, Min, Max, Default, Callback)
			Callback = Callback or function() end
			local Value = Default or Min

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = Text .. "Slider"
			SliderFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			SliderFrame.Size = UDim2.new(1, 0, 0, 50)
			SliderFrame.Parent = TabContainer

			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = SliderFrame

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(1, 0, 0, 20)
			Title.Position = UDim2.new(0, 10, 0, 5)
			Title.Font = Enum.Font.SourceSans
			Title.Text = Text .. ": " .. Value
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = SliderFrame

			local SliderBar = Instance.new("Frame")
			SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			SliderBar.Size = UDim2.new(0.9, 0, 0, 10)
			SliderBar.Position = UDim2.new(0.05, 0, 0.6, 0)
			SliderBar.Parent = SliderFrame

			local BarCorner = Instance.new("UICorner")
			BarCorner.CornerRadius = UDim.new(1, 0)
			BarCorner.Parent = SliderBar

			local Fill = Instance.new("Frame")
			Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
			Fill.Parent = SliderBar

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill

			local Trigger = Instance.new("TextButton")
			Trigger.BackgroundTransparency = 1
			Trigger.Text = ""
			Trigger.Size = UDim2.new(1, 0, 1, 0)
			Trigger.Parent = SliderBar

			local IsDragging = false

			Trigger.MouseButton1Down:Connect(function()
				IsDragging = true
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					IsDragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					local NewValue = math.floor(Min + ((Max - Min) * SizeScale))
					TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()
					Title.Text = Text .. ": " .. NewValue
					Callback(NewValue)
				end
			end)
		end

		function Tab:AddDropdown(Text, Options, Callback)
			Callback = Callback or function() end
			local DropdownOpen = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = Text .. "Dropdown"
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = TabContainer

			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 6)
			DropdownCorner.Parent = DropdownFrame

			local DropBtn = Instance.new("TextButton")
			DropBtn.Name = "Title"
			DropBtn.BackgroundTransparency = 1
			DropBtn.Size = UDim2.new(1, 0, 0, 35)
			DropBtn.Font = Enum.Font.SourceSans
			DropBtn.Text = Text .. " v"
			DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropBtn.TextSize = 16
			DropBtn.Parent = DropdownFrame

			local Container = Instance.new("Frame")
			Container.BackgroundTransparency = 1
			Container.Position = UDim2.new(0, 0, 0, 35)
			Container.Size = UDim2.new(1, 0, 0, #Options * 30)
			Container.Parent = DropdownFrame

			local UIList = Instance.new("UIListLayout")
			UIList.Parent = Container
			UIList.SortOrder = Enum.SortOrder.LayoutOrder

			for _, option in pairs(Options) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
				OptBtn.Size = UDim2.new(1, 0, 0, 30)
				OptBtn.Text = option
				OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
				OptBtn.Font = Enum.Font.SourceSans
				OptBtn.TextSize = 14
				OptBtn.BorderSizePixel = 0
				OptBtn.Parent = Container

				OptBtn.MouseButton1Click:Connect(function()
					DropBtn.Text = Text .. ": " .. option
					Callback(option)
					DropdownOpen = false
					TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
				end)
			end

			DropBtn.MouseButton1Click:Connect(function()
				DropdownOpen = not DropdownOpen
				if DropdownOpen then
					TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35 + (#Options * 30))}):Play()
				else
					TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
				end
			end)
		end

		function Tab:AddTextBox(Text, Callback)
			Callback = Callback or function() end

			local BoxFrame = Instance.new("Frame")
			BoxFrame.Name = Text .. "TextBox"
			BoxFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			BoxFrame.Size = UDim2.new(1, 0, 0, 35)
			BoxFrame.Parent = TabContainer

			local BoxCorner = Instance.new("UICorner")
			BoxCorner.CornerRadius = UDim.new(0, 6)
			BoxCorner.Parent = BoxFrame

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(0.3, 0, 1, 0)
			Title.Position = UDim2.new(0, 10, 0, 0)
			Title.Font = Enum.Font.SourceSans
			Title.Text = Text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = BoxFrame

			local Input = Instance.new("TextBox")
			Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Input.Position = UDim2.new(0.4, 0, 0.15, 0)
			Input.Size = UDim2.new(0.55, 0, 0.7, 0)
			Input.Font = Enum.Font.SourceSans
			Input.Text = ""
			Input.PlaceholderText = "Type here..."
			Input.TextColor3 = Color3.fromRGB(255, 255, 255)
			Input.TextSize = 14
			Input.Parent = BoxFrame

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 4)
			InputCorner.Parent = Input

			Input.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					Callback(Input.Text)
				end
			end)
		end

		return Tab
	end

	return Window
end

return Library
