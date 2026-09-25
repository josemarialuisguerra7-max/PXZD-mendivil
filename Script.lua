-- ==============================================================================
--  PXZD HUB IN TOP | FUNNY & SIMPLE MEME INTRO (VERSION COMPLETA)
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

-- Obtener contenedor seguro para la UI
local function GetSafeGuiParent()
    local success, _ = pcall(function() return CoreGui.Name end)
    if success then
        return CoreGui
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

local GuiParent = GetSafeGuiParent()

-- LISTA DE USUARIOS PREMIUM (EN MINÚSCULAS)
local PremiumUsers = {
    ["carbius123"] = true,
    ["bacon_pro8879"] = true,
    ["g_07n1"] = true,
    ["zzzzzer11"] = true,
    ["elalfa_3677"] = true
}

local LOGO_ID = "rbxassetid://108485396062507"
local FUNNY_AUDIO_ID = "rbxassetid://9069609268" -- Efecto gracioso de corneta / meme

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

-- ==================== INTRO SENCILLA Y CHISTOSA ====================
local function PlayCustomIntro(onComplete)
    local funnySound = Instance.new("Sound")
    funnySound.Name = "PxzdMemeSound"
    funnySound.SoundId = FUNNY_AUDIO_ID
    funnySound.Volume = 0.8
    funnySound.Parent = SoundService

    pcall(function() funnySound:Play() end)

    if GuiParent:FindFirstChild("PxzdFunnyIntroGui") then GuiParent.PxzdFunnyIntroGui:Destroy() end

    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "PxzdFunnyIntroGui"
    IntroGui.ResetOnSpawn = false
    IntroGui.IgnoreGuiInset = true
    IntroGui.Parent = GuiParent

    -- Fondo morado chillon / meme
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(18, 10, 30)
    Background.BackgroundTransparency = 0.1
    Background.Parent = IntroGui

    -- Frame Centrado
    local CenterFrame = Instance.new("Frame")
    CenterFrame.Size = UDim2.new(0, 380, 0, 240)
    CenterFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
    CenterFrame.BackgroundTransparency = 1
    CenterFrame.Parent = IntroGui

    -- Logo rebotando
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(0, 100, 0, 100)
    LogoImage.Position = UDim2.new(0.5, -50, 0.05, 0)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = LOGO_ID
    LogoImage.Parent = CenterFrame
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

    -- Animación de rebote
    LogoImage.Rotation = -20
    TweenService:Create(LogoImage, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Rotation = 20
    }):Play()

    -- Texto Principal
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, 0, 0, 45)
    TitleText.Position = UDim2.new(0, 0, 0.5, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "👑 CHEMA IN TOP 👑"
    TitleText.TextColor3 = Color3.fromRGB(255, 230, 0)
    TitleText.Font = Enum.Font.FredokaOne
    TitleText.TextSize = 28
    TitleText.Parent = CenterFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 0, 100)
    Stroke.Thickness = 3
    Stroke.Parent = TitleText

    -- Texto Subtítulo gracioso
    local Subtext = Instance.new("TextLabel")
    Subtext.Size = UDim2.new(1, 0, 0, 25)
    Subtext.Position = UDim2.new(0, 0, 0.72, 0)
    Subtext.BackgroundTransparency = 1
    Subtext.Text = "🚨 CUIDADO: Script demasiado insano 🚨"
    Subtext.TextColor3 = Color3.fromRGB(0, 255, 180)
    Subtext.Font = Enum.Font.SourceSansBold
    Subtext.TextSize = 16
    Subtext.Parent = CenterFrame

    -- Efecto de parpadeo rápido
    task.spawn(function()
        for i = 1, 12 do
            TitleText.TextColor3 = (i % 2 == 0) and Color3.fromRGB(255, 230, 0) or Color3.fromRGB(0, 255, 255)
            LogoImage.Rotation = (i % 2 == 0) and -15 or 15
            task.wait(0.12)
        end
    end)

    task.wait(2.2)

    -- Desaparición
    TweenService:Create(Background, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(TitleText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(Subtext, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LogoImage, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()

    task.wait(0.3)

    if funnySound then funnySound:Destroy() end
    if IntroGui then IntroGui:Destroy() end

    if onComplete then onComplete() end
end

-- ==================== INICIO DEL SCRIPT ====================
PlayCustomIntro(function()
    local isPremium = PremiumUsers[string.lower(LocalPlayer.Name)]

    if isPremium then
        if GuiParent:FindFirstChild("PxzdPremiumBadge") then GuiParent.PxzdPremiumBadge:Destroy() end

        local isOwner = (string.lower(LocalPlayer.Name) == "carbius123")
        local badgeDuration = isOwner and 12 or 7

        local BadgeGui = Instance.new("ScreenGui")
        BadgeGui.Name = "PxzdPremiumBadge"
        BadgeGui.ResetOnSpawn = false
        BadgeGui.Parent = GuiParent

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

        if GuiParent:FindFirstChild("PxzdHubMenu") then GuiParent.PxzdHubMenu:Destroy() end

        local MenuGui = Instance.new("ScreenGui")
        MenuGui.Name = "PxzdHubMenu"
        MenuGui.ResetOnSpawn = false
        MenuGui.Parent = GuiParent

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

        if GuiParent:FindFirstChild("PxzdToggleButton") then GuiParent.PxzdToggleButton:Destroy() end

        local ToggleGui = Instance.new("ScreenGui")
        ToggleGui.Name = "PxzdToggleButton"
        ToggleGui.ResetOnSpawn = false
        ToggleGui.Parent = GuiParent

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
            Row.Parent = ScrollFrame
            Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

            local RowStroke = Instance.new("UIStroke")
            RowStroke.Color = Color3.fromRGB(80, 25, 130)
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
            NameText.ZIndex = 3
            NameText.Parent = Row

            local ExecBtn = Instance.new("TextButton")
            ExecBtn.Size = UDim2.new(0.3, -5, 0, 28)
            ExecBtn.Position = UDim2.new(0.7, 0, 0.5, -14)
            ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            ExecBtn.Text = "Execute"
            ExecBtn.TextColor3 = Color3.fromRGB(10, 25, 15)
            ExecBtn.Font = Enum.Font.GothamBlack
            ExecBtn.TextSize = 11
            ExecBtn.ZIndex = 3
            ExecBtn.Parent = Row
            Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)

            ExecBtn.MouseButton1Click:Connect(function()
                ExecBtn.Text = "Cargando..."
                ExecBtn.BackgroundColor3 = Color3.fromRGB(168, 45, 255)
                ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

                task.spawn(function()
                    pcall(function()
                        if type(scriptTarget) == "function" then
                            scriptTarget()
                        else
                            loadstring(game:HttpGet(scriptTarget))()
                        end
                    end)
                    task.wait(0.5)
                    ExecBtn.Text = "¡Activado!"
                    ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
                    ExecBtn.TextColor3 = Color3.fromRGB(10, 25, 15)
                end)
            end)
        end

        CreateScriptRow("Mejorar Rendimiento 🥔", EnablePotatoMode)
        CreateScriptRow("Afk Lennon Premium", "https://raw.githubusercontent.com/lennonxscripts/lennonfarm/refs/heads/main/farmv1.lua")
        CreateScriptRow("Miranda Farm", "https://api.luarmor.net/files/v4/loaders/6b07a458832f08b2314f706f14723212.lua")
        CreateScriptRow("Server Premium 🤑", "https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua")
        CreateScriptRow("Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")

        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 15)

        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "⚡ PXZD HUB IN TOP ⚡",
                Text = "¡Bienvenido " .. LocalPlayer.Name .. "! Script cargado.",
                Duration = 4
            })
        end)
    else
        if GuiParent:FindFirstChild("PxzdHubCore") then GuiParent.PxzdHubCore:Destroy() end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "PxzdHubCore"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = GuiParent

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "UpdateFrame"
        MainFrame.Size = UDim2.new(0, 360, 0, 200)
        MainFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
        MainFrame.BackgroundColor3 = Color3.fromRGB(14, 9, 22)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui

        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(168, 45, 255)
        UIStroke.Thickness = 2
        UIStroke.Parent = MainFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Position = UDim2.new(0, 0, 0.35, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "PXZD HUB IN TOP ⚡"
        Title.TextColor3 = Color3.fromRGB(168, 45, 255)
        Title.TextSize = 17
        Title.Font = Enum.Font.GothamBlack
        Title.Parent = MainFrame

        local Description = Instance.new("TextLabel")
        Description.Size = UDim2.new(1, -40, 0, 30)
        Description.Position = UDim2.new(0, 20, 0.55, 0)
        Description.BackgroundTransparency = 1
        Description.Text = "GG tranquilo está en actualización"
        Description.TextColor3 = Color3.fromRGB(200, 200, 210)
        Description.TextSize = 13
        Description.Font = Enum.Font.GothamSemibold
        Description.Parent = MainFrame

        task.wait(4)
        ScreenGui:Destroy()
    end
end)
