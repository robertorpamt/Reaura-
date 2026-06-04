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
MainFrame.Size = UDim2.new(0, 340, 0, 500)
MainFrame.Position = UDim2.new(0.5, -170, 0.4, -250)
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
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
    AutoClimb = false,
    AutoCakes = false,
    SpawnAtStairs = true,
    SpamClaim25Cakes = false
}

local climbThread = nil
local cakeThread = nil
local spamClaimThread = nil

local STAIRS_POSITION = Vector3.new(51, 29, -39)

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

local function AddMobileButton(name, callback)
    local Frame = Instance.new("Frame")
    local Button = Instance.new("TextButton")
    
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScrollFrame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = "  " .. name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.SourceSansBold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Frame
    
    Button.MouseButton1Click:Connect(function()
        callback()
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
AddMobileToggle("Auto-Collect Cakes", "AutoCakes", false)
AddMobileToggle("Spawn at Stairs", "SpawnAtStairs", true)
AddMobileToggle("💰 Spam Claim 25Cakes", "SpamClaim25Cakes", false)

-- Add Teleport to Rebirth Door Button
AddMobileButton("🚪 Teleport to Rebirth Door", function()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Character = LocalPlayer.Character
    
    if not Character then
        print("❌ No character found!")
        return
    end
    
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then
        print("❌ No HumanoidRootPart found!")
        return
    end
    
    -- Find FINISH part in SpiralTower
    local SpiralTower = workspace:FindFirstChild("SpiralTower")
    if not SpiralTower then
        print("❌ SpiralTower not found!")
        return
    end
    
    local FinishDoor = SpiralTower:FindFirstChild("FINISH")
    if not FinishDoor then
        print("❌ FINISH door not found!")
        return
    end
    
    print("🚪 Teleporting to Rebirth Door...")
    RootPart.CFrame = FinishDoor.CFrame + Vector3.new(0, 3, 0)
    print("✅ Arrived at Rebirth Door!")
end)

-- =========================================================================
-- CORE EXECUTION BACKEND
-- =========================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
local playerRemotes = remotesFolder and remotesFolder:WaitForChild("PlayerRemotes", 5)
local sprintRE = playerRemotes and playerRemotes:WaitForChild("SprintRequestRE", 5)
local purchaseUpgradeRF = playerRemotes and playerRemotes:WaitForChild("PurchaseTowerUpgradeRF", 5)
local LimitedDanielRF = playerRemotes and playerRemotes:WaitForChild("LimitedDanielRF", 5)

-- Get UpdateStateRE for spam claiming
local ClientData = ReplicatedStorage:FindFirstChild("ClientData")
local StateController = ClientData and ClientData:FindFirstChild("StateController")
local UpdateStateRE = StateController and StateController:FindFirstChild("UpdateStateRE")

local function fireSprintRemote()
    if Flags.Sprint and sprintRE then pcall(function() sprintRE:FireServer(true) end) end
end

local function teleportToStairs()
    if not Flags.SpawnAtStairs then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if RootPart then
        task.wait(0.5)
        RootPart.CFrame = CFrame.new(STAIRS_POSITION + Vector3.new(0, 3, 0))
        print("📍 Spawned at stairs!")
    end
end

-- Initial spawn
if LocalPlayer.Character then
    task.spawn(function()
        task.wait(0.2)
        fireSprintRemote()
        teleportToStairs()
    end)
end

-- Respawn handler
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    fireSprintRemote()
    teleportToStairs()
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if purchaseUpgradeRF then
            -- Regular upgrade purchases
            if Flags.APGain then pcall(function() purchaseUpgradeRF:InvokeServer("APGain") end) end
            if Flags.Fortitude then pcall(function() purchaseUpgradeRF:InvokeServer("Fortitude") end) end
            if Flags.Composure then pcall(function() purchaseUpgradeRF:InvokeServer("Composure") end) end
            if Flags.Momentum then pcall(function() purchaseUpgradeRF:InvokeServer("Momentum") end) end
            if Flags.BonusSpeed then pcall(function() purchaseUpgradeRF:InvokeServer("BonusSpeed") end) end
            if Flags.AuraRecharge then pcall(function() purchaseUpgradeRF:InvokeServer("AuraRecharge") end) end
            if Flags.AuraStrength then pcall(function() purchaseUpgradeRF:InvokeServer("AuraStrength") end) end
            
            -- Unlock upgrades (new method)
            if Flags.APGain then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "APGain") end) end
            if Flags.Fortitude then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "Fortitude") end) end
            if Flags.Composure then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "Composure") end) end
            if Flags.Momentum then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "Momentum") end) end
            if Flags.BonusSpeed then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "BonusSpeed") end) end
            if Flags.AuraRecharge then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "AuraRecharge") end) end
            if Flags.AuraStrength then pcall(function() purchaseUpgradeRF:InvokeServer("Unlock", "AuraStrength") end) end
        end
    end
