--------------------------------------------------
-- SERVICES
--------------------------------------------------
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--------------------------------------------------
-- VARIABLES
--------------------------------------------------
local sakuraColor = Color3.fromRGB(255, 183, 197)
local whiteColor = Color3.fromRGB(255, 255, 255)
local blackColor = Color3.fromRGB(15, 15, 15)
local darkGray = Color3.fromRGB(25, 25, 25)

--------------------------------------------------
-- CONFIG
--------------------------------------------------

--------------------------------------------------
-- GUI
--------------------------------------------------
local GxiUI = Instance.new("ScreenGui")
GxiUI.Name = "GxiUI"
GxiUI.Parent = CoreGui

-- ================= Вотермарка ================= --
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Parent = GxiUI
Watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Watermark.BackgroundTransparency = 0.3
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.Size = UDim2.new(0, 0, 0, 24)
Watermark.AutomaticSize = Enum.AutomaticSize.X

local WatermarkCorner = Instance.new("UICorner", Watermark)
WatermarkCorner.CornerRadius = UDim.new(0, 12)

local WatermarkStroke = Instance.new("UIStroke", Watermark)
WatermarkStroke.Color = Color3.fromRGB(45, 45, 45)
WatermarkStroke.Thickness = 1

local WatermarkPadding = Instance.new("UIPadding", Watermark)
WatermarkPadding.PaddingLeft = UDim.new(0, 10)
WatermarkPadding.PaddingRight = UDim.new(0, 10)

local WatermarkList = Instance.new("UIListLayout", Watermark)
WatermarkList.FillDirection = Enum.FillDirection.Horizontal
WatermarkList.SortOrder = Enum.SortOrder.LayoutOrder
WatermarkList.Padding = UDim.new(0, 8)
WatermarkList.VerticalAlignment = Enum.VerticalAlignment.Center

-- Кнопка Gxi.cc (Открытие/Закрытие меню)
local TitleBtn = Instance.new("TextButton", Watermark)
TitleBtn.Name = "TitleBtn"
TitleBtn.BackgroundTransparency = 1
TitleBtn.Size = UDim2.new(0, 0, 1, 0)
TitleBtn.AutomaticSize = Enum.AutomaticSize.X
TitleBtn.Text = ""
TitleBtn.AutoButtonColor = false

local TitleList = Instance.new("UIListLayout", TitleBtn)
TitleList.FillDirection = Enum.FillDirection.Horizontal
TitleList.SortOrder = Enum.SortOrder.LayoutOrder
TitleList.VerticalAlignment = Enum.VerticalAlignment.Center

local WatermarkText1 = Instance.new("TextLabel", TitleBtn)
WatermarkText1.BackgroundTransparency = 1
WatermarkText1.AutomaticSize = Enum.AutomaticSize.X
WatermarkText1.Size = UDim2.new(0, 0, 1, 0)
WatermarkText1.Font = Enum.Font.GothamBold
WatermarkText1.Text = "Gxi."
WatermarkText1.TextColor3 = sakuraColor
WatermarkText1.TextSize = 11

local WatermarkText2 = Instance.new("TextLabel", TitleBtn)
WatermarkText2.BackgroundTransparency = 1
WatermarkText2.AutomaticSize = Enum.AutomaticSize.X
WatermarkText2.Size = UDim2.new(0, 0, 1, 0)
WatermarkText2.Font = Enum.Font.GothamBold
WatermarkText2.Text = "cc"
WatermarkText2.TextColor3 = whiteColor
WatermarkText2.TextSize = 11

-- FPS
local FpsLabel = Instance.new("TextLabel", Watermark)
FpsLabel.Name = "FpsLabel"
FpsLabel.BackgroundTransparency = 1
FpsLabel.AutomaticSize = Enum.AutomaticSize.X
FpsLabel.Size = UDim2.new(0, 0, 1, 0)
FpsLabel.Font = Enum.Font.Gotham
FpsLabel.Text = "60 fps"
FpsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
FpsLabel.TextSize = 11

-- Ping (ms)
local PingLabel = Instance.new("TextLabel", Watermark)
PingLabel.Name = "PingLabel"
PingLabel.BackgroundTransparency = 1
PingLabel.AutomaticSize = Enum.AutomaticSize.X
PingLabel.Size = UDim2.new(0, 0, 1, 0)
PingLabel.Font = Enum.Font.Gotham
PingLabel.Text = "0 ms"
PingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PingLabel.TextSize = 11

