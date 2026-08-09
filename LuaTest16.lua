local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local sakuraColor = Color3.fromRGB(255, 183, 197)
local sakuraHex = "#FFB7C5"
local whiteColor = Color3.fromRGB(230, 230, 230)
local blackColor = Color3.fromRGB(12, 12, 12)
local panelColor = Color3.fromRGB(18, 18, 18)
local darkBoxColor = Color3.fromRGB(22, 22, 22)
local strokeColor = Color3.fromRGB(38, 38, 38)
local mutedTextColor = Color3.fromRGB(140, 140, 140)

local Config = {
    SilentAimEnabled = false,
    AimBotEnabled = false,
    SilentAimTargetPart = "Head",
    AimBotTargetPart = "Head",
    FovEnabled = false,
    FovMode = "Move",
    FovRadius = 150,
    TeamCheckEnabled = true,
    WallCheckEnabled = true,
    ChamsEnabled = false,
    ChamsTeamCheck = true,
    ChamsTransparency = 0.4,
    CustomCursorEnabled = false,
    NoFogEnabled = false,
    FakeKorbloxEnabled = false,
    AntiAimEnabled = false,
    AntiAimSpeed = 3,
    ArrestAuraEnabled = false
}

setmetatable(_G, {
    __index = Config,
    __newindex = function(_, key, value)
        Config[key] = value
    end
})

local cachedTargetPart = nil
local wallCheckParams = RaycastParams.new()
wallCheckParams.FilterType = Enum.RaycastFilterType.Exclude

local GxiUI = Instance.new("ScreenGui")
GxiUI.Name = "GxiUI_PrisonLife"
GxiUI.Parent = CoreGui

local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Parent = GxiUI
Watermark.BackgroundColor3 = panelColor
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.AutomaticSize = Enum.AutomaticSize.XY

local WatermarkStroke = Instance.new("UIStroke", Watermark)
WatermarkStroke.Color = sakuraColor
WatermarkStroke.Thickness = 1
WatermarkStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local WatermarkPadding = Instance.new("UIPadding", Watermark)
WatermarkPadding.PaddingTop = UDim.new(0, 6)
WatermarkPadding.PaddingBottom = UDim.new(0, 6)
WatermarkPadding.PaddingLeft = UDim.new(0, 10)
WatermarkPadding.PaddingRight = UDim.new(0, 10)

local WatermarkBtn = Instance.new("TextButton", Watermark)
WatermarkBtn.Name = "WatermarkBtn"
WatermarkBtn.BackgroundTransparency = 1
WatermarkBtn.AutomaticSize = Enum.AutomaticSize.XY
WatermarkBtn.Font = Enum.Font.Code
WatermarkBtn.TextSize = 12
WatermarkBtn.RichText = true
WatermarkBtn.AutoButtonColor = false
WatermarkBtn.Text = string.format('<font color="%s">Gxi.</font><font color="#FFFFFF">cc</font> | fps: 0 | ms: 0', sakuraHex)

task.spawn(function()
    local lastTime = os.clock()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            WatermarkBtn.Text = string.format(
                '<font color="%s">Gxi.</font><font color="#FFFFFF">cc</font> | fps: %d | ms: %d',
                sakuraHex, fps, ping
            )
        end
    end)
end)

local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Parent = GxiUI
MainFrame.BackgroundColor3 = blackColor
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.GroupTransparency = 1

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 4)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = strokeColor
MainStroke.Thickness = 1.5

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -52)
ContentArea.Position = UDim2.new(0, 8, 0, 8)
ContentArea.BackgroundTransparency = 1

local BottomBar = Instance.new("Frame", MainFrame)
BottomBar.Name = "BottomBar"
BottomBar.Size = UDim2.new(1, -16, 0, 28)
BottomBar.Position = UDim2.new(0, 8, 1, -36)
BottomBar.BackgroundColor3 = panelColor

local BottomBarCorner = Instance.new("UICorner", BottomBar)
BottomBarCorner.CornerRadius = UDim.new(0, 3)

local BottomBarStroke = Instance.new("UIStroke", BottomBar)
BottomBarStroke.Color = strokeColor
BottomBarStroke.Thickness = 1

