loadstring(game:HttpGet("https://raw.githubusercontent.com/stopcracking/roblox/refs/heads/main/antiafk.lua"))()
-- Dark Gothic Gray Anti-AFK with Glass Effect & Movable UI
-- Place this in a LocalScript inside StarterPlayerScripts or StarterGui

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- ========== DARK GOTHIC GRAY CONFIGURATION ==========
local CONFIG = {
    -- Timer settings
    AFK_TIMEOUT = 900,           -- 15 minutes in seconds
    CLICK_COUNT = 10,
    CLICK_DELAY = 0.1,
    
    -- Modern GUI settings
    GUI_WIDTH = 300,
    GUI_HEIGHT = 130,
    GUI_POSITION_OFFSET = 20,
    
    -- Dark Gothic Gray color scheme
    COLORS = {
        -- Grayscale with dark gothic theme
        PRIMARY = Color3.fromRGB(180, 180, 180),     -- Light gray
        SECONDARY = Color3.fromRGB(120, 120, 120),   -- Medium gray
        TERTIARY = Color3.fromRGB(80, 80, 80),       -- Dark gray
        BACKGROUND = Color3.fromRGB(20, 20, 25),      -- Deep dark gray
        BACKGROUND_GLASS = Color3.fromRGB(25, 25, 30), -- Glass background
        TEXT = Color3.fromRGB(220, 220, 220),         -- Off-white
        TEXT_SECONDARY = Color3.fromRGB(160, 160, 170), -- Muted gray
        ACCENT = Color3.fromRGB(200, 200, 200),       -- Bright gray
        GLOW = Color3.fromRGB(150, 150, 150),         -- Gray glow
        SUCCESS = Color3.fromRGB(180, 220, 180),      -- Muted green-gray
        WARNING = Color3.fromRGB(220, 200, 160),      -- Muted gold-gray
        SHADOW = Color3.fromRGB(0, 0, 0),             -- Black for shadows
    },
    
    -- Animation settings
    ANIMATION = {
        DRAG_SPEED = 0.2,            -- Drag animation speed
        GLOW_INTENSITY = 0.6,         -- Glow effect intensity
        TRANSITION_SPEED = 0.3,       -- Transition speed for animations
    }
}
-- ===========================================

-- Variables
local antiAfkActive = true
local clickSimulationInProgress = false
local startTime = tick()
local runtime = 0
local dragging = false
local dragStart = nil
local dragOffset = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkGothicAntiAfk"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Main container with glass effect
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, CONFIG.GUI_WIDTH, 0, CONFIG.GUI_HEIGHT)
mainContainer.Position = UDim2.new(1, -(CONFIG.GUI_WIDTH + CONFIG.GUI_POSITION_OFFSET), 1, -(CONFIG.GUI_HEIGHT + CONFIG.GUI_POSITION_OFFSET))
mainContainer.BackgroundColor3 = CONFIG.COLORS.BACKGROUND_GLASS
mainContainer.BackgroundTransparency = 0.2
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = false
mainContainer.Parent = screenGui

-- Shadow effects
local shadow1 = Instance.new("Frame")
shadow1.Size = UDim2.new(1, 10, 1, 10)
shadow1.Position = UDim2.new(0, -5, 0, -5)
shadow1.BackgroundColor3 = CONFIG.COLORS.SHADOW
shadow1.BackgroundTransparency = 0.7
shadow1.BorderSizePixel = 0
shadow1.ZIndex = -1
shadow1.Parent = mainContainer

local shadow2 = Instance.new("Frame")
shadow2.Size = UDim2.new(1, 6, 1, 6)
shadow2.Position = UDim2.new(0, -3, 0, -3)
shadow2.BackgroundColor3 = CONFIG.COLORS.SHADOW
shadow2.BackgroundTransparency = 0.5
shadow2.BorderSizePixel = 0
shadow2.ZIndex = -1
shadow2.Parent = mainContainer

-- Rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainContainer

-- Shadow corners
for _, shadow in ipairs({shadow1, shadow2}) do
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 18)
    shadowCorner.Parent = shadow
end

-- Glass effect gradient
local glassGradient = Instance.new("UIGradient")
glassGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLORS.BACKGROUND_GLASS:lerp(Color3.new(1, 1, 1), 0.1)),
    ColorSequenceKeypoint.new(0.5, CONFIG.COLORS.BACKGROUND_GLASS),
    ColorSequenceKeypoint.new(1, CONFIG.COLORS.BACKGROUND_GLASS:lerp(Color3.new(0, 0, 0), 0.1))
})
glassGradient.Rotation = 45
glassGradient.Parent = mainContainer

-- Border
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1.2
uiStroke.Color = CONFIG.COLORS.PRIMARY
uiStroke.Transparency = 0.8
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = mainContainer

-- Inner highlight
local innerHighlight = Instance.new("Frame")
innerHighlight.Size = UDim2.new(1, -4, 1, -4)
innerHighlight.Position = UDim2.new(0, 2, 0, 2)
innerHighlight.BackgroundTransparency = 1
innerHighlight.BorderSizePixel = 0
innerHighlight.Parent = mainContainer

