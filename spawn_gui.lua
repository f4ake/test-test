-- spawn_gui.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpawnEvent = ReplicatedStorage:WaitForChild("SpawnRequest")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tworzymy ScreenGui jeśli nie istnieje
local screenGui = playerGui:FindFirstChild("SpawnGUI") or Instance.new("ScreenGui")
screenGui.Name = "SpawnGUI"
screenGui.Parent = playerGui

-- Dane o przedmiotach (możesz rozszerzać)
local spawnData = {
	Siona = {
		{label = "Marchewka", itemName = "CarrotSeed"},
		{label = "Ziemniak", itemName = "PotatoSeed"},
	},
	Zwierzeta = {
		{label = "Królik", itemName = "Rabbit"},
		{label = "Kura", itemName = "Chicken"},
		{label = "Szop", itemName = "Raccoon"},
		{label = "Moon Cat", itemName = "MoonCat"},
	}
}

local function clearButtons(buttonFrame)
	for _, child in ipairs(buttonFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function showCategory(categoryName, buttonFrame)
	clearButtons(buttonFrame)
	local items = spawnData[categoryName]
	if not items then return end

	for i, data in ipairs(items) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 200, 0, 40)
		button.Position = UDim2.new(0, 10, 0, (i - 1) * 45)
		button.Text = data.label
		button.BackgroundColor3 = Color3.fromRGB(180, 220, 180)
		button.Parent = buttonFrame

		button.MouseButton1Click:Connect(function()
			SpawnEvent:FireServer(data.itemName)
		end)
	end
end

local function createGui()
	screenGui:ClearAllChildren()

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(0, 220, 0, 300)
	buttonFrame.Position = UDim2.new(0, 10, 0, 100)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = screenGui

	local categoryFrame = Instance.new("Frame")
	categoryFrame.Size = UDim2.new(0, 220, 0, 50)
	categoryFrame.Position = UDim2.new(0, 10, 0, 40)
	categoryFrame.BackgroundTransparency = 1
	categoryFrame.Parent = screenGui

	local xOffset = 0
	for categoryName, _ in pairs(spawnData) do
		local catBtn = Instance.new("TextButton")
		catBtn.Size = UDim2.new(0, 100, 0, 40)
		catBtn.Position = UDim2.new(0, xOffset, 0, 0)
		catBtn.Text = categoryName
		catBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
		catBtn.Parent = categoryFrame

		catBtn.MouseButton1Click:Connect(function()
			showCategory(categoryName, buttonFrame)
		end)

		xOffset += 110
	end

	showCategory("Siona", buttonFrame)
end

createGui()