local BottomBarList = Instance.new("UIListLayout", BottomBar)
BottomBarList.FillDirection = Enum.FillDirection.Horizontal
BottomBarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
BottomBarList.VerticalAlignment = Enum.VerticalAlignment.Center
BottomBarList.Padding = UDim.new(0, 10)

local tabs = {}
local function CreateTab(name)
    local tabBtn = Instance.new("TextButton", BottomBar)
    tabBtn.Size = UDim2.new(0, 80, 1, -6)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name:lower()
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextColor3 = mutedTextColor
    tabBtn.TextSize = 11
    tabBtn.AutoButtonColor = false

    local tabFrame = Instance.new("Frame", ContentArea)
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false

    local leftCol = Instance.new("ScrollingFrame", tabFrame)
    leftCol.Size = UDim2.new(0.49, -4, 1, 0)
    leftCol.Position = UDim2.new(0, 0, 0, 0)
    leftCol.BackgroundColor3 = panelColor
    leftCol.BorderSizePixel = 0
    leftCol.ScrollBarThickness = 2
    leftCol.ScrollBarImageColor3 = sakuraColor
    Instance.new("UICorner", leftCol).CornerRadius = UDim.new(0, 3)
    Instance.new("UIStroke", leftCol).Color = strokeColor

    local leftList = Instance.new("UIListLayout", leftCol)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Padding = UDim.new(0, 6)

    local leftPad = Instance.new("UIPadding", leftCol)
    leftPad.PaddingTop = UDim.new(0, 8)
    leftPad.PaddingLeft = UDim.new(0, 8)
    leftPad.PaddingRight = UDim.new(0, 8)

    local rightCol = Instance.new("ScrollingFrame", tabFrame)
    rightCol.Size = UDim2.new(0.49, -4, 1, 0)
    rightCol.Position = UDim2.new(0.51, 4, 0, 0)
    rightCol.BackgroundColor3 = panelColor
    rightCol.BorderSizePixel = 0
    rightCol.ScrollBarThickness = 2
    rightCol.ScrollBarImageColor3 = sakuraColor
    Instance.new("UICorner", rightCol).CornerRadius = UDim.new(0, 3)
    Instance.new("UIStroke", rightCol).Color = strokeColor

    local rightList = Instance.new("UIListLayout", rightCol)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder
    rightList.Padding = UDim.new(0, 6)

    local rightPad = Instance.new("UIPadding", rightCol)
    rightPad.PaddingTop = UDim.new(0, 8)
    rightPad.PaddingLeft = UDim.new(0, 8)
    rightPad.PaddingRight = UDim.new(0, 8)

    table.insert(tabs, {
        Button = tabBtn, 
        Frame = tabFrame, 
        Left = leftCol, 
        Right = rightCol
    })

    tabBtn.MouseButton1Click:Connect(function()
        for _, tab in ipairs(tabs) do
            if tab.Button == tabBtn then
                tab.Button.TextColor3 = whiteColor
                tab.Frame.Visible = true
            else
                tab.Button.TextColor3 = mutedTextColor
                tab.Frame.Visible = false
            end
        end
    end)

    return leftCol, rightCol
end

WatermarkBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if MainFrame.GroupTransparency >= 0.9 or not MainFrame.Visible then
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
        else
            local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3), {GroupTransparency = 1})
            tw:Play()
            tw.Completed:Connect(function()
                if MainFrame.GroupTransparency == 1 then MainFrame.Visible = false end
            end)
        end
    end
end)

task.spawn(function()
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()
end)