local innerStroke = Instance.new("UIStroke")
innerStroke.Thickness = 1
innerStroke.Color = CONFIG.COLORS.TEXT_SECONDARY
innerStroke.Transparency = 0.95
innerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
innerStroke.Parent = innerHighlight

-- Drag handle
local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1, 0, 0, 40)
dragHandle.Position = UDim2.new(0, 0, 0, 0)
dragHandle.BackgroundTransparency = 1
dragHandle.BorderSizePixel = 0
dragHandle.Parent = mainContainer

-- Header section
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 40)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainContainer

-- Title - FIXED FONT
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ANTI-AFK"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextColor3 = CONFIG.COLORS.TEXT
titleLabel.Parent = headerFrame

-- Title gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLORS.PRIMARY),
    ColorSequenceKeypoint.new(0.5, CONFIG.COLORS.SECONDARY),
    ColorSequenceKeypoint.new(1, CONFIG.COLORS.TERTIARY)
})
titleGradient.Rotation = 45
titleGradient.Parent = titleLabel

-- Made by text - FIXED FONT
local madeByLabel = Instance.new("TextLabel")
madeByLabel.Size = UDim2.new(0.4, 0, 1, 0)
madeByLabel.Position = UDim2.new(0.6, -15, 0, 0)
madeByLabel.BackgroundTransparency = 1
madeByLabel.Text = "kurxed"
madeByLabel.Font = Enum.Font.SourceSansLight
madeByLabel.TextSize = 11
madeByLabel.TextXAlignment = Enum.TextXAlignment.Right
madeByLabel.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
madeByLabel.TextTransparency = 0.4
madeByLabel.Parent = headerFrame

-- Separator
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -30, 0, 1)
separator.Position = UDim2.new(0, 15, 0, 40)
separator.BackgroundColor3 = CONFIG.COLORS.SECONDARY
separator.BackgroundTransparency = 0.8
separator.BorderSizePixel = 0
separator.Parent = mainContainer

-- Timer display - FIXED FONT
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 0, 45)
timerLabel.Position = UDim2.new(0, 0, 0, 45)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "15:00"
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 38
timerLabel.TextColor3 = CONFIG.COLORS.TEXT
timerLabel.Parent = mainContainer

-- Timer shadow
local timerShadow = Instance.new("TextLabel")
timerShadow.Size = UDim2.new(1, 2, 0, 45)
timerShadow.Position = UDim2.new(0, 2, 0, 47)
timerShadow.BackgroundTransparency = 1
timerShadow.Text = "15:00"
timerShadow.Font = Enum.Font.GothamBold
timerShadow.TextSize = 38
timerShadow.TextColor3 = CONFIG.COLORS.SHADOW
timerShadow.TextTransparency = 0.7
timerShadow.ZIndex = 0
timerShadow.Parent = mainContainer

-- Status frame
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -30, 0, 24)
statusFrame.Position = UDim2.new(0, 15, 0, 95)
statusFrame.BackgroundTransparency = 1
statusFrame.BorderSizePixel = 0
statusFrame.Parent = mainContainer

-- Status dot
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 0, 0.5, -4)
statusDot.BackgroundColor3 = CONFIG.COLORS.SUCCESS
statusDot.BorderSizePixel = 0
statusDot.Parent = statusFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- Dot glow
local dotGlow = Instance.new("Frame")
dotGlow.Size = UDim2.new(0, 14, 0, 14)
dotGlow.Position = UDim2.new(0, -3, 0.5, -7)
dotGlow.BackgroundColor3 = CONFIG.COLORS.SUCCESS
dotGlow.BackgroundTransparency = 0.8
dotGlow.BorderSizePixel = 0
dotGlow.Parent = statusFrame

local dotGlowCorner = Instance.new("UICorner")
dotGlowCorner.CornerRadius = UDim.new(1, 0)
dotGlowCorner.Parent = dotGlow

-- Status text - FIXED FONT
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 100, 1, 0)
statusText.Position = UDim2.new(0, 15, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Active"
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextColor3 = CONFIG.COLORS.SUCCESS
statusText.Parent = statusFrame

-- Runtime display - FIXED FONT
local runtimeText = Instance.new("TextLabel")
runtimeText.Size = UDim2.new(0, 100, 1, 0)
runtimeText.Position = UDim2.new(1, -100, 0, 0)
runtimeText.BackgroundTransparency = 1
runtimeText.Text = "00:00:00"
runtimeText.Font = Enum.Font.SourceSans
runtimeText.TextSize = 11
runtimeText.TextXAlignment = Enum.TextXAlignment.Right
runtimeText.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
runtimeText.Parent = statusFrame

-- Click count badge
local badgeFrame = Instance.new("Frame")
badgeFrame.Size = UDim2.new(0, 70, 0, 24)
badgeFrame.Position = UDim2.new(1, -80, 0, 5)
badgeFrame.BackgroundColor3 = CONFIG.COLORS.TERTIARY
badgeFrame.BackgroundTransparency = 0.7
badgeFrame.BorderSizePixel = 0
badgeFrame.Parent = mainContainer

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 20)
badgeCorner.Parent = badgeFrame

