local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- // Utility: Mobile/PC Draggable
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

local function Tween(obj, props, time)
	local info = TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(obj, info, props):Play()
end

function Library:CreateWindow(name)
	local UI = {}
	
	-- // Main GUI
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ZyphMobileLib"
	-- Check for Synapse/Fluxus/etc, else PlayerGui
	if gethui then
		ScreenGui.Parent = gethui()
	elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
		ScreenGui.Parent = game:GetService("CoreGui")
	else
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- // 1. Clean Opener (No Icons, just a sleek toggle)
	local Opener = Instance.new("TextButton")
	Opener.Name = "Opener"
	Opener.Parent = ScreenGui
	Opener.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Opener.Position = UDim2.new(0.9, -55, 0.4, 0) -- Top right-ish
	Opener.Size = UDim2.new(0, 50, 0, 50) -- Smaller for mobile
	Opener.BorderSizePixel = 0
	Opener.Text = ""
	Opener.AutoButtonColor = false
	
	local OpenerCorner = Instance.new("UICorner")
	OpenerCorner.CornerRadius = UDim.new(0, 12)
	OpenerCorner.Parent = Opener
	
	-- Simple visual indicator inside opener
	local OpenerDot = Instance.new("Frame")
	OpenerDot.Parent = Opener
	OpenerDot.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
	OpenerDot.Size = UDim2.new(0, 14, 0, 14)
	OpenerDot.AnchorPoint = Vector2.new(0.5, 0.5)
	OpenerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
	
	local DotCorner = Instance.new("UICorner")
	DotCorner.CornerRadius = UDim.new(1, 0)
	DotCorner.Parent = OpenerDot
	
	MakeDraggable(Opener, Opener)

	-- // 2. Main Frame (Smaller Dimensions)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140) -- Centered
	MainFrame.Size = UDim2.new(0, 480, 0, 280) -- Compact Size (Mobile Friendly)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame
	
	local MainStroke = Instance.new("UIStroke")
	MainStroke.Parent = MainFrame
	MainStroke.Color = Color3.fromRGB(60, 60, 60)
	MainStroke.Thickness = 1

	-- Toggle Logic
	local isOpen = false
	Opener.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		MainFrame.Visible = isOpen
		
		if isOpen then
			OpenerDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100) -- Green when open
			MainFrame.Size = UDim2.new(0, 480, 0, 0)
			Tween(MainFrame, {Size = UDim2.new(0, 480, 0, 280)}, 0.3)
		else
			OpenerDot.BackgroundColor3 = Color3.fromRGB(100, 100, 255) -- Blue when closed
		end
	end)

	MakeDraggable(MainFrame, MainFrame)

	-- // 3. Sidebar (Smaller)
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	Sidebar.Size = UDim2.new(0, 110, 1, 0) -- Narrower sidebar
	Sidebar.BorderSizePixel = 0
	
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 10)
	SidebarCorner.Parent = Sidebar

	local SidebarFix = Instance.new("Frame")
	SidebarFix.Parent = Sidebar
	SidebarFix.BorderSizePixel = 0
	SidebarFix.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	SidebarFix.Size = UDim2.new(0, 10, 1, 0)
	SidebarFix.Position = UDim2.new(1, -10, 0, 0)
	SidebarFix.ZIndex = 2
	
	local Title = Instance.new("TextLabel")
	Title.Parent = Sidebar
	Title.Text = name
	Title.Size = UDim2.new(1, 0, 0, 35)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14 -- Smaller Text
	
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Parent = Sidebar
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 5, 0, 40)
	TabContainer.Size = UDim2.new(1, -10, 1, -45)
	TabContainer.ScrollBarThickness = 0
	
	local TabList = Instance.new("UIListLayout")
	TabList.Parent = TabContainer
	TabList.Padding = UDim.new(0, 4)
	TabList.SortOrder = Enum.SortOrder.LayoutOrder

	local PagesFolder = Instance.new("Folder")
	PagesFolder.Name = "Pages"
	PagesFolder.Parent = MainFrame

	-- // TAB SYSTEM
	function UI:Tab(text)
		local TabFunctions = {}
		
		local TabBtn = Instance.new("TextButton")
		TabBtn.Parent = TabContainer
		TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		TabBtn.Size = UDim2.new(1, 0, 0, 30) -- Smaller Height
		TabBtn.Font = Enum.Font.GothamMedium
		TabBtn.Text = text
		TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		TabBtn.TextSize = 12
		TabBtn.AutoButtonColor = false
		
		local TabBtnCorner = Instance.new("UICorner")
		TabBtnCorner.CornerRadius = UDim.new(0, 6)
		TabBtnCorner.Parent = TabBtn
		
		local Page = Instance.new("ScrollingFrame")
		Page.Name = text .. "_Page"
		Page.Parent = PagesFolder
		Page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		Page.BackgroundTransparency = 1
		Page.Position = UDim2.new(0, 118, 0, 10)
		Page.Size = UDim2.new(0, 352, 1, -20) -- Adjusted for new size
		Page.ScrollBarThickness = 2
		Page.Visible = false
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.Padding = UDim.new(0, 6)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _, child in pairs(TabContainer:GetChildren()) do
				if child:IsA("TextButton") then
					Tween(child, {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Color3.fromRGB(180, 180, 180)})
				end
			end
			for _, child in pairs(PagesFolder:GetChildren()) do
				child.Visible = false
			end
			
			Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(100, 100, 255), TextColor3 = Color3.fromRGB(255, 255, 255)})
			Page.Visible = true
		end)
		
		if #TabContainer:GetChildren() == 2 then
			TabBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
			TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Page.Visible = true
		end

		-- // ELEMENTS

		-- 1. Compact Button
		function TabFunctions:Button(btnText, callback)
			local Btn = Instance.new("TextButton")
			Btn.Parent = Page
			Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Btn.Size = UDim2.new(1, -5, 0, 32) -- Smaller
			Btn.Font = Enum.Font.GothamSemibold
			Btn.Text = btnText
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.TextSize = 13
			Btn.AutoButtonColor = false
			
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 6)
			BtnCorner.Parent = Btn
			
			Btn.MouseButton1Click:Connect(function()
				Tween(Btn, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}, 0.1)
				task.wait(0.1)
				Tween(Btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1)
				pcall(callback)
			end)
		end

		-- 2. Compact Toggle
		function TabFunctions:Toggle(toggleText, default, callback)
			local toggled = default or false
			
			local ToggleFrame = Instance.new("TextButton")
			ToggleFrame.Parent = Page
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ToggleFrame.Size = UDim2.new(1, -5, 0, 32)
			ToggleFrame.Text = ""
			ToggleFrame.AutoButtonColor = false
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = ToggleFrame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = ToggleFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.Size = UDim2.new(0.7, 0, 1, 0)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = toggleText
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local Indicator = Instance.new("Frame")
			Indicator.Parent = ToggleFrame
			Indicator.BackgroundColor3 = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(30, 30, 30)
			Indicator.Position = UDim2.new(1, -40, 0.5, -9)
			Indicator.Size = UDim2.new(0, 34, 0, 18)
			
			local IndCorner = Instance.new("UICorner")
			IndCorner.CornerRadius = UDim.new(1, 0)
			IndCorner.Parent = Indicator
			
			local Dot = Instance.new("Frame")
			Dot.Parent = Indicator
			Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Dot.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
			Dot.Size = UDim2.new(0, 14, 0, 14)
			
			local DotCorner = Instance.new("UICorner")
			DotCorner.CornerRadius = UDim.new(1, 0)
			DotCorner.Parent = Dot
			
			ToggleFrame.MouseButton1Click:Connect(function()
				toggled = not toggled
				
				local targetPos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				local targetColor = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(30, 30, 30)
				
				Tween(Dot, {Position = targetPos})
				Tween(Indicator, {BackgroundColor3 = targetColor})
				
				pcall(callback, toggled)
			end)
		end

		-- 3. Compact Slider
		function TabFunctions:Slider(sliderText, min, max, default, callback)
			local value = default or min
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Page
			SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SliderFrame.Size = UDim2.new(1, -5, 0, 42) -- Slightly taller for touch
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = SliderFrame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = SliderFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 10, 0, 4)
			Label.Size = UDim2.new(1, -20, 0, 16)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = sliderText .. ": " .. tostring(value)
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local SliderBg = Instance.new("TextButton")
			SliderBg.Parent = SliderFrame
			SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			SliderBg.Position = UDim2.new(0, 10, 0, 24)
			SliderBg.Size = UDim2.new(1, -20, 0, 8)
			SliderBg.Text = ""
			SliderBg.AutoButtonColor = false
			
			local BgCorner = Instance.new("UICorner")
			BgCorner.CornerRadius = UDim.new(1, 0)
			BgCorner.Parent = SliderBg
			
			local SliderFill = Instance.new("Frame")
			SliderFill.Parent = SliderBg
			SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
			SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			SliderFill.BorderSizePixel = 0
			
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = SliderFill
			
			local dragging = false
			
			local function UpdateSlider(input)
				local pos = UDim2.new(math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
				SliderFill.Size = pos
				
				local newVal = math.floor(min + ((max - min) * pos.X.Scale))
				Label.Text = sliderText .. ": " .. tostring(newVal)
				pcall(callback, newVal)
			end
			
			SliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					UpdateSlider(input)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					UpdateSlider(input)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
		end

		-- 4. COLOR WHEEL PICKER (HSV)
		function TabFunctions:ColorPicker(text, defaultColor, callback)
			local pickedColor = defaultColor or Color3.fromRGB(255, 255, 255)
			local h, s, v = Color3.toHSV(pickedColor)
			local isOpen = false
			
			local PickerFrame = Instance.new("Frame")
			PickerFrame.Parent = Page
			PickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			PickerFrame.Size = UDim2.new(1, -5, 0, 32) -- Collapsed size
			PickerFrame.ClipsDescendants = true
			
			local PickerCorner = Instance.new("UICorner")
			PickerCorner.CornerRadius = UDim.new(0, 6)
			PickerCorner.Parent = PickerFrame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = PickerFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.Size = UDim2.new(0.5, 0, 0, 32)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 13
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local ColorPreview = Instance.new("TextButton")
			ColorPreview.Parent = PickerFrame
			ColorPreview.BackgroundColor3 = pickedColor
			ColorPreview.Position = UDim2.new(1, -40, 0, 6)
			ColorPreview.Size = UDim2.new(0, 30, 0, 20)
			ColorPreview.Text = ""
			
			local PreviewCorner = Instance.new("UICorner")
			PreviewCorner.CornerRadius = UDim.new(0, 4)
			PreviewCorner.Parent = ColorPreview

			-- // The Wheel Container
			local Container = Instance.new("Frame")
			Container.Parent = PickerFrame
			Container.BackgroundTransparency = 1
			Container.Position = UDim2.new(0, 0, 0, 35)
			Container.Size = UDim2.new(1, 0, 0, 140)
			
			-- The Wheel Image
			local Wheel = Instance.new("ImageButton")
			Wheel.Parent = Container
			Wheel.Position = UDim2.new(0, 15, 0, 0)
			Wheel.Size = UDim2.new(0, 120, 0, 120)
			Wheel.BackgroundColor3 = Color3.new(1,1,1)
			Wheel.BackgroundTransparency = 1
			Wheel.Image = "rbxassetid://6020299385" -- Color Wheel Asset
			Wheel.AutoButtonColor = false
			
			local Selector = Instance.new("Frame")
			Selector.Parent = Wheel
			Selector.BackgroundColor3 = Color3.new(1,1,1)
			Selector.Size = UDim2.new(0, 6, 0, 6)
			Selector.BorderColor3 = Color3.new(0,0,0)
			Selector.Rotation = 45
			Selector.Position = UDim2.new(0.5, 0, 0.5, 0)
			
			local SelCorner = Instance.new("UICorner")
			SelCorner.CornerRadius = UDim.new(1, 0)
			SelCorner.Parent = Selector
			
			local SelStroke = Instance.new("UIStroke")
			SelStroke.Parent = Selector
			SelStroke.Thickness = 1
			
			-- Value Slider (Brightness)
			local ValSlider = Instance.new("TextButton")
			ValSlider.Parent = Container
			ValSlider.BackgroundColor3 = Color3.new(1,1,1)
			ValSlider.Position = UDim2.new(0, 150, 0, 10)
			ValSlider.Size = UDim2.new(0, 20, 0, 100)
			ValSlider.Text = ""
			ValSlider.AutoButtonColor = false
			
			local ValCorner = Instance.new("UICorner")
			ValCorner.CornerRadius = UDim.new(0, 4)
			ValCorner.Parent = ValSlider
			
			local ValGradient = Instance.new("UIGradient")
			ValGradient.Parent = ValSlider
			ValGradient.Rotation = 90
			ValGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0.00, Color3.new(1,1,1)), 
				ColorSequenceKeypoint.new(1.00, Color3.new(0,0,0))
			}
			
			local ValInd = Instance.new("Frame")
			ValInd.Parent = ValSlider
			ValInd.BackgroundColor3 = Color3.new(1,1,1)
			ValInd.Size = UDim2.new(1, 4, 0, 4)
			ValInd.Position = UDim2.new(0, -2, 0, 0)
			ValInd.BorderSizePixel = 0
			ValInd.ZIndex = 2
			
			-- Logic Variables
			local draggingWheel = false
			local draggingVal = false
			
			local function UpdateColor()
				pickedColor = Color3.fromHSV(h, s, v)
				ColorPreview.BackgroundColor3 = pickedColor
				-- Update visual slider color to match hue
				ValSlider.BackgroundColor3 = Color3.fromHSV(h, s, 1) 
				ValGradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0.00, Color3.fromHSV(h, s, 1)), 
					ColorSequenceKeypoint.new(1.00, Color3.new(0,0,0))
				}
				pcall(callback, pickedColor)
			end
			
			local function UpdateWheel(input)
				local center = Wheel.AbsolutePosition + (Wheel.AbsoluteSize/2)
				local vector = Vector2.new(input.Position.X - center.X, input.Position.Y - center.Y)
				
				-- Hue (Angle)
				local angle = math.atan2(vector.Y, vector.X)
				h = (angle + math.pi) / (2 * math.pi)
				
				-- Saturation (Distance from center)
				local radius = Wheel.AbsoluteSize.X / 2
				s = math.clamp(vector.Magnitude / radius, 0, 1)
				
				-- Visual Position
				local newPos = UDim2.new(0.5 + (math.cos(angle) * s * 0.5), 0, 0.5 + (math.sin(angle) * s * 0.5), 0)
				Selector.Position = newPos
				
				UpdateColor()
			end
			
			local function UpdateVal(input)
				local relativeY = input.Position.Y - ValSlider.AbsolutePosition.Y
				local scale = math.clamp(relativeY / ValSlider.AbsoluteSize.Y, 0, 1)
				v = 1 - scale -- Top is 1 (Bright), Bottom is 0 (Dark)
				
				ValInd.Position = UDim2.new(0, -2, scale, -2)
				UpdateColor()
			end
			
			-- Inputs
			Wheel.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingWheel = true
					UpdateWheel(input)
				end
			end)
			
			ValSlider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingVal = true
					UpdateVal(input)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if draggingWheel then UpdateWheel(input) end
					if draggingVal then UpdateVal(input) end
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingWheel = false
					draggingVal = false
				end
			end)
			
			-- Dropdown Logic
			ColorPreview.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					Tween(PickerFrame, {Size = UDim2.new(1, -5, 0, 180)}) -- Expand
				else
					Tween(PickerFrame, {Size = UDim2.new(1, -5, 0, 32)}) -- Collapse
				end
			end)
		end

		return TabFunctions
	end
	
	return UI
end

return Library