end)

-- =========================================================================
-- SPAM CLAIM 25 CAKES ENGINE
-- =========================================================================
local function startSpamClaim()
    if spamClaimThread then
        task.cancel(spamClaimThread)
        spamClaimThread = nil
    end
    
    spamClaimThread = task.spawn(function()
        print("💰 Starting spam claim loop for 25Cakes...")
        
        while Flags.SpamClaim25Cakes do
            if not LimitedDanielRF or not UpdateStateRE then
                print("❌ Required remotes not found!")
                break
            end
            
            -- Remove 25Cakes from claimed rewards
            pcall(function()
                firesignal(UpdateStateRE.OnClientEvent, {
                    action = "UpdateLimitedDaniel",
                    value = {
                        ClaimedRewards = {}  -- Remove all claimed rewards
                    }
                })
            end)
            
            task.wait(0.1)
            
            -- Claim the reward
            pcall(function()
                local result = LimitedDanielRF:InvokeServer("ClaimReward", "25Cakes")
                print("✅ Claimed 25Cakes! Result:", result)
            end)
            
            task.wait(0.2)
        end
        
        print("❌ Spam claim stopped!")
        spamClaimThread = nil
    end)
end

-- Monitor SpamClaim25Cakes flag changes
task.spawn(function()
    local previousState = false
    while true do
        task.wait(0.1)
        if Flags.SpamClaim25Cakes and not previousState then
            startSpamClaim()
            previousState = true
        elseif not Flags.SpamClaim25Cakes and previousState then
            if spamClaimThread then
                task.cancel(spamClaimThread)
                spamClaimThread = nil
            end
            previousState = false
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
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        
        print("🏃 Starting spiral climb to Floor 50...")
        
        -- Activate sprint
        if sprintRE then
            pcall(function() sprintRE:FireServer(true) end)
        end
        
        task.wait(0.5)
        
        local startY = RootPart.Position.Y
        local targetHeight = 300
        local rotation = 0
        
        while (RootPart.Position.Y - startY) < targetHeight do
            if not Flags.AutoClimb or not Character.Parent then 
                print("❌ Auto-climb stopped!")
                break 
            end
            
            -- Rotate character continuously (spiral motion)
            rotation = rotation + 0.05
            
            local rotatedCFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, rotation, 0)
            local forwardDirection = rotatedCFrame.LookVector
            
            -- Move forward in the rotated direction while going up
            local newPos = RootPart.Position + forwardDirection * 2 + Vector3.new(0, 0.2, 0)
            RootPart.CFrame = CFrame.new(newPos, newPos + forwardDirection)
            
            task.wait(0.05)
        end
        
        print("✅ Reached Floor 50!")
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

-- =========================================================================
-- AUTO-CAKE COLLECTOR ENGINE
-- =========================================================================
local function startAutoCakes()
    if cakeThread then
        task.cancel(cakeThread)
        cakeThread = nil
    end
    
    cakeThread = task.spawn(function()
        while Flags.AutoCakes do
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local RootPart = Character:WaitForChild("HumanoidRootPart")
            
            print("🍰 Starting cake collection...")
            
            local CakeFolder = workspace:FindFirstChild("LimitedDanielCakeVisuals")
            if not CakeFolder then
                print("❌ Cake folder not found!")
                task.wait(2)
                continue
            end
            
            local cakes = CakeFolder:GetChildren()
            print("Found " .. #cakes .. " cakes!")
            
            -- Teleport to each cake
            for _, cake in pairs(cakes) do
                if not Flags.AutoCakes or not Character.Parent then 
                    print("❌ Cake collection stopped or character died!")
                    break 
                end
                
                -- Get the Handle (or PrimaryPart) of the cake model
                local handle = cake:FindFirstChild("Handle") or cake:FindFirstChildOfClass("BasePart")
                
                if handle then
                    print("📍 Collecting: " .. cake.Name)
                    RootPart.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.5)
                end
            end
            
            print("✅ All cakes collected! Looping...")
            task.wait(1) -- Wait before restarting
        end
        
        cakeThread = nil
    end)
end

-- Monitor AutoCakes flag changes
task.spawn(function()
    local previousState = false
    while true do
        task.wait(0.1)
        if Flags.AutoCakes and not previousState then
            startAutoCakes()
            previousState = true
        elseif not Flags.AutoCakes and previousState then
            if cakeThread then
                task.cancel(cakeThread)
                cakeThread = nil
            end
            previousState = false
        end
    end
end)
