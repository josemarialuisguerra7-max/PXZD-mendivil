-- ==============================================================================
--  PXZD HUB | CHEMX EDITION (ULTRA POTED)
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local GuiParent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- Tu logo original de PXZD Hub y el audio
local LOGO = "rbxassetid://108485396062507"
local AUDIO = "rbxassetid://108721795687965"

-- Función para mover ventanas
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

-- Función para crear efecto de borde Arcoíris dinámico
local function ApplyRainbowStroke(uiStrokeInstance)
    pcall(function()
        task.spawn(function()
            local hue = 0
            while uiStrokeInstance and uiStrokeInstance.Parent do
                hue = (hue + 0.01) % 1
                uiStrokeInstance.Color = Color3.fromHSV(hue, 1, 1)
                RunService.RenderStepped:Wait()
            end
        end)
    end)
end

-- ==================== MENÚ PRINCIPAL CHEMXHUB ====================
local function LoadMainPanel()
    pcall(function()
        if GuiParent:FindFirstChild("ChemMenuGui") then GuiParent.ChemMenuGui:Destroy() end
        local MenuGui = Instance.new("ScreenGui", GuiParent)
        MenuGui.Name = "ChemMenuGui"; MenuGui.ResetOnSpawn = false

        local Main = Instance.new("Frame", MenuGui)
        Main.Size = UDim2.new(0, 380, 0, 260); Main.Position = UDim2.new(0.5, -190, 0.5, -130)
        Main.BackgroundColor3 = Color3.fromRGB(15, 8, 20); Main.BorderSizePixel = 0; Main.ClipsDescendants = true
        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
        local mainStroke = Instance.new("UIStroke", Main)
        mainStroke.Thickness = 2.5
        ApplyRainbowStroke(mainStroke)

        local Header = Instance.new("Frame", Main)
        Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundTransparency = 1
        MakeDraggable(Main, Header)

        local TitleLbl = Instance.new("TextLabel", Header)
        TitleLbl.Size = UDim2.new(1, -40, 1, 0); TitleLbl.Position = UDim2.new(0, 15, 0, 0); TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = "⚡ CHEMXHUB IN TOP ⚡"; TitleLbl.TextColor3 = Color3.fromRGB(255, 140, 0); TitleLbl.Font = Enum.Font.GothamBlack; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local CloseMenu = Instance.new("TextButton", Header)
        CloseMenu.Size = UDim2.new(0, 24, 0, 24); CloseMenu.Position = UDim2.new(1, -32, 0, 8)
        CloseMenu.BackgroundColor3 = Color3.fromRGB(60, 20, 20); CloseMenu.Text = "✕"; CloseMenu.TextColor3 = Color3.fromRGB(255,255,255); CloseMenu.Font = Enum.Font.GothamBold; CloseMenu.TextSize = 12
        Instance.new("UICorner", CloseMenu).CornerRadius = UDim.new(0, 6)
        CloseMenu.MouseButton1Click:Connect(function() Main.Visible = false end)

        -- Barra de carga metálica con gradiente morado y naranja, y texto "???"
        local BarBG = Instance.new("Frame", Main)
        BarBG.Size = UDim2.new(0, 340, 0, 20); BarBG.Position = UDim2.new(0.5, -170, 0, 45)
        BarBG.BackgroundColor3 = Color3.fromRGB(25, 10, 25); BarBG.BorderSizePixel = 0
        Instance.new("UICorner", BarBG).CornerRadius = UDim.new(0, 6)

        local BarStroke = Instance.new("UIStroke", BarBG)
        BarStroke.Color = Color3.fromRGB(255, 120, 0)
        BarStroke.Thickness = 1.5

        local BarFill = Instance.new("Frame", BarBG)
        BarFill.Size = UDim2.new(1, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BarFill.BorderSizePixel = 0
        Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 5)

        local BarGradient = Instance.new("UIGradient", BarFill)
        BarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 40, 200)),   -- Morado metálico
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 0)), -- Naranja metálico
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 180))   -- Morado de nuevo
        })
        BarGradient.Rotation = 45

        local CustomBarText = Instance.new("TextLabel", BarBG)
        CustomBarText.Size = UDim2.new(1, 0, 1, 0); CustomBarText.BackgroundTransparency = 1
        CustomBarText.Text = "???"
        CustomBarText.Font = Enum.Font.Code; CustomBarText.TextSize = 14; CustomBarText.TextColor3 = Color3.fromRGB(255, 255, 255)
        CustomBarText.TextXAlignment = Enum.TextXAlignment.Center; CustomBarText.ZIndex = 3

        -- Botón flotante para abrir/cerrar con tu logo original
        if GuiParent:FindFirstChild("ChemToggleGui") then GuiParent.ChemToggleGui:Destroy() end
        local ToggleGui = Instance.new("ScreenGui", GuiParent)
        ToggleGui.Name = "ChemToggleGui"; ToggleGui.ResetOnSpawn = false

        local ToggleBtn = Instance.new("ImageButton", ToggleGui)
        ToggleBtn.Size = UDim2.new(0, 42, 0, 42); ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Image = LOGO
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        local toggleStroke = Instance.new("UIStroke", ToggleBtn)
        toggleStroke.Thickness = 2.5
        ApplyRainbowStroke(toggleStroke)
        MakeDraggable(ToggleBtn, ToggleBtn)
        ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

        local Scroll = Instance.new("ScrollingFrame", Main)
        Scroll.Size = UDim2.new(1, -16, 1, -80); Scroll.Position = UDim2.new(0, 8, 0, 74); Scroll.BackgroundTransparency = 1; Scroll.BorderSizePixel = 0; Scroll.ScrollBarThickness = 3
        local UIList = Instance.new("UIListLayout", Scroll)
        UIList.Padding = UDim.new(0, 6); UIList.SortOrder = Enum.SortOrder.LayoutOrder

        local function AddRow(txt, target)
            local Row = Instance.new("Frame", Scroll)
            Row.Size = UDim2.new(1, -4, 0, 40); Row.BackgroundColor3 = Color3.fromRGB(25, 12, 25); Row.BackgroundTransparency = 0.2
            Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

            local Lbl = Instance.new("TextLabel", Row)
            Lbl.Size = UDim2.new(0.6, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1
            Lbl.Text = txt; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 11; Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Btn = Instance.new("TextButton", Row)
            Btn.Size = UDim2.new(0.35, 0, 0, 26); Btn.Position = UDim2.new(0.62, 0, 0.5, -13); Btn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            Btn.Text = "Execute"; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBlack; Btn.TextSize = 11
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

            Btn.MouseButton1Click:Connect(function()
                Btn.Text = "Cargando..."
                task.spawn(function()
                    pcall(function()
                        if type(target) == "function" then target() else loadstring(game:HttpGet(target))() end
                    end)
                    task.wait(0.5); Btn.Text = "¡Listo!"
                end)
            end)
        end

        -- Modo Patata Remejorado (Ultra Optimización)
        AddRow("Modo Patata ULTRA 🥔", function()
            pcall(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.CastShadow = false
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SpecialMesh") then
                        v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                        v:Destroy()
                    end
                end
                Lighting.GlobalShadows = false
                Lighting.Brightness = 1
                for _, v in ipairs(Lighting:GetChildren()) do
                    if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
                        v:Destroy()
                    end
                end
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
        end)
        
        AddRow("Server Premium 🤑", "https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua")

        Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
    end)
end

-- ==================== INTRO NORMAL Y SECUENCIA DE HACKEO ====================
local function LoadIntro()
    pcall(function()
        local blur = Instance.new("BlurEffect", Lighting)
        blur.Name = "ChemBlur"; blur.Size = 20

        local sound = Instance.new("Sound", SoundService)
        sound.Name = "ChemSound"; sound.SoundId = AUDIO; sound.Volume = 0; sound.TimePosition = 24
        task.spawn(function() 
            sound:Play() 
            TweenService:Create(sound, TweenInfo.new(1.5), {Volume = 0.3}):Play()
        end)

        if GuiParent:FindFirstChild("ChemIntroGui") then GuiParent.ChemIntroGui:Destroy() end
        local IntroGui = Instance.new("ScreenGui", GuiParent)
        IntroGui.Name = "ChemIntroGui"; IntroGui.ResetOnSpawn = false; IntroGui.IgnoreGuiInset = true

        local Bg = Instance.new("Frame", IntroGui)
        Bg.Size = UDim2.new(1,0,1,0); Bg.BackgroundColor3 = Color3.fromRGB(10, 4, 15); Bg.BackgroundTransparency = 0.2

        -- Burbujas flotantes iniciales con tu logo original
        local BubbleFolder = Instance.new("Folder", IntroGui)
        local activeBubbles = true
        task.spawn(function()
            while activeBubbles and IntroGui.Parent do
                task.spawn(function()
                    if not activeBubbles then return end
                    local b = Instance.new("ImageLabel", BubbleFolder)
                    local sz = math.random(30, 60)
                    b.Size = UDim2.new(0, sz, 0, sz)
                    b.Position = UDim2.new(math.random(5, 95)/100, 0, 1.1, 0)
                    b.BackgroundTransparency = 1; b.Image = LOGO; b.ImageTransparency = math.random(30, 60)/100
                    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
                    local tw = TweenService:Create(b, TweenInfo.new(math.random(4, 7), Enum.EasingStyle.Sine), {Position = UDim2.new(b.Position.X.Scale, math.random(-40, 40), -0.2, 0), ImageTransparency = 1})
                    tw:Play()
                    tw.Completed:Connect(function() b:Destroy() end)
                end)
                task.wait(0.25)
            end
        end)

        local Center = Instance.new("Frame", IntroGui)
        Center.Size = UDim2.new(0, 400, 0, 220); Center.Position = UDim2.new(0.5, -200, 0.5, -110); Center.BackgroundTransparency = 1

        local Logo = Instance.new("ImageLabel", Center)
        Logo.Size = UDim2.new(0, 90, 0, 90); Logo.Position = UDim2.new(0.5, -45, 0, 0); Logo.BackgroundTransparency = 1; Logo.Image = LOGO
        Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
        local logoStroke = Instance.new("UIStroke", Logo)
        logoStroke.Thickness = 3
        ApplyRainbowStroke(logoStroke)

        local Title = Instance.new("TextLabel", Center)
        Title.Size = UDim2.new(1, 0, 0, 40); Title.Position = UDim2.new(0, 0, 0.45, 0); Title.BackgroundTransparency = 1
        Title.Text = "👑 PXZD HUB 👑"; Title.Font = Enum.Font.FredokaOne; Title.TextSize = 24; Title.TextColor3 = Color3.fromRGB(255,255,255)

        -- Esperar 5 segundos normales con la intro de PXZD Hub
        task.wait(5)

        -- EFECTO DE HACKEO: La canción se traba y aparece pantalla completa de números verdes
        pcall(function()
            sound.PlaybackSpeed = 0.4
        end)

        Title.Visible = false
        Logo.Visible = false
        Bg.BackgroundTransparency = 0.05
        Bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

        local HackerText = Instance.new("TextLabel", IntroGui)
        HackerText.Size = UDim2.new(1, 0, 1, 0); HackerText.BackgroundTransparency = 1
        HackerText.Font = Enum.Font.Code; HackerText.TextSize = 18; HackerText.TextColor3 = Color3.fromRGB(0, 255, 60)
        HackerText.TextWrapped = true

        local hackerActive = true
        task.spawn(function()
            while hackerActive do
                local randomStr = ""
                for i = 1, 200 do
                    randomStr = randomStr .. (math.random(0,1) == 1 and "101 " or "010 ")
                end
                HackerText.Text = randomStr
                task.wait(0.08)
            end
        end)

        -- Duración de los números verdes (4 segundos)
        task.wait(4)
        hackerActive = false

        -- Limpiar intro hackeada y abrir el menú ChemxHub con la música restaurada
        activeBubbles = false
        IntroGui:Destroy()
        if blur then blur:Destroy() end
        if sound then 
            sound.PlaybackSpeed = 1
            TweenService:Create(sound, TweenInfo.new(1), {Volume = 0}):Play()
            task.wait(1); sound:Stop(); sound:Destroy()
        end

        LoadMainPanel()
    end)
end

-- Iniciar secuencia
LoadIntro()
