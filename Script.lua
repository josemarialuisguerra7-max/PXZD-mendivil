-- ==============================================================================
--  PXZD HUB PRO | INTRO LIMPIA (SOLO IMAGEN 3S) + MÚSICA 6S + 6 FUNCIONES
-- ==============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local GuiParent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- FUNCIÓN DE ARRASTRE UNIVERSAL
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

-- 1. INTRO (SOLO TU IMAGEN FLOTANTE SIN FONDO - 3 SEGUNDOS + MÚSICA 6S CON FADE)
pcall(function()
    if GuiParent:FindFirstChild("PXZD_IntroGui") then GuiParent.PXZD_IntroGui:Destroy() end

    -- Música de fondo (6 segundos con desvanecimiento)
    local introSound = Instance.new("Sound", SoundService)
    introSound.SoundId = "rbxassetid://71251641989884"
    introSound.Volume = 0.3
    introSound.TimePosition = 18
    introSound:Play()

    task.spawn(function()
        task.wait(4.5) -- Empieza a bajar el volumen antes de los 6s
        if introSound and introSound.Parent then
            for i = 30, 0, -1 do
                if not introSound or not introSound.Parent then break end
                introSound.Volume = i / 100
                task.wait(0.05)
            end
            introSound:Destroy()
        end
    end)

    local IntroGui = Instance.new("ScreenGui", GuiParent)
    IntroGui.Name = "PXZD_IntroGui"
    IntroGui.ResetOnSpawn = false

    -- Imagen sola, centrada y sin fondo negro
    local PureLogo = Instance.new("ImageLabel", IntroGui)
    PureLogo.Size = UDim2.new(0, 130, 0, 130)
    PureLogo.Position = UDim2.new(0.5, -65, 0.5, -65)
    PureLogo.BackgroundTransparency = 1
    PureLogo.Image = "rbxassetid://108485396062507"
    PureLogo.ImageTransparency = 0
    Instance.new("UICorner", PureLogo).CornerRadius = UDim.new(1, 0)

    -- Animación de arcoíris en el borde de tu imagen durante la intro
    local LogoStroke = Instance.new("UIStroke", PureLogo)
    LogoStroke.Thickness = 3
    LogoStroke.Color = Color3.fromRGB(0, 255, 100)

    task.spawn(function()
        local t = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            t = t + dt * 0.3
            LogoStroke.Color = Color3.fromHSV(t % 1, 0.8, 1)
        end)

        -- Mantener 2 segundos visibles y 1 segundo de desvanecimiento (Total 3s)
        task.wait(2.0)
        for i = 0, 1, 0.1 do
            if not PureLogo.Parent then break end
            PureLogo.ImageTransparency = i
            LogoStroke.Transparency = i
            task.wait(0.1)
        end

        if conn then conn:Disconnect() end
        IntroGui:Destroy()
    end)
end)

-- 2. INTERFAZ PRINCIPAL (APARECE AL TERMINAR LA INTRO)
task.delay(3.0, function()
    pcall(function()
        if GuiParent:FindFirstChild("PXZD_MainGui") then GuiParent.PXZD_MainGui:Destroy() end

        local ScreenGui = Instance.new("ScreenGui", GuiParent)
        ScreenGui.Name = "PXZD_MainGui"
        ScreenGui.ResetOnSpawn = false

        -- BOTÓN FLOTANTE MÓVIBLE
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

        -- MARCO PRINCIPAL
        local Main = Instance.new("Frame", ScreenGui)
        Main.Size = UDim2.new(0, 310, 0, 295)
        Main.Position = UDim2.new(0.5, -155, 0.5, -147.5)
        Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        Main.BorderSizePixel = 0
        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

        local MainStroke = Instance.new("UIStroke", Main)
        MainStroke.Thickness = 3
        MainStroke.Color = Color3.fromRGB(0, 255, 100)
        MakeDraggable(Main, Main)

        ToggleBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
        end)

        -- ARCOÍRIS SUAVE CONTINUO
        task.spawn(function()
            local t = 0
            while ScreenGui.Parent do
                t = t + 0.03
                local rainbow = Color3.fromHSV((t * 0.2) % 1, 0.8, 1)
                MainStroke.Color = rainbow
                ToggleStroke.Color = rainbow
                task.wait(0.04)
            end
        end)

        -- HEADER
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

        -- CONTENEDOR DE OPCIONES
        local Container = Instance.new("ScrollingFrame", Main)
        Container.Size = UDim2.new(0.92, 0, 0, 235)
        Container.Position = UDim2.new(0.04, 0, 0.17, 0)
        Container.BackgroundTransparency = 1
        Container.CanvasSize = UDim2.new(0, 0, 0, 355)
        Container.ScrollBarThickness = 3

        local UIList = Instance.new("UIListLayout", Container)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Padding = UDim.new(0, 8)

        local function CreateButtonCard(name, bgColor, btnColor, btnText, callback)
            local Card = Instance.new("Frame", Container)
            Card.Size = UDim2.new(1, 0, 0, 50)
            Card.BackgroundColor3 = bgColor
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", Card)
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Position = UDim2.new(0.04, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ExecBtn = Instance.new("TextButton", Card)
            ExecBtn.Size = UDim2.new(0.34, 0, 0.7, 0)
            ExecBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
            ExecBtn.BackgroundColor3 = btnColor
            ExecBtn.Text = btnText
            ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ExecBtn.Font = Enum.Font.GothamBold
            ExecBtn.TextSize = 11
            Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 5)

            ExecBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    callback()
                    ExecBtn.Text = "Ready!"
                    ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
                end)
            end)
        end

        -- 1. VIREX HUB
        CreateButtonCard("VIREX Hub", Color3.fromRGB(28, 20, 38), Color3.fromRGB(230, 110, 10), "Execute", function()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/virexx55/836653079c73281295d6bfb5c10be5d9/raw/128b0220c9a36354b5c6504c3669f328e5354805/virex.lua"))()
        end)

        -- 2. MODO PATATA ULTRA
        CreateButtonCard("Modo Patata Ultra", Color3.fromRGB(28, 28, 20), Color3.fromRGB(180, 130, 20), "Active", function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end)

        -- 3. SERVER BYPASS
        CreateButtonCard("Server Bypass", Color3.fromRGB(20, 28, 38), Color3.fromRGB(40, 110, 180), "Bypass", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua"))()
        end)

        -- 4. LENNON FARM AFK
        CreateButtonCard("Lennon Farm AFK", Color3.fromRGB(38, 20, 28), Color3.fromRGB(180, 40, 110), "Farm AFK", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/lennonxscripts/lennonfarmv2/refs/heads/main/stealanegg"))()
        end)

        -- 5. CHILLI HUB
        CreateButtonCard("Chilli Hub", Color3.fromRGB(38, 25, 20), Color3.fromRGB(200, 60, 20), "Execute", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
        end)

        -- 6. MIRANDA HUB
        CreateButtonCard("Miranda Hub", Color3.fromRGB(25, 20, 38), Color3.fromRGB(130, 40, 200), "Execute", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealeggies"))()
        end)
    end)
end)
