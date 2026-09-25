-- ==============================================================================
--  PXZD HUB IN TOP | PREMIUM SELECTOR & SYSTEM CONTROL
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- LISTA DE USUARIOS PREMIUM (EN MINÚSCULAS PARA EVITAR ERRORES)
local PremiumUsers = {
    ["carbius123"] = true,
    ["bacon_pro8879"] = true,
    ["g_07n1"] = true,
    ["zzzzzer11"] = true
}

-- VERIFICAR USUARIO (Ignora mayúsculas/minúsculas)
local isPremium = PremiumUsers[string.lower(LocalPlayer.Name)]

if isPremium then
    
    -- ==================== BADGE PREMIUM CON CORONA Y ARCOÍRIS ====================
    if CoreGui:FindFirstChild("PxzdPremiumBadge") then
        CoreGui.PxzdPremiumBadge:Destroy()
    end

    local BadgeGui = Instance.new("ScreenGui")
    BadgeGui.Name = "PxzdPremiumBadge"
    BadgeGui.ResetOnSpawn = false
    BadgeGui.Parent = CoreGui

    local BadgeFrame = Instance.new("Frame")
    BadgeFrame.Name = "BadgeFrame"
    BadgeFrame.Size = UDim2.new(0, 200, 0, 32)
    BadgeFrame.Position = UDim2.new(0.5, -100, 0, 10)
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 24)
    BadgeFrame.BorderSizePixel = 0
    BadgeFrame.Parent = BadgeGui

    Instance.new("UICorner", BadgeFrame).CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Parent = BadgeFrame

    local CrownLabel = Instance.new("TextLabel")
    CrownLabel.Size = UDim2.new(0, 30, 1, 0)
    CrownLabel.Position = UDim2.new(0, 5, 0, 0)
    CrownLabel.BackgroundTransparency = 1
    CrownLabel.Text = "👑"
    CrownLabel.TextSize = 16
    CrownLabel.Parent = BadgeFrame

    local PremiumText = Instance.new("TextLabel")
    PremiumText.Size = UDim2.new(1, -40, 1, 0)
    PremiumText.Position = UDim2.new(0, 35, 0, 0)
    PremiumText.BackgroundTransparency = 1
    PremiumText.Text = "PREMIUM USER"
    PremiumText.Font = Enum.Font.GothamBlack
    PremiumText.TextSize = 12
    PremiumText.TextXAlignment = Enum.TextXAlignment.Left
    PremiumText.Parent = BadgeFrame

    task.spawn(function()
        local hue = 0
        while BadgeGui and BadgeGui.Parent do
            hue = (hue + 1) % 360
            local rainbowColor = Color3.fromHSV(hue / 360, 0.8, 1)
            PremiumText.TextColor3 = rainbowColor
            Stroke.Color = rainbowColor
            RunService.RenderStepped:Wait()
        end
    end)

    -- ==================== INTERFAZ PREMIUM PXZD HUB ====================
    if CoreGui:FindFirstChild("PxzdHubMenu") then
        CoreGui.PxzdHubMenu:Destroy()
    end

    local MenuGui = Instance.new("ScreenGui")
    MenuGui.Name = "PxzdHubMenu"
    MenuGui.ResetOnSpawn = false
    MenuGui.Parent = CoreGui

    local MainMenu = Instance.new("Frame")
    MainMenu.Name = "MainFrame"
    MainMenu.Size = UDim2.new(0, 380, 0, 290)
    MainMenu.Position = UDim2.new(0.5, -190, 0.5, -145)
    MainMenu.BackgroundColor3 = Color3.fromRGB(15, 10, 24)
    MainMenu.BorderSizePixel = 0
    MainMenu.ClipsDescendants = true
    MainMenu.Parent = MenuGui

    Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(168, 45, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainMenu

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 0, 40)
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "PXZD HUB IN TOP ⚡"
    TitleLabel.TextColor3 = Color3.fromRGB(168, 45, 255)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = MainMenu

    local CloseMenuBtn = Instance.new("TextButton")
    CloseMenuBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseMenuBtn.Position = UDim2.new(1, -32, 0, 10)
    CloseMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
    CloseMenuBtn.Text = "X"
    CloseMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseMenuBtn.Font = Enum.Font.GothamBold
    CloseMenuBtn.TextSize = 12
    CloseMenuBtn.Parent = MainMenu
    Instance.new("UICorner", CloseMenuBtn).CornerRadius = UDim.new(0, 6)

    CloseMenuBtn.MouseButton1Click:Connect(function()
        MenuGui:Destroy()
    end)

    -- Contenedor con Scroll para los botones
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(168, 45, 255)
    ScrollFrame.Parent = MainMenu

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 10)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Parent = ScrollFrame

    -- Función para crear botones con diseño Verde y Morado
    local function CreateScriptRow(name, scriptUrl)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -10, 0, 45)
        Row.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
        Row.Parent = ScrollFrame
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

        local RowStroke = Instance.new("UIStroke")
        RowStroke.Color = Color3.fromRGB(100, 30, 160)
        RowStroke.Thickness = 1
        RowStroke.Parent = Row

        local NameText = Instance.new("TextLabel")
        NameText.Size = UDim2.new(0.65, -10, 1, 0)
        NameText.Position = UDim2.new(0, 12, 0, 0)
        NameText.BackgroundTransparency = 1
        NameText.Text = name
        NameText.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameText.Font = Enum.Font.GothamBold
        NameText.TextSize = 12
        NameText.TextXAlignment = Enum.TextXAlignment.Left
        NameText.Parent = Row

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0.3, -5, 0, 28)
        ExecBtn.Position = UDim2.new(0.7, 0, 0.5, -14)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        ExecBtn.Text = "Execute"
        ExecBtn.TextColor3 = Color3.fromRGB(10, 25, 15)
        ExecBtn.Font = Enum.Font.GothamBlack
        ExecBtn.TextSize = 11
        ExecBtn.Parent = Row
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)

        ExecBtn.MouseButton1Click:Connect(function()
            ExecBtn.Text = "Cargando..."
            ExecBtn.BackgroundColor3 = Color3.fromRGB(168, 45, 255)
            ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            task.spawn(function()
                pcall(function()
                    loadstring(game:HttpGet(scriptUrl))()
                end)
                task.wait(1)
                ExecBtn.Text = "Ejecutado!"
                ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
                ExecBtn.TextColor3 = Color3.fromRGB(10, 25, 15)
            end)
        end)
    end

    -- CREACIÓN DE LOS SCRIPTS SOLICITADOS
    CreateScriptRow("Afk Lennon Premium", "https://raw.githubusercontent.com/lennonxscripts/lennonfarm/refs/heads/main/farmv1.lua")
    CreateScriptRow("Miranda Farm", "https://api.luarmor.net/files/v4/loaders/6b07a458832f08b2314f706f14723212.lua")
    CreateScriptRow("Server Premium 🤑", "https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua")
    CreateScriptRow("Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 15)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ PXZD HUB ⚡",
            Text = "¡Bienvenido " .. LocalPlayer.Name .. "! Menú cargado.",
            Duration = 4
        })
    end)

