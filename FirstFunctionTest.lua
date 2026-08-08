--------------------------------------------------
-- SERVICES
--------------------------------------------------
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
local Watermark = Instance.new("TextButton")
Watermark.Name = "Watermark"
Watermark.Parent = GxiUI
Watermark.BackgroundColor3 = blackColor
Watermark.BackgroundTransparency = 0.2
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.Size = UDim2.new(0, 70, 0, 20)
Watermark.Font = Enum.Font.GothamBold
Watermark.Text = ""
Watermark.AutoButtonColor = false

local WatermarkCorner = Instance.new("UICorner", Watermark)
WatermarkCorner.CornerRadius = UDim.new(0, 4)

local WatermarkStroke = Instance.new("UIStroke", Watermark)
WatermarkStroke.Color = sakuraColor
WatermarkStroke.Thickness = 1

local WatermarkText1 = Instance.new("TextLabel", Watermark)
WatermarkText1.BackgroundTransparency = 1
WatermarkText1.Size = UDim2.new(0.6, 0, 1, 0)
WatermarkText1.Font = Enum.Font.GothamBold
WatermarkText1.Text = "Gxi."
WatermarkText1.TextColor3 = sakuraColor
WatermarkText1.TextSize = 11
WatermarkText1.TextXAlignment = Enum.TextXAlignment.Right

local WatermarkText2 = Instance.new("TextLabel", Watermark)
WatermarkText2.BackgroundTransparency = 1
WatermarkText2.Position = UDim2.new(0.6, 0, 0, 0)
WatermarkText2.Size = UDim2.new(0.4, 0, 1, 0)
WatermarkText2.Font = Enum.Font.GothamBold
WatermarkText2.Text = "cc"
WatermarkText2.TextColor3 = whiteColor
WatermarkText2.TextSize = 11
WatermarkText2.TextXAlignment = Enum.TextXAlignment.Left

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

local function CreateSlider(parent, text, min, max)
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
CreateToggle(MiscTab, "custom cursor")
CreateDropdown(MiscTab, "custom skybox", {"nebula", "sakura"})
CreateToggle(MiscTab, "Fake headless", function(state)
    if _G.ToggleFakeHeadless then
        _G.ToggleFakeHeadless(state)
    end
end)

local AntiAimTab = CreateTabButton("ANTI AIM")
CreateToggle(AntiAimTab, "anti aim")
CreateSlider(AntiAimTab, "anti aim speed", 2, 5)

tabs[1].Button.TextColor3 = sakuraColor
tabs[1].Frame.Visible = true

-- ================= Анимация открытия/закрытия ================= --
Watermark.Active = true
Watermark.InputBegan:Connect(function(input)
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

-- сюда код Cursor


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

-- сюда код anti aim


-- ANTI AIM SPEED

-- сюда код anti aim speed


--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------

--------------------------------------------------