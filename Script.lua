-- ==============================================================================
--  CHEMXHUB | MODO ACTUALIZACIÓN & MÚSICA CONTINUA
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
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

-- Identificadores (Logo original de Pxxd Hub para la sección de actualización y audio)
local PXZD_LOGO_ID = "rbxassetid://108485396062507"
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

-- ==================== PANTALLA DE ACTUALIZACIÓN ====================
local function ShowUpdateScreen()
    pcall(function()
        local oldBlur = Lighting:FindFirstChild("ChemxUpdateBlur")
        if oldBlur then oldBlur:Destroy() end

        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Name = "ChemxUpdateBlur"
        blurEffect.Size = 22
        blurEffect.Parent = Lighting

        local oldSound = SoundService:FindFirstChild("ChemxUpdateMusic")
        if oldSound then oldSound:Destroy() end

        local updateSound = Instance.new("Sound")
        updateSound.Name = "ChemxUpdateMusic"
        updateSound.SoundId = INTRO_AUDIO_ID
        updateSound.Volume = 0.3
        updateSound.Looped = true -- La música se queda sonando continuamente hasta cerrar con la X
        updateSound.TimePosition = 24
        updateSound.Parent = SoundService
        
        task.spawn(function()
            pcall(function() updateSound:Play() end)
        end)

        if GuiParent:FindFirstChild("ChemxUpdateGui") then GuiParent.ChemxUpdateGui:Destroy() end

        local UpdateGui = Instance.new("ScreenGui")
        UpdateGui.Name = "ChemxUpdateGui"
        UpdateGui.ResetOnSpawn = false
        UpdateGui.IgnoreGuiInset = true
        UpdateGui.Parent = GuiParent

        local Background = Instance.new("Frame")
        Background.Size = UDim2.new(1, 0, 1, 0)
        Background.BackgroundColor3 = Color3.fromRGB(12, 5, 18)
        Background.BackgroundTransparency = 0.15
        Background.Parent = UpdateGui

        -- Contenedor de burbujas flotantes con Pxxd Hub
        local BubbleContainer = Instance.new("Folder")
        BubbleContainer.Name = "BubbleContainer"
        BubbleContainer.Parent = UpdateGui

        local activeBubbles = true
        task.spawn(function()
            math.randomseed(tick())
            while activeBubbles and UpdateGui and UpdateGui.Parent do
                task.spawn(function()
                    if not activeBubbles then return end
                    local bubble = Instance.new("ImageLabel")
                    local size = math.random(30, 60)
                    bubble.Size = UDim2.new(0, size, 0, size)
                    bubble.Position = UDim2.new(math.random(5, 95) / 100, 0, 1.1, 0)
                    bubble.BackgroundTransparency = 1
                    bubble.Image = PXZD_LOGO_ID
                    bubble.ImageTransparency = math.random(35, 65) / 100
                    bubble.Parent = BubbleContainer

                    Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

                    local targetY = -0.2
                    local duration = math.random(4, 7)
                    local wobbleOffset = math.random(-50, 50)

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
                task.wait(0.2)
            end
        end)

        -- Ventana principal flotante de Actualización
        local CenterFrame = Instance.new("Frame")
        CenterFrame.Size = UDim2.new(0, 420, 0, 280)
        CenterFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
        CenterFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 25)
        CenterFrame.BorderSizePixel = 0
        CenterFrame.Parent = UpdateGui

        Instance.new("UICorner", CenterFrame).CornerRadius = UDim.new(0, 14)

        local MainStroke = Instance.new("UIStroke")
        MainStroke.Color = Color3.fromRGB(255, 40, 40)
        MainStroke.Thickness = 2.5
        MainStroke.Parent = CenterFrame

        MakeDraggable(CenterFrame, CenterFrame)

        -- Botón X de cierre en la parte superior derecha
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -38, 0, 8)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 14
        CloseBtn.ZIndex = 5
        CloseBtn.Parent = CenterFrame
        Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

        CloseBtn.MouseButton1Click:Connect(function()
            activeBubbles = false
            if updateSound then
                updateSound:Stop()
                updateSound:Destroy()
            end
            if blurEffect then blurEffect:Destroy() end
            UpdateGui:Destroy()
        end)

        -- Logo Central de Pxxd Hub
        local LogoImage = Instance.new("ImageLabel")
        LogoImage.Size = UDim2.new(0, 85, 0, 85)
        LogoImage.Position = UDim2.new(0.5, -42, 0, 15)
        LogoImage.BackgroundTransparency = 1
        LogoImage.Image = PXZD_LOGO_ID
        LogoImage.Parent = CenterFrame
        Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

        local LogoStroke = Instance.new("UIStroke")
        LogoStroke.Thickness = 2.5
        LogoStroke.Color = Color3.fromRGB(0, 130, 255)
        LogoStroke.Parent = LogoImage

        -- Título: ¡ACTUALIZANDO!
        local TitleText = Instance.new("TextLabel")
        TitleText.Size = UDim2.new(1, 0, 0, 35)
        TitleText.Position = UDim2.new(0, 0, 0, 105)
        TitleText.BackgroundTransparency = 1
        TitleText.Text = "⚠️ ¡ESTAMOS ACTUALIZANDO! ⚠️"
        TitleText.Font = Enum.Font.GothamBlack
        TitleText.TextSize = 18
        TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleText.Parent = CenterFrame

        -- Mensaje en Letras Azules actualizado
        local MsgText = Instance.new("TextLabel")
        MsgText.Size = UDim2.new(1, -30, 0, 50)
        MsgText.Position = UDim2.new(0, 15, 0, 142)
        MsgText.BackgroundTransparency = 1
        MsgText.Text = "este script no funciona unete al dc o el Wtshp Carbius123 in top👑"
        MsgText.Font = Enum.Font.GothamBold
        MsgText.TextSize = 12
        MsgText.TextColor3 = Color3.fromRGB(0, 150, 255) -- Letras azules
        MsgText.TextWrapped = true
        MsgText.TextXAlignment = Enum.TextXAlignment.Center
        MsgText.Parent = CenterFrame

        -- Barra de Estado / Carga Estética Inferior
        local BarBG = Instance.new("Frame")
        BarBG.Size = UDim2.new(0, 320, 0, 6)
        BarBG.Position = UDim2.new(0.5, -160, 0, 225)
        BarBG.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
        BarBG.Parent = CenterFrame
        Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

        local BarFill = Instance.new("Frame")
        BarFill.Size = UDim2.new(1, 0, 1, 0)
        BarFill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
        BarFill.Parent = BarBG
        Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

        local BarGradient = Instance.new("UIGradient")
        BarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 40, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 130, 255))
        })
        BarGradient.Parent = BarFill

        local SubFooter = Instance.new("TextLabel")
        SubFooter.Size = UDim2.new(1, 0, 0, 20)
        SubFooter.Position = UDim2.new(0, 0, 0, 240)
        SubFooter.BackgroundTransparency = 1
        SubFooter.Text = "Presiona la [ X ] arriba a la derecha para salir."
        SubFooter.Font = Enum.Font.Gotham
        SubFooter.TextSize = 11
        SubFooter.TextColor3 = Color3.fromRGB(160, 160, 180)
        SubFooter.Parent = CenterFrame
    end)
end

-- Ejecutar la interfaz de Actualización
ShowUpdateScreen()
