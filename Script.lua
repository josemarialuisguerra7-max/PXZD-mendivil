-- ==============================================================================
--  PXZD HUB IN TOP | PREMIUM WHITELIST & SYSTEM CONTROL
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- LISTA DE USUARIOS PREMIUM
local PremiumUsers = {
    ["Carbius123"] = true,
    ["Bacon_pro8879"] = true,
    ["g_07n1"] = true,
    ["zzzzzer11"] = true
}

-- VERIFICAR SI EL JUGADOR ES PREMIUM
if PremiumUsers[LocalPlayer.Name] then
    
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
    BadgeFrame.Size = UDim2.new(0, 220, 0, 36)
    BadgeFrame.Position = UDim2.new(0.5, -110, 0, 15)
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 24)
    BadgeFrame.BorderSizePixel = 0
    BadgeFrame.Parent = BadgeGui

    Instance.new("UICorner", BadgeFrame).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Parent = BadgeFrame

    local CrownLabel = Instance.new("TextLabel")
    CrownLabel.Size = UDim2.new(0, 30, 1, 0)
    CrownLabel.Position = UDim2.new(0, 10, 0, 0)
    CrownLabel.BackgroundTransparency = 1
    CrownLabel.Text = "👑"
    CrownLabel.TextSize = 18
    CrownLabel.Parent = BadgeFrame

    local PremiumText = Instance.new("TextLabel")
    PremiumText.Size = UDim2.new(1, -45, 1, 0)
    PremiumText.Position = UDim2.new(0, 40, 0, 0)
    PremiumText.BackgroundTransparency = 1
    PremiumText.Text = "PREMIUM USER"
    PremiumText.Font = Enum.Font.GothamBlack
    PremiumText.TextSize = 14
    PremiumText.TextXAlignment = Enum.TextXAlignment.Left
    PremiumText.Parent = BadgeFrame

    -- Animación Arcoíris (Rainbow effect)
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

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ PXZD HUB PREMIUM ⚡",
            Text = "¡Bienvenido, " .. LocalPlayer.Name .. "! Cargando scripts Premium...",
            Duration = 5
        })
    end)

    -- ==============================================================================
    --  CARGA DE SCRIPTS PREMIUM AUTORIZADOS
    -- ==============================================================================
    
    -- 1. Afk Lennon premium
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/lennonxscripts/lennonfarm/refs/heads/main/farmv1.lua"))()
        end)
    end)

    -- 2. Miranda farm
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/6b07a458832f08b2314f706f14723212.lua"))()
        end)
    end)

    -- 3. Server premium🤑
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua"))()
        end)
    end)

    -- 4. Chilli hub actualizadacho
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
        end)
    end)
    
    print("[PXZD HUB]: Scripts Premium ejecutados con éxito para -> " .. LocalPlayer.Name)

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

    -- Reproducción de música con reintentos
    task.spawn(function()
        pcall(function()
            local oldSound = SoundService:FindFirstChild("PxzdUpdateMusic")
            if oldSound then
                oldSound:Destroy()
            end

            bgMusic = Instance.new("Sound")
            bgMusic.Name = "PxzdUpdateMusic"
            bgMusic.SoundId = AUDIO_ID
            bgMusic.Volume = 0.25
            bgMusic.Looped = true
            bgMusic.TimePosition = 0
            bgMusic.Parent = SoundService

            ContentProvider:PreloadAsync({bgMusic})
            bgMusic:Play()

            task.spawn(function()
                for i = 1, 5 do
                    if bgMusic and not bgMusic.IsPlaying then
                        bgMusic:Play()
                        task.wait(0.5)
                    else
                        break
                    end
                end
            end)
        end)
    end)

    -- Interfaz Principal de Mantenimiento
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

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 15, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 20))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = MainFrame

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

    task.spawn(function()
        while MainFrame and MainFrame.Parent do
            TweenService:Create(LogoImage, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1.08, 0, 1.08, 0), Position = UDim2.new(-0.04, 0, -0.04, 0)}):Play()
            task.wait(1.2)
            TweenService:Create(LogoImage, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(1.2)
        end
    end)

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
