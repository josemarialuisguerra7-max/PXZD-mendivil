-- ==============================================================================
--  PXZD HUB PRO | INTRO, BURBUJAS CON FADE, BOTÓN MÓVIBLE Y 4 FUNCIONES
-- ==============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local GuiParent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- 1. FUNCIÓN DE ARRASTRE UNIVERSAL (PARA VENTANA Y BOTÓN FLOTANTE)
local function MakeDraggable(frame, handle)
    pcall(function()
        handle = handle or frame
        local dragging, dragInput, startPos, dragStart
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end)
end

-- 2. INTRO PRO (7 SEGUNDOS, BORROSO, MÚSICA 20S CON FADE OUT)
pcall(function()
    if GuiParent:FindFirstChild("PXZD_IntroGui") then GuiParent.PXZD_IntroGui:Destroy() end
    if Lighting:FindFirstChild("PXZD_Blur") then Lighting.PXZD_Blur:Destroy() end
    
    -- Efecto borroso en el fondo de Roblox
    local blurEffect = Instance.new("BlurEffect", Lighting)
    blurEffect.Name = "PXZD_Blur"
    blurEffect.Size = 18

    -- Música de fondo (ID: 71251641989884, desde segundo 18, volumen 0.25)
    local introSound = Instance.new("Sound", SoundService)
    introSound.SoundId = "rbxassetid://71251641989884"
    introSound.Volume = 0.25
    introSound.TimePosition = 18
    introSound:Play()

    -- Desvanecimiento de la música a los 20 segundos
    task.spawn(function()
        task.wait(20)
        if introSound and introSound.Parent then
            for i = 25, 0, -1 do
                if not introSound or not introSound.Parent then break end
                introSound.Volume = i / 100
                task.wait(0.08)
            end
            introSound:Destroy()
        end
    end)

    local IntroGui = Instance.new("ScreenGui", GuiParent)
    IntroGui.Name = "PXZD_IntroGui"
    IntroGui.ResetOnSpawn = false

    -- Marco principal de intro transparente
    local IntroFrame = Instance.new("Frame", IntroGui)
    IntroFrame.Size = UDim2.new(0, 360, 0, 280)
    IntroFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
    IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    IntroFrame.BackgroundTransparency = 0.35
    Instance.new("UICorner", IntroFrame).CornerRadius = UDim.new(0, 14)

    local IntroFrameStroke = Instance.new("UIStroke", IntroFrame)
    IntroFrameStroke.Thickness = 2.5
    IntroFrameStroke.Color = Color3.fromRGB(0, 255, 100)

    -- Imagen Central de PXZD HUB
    local LogoImage = Instance.new("ImageLabel", IntroFrame)
    LogoImage.Size = UDim2.new(0, 100, 0, 100)
    LogoImage.Position = UDim2.new(0.5, -50, 0, 20)
    LogoImage.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    LogoImage.Image = "rbxassetid://108485396062507"
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)
    
    local LogoStroke = Instance.new("UIStroke", LogoImage)
    LogoStroke.Thickness = 3
    LogoStroke.Color = Color3.fromRGB(0, 255, 100)

    -- Texto Inferior: 👑CHEMA👑
    local ChemaLabel = Instance.new("TextLabel", IntroFrame)
    ChemaLabel.Size = UDim2.new(1, 0, 0, 30)
    ChemaLabel.Position = UDim2.new(0, 0, 0, 128)
    ChemaLabel.BackgroundTransparency = 1
    ChemaLabel.Text = "👑 CHEMA 👑"
    ChemaLabel.Font = Enum.Font.GothamBlack
    ChemaLabel.TextSize = 22

    -- Barra de carga
    local LoadBarContainer = Instance.new("Frame", IntroFrame)
    LoadBarContainer.Size = UDim2.new(0, 260, 0, 8)
    LoadBarContainer.Position = UDim2.new(0.5, -130, 0, 175)
    LoadBarContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Instance.new("UICorner", LoadBarContainer).CornerRadius = UDim.new(1, 0)

    local LoadBarFill = Instance.new("Frame", LoadBarContainer)
    LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadBarFill.BackgroundColor3 = Color3.fromRGB(255, 120, 20)
    Instance.new("UICorner", LoadBarFill).CornerRadius = UDim.new(1, 0)

    local UIGradient = Instance.new("UIGradient", LoadBarFill)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 10)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 160, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 144, 255))
    })

    local LoadingText = Instance.new("TextLabel", IntroFrame)
    LoadingText.Size = UDim2.new(1, 0, 0, 25)
    LoadingText.Position = UDim2.new(0, 0, 0, 195)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Cargando script"
    LoadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.TextSize = 13

    -- Burbujas flotantes con más cantidad y desvanecimiento progresivo
    task.spawn(function()
        for i = 1, 24 do
            local bubble = Instance.new("ImageLabel", IntroGui)
            local size = math.random(15, 30)
            bubble.Size = UDim2.new(0, size, 0, size)
            bubble.Position = UDim2.new(math.random(5, 95)/100, 0, 1.1, 0)
            bubble.Image = "rbxassetid://108485396062507"
            bubble.BackgroundTransparency = 1
            bubble.ImageTransparency = 0.2
            Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
            
            task.spawn(function()
                for count = 1, 55 do
                    bubble.Position = bubble.Position - UDim2.new(0, 0, 0.02, 0)
                    bubble.ImageTransparency = bubble.ImageTransparency + (1 / 55)
                    task.wait(0.04)
                end
                bubble:Destroy()
            end)
            task.wait(0.08)
        end
    end)

    -- Animación de arcoíris suave
    task.spawn(function()
        local t = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            t = t + dt * 0.2
            local smoothColor = Color3.fromHSV(t % 1, 0.8, 1)
            LogoStroke.Color = smoothColor
            IntroFrameStroke.Color = smoothColor
            ChemaLabel.TextColor3 = smoothColor
        end)

        -- Puntos parpadeantes (. .. ...)
        task.spawn(function()
            local dots = {"", ".", "..", "..."}
            while IntroGui.Parent do
                for _, d in ipairs(dots) do
                    if not LoadingText.Parent then break end
                    LoadingText.Text = "Cargando script" .. d
                    task.wait(0.4)
                end
            end
        end)

        -- Progreso de barra exacto para los 7 segundos
        for i = 1, 100 do
            LoadBarFill.Size = UDim2.new(i/100, 0, 1, 0)
            task.wait(0.065)
        end

        if conn then conn:Disconnect() end
        
        -- Desvanecimiento exacto de la intro
        for i = 0, 1, 0.1 do
            IntroFrame.BackgroundTransparency = i + 0.35
            task.wait(0.02)
        end
        
        IntroGui:Destroy()
        if blurEffect then blurEffect:Destroy() end
    end)