-- Таймер
local TimeLabel = Instance.new("TextLabel", Watermark)
TimeLabel.Name = "TimeLabel"
TimeLabel.BackgroundTransparency = 1
TimeLabel.AutomaticSize = Enum.AutomaticSize.X
TimeLabel.Size = UDim2.new(0, 0, 1, 0)
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.Text = "00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
TimeLabel.TextSize = 11

-- Обновление FPS, Ping и времени
task.spawn(function()
    local lastTime = os.clock()
    local frameCount = 0
    
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            FpsLabel.Text = tostring(fps) .. " fps"
            frameCount = 0
            lastTime = currentTime
            
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            PingLabel.Text = tostring(ping) .. " ms"
            
            local gameTime = math.floor(workspace.DistributedGameTime)
            local hours = math.floor(gameTime / 3600)
            local mins = math.floor((gameTime % 3600) / 60)
            local secs = gameTime % 60
            TimeLabel.Text = string.format("%02d:%02d:%02d", hours, mins, secs)
        end
    end)
end)

-- ================= Главное меню (Уменьшено на 40%) ================= --
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Parent = GxiUI
MainFrame.BackgroundColor3 = blackColor
MainFrame.BackgroundTransparency = 0.15
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -135)
MainFrame.Size = UDim2.new(0, 420, 0, 270)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.GroupTransparency = 1 

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = sakuraColor
MainStroke.Thickness = 1.5

-- Левая панель вкладок
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 90, 1, 0)
Sidebar.BackgroundColor3 = darkGray
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 3)

local SidebarPadding = Instance.new("UIPadding", Sidebar)
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)

-- Контейнер для секций
local SectionsContainer = Instance.new("Frame", MainFrame)
SectionsContainer.Size = UDim2.new(1, -98, 1, -12)
SectionsContainer.Position = UDim2.new(0, 98, 0, 6)
SectionsContainer.BackgroundTransparency = 1

local tabs = {}
local function CreateTabButton(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundColor3 = blackColor
    btn.BackgroundTransparency = 0.5
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = whiteColor
    btn.TextSize = 10
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local sectionFrame = Instance.new("ScrollingFrame", SectionsContainer)
    sectionFrame.Size = UDim2.new(1, 0, 1, 0)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.ScrollBarThickness = 2
    sectionFrame.ScrollBarImageColor3 = sakuraColor
    sectionFrame.Visible = false
    
    local list = Instance.new("UIListLayout", sectionFrame)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    
    table.insert(tabs, {Button = btn, Frame = sectionFrame})
    
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            if tab.Button == btn then
                TweenService:Create(tab.Button, TweenInfo.new(0.3), {TextColor3 = sakuraColor}):Play()
                tab.Frame.Visible = true
                for _, element in pairs(tab.Frame:GetChildren()) do
                    if element:IsA("Frame") then
                        element.BackgroundTransparency = 1
                        TweenService:Create(element, TweenInfo.new(0.4), {BackgroundTransparency = 0.5}):Play()
                    end
                end
            else
                TweenService:Create(tab.Button, TweenInfo.new(0.3), {TextColor3 = whiteColor}):Play()
                tab.Frame.Visible = false
            end
        end
    end)
    return sectionFrame
end

-- ================= Элементы управления ================= --
local function CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -6, 0, 24)
    frame.BackgroundColor3 = darkGray
    frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = whiteColor
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 26, 0, 13)
    toggleBtn.Position = UDim2.new(1, -30, 0.5, -6)
    toggleBtn.BackgroundColor3 = blackColor
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 9, 0, 9)
    circle.Position = UDim2.new(0, 2, 0.5, -4)
    circle.BackgroundColor3 = whiteColor
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        local goalColor = state and sakuraColor or blackColor
        local goalPos = state and UDim2.new(1, -11, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
        TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = goalColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3), {Position = goalPos}):Play()
        if callback then
            callback(state)
        end
    end)
end

local function CreateSlider(parent, text, min, max, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -6, 0, 34)
    frame.BackgroundColor3 = darkGray
    frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local defaultValue = math.floor(min + (max - min) * 0.5)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -12, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. " [" .. defaultValue .. "]"
    label.Font = Enum.Font.Gotham
    label.TextColor3 = whiteColor
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("TextButton", frame)
    sliderBg.Size = UDim2.new(1, -16, 0, 4)
    sliderBg.Position = UDim2.new(0, 8, 0, 22)
    sliderBg.BackgroundColor3 = blackColor
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = sakuraColor
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function update(input)
        local pos = input.Position.X
        local bgPos = sliderBg.AbsolutePosition.X
        local bgWidth = sliderBg.AbsoluteSize.X
        local percent = math.clamp((pos - bgPos) / bgWidth, 0, 1)
        local value = math.floor(min + (max - min) * percent)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        label.Text = text .. " [" .. value .. "]"
        if callback then
            callback(value)
        end
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

