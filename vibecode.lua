-- =========================================================================
-- MOBILE-OPTIMIZED DASHBOARD (100% ARCEUS X COMPATIBLE)
-- =========================================================================

local oldGui = game:GetService("CoreGui"):FindFirstChild("VibecodeHubMobile") or game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("VibecodeHubMobile")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "VibecodeHubMobile"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Responsive mobile sizing (adapts to touch screens fluidly)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 340)
MainFrame.Position = UDim2.new(0.5, -170, 0.4, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

TitleLabel.Size = UDim2.new(1, -20, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "⚡ Vibecode Mobile Panel"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = MainFrame

ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.Parent = MainFrame

UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

local Flags = {
    Sprint = true,
    APGain = false,
    Fortitude = false,
    Composure = false,
    Momentum = false,
    BonusSpeed = false,
    AuraRecharge = false,
    AuraStrength = false,
    AutoClimb = false
}

local climbThread = nil

local function AddMobileToggle(name, flagName, defaultVal)
    Flags[flagName] = defaultVal
    local Frame = Instance.new("Frame")
    local Button = Instance.new("TextButton")
    local StatusText = Instance.new("TextLabel")
    
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScrollFrame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = "  " .. name
    Button.TextColor3 = Color3.fromRGB(210, 210, 220)
    Button.TextSize = 13
    Button.Font = Enum.Font.SourceSans
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Frame
    
    StatusText.Size = UDim2.new(0, 80, 1, 0)
    StatusText.Position = UDim2.new(1, -90, 0, 0)
    StatusText.Text = defaultVal and "ON" or "OFF"
    StatusText.TextColor3 = defaultVal and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(240, 70, 70)
    StatusText.Font = Enum.Font.SourceSansBold
    StatusText.TextSize = 13
    StatusText.TextXAlignment = Enum.TextXAlignment.Right
    StatusText.BackgroundTransparency = 1
    StatusText.Parent = Frame
    
    Button.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        StatusText.Text = Flags[flagName] and "ON" or "OFF"
        StatusText.TextColor3 = Flags[flagName] and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(240, 70, 70)
    end)
end

-- Generate Touch UI Items
AddMobileToggle("Auto-Sprint (Always-On)", "Sprint", true)
AddMobileToggle("Auto APGain Upgrade", "APGain", false)
AddMobileToggle("Auto Fortitude Upgrade", "Fortitude", false)
AddMobileToggle("Auto Composure Upgrade", "Composure", false)
AddMobileToggle("Auto Momentum Upgrade", "Momentum", false)
AddMobileToggle("Auto BonusSpeed Upgrade", "BonusSpeed", false)
AddMobileToggle("Auto AuraRecharge Upgrade", "AuraRecharge", false)
AddMobileToggle("Auto AuraStrength Upgrade", "AuraStrength", false)
AddMobileToggle("Auto-Climb to Floor 50", "AutoClimb", false)

-- =========================================================================
-- CORE EXECUTION BACKEND
-- =========================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
local playerRemotes = remotesFolder and remotesFolder:WaitForChild("PlayerRemotes", 5)
local sprintRE = playerRemotes and playerRemotes:WaitForChild("SprintRequestRE", 5)
local upgradeRF = playerRemotes and playerRemotes:WaitForChild("PurchaseTowerUpgradeRF", 5)

local function fireSprintRemote()
    if Flags.Sprint and sprintRE then pcall(function() sprintRE:FireServer(true) end) end
end
if LocalPlayer.Character then task.spawn(fireSprintRemote) end
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.3) fireSprintRemote() end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if upgradeRF then
            if Flags.APGain then pcall(function() upgradeRF:InvokeServer("APGain") end) end
            if Flags.Fortitude then pcall(function() upgradeRF:InvokeServer("Fortitude") end) end
            if Flags.Composure then pcall(function() upgradeRF:InvokeServer("Composure") end) end
            if Flags.Momentum then pcall(function() upgradeRF:InvokeServer("Momentum") end) end
            if Flags.BonusSpeed then pcall(function() upgradeRF:InvokeServer("BonusSpeed") end) end
            if Flags.AuraRecharge then pcall(function() upgradeRF:InvokeServer("AuraRecharge") end) end
            if Flags.AuraStrength then pcall(function() upgradeRF:InvokeServer("AuraStrength") end) end
        end
    end
end)

-- =========================================================================
-- AUTO-CLIMB SPIRAL STAIRCASE ENGINE
-- =========================================================================
local function startAutoClimb()
    if climbThread then
        task.cancel(climbThread)
        climbThread = nil
    end
    
    climbThread = task.spawn(function()
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        
        local SpiralTower = workspace:WaitForChild("SpiralTower")
        local TARGET_FLOOR = 50
        local WAYPOINT_DISTANCE = 10
        
        print("🏃 Starting climb to Floor " .. TARGET_FLOOR .. "...")
        
        local function getFloorStairTop(floorNumber)
            local floor = SpiralTower:FindFirstChild("Floor" .. floorNumber)
            if not floor then return nil end
            
            local steps = floor:FindFirstChild("Steps")
            if steps then
                local highestY = 0
                local topPosition = steps.Position
                
                for _, step in pairs(steps:GetChildren()) do
                    if step:IsA("BasePart") and step.Position.Y > highestY then
                        highestY = step.Position.Y
                        topPosition = step.Position + Vector3.new(0, 3, 0)
                    end
                end
                
                return topPosition
            end
            
            return nil
        end
        
        for floorNum = 0, TARGET_FLOOR do
            if not Flags.AutoClimb or not Character.Parent then 
                print("❌ Auto-climb stopped!")
                break 
            end
            
            local targetPos = getFloorStairTop(floorNum)
            
            if targetPos then
                print("📍 Moving to Floor " .. floorNum .. "...")
                
                while (targetPos - RootPart.Position).Magnitude > WAYPOINT_DISTANCE do
                    if not Flags.AutoClimb or not Character.Parent then break end
                    
                    Humanoid:MoveTo(targetPos)
                    task.wait(0.05)
                end
                
                if floorNum < TARGET_FLOOR then
                    Humanoid:Jump()
                    task.wait(0.3)
                end
            end
        end
        
        print("✅ Reached Floor " .. TARGET_FLOOR .. "!")
        climbThread = nil
    end)
end

-- Monitor AutoClimb flag changes
task.spawn(function()
    local previousState = false
    while true do
        task.wait(0.1)
        if Flags.AutoClimb and not previousState then
            startAutoClimb()
            previousState = true
        elseif not Flags.AutoClimb and previousState then
            if climbThread then
                task.cancel(climbThread)
                climbThread = nil
            end
            previousState = false
        end
    end
end)