local function CreateSectionHeader(parent, text)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = text:lower()
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = whiteColor
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateSquareToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 16)
    frame.BackgroundTransparency = 1

    local box = Instance.new("TextButton", frame)
    box.Size = UDim2.new(0, 12, 0, 12)
    box.Position = UDim2.new(0, 0, 0.5, -6)
    box.BackgroundColor3 = darkBoxColor
    box.BorderColor3 = strokeColor
    box.BorderSizePixel = 1
    box.Text = ""
    box.AutoButtonColor = false

    local innerFill = Instance.new("Frame", box)
    innerFill.Size = UDim2.new(1, -4, 1, -4)
    innerFill.Position = UDim2.new(0, 2, 0, 2)
    innerFill.BackgroundColor3 = sakuraColor
    innerFill.BorderSizePixel = 0
    innerFill.Visible = default or false

    local label = Instance.new("TextButton", frame)
    label.Size = UDim2.new(1, -18, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text:lower()
    label.Font = Enum.Font.Gotham
    label.TextColor3 = default and whiteColor or mutedTextColor
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left

    local state = default or false

    local function toggle()
        state = not state
        innerFill.Visible = state
        label.TextColor3 = state and whiteColor or mutedTextColor
        if callback then callback(state) end
    end

    box.MouseButton1Click:Connect(toggle)
    label.MouseButton1Click:Connect(toggle)
end

local function CreateSlider(parent, text, min, max, defaultVal, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundTransparency = 1

    local val = defaultVal or min

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 12)
    label.BackgroundTransparency = 1
    label.Text = text:lower() .. ": " .. tostring(val)
    label.Font = Enum.Font.Gotham
    label.TextColor3 = mutedTextColor
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("TextButton", frame)
    sliderBg.Size = UDim2.new(1, 0, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0, 16)
    sliderBg.BackgroundColor3 = darkBoxColor
    sliderBg.BorderColor3 = strokeColor
    sliderBg.BorderSizePixel = 1
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false

    local fill = Instance.new("Frame", sliderBg)
    local startPercent = math.clamp((val - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(startPercent, 0, 1, 0)
    fill.BackgroundColor3 = sakuraColor
    fill.BorderSizePixel = 0

    local dragging = false

    local function update(input)
        local pos = input.Position.X
        local bgPos = sliderBg.AbsolutePosition.X
        local bgWidth = sliderBg.AbsoluteSize.X
        local percent = math.clamp((pos - bgPos) / bgWidth, 0, 1)
        local currentVal = math.floor(min + (max - min) * percent)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        label.Text = text:lower() .. ": " .. tostring(currentVal)
        if callback then callback(currentVal) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true 
            update(input)
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function CreateDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 12)
    label.BackgroundTransparency = 1
    label.Text = text:lower()
    label.Font = Enum.Font.Gotham
    label.TextColor3 = mutedTextColor
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btnContainer = Instance.new("Frame", frame)
    btnContainer.Size = UDim2.new(1, 0, 0, 14)
    btnContainer.Position = UDim2.new(0, 0, 0, 14)
    btnContainer.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 4)

    for i, opt in ipairs(options) do
        local btn = Instance.new("TextButton", btnContainer)
        btn.Size = UDim2.new(0, 48, 1, 0)
        btn.BackgroundColor3 = darkBoxColor
        btn.BorderColor3 = strokeColor
        btn.BorderSizePixel = 1
        btn.Text = opt:lower()
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = (i == 1) and sakuraColor or mutedTextColor
        btn.TextSize = 9
        btn.MouseButton1Click:Connect(function()
            for _, child in ipairs(btnContainer:GetChildren()) do
                if child:IsA("TextButton") then child.TextColor3 = mutedTextColor end
            end
            btn.TextColor3 = sakuraColor
            if callback then callback(opt) end
        end)
    end
end

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 18)
    frame.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = darkBoxColor
    btn.BorderColor3 = strokeColor
    btn.BorderSizePixel = 1
    btn.Text = text:lower()
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = whiteColor
    btn.TextSize = 10
    btn.AutoButtonColor = false

    btn.MouseButton1Down:Connect(function()
        btn.TextColor3 = sakuraColor
    end)

    btn.MouseButton1Up:Connect(function()
        btn.TextColor3 = whiteColor
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function TeleportTo(cframe)
    local localPlayer = Players.LocalPlayer
    local char = localPlayer and localPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if hrp then
            hrp.CFrame = cframe
        end
    end
end

local rageLeft, rageRight = CreateTab("rage")

CreateSectionHeader(rageLeft, "silent aim")
CreateSquareToggle(rageLeft, "enabled", false, function(s) _G.SilentAimEnabled = s end)
CreateDropdown(rageLeft, "target part", {"Head", "Torso", "HRP"}, function(p) 
    _G.SilentAimTargetPart = (p == "HRP") and "HumanoidRootPart" or p 
end)
CreateSquareToggle(rageLeft, "team check", true, function(s) _G.TeamCheckEnabled = s end)
CreateSquareToggle(rageLeft, "wall check", true, function(s) _G.WallCheckEnabled = s end)

CreateSectionHeader(rageLeft, "arrest aura")
CreateSquareToggle(rageLeft, "enabled", false, function(s) if _G.ToggleArrestAura then _G.ToggleArrestAura(s) end end)

CreateSectionHeader(rageRight, "aimbot & fov")
CreateSquareToggle(rageRight, "aimbot", false, function(s) _G.AimBotEnabled = s end)
CreateDropdown(rageRight, "aimbot part", {"Head", "Torso"}, function(p) _G.AimBotTargetPart = p end)
CreateSquareToggle(rageRight, "draw fov", false, function(s) _G.FovEnabled = s end)
CreateDropdown(rageRight, "fov mode", {"Move", "Static"}, function(m) _G.FovMode = m end)
CreateSlider(rageRight, "fov radius", 10, 600, 150, function(v) _G.FovRadius = v end)

local visLeft, visRight = CreateTab("visuals")

CreateSectionHeader(visLeft, "chams")
CreateSquareToggle(visLeft, "enabled", false, function(s) if _G.ToggleChams then _G.ToggleChams(s) end end)
CreateSquareToggle(visLeft, "team check", true, function(s) _G.ChamsTeamCheck = s end)
CreateSlider(visLeft, "chams transparency", 0, 100, 40, function(v) _G.ChamsTransparency = v / 100 end)

CreateSectionHeader(visRight, "other visuals")
CreateSquareToggle(visRight, "custom cursor", false, function(s) if _G.ToggleCustomCursor then _G.ToggleCustomCursor(s) end end)
CreateSquareToggle(visRight, "no fog", false, function(s) if _G.ToggleNoFog then _G.ToggleNoFog(s) end end)

local miscLeft, miscRight = CreateTab("misc")

CreateSectionHeader(miscLeft, "character")
CreateSquareToggle(miscLeft, "fake headless", false, function(s) if _G.ToggleFakeHeadless then _G.ToggleFakeHeadless(s) end end)
CreateSquareToggle(miscLeft, "fake korblox", false, function(s) if _G.ToggleFakeKorblox then _G.ToggleFakeKorblox(s) end end)

CreateSectionHeader(miscRight, "teleports")
CreateButton(miscRight, "criminal base", function() TeleportTo(CFrame.new(-943, 94, 2063)) end)
CreateButton(miscRight, "guard armory", function() TeleportTo(CFrame.new(789, 100, 2260)) end)
CreateButton(miscRight, "cells", function() TeleportTo(CFrame.new(918, 100, 2441)) end)
CreateButton(miscRight, "cafeteria", function() TeleportTo(CFrame.new(961, 100, 2327)) end)
CreateButton(miscRight, "yard", function() TeleportTo(CFrame.new(979, 98, 2488)) end)
CreateButton(miscRight, "guard booth", function() TeleportTo(CFrame.new(802, 100, 2588)) end)
CreateButton(miscRight, "void baseplate", function() TeleportTo(CFrame.new(0, -500, 0)) end)

local aaLeft, aaRight = CreateTab("anti-aim")

CreateSectionHeader(aaLeft, "spin / jitter")
CreateSquareToggle(aaLeft, "enabled", false, function(s) if _G.ToggleAntiAim then _G.ToggleAntiAim(s) end end)
CreateSlider(aaLeft, "speed", 1, 10, 3, function(v) if _G.SetAntiAimSpeed then _G.SetAntiAimSpeed(v) end end)

tabs[1].Button.TextColor3 = whiteColor
tabs[1].Frame.Visible = true

local function IsEnemy(player)
    if not player or player == Players.LocalPlayer then return false end
    local lp = Players.LocalPlayer
    if not lp.Team or not player.Team then return true end

    local myTeam = lp.Team.Name
    local enemyTeam = player.Team.Name

    if myTeam == "Guards" then
        return enemyTeam == "Inmates" or enemyTeam == "Criminals"
    end

    if myTeam == "Inmates" or myTeam == "Criminals" then
        return enemyTeam == "Guards"
    end

    return myTeam ~= enemyTeam
end

local function GetTeamColor(player)
    if player and player.Team then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

local function GetBodyPart(char, preferredName)
    if not char then return nil end
    if preferredName == "Torso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    elseif preferredName == "HumanoidRootPart" or preferredName == "HRP" then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("Head")
    end
end

local function IsVisible(targetPart)
    local camera = workspace.CurrentCamera
    if not camera or not targetPart or not targetPart:IsDescendantOf(workspace) then
        return false
    end

    local origin = camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin

    if direction.Magnitude < 0.001 then
        return true
    end

    local ignoreList = {camera}
    local localChar = Players.LocalPlayer and Players.LocalPlayer.Character
    if localChar then
        table.insert(ignoreList, localChar)
    end

    wallCheckParams.FilterDescendantsInstances = ignoreList

    local success, result = pcall(function()
        return workspace:Raycast(origin, direction, wallCheckParams)
    end)

    if not success or not result then
        return not result
    end

    return result.Instance:IsDescendantOf(targetPart.Parent)
end

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 60
fovCircle.Radius = Config.FovRadius
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.Color = sakuraColor

local function GetFovCenter()
    local camera = workspace.CurrentCamera
    if Config.FovMode == "Static" and camera then
        return Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    else
        return UserInputService:GetMouseLocation()
    end
end

RunService.RenderStepped:Connect(function()
    if Config.FovEnabled then
        fovCircle.Position = GetFovCenter()
        fovCircle.Radius = Config.FovRadius
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.SilentAimEnabled and not Config.AimBotEnabled then
        cachedTargetPart = nil
        return
    end

    local closestPlayer = nil
    local shortestDistance = Config.FovEnabled and Config.FovRadius or math.huge
    local camera = workspace.CurrentCamera
    local centerPos = GetFovCenter()

    if not camera then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if not Config.TeamCheckEnabled or IsEnemy(player) then
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if char and hum and hum.Health > 0 then
                    local preferredPart = Config.SilentAimEnabled and Config.SilentAimTargetPart or Config.AimBotTargetPart
                    local targetPart = GetBodyPart(char, preferredPart)
                    if targetPart and targetPart:IsA("BasePart") then
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - centerPos).Magnitude
                            if distance <= shortestDistance then
                                if not Config.WallCheckEnabled or IsVisible(targetPart) then
                                    shortestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if closestPlayer and closestPlayer.Character then
        local preferredPart = Config.SilentAimEnabled and Config.SilentAimTargetPart or Config.AimBotTargetPart
        cachedTargetPart = GetBodyPart(closestPlayer.Character, preferredPart)
    else
        cachedTargetPart = nil
    end

    if Config.AimBotEnabled and cachedTargetPart and cachedTargetPart.Parent and cachedTargetPart:IsDescendantOf(workspace) then
        local success, targetPos = pcall(function() return cachedTargetPart.Position end)
        if success and targetPos then
            local camPos = camera.CFrame.Position
            local dir = (targetPos - camPos)
            if dir.Magnitude > 0.1 then
                camera.CFrame = CFrame.new(camPos, targetPos)
            end
        end
    end
end)

