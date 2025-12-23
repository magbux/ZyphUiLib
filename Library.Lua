local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Utils
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

function Library:Window(options)
	options = options or {}
	local title = options.Name or "Classic Lib"
	local keySystem = options.KeySystem or false
	local key = options.Key or ""
	local keyNote = options.KeyNote or "Join the discord for the key!"

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ZyphClassicLib"
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false --// Persist after death

	local function InitWindow()
		--// Main Frame
		local MainFrame = Instance.new("Frame")
		MainFrame.Name = "MainFrame"
		MainFrame.Parent = ScreenGui
		MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		MainFrame.BorderSizePixel = 0
		MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
		MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Start small for anim
		MainFrame.ClipsDescendants = true
		MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

		--// Intro Animation
		TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()

		--// Shadow
		local Shadow = Instance.new("ImageLabel")
		Shadow.Name = "Shadow"
		Shadow.Parent = MainFrame
		Shadow.BackgroundTransparency = 1
		Shadow.Position = UDim2.new(0, -15, 0, -15)
		Shadow.Size = UDim2.new(1, 30, 1, 30)
		Shadow.ZIndex = 0
		Shadow.Image = "rbxassetid://5554236805"
		Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		Shadow.ScaleType = Enum.ScaleType.Slice
		Shadow.SliceCenter = Rect.new(23, 23, 277, 277)

		--// Title Bar
		local TitleBar = Instance.new("Frame")
		TitleBar.Name = "TitleBar"
		TitleBar.Parent = MainFrame
		TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		TitleBar.BorderSizePixel = 0
		TitleBar.Size = UDim2.new(1, 0, 0, 30)

		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Parent = TitleBar
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Position = UDim2.new(0, 10, 0, 0)
		TitleLabel.Size = UDim2.new(1, -100, 1, 0)
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.Text = title
		TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
		TitleLabel.TextSize = 16
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

		--// Control Buttons (Minimize)
		local MinBtn = Instance.new("TextButton")
		MinBtn.Parent = TitleBar
		MinBtn.BackgroundTransparency = 1
		MinBtn.Position = UDim2.new(1, -30, 0, 0)
		MinBtn.Size = UDim2.new(0, 30, 1, 0)
		MinBtn.Font = Enum.Font.SourceSansBold
		MinBtn.Text = "-"
		MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		MinBtn.TextSize = 20

		local isMinimized = false
		local oldSize = UDim2.new(0, 550, 0, 350)
		
		MinBtn.MouseButton1Click:Connect(function()
			if isMinimized then
				TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = oldSize}):Play()
				MinBtn.Text = "-"
			else
				oldSize = MainFrame.Size
				TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, oldSize.X.Offset, 0, 30)}):Play()
				MinBtn.Text = "+"
			end
			isMinimized = not isMinimized
		end)

		MakeDraggable(TitleBar, MainFrame)

		--// Sidebar
		local Sidebar = Instance.new("Frame")
		Sidebar.Parent = MainFrame
		Sidebar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Sidebar.BorderSizePixel = 0
		Sidebar.Position = UDim2.new(0, 0, 0, 30)
		Sidebar.Size = UDim2.new(0, 140, 1, -30)

		--// Search Bar
		local SearchFrame = Instance.new("Frame")
		SearchFrame.Parent = Sidebar
		SearchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		SearchFrame.BorderSizePixel = 0
		SearchFrame.Position = UDim2.new(0, 5, 0, 5)
		SearchFrame.Size = UDim2.new(1, -10, 0, 25)

		local SearchBox = Instance.new("TextBox")
		SearchBox.Parent = SearchFrame
		SearchBox.BackgroundTransparency = 1
		SearchBox.Size = UDim2.new(1, 0, 1, 0)
		SearchBox.Font = Enum.Font.SourceSans
		SearchBox.PlaceholderText = "Search..."
		SearchBox.Text = ""
		SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		SearchBox.TextSize = 14

		local TabContainer = Instance.new("ScrollingFrame")
		TabContainer.Parent = Sidebar
		TabContainer.BackgroundTransparency = 1
		TabContainer.Position = UDim2.new(0, 0, 0, 35)
		TabContainer.Size = UDim2.new(1, 0, 1, -35)
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContainer.ScrollBarThickness = 2
		TabContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

		local TabLayout = Instance.new("UIListLayout")
		TabLayout.Parent = TabContainer
		TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

		--// Content Area
		local ContentContainer = Instance.new("Frame")
		ContentContainer.Parent = MainFrame
		ContentContainer.BackgroundTransparency = 1
		ContentContainer.Position = UDim2.new(0, 140, 0, 30)
		ContentContainer.Size = UDim2.new(1, -140, 1, -30)
		ContentContainer.ClipsDescendants = true

		--// Resize Grip (The "Clip")
		local ResizeGrip = Instance.new("Frame")
		ResizeGrip.Parent = MainFrame
		ResizeGrip.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		ResizeGrip.BorderSizePixel = 0
		ResizeGrip.Position = UDim2.new(1, -10, 1, -10)
		ResizeGrip.Size = UDim2.new(0, 10, 0, 10)
		
		local GripPoly = Instance.new("UICorner") -- Making it slightly rounded looks cleaner
		GripPoly.CornerRadius = UDim.new(0, 2)
		GripPoly.Parent = ResizeGrip

		local Resizing = false
		ResizeGrip.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then Resizing = true end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then Resizing = false end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local MouseLoc = UserInputService:GetMouseLocation()
				local newX = math.max(400, MouseLoc.X - MainFrame.AbsolutePosition.X)
				local newY = math.max(250, MouseLoc.Y - MainFrame.AbsolutePosition.Y)
				MainFrame.Size = UDim2.new(0, newX, 0, newY)
			end
		end)

		--// Notification System
		local NotifContainer = Instance.new("Frame")
		NotifContainer.Parent = ScreenGui
		NotifContainer.Position = UDim2.new(1, -220, 1, -20)
		NotifContainer.Size = UDim2.new(0, 200, 1, 0)
		NotifContainer.AnchorPoint = Vector2.new(0, 1)
		NotifContainer.BackgroundTransparency = 1

		local NotifLayout = Instance.new("UIListLayout")
		NotifLayout.Parent = NotifContainer
		NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
		NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		NotifLayout.Padding = UDim.new(0, 10)

		local WindowFunctions = {}
		local Tabs = {}
		local CurrentTab = nil

		function WindowFunctions:Notification(title, msg, duration)
			duration = duration or 5
			local Notif = Instance.new("Frame")
			Notif.Parent = NotifContainer
			Notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Notif.BorderSizePixel = 0
			Notif.Size = UDim2.new(1, 0, 0, 0) -- Start Height 0
			Notif.ClipsDescendants = true
			
			local NotifStroke = Instance.new("UIStroke")
			NotifStroke.Parent = Notif
			NotifStroke.Color = Color3.fromRGB(60, 60, 60)
			NotifStroke.Thickness = 1
			
			local Title = Instance.new("TextLabel")
			Title.Parent = Notif
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 10, 0, 5)
			Title.Size = UDim2.new(1, -20, 0, 20)
			Title.Font = Enum.Font.SourceSansBold
			Title.Text = title
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 14
			Title.TextXAlignment = Enum.TextXAlignment.Left

			local Message = Instance.new("TextLabel")
			Message.Parent = Notif
			Message.BackgroundTransparency = 1
			Message.Position = UDim2.new(0, 10, 0, 25)
			Message.Size = UDim2.new(1, -20, 0, 30)
			Message.Font = Enum.Font.SourceSans
			Message.Text = msg
			Message.TextColor3 = Color3.fromRGB(200, 200, 200)
			Message.TextSize = 14
			Message.TextWrapped = true
			Message.TextXAlignment = Enum.TextXAlignment.Left
			
			local ProgressBar = Instance.new("Frame")
			ProgressBar.Parent = Notif
			ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
			ProgressBar.BorderSizePixel = 0
			ProgressBar.Position = UDim2.new(0, 0, 1, -2)
			ProgressBar.Size = UDim2.new(1, 0, 0, 2)
			
			-- Open Anim
			TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 65)}):Play()
			
			-- Progress Anim
			TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

			task.delay(duration, function()
				local close = TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 0)})
				close:Play()
				close.Completed:Wait()
				Notif:Destroy()
			end)
		end

		function WindowFunctions:Tab(name)
			local TabFrame = Instance.new("ScrollingFrame")
			TabFrame.Name = name
			TabFrame.Parent = ContentContainer
			TabFrame.BackgroundTransparency = 1
			TabFrame.Size = UDim2.new(1, 0, 1, 0)
			TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			TabFrame.ScrollBarThickness = 4
			TabFrame.Visible = false
			
			local ContentLayout = Instance.new("UIListLayout")
			ContentLayout.Parent = TabFrame
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 5)
			
			local Padding = Instance.new("UIPadding")
			Padding.Parent = TabFrame
			Padding.PaddingBottom = UDim.new(0, 10)
			Padding.PaddingLeft = UDim.new(0, 10)
			Padding.PaddingRight = UDim.new(0, 10)
			Padding.PaddingTop = UDim.new(0, 10)

			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
			end)

			local TabBtn = Instance.new("TextButton")
			TabBtn.Parent = TabContainer
			TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			TabBtn.BorderSizePixel = 0
			TabBtn.Size = UDim2.new(1, 0, 0, 32)
			TabBtn.Font = Enum.Font.SourceSans
			TabBtn.Text = name
			TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			TabBtn.TextSize = 14
			
			local function UpdateSearch(text)
				if CurrentTab ~= TabFrame then return end
				text = text:lower()
				for _, v in pairs(TabFrame:GetChildren()) do
					if v:IsA("Frame") then
						local searchable = v:FindFirstChild("SearchTag")
						if searchable then
							if string.find(searchable.Value:lower(), text) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end
			end
			
			SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
				UpdateSearch(SearchBox.Text)
			end)

			TabBtn.MouseButton1Click:Connect(function()
				for _, v in pairs(ContentContainer:GetChildren()) do v.Visible = false end
				for _, v in pairs(TabContainer:GetChildren()) do
					if v:IsA("TextButton") then
						TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
					end
				end
				
				CurrentTab = TabFrame
				TabFrame.Visible = true
				TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				UpdateSearch(SearchBox.Text)
			end)
			
			-- Select first tab by default
			if CurrentTab == nil then
				CurrentTab = TabFrame
				TabFrame.Visible = true
				TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			end

			local Elements = {}

			local function AddSearchTag(frame, keyword)
				local tag = Instance.new("StringValue")
				tag.Name = "SearchTag"
				tag.Value = keyword
				tag.Parent = frame
			end

			function Elements:Label(text)
				local Frame = Instance.new("Frame")
				Frame.Parent = TabFrame
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.new(1, 0, 0, 20)
				AddSearchTag(Frame, text)

				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame
				Lbl.BackgroundTransparency = 1
				Lbl.Size = UDim2.new(1, 0, 1, 0)
				Lbl.Font = Enum.Font.SourceSans
				Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
				Lbl.TextSize = 14
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				return Frame
			end

			function Elements:Button(text, callback)
				callback = callback or function() end
				local Frame = Instance.new("Frame")
				Frame.Parent = TabFrame
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.new(1, 0, 0, 32)
				AddSearchTag(Frame, text)

				local Btn = Instance.new("TextButton")
				Btn.Parent = Frame
				Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				Btn.BorderSizePixel = 0
				Btn.Size = UDim2.new(1, 0, 0, 28)
				Btn.Font = Enum.Font.SourceSans
				Btn.Text = text
				Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				Btn.TextSize = 14
				
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Btn
				
				Btn.MouseButton1Click:Connect(function()
					local t = TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
					t:Play()
					t.Completed:Wait()
					TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					pcall(callback)
				end)
			end
			
			function Elements:Toggle(text, default, callback)
				callback = callback or function() end
				local Frame = Instance.new("Frame")
				Frame.Parent = TabFrame
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.new(1, 0, 0, 32)
				AddSearchTag(Frame, text)

				local Btn = Instance.new("TextButton")
				Btn.Parent = Frame
				Btn.BackgroundTransparency = 1
				Btn.Size = UDim2.new(1, 0, 1, 0)
				Btn.Text = ""

				local Checkbox = Instance.new("Frame")
				Checkbox.Parent = Btn
				Checkbox.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
				Checkbox.BorderSizePixel = 0
				Checkbox.Position = UDim2.new(0, 0, 0.5, -9)
				Checkbox.Size = UDim2.new(0, 18, 0, 18)
				
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Checkbox

				local Title = Instance.new("TextLabel")
				Title.Parent = Btn
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 26, 0, 0)
				Title.Size = UDim2.new(1, -26, 1, 0)
				Title.Font = Enum.Font.SourceSans
				Title.Text = text
				Title.TextColor3 = Color3.fromRGB(240, 240, 240)
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left

				local state = default
				Btn.MouseButton1Click:Connect(function()
					state = not state
					local targetC = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
					TweenService:Create(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = targetC}):Play()
					pcall(callback, state)
				end)
			end

			function Elements:Colorpicker(text, default, callback)
				callback = callback or function() end
				local defaultColor = default or Color3.new(1,1,1)
				
				local Frame = Instance.new("Frame")
				Frame.Parent = TabFrame
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.new(1, 0, 0, 32)
				Frame.ZIndex = 5
				AddSearchTag(Frame, text)
				
				local Title = Instance.new("TextLabel")
				Title.Parent = Frame
				Title.BackgroundTransparency = 1
				Title.Size = UDim2.new(0.7, 0, 1, 0)
				Title.Font = Enum.Font.SourceSans
				Title.Text = text
				Title.TextColor3 = Color3.fromRGB(240, 240, 240)
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left
				
				local Preview = Instance.new("TextButton")
				Preview.Parent = Frame
				Preview.BackgroundColor3 = defaultColor
				Preview.BorderSizePixel = 0
				Preview.Position = UDim2.new(1, -40, 0.5, -9)
				Preview.Size = UDim2.new(0, 40, 0, 18)
				Preview.Text = ""
				
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Preview
				
				--// Popup
				local Popup = Instance.new("Frame")
				Popup.Parent = Frame
				Popup.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				Popup.BorderSizePixel = 0
				Popup.Position = UDim2.new(1, 5, 0, 0)
				Popup.Size = UDim2.new(0, 150, 0, 130)
				Popup.Visible = false
				Popup.ZIndex = 10
				
				local PopStroke = Instance.new("UIStroke")
				PopStroke.Parent = Popup
				PopStroke.Color = Color3.fromRGB(20, 20, 20)
				PopStroke.Thickness = 2
				
				local function CreateSlider(name, y, gradient, updateFunc)
					local SliderBg = Instance.new("Frame")
					SliderBg.Parent = Popup
					SliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					SliderBg.BorderSizePixel = 0
					SliderBg.Position = UDim2.new(0, 10, 0, y)
					SliderBg.Size = UDim2.new(0, 130, 0, 10)
					SliderBg.ZIndex = 11
					
					local Grad = Instance.new("UIGradient")
					Grad.Color = gradient
					Grad.Parent = SliderBg
					
					local Indicator = Instance.new("Frame")
					Indicator.Parent = SliderBg
					Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Indicator.BorderColor3 = Color3.new(0,0,0)
					Indicator.Size = UDim2.new(0, 2, 1, 4)
					Indicator.Position = UDim2.new(0,0,0,-2)
					Indicator.ZIndex = 12
					
					local Trigger = Instance.new("TextButton")
					Trigger.Parent = SliderBg
					Trigger.BackgroundTransparency = 1
					Trigger.Size = UDim2.new(1,0,1,0)
					Trigger.Text = ""
					Trigger.ZIndex = 13
					
					local dragging = false
					Trigger.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateFunc(inp) end end)
					UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
					UserInputService.InputChanged:Connect(function(inp) if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then updateFunc(inp) end end)
					
					return Indicator, SliderBg
				end
				
				local h, s, v = defaultColor:ToHSV()
				local color = defaultColor
				
				-- Visual Updaters
				local function UpdateFinal()
					color = Color3.fromHSV(h, s, v)
					Preview.BackgroundColor3 = color
					pcall(callback, color)
				end
				
				-- Hue Slider
				local hInd, hBg = CreateSlider("Hue", 10, ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
					ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2,1,1)),
					ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4,1,1)),
					ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6,1,1)),
					ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8,1,1)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
				}, function(input)
					local pos = math.clamp((input.Position.X - hBg.AbsolutePosition.X) / hBg.AbsoluteSize.X, 0, 1)
					hInd.Position = UDim2.new(pos, -1, 0, -2)
					h = pos
					UpdateFinal()
				end)
				
				-- Saturation Slider
				local sInd, sBg = CreateSlider("Sat", 30, ColorSequence.new(Color3.new(1,1,1), Color3.new(1,0,0)), function(input)
					local pos = math.clamp((input.Position.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
					sInd.Position = UDim2.new(pos, -1, 0, -2)
					s = pos
					UpdateFinal()
				end)

				-- Value Slider
				local vInd, vBg = CreateSlider("Val", 50, ColorSequence.new(Color3.new(0,0,0), Color3.new(1,1,1)), function(input)
					local pos = math.clamp((input.Position.X - vBg.AbsolutePosition.X) / vBg.AbsoluteSize.X, 0, 1)
					vInd.Position = UDim2.new(pos, -1, 0, -2)
					v = pos
					UpdateFinal()
				end)
				
				-- Set Initial Positions
				hInd.Position = UDim2.new(h, -1, 0, -2)
				sInd.Position = UDim2.new(s, -1, 0, -2)
				vInd.Position = UDim2.new(v, -1, 0, -2)
				
				-- RGB Readout (Simple)
				local RGBBox = Instance.new("TextLabel")
				RGBBox.Parent = Popup
				RGBBox.BackgroundTransparency = 1
				RGBBox.Position = UDim2.new(0, 10, 0, 70)
				RGBBox.Size = UDim2.new(0, 130, 0, 20)
				RGBBox.Font = Enum.Font.SourceSans
				RGBBox.Text = "R, G, B Slider"
				RGBBox.TextColor3 = Color3.fromRGB(150, 150, 150)
				RGBBox.TextSize = 12
				
				local ClosePick = Instance.new("TextButton")
				ClosePick.Parent = Popup
				ClosePick.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				ClosePick.BorderSizePixel = 0
				ClosePick.Position = UDim2.new(0, 10, 0, 95)
				ClosePick.Size = UDim2.new(0, 130, 0, 25)
				ClosePick.Text = "Confirm"
				ClosePick.TextColor3 = Color3.white
				
				ClosePick.MouseButton1Click:Connect(function()
					Popup.Visible = false
				end)

				Preview.MouseButton1Click:Connect(function()
					-- Toggle Popup
					for _, other in pairs(TabFrame:GetDescendants()) do
						if other.Name == "Popup" and other ~= Popup then other.Visible = false end
					end
					Popup.Visible = not Popup.Visible
				end)
			end
			
			function Elements:Slider(text, min, max, default, callback)
				callback = callback or function() end
				default = default or min
				
				local Frame = Instance.new("Frame")
				Frame.Parent = TabFrame
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.new(1, 0, 0, 45)
				AddSearchTag(Frame, text)
				
				local Title = Instance.new("TextLabel")
				Title.Parent = Frame
				Title.BackgroundTransparency = 1
				Title.Size = UDim2.new(1, 0, 0, 20)
				Title.Font = Enum.Font.SourceSans
				Title.Text = text
				Title.TextColor3 = Color3.fromRGB(240, 240, 240)
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left
				
				local ValText = Instance.new("TextLabel")
				ValText.Parent = Frame
				ValText.BackgroundTransparency = 1
				ValText.Size = UDim2.new(1, 0, 0, 20)
				ValText.Font = Enum.Font.SourceSans
				ValText.Text = tostring(default)
				ValText.TextColor3 = Color3.fromRGB(180, 180, 180)
				ValText.TextSize = 14
				ValText.TextXAlignment = Enum.TextXAlignment.Right
				
				local Bar = Instance.new("Frame")
				Bar.Parent = Frame
				Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Bar.BorderSizePixel = 0
				Bar.Position = UDim2.new(0, 0, 0, 25)
				Bar.Size = UDim2.new(1, 0, 0, 8)
				
				local Fill = Instance.new("Frame")
				Fill.Parent = Bar
				Fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
				Fill.BorderSizePixel = 0
				Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
				
				local Trigger = Instance.new("TextButton")
				Trigger.Parent = Bar
				Trigger.BackgroundTransparency = 1
				Trigger.Size = UDim2.new(1, 0, 1, 0)
				Trigger.Text = ""
				
				local dragging = false
				local function Update(input)
					local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					local res = math.floor(min + ((max-min)*pos))
					ValText.Text = tostring(res)
					pcall(callback, res)
				end
				
				Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(i) end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
				UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
			end
			
			function Elements:Dropdown(text, list, callback)
				callback = callback or function() end
				local Frame = Instance.new("Frame")
				Frame.Parent = TabFrame
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.new(1, 0, 0, 50)
				Frame.ClipsDescendants = true
				Frame.ZIndex = 2
				AddSearchTag(Frame, text)
				
				local Title = Instance.new("TextLabel")
				Title.Parent = Frame
				Title.BackgroundTransparency = 1
				Title.Size = UDim2.new(1, 0, 0, 20)
				Title.Font = Enum.Font.SourceSans
				Title.Text = text
				Title.TextColor3 = Color3.fromRGB(240, 240, 240)
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left
				
				local MainBtn = Instance.new("TextButton")
				MainBtn.Parent = Frame
				MainBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				MainBtn.BorderSizePixel = 0
				MainBtn.Position = UDim2.new(0, 0, 0, 22)
				MainBtn.Size = UDim2.new(1, 0, 0, 24)
				MainBtn.Font = Enum.Font.SourceSans
				MainBtn.Text = "Select..."
				MainBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
				MainBtn.TextSize = 14
				
				local Arrow = Instance.new("TextLabel")
				Arrow.Parent = MainBtn
				Arrow.BackgroundTransparency = 1
				Arrow.Position = UDim2.new(1, -20, 0, 0)
				Arrow.Size = UDim2.new(0, 20, 1, 0)
				Arrow.Text = "v"
				Arrow.TextColor3 = Color3.white
				
				local List = Instance.new("Frame")
				List.Parent = Frame
				List.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				List.Position = UDim2.new(0, 0, 0, 48)
				List.Size = UDim2.new(1, 0, 0, #list * 24)
				
				local ListLayout = Instance.new("UIListLayout")
				ListLayout.Parent = List
				
				local isOpen = false
				
				for _, item in pairs(list) do
					local ItemBtn = Instance.new("TextButton")
					ItemBtn.Parent = List
					ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					ItemBtn.BorderSizePixel = 0
					ItemBtn.Size = UDim2.new(1, 0, 0, 24)
					ItemBtn.Font = Enum.Font.SourceSans
					ItemBtn.Text = item
					ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
					ItemBtn.TextSize = 14
					
					ItemBtn.MouseButton1Click:Connect(function()
						MainBtn.Text = item
						pcall(callback, item)
						isOpen = false
						Frame:TweenSize(UDim2.new(1, 0, 0, 50), "Out", "Quad", 0.3)
						Arrow.Rotation = 0
					end)
				end
				
				MainBtn.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					if isOpen then
						Frame:TweenSize(UDim2.new(1, 0, 0, 50 + (#list * 24)), "Out", "Quad", 0.3)
						Arrow.Rotation = 180
					else
						Frame:TweenSize(UDim2.new(1, 0, 0, 50), "Out", "Quad", 0.3)
						Arrow.Rotation = 0
					end
				end)
			end

			return Elements
		end

		--// Keybind Toggle
		UserInputService.InputBegan:Connect(function(inp, gp)
			if not gp and inp.KeyCode == Enum.KeyCode.RightControl then
				ScreenGui.Enabled = not ScreenGui.Enabled
			end
		end)
		
		return WindowFunctions
	end

	--// Key System Logic
	if keySystem then
		local KeyGui = Instance.new("ScreenGui")
		KeyGui.Name = "ZyphKeySystem"
		KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		KeyGui.ResetOnSpawn = false

		local Frame = Instance.new("Frame")
		Frame.Parent = KeyGui
		Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
		Frame.Size = UDim2.new(0, 0, 0, 0) -- Anim start
		Frame.ClipsDescendants = true
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		
		local Stroke = Instance.new("UIStroke")
		Stroke.Parent = Frame
		Stroke.Color = Color3.fromRGB(20, 20, 20)
		Stroke.Thickness = 2
		
		TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 150)}):Play()

		local Title = Instance.new("TextLabel")
		Title.Parent = Frame
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 0, 0, 10)
		Title.Size = UDim2.new(1, 0, 0, 20)
		Title.Font = Enum.Font.SourceSansBold
		Title.Text = "Key System"
		Title.TextColor3 = Color3.white
		Title.TextSize = 18

		local Note = Instance.new("TextLabel")
		Note.Parent = Frame
		Note.BackgroundTransparency = 1
		Note.Position = UDim2.new(0, 10, 0, 35)
		Note.Size = UDim2.new(1, -20, 0, 20)
		Note.Font = Enum.Font.SourceSans
		Note.Text = keyNote
		Note.TextColor3 = Color3.fromRGB(150, 150, 150)
		Note.TextSize = 14
		
		local Close = Instance.new("TextButton")
		Close.Parent = Frame
		Close.BackgroundTransparency = 1
		Close.Position = UDim2.new(1, -25, 0, 5)
		Close.Size = UDim2.new(0, 20, 0, 20)
		Close.Text = "X"
		Close.TextColor3 = Color3.fromRGB(200, 200, 200)
		Close.TextSize = 16
		Close.MouseButton1Click:Connect(function() KeyGui:Destroy() end)

		local Box = Instance.new("TextBox")
		Box.Parent = Frame
		Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Box.BorderSizePixel = 0
		Box.Position = UDim2.new(0.1, 0, 0.5, -10)
		Box.Size = UDim2.new(0.8, 0, 0, 30)
		Box.Font = Enum.Font.SourceSans
		Box.PlaceholderText = "Enter Key..."
		Box.Text = ""
		Box.TextColor3 = Color3.white
		Box.TextSize = 14

		local Submit = Instance.new("TextButton")
		Submit.Parent = Frame
		Submit.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Submit.BorderSizePixel = 0
		Submit.Position = UDim2.new(0.3, 0, 0.8, -10)
		Submit.Size = UDim2.new(0.4, 0, 0, 25)
		Submit.Font = Enum.Font.SourceSans
		Submit.Text = "Submit"
		Submit.TextColor3 = Color3.white
		Submit.TextSize = 14
		
		local function Check()
			if Box.Text == key then
				TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
				task.wait(0.3)
				KeyGui:Destroy()
				return InitWindow()
			else
				Box.Text = "Incorrect Key"
				task.wait(1)
				Box.Text = ""
			end
		end
		
		Submit.MouseButton1Click:Connect(Check)
	else
		return InitWindow()
	end
end

return Library
