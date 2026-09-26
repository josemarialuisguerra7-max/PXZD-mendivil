-- ==============================================================================
--  PXZD HUB ORIGINAL (CON INTRO, MÚSICA Y HORIZON HUB INTEGRADO)
-- ==============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local GuiParent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- 1. INTRO Y MÚSICA DE FONDO ORIGINAL
pcall(function()
    if GuiParent:FindFirstChild("PXZD_IntroGui") then GuiParent.PXZD_IntroGui:Destroy() end
    
    local introSound = Instance.new("Sound", SoundService)
    introSound.SoundId = "rbxassetid://9069653225"
    introSound.Volume = 1
    introSound:Play()

    local IntroGui = Instance.new("ScreenGui", GuiParent)
    IntroGui.Name = "PXZD_IntroGui"
    IntroGui.ResetOnSpawn = false

    local IntroFrame = Instance.new("Frame", IntroGui)
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    IntroFrame.BackgroundTransparency = 0

    local LogoText = Instance.new("TextLabel", IntroFrame)
    LogoText.Size = UDim2.new(0, 400, 0, 100)
    LogoText.Position = UDim2.new(0.5, -200, 0.5, -50)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "⚡ PXZD HUB ⚡"
    LogoText.TextColor3 = Color3.fromRGB(0, 255, 100)
    LogoText.Font = Enum.Font.GothamBlack
    LogoText.TextSize = 36
    LogoText.TextTransparency = 1

    task.spawn(function()
        for i = 1, 0, -0.1 do
            LogoText.TextTransparency = i
            task.wait(0.03)
        end
        task.wait(1.5)
        for i = 0, 1, 0.1 do
            LogoText.TextTransparency = i
            IntroFrame.BackgroundTransparency = i
            task.wait(0.03)
        end
        IntroGui:Destroy()
        introSound:Destroy()
    end)
end)

-- 2. FUNCIONES DE ARRASTRE Y TELETRANSPORTE
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

local function InstantTeleport(targetCFrame)
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local oldVel = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.CFrame = targetCFrame + Vector3.new(0, 4, 0)
            task.wait(0.02)
            hrp.AssemblyLinearVelocity = oldVel
        end
    end)
end

local BiomesMap = {
    ["🌲 Forest (Inicio)"] = CFrame.new(0, 5, 0),
    ["🌊 Lake (Swan)"] = CFrame.new(0, 5, -250),
    ["🏜️ Desert (Scorpion)"] = CFrame.new(0, 5, -600),
    ["🐅 Jungle (Tiger)"] = CFrame.new(0, 5, -1000),
    ["❄️ Snow (Yeti)"] = CFrame.new(0, 5, -1500),
    ["🌋 Volcano (Hellhound)"] = CFrame.new(0, 5, -2200),
    ["🐙 Abyss Ocean (Moby)"] = CFrame.new(0, 5, -3000),
    ["🦖 Prehistoric (T-Rex)"] = CFrame.new(0, 5, -4000),
    ["🌌 Cosmic (Dragon)"] = CFrame.new(0, 5, -5500),
    ["🌸 Cherry Blossom (Oni Tiger)"] = CFrame.new(0, 5, -7500),
    ["🏛️ Titan Temple"] = CFrame.new(0, 5, -9500),
    ["⚡ Angels & Demons"] = CFrame.new(0, 5, -12000),
}

-- 3. INTERFAZ PRINCIPAL DESPUÉS DE LA INTRO
task.delay(2.2, function()
    pcall(function()
        if GuiParent:FindFirstChild("PXZD_MainGui") then GuiParent.PXZD_MainGui:Destroy() end
        local ScreenGui = Instance.new("ScreenGui", GuiParent)
        ScreenGui.Name = "PXZD_MainGui"
        ScreenGui.ResetOnSpawn = false

        local Main = Instance.new("Frame", ScreenGui)
        Main.Size = UDim2.new(0, 310, 0, 440)
        Main.Position = UDim2.new(0.03, 0, 0.2, 0)
        Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        Main.BorderSizePixel = 0
        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

        local Header = Instance.new("Frame", Main)
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.BackgroundTransparency = 1
        MakeDraggable(Main, Header)

        local Title = Instance.new("TextLabel", Header)
        Title.Size = UDim2.new(1, -40, 1, 0)
        Title.Position = UDim2.new(0, 12, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "⚡ PXZD HUB | STEAL AN EGG ⚡"
        Title.TextColor3 = Color3.fromRGB(0, 255, 100)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 11
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local CloseBtn = Instance.new("TextButton", Header)
        CloseBtn.Size = UDim2.new(0, 24, 0, 24)
        CloseBtn.Position = UDim2.new(1, -32, 0, 8)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 11
        Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
        CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

        local ScrollingFrame = Instance.new("ScrollingFrame", Main)
        ScrollingFrame.Size = UDim2.new(0.92, 0, 0.82, 0)
        ScrollingFrame.Position = UDim2.new(0.04, 0, 0.14, 0)
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 850)
        ScrollingFrame.ScrollBarThickness = 4

        local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 6)

        -- MÓDULO DE HORIZON HUB ANTI GUARD (INTEGRADO EN LA LISTA)
        local HorizonCard = Instance.new("Frame", ScrollingFrame)
        HorizonCard.Size = UDim2.new(1, 0, 0, 42)
        HorizonCard.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
        Instance.new("UICorner", HorizonCard).CornerRadius = UDim.new(0, 6)

        local HorizonLabel = Instance.new("TextLabel", HorizonCard)
        HorizonLabel.Size = UDim2.new(0.6, 0, 1, 0)
        HorizonLabel.Position = UDim2.new(0.04, 0, 0, 0)
        HorizonLabel.BackgroundTransparency = 1
        HorizonLabel.Text = "Horizon Hub Anti Guard"
        HorizonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        HorizonLabel.Font = Enum.Font.GothamBold
        HorizonLabel.TextSize = 11
        HorizonLabel.TextXAlignment = Enum.TextXAlignment.Left

        local HorizonExecBtn = Instance.new("TextButton", HorizonCard)
        HorizonExecBtn.Size = UDim2.new(0.34, 0, 0.7, 0)
        HorizonExecBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
        HorizonExecBtn.BackgroundColor3 = Color3.fromRGB(230, 110, 10)
        HorizonExecBtn.Text = "Execute"
        HorizonExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        HorizonExecBtn.Font = Enum.Font.GothamBold
        HorizonExecBtn.TextSize = 11
        Instance.new("UICorner", HorizonExecBtn).CornerRadius = UDim.new(0, 5)

        HorizonExecBtn.MouseButton1Click:Connect(function()
            pcall(function()
                getgenv().script_key = "Trial"
                loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/6582551b42d21c6b7eb55f1d76d8d50ce53cb35592093d6615b5e83437594dc0.lua"))()
                HorizonExecBtn.Text = "Executed!"
                HorizonExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
            end)
        end)

        -- LISTA DE BIOMAS
        for bName, cframeData in pairs(BiomesMap) do
            local Btn = Instance.new("TextButton", ScrollingFrame)
            Btn.Size = UDim2.new(1, 0, 0, 38)
            if bName:find("Cherry Blossom") then
                Btn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
            else
                Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            end
            Btn.Text = bName
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 11
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

            Btn.MouseButton1Click:Connect(function()
                InstantTeleport(cframeData)
            end)
        end
    end)
end)
