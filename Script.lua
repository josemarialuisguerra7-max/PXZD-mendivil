-- ==============================================================================
--  PXZD HUB IN TOP | ULTIMATE CINEMATIC INTRO & PREMIUM HUB
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- LISTA DE USUARIOS PREMIUM (EN MINÚSCULAS)
local PremiumUsers = {
    ["carbius123"] = true,
    ["bacon_pro8879"] = true,
    ["g_07n1"] = true,
    ["zzzzzer11"] = true,
    ["elalfa_3677"] = true
}

local LOGO_ID = "rbxassetid://108485396062507"
local INTRO_AUDIO_ID = "rbxassetid://108721795687965"

-- ==================== FUNCIÓN HACER MARCO ARRASTRABLE ====================
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ==================== MODO PAPA / OPTIMIZACIÓN ====================
local function EnablePotatoMode()
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end

        local function HideCharacter(char)
            if char and char ~= LocalPlayer.Character then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 1
                    end
                end
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character then HideCharacter(player.Character) end
                player.CharacterAdded:Connect(HideCharacter)
            end
        end

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
                effect.Enabled = false
            end
        end
    end)
end

-- ==================== SISTEMA DE PARTÍCULAS ====================
local function SpawnParticle(parent)
    if not parent or not parent.Parent then return end

    local particle = Instance.new("ImageLabel")
    particle.Name = "PxzdParticle"
    particle.Size = UDim2.new(0, math.random(12, 24), 0, math.random(12, 24))
    particle.Position = UDim2.new(math.random(), 0, 1, 0)
    particle.BackgroundTransparency = 1
    particle.Image = LOGO_ID
    particle.ImageTransparency = math.random(3, 6) / 10
    particle.ZIndex = 15
    particle.Parent = parent

    Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)

    local endX = particle.Position.X.Scale + (math.random(-20, 20) / 100)
    local tweenDuration = math.random(15, 25) / 10

    local tween = TweenService:Create(particle, TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(endX, 0, -0.1, 0),
        ImageTransparency = 1,
        Rotation = math.random(-180, 180)
    })

    tween:Play()
    tween.Completed:Connect(function()
        particle:Destroy()
    end)
end

