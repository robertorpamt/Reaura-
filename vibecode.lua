-- =========================================================================
-- OPTIMIZED STANDALONE INTERFACE (NO LOADSTRING / FALLBACK METHOD)
-- =========================================================================

-- Safely clear out any old duplicate windows before drawing a new one
local oldGui = game:GetService("CoreGui"):FindFirstChild("VibecodeHub") or game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("VibecodeHub")
if oldGui then oldGui:Destroy() end

-- Create Core Engine UI Screen Container
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftNav = Instance.new("Frame")
local TabContainer = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")

ScreenGui.Name = "VibecodeHub"
ScreenGui.Parent = game:GetService("CoreGui") rescue game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Style Main Panel Window 
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows you to hold and drag the window with your mouse
MainFrame.Parent = ScreenGui

-- Apply Smooth Rounded Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header Title Styling
TitleLabel.Size = UDim2.new(0, 500, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 5)
TitleLabel.Text = "⚡ Vibecode Control Hub (Hirthe72264)"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = MainFrame

-- Scrolling Container for Toggles
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0, 490, 0, 270)
ScrollFrame.Position = UDim2.new(0, 15, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

-- =========================================================================
-- STATE MEMORY MANAGEMENT
-- =========================================================================
local Flags = {
    Sprint = true,
    APGain = false,
    Fortitude = false,
    Composure = false,
    Momentum = false,
    BonusSpeed = false
}

-- UI Macro Creator Function
local function AddToggleButton(name, flagName, defaultVal)
    Flags[flagName] = defaultVal
    
    local Frame = Instance.new("Frame")
    local Button = Instance.new("TextButton")
    local StatusText = Instance.new("TextLabel")
    
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScrollFrame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
    
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = "   " .. name
    Button.TextColor3 = Color3.fromRGB(220, 220, 230)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Frame
    
    StatusText.Size = UDim2.new(0, 100, 1, 0)
    StatusText.Position = UDim2.new(1, -110, 0, 0)
    StatusText.Text = defaultVal and "ENABLED" or "DISABLED"
    StatusText.TextColor3 = defaultVal and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(240, 70, 70)
    StatusText.Font = Enum.Font.SourceSansBold
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Right
    StatusText.BackgroundTransparency = 1
    StatusText.Parent = Frame
    
    Button.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        StatusText.Text = Flags[flagName] and "ENABLED" or "DISABLED"
        StatusText.TextColor3 = Flags[flagName] and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(240, 70, 70)
    end)
end

-- Generate Interface Menu Items
AddToggleButton("Infinite Auto-Sprint (Persists Through Death)", "Sprint", true)
AddToggleButton("Auto Loop APGain Upgrade", "APGain", false)
AddToggleButton("Auto Loop Fortitude Upgrade", "Fortitude", false)
AddToggleButton("Auto Loop Composure Upgrade", "Composure", false)
AddToggleButton("Auto Loop Momentum Upgrade", "Momentum", false)
AddToggleButton("Auto Loop BonusSpeed Upgrade", "BonusSpeed", false)

-- =========================================================================
-- NETWORK AND AUTOMATION ENGINE BACKEND
-- =========================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
local playerRemotes = remotesFolder and remotesFolder:WaitForChild("PlayerRemotes", 5)

local sprintRE = playerRemotes and playerRemotes:WaitForChild("SprintRequestRE", 5)
local upgradeRF = playerRemotes and playerRemotes:WaitForChild("PurchaseTowerUpgradeRF", 5)

-- Thread 1: Infinite Auto-Sprint 
local function fireSprintRemote()
    if Flags.Sprint and sprintRE then
        pcall(function() sprintRE:FireServer(true) end)
    end
end

if LocalPlayer.Character then task.spawn(fireSprintRemote) end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    fireSprintRemote()
end)

-- Thread 2: Centralized Loop Upgrades Optimization
task.spawn(function()
    while true do
        task.wait(0.3) -- Engine Cycle Sync Time
        
        if upgradeRF then
            if Flags.APGain then pcall(function() upgradeRF:InvokeServer("APGain") end) end
            if Flags.Fortitude then pcall(function() upgradeRF:InvokeServer("Fortitude") end) end
            if Flags.Composure then pcall(function() upgradeRF:InvokeServer("Composure") end) end
            if Flags.Momentum then pcall(function() upgradeRF:InvokeServer("Momentum") end) end
            if Flags.BonusSpeed then pcall(function() upgradeRF:InvokeServer("BonusSpeed") end) end
        end
    end
end)