local function CreateDropdown(parent, text, options)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -6, 0, 38)
    frame.BackgroundColor3 = darkGray
    frame.BackgroundTransparency = 0.5
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -12, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = whiteColor
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btnLayout = Instance.new("Frame", frame)
    btnLayout.Size = UDim2.new(1, -16, 0, 16)
    btnLayout.Position = UDim2.new(0, 8, 0, 18)
    btnLayout.BackgroundTransparency = 1
    
    local list = Instance.new("UIListLayout", btnLayout)
    list.FillDirection = Enum.FillDirection.Horizontal
    list.Padding = UDim.new(0, 5)
    
    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton", btnLayout)
        btn.Size = UDim2.new(0, 52, 1, 0)
        btn.BackgroundColor3 = blackColor
        btn.Text = opt
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = whiteColor
        btn.TextSize = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        
        btn.MouseButton1Click:Connect(function()
            for _, child in ipairs(btnLayout:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = blackColor, TextColor3 = whiteColor}):Play()
                end
            end
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = sakuraColor, TextColor3 = blackColor}):Play()
        end)
    end
end

-- ================= Наполнение секций ================= --
local RageTab = CreateTabButton("RAGE")
CreateToggle(RageTab, "Aim")
CreateToggle(RageTab, "Silent aim")
CreateDropdown(RageTab, "Silent aim", {"HumanoidRootPart", "Torso", "Head"})
CreateToggle(RageTab, "AimBot")
CreateDropdown(RageTab, "AimBot", {"Torso", "Head"})
CreateToggle(RageTab, "Fov")
CreateSlider(RageTab, "Fov size", 10, 700)

local VisualsTab = CreateTabButton("VISUALS")
CreateToggle(VisualsTab, "esp")
CreateToggle(VisualsTab, "esp skeleton")
CreateToggle(VisualsTab, "esp health")
CreateToggle(VisualsTab, "esp nickname")
CreateToggle(VisualsTab, "chams")

local MiscTab = CreateTabButton("MISC")
CreateToggle(MiscTab, "custom cursor", function(state)
    if _G.ToggleCustomCursor then
        _G.ToggleCustomCursor(state)
    end
end)
CreateDropdown(MiscTab, "custom skybox", {"nebula", "sakura"})
CreateToggle(MiscTab, "Fake headless", function(state)
    if _G.ToggleFakeHeadless then
        _G.ToggleFakeHeadless(state)
    end
end)

local AntiAimTab = CreateTabButton("ANTI AIM")
CreateToggle(AntiAimTab, "anti aim", function(state)
    if _G.ToggleAntiAim then
        _G.ToggleAntiAim(state)
    end
end)
CreateSlider(AntiAimTab, "anti aim speed", 2, 5, function(val)
    if _G.SetAntiAimSpeed then
        _G.SetAntiAimSpeed(val)
    end
end)

tabs[1].Button.TextColor3 = sakuraColor
tabs[1].Frame.Visible = true

-- ================= Анимация открытия/закрытия по клику на Gxi.cc ================= --
TitleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if MainFrame.GroupTransparency >= 0.9 or not MainFrame.Visible then
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        else
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1})
            tween:Play()
            tween.Completed:Connect(function()
                if MainFrame.GroupTransparency == 1 then 
                    MainFrame.Visible = false 
                end
            end)
        end
    end
end)

-- ================= Загрузочный экран ================= --
local LoadScreen = Instance.new("Frame", GxiUI)
LoadScreen.Size = UDim2.new(0, 100, 0, 100)
LoadScreen.Position = UDim2.new(0.5, -50, 0.5, -50)
LoadScreen.BackgroundColor3 = blackColor
LoadScreen.BackgroundTransparency = 1

local LoadCorner = Instance.new("UICorner", LoadScreen)
LoadCorner.CornerRadius = UDim.new(0, 8)

local LoadText1 = Instance.new("TextLabel", LoadScreen)
LoadText1.Size = UDim2.new(0.6, 0, 1, 0)
LoadText1.BackgroundTransparency = 1
LoadText1.Font = Enum.Font.GothamBold
LoadText1.Text = "Gxi."
LoadText1.TextColor3 = sakuraColor
LoadText1.TextSize = 20
LoadText1.TextXAlignment = Enum.TextXAlignment.Right
LoadText1.TextTransparency = 1

