-- ==============================================================================
--  PXZD HUB | OWNER EDITION (RAINBOW & BUBBLES CLEAN CACHE)
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

-- ==================== PANTALLA DE ACTUALIZACIÓN (OTROS) ====================
local function ShowUpdateScreen()
    pcall(function()
        local blur = Instance.new("BlurEffect", Lighting)
        blur.Name = "PxzdBlur"; blur.Size = 22

        local sound = Instance.new("Sound", SoundService)
        sound.Name = "PxzdSound"; sound.SoundId = AUDIO; sound.Volume = 0.3; sound.Looped = true; sound.TimePosition = 24
        task.spawn(function() sound:Play() end)

        if GuiParent:FindFirstChild("PxzdUpdateGui") then GuiParent.PxzdUpdateGui:Destroy() end
        local Gui = Instance.new("ScreenGui", GuiParent)
        Gui.Name = "PxzdUpdateGui"; Gui.ResetOnSpawn = false; Gui.IgnoreGuiInset = true

        local Bg = Instance.new("Frame", Gui)
        Bg.Size = UDim2.new(1,0,1,0); Bg.BackgroundColor3 = Color3.fromRGB(12, 5, 18); Bg.BackgroundTransparency = 0.15

        local Folder = Instance.new("Folder", Gui)
        local active = true
        task.spawn(function()
            while active and Gui.Parent do
                task.spawn(function()
                    if not active then return end
                    local b = Instance.new("ImageLabel", Folder)
                    local sz = math.random(30, 60)
                    b.Size = UDim2.new(0, sz, 0, sz)
                    b.Position = UDim2.new(math.random(5, 95)/100, 0, 1.1, 0)
                    b.BackgroundTransparency = 1; b.Image = LOGO; b.ImageTransparency = math.random(35, 65)/100
                    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
                    local tw = TweenService:Create(b, TweenInfo.new(math.random(4, 7), Enum.EasingStyle.Sine), {Position = UDim2.new(b.Position.X.Scale, math.random(-50, 50), -0.2, 0), ImageTransparency = 1})
                    tw:Play()
                    tw.Completed:Connect(function() b:Destroy() end)
                end)
                task.wait(0.2)
            end
        end)

        local Frame = Instance.new("Frame", Gui)
        Frame.Size = UDim2.new(0, 420, 0, 280); Frame.Position = UDim2.new(0.5, -210, 0.5, -140)
        Frame.BackgroundColor3 = Color3.fromRGB(18, 10, 25); Frame.BorderSizePixel = 0
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
        local stroke = Instance.new("UIStroke", Frame)
        stroke.Thickness = 2.5
        ApplyRainbowStroke(stroke)
        MakeDraggable(Frame, Frame)

        local Close = Instance.new("TextButton", Frame)
        Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -38, 0, 8)
        Close.BackgroundColor3 = Color3.fromRGB(60, 20, 20); Close.Text = "✕"; Close.TextColor3 = Color3.fromRGB(255,255,255); Close.Font = Enum.Font.GothamBold; Close.TextSize = 14
        Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
        Close.MouseButton1Click:Connect(function()
            active = false
            if sound then sound:Stop(); sound:Destroy() end
            if blur then blur:Destroy() end
            Gui:Destroy()
        end)

        local Img = Instance.new("ImageLabel", Frame)
        Img.Size = UDim2.new(0, 85, 0, 85); Img.Position = UDim2.new(0.5, -42, 0, 15); Img.BackgroundTransparency = 1; Img.Image = LOGO
        Instance.new("UICorner", Img).CornerRadius = UDim.new(1, 0)
        local imgStroke = Instance.new("UIStroke", Img)
        imgStroke.Thickness = 2
        ApplyRainbowStroke(imgStroke)

        local Txt = Instance.new("TextLabel", Frame)
        Txt.Size = UDim2.new(1, 0, 0, 35); Txt.Position = UDim2.new(0, 0, 0, 105); Txt.BackgroundTransparency = 1
        Txt.Text = "⚠️ ¡ESTAMOS ACTUALIZANDO! ⚠️"; Txt.Font = Enum.Font.GothamBlack; Txt.TextSize = 18; Txt.TextColor3 = Color3.fromRGB(255,255,255)

        local Msg = Instance.new("TextLabel", Frame)
        Msg.Size = UDim2.new(1, -30, 0, 50); Msg.Position = UDim2.new(0, 15, 0, 142); Msg.BackgroundTransparency = 1
        Msg.Text = "este script no funciona unete al dc o el Wtshp Carbius123 in top👑"
        Msg.Font = Enum.Font.GothamBold; Msg.TextSize = 12; Msg.TextColor3 = Color3.fromRGB(0, 150, 255)
        Msg.TextWrapped = true; Msg.TextXAlignment = Enum.TextXAlignment.Center
    end)
