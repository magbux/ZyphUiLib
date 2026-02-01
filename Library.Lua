local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

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
	local info = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	TweenService:Create(obj, info, props):Play()
end

function Library:CreateWindow(name)
	local UI = {}
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CustomLibrary"
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Opener = Instance.new("TextButton")
	Opener.Name = "Opener"
	Opener.Parent = ScreenGui
	Opener.BackgroundColor3 = Color3.fromRGB(96, 96, 96)
	Opener.Position = UDim2.new(0.82, 0, 0.37, 0)
	Opener.Size = UDim2.new(0, 64, 0, 64)
	Opener.BorderSizePixel = 0
	Opener.Text = ""
	Opener.AutoButtonColor = false
	
	local OpenerCorner = Instance.new("UICorner")
	OpenerCorner.CornerRadius = UDim.new(0, 16)
	OpenerCorner.Parent = Opener
	
	local OpenerIcon = Instance.new("ImageLabel")
	OpenerIcon.Parent = Opener
	OpenerIcon.BackgroundTransparency = 1
	OpenerIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
	OpenerIcon.Position = UDim2.new(0.2, 0, 0.2, 0)
	OpenerIcon.Image = "rbxassetid://3926305904"
	OpenerIcon.ImageColor3 = Color3.fromRGB(240, 240, 240)

	MakeDraggable(Opener, Opener)

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	MainFrame.Position = UDim2.new(0.23, 0, 0.225, 0)
	MainFrame.Size = UDim2.new(0, 731, 0, 348)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame
	
	local isOpen = false
	Opener.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		MainFrame.Visible = isOpen
		
		if isOpen then
			MainFrame.Size = UDim2.new(0, 0, 0, 348)
			Tween(MainFrame, {Size = UDim2.new(0, 731, 0, 348)}, 0.5)
		end
	end)

	MakeDraggable(MainFrame, MainFrame)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Sidebar.Size = UDim2.new(0, 150, 1, 0)
	Sidebar.BorderSizePixel = 0
	
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 8)
	SidebarCorner.Parent = Sidebar

	local SidebarFix = Instance.new("Frame")
	SidebarFix.Parent = Sidebar
	SidebarFix.BorderSizePixel = 0
	SidebarFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	SidebarFix.Size = UDim2.new(0, 10, 1, 0)
	SidebarFix.Position = UDim2.new(1, -10, 0, 0)
	SidebarFix.ZIndex = 2
	
	local Title = Instance.new("TextLabel")
	Title.Parent = Sidebar
	Title.Text = name
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Parent = Sidebar
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 10, 0, 50)
	TabContainer.Size = UDim2.new(1, -20, 1, -60)
	TabContainer.ScrollBarThickness = 0
	
	local TabList = Instance.new("UIListLayout")
	TabList.Parent = TabContainer
	TabList.Padding = UDim.new(0, 5)
	TabList.SortOrder = Enum.SortOrder.LayoutOrder

	local PagesFolder = Instance.new("Folder")
	PagesFolder.Name = "Pages"
	PagesFolder.Parent = MainFrame

	function UI:Tab(text)
		local TabFunctions = {}
		
		local TabBtn = Instance.new("TextButton")
		TabBtn.Parent = TabContainer
		TabBtn.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
		TabBtn.Size = UDim2.new(1, 0, 0, 35)
		TabBtn.Font = Enum.Font.Gotham
		TabBtn.Text = text
		TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabBtn.TextSize = 14
		TabBtn.AutoButtonColor = false
		
		local TabBtnCorner = Instance.new("UICorner")
		TabBtnCorner.CornerRadius = UDim.new(0, 6)
		TabBtnCorner.Parent = TabBtn
		
		local Page = Instance.new("ScrollingFrame")
		Page.Name = text .. "_Page"
		Page.Parent = PagesFolder
		Page.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		Page.BackgroundTransparency = 1
		Page.Position = UDim2.new(0, 160, 0, 10)
		Page.Size = UDim2.new(0, 560, 1, -20)
		Page.ScrollBarThickness = 4
		Page.ScrollBarImageColor3 = Color3.fromRGB(63, 63, 63)
		Page.Visible = false
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _, child in pairs(TabContainer:GetChildren()) do
				if child:IsA("TextButton") then
					Tween(child, {BackgroundColor3 = Color3.fromRGB(63, 63, 63), TextColor3 = Color3.fromRGB(200, 200, 200)})
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

		function TabFunctions:Button(btnText, callback)
			local Btn = Instance.new("TextButton")
			Btn.Parent = Page
			Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Btn.Size = UDim2.new(1, -10, 0, 40)
			Btn.Font = Enum.Font.GothamSemibold
			Btn.Text = btnText
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.TextSize = 14
			Btn.AutoButtonColor = false
			
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 6)
			BtnCorner.Parent = Btn
			
			Btn.MouseButton1Click:Connect(function()
				Tween(Btn, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.1)
				task.wait(0.1)
				Tween(Btn, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.1)
				pcall(callback)
			end)
		end

		function TabFunctions:Toggle(toggleText, default, callback)
			local toggled = default or false
			
			local ToggleFrame = Instance.new("TextButton")
			ToggleFrame.Parent = Page
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
			ToggleFrame.Text = ""
			ToggleFrame.AutoButtonColor = false
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = ToggleFrame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = ToggleFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.Size = UDim2.new(0.7, 0, 1, 0)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = toggleText
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local Indicator = Instance.new("Frame")
			Indicator.Parent = ToggleFrame
			Indicator.BackgroundColor3 = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(40, 40, 40)
			Indicator.Position = UDim2.new(0.85, 0, 0.5, -10)
			Indicator.Size = UDim2.new(0, 40, 0, 20)
			
			local IndCorner = Instance.new("UICorner")
			IndCorner.CornerRadius = UDim.new(1, 0)
			IndCorner.Parent = Indicator
			
			local Dot = Instance.new("Frame")
			Dot.Parent = Indicator
			Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Dot.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			Dot.Size = UDim2.new(0, 16, 0, 16)
			
			local DotCorner = Instance.new("UICorner")
			DotCorner.CornerRadius = UDim.new(1, 0)
			DotCorner.Parent = Dot
			
			ToggleFrame.MouseButton1Click:Connect(function()
				toggled = not toggled
				
				local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				local targetColor = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(40, 40, 40)
				
				Tween(Dot, {Position = targetPos})
				Tween(Indicator, {BackgroundColor3 = targetColor})
				
				pcall(callback, toggled)
			end)
		end

		function TabFunctions:Slider(sliderText, min, max, default, callback)
			local value = default or min
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Page
			SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			SliderFrame.Size = UDim2.new(1, -10, 0, 50)
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = SliderFrame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = SliderFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 15, 0, 5)
			Label.Size = UDim2.new(1, -30, 0, 20)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = sliderText .. ": " .. tostring(value)
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local SliderBg = Instance.new("TextButton")
			SliderBg.Parent = SliderFrame
			SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			SliderBg.Position = UDim2.new(0, 15, 0, 30)
			SliderBg.Size = UDim2.new(1, -30, 0, 10)
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

		function TabFunctions:ColorPicker(text, defaultColor, callback)
			local pickedColor = defaultColor or Color3.fromRGB(255, 255, 255)
			local isOpen = false
			
			local PickerFrame = Instance.new("Frame")
			PickerFrame.Parent = Page
			PickerFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			PickerFrame.Size = UDim2.new(1, -10, 0, 40)
			PickerFrame.ClipsDescendants = true
			
			local PickerCorner = Instance.new("UICorner")
			PickerCorner.CornerRadius = UDim.new(0, 6)
			PickerCorner.Parent = PickerFrame
			
			local Label = Instance.new("TextLabel")
			Label.Parent = PickerFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 15, 0, 0)
			Label.Size = UDim2.new(0.6, 0, 0, 40)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local ColorPreview = Instance.new("TextButton")
			ColorPreview.Parent = PickerFrame
			ColorPreview.BackgroundColor3 = pickedColor
			ColorPreview.Position = UDim2.new(0.85, 0, 0.5, -10)
			ColorPreview.Size = UDim2.new(0, 40, 0, 20)
			ColorPreview.Text = ""
			
			local PreviewCorner = Instance.new("UICorner")
			PreviewCorner.CornerRadius = UDim.new(0, 4)
			PreviewCorner.Parent = ColorPreview
			
			local SlidersContainer = Instance.new("Frame")
			SlidersContainer.Parent = PickerFrame
			SlidersContainer.BackgroundTransparency = 1
			SlidersContainer.Position = UDim2.new(0, 0, 0, 45)
			SlidersContainer.Size = UDim2.new(1, 0, 0, 100)
			
			local function CreateRGBSlider(comp, yPos)
				local SliderBg = Instance.new("TextButton")
				SliderBg.Parent = SlidersContainer
				SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				SliderBg.Position = UDim2.new(0, 15, 0, yPos)
				SliderBg.Size = UDim2.new(1, -30, 0, 10)
				SliderBg.Text = ""
				SliderBg.AutoButtonColor = false
				
				local SC = Instance.new("UICorner")
				SC.CornerRadius = UDim.new(1, 0)
				SC.Parent = SliderBg
				
				local Fill = Instance.new("Frame")
				Fill.Parent = SliderBg
				Fill.BackgroundColor3 = comp == "R" and Color3.fromRGB(255, 50, 50) or (comp == "G" and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(50, 50, 255))
				
				local initialVal = (comp == "R" and pickedColor.R) or (comp == "G" and pickedColor.G) or pickedColor.B
				Fill.Size = UDim2.new(initialVal, 0, 1, 0)
				Fill.BorderSizePixel = 0
				
				local FC = Instance.new("UICorner")
				FC.CornerRadius = UDim.new(1, 0)
				FC.Parent = Fill

				local dragging = false
				
				local function Update(input)
					local scale = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
					Fill.Size = UDim2.new(scale, 0, 1, 0)
					
					local r = SlidersContainer:FindFirstChild("R_Fill", true).Size.X.Scale
					local g = SlidersContainer:FindFirstChild("G_Fill", true).Size.X.Scale
					local b = SlidersContainer:FindFirstChild("B_Fill", true).Size.X.Scale
					
					pickedColor = Color3.new(r, g, b)
					ColorPreview.BackgroundColor3 = pickedColor
					pcall(callback, pickedColor)
				end
				
				SliderBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true; Update(input)
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						Update(input)
					end
				end)
				
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
				end)
				
				Fill.Name = comp.."_Fill"
			end
			
			CreateRGBSlider("R", 10)
			CreateRGBSlider("G", 40)
			CreateRGBSlider("B", 70)
			
			ColorPreview.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					Tween(PickerFrame, {Size = UDim2.new(1, -10, 0, 150)})
				else
					Tween(PickerFrame, {Size = UDim2.new(1, -10, 0, 40)})
				end
			end)
		end

		return TabFunctions
	end
	
	return UI
end

return Library