local badgeStroke = Instance.new("UIStroke")
badgeStroke.Thickness = 1
badgeStroke.Color = CONFIG.COLORS.PRIMARY
badgeStroke.Transparency = 0.7
badgeStroke.Parent = badgeFrame

-- Badge text - FIXED FONT
local badgeText = Instance.new("TextLabel")
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Text = "10 CLICKS"
badgeText.Font = Enum.Font.GothamBold
badgeText.TextSize = 9
badgeText.TextColor3 = CONFIG.COLORS.PRIMARY
badgeText.Parent = badgeFrame

-- Progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(1, -30, 0, 2)
progressBar.Position = UDim2.new(0, 15, 1, -10)
progressBar.BackgroundColor3 = CONFIG.COLORS.TERTIARY
progressBar.BackgroundTransparency = 0.6
progressBar.BorderSizePixel = 0
progressBar.Parent = mainContainer

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = CONFIG.COLORS.PRIMARY
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(1, 0)
progressCorner.Parent = progressFill

-- Function to format time
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Function to update displays
local function updateDisplays()
    if not clickSimulationInProgress then
        local minutes = math.floor(CONFIG.AFK_TIMEOUT / 60)
        local seconds = CONFIG.AFK_TIMEOUT % 60
        timerLabel.Text = string.format("%02d:%02d", minutes, seconds)
        timerShadow.Text = timerLabel.Text
    else
        timerLabel.Text = "CLICKING"
        timerShadow.Text = "CLICKING"
    end
    
    runtime = tick() - startTime
    runtimeText.Text = formatTime(runtime)
    
    local progress = (runtime % CONFIG.AFK_TIMEOUT) / CONFIG.AFK_TIMEOUT
    progressFill.Size = UDim2.new(progress, 0, 1, 0)
end

-- Dragging functions
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        dragOffset = mainContainer.Position - UDim2.new(0, dragStart.X, 0, dragStart.Y)
    end
end

local function updateDrag(input)
    if dragging then
        local newPos = UDim2.new(0, input.Position.X + dragOffset.X.Offset, 0, input.Position.Y + dragOffset.Y.Offset)
        local dragTween = TweenService:Create(
            mainContainer,
            TweenInfo.new(CONFIG.ANIMATION.DRAG_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = newPos}
        )
        dragTween:Play()
    end
end

local function stopDrag()
    dragging = false
end

-- Connect drag events
dragHandle.InputBegan:Connect(startDrag)
dragHandle.InputChanged:Connect(updateDrag)
dragHandle.InputEnded:Connect(stopDrag)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        stopDrag()
    end
end)

-- Click simulation
local function simulateClicks()
    if clickSimulationInProgress then return end
    clickSimulationInProgress = true
    
    statusText.Text = "Clicking..."
    statusText.TextColor3 = CONFIG.COLORS.WARNING
    statusDot.BackgroundColor3 = CONFIG.COLORS.WARNING
    dotGlow.BackgroundColor3 = CONFIG.COLORS.WARNING
    badgeText.Text = "CLICKING"
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    for i = 1, CONFIG.CLICK_COUNT do
        if not antiAfkActive then break end
        
        local x = math.random(100, viewportSize.X - 100)
        local y = math.random(100, viewportSize.Y - 100)
        
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        
        task.wait(CONFIG.CLICK_DELAY)
    end
    
    statusText.Text = "Active"
    statusText.TextColor3 = CONFIG.COLORS.SUCCESS
    statusDot.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    dotGlow.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    badgeText.Text = "10 CLICKS"
    
    clickSimulationInProgress = false
    startTime = tick()
end

-- Animations
local function animateDot()
    while antiAfkActive do
        local pulseTween = TweenService:Create(
            dotGlow,
            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, -6, 0.5, -10)}
        )
        pulseTween:Play()
        task.wait(2)
    end
end

-- Start animations
task.spawn(animateDot)

-- Update loop
RunService.Heartbeat:Connect(updateDisplays)

-- Main timer loop
task.spawn(function()
    while antiAfkActive do
        task.wait(CONFIG.AFK_TIMEOUT)
        if antiAfkActive and not clickSimulationInProgress then
            simulateClicks()
        end
    end
end)
screenGui.Enabled = false
-- Toggle GUI with F6
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F6 then
        screenGui.Enabled = false
    end
end)
-- made by CypherM#8368 (if you take anything from this script then make sure to add credits!) (you are not allowed to sell this / add it to your paid script unless if you ask me)
repeat wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')
local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

po.ChildAdded:connect(function(a)
    if a.Name == 'ErrorPrompt' then
        repeat
            game:GetService('TeleportService'):Teleport(game.PlaceId)
            wait(2)
        until false
    end
end)
print("auto rejoin active")
