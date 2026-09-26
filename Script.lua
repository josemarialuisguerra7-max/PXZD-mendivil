-- ==============================================================================
--  PXZD HUB + HORIZON HUB (CON BOTÓN DE ACCESO VISIBLE)
-- ==============================================================================

-- 1. Cargar Horizon Hub de forma segura
pcall(function()
    getgenv().script_key = "Trial"
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/6582551b42d21c6b7eb55f1d76d8d50ce53cb35592093d6615b5e83437594dc0.lua"))()
end)

-- 2. Interfaz y Teletransporte de PXZD Hub + Botón para Horizon
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

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

-- Teletransporte instantáneo a biomas
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

-- ==================== INTERFAZ PRINCIPAL PXZD ====================
pcall(function()
    if GuiParent:FindFirstChild("PXZD_UltimateGui") then GuiParent.PXZD_UltimateGui:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", GuiParent)
    ScreenGui.Name = "PXZD_UltimateGui"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 280, 0, 430)
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
    Title.Text = "⚡ PXZD HUB + HORIZON ⚡"
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

    -- Botón especial para forzar la apertura del menú de Horizon Hub por si usa tecla oculta
    local HorizonToggle = Instance.new("TextButton", Main)
    HorizonToggle.Size = UDim2.new(0.92, 0, 0, 36)
    HorizonToggle.Position = UDim2.new(0.04, 0, 0.11, 0)
    HorizonToggle.BackgroundColor3 = Color3.fromRGB(120, 40, 180)
    HorizonToggle.Text = "🔮 Abrir / Toggle Horizon Hub"
    HorizonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HorizonToggle.Font = Enum.Font.GothamBold
    HorizonToggle.TextSize = 11
    Instance.new("UICorner", HorizonToggle).CornerRadius = UDim.new(0, 6)
    
    HorizonToggle.MouseButton1Click:Connect(function()
        pcall(function()
            -- Simula la tecla Insert o RightShift que suelen usar los hubs de pago para abrirse
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
        end)
    end)

    local ScrollingFrame = Instance.new("ScrollingFrame", Main)
    ScrollingFrame.Size = UDim2.new(0.92, 0, 0.72, 0)
    ScrollingFrame.Position = UDim2.new(0.04, 0, 0.25, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
    ScrollingFrame.ScrollBarThickness = 4

    local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)

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