end

-- ==================== INTRO Y MENÚ (OWNER: CARBIUS123) ====================
local function LoadOwnerPanel()
    pcall(function()
        local blur = Instance.new("BlurEffect", Lighting)
        blur.Name = "PxzdIntroBlur"; blur.Size = 20

        local sound = Instance.new("Sound", SoundService)
        sound.Name = "PxzdIntroSound"; sound.SoundId = AUDIO; sound.Volume = 0; sound.TimePosition = 24
        task.spawn(function() 
            sound:Play() 
            TweenService:Create(sound, TweenInfo.new(2), {Volume = 0.25}):Play()
        end)

        if GuiParent:FindFirstChild("PxzdOwnerGui") then GuiParent.PxzdOwnerGui:Destroy() end
        local IntroGui = Instance.new("ScreenGui", GuiParent)
        IntroGui.Name = "PxzdOwnerGui"; IntroGui.ResetOnSpawn = false; IntroGui.IgnoreGuiInset = true

        local Bg = Instance.new("Frame", IntroGui)
        Bg.Size = UDim2.new(1,0,1,0); Bg.BackgroundColor3 = Color3.fromRGB(10, 4, 15); Bg.BackgroundTransparency = 0.2

        -- Burbujas flotantes con tu logo en la intro
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
        Title.Text = "👑 Bienvenido Owner 👑"; Title.Font = Enum.Font.FredokaOne; Title.TextSize = 26; Title.TextColor3 = Color3.fromRGB(255,255,255)

        local BarBg = Instance.new("Frame", Center)
        BarBg.Size = UDim2.new(0, 240, 0, 6); BarBg.Position = UDim2.new(0.5, -120, 0.75, 0); BarBg.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
        Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

        local BarFill = Instance.new("Frame", BarBg)
        BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

        TweenService:Create(BarFill, TweenInfo.new(4), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(4.5)

        activeBubbles = false
        IntroGui:Destroy()
        if blur then blur:Destroy() end
        if sound then 
            TweenService:Create(sound, TweenInfo.new(1), {Volume = 0}):Play()
            task.wait(1); sound:Stop(); sound:Destroy()
        end

        -- CONSTRUCCIÓN DEL MENÚ REAL
        if GuiParent:FindFirstChild("PxzdMenuGui") then GuiParent.PxzdMenuGui:Destroy() end
        local MenuGui = Instance.new("ScreenGui", GuiParent)
        MenuGui.Name = "PxzdMenuGui"; MenuGui.ResetOnSpawn = false

        local Main = Instance.new("Frame", MenuGui)
        Main.Size = UDim2.new(0, 380, 0, 280); Main.Position = UDim2.new(0.5, -190, 0.5, -140)
        Main.BackgroundColor3 = Color3.fromRGB(15, 8, 15); Main.BorderSizePixel = 0; Main.ClipsDescendants = true
        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
        local mainStroke = Instance.new("UIStroke", Main)
        mainStroke.Thickness = 2.5
        ApplyRainbowStroke(mainStroke)

        local Header = Instance.new("Frame", Main)
        Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundTransparency = 1
        MakeDraggable(Main, Header)

        local TitleLbl = Instance.new("TextLabel", Header)
        TitleLbl.Size = UDim2.new(1, -40, 1, 0); TitleLbl.Position = UDim2.new(0, 15, 0, 0); TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = "⚡ CARBIUS123 IN TOP ⚡"; TitleLbl.TextColor3 = Color3.fromRGB(0, 140, 255); TitleLbl.Font = Enum.Font.GothamBlack; TitleLbl.TextSize = 14; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local CloseMenu = Instance.new("TextButton", Header)
        CloseMenu.Size = UDim2.new(0, 24, 0, 24); CloseMenu.Position = UDim2.new(1, -32, 0, 8)
        CloseMenu.BackgroundColor3 = Color3.fromRGB(60, 20, 20); CloseMenu.Text = "✕"; CloseMenu.TextColor3 = Color3.fromRGB(255,255,255); CloseMenu.Font = Enum.Font.GothamBold; CloseMenu.TextSize = 12
        Instance.new("UICorner", CloseMenu).CornerRadius = UDim.new(0, 6)
        CloseMenu.MouseButton1Click:Connect(function() Main.Visible = false end)

        -- Botón flotante para abrir/cerrar con borde arcoíris
        if GuiParent:FindFirstChild("PxzdToggleGui") then GuiParent.PxzdToggleGui:Destroy() end
        local ToggleGui = Instance.new("ScreenGui", GuiParent)
        ToggleGui.Name = "PxzdToggleGui"; ToggleGui.ResetOnSpawn = false

        local ToggleBtn = Instance.new("ImageButton", ToggleGui)
        ToggleBtn.Size = UDim2.new(0, 42, 0, 42); ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Image = LOGO
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        local toggleStroke = Instance.new("UIStroke", ToggleBtn)
        toggleStroke.Thickness = 2.5
        ApplyRainbowStroke(toggleStroke)
        MakeDraggable(ToggleBtn, ToggleBtn)
        ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

        -- Lista de funciones dentro del menú
        local Scroll = Instance.new("ScrollingFrame", Main)
        Scroll.Size = UDim2.new(1, -16, 1, -50); Scroll.Position = UDim2.new(0, 8, 0, 44); Scroll.BackgroundTransparency = 1; Scroll.BorderSizePixel = 0; Scroll.ScrollBarThickness = 3
        local UIList = Instance.new("UIListLayout", Scroll)
        UIList.Padding = UDim.new(0, 6); UIList.SortOrder = Enum.SortOrder.LayoutOrder

        local function AddRow(txt, target)
            local Row = Instance.new("Frame", Scroll)
            Row.Size = UDim2.new(1, -4, 0, 40); Row.BackgroundColor3 = Color3.fromRGB(22, 12, 18); Row.BackgroundTransparency = 0.2
            Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

            local Lbl = Instance.new("TextLabel", Row)
            Lbl.Size = UDim2.new(0.6, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1
            Lbl.Text = txt; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 11; Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Btn = Instance.new("TextButton", Row)
            Btn.Size = UDim2.new(0.35, 0, 0, 26); Btn.Position = UDim2.new(0.62, 0, 0.5, -13); Btn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
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

        AddRow("Mejorar Rendimiento 🥔", function()
            pcall(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.CastShadow = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
                end
                Lighting.GlobalShadows = false
            end)
        end)
        AddRow("Afk Lennon Premium", "https://raw.githubusercontent.com/lennonxscripts/lennonfarm/refs/heads/main/farmv1.lua")
        AddRow("Miranda Farm", "https://api.luarmor.net/files/v4/loaders/6b07a458832f08b2314f706f14723212.lua")
        AddRow("Server Premium 🤑", "https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua")
        AddRow("Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")

        Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
    end)
end

-- ==================== EJECUCIÓN SEGÚN USUARIO ====================
if LocalPlayer.Name == "Carbius123" then
    LoadOwnerPanel()
else
    ShowUpdateScreen()
end
