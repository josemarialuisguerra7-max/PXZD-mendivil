-- ==============================================================================
--  PXZD HUB IN TOP | CORESCRIPT ULTIMATE (BURBUJAS + BARRA ROJA Y VERDE)
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local function GetSafeGuiParent()
    local success, parent = pcall(function() return CoreGui end)
    if success and parent then
        return parent
    else
        return LocalPlayer:WaitForChild("PlayerGui", 5)
    end
end

local GuiParent = GetSafeGuiParent()
if not GuiParent then return end

local LOGO_ID = "rbxassetid://108485396062507"
local INTRO_AUDIO_ID = "rbxassetid://108721795687965"

-- ==================== FUNCIÓN DRAGGABLE ====================
local function MakeDraggable(frame, handle)
    pcall(function()
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
    end)
end

-- ==================== MODO PAPÁ ====================
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
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
                effect.Enabled = false
            end
        end
    end)
end

-- ==================== INTRO CON BURBUJAS Y BARRA ROJO/VERDE ====================
local function PlayCustomIntro(onComplete)
    pcall(function()
        local oldBlur = Lighting:FindFirstChild("PxzdIntroBlur")
        if oldBlur then oldBlur:Destroy() end

        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Name = "PxzdIntroBlur"
        blurEffect.Size = 20
        blurEffect.Parent = Lighting

        local oldSound = SoundService:FindFirstChild("PxzdIntroMusic")
        if oldSound then oldSound:Destroy() end

        local introSound = Instance.new("Sound")
        introSound.Name = "PxzdIntroMusic"
        introSound.SoundId = INTRO_AUDIO_ID
        introSound.Volume = 0
        introSound.TimePosition = 24
        introSound.Parent = SoundService
        
        task.spawn(function()
            pcall(function() 
                introSound:Play() 
                TweenService:Create(introSound, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = 0.25}):Play()
            end)
        end)

        if GuiParent:FindFirstChild("PxzdIntroGui") then GuiParent.PxzdIntroGui:Destroy() end

        local IntroGui = Instance.new("ScreenGui")
        IntroGui.Name = "PxzdIntroGui"
        IntroGui.ResetOnSpawn = false
        IntroGui.IgnoreGuiInset = true
        IntroGui.Parent = GuiParent

        local Background = Instance.new("Frame")
        Background.Size = UDim2.new(1, 0, 1, 0)
        Background.BackgroundColor3 = Color3.fromRGB(8, 4, 14)
        Background.BackgroundTransparency = 0.2
        Background.Parent = IntroGui

        -- Contenedor de burbujas flotantes de logo
        local BubbleContainer = Instance.new("Folder")
        BubbleContainer.Name = "BubbleContainer"
        BubbleContainer.Parent = IntroGui

        local activeBubbles = true
        task.spawn(function()
            math.randomseed(tick())
            while activeBubbles and IntroGui and IntroGui.Parent do
                task.spawn(function()
                    if not activeBubbles then return end
                    local bubble = Instance.new("ImageLabel")
                    local size = math.random(25, 55)
                    bubble.Size = UDim2.new(0, size, 0, size)
                    bubble.Position = UDim2.new(math.random(5, 95) / 100, 0, 1.1, 0)
                    bubble.BackgroundTransparency = 1
                    bubble.Image = LOGO_ID
                    bubble.ImageTransparency = math.random(40, 70) / 100
                    bubble.Parent = BubbleContainer

                    Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

                    local targetY = -0.2
                    local duration = math.random(35, 60) / 10
                    local wobbleOffset = math.random(-40, 40)

                    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(bubble, tweenInfo, {
                        Position = UDim2.new(bubble.Position.X.Scale, wobbleOffset, targetY, 0),
                        ImageTransparency = 1
                    })
                    tween:Play()

                    tween.Completed:Connect(function()
                        bubble:Destroy()
                    end)
                end)
                task.wait(0.25)
            end
        end)

        local CenterFrame = Instance.new("Frame")
        CenterFrame.Size = UDim2.new(0, 400, 0, 260)
        CenterFrame.Position = UDim2.new(0.5, -200, 0.5, -130)
        CenterFrame.BackgroundTransparency = 1
        CenterFrame.Parent = IntroGui

        local LogoImage = Instance.new("ImageLabel")
        LogoImage.Size = UDim2.new(0, 100, 0, 100)
        LogoImage.Position = UDim2.new(0.5, -50, 0, 0)
        LogoImage.BackgroundTransparency = 1
        LogoImage.Image = LOGO_ID
        LogoImage.Parent = CenterFrame
        Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

        local LogoStroke = Instance.new("UIStroke")
        LogoStroke.Thickness = 3
        LogoStroke.Color = Color3.fromRGB(0, 255, 128)
        LogoStroke.Parent = LogoImage

        local TitleText = Instance.new("TextLabel")
        TitleText.Size = UDim2.new(1, 0, 0, 50)
        TitleText.Position = UDim2.new(0, 0, 0.42, 0)
        TitleText.BackgroundTransparency = 1
        TitleText.Text = "👑 Chema in top 👑"
        TitleText.Font = Enum.Font.FredokaOne
        TitleText.TextSize = 32
        TitleText.Parent = CenterFrame

        local TextStroke = Instance.new("UIStroke")
        TextStroke.Thickness = 3
        TextStroke.Color = Color3.fromRGB(168, 45, 255)
        TextStroke.Parent = TitleText

        -- Barra de Carga Fondo
        local BarBG = Instance.new("Frame")
        BarBG.Size = UDim2.new(0, 240, 0, 8)
        BarBG.Position = UDim2.new(0.5, -120, 0.72, 0)
        BarBG.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
        BarBG.Parent = CenterFrame
        Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

        -- Barra de Relleno
        local BarFill = Instance.new("Frame")
        BarFill.Size = UDim2.new(0, 0, 1, 0)
        BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BarFill.Parent = BarBG
        Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

        -- Gradiente Metálico Rojo y Verde
        local BarGradient = Instance.new("UIGradient")
        BarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 40, 40)),     -- Rojo metálico encendido
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 150)), -- Brillo central metálico
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 128))      -- Verde brillante
        })
        BarGradient.Parent = BarFill

        local LoadingStatus = Instance.new("TextLabel")
        LoadingStatus.Size = UDim2.new(1, 0, 0, 30)
        LoadingStatus.Position = UDim2.new(0, 0, 0.82, 0)
        LoadingStatus.BackgroundTransparency = 1
        LoadingStatus.Text = "Cargando."
        LoadingStatus.TextColor3 = Color3.fromRGB(200, 200, 215)
        LoadingStatus.Font = Enum.Font.GothamBold
        LoadingStatus.TextSize = 14
        LoadingStatus.Parent = CenterFrame

        TweenService:Create(BarFill, TweenInfo.new(7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()

        local textAnimRoutine = task.spawn(function()
            local states = {"Cargando.", "Cargando..", "Cargando..."}
            local i = 1
            while IntroGui and IntroGui.Parent do
                LoadingStatus.Text = states[i]
                i = (i % #states) + 1
                task.wait(0.4)
            end
        end)

        local rainbowRoutine = task.spawn(function()
            local hue = 0
            while IntroGui and IntroGui.Parent do
                hue = (hue + 3) % 360
                local col = Color3.fromHSV(hue / 360, 0.95, 1)
                local colStroke = Color3.fromHSV(((hue + 180) % 360) / 360, 1, 1)
                TitleText.TextColor3 = col
                TextStroke.Color = colStroke
                LogoStroke.Color = col
                RunService.RenderStepped:Wait()
            end
        end)

        task.wait(7.5)

        activeBubbles = false
        pcall(function()
            task.cancel(rainbowRoutine)
            task.cancel(textAnimRoutine)
        end)

        if IntroGui then IntroGui:Destroy() end
        if blurEffect then blurEffect:Destroy() end

        if onComplete then onComplete() end

        task.spawn(function()
            if introSound and introSound.IsPlaying then
                TweenService:Create(introSound, TweenInfo.new(1.5), {Volume = 0}):Play()
                task.wait(1.5)
                introSound:Stop()
                introSound:Destroy()
            end
        end)
    end)
end

-- ==================== CONSTRUCCIÓN DEL MENÚ PRINCIPAL ====================
PlayCustomIntro(function()
    pcall(function()
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

        local BackgroundWatermark = Instance.new("ImageLabel")
        BackgroundWatermark.Size = UDim2.new(0, 220, 0, 220)
        BackgroundWatermark.Position = UDim2.new(0.5, -110, 0.5, -110)
        BackgroundWatermark.BackgroundTransparency = 1
        BackgroundWatermark.Image = LOGO_ID
        BackgroundWatermark.ImageTransparency = 0.88
        BackgroundWatermark.ZIndex = 0
        BackgroundWatermark.Parent = MainMenu

        local Header = Instance.new("Frame")
        Header.Size = UDim2.new(1, 0, 0, 45)
        Header.BackgroundTransparency = 1
        Header.ZIndex = 2
        Header.Parent = MainMenu

        MakeDraggable(MainMenu, Header)

        local AvatarHolder = Instance.new("Frame")
        AvatarHolder.Size = UDim2.new(0, 34, 0, 34)
        AvatarHolder.Position = UDim2.new(0, 12, 0, 6)
        AvatarHolder.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
        AvatarHolder.ZIndex = 2
        AvatarHolder.Parent = Header
        Instance.new("UICorner", AvatarHolder).CornerRadius = UDim.new(1, 0)

        local AvatarStroke = Instance.new("UIStroke")
        AvatarStroke.Color = Color3.fromRGB(0, 255, 128)
        AvatarStroke.Thickness = 1.5
        AvatarStroke.Parent = AvatarHolder

        local AvatarImage = Instance.new("ImageLabel")
        AvatarImage.Size = UDim2.new(1, 0, 1, 0)
        AvatarImage.BackgroundTransparency = 1
        AvatarImage.ZIndex = 2
        AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", LocalPlayer.UserId)
        AvatarImage.Parent = AvatarHolder
        Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -95, 1, 0)
        TitleLabel.Position = UDim2.new(0, 56, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = "PXZD HUB IN TOP ⚡"
        TitleLabel.TextColor3 = Color3.fromRGB(168, 45, 255)
        TitleLabel.Font = Enum.Font.GothamBlack
        TitleLabel.TextSize = 15
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 2
        TitleLabel.Parent = Header

        local CloseMenuBtn = Instance.new("TextButton")
        CloseMenuBtn.Size = UDim2.new(0, 26, 0, 26)
        CloseMenuBtn.Position = UDim2.new(1, -34, 0, 10)
        CloseMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
        CloseMenuBtn.Text = "✕"
        CloseMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseMenuBtn.Font = Enum.Font.GothamBold
        CloseMenuBtn.TextSize = 13
        CloseMenuBtn.ZIndex = 2
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
            Row.BackgroundTransparency = 0.15
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
            NameText.ZIndex = 2
            NameText.Parent = Row

            local ExecBtn = Instance.new("TextButton")
            ExecBtn.Size = UDim2.new(0.3, -5, 0, 28)
            ExecBtn.Position = UDim2.new(0.7, 0, 0.5, -14)
            ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            ExecBtn.Text = "Execute"
            ExecBtn.TextColor3 = Color3.fromRGB(10, 25, 15)
            ExecBtn.Font = Enum.Font.GothamBlack
            ExecBtn.TextSize = 11
            ExecBtn.ZIndex = 2
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
    end)
end)
