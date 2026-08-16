--[[
    Gxi Hitmarker - Universal
    Только хитмаркер + размер текста
]]

local scriptId = math.random(100000, 999999)
_G.GxiScriptId = scriptId

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Цвета
local sakura = Color3.fromRGB(255, 183, 197)
local sakuraHex = "#FFB7C5"
local white = Color3.fromRGB(230, 230, 230)
local black = Color3.fromRGB(12, 12, 12)
local panel = Color3.fromRGB(18, 18, 18)
local dark = Color3.fromRGB(22, 22, 22)
local stroke = Color3.fromRGB(38, 38, 38)
local muted = Color3.fromRGB(140, 140, 140)

-- Конфиг
local Config = {
    Hitmarker = true,
    TextSize = 18
}

-- ====================== UI ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GxiHitmarker"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Watermark
local Watermark = Instance.new("Frame")
Watermark.AutomaticSize = Enum.AutomaticSize.XY
Watermark.Position = UDim2.new(0, 12, 0, 12)
Watermark.BackgroundColor3 = panel
Watermark.Parent = ScreenGui

Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 5)
local ws = Instance.new("UIStroke", Watermark)
ws.Color = sakura
ws.Thickness = 1.2

local WatermarkBtn = Instance.new("TextButton")
WatermarkBtn.BackgroundTransparency = 1
WatermarkBtn.AutomaticSize = Enum.AutomaticSize.XY
WatermarkBtn.Font = Enum.Font.Code
WatermarkBtn.TextSize = 13
WatermarkBtn.RichText = true
WatermarkBtn.Text = string.format('<font color="%s">Gxi.</font><font color="#FFFFFF">cc | Hitmarker</font>', sakuraHex)
WatermarkBtn.Parent = Watermark

local pad = Instance.new("UIPadding", Watermark)
pad.PaddingTop = UDim.new(0, 7)
pad.PaddingBottom = UDim.new(0, 7)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)

-- Main Window (меньше, т.к. мало функций)
local Main = Instance.new("CanvasGroup")
Main.Size = UDim2.new(0, 280, 0, 160)
Main.Position = UDim2.new(0.5, -140, 0.5, -80)
Main.BackgroundColor3 = black
Main.GroupTransparency = 1
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 7)
local ms = Instance.new("UIStroke", Main)
ms.Color = stroke
ms.Thickness = 1.5

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -16)
Content.Position = UDim2.new(0, 8, 0, 8)
Content.BackgroundTransparency = 1
Content.Parent = Main

local list = Instance.new("UIListLayout", Content)
list.Padding = UDim.new(0, 8)
list.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", Content)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)

-- Открытие меню
WatermarkBtn.MouseButton1Click:Connect(function()
    if Main.GroupTransparency > 0.5 then
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.22), {GroupTransparency = 0}):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.22), {GroupTransparency = 1})
        tw:Play()
        tw.Completed:Connect(function()
            if Main.GroupTransparency >= 0.99 then
                Main.Visible = false
            end
        end)
    end
end)

task.spawn(function()
    task.wait(0.4)
    Main.Visible = true
    TweenService:Create(Main, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
end)

-- UI элементы
local function Section(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text:lower()
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextColor3 = white
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
end

local function Toggle(parent, text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 18)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 14, 0, 14)
    box.Position = UDim2.new(0, 0, 0.5, -7)
    box.BackgroundColor3 = dark
    box.BorderSizePixel = 1
    box.BorderColor3 = stroke
    box.Text = ""
    box.Parent = f

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, -4, 1, -4)
    fill.Position = UDim2.new(0, 2, 0, 2)
    fill.BackgroundColor3 = sakura
    fill.Visible = default
    fill.Parent = box

    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1, -22, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text:lower()
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = default and white or muted
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local state = default
    local function switch()
        state = not state
        fill.Visible = state
        label.TextColor3 = state and white or muted
        if callback then callback(state) end
    end

    box.MouseButton1Click:Connect(switch)
    label.MouseButton1Click:Connect(switch)
end

local function Slider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = text:lower() .. ": " .. default
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextColor3 = muted
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, 0, 0, 7)
    bg.Position = UDim2.new(0, 0, 0, 18)
    bg.BackgroundColor3 = dark
    bg.BorderSizePixel = 1
    bg.BorderColor3 = stroke
    bg.Text = ""
    bg.Parent = f

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = sakura
    fill.Parent = bg

    local dragging = false

    local function update(input)
        local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        label.Text = text:lower() .. ": " .. val
        if callback then callback(val) end
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    bg.InputEnded:Connect(function(input)
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

-- ====================== Контент GUI ======================
Section(Content, "Hitmarker")
Toggle(Content, "Enabled", true, function(v) Config.Hitmarker = v end)
Slider(Content, "Text Size", 12, 36, 18, function(v) Config.TextSize = v end)

-- ====================== HITMARKER LOGIC ======================

local lastAttackTime = 0
local lastHitPart = nil
local ATTACK_WINDOW = 0.45 -- секунды, в течение которых считаем урон "нашим"

-- Отмечаем атаку (инструмент / клик)
local function markAttack()
    lastAttackTime = tick()

    -- Пробуем узнать, во что попали (для headshot)
    local mouse = LocalPlayer:GetMouse()
    if mouse and mouse.Target then
        lastHitPart = mouse.Target
    else
        -- fallback raycast
        local origin = Camera.CFrame.Position
        local direction = Camera.CFrame.LookVector * 500
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
        local result = workspace:Raycast(origin, direction, params)
        if result then
            lastHitPart = result.Instance
        else
            lastHitPart = nil
        end
    end
end

-- Слушаем активацию инструментов
local function setupCharacter(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Activated:Connect(function()
                markAttack()
            end)
        end
    end)

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            child.Activated:Connect(function()
                markAttack()
            end)
        end
    end
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- Дополнительно: клик мыши / тач (на случай если Tool.Activated не срабатывает)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            markAttack()
        end
    end
end)

