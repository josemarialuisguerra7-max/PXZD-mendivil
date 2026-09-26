-- ==============================================================================
--  PXZD HUB | VERSIÓN FINAL CON MÓDULO HORIZON INTEGRADO EN UI
-- ==============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local GuiParent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

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

-- Teletransporte instantáneo a biomas con bypass anti-cheat
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

-- ==================== INTERFAZ GRÁFICA UNIFICADA ====================
pcall(function()
    if GuiParent:FindFirstChild("PXZD_FinalHubGui") then GuiParent.PXZD_FinalHubGui:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", GuiParent)
    ScreenGui.Name = "PXZD_FinalHubGui"
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
    Title.Text = "⚡ PXZD HUB | CONTROL PANEL ⚡"
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
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    ScrollingFrame.ScrollBarThickness = 4

    local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)

    -- TARJETA DE HORIZON HUB ANTI GUARD (ESTILO CHEMXHUB CON BOTÓN EXECUTE)
    local HorizonCard = Instance.new("Frame", ScrollingFrame)
    HorizonCard.Size = UDim2.new(1, 0, 0, 50)
    HorizonCard.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Instance.new("UICorner", HorizonCard).CornerRadius = UDim.new(0, 6)

    local HorizonLabel = Instance.new("TextLabel", HorizonCard)
    HorizonLabel.Size = UDim2.new(0.6, 0, 1, 0)
    HorizonLabel.Position = UDim2.new(0.05, 0, 0, 0)
    HorizonLabel.BackgroundTransparency = 1
    HorizonLabel.Text = "Horizon Hub Anti Guard"
    HorizonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    HorizonLabel.Font = Enum.Font.GothamBold
    HorizonLabel.TextSize = 11
    HorizonLabel.TextXAlignment = Enum.TextXAlignment.Left

    local HorizonExecBtn = Instance.new("TextButton", HorizonCard)
    HorizonExecBtn.Size = UDim2.new(0.32, 0, 0.7, 0)
    HorizonExecBtn.Position = UDim2.new(0.64, 0, 0.15, 0)
    HorizonExecBtn.BackgroundColor3 = Color3.fromRGB(230, 110, 10) -- Naranja clásico de Execute
    HorizonExecBtn.Text = "Execute"
    HorizonExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HorizonExecBtn.Font = Enum.Font.GothamBold
    HorizonExecBtn.TextSize = 11
    Instance.new("UICorner", HorizonExecBtn).CornerRadius = UDim.new(0, 6)

    HorizonExecBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().script_key = "Trial"
            loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/6582551b42d21c6b7eb55f1d76d8d50ce53cb35592093d6615b5e83437594dc0.lua"))()
            HorizonExecBtn.Text = "Loaded!"
            HorizonExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
        end)
    end)

    -- SEPARADOR VISUAL DE BIOMAS
    local Separator = Instance.new("TextLabel", ScrollingFrame)
    Separator.Size = UDim2.new(1, 0, 0, 25)
    Separator.BackgroundTransparency = 1
    Separator.Text = "─── TELEPORT A BIOMAS / HUEVOS ───"
    Separator.TextColor3 = Color3.fromRGB(150, 150, 160)
    Separator.Font = Enum.Font.GothamBold
    Separator.TextSize = 10

    -- LISTA DE BOTONES DE BIOMAS
    for bName, cframeData in pairs(BiomesMap) do
        local Btn = Instance.new("TextButton", ScrollingFrame)
        Btn.Size = UDim2.new(1, 0, 0, 38)
        if bName:find("Cherry Blossom") then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
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
