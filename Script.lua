-- ==============================================================================
--  PXZD HUB IN TOP | EXCLUSIVE LOADER
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local LOGO_ID = "rbxassetid://108485396062507"
local AUDIO_ID = "rbxassetid://75500567967936"
local VIP_USER = "Carbius123"

if CoreGui:FindFirstChild("PxzdHubCore") then
    CoreGui.PxzdHubCore:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PxzdHubCore"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local function sendNotification(text)
    pcall(function()
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 200, 0, 30)
        Frame.Position = UDim2.new(1, -210, 1, -40)
        Frame.BackgroundColor3 = Color3.fromRGB(18, 13, 28)
        Frame.BorderSizePixel = 0
        Frame.Parent = ScreenGui

        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(168, 45, 255)
        UIStroke.Thickness = 1.5
        UIStroke.Parent = Frame

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, -10, 1, 0)
        TextLabel.Position = UDim2.new(0, 5, 0, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "[PXZD]: " .. text
        TextLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        TextLabel.TextSize = 10
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Parent = Frame

        task.delay(2, function()
            if Frame then Frame:Destroy() end
        end)
    end)
end

local function loadMainUI()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9000000000
    end)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 13, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(168, 45, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundColor3 = Color3.fromRGB(24, 16, 38)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "PXZD HUB IN TOP | LOADER"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    TitleLabel.TextSize = 11
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 22, 0, 22)
    MinBtn.Position = UDim2.new(1, -28, 0.5, -11)
    MinBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
    MinBtn.Text = "_"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 12
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TopBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Size = UDim2.fromOffset(40, 40)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(168, 45, 255)
    ToggleBtn.Image = LOGO_ID
    ToggleBtn.Visible = false
    ToggleBtn.Active = true
    ToggleBtn.Draggable = true
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ToggleBtn.Visible = true
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ToggleBtn.Visible = false
    end)

    local ScrollContainer = Instance.new("ScrollingFrame")
    ScrollContainer.Size = UDim2.new(1, -10, 1, -40)
    ScrollContainer.Position = UDim2.new(0, 5, 0, 36)
    ScrollContainer.BackgroundTransparency = 1
    ScrollContainer.BorderSizePixel = 0
    ScrollContainer.ScrollBarThickness = 3
    ScrollContainer.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollContainer

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Lista exclusiva de scripts
    local scriptList = {
        {Name = "LENNON FARM", Script = "https://raw.githubusercontent.com/lennonxscripts/lennonfarm/refs/heads/main/farmv1.lua"},
        {Name = "CHILLI HUB", Script = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"},
        {Name = "MIRANDA FARM AFK", Script = "https://api.luarmor.net/files/v4/loaders/6b07a458832f08b2314f706f14723212.lua"},
        {Name = "LENNON V3", Script = "https://raw.githubusercontent.com/lennonxscripts/lennonhubv3/refs/heads/main/stealanegg.lua"}
    }

    for i, data in ipairs(scriptList) do
        local ItemFrame = Instance.new("Frame")
        ItemFrame.LayoutOrder = i
        ItemFrame.Size = UDim2.new(1, -4, 0, 30)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(28, 20, 42)
        ItemFrame.Parent = ScrollContainer

        Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 5)

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0.65, 0, 1, 0)
        NameLabel.Position = UDim2.new(0, 8, 0, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = data.Name
        NameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        NameLabel.TextSize = 10
        NameLabel.Font = Enum.Font.GothamSemibold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = ItemFrame

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0.3, 0, 0.75, 0)
        ExecBtn.Position = UDim2.new(0.68, 0, 0.125, 0)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(168, 45, 255)
        ExecBtn.Text = "EJECUTAR"
        ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ExecBtn.TextSize = 9
        ExecBtn.Font = Enum.Font.GothamBold
        ExecBtn.Parent = ItemFrame

        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)

        ExecBtn.MouseButton1Click:Connect(function()
            sendNotification("Cargando " .. data.Name)
            pcall(function()
                loadstring(game:HttpGet(data.Script))()
            end)
        end)
    end
    sendNotification("PXZD Hub Cargado")