-- Создание хитмаркера
local function createHitmarker(position, damage, isHeadshot)
    if not Config.Hitmarker then return end
    if damage < 1 then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 200
    billboard.Adornee = nil

    -- Создаём невидимую часть-якорь рядом с целью
    local anchor = Instance.new("Part")
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.Transparency = 1
    anchor.Size = Vector3.new(0.1, 0.1, 0.1)
    anchor.Position = position + Vector3.new(math.random(-8, 8) / 10, 0, math.random(-8, 8) / 10)
    anchor.Parent = workspace
    billboard.Adornee = anchor
    billboard.Parent = anchor

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = tostring(math.floor(damage + 0.5))
    label.Font = Enum.Font.GothamBold -- дефолтный роблокс-шрифт
    label.TextSize = Config.TextSize
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0) -- чёрный outline
    label.TextColor3 = isHeadshot and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    label.Parent = billboard

    -- Анимация: поднимается вверх и исчезает
    local startPos = anchor.Position
    local endPos = startPos + Vector3.new(0, 2.5, 0)
    local startTime = tick()
    local duration = 0.85

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if _G.GxiScriptId ~= scriptId then
            conn:Disconnect()
            anchor:Destroy()
            return
        end

        local alpha = (tick() - startTime) / duration
        if alpha >= 1 then
            conn:Disconnect()
            anchor:Destroy()
            return
        end

        anchor.Position = startPos:Lerp(endPos, alpha)
        label.TextTransparency = alpha * 0.9
        label.TextStrokeTransparency = alpha * 0.9
    end)
end

-- Отслеживание урона по всем Humanoid
local healthCache = {}

local function trackHumanoid(hum, char)
    if not hum or not hum:IsA("Humanoid") then return end
    if healthCache[hum] then return end

    healthCache[hum] = hum.Health

    hum.HealthChanged:Connect(function(newHealth)
        if _G.GxiScriptId ~= scriptId then return end
        if not Config.Hitmarker then
            healthCache[hum] = newHealth
            return
        end

        local oldHealth = healthCache[hum] or newHealth
        local damage = oldHealth - newHealth
        healthCache[hum] = newHealth

        if damage <= 0 then return end
        if tick() - lastAttackTime > ATTACK_WINDOW then return end -- урон не наш

        -- Не показываем по себе
        if char == LocalPlayer.Character then return end

        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char.PrimaryPart
        if not root then return end

        -- Определяем headshot
        local isHeadshot = false
        if lastHitPart then
            local name = lastHitPart.Name:lower()
            if name == "head" or lastHitPart:FindFirstAncestorOfClass("Model") == char and (name:find("head") or lastHitPart.Parent and lastHitPart.Parent.Name:lower() == "head") then
                isHeadshot = true
            end
            -- более надёжная проверка
            if lastHitPart:IsDescendantOf(char) then
                local current = lastHitPart
                while current and current ~= char do
                    if current.Name:lower() == "head" then
                        isHeadshot = true
                        break
                    end
                    current = current.Parent
                end
            end
        end

        createHitmarker(root.Position, damage, isHeadshot)
    end)

    hum.Destroying:Connect(function()
        healthCache[hum] = nil
    end)
end

-- Подключаем всех игроков + NPC
local function onCharacterAdded(char)
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if hum then
        trackHumanoid(hum, char)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        onCharacterAdded(plr.Character)
    end
    plr.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(onCharacterAdded)
end)

-- NPC / другие модели с Humanoid (универсальность)
workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Humanoid") then
        local char = desc.Parent
        if char and char:IsA("Model") and char ~= LocalPlayer.Character then
            trackHumanoid(desc, char)
        end
    end
end)

-- Уже существующие Humanoid в мире
for _, desc in ipairs(workspace:GetDescendants()) do
    if desc:IsA("Humanoid") then
        local char = desc.Parent
        if char and char:IsA("Model") and char ~= LocalPlayer.Character then
            trackHumanoid(desc, char)
        end
    end
end

print("[Gxi] Hitmarker loaded")
