local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for PlayerGui to exist
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("PlayerGui failed to load!")
    return
end

local BUTTON_IMAGE = "rbxassetid://85362313821089"
local BACKGROUND_IMAGE = "rbxassetid://115156280281052"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local OpenButton = Instance.new("ImageButton")
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0,65,0,65)
OpenButton.Position = UDim2.new(0.04,0,0.42,0)
OpenButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
OpenButton.BackgroundTransparency = 0.15
OpenButton.Image = BUTTON_IMAGE
OpenButton.ScaleType = Enum.ScaleType.Crop
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.BorderSizePixel = 0
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0,18)
Instance.new("UIStroke", OpenButton).Thickness = 2

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,430,0,280)
MainFrame.Position = UDim2.new(0.35,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,25)
Instance.new("UIStroke", MainFrame).Thickness = 2

local BG = Instance.new("ImageLabel")
BG.Parent = MainFrame
BG.Size = UDim2.new(1,0,1,0)
BG.BackgroundTransparency = 1
BG.Image = BACKGROUND_IMAGE
BG.ImageTransparency = 0.45
BG.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", BG).CornerRadius = UDim.new(0,25)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "Height Teleport"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0,0,0)

local Desc = Instance.new("TextLabel")
Desc.Parent = MainFrame
Desc.Size = UDim2.new(0.88,0,0,45)
Desc.Position = UDim2.new(0.06,0,0.2,0)
Desc.BackgroundTransparency = 1
Desc.Text = "Enter how many meters you want to teleport upward."
Desc.TextWrapped = true
Desc.TextScaled = true
Desc.Font = Enum.Font.Gotham
Desc.TextColor3 = Color3.fromRGB(0,0,0)

local TextBox = Instance.new("TextBox")
TextBox.Parent = MainFrame
TextBox.Size = UDim2.new(0.78,0,0,45)
TextBox.Position = UDim2.new(0.11,0,0.48,0)
TextBox.PlaceholderText = "Numbers only..."
TextBox.Text = ""
TextBox.TextScaled = true
TextBox.Font = Enum.Font.GothamBold
TextBox.TextColor3 = Color3.fromRGB(0,0,0)
TextBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundTransparency = 0.2
TextBox.BorderSizePixel = 0
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,15)

local ErrorText = Instance.new("TextLabel")
ErrorText.Parent = MainFrame
ErrorText.Size = UDim2.new(1,0,0,20)
ErrorText.Position = UDim2.new(0,0,0.67,0)
ErrorText.BackgroundTransparency = 1
ErrorText.Text = ""
ErrorText.TextScaled = true
ErrorText.Font = Enum.Font.GothamBold
ErrorText.TextColor3 = Color3.fromRGB(255,0,0)

local TPButton = Instance.new("TextButton")
TPButton.Parent = MainFrame
TPButton.Size = UDim2.new(0.5,0,0,42)
TPButton.Position = UDim2.new(0.25,0,0.8,0)
TPButton.Text = "Teleport"
TPButton.TextScaled = true
TPButton.Font = Enum.Font.GothamBold
TPButton.TextColor3 = Color3.fromRGB(255,255,255)
TPButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
TPButton.BorderSizePixel = 0
Instance.new("UICorner", TPButton).CornerRadius = UDim.new(0,14)

local Close = Instance.new("TextButton")
Close.Parent = MainFrame
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-40,0,10)
Close.Text = "X"
Close.TextScaled = true
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(255,0,0)
Close.BorderSizePixel = 0
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

TPButton.MouseButton1Click:Connect(function()
    local value = tonumber(TextBox.Text)
    if value then
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, value, 0)
            ErrorText.Text = ""
        else
            ErrorText.Text = "HumanoidRootPart not found!"
        end
    else
        ErrorText.Text = "Please enter numbers only."
    end
end)