if hookmetamethod then
    local unpackFunc = table.unpack or unpack
    local makeClosure = newcclosure or function(f) return f end
    local oldNamecall

    oldNamecall = hookmetamethod(game, "__namecall", makeClosure(function(self, ...)
        if checkcaller() then 
            return oldNamecall(self, ...) 
        end

        local method = getnamecallmethod()
        local args = {...}

        if method == "FireServer" and self.Name == "ShootEvent" and Config.SilentAimEnabled and cachedTargetPart and cachedTargetPart.Parent then
            for _, shot in pairs(args) do
                if type(shot) == "table" then
                    shot.Hit = cachedTargetPart
                    shot.Cframe = cachedTargetPart.CFrame
                end
            end
            return oldNamecall(self, unpackFunc(args))
        end

        return oldNamecall(self, ...)
    end))

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", makeClosure(function(self, key)
        if Config.SilentAimEnabled and not checkcaller() and cachedTargetPart and cachedTargetPart.Parent then
            if typeof(self) == "Instance" and self:IsA("Mouse") then
                if key == "Hit" then 
                    return cachedTargetPart.CFrame 
                elseif key == "Target" then 
                    return cachedTargetPart 
                end
            end
        end

        return oldIndex(self, key)
    end))
end

local function applyChamsToCharacter(player)
    if not player or player == Players.LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local existingHighlight = char:FindFirstChild("GxiChamsHighlight")

    if Config.ChamsEnabled and (not Config.ChamsTeamCheck or IsEnemy(player)) then
        local teamColor = GetTeamColor(player)
        if not existingHighlight then
            local highlight = Instance.new("Highlight", char)
            highlight.Name = "GxiChamsHighlight"
            highlight.Adornee = char
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = teamColor
            highlight.FillTransparency = Config.ChamsTransparency or 0.4
            highlight.OutlineColor = teamColor
            highlight.OutlineTransparency = 0
        else
            existingHighlight.FillColor = teamColor
            existingHighlight.OutlineColor = teamColor
            existingHighlight.FillTransparency = Config.ChamsTransparency or 0.4
        end
    else
        if existingHighlight then existingHighlight:Destroy() end
    end
