-- spawn_gui_loader.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GetSpawnData = ReplicatedStorage:WaitForChild("GetSpawnData")
local SpawnRequest = ReplicatedStorage:WaitForChild("SpawnRequest")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnGUI"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Spawn Menu"
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(1, 0, 0, 50)
categoryFrame.Position = UDim2.new(0, 0, 0, 45)
categoryFrame.BackgroundTransparency = 1
categoryFrame.Parent = mainFrame

local UIListLayoutCategories = Instance.new("UIListLayout")
UIListLayoutCategories.FillDirection = Enum.FillDirection.Horizontal
UIListLayoutCategories.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayoutCategories.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayoutCategories.Padding = UDim.new(0, 10)
UIListLayoutCategories.Parent = categoryFrame

local buttonFrame = Instance.new("ScrollingFrame")
buttonFrame.Size = UDim2.new(1, -20, 1, -100)
buttonFrame.Position = UDim2.new(0, 10, 0, 100)
buttonFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
buttonFrame.BorderSizePixel = 0
buttonFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
buttonFrame.ScrollBarThickness = 8
buttonFrame.Parent = mainFrame

local UIListLayoutButtons = Instance.new("UIListLayout")
UIListLayoutButtons.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutButtons.Padding = UDim.new(0, 5)
UIListLayoutButtons.Parent = buttonFrame

local spawnData = GetSpawnData:InvokeServer()

local function clearButtons()
	for _, child in ipairs(buttonFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function showCategory(categoryName)
	clearButtons()
	local items = spawnData[categoryName]
	if not items then return end

	for _, data in ipairs(items) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 40)
		btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
		btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		btn.Font = Enum.Font.GothamSemibold
		btn.TextSize = 20
		btn.Text = data.label
		btn.Parent = buttonFrame

		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(100, 160, 210)
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
		end)

		btn.MouseButton1Click:Connect(function()
			SpawnRequest:FireServer(data.itemName)
		end)
	end

	wait()
	buttonFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutButtons.AbsoluteContentSize.Y + 10)
end

for categoryName, _ in pairs(spawnData) do
	local catBtn = Instance.new("TextButton")
	catBtn.Size = UDim2.new(0, 140, 1, 0)
	catBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 130)
	catBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
	catBtn.Font = Enum.Font.GothamBold
	catBtn.TextSize = 18
	catBtn.Text = categoryName
	catBtn.Parent = categoryFrame

	catBtn.MouseEnter:Connect(function()
		catBtn.BackgroundColor3 = Color3.fromRGB(130, 130, 160)
	end)
	catBtn.MouseLeave:Connect(function()
		catBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 130)
	end)

	catBtn.MouseButton1Click:Connect(function()
		showCategory(categoryName)
	end)
end

local firstCategory = next(spawnData)
showCategory(firstCategory)

