--------------------------------------------------
-- SERVICES
--------------------------------------------------
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

--------------------------------------------------
-- VARIABLES
--------------------------------------------------
local SakuraColor = Color3.fromRGB(255, 183, 197)
local WhiteColor = Color3.fromRGB(255, 255, 255)
local BgColor = Color3.fromRGB(15, 15, 15)

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local Config = {
    Rage = { Aim = false, SilentAim = false, SilentAimTarget = "Head", AimBot = false, AimBotTarget = "Head", Fov = false, FovSize = 100 },
    Visuals = { ESP = false, Skeleton = false, Health = false, Nickname = false, Chams = false },
    Misc = { CustomCursor = false, CustomSkybox = false, SkyboxMode = "nebula", FakeHeadless = false },
    AntiAim = { AntiAim = false, AntiAimSpeed = 2 }
}

--------------------------------------------------
-- GUI
--------------------------------------------------
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Gxi_cc_GUI"
    ScreenGui.ResetOnSpawn = false
    
    local success = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- ================= LOADING SCREEN =================
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(0, 200, 0, 200)
    LoadingFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
    LoadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.ClipsDescendants = true
    LoadingFrame.Parent = ScreenGui

    local GxiText = Instance.new("TextLabel")
    GxiText.Text = "Gxi."
    GxiText.TextColor3 = SakuraColor
    GxiText.BackgroundTransparency = 1
    GxiText.Size = UDim2.new(0.5, 0, 1, 0)
    GxiText.Position = UDim2.new(0.1, 0, 0, 0)
    GxiText.Font = Enum.Font.GothamBold
    GxiText.TextSize = 40
    GxiText.TextTransparency = 1
    GxiText.Parent = LoadingFrame

    local ccText = Instance.new("TextLabel")
    ccText.Text = "cc"
    ccText.TextColor3 = WhiteColor
    ccText.BackgroundTransparency = 1
    ccText.Size = UDim2.new(0.5, 0, 1, 0)
    ccText.Position = UDim2.new(0.45, 0, 0.5, 0) -- Start lower
    ccText.Font = Enum.Font.GothamBold
    ccText.TextSize = 40
    ccText.TextTransparency = 1
    ccText.Parent = LoadingFrame

    -- ================= MAIN GUI =================
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = BgColor
    MainFrame.BackgroundTransparency = 1 -- Starts transparent
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = SakuraColor
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 1
    UIStroke.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -160, 1, -20)
    ContentArea.Position = UDim2.new(0, 160, 0, 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    -- Helper Functions for UI Elements
    local Pages = {}
    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = ContentArea
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = Page

        Pages[name] = Page
        return Page
    end

    local function CreateToggle(page, text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = "  " .. text
        btn.TextColor3 = WhiteColor
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = page
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = btn
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 10, 0, 10)
        indicator.Position = UDim2.new(1, -20, 0.5, -5)
        indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        indicator.Parent = btn
        
        local icorner = Instance.new("UICorner")
        icorner.CornerRadius = UDim.new(1, 0)
        icorner.Parent = indicator
        
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(indicator, TweenInfo.new(0.3), {BackgroundColor3 = state and SakuraColor or Color3.fromRGB(50, 50, 50)}):Play()
        end)
    end

    local function CreateSlider(page, text, min, max)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 50)
        container.BackgroundTransparency = 1
        container.Parent = page

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. " [" .. min .. " - " .. max .. "]"
        label.TextColor3 = WhiteColor
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 6)
        bar.Position = UDim2.new(0, 0, 0, 30)
        bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        bar.Parent = container

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0.5, 0, 1, 0)
        fill.BackgroundColor3 = SakuraColor
        fill.Parent = bar
    end

    local function CreateDropdown(page, text, options)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 30)
        label.BackgroundTransparency = 1
        label.Text = text .. " : " .. options[1] .. " / " .. options[2]
        label.TextColor3 = SakuraColor
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = page
    end

    -- Create Sections
    local RagePage = CreatePage("RAGE")
    CreateToggle(RagePage, "Aim")
    CreateToggle(RagePage, "Silent aim")
    CreateDropdown(RagePage, "Target", {"Torso", "Head"})
    CreateToggle(RagePage, "AimBot")
    CreateDropdown(RagePage, "AimBot Target", {"Torso", "Head"})
    CreateToggle(RagePage, "Fov")
    CreateSlider(RagePage, "Fov size", 10, 700)

    local VisualsPage = CreatePage("VISUALS")
    CreateToggle(VisualsPage, "esp")
    CreateToggle(VisualsPage, "esp skeleton")
    CreateToggle(VisualsPage, "esp health")
    CreateToggle(VisualsPage, "esp nickname")
    CreateToggle(VisualsPage, "chams")

    local MiscPage = CreatePage("MISC")
    CreateToggle(MiscPage, "custom cursor")
    CreateToggle(MiscPage, "custom skybox")
    CreateDropdown(MiscPage, "Skybox Mode", {"nebula", "sakura"})
    CreateToggle(MiscPage, "Fake headless")

    local AntiAimPage = CreatePage("ANTI AIM")
    CreateToggle(AntiAimPage, "anti aim")
    CreateSlider(AntiAimPage, "anti aim speed", 2, 5)

    -- Sidebar Buttons
    local function CreateTabButton(name, posY)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, posY)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = WhiteColor
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = Sidebar

        btn.MouseButton1Click:Connect(function()
            for pageName, pageFrame in pairs(Pages) do
                pageFrame.Visible = (pageName == name)
            end
        end)
    end

    CreateTabButton("RAGE", 20)
    CreateTabButton("VISUALS", 60)
    CreateTabButton("MISC", 100)
    CreateTabButton("ANTI AIM", 140)

    Pages["RAGE"].Visible = true

    -- ================= ANIMATIONS =================
    task.spawn(function()
        -- Gxi. Fade in
        TweenService:Create(GxiText, TweenInfo.new(1), {TextTransparency = 0}):Play()
        task.wait(0.5)
        
        -- cc Slide up & Fade in
        TweenService:Create(ccText, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.45, 0, 0, 0),
            TextTransparency = 0
        }):Play()
        
        task.wait(1.5) -- wait for full loading text presentation
        
        -- Loading screen fade out
        local fadeOut = TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        TweenService:Create(GxiText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(ccText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        fadeOut:Play()
        fadeOut.Completed:Wait()
        LoadingFrame:Destroy()
        
        task.wait(0.7) -- Expected 0.7 second delay
        
        -- Main GUI Fade In
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(1), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(Sidebar, TweenInfo.new(1), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(UIStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    end)
end

CreateUI()

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

-- сюда код Fake Headless


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