end

RunService.Heartbeat:Connect(function()
    if Config.ChamsEnabled then 
        for _, p in ipairs(Players:GetPlayers()) do 
            applyChamsToCharacter(p) 
        end 
    end
end)

function _G.ToggleChams(state)
    Config.ChamsEnabled = state
    for _, p in ipairs(Players:GetPlayers()) do 
        applyChamsToCharacter(p) 
    end
end

local customCursorConn = nil
local CrosshairGui = Instance.new("ScreenGui", CoreGui)
CrosshairGui.Name = "GxiCrosshairGui"
CrosshairGui.Enabled = false
CrosshairGui.DisplayOrder = 9999

local CursorContainer = Instance.new("Frame", CrosshairGui)
CursorContainer.Name = "CursorContainer"
CursorContainer.Size = UDim2.new(0, 12, 0, 12)
CursorContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CursorContainer.BackgroundTransparency = 1

local function createCrossBar(size, position)
    local bar = Instance.new("Frame", CursorContainer)
    bar.Size, bar.Position = size, position
    bar.BackgroundColor3, bar.BorderSizePixel = Color3.fromRGB(255, 255, 255), 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
end

createCrossBar(UDim2.new(0, 2, 0, 4), UDim2.new(0.5, -1, 0, 0))
createCrossBar(UDim2.new(0, 2, 0, 4), UDim2.new(0.5, -1, 1, -4))
createCrossBar(UDim2.new(0, 4, 0, 2), UDim2.new(0, 0, 0.5, -1))
createCrossBar(UDim2.new(0, 4, 0, 2), UDim2.new(1, -4, 0.5, -1))

