local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// UI Creator
function Library:Window(options)
	options = options or {}
	local title = options.Name or "Classic Lib"
	local keySystem = options.KeySystem or false
	local key = options.Key or ""
	local keyNote = options.KeyNote or "Join discord for key"

	--// 1. Create ScreenGui (Persist after death)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ZyphClassicLib"
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	--// 2. Utils
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
			if input == DragInput and Dragging then Update(input) end
		end)
	end

	--// 3. Main Window Construction (Hidden Initially)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
	MainFrame.Size = UDim2.new(0, 550, 0, 350) -- Default Size
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false -- Hidden until Key System passed
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

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

	MakeDraggable(TitleBar, MainFrame)

	--// Minimize Logic
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
	local storedSize = UDim2.new(0, 550, 0, 350)
	
	MinBtn.MouseButton1Click:Connect(function()
		if isMinimized then
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = storedSize}):Play()
			MinBtn.Text = "-"
			MainFrame.ClipsDescendants = true
		else
			storedSize = MainFrame.Size
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, storedSize.X.Offset, 0, 30)}):Play()
			MinBtn.Text = "+"
		end
		isMinimized = not isMinimized
	end)

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

	--// Content Container
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Parent = MainFrame
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0, 140, 0, 30)
	ContentContainer.Size = UDim2.new(1, -140, 1, -30)
	ContentContainer.ClipsDescendants = true

	--// Resize Grip
	local ResizeGrip = Instance.new("Frame")
	ResizeGrip.Parent = MainFrame
	ResizeGrip.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	ResizeGrip.BorderSizePixel = 0
	ResizeGrip.Position = UDim2.new(1, -10, 1, -10)
	ResizeGrip.Size = UDim2.new(0, 10, 0, 10)
	local GripCorn = Instance.new("UICorner")
	GripCorn.CornerRadius = UDim.new(0, 2)
	GripCorn.Parent = ResizeGrip

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

	--// Notifications
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

	--// Logic Variables
	local WindowFunctions = {}
	local CurrentTab = nil

	--// Function: Open the Window (Animations)
	local function OpenWindow()
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
	end

	--// Function: Handle Search
	local function UpdateSearch(text, tabFrame)
		if not tabFrame then return end
		text = text:lower()
		for _, v in pairs(tabFrame:GetChildren()) do
			if v:IsA("Frame") then
				local tag = v:FindFirstChild("SearchTag")
				if tag then
					if string.find(tag.Value:lower(), text) then
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end
		end
	end
	
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if CurrentTab then UpdateSearch(SearchBox.Text, CurrentTab) end
	end)

	--// Window Functions
	function WindowFunctions:Notification(title, msg, duration)
		duration = duration or 5
		local Notif = Instance.new("Frame")
		Notif.Parent = NotifContainer
		Notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Notif.BorderSizePixel = 0
		Notif.Size = UDim2.new(1, 0, 0, 0)
		Notif.ClipsDescendants = true
		
		local Stroke = Instance.new("UIStroke")
		Stroke.Parent = Notif
		Stroke.Color = Color3.fromRGB(60, 60, 60)
		Stroke.Thickness = 1
		
		local Txt = Instance.new("TextLabel")
		Txt.Parent = Notif
		Txt.BackgroundTransparency = 1
		Txt.Position = UDim2.new(0, 10, 0, 5)
		Txt.Size = UDim2.new(1, -20, 0, 20)
		Txt.Font = Enum.Font.SourceSansBold
		Txt.Text = title
		Txt.TextColor3 = Color3.white
		Txt.TextSize = 14
		Txt.TextXAlignment = Enum.TextXAlignment.Left
		
		local Desc = Instance.new("TextLabel")
		Desc.Parent = Notif
		Desc.BackgroundTransparency = 1
		Desc.Position = UDim2.new(0, 10, 0, 25)
		Desc.Size = UDim2.new(1, -20, 0, 30)
		Desc.Font = Enum.Font.SourceSans
		Desc.Text = msg
		Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
		Desc.TextSize = 14
		Desc.TextWrapped = true
		Desc.TextXAlignment = Enum.TextXAlignment.Left
		
		local Bar = Instance.new("Frame")
		Bar.Parent = Notif
		Bar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
		Bar.BorderSizePixel = 0
		Bar.Position = UDim2.new(0, 0, 1, -2)
		Bar.Size = UDim2.new(1, 0, 0, 2)
		
		TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 65)}):Play()
		TweenService:Create(Bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
		
		task.delay(duration, function()
			local t = TweenService:Create(Notif, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 0)})
			t:Play()
			t.Completed:Wait()
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
		
		local Layout = Instance.new("UIListLayout")
		Layout.Parent = TabFrame
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Padding = UDim.new(0, 5)
		
		local Pad = Instance.new("UIPadding")
		Pad.Parent = TabFrame
		Pad.PaddingTop = UDim.new(0, 10)
		Pad.PaddingLeft = UDim.new(0, 10)
		Pad.PaddingRight = UDim.new(0, 10)
		Pad.PaddingBottom = UDim.new(0, 10)
		
		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
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
			UpdateSearch(SearchBox.Text, TabFrame)
		end)
		
		if CurrentTab == nil then
			CurrentTab = TabFrame
			TabFrame.Visible = true
			TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		local Elements = {}
		
		local function AddTag(obj, txt)
			local t = Instance.new("StringValue")
			t.Name = "SearchTag"
			t.Value = txt
			t.Parent = obj
		end

		function Elements:Label(text)
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, 0, 0, 20)
			AddTag(Frame, text)
			
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
			AddTag(Frame, text)
			
			local Btn = Instance.new("TextButton")
			Btn.Parent = Frame
			Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Btn.BorderSizePixel = 0
			Btn.Size = UDim2.new(1, 0, 0, 28)
			Btn.Font = Enum.Font.SourceSans
			Btn.Text = text
			Btn.TextColor3 = Color3.white
			Btn.TextSize = 14
			
			local corn = Instance.new("UICorner")
			corn.CornerRadius = UDim.new(0, 4)
			corn.Parent = Btn
			
			Btn.MouseButton1Click:Connect(function()
				local t = TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
				t:Play() t.Completed:Wait()
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
			AddTag(Frame, text)
			
			local Btn = Instance.new("TextButton")
			Btn.Parent = Frame
			Btn.BackgroundTransparency = 1
			Btn.Size = UDim2.new(1, 0, 1, 0)
			Btn.Text = ""
			
			local Box = Instance.new("Frame")
			Box.Parent = Btn
			Box.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(0, 0, 0.5, -9)
			Box.Size = UDim2.new(0, 18, 0, 18)
			local corn = Instance.new("UICorner")
			corn.CornerRadius = UDim.new(0, 4)
			corn.Parent = Box
			
			local Lbl = Instance.new("TextLabel")
			Lbl.Parent = Btn
			Lbl.BackgroundTransparency = 1
			Lbl.Position = UDim2.new(0, 26, 0, 0)
			Lbl.Size = UDim2.new(1, -26, 1, 0)
			Lbl.Font = Enum.Font.SourceSans
			Lbl.Text = text
			Lbl.TextColor3 = Color3.white
			Lbl.TextSize = 14
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			
			local state = default
			Btn.MouseButton1Click:Connect(function()
				state = not state
				local c = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
				TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = c}):Play()
				pcall(callback, state)
			end)
		end
		
		function Elements:Slider(text, min, max, default, callback)
			callback = callback or function() end
			default = default or min
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, 0, 0, 45)
			AddTag(Frame, text)
			
			local Lbl = Instance.new("TextLabel")
			Lbl.Parent = Frame
			Lbl.BackgroundTransparency = 1
			Lbl.Size = UDim2.new(1, 0, 0, 20)
			Lbl.Font = Enum.Font.SourceSans
			Lbl.Text = text
			Lbl.TextColor3 = Color3.white
			Lbl.TextSize = 14
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			
			local Val = Instance.new("TextLabel")
			Val.Parent = Frame
			Val.BackgroundTransparency = 1
			Val.Size = UDim2.new(1, 0, 0, 20)
			Val.Font = Enum.Font.SourceSans
			Val.Text = tostring(default)
			Val.TextColor3 = Color3.fromRGB(180, 180, 180)
			Val.TextSize = 14
			Val.TextXAlignment = Enum.TextXAlignment.Right
			
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
			Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
			
			local Trig = Instance.new("TextButton")
			Trig.Parent = Bar
			Trig.BackgroundTransparency = 1
			Trig.Size = UDim2.new(1, 0, 1, 0)
			Trig.Text = ""
			
			local drag = false
			local function Upd(input)
				local p = math.clamp((input.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
				Fill.Size = UDim2.new(p, 0, 1, 0)
				local r = math.floor(min + ((max-min)*p))
				Val.Text = tostring(r)
				pcall(callback, r)
			end
			Trig.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true Upd(i) end end)
			UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
			UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then Upd(i) end end)
		end
		
		function Elements:Colorpicker(text, default, callback)
			callback = callback or function() end
			default = default or Color3.new(1,1,1)
			local Frame = Instance.new("Frame")
			Frame.Parent = TabFrame
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, 0, 0, 32)
			Frame.ZIndex = 5
			AddTag(Frame, text)
			
			local Lbl = Instance.new("TextLabel")
			Lbl.Parent = Frame
			Lbl.BackgroundTransparency = 1
			Lbl.Size = UDim2.new(0.7, 0, 1, 0)
			Lbl.Font = Enum.Font.SourceSans
			Lbl.Text = text
			Lbl.TextColor3 = Color3.white
			Lbl.TextSize = 14
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			
			local Prev = Instance.new("TextButton")
			Prev.Parent = Frame
			Prev.BackgroundColor3 = default
			Prev.BorderSizePixel = 0
			Prev.Position = UDim2.new(1, -40, 0.5, -9)
			Prev.Size = UDim2.new(0, 40, 0, 18)
			Prev.Text = ""
			local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = Prev
			
			local Popup = Instance.new("Frame")
			Popup.Parent = ScreenGui -- Move to ScreenGui to ensure Top ZIndex
			Popup.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Popup.BorderSizePixel = 0
			Popup.Size = UDim2.new(0, 160, 0, 140)
			Popup.Visible = false
			Popup.ZIndex = 100
			
			local Stroke = Instance.new("UIStroke") Stroke.Parent = Popup Stroke.Color = Color3.fromRGB(20, 20, 20) Stroke.Thickness = 2
			
			local function UpdatePopupPos()
				-- Position popup next to the preview button
				local absPos = Prev.AbsolutePosition
				Popup.Position = UDim2.new(0, absPos.X + 50, 0, absPos.Y)
			end
			
			local function CreateSlider(y, grad, func)
				local Bg = Instance.new("Frame")
				Bg.Parent = Popup
				Bg.BackgroundColor3 = Color3.white
				Bg.BorderSizePixel = 0
				Bg.Position = UDim2.new(0, 10, 0, y)
				Bg.Size = UDim2.new(0, 140, 0, 10)
				local G = Instance.new("UIGradient") G.Color = grad G.Parent = Bg
				local Ind = Instance.new("Frame") Ind.Parent = Bg Ind.BackgroundColor3 = Color3.white Ind.BorderColor3 = Color3.black Ind.Size = UDim2.new(0, 2, 1, 4) Ind.Position = UDim2.new(0,0,0,-2)
				local Trig = Instance.new("TextButton") Trig.Parent = Bg Trig.BackgroundTransparency = 1 Trig.Size = UDim2.new(1,0,1,0) Trig.Text=""
				local d = false
				Trig.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true func(i, Ind, Bg) end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
				UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then func(i, Ind, Bg) end end)
				return Ind
			end
			
			local h, s, v = default:ToHSV()
			local function Update()
				local newC = Color3.fromHSV(h, s, v)
				Prev.BackgroundColor3 = newC
				pcall(callback, newC)
			end
			
			local hI = CreateSlider(10, ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2,1,1)),
				ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4,1,1)), ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6,1,1)),
				ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
			}, function(i, ind, bg)
				local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
				ind.Position = UDim2.new(p, -1, 0, -2)
				h = p
				Update()
			end)
			
			local sI = CreateSlider(30, ColorSequence.new(Color3.white, Color3.new(1,0,0)), function(i, ind, bg)
				local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
				ind.Position = UDim2.new(p, -1, 0, -2)
				s = p
				Update()
			end)
			
			local vI = CreateSlider(50, ColorSequence.new(Color3.black, Color3.white), function(i, ind, bg)
				local p = math.clamp((i.Position.X - bg.AbsolutePosition.X)/bg.AbsoluteSize.X, 0, 1)
				ind.Position = UDim2.new(p, -1, 0, -2)
				v = p
				Update()
			end)
			
			-- Close
			local Close = Instance.new("TextButton")
			Close.Parent = Popup
			Close.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Close.BorderSizePixel = 0
			Close.Position = UDim2.new(0, 10, 0, 105)
			Close.Size = UDim2.new(0, 140, 0, 25)
			Close.Text = "Confirm"
			Close.TextColor3 = Color3.white
			Close.MouseButton1Click:Connect(function() Popup.Visible = false end)
			
			Prev.MouseButton1Click:Connect(function()
				UpdatePopupPos()
				Popup.Visible = not Popup.Visible
			end)
		end

		return Elements
	end
	
	--// 4. Handle Key System OR Open Immediately
	if keySystem then
		local KeyFrame = Instance.new("Frame")
		KeyFrame.Name = "KeySystemFrame"
		KeyFrame.Parent = ScreenGui
		KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		KeyFrame.BorderSizePixel = 0
		KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
		KeyFrame.Size = UDim2.new(0, 300, 0, 150)
		KeyFrame.Visible = true -- Force visible
		KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		
		local KStroke = Instance.new("UIStroke") KStroke.Parent = KeyFrame KStroke.Color = Color3.fromRGB(20, 20, 20) KStroke.Thickness = 2
		
		-- Drag KeyFrame
		MakeDraggable(KeyFrame, KeyFrame)

		local KTitle = Instance.new("TextLabel")
		KTitle.Parent = KeyFrame
		KTitle.BackgroundTransparency = 1
		KTitle.Position = UDim2.new(0, 0, 0, 10)
		KTitle.Size = UDim2.new(1, 0, 0, 20)
		KTitle.Font = Enum.Font.SourceSansBold
		KTitle.Text = "Key System"
		KTitle.TextColor3 = Color3.white
		KTitle.TextSize = 18
		
		local KNote = Instance.new("TextLabel")
		KNote.Parent = KeyFrame
		KNote.BackgroundTransparency = 1
		KNote.Position = UDim2.new(0, 10, 0, 35)
		KNote.Size = UDim2.new(1, -20, 0, 20)
		KNote.Font = Enum.Font.SourceSans
		KNote.Text = keyNote
		KNote.TextColor3 = Color3.fromRGB(150, 150, 150)
		KNote.TextSize = 14
		
		local KClose = Instance.new("TextButton")
		KClose.Parent = KeyFrame
		KClose.BackgroundTransparency = 1
		KClose.Position = UDim2.new(1, -30, 0, 5)
		KClose.Size = UDim2.new(0, 25, 0, 25)
		KClose.Text = "X"
		KClose.TextColor3 = Color3.fromRGB(200, 200, 200)
		KClose.TextSize = 18
		KClose.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
		
		local KBox = Instance.new("TextBox")
		KBox.Parent = KeyFrame
		KBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		KBox.BorderSizePixel = 0
		KBox.Position = UDim2.new(0.1, 0, 0.5, -10)
		KBox.Size = UDim2.new(0.8, 0, 0, 30)
		KBox.Font = Enum.Font.SourceSans
		KBox.PlaceholderText = "Enter Key..."
		KBox.Text = ""
		KBox.TextColor3 = Color3.white
		KBox.TextSize = 14
		
		local KSubmit = Instance.new("TextButton")
		KSubmit.Parent = KeyFrame
		KSubmit.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		KSubmit.BorderSizePixel = 0
		KSubmit.Position = UDim2.new(0.3, 0, 0.8, -10)
		KSubmit.Size = UDim2.new(0.4, 0, 0, 25)
		KSubmit.Font = Enum.Font.SourceSans
		KSubmit.Text = "Submit"
		KSubmit.TextColor3 = Color3.white
		KSubmit.TextSize = 14
		
		KSubmit.MouseButton1Click:Connect(function()
			if KBox.Text == key then
				KeyFrame:Destroy()
				OpenWindow()
			else
				KBox.Text = "Incorrect"
				task.wait(1)
				KBox.Text = ""
			end
		end)
	else
		OpenWindow()
	end
	
	--// Toggle Keybind (Right Ctrl)
	UserInputService.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == Enum.KeyCode.RightControl then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)

	return WindowFunctions
end

return Library