end

-- ==================== ANIMACIÓN DE INTRO Y MÚSICA CONFIGURADA ====================
local function playPxzdIntro()
    local bgMusic
    pcall(function()
        bgMusic = Instance.new("Sound")
        bgMusic.SoundId = AUDIO_ID
        bgMusic.Volume = 0.25 -- VOLUMEN MODERADO (25%)
        bgMusic.TimePosition = 13.5
        bgMusic.Parent = SoundService
        bgMusic:Play()
    end)

    local splashFrame = Instance.new("Frame")
    splashFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    splashFrame.Position = UDim2.fromScale(0.5, 0.5)
    splashFrame.Size = UDim2.fromOffset(200, 200)
    splashFrame.BackgroundTransparency = 1
    splashFrame.Parent = ScreenGui

    local splashLogo = Instance.new("ImageLabel")
    splashLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    splashLogo.Position = UDim2.fromScale(0.5, 0.4)
    splashLogo.Size = UDim2.fromOffset(110, 110)
    splashLogo.BackgroundTransparency = 1
    splashLogo.ImageTransparency = 1
    splashLogo.Image = LOGO_ID
    splashLogo.Parent = splashFrame

    local splashTitle = Instance.new("TextLabel")
    splashTitle.BackgroundTransparency = 1
    splashTitle.Position = UDim2.new(0, 0, 0.8, 0)
    splashTitle.Size = UDim2.new(1, 0, 0, 25)
    splashTitle.Font = Enum.Font.GothamBlack
    splashTitle.Text = "PXZD HUB IN TOP"
    splashTitle.TextColor3 = Color3.fromRGB(168, 45, 255)
    splashTitle.TextSize = 18
    splashTitle.TextTransparency = 1
    splashTitle.Parent = splashFrame

    TweenService:Create(splashLogo, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    TweenService:Create(splashTitle, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    task.wait(6)

    TweenService:Create(splashLogo, TweenInfo.new(1), {ImageTransparency = 1}):Play()
    TweenService:Create(splashTitle, TweenInfo.new(1), {TextTransparency = 1}):Play()
    
    if bgMusic then
        TweenService:Create(bgMusic, TweenInfo.new(1), {Volume = 0}):Play()
    end

    task.wait(1)

    if bgMusic then
        bgMusic:Stop()
        bgMusic:Destroy()
    end

    splashFrame:Destroy()
    loadMainUI()
end

-- ==================== COMPROBACIÓN VIP / KEY ====================
if LocalPlayer.Name:lower() == VIP_USER:lower() then
    playPxzdIntro()
else
    local keyFrame = Instance.new("Frame")
    keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    keyFrame.Position = UDim2.fromScale(0.5, 0.5)
    keyFrame.Size = UDim2.fromOffset(300, 180)
    keyFrame.BackgroundColor3 = Color3.fromRGB(18, 13, 28)
    keyFrame.Parent = ScreenGui

    Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "PXZD HUB - KEY"
    title.TextColor3 = Color3.fromRGB(0, 255, 128)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 14
    title.Parent = keyFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    keyBox.Size = UDim2.new(0.8, 0, 0, 32)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
    keyBox.PlaceholderText = "Ingresa Key (pxzd)"
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.TextSize = 12
    keyBox.Parent = keyFrame
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

    local submitBtn = Instance.new("TextButton")
    submitBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    submitBtn.Size = UDim2.new(0.8, 0, 0, 32)
    submitBtn.BackgroundColor3 = Color3.fromRGB(168, 45, 255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.Text = "INGRESAR"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.TextSize = 12
    submitBtn.Parent = keyFrame
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 6)

    submitBtn.MouseButton1Click:Connect(function()
        local inputKey = keyBox.Text:gsub("%s+", ""):lower()
        if inputKey == "pxzd" or inputKey == "pxzduser" then
            keyFrame:Destroy()
            playPxzdIntro()
        else
            keyBox.Text = ""
            keyBox.PlaceholderText = "Key Incorrecta!"
        end
    end)
end