function _G.ToggleCustomCursor(state)
    Config.CustomCursorEnabled = state 
    CrosshairGui.Enabled = state
    if customCursorConn then customCursorConn:Disconnect() customCursorConn = nil end
    if not state then return end

    customCursorConn = RunService.RenderStepped:Connect(function()
        if not Config.CustomCursorEnabled then return end
        local mouseLoc = UserInputService:GetMouseLocation()
        CursorContainer.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
    end)
end

local origFogEnd = Lighting.FogEnd
local origFogStart = Lighting.FogStart
local noFogConn = nil

function _G.ToggleNoFog(state)
    Config.NoFogEnabled = state
    if noFogConn then noFogConn:Disconnect() noFogConn = nil end

    if state then
        origFogEnd = Lighting.FogEnd
        origFogStart = Lighting.FogStart
        Lighting.FogEnd = 9e9

        noFogConn = Lighting.Changed:Connect(function(prop)
            if Config.NoFogEnabled and (prop == "FogEnd" or prop == "FogStart") then
                Lighting.FogEnd = 9e9
            end
        end)
    else
        Lighting.FogEnd = origFogEnd
        Lighting.FogStart = origFogStart
    end
end

local fakeHeadlessConnection = nil

function _G.ToggleFakeHeadless(state)
    if fakeHeadlessConnection then fakeHeadlessConnection:Disconnect() fakeHeadlessConnection = nil end
    if not state then
        local head = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head")
        if head then 
            head.LocalTransparencyModifier = 0 
            for _, c in ipairs(head:GetChildren()) do 
                if c:IsA("Decal") then c.Transparency = 0 end 
            end 
        end
        return
    end

    fakeHeadlessConnection = RunService.RenderStepped:Connect(function()
        local head = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head")
        if head then 
            head.LocalTransparencyModifier = 1 
            for _, c in ipairs(head:GetChildren()) do 
                if c:IsA("Decal") then c.Transparency = 1 end 
            end 
        end
    end)
