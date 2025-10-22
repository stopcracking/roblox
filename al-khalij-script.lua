local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
workspace.FallenPartsDestroyHeight = "nan"

local tweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.Name = "Fuck you nigger "
screenGui.ResetOnSpawn = false
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BackgroundTransparency = 1
frame.Parent = screenGui
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0.6, 0, 0.2, 0)
textLabel.Position = UDim2.new(0.2, 0, 0.4, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Made by Dream bitch"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextTransparency = 1
textLabel.Parent = frame
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(100, 150, 255)
uiStroke.Transparency = 1
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = textLabel
local tweenInfo1 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local frameTween1 = tweenService:Create(frame, tweenInfo1, {BackgroundTransparency = 0.5})
local textTween1 = tweenService:Create(textLabel, tweenInfo1, {TextTransparency = 0})
local strokeTween1 = tweenService:Create(uiStroke, tweenInfo1, {Transparency = 0})
frameTween1:Play()
textTween1:Play()
strokeTween1:Play()
wait(3) 
task.spawn(function ()
    while textLabel.TextTransparency == 0 do
        local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local glowTween1 = tweenService:Create(uiStroke, tweenInfo, {Color = Color3.fromRGB(150, 200, 255), Thickness = 4})
        local glowTween2 = tweenService:Create(uiStroke, tweenInfo, {Color = Color3.fromRGB(100, 150, 255), Thickness = 2})
        glowTween1:Play()
        glowTween1.Completed:Wait()
        glowTween2:Play()
        glowTween2.Completed:Wait()
    end
end)
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local frameTween = tweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
local textTween = tweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})
local strokeTween = tweenService:Create(uiStroke, tweenInfo, {Transparency = 1})
frameTween:Play()
textTween:Play()
strokeTween:Play()
frameTween.Completed:Connect(function()
    screenGui:Destroy()
end)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
local function showNotification(text)
    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, 20, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0) 
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 8)
    shadowCorner.Parent = shadow
    local label = Instance.new("TextLabel")
    label.Name = "NotificationText"
    label.Size = UDim2.new(1, -20, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local slideIn = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -320, 0, 20)})
    slideIn:Play()
    wait(5)
    local slideOut = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)})
    slideOut:Play()
    slideOut.Completed:Connect(function()
        frame:Destroy()
    end)
end
warn("Anti afk running")
local autoFarmActive = false
local hum = game:GetService("Players").LocalPlayer.Character.Humanoid
game:GetService("Players").LocalPlayer.Idled:connect(function()
    warn("Anti afk ran")
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
local guiScreen = Instance.new("ScreenGui")
guiScreen.Name = "conquer top"
guiScreen.DisplayOrder = 1000
guiScreen.Parent = game.CoreGui
local guiFrame = Instance.new("Frame")
guiFrame.Size = UDim2.new(0, 200, 0, 150)
guiFrame.Position = UDim2.new(0, 10, 0, 10)
guiFrame.BackgroundTransparency = 0.5
guiFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
guiFrame.BorderSizePixel = 0
guiFrame.Parent = guiScreen
local autoFarmToggle = Instance.new("TextButton")
autoFarmToggle.Size = UDim2.new(0, 180, 0, 30)
autoFarmToggle.Position = UDim2.new(0.5, -90, 0, 10)
autoFarmToggle.Text = "Auto Farm: OFF"
autoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmToggle.BackgroundTransparency = 0.3
autoFarmToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
autoFarmToggle.Parent = guiFrame
autoFarmToggle.MouseButton1Click:Connect(function()
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        if hum.Sit == true then
            autoFarmActive = not autoFarmActive
            if autoFarmActive then
                autoFarmToggle.Text = "Auto Farm: ON"
                spawn(function()
                    while autoFarmActive do
                        for i, v in pairs(workspace:GetChildren()) do
                            if v.ClassName == "Model" and (v:FindFirstChild("Container") or v.Name == "PortCraneOversized") then
                                v:Destroy()
                            end
                        end
                        wait(1)
                    end
                end)
                spawn(function()
                    while autoFarmActive do
                        if not hum then
                            print("No humanoid fuck nigga")
                            break
                        end
                        local car = hum.SeatPart and hum.SeatPart.Parent
                        if not car then
                            warn("No car, drive on my dick or maybe a car?")
                            break
                        end
                        car.PrimaryPart = car:FindFirstChild("#Weight") or car.PrimaryPart
                        if not car.PrimaryPart then
                            warn("No PrimaryPart found, maybe a bug nigga discord : (kurrxed_xtyle) contact me")
                            break
                        end
                        if not getfenv().first then
                            car:PivotTo(CFrame.new(Vector3.new(-40085.1758, 2101.7981, -3069.90405)) * CFrame.Angles(0, math.rad(3.6), 0))
                            wait(0.1)
                            getfenv().first = true
                        end
                        car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                        local waypoints = {
                            Vector3.new(888.509033, 2101.7981, -3075.43115),
                            Vector3.new(-40085.1758, 2143.82959, -3069.90405)
                        }
                        local mathlock = 550
                        for i, location in ipairs(waypoints) do
                            if not autoFarmActive then break end
                            local targetXZ = Vector3.new(location.X, car.PrimaryPart.Position.Y, location.Z)
                            local directionXZ = (targetXZ - car.PrimaryPart.Position).Unit
                            local lookVector = Vector3.new(directionXZ.X, -0.05, directionXZ.Z).Unit
                            local lookCFrame = CFrame.new(Vector3.new(0, 0, 0), lookVector)

                            repeat
                                task.wait()
                                car:PivotTo(CFrame.new(car.PrimaryPart.Position) * lookCFrame)
                                car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * mathlock
                            until game.Players.LocalPlayer:DistanceFromCharacter(location) < 50 or not autoFarmActive
                            car.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end)
            else
                autoFarmToggle.Text = "Auto Farm: OFF"
            end
        else
            showNotification("get in a car bitch ass stupid nigga.")
        end
    else
        showNotification("no Humanoid, how a stupid nigger gets this error but you got it somehow that why i hate niggers")
    end
end)
local blackScreenToggle = Instance.new("TextButton")
blackScreenToggle.Size = UDim2.new(0, 180, 0, 30)
blackScreenToggle.Position = UDim2.new(0.5, -90, 0, 50)
blackScreenToggle.Text = "nigger mode: OFF"
blackScreenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
blackScreenToggle.BackgroundTransparency = 0.3
blackScreenToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blackScreenToggle.Parent = guiFrame
blackScreenToggle.MouseButton1Click:Connect(function()
    if blackScreenToggle.Text == "nigger mode: OFF" then
        local blackScreen = Instance.new("ScreenGui")
        blackScreen.Name = "nigger mode"
        blackScreen.DisplayOrder = -1000
        blackScreen.Parent = game.CoreGui
        local blackFrame = Instance.new("Frame")
        blackFrame.Size = UDim2.new(1, 0, 1, 0)
        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        blackFrame.BorderSizePixel = 0
        blackFrame.Parent = blackScreen
        blackScreenToggle.Text = "nigger mode: ON"
    else
        local blackScreen = game.CoreGui:FindFirstChild("nigger mode")
        if blackScreen then
            blackScreen:Destroy()
        end
        blackScreenToggle.Text = "nigger mode: OFF"
    end
end)