-- ==================== INTRO CINEMÁTICA Y ANIMADA ====================
local function PlayCustomIntro(onComplete)
    -- Blur Background
    local oldBlur = Lighting:FindFirstChild("PxzdIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "PxzdIntroBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting

    TweenService:Create(blurEffect, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 28
    }):Play()

    -- Audio Player (Inicia en segundo 24 con volumen a 0.25)
    local oldSound = SoundService:FindFirstChild("PxzdIntroMusic")
    if oldSound then oldSound:Destroy() end

    local introSound = Instance.new("Sound")
    introSound.Name = "PxzdIntroMusic"
    introSound.SoundId = INTRO_AUDIO_ID
    introSound.Volume = 0.25 -- Volumen ajustado a 0.25
    introSound.Looped = false
    introSound.TimePosition = 24
    introSound.Parent = SoundService

    task.spawn(function()
        pcall(function()
            ContentProvider:PreloadAsync({introSound})
            introSound:Play()
        end)
    end)

    -- GUI Base
    if CoreGui:FindFirstChild("PxzdIntroGui") then CoreGui.PxzdIntroGui:Destroy() end

    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "PxzdIntroGui"
    IntroGui.ResetOnSpawn = false
    IntroGui.IgnoreGuiInset = true
    IntroGui.Parent = CoreGui

    -- Background Overlay
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(8, 5, 14)
    Background.BackgroundTransparency = 0.25
    Background.Parent = IntroGui

    -- Main Container
    local CenterFrame = Instance.new("Frame")
    CenterFrame.Size = UDim2.new(0, 420, 0, 320)
    CenterFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    CenterFrame.BackgroundTransparency = 1
    CenterFrame.Parent = IntroGui

    -- Logo Frame
    local LogoHolder = Instance.new("Frame")
    LogoHolder.Size = UDim2.new(0, 110, 0, 110)
    LogoHolder.Position = UDim2.new(0.5, -55, 0.15, 0)
    LogoHolder.BackgroundTransparency = 1
    LogoHolder.Parent = CenterFrame

    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(1, 0, 1, 0)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = LOGO_ID
    LogoImage.ImageTransparency = 1
    LogoImage.Parent = LogoHolder
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = Color3.fromRGB(0, 255, 128)
    LogoStroke.Thickness = 3.5
    LogoStroke.Transparency = 1
    LogoStroke.Parent = LogoImage

    -- Animación de Logo Entrada
    LogoHolder.Size = UDim2.new(0, 20, 0, 20)
    LogoHolder.Position = UDim2.new(0.5, -10, 0.25, 0)

    TweenService:Create(LogoHolder, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 110, 0, 110),
        Position = UDim2.new(0.5, -55, 0.12, 0)
    }):Play()
    TweenService:Create(LogoImage, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    TweenService:Create(LogoStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()

    -- Texto Principal "Chema in top"
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, 0, 0, 45)
    TitleText.Position = UDim2.new(0, 0, 0.52, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "👑 Chema in top 👑"
    TitleText.TextColor3 = Color3.fromRGB(0, 255, 128)
    TitleText.Font = Enum.Font.GothamBlack
    TitleText.TextSize = 28
    TitleText.TextTransparency = 1
    TitleText.Parent = CenterFrame

    local TextStroke = Instance.new("UIStroke")
    TextStroke.Thickness = 3
    TextStroke.Transparency = 1
    TextStroke.Parent = TitleText

    TweenService:Create(TitleText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(TextStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()

    -- Subtítulo PXZD HUB
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0.67, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "PXZD HUB IN TOP ⚡ LOADING..."
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    Subtitle.Font = Enum.Font.GothamBold
    Subtitle.TextSize = 13
    Subtitle.TextTransparency = 1
    Subtitle.Parent = CenterFrame

    TweenService:Create(Subtitle, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    -- Barra de Carga
    local BarBackground = Instance.new("Frame")
    BarBackground.Size = UDim2.new(0, 280, 0, 8)
    BarBackground.Position = UDim2.new(0.5, -140, 0.82, 0)
    BarBackground.BackgroundColor3 = Color3.fromRGB(25, 15, 38)
    BarBackground.BorderSizePixel = 0
    BarBackground.Parent = CenterFrame
    Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBackground
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 128)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 45, 255))
    })
    FillGradient.Parent = BarFill

    -- Bucles de Animaciones y Partículas
    local running = true

    task.spawn(function()
        while running and CenterFrame and CenterFrame.Parent do
            SpawnParticle(Background)
            task.wait(0.1)
        end
    end)

    task.spawn(function()
        local hue = 0
        while running and TitleText and TitleText.Parent do
            hue = (hue + 1) % 360
            local color = Color3.fromHSV(hue / 360, 0.85, 1)
            TextStroke.Color = color
            LogoStroke.Color = color
            RunService.RenderStepped:Wait()
        end
    end)

    -- Animación de Carga (Duración de 5 segundos)
    TweenService:Create(BarFill, TweenInfo.new(5.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()

    task.wait(5.2)

    -- Salida de Intro
    running = false

    TweenService:Create(TitleText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(TextStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    TweenService:Create(Subtitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(LogoImage, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(LogoStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    TweenService:Create(BarBackground, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Background, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(blurEffect, TweenInfo.new(0.6), {Size = 0}):Play()

    if introSound and introSound.IsPlaying then
        TweenService:Create(introSound, TweenInfo.new(0.6), {Volume = 0}):Play()
    end

    task.wait(0.6)

    if introSound then introSound:Destroy() end
    if blurEffect then blurEffect:Destroy() end
    if IntroGui then IntroGui:Destroy() end

    if onComplete then onComplete() end
end

-- ==================== INICIO DEL SCRIPT ====================
PlayCustomIntro(function()
    local isPremium = PremiumUsers[string.lower(LocalPlayer.Name)]

    if isPremium then
        -- BADGE SUPERIOR DE RANGO
        if CoreGui:FindFirstChild("PxzdPremiumBadge") then CoreGui.PxzdPremiumBadge:Destroy() end

        local isOwner = (string.lower(LocalPlayer.Name) == "carbius123")
        local badgeDuration = isOwner and 12 or 7

        local BadgeGui = Instance.new("ScreenGui")
        BadgeGui.Name = "PxzdPremiumBadge"
        BadgeGui.ResetOnSpawn = false
        BadgeGui.Parent = CoreGui

        local BadgeFrame = Instance.new("Frame")
        BadgeFrame.Name = "BadgeFrame"
        BadgeFrame.Size = UDim2.new(0, 190, 0, 36)
        BadgeFrame.Position = UDim2.new(0.5, -95, 0, 12)
        BadgeFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 24)
        BadgeFrame.BorderSizePixel = 0
        BadgeFrame.Parent = BadgeGui

        Instance.new("UICorner", BadgeFrame).CornerRadius = UDim.new(0, 10)

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 2
        Stroke.Parent = BadgeFrame

        local CrownLabel = Instance.new("TextLabel")
        CrownLabel.Size = UDim2.new(0, 32, 1, 0)
        CrownLabel.Position = UDim2.new(0, 6, 0, 0)
        CrownLabel.BackgroundTransparency = 1
        CrownLabel.Text = "👑"
        CrownLabel.TextSize = 18
        CrownLabel.Parent = BadgeFrame

        local PremiumText = Instance.new("TextLabel")
        PremiumText.Size = UDim2.new(1, -42, 1, 0)
        PremiumText.Position = UDim2.new(0, 38, 0, 0)
        PremiumText.BackgroundTransparency = 1
        PremiumText.Text = isOwner and "OWNER GG" or "VIP MEMBER"
        PremiumText.Font = Enum.Font.GothamBlack
        PremiumText.TextSize = 12
        PremiumText.TextXAlignment = Enum.TextXAlignment.Left
        PremiumText.Parent = BadgeFrame

        task.spawn(function()
            local t = 0
            local startTime = tick()
            while BadgeGui and BadgeGui.Parent and (tick() - startTime < badgeDuration) do
                t = t + 0.05
                if isOwner then
                    local rainbow = Color3.fromHSV((t * 25) % 360 / 360, 0.85, 1)
                    PremiumText.TextColor3 = rainbow
                    Stroke.Color = rainbow
                else
                    local green = Color3.fromRGB(0, 255, 128)
                    local purple = Color3.fromRGB(168, 45, 255)
                    local mix = green:Lerp(purple, (math.sin(t * 3) + 1) / 2)
                    PremiumText.TextColor3 = mix
                    Stroke.Color = mix
                end
                RunService.RenderStepped:Wait()
            end
            if BadgeGui and BadgeGui.Parent then BadgeGui:Destroy() end
        end)

        -- MENU PRINCIPAL DEL HUB
        if CoreGui:FindFirstChild("PxzdHubMenu") then CoreGui.PxzdHubMenu:Destroy() end

        local MenuGui = Instance.new("ScreenGui")
        MenuGui.Name = "PxzdHubMenu"
        MenuGui.ResetOnSpawn = false
        MenuGui.Parent = CoreGui

        local MainMenu = Instance.new("Frame")
        MainMenu.Name = "MainFrame"
        MainMenu.Size = UDim2.new(0, 400, 0, 310)
        MainMenu.Position = UDim2.new(0.5, -200, 0.5, -155)
        MainMenu.BackgroundColor3 = Color3.fromRGB(14, 9, 22)
        MainMenu.BorderSizePixel = 0
        MainMenu.ClipsDescendants = true
        MainMenu.Parent = MenuGui

        Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 14)

        local MainStroke = Instance.new("UIStroke")
        MainStroke.Color = Color3.fromRGB(168, 45, 255)
        MainStroke.Thickness = 2
        MainStroke.Parent = MainMenu

        -- Hacer la ventana arrastrable
        local Header = Instance.new("Frame")
        Header.Size = UDim2.new(1, 0, 0, 45)
        Header.BackgroundTransparency = 1
        Header.Parent = MainMenu

        MakeDraggable(MainMenu, Header)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -50, 1, 0)
        TitleLabel.Position = UDim2.new(0, 16, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = "PXZD HUB IN TOP ⚡"
        TitleLabel.TextColor3 = Color3.fromRGB(168, 45, 255)
        TitleLabel.Font = Enum.Font.GothamBlack
        TitleLabel.TextSize = 16
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 3
        TitleLabel.Parent = Header

        local CloseMenuBtn = Instance.new("TextButton")
        CloseMenuBtn.Size = UDim2.new(0, 26, 0, 26)
        CloseMenuBtn.Position = UDim2.new(1, -34, 0, 10)
        CloseMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
        CloseMenuBtn.Text = "✕"
        CloseMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseMenuBtn.Font = Enum.Font.GothamBold
        CloseMenuBtn.TextSize = 13
        CloseMenuBtn.ZIndex = 3
        CloseMenuBtn.Parent = Header
        Instance.new("UICorner", CloseMenuBtn).CornerRadius = UDim.new(0, 7)

        CloseMenuBtn.MouseButton1Click:Connect(function()
            MainMenu.Visible = false
        end)

        -- BOTÓN FLOTANTE MÓVIL/PC
        if CoreGui:FindFirstChild("PxzdToggleButton") then CoreGui.PxzdToggleButton:Destroy() end

        local ToggleGui = Instance.new("ScreenGui")
        ToggleGui.Name = "PxzdToggleButton"
        ToggleGui.ResetOnSpawn = false
        ToggleGui.Parent = CoreGui

        local ToggleBtn = Instance.new("ImageButton")
        ToggleBtn.Name = "ToggleImageBtn"
        ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
        ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
        ToggleBtn.BackgroundTransparency = 1
        ToggleBtn.Image = LOGO_ID
        ToggleBtn.Parent = ToggleGui

        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Color = Color3.fromRGB(0, 255, 128)
        ToggleStroke.Thickness = 2.5
        ToggleStroke.Parent = ToggleBtn

        MakeDraggable(ToggleBtn, ToggleBtn)

        task.spawn(function()
            local t = 0
            while ToggleBtn and ToggleBtn.Parent do
                t = t + 0.05
                local green = Color3.fromRGB(0, 255, 128)
                local purple = Color3.fromRGB(168, 45, 255)
                ToggleStroke.Color = green:Lerp(purple, (math.sin(t * 3) + 1) / 2)
                task.wait(0.03)
            end
        end)

        ToggleBtn.MouseButton1Click:Connect(function()
            MainMenu.Visible = not MainMenu.Visible
        end)

        -- SCROLLING FRAME SCRIPTS
        local ScrollFrame = Instance.new("ScrollingFrame")
        ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
        ScrollFrame.Position = UDim2.new(0, 10, 0, 48)
        ScrollFrame.BackgroundTransparency = 1
        ScrollFrame.BorderSizePixel = 0
        ScrollFrame.ScrollBarThickness = 4
        ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(168, 45, 255)
        ScrollFrame.ZIndex = 2
        ScrollFrame.Parent = MainMenu

        local UIList = Instance.new("UIListLayout")
        UIList.Padding = UDim.new(0, 8)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Parent = ScrollFrame

        local function CreateScriptRow(name, scriptTarget)
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, -8, 0, 44)
            Row.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
            Row.ZIndex = 2
  