end

-- ИСПРАВЛЕННЫЙ ФЕЙК КОРБЛОКС
local korbloxConn = nil

local function removeKorblox(char)
    if not char then return end
    for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
        local part = char:FindFirstChild(n)
        if part then 
            part.LocalTransparencyModifier = 0
            part.Transparency = 0 
            part.CanCollide = true
        end
    end
end

local function applyKorblox(char)
    if not char then return end 
    removeKorblox(char)

    local isR15 = char:FindFirstChild("UpperTorso") ~= nil
    if isR15 then 
        for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do 
            local part = char:FindFirstChild(n)
            if part then 
                part.LocalTransparencyModifier = 1
                part.CanCollide = false
            end 
        end 
    else 
        local rLeg = char:FindFirstChild("Right Leg")
        if rLeg then
            rLeg.LocalTransparencyModifier = 1
            rLeg.CanCollide = false
        end
    end
end

function _G.ToggleFakeKorblox(state)
    Config.FakeKorbloxEnabled = state
    if korbloxConn then 
        korbloxConn:Disconnect() 
        korbloxConn = nil 
    end

    if not state then 
        removeKorblox(Players.LocalPlayer.Character) 
        return 
    end

    if Players.LocalPlayer.Character then
        applyKorblox(Players.LocalPlayer.Character)
    end

    korbloxConn = RunService.RenderStepped:Connect(function()
        if not Config.FakeKorbloxEnabled then return end
        local char = Players.LocalPlayer.Character
        if char then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            if isR15 then
                local rUpper = char:FindFirstChild("RightUpperLeg")
                if rUpper and rUpper.LocalTransparencyModifier ~= 1 then
                    applyKorblox(char)
                end
            end
        end
    end)
end

local antiAimConnection = nil
local spinAngle = 0
local jitterState = false

function _G.ToggleAntiAim(state)
    Config.AntiAimEnabled = state
    if antiAimConnection then antiAimConnection:Disconnect() antiAimConnection = nil end
    if not state then return end

    antiAimConnection = RunService.RenderStepped:Connect(function()
        local char = Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local sm = Config.AntiAimSpeed or 3
        if hum.MoveDirection.Magnitude <= 0.1 then
            spinAngle = (spinAngle + (sm * 3)) % 360
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
        else
            jitterState = not jitterState
            local camera = workspace.CurrentCamera
            local _, yaw = (camera and camera.CFrame or hrp.CFrame):ToOrientation()
            local finalYaw = yaw + math.pi + ((jitterState and 1 or -1) * math.rad(8 + (sm * 2)))
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, finalYaw, 0)
        end
    end)
end

function _G.SetAntiAimSpeed(val) 
    Config.AntiAimSpeed = val 
end

-- ИСПРАВЛЕННЫЙ ARREST AURA
local arrestAuraConn = nil

function _G.ToggleArrestAura(state)
    Config.ArrestAuraEnabled = state
    if arrestAuraConn then 
        arrestAuraConn:Disconnect() 
        arrestAuraConn = nil 
    end
    if not state then return end

    local replicatedStorage = game:GetService("ReplicatedStorage")
    local arrestEvent = replicatedStorage:FindFirstChild("逮捕") or replicatedStorage:FindFirstChild("Event")

    local lastArrest = 0
    arrestAuraConn = RunService.Heartbeat:Connect(function()
        if not Config.ArrestAuraEnabled then return end
        if os.clock() - lastArrest < 0.4 then return end
        
        local localPlayer = Players.LocalPlayer
        local localChar = localPlayer.Character
        local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end

        if localPlayer.Team and localPlayer.Team.Name ~= "Guards" then return end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and IsEnemy(player) then
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if char and hum and hum.Health > 0 and hrp then
                    local distance = (localHRP.Position - hrp.Position).Magnitude
                    if distance <= 25 then
                        lastArrest = os.clock()
                        if arrestEvent then
                            pcall(function()
                                arrestEvent:FireServer(char)
                            end)
                        end
                        break
                    end
                end
            end
        end
    end)
end