local LoadText2 = Instance.new("TextLabel", LoadScreen)
LoadText2.Size = UDim2.new(0.4, 0, 1, 0)
LoadText2.Position = UDim2.new(0.6, 0, 0.1, 0)
LoadText2.BackgroundTransparency = 1
LoadText2.Font = Enum.Font.GothamBold
LoadText2.Text = "cc"
LoadText2.TextColor3 = whiteColor
LoadText2.TextSize = 20
LoadText2.TextXAlignment = Enum.TextXAlignment.Left
LoadText2.TextTransparency = 1

task.spawn(function()
    TweenService:Create(LoadScreen, TweenInfo.new(0.5), {BackgroundTransparency = 0.15}):Play()
    task.wait(0.5)
    
    TweenService:Create(LoadText1, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(0.6)
    
    TweenService:Create(LoadText2, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        Position = UDim2.new(0.6, 0, 0, 0)
    }):Play()
    
    task.wait(0.6)
    task.wait(0.7)
    
    TweenService:Create(LoadScreen, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadText1, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(LoadText2, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4)
    LoadScreen:Destroy()
    
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
end)

--------------------------------------------------
-- MODULES
--------------------------------------------------

--------------------------------------------------
-- EVENTS
--------------------------------------------------


--------------------------------------------------
--RAGE
--------------------------------------------------

-- AIM

-- сюда код того что отвечает за работу всех aim


-- AIMBOT

-- сюда код AimBot


-- SILENT AIM

-- сюда код silent aim


-- FOV

-- сюда код fov


-- FOV SIZE

-- сюда код fov size


-- FOV MODE

-- сюда код fov mode


--------------------------------------------------
-- VISUALS
--------------------------------------------------

-- ESP

-- сюда код ESP


-- SKELETON

-- сюда код Skeleton


-- HEALTH BAR

-- сюда код Health Bar


--------------------------------------------------
-- MISC
--------------------------------------------------

-- CUSTOM CURSOR
_G.CustomCursorEnabled = false
local customCursorConn = nil

-- Создаем UI прицела
local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "GxiCrosshairGui"
CrosshairGui.Parent = CoreGui
CrosshairGui.Enabled = false
CrosshairGui.DisplayOrder = 9999

local CursorContainer = Instance.new("Frame", CrosshairGui)
CursorContainer.Name = "CursorContainer"
CursorContainer.Size = UDim2.new(0, 12, 0, 12)
CursorContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CursorContainer.BackgroundTransparency = 1

local function createCrossBar(size, position)
    local bar = Instance.new("Frame", CursorContainer)
    bar.Size = size
    bar.Position = position
    bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bar.BorderSizePixel = 0
    local corner = Instance.new("UICorner", bar)
    corner.CornerRadius = UDim.new(1, 0)
    return bar
end

-- Компактный маленький прицел
-- Верхняя плашка
createCrossBar(UDim2.new(0, 2, 0, 4), UDim2.new(0.5, -1, 0, 0))
-- Нижняя плашка
createCrossBar(UDim2.new(0, 2, 0, 4), UDim2.new(0.5, -1, 1, -4))
-- Левая плашка
createCrossBar(UDim2.new(0, 4, 0, 2), UDim2.new(0, 0, 0.5, -1))
-- Правая плашка
createCrossBar(UDim2.new(0, 4, 0, 2), UDim2.new(1, -4, 0.5, -1))

function _G.ToggleCustomCursor(state)
    _G.CustomCursorEnabled = state
    CrosshairGui.Enabled = state

    if customCursorConn then
        customCursorConn:Disconnect()
        customCursorConn = nil
    end

    if not state then return end

    customCursorConn = RunService.RenderStepped:Connect(function()
        if not _G.CustomCursorEnabled then return end

        local camera = workspace.CurrentCamera
        if not camera then return end
        local viewportSize = camera.ViewportSize

        local localPlayer = Players.LocalPlayer
        local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
        local foundDotPos = nil

        -- Поиск оригинальной зеленой точки UI Prison Life (GunGUI / Crosshair)
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Enabled then
                    local gName = gui.Name:lower()
                    if gName:find("gun") or gName:find("crosshair") or gName:find("weapon") then
                        for _, desc in ipairs(gui:GetDescendants()) do
                            if (desc:IsA("ImageLabel") or desc:IsA("Frame")) and desc.Visible then
                                local isGreen = false
                                if desc:IsA("ImageLabel") and desc.ImageColor3.G > 0.5 and desc.ImageColor3.R < 0.5 then
                                    isGreen = true
                                elseif desc:IsA("Frame") and desc.BackgroundColor3.G > 0.5 and desc.BackgroundColor3.R < 0.5 then
                                    isGreen = true
                                end

                                if isGreen or desc.Name:lower():find("dot") or desc.Name:lower():find("crosshair") then
                                    -- Скрываем зеленую точку визуально
                                    if desc:IsA("ImageLabel") then
                                        desc.ImageTransparency = 1
                                    else
                                        desc.BackgroundTransparency = 1
                                    end

                                    local absPos = desc.AbsolutePosition
                                    local absSize = desc.AbsoluteSize
                                    foundDotPos = Vector2.new(absPos.X + absSize.X / 2, absPos.Y + absSize.Y / 2 + 36)
                                end
                            end
                        end
                    end
                end
            end
        end

        if foundDotPos then
            -- Прицел встает ровно на место зеленой точки
            CursorContainer.Position = UDim2.new(0, foundDotPos.X, 0, foundDotPos.Y)
        else
            -- Без прицеливания/шифтлока: следование за касанием с исключением зон ходьбы и прыжка
            local mouseLoc = UserInputService:GetMouseLocation()

            -- Зона джойстика/ходьбы (левый нижний угол) и кнопка прыжка (правый нижний угол)
            local inWalkZone = (mouseLoc.X < viewportSize.X * 0.40) and (mouseLoc.Y > viewportSize.Y * 0.50)
            local inJumpZone = (mouseLoc.X > viewportSize.X * 0.70) and (mouseLoc.Y > viewportSize.Y * 0.55)

            if not (inWalkZone or inJumpZone) then
                CursorContainer.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
            end
        end
    end)
end


-- CUSTOM SKYBOX

-- сюда код Skybox


-- FAKE HEADLESS
local fakeHeadlessConnection = nil

local function applyHeadless(character)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if head then
        head.LocalTransparencyModifier = 1
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                child.Transparency = 1
            end
        end
    end
end

local function restoreHeadless(character)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if head then
        head.LocalTransparencyModifier = 0
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                child.Transparency = 0
            end
        end
    end
end

function _G.ToggleFakeHeadless(state)
    if fakeHeadlessConnection then
        fakeHeadlessConnection:Disconnect()
        fakeHeadlessConnection = nil
    end

    local char = Players.LocalPlayer and Players.LocalPlayer.Character
    if not state then
        restoreHeadless(char)
        return
    end

    fakeHeadlessConnection = RunService.RenderStepped:Connect(function()
        local character = Players.LocalPlayer and Players.LocalPlayer.Character
        if character then
            applyHeadless(character)
        end
    end)
end


--------------------------------------------------
-- ANTI AIM
--------------------------------------------------

-- ANTI AIM
local antiAimConnection = nil
_G.AntiAimEnabled = false
_G.AntiAimSpeed = 3.5

local spinAngle = 0
local jitterState = false

function _G.ToggleAntiAim(state)
    _G.AntiAimEnabled = state
    if antiAimConnection then
        antiAimConnection:Disconnect()
        antiAimConnection = nil
    end

    if not state then return end

    antiAimConnection = RunService.RenderStepped:Connect(function()
        local char = Players.LocalPlayer and Players.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid or humanoid.Health <= 0 then return end

        local speedMultiplier = _G.AntiAimSpeed or 3.5
        local isMoving = humanoid.MoveDirection.Magnitude > 0.1

        if not isMoving then
            -- Стоит на месте (на земле или в воздухе) -> Вращение вокруг оси
            spinAngle = (spinAngle + (speedMultiplier * 3)) % 360
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
        else
            -- Движется (на земле или в воздухе) -> Jitter Mode со взглядом назад
            jitterState = not jitterState
            local camera = workspace.CurrentCamera
            local camYaw = 0
            
            if camera then
                local _, yaw, _ = camera.CFrame:ToOrientation()
                camYaw = yaw
            else
                local _, yaw, _ = hrp.CFrame:ToOrientation()
                camYaw = yaw
            end

            -- Взгляд назад (180 градусов) + аккуратный джиттер влево/вправо в зависимости от ползунка скорости
            local jitterAngle = (jitterState and 1 or -1) * math.rad(8 + (speedMultiplier * 2))
            local finalYaw = camYaw + math.pi + jitterAngle

            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, finalYaw, 0)
        end
    end)
end

-- ANTI AIM SPEED
function _G.SetAntiAimSpeed(val)
    _G.AntiAimSpeed = val
end


--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------

--------------------------------------------------