end)

-- 3. INTERFAZ PRINCIPAL (APARECE EXACTAMENTE AL ACABAR LA INTRO Y BOTÓN MÓVIBLE)
task.delay(7.0, function()
    pcall(function()
        if GuiParent:FindFirstChild("PXZD_MainGui") then GuiParent.PXZD_MainGui:Destroy() end
        local ScreenGui = Instance.new("ScreenGui", GuiParent)
        ScreenGui.Name = "PXZD_MainGui"
        ScreenGui.ResetOnSpawn = false

        -- Botón flotante lateral (MÓVIBLE / DRAGGABLE)
        local ToggleBtn = Instance.new("ImageButton", ScreenGui)
        ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
        ToggleBtn.Position = UDim2.new(0, 15, 0.35, 0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        ToggleBtn.Image = "rbxassetid://108485396062507"
        ToggleBtn.AutoButtonColor = false
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        
        local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
        ToggleStroke.Thickness = 3
        ToggleStroke.Color = Color3.fromRGB(0, 255, 100)

        MakeDraggable(ToggleBtn, ToggleBtn)

        -- Marco principal CENTRADO (Altura adaptada para 4 opciones)
        local Main = Instance.new("Frame", ScreenGui)
        Main.Size = UDim2.new(0, 310, 0, 275)
        Main.Position = UDim2.new(0.5, -155, 0.5, -137.5)
        Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        Main.BorderSizePixel = 0
        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

        local BgImage = Instance.new("ImageLabel", Main)
        BgImage.Size = UDim2.new(1, 0, 1, 0)
        BgImage.BackgroundTransparency = 1
        BgImage.Image = "rbxassetid://108485396062507"
        BgImage.ImageTransparency = 0.82
        Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 12)

        local MainStroke = Instance.new("UIStroke", Main)
        MainStroke.Thickness = 3
        MainStroke.Color = Color3.fromRGB(0, 255, 100)

        MakeDraggable(Main, Main)

        ToggleBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
        end)

        -- Arcoíris suave continuo
        task.spawn(function()
            local t = 0
            while ScreenGui.Parent do
                t = t + 0.03
                local rainbow = Color3.fromHSV((t*0.2) % 1, 0.8, 1)
                MainStroke.Color = rainbow
                ToggleStroke.Color = rainbow
                task.wait(0.04)
            end
        end)

        local Header = Instance.new("Frame", Main)
        Header.Size = UDim2.new(1, 0, 0, 38)
        Header.BackgroundTransparency = 1

        local Title = Instance.new("TextLabel", Header)
        Title.Size = UDim2.new(1, -40, 1, 0)
        Title.Position = UDim2.new(0, 12, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "⚡ PXZD HUB | 👑 CHEMA 👑"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 11
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local CloseBtn = Instance.new("TextButton", Header)
        CloseBtn.Size = UDim2.new(0, 22, 0, 22)
        CloseBtn.Position = UDim2.new(1, -30, 0, 8)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 10
        Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
        CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

        local Container = Instance.new("ScrollingFrame", Main)
        Container.Size = UDim2.new(0.92, 0, 0, 215)
        Container.Position = UDim2.new(0.04, 0, 0.18, 0)
        Container.BackgroundTransparency = 1
        Container.CanvasSize = UDim2.new(0, 0, 0, 235)
        Container.ScrollBarThickness = 3

        local UIList = Instance.new("UIListLayout", Container)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Padding = UDim.new(0, 8)

        -- TARJETA 1: VIREX HUB
        local VirexCard = Instance.new("Frame", Container)
        VirexCard.Size = UDim2.new(1, 0, 0, 50)
        VirexCard.BackgroundColor3 = Color3.fromRGB(28, 20, 38)
        Instance.new("UICorner", VirexCard).CornerRadius = UDim.new(0, 6)

        local VirexLabel = Instance.new("TextLabel", VirexCard)
        VirexLabel.Size = UDim2.new(0.6, 0, 1, 0)
        VirexLabel.Position = UDim2.new(0.04, 0, 0, 0)
        VirexLabel.BackgroundTransparency = 1
        VirexLabel.Text = "VIREX Hub"
        VirexLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        VirexLabel.Font = Enum.Font.GothamBold
        VirexLabel.TextSize = 11
        VirexLabel.TextXAlignment = Enum.TextXAlignment.Left

        local VirexExecBtn = Instance.new("TextButton", VirexCard)
        VirexExecBtn.Size = UDim2.new(0.34, 0, 0.7, 0)
        VirexExecBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
        VirexExecBtn.BackgroundColor3 = Color3.fromRGB(230, 110, 10)
        VirexExecBtn.Text = "Execute"
        VirexExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        VirexExecBtn.Font = Enum.Font.GothamBold
        VirexExecBtn.TextSize = 11
        Instance.new("UICorner", VirexExecBtn).CornerRadius = UDim.new(0, 5)

        VirexExecBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(game:HttpGet("https://gist.githubusercontent.com/virexx55/836653079c73281295d6bfb5c10be5d9/raw/128b0220c9a36354b5c6504c3669f328e5354805/virex.lua"))()
                VirexExecBtn.Text = "Executed!"
                VirexExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
            end)
        end)

        -- TARJETA 2: MODO PATATA ULTRA
        local PotatoCard = Instance.new("Frame", Container)
        PotatoCard.Size = UDim2.new(1, 0, 0, 50)
        PotatoCard.BackgroundColor3 = Color3.fromRGB(28, 28, 20)
        Instance.new("UICorner", PotatoCard).CornerRadius = UDim.new(0, 6)

        local PotatoLabel = Instance.new("TextLabel", PotatoCard)
        PotatoLabel.Size = UDim2.new(0.6, 0, 1, 0)
        PotatoLabel.Position = UDim2.new(0.04, 0, 0, 0)
        PotatoLabel.BackgroundTransparency = 1
        PotatoLabel.Text = "Modo Patata Ultra"
        PotatoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PotatoLabel.Font = Enum.Font.GothamBold
        PotatoLabel.TextSize = 11
        PotatoLabel.TextXAlignment = Enum.TextXAlignment.Left

        local PotatoExecBtn = Instance.new("TextButton", PotatoCard)
        PotatoExecBtn.Size = UDim2.new(0.34, 0, 0.7, 0)
        PotatoExecBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
        PotatoExecBtn.BackgroundColor3 = Color3.fromRGB(180, 130, 20)
        PotatoExecBtn.Text = "Active"
        PotatoExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        PotatoExecBtn.Font = Enum.Font.GothamBold
        PotatoExecBtn.TextSize = 11
        Instance.new("UICorner", PotatoExecBtn).CornerRadius = UDim.new(0, 5)

        PotatoExecBtn.MouseButton1Click:Connect(function()
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        v:Destroy()
                    end
                end
                Lighting.GlobalShadows = false
                Lighting.Brightness = 2
                for _, effect in pairs(Lighting:GetChildren()) do
                    if effect:IsA("PostEffect") then effect.Enabled = false end
                end
                PotatoExecBtn.Text = "Optimized!"
                PotatoExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
            end)
        end)

        -- TARJETA 3: SERVER BYPASS
        local BypassCard = Instance.new("Frame", Container)
        BypassCard.Size = UDim2.new(1, 0, 0, 50)
        BypassCard.BackgroundColor3 = Color3.fromRGB(20, 28, 38)
        Instance.new("UICorner", BypassCard).CornerRadius = UDim.new(0, 6)

        local BypassLabel = Instance.new("TextLabel", BypassCard)
        BypassLabel.Size = UDim2.new(0.6, 0, 1, 0)
        BypassLabel.Position = UDim2.new(0.04, 0, 0, 0)
        BypassLabel.BackgroundTransparency = 1
        BypassLabel.Text = "Server Bypass"
        BypassLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        BypassLabel.Font = Enum.Font.GothamBold
        BypassLabel.TextSize = 11
        BypassLabel.TextXAlignment = Enum.TextXAlignment.Left

        local BypassExecBtn = Instance.new("TextButton", BypassCard)
        BypassExecBtn.Size = UDim2.new(0.34, 0, 0.7, 0)
        BypassExecBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
        BypassExecBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 180)
        BypassExecBtn.Text = "Bypass"
        BypassExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        BypassExecBtn.Font = Enum.Font.GothamBold
        BypassExecBtn.TextSize = 11
        Instance.new("UICorner", BypassExecBtn).CornerRadius = UDim.new(0, 5)

        BypassExecBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua"))()
                BypassExecBtn.Text = "Bypassed!"
                BypassExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
            end)
        end)

        -- TARJETA 4: LENNON FARM AFK
        local LennonCard = Instance.new("Frame", Container)
        LennonCard.Size = UDim2.new(1, 0, 0, 50)
        LennonCard.BackgroundColor3 = Color3.fromRGB(38, 20, 28)
        Instance.new("UICorner", LennonCard).CornerRadius = UDim.new(0, 6)

        local LennonLabel = Instance.new("TextLabel", LennonCard)
        LennonLabel.Size = UDim2.new(0.6, 0, 1, 0)
        LennonLabel.Position = UDim2.new(0.04, 0, 0, 0)
        LennonLabel.BackgroundTransparency = 1
        LennonLabel.Text = "Lennon Farm AFK"
        LennonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        LennonLabel.Font = Enum.Font.GothamBold
        LennonLabel.TextSize = 11
        LennonLabel.TextXAlignment = Enum.TextXAlignment.Left

        local LennonExecBtn = Instance.new("TextButton", LennonCard)
        LennonExecBtn.Size = UDim2.new(0.34, 0, 0.7, 0)
        LennonExecBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
        LennonExecBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 110)
        LennonExecBtn.Text = "Farm AFK"
        LennonExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        LennonExecBtn.Font = Enum.Font.GothamBold
        LennonExecBtn.TextSize = 11
        Instance.new("UICorner", LennonExecBtn).CornerRadius = UDim.new(0, 5)

        LennonExecBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/lennonxscripts/lennonfarmv2/refs/heads/main/stealanegg"))()
                LennonExecBtn.Text = "Farming!"
                LennonExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
            end)
        end)
    end)
end)