else

    -- ==============================================================================
    --  PANTALLA DE MANTENIMIENTO / ACCESO RESTRINGIDO (PARA NO PREMIUMS)
    -- ==============================================================================
    local LOGO_ID = "rbxassetid://108485396062507"
    local AUDIO_ID = "rbxassetid://128999238382127"

    if CoreGui:FindFirstChild("PxzdHubCore") then
        CoreGui.PxzdHubCore:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PxzdHubCore"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local bgMusic

    task.spawn(function()
        pcall(function()
            local oldSound = SoundService:FindFirstChild("PxzdUpdateMusic")
            if oldSound then oldSound:Destroy() end

            bgMusic = Instance.new("Sound")
            bgMusic.Name = "PxzdUpdateMusic"
            bgMusic.SoundId = AUDIO_ID
            bgMusic.Volume = 0.25
            bgMusic.Looped = true
            bgMusic.TimePosition = 0
            bgMusic.Parent = SoundService

            ContentProvider:PreloadAsync({bgMusic})
            bgMusic:Play()
        end)
    end)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "UpdateFrame"
    MainFrame.Size = UDim2.new(0, 360, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(168, 45, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 80, 0, 80)
    LogoFrame.Position = UDim2.new(0.5, -40, 0.1, 0)
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.Parent = MainFrame

    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(1, 0, 1, 0)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = LOGO_ID
    LogoImage.Parent = LogoFrame
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Position = UDim2.new(0, 0, 0.52, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "PXZD HUB IN TOP"
    Title.TextColor3 = Color3.fromRGB(168, 45, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    TitleLabel.Position = UDim2.new(0, 0, 0.65, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "⚡ ESTADO: EN ACTUALIZACIÓN ⚡"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    TitleLabel.TextSize = 11
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = MainFrame

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -40, 0, 30)
    Description.Position = UDim2.new(0, 20, 0.78, 0)
    Description.BackgroundTransparency = 1
    Description.Text = "GG tranquilo está en actualización"
    Description.TextColor3 = Color3.fromRGB(200, 200, 210)
    Description.TextSize = 10
    Description.Font = Enum.Font.GothamSemibold
    Description.TextWrapped = true
    Description.Parent = MainFrame

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -28, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 10
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = MainFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    local closing = false
    CloseBtn.MouseButton1Click:Connect(function()
        if closing then return end
        closing = true
        if bgMusic then
            TweenService:Create(bgMusic, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Volume = 0}):Play()
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
            task.wait(1.2)
            bgMusic:Stop()
            bgMusic:Destroy()
        end
        ScreenGui:Destroy()
    end)
end
