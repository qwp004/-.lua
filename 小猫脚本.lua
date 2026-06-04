-- ============================================
-- 小猫脚本 v9.1 - 白子修复版 (1/4)
-- 卡密验证 + 核心变量 + 主UI框架
-- 背景角色: 砂狼白子 (Blue Archive)
-- 适配: Roblox Delta注入器 (手机端)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ==================== 设备检测 ====================
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local IsPC = UserInputService.KeyboardEnabled

-- ==================== 卡密验证 ====================
local VALID_KEY = "KITTEN-INF"

local function SaveVerified(key)
    pcall(function()
        if not isfolder("KittenScript") then makefolder("KittenScript") end
        writefile("KittenScript/key_v91.json", HttpService:JSONEncode({key = key, time = os.time()}))
    end)
end

local function LoadVerified()
    local ok, result = pcall(function()
        local path = "KittenScript/key_v91.json"
        if isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            return data and data.key == VALID_KEY
        end
        return false
    end)
    return ok and result
end

-- ==================== 白子主题色 ====================
local SHIROKO_PRIMARY = Color3.fromRGB(100, 180, 255)
local SHIROKO_SECONDARY = Color3.fromRGB(200, 230, 255)
local SHIROKO_DARK = Color3.fromRGB(20, 30, 50)

-- ==================== 卡密UI ====================
local function CreateKeyUI()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KittenKeyV91"
    KeyGui.Parent = CoreGui
    KeyGui.ResetOnSpawn = false
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = SHIROKO_DARK
    Backdrop.BackgroundTransparency = 0.3
    Backdrop.Parent = KeyGui

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SHIROKO_DARK),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 60, 90)),
        ColorSequenceKeypoint.new(1, SHIROKO_DARK)
    })
    Gradient.Rotation = 45
    Gradient.Parent = Backdrop

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 420, 0, 280)
    Box.Position = UDim2.new(0.5, -210, 0.5, -140)
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Box.BorderSizePixel = 0
    Box.Parent = KeyGui
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 16)

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Thickness = 2
    BoxStroke.Color = SHIROKO_PRIMARY
    BoxStroke.Transparency = 0.5
    BoxStroke.Parent = Box

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "🐱 小猫脚本 v9.1"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 26
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = Box

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, 0, 0, 30)
    Sub.Position = UDim2.new(0, 0, 0, 45)
    Sub.BackgroundTransparency = 1
    Sub.Text = "砂狼白子主题版 | 请输入卡密"
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 14
    Sub.TextColor3 = SHIROKO_PRIMARY
    Sub.Parent = Box

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 45)
    KeyBox.Position = UDim2.new(0, 20, 0, 85)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    KeyBox.BorderSizePixel = 0
    KeyBox.Text = ""
    KeyBox.PlaceholderText = "输入卡密..."
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.TextSize = 15
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    KeyBox.Parent = Box
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

    local KeyBoxStroke = Instance.new("UIStroke")
    KeyBoxStroke.Thickness = 1.5
    KeyBoxStroke.Color = SHIROKO_PRIMARY
    KeyBoxStroke.Transparency = 0.7
    KeyBoxStroke.Parent = KeyBox

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 25)
    Status.Position = UDim2.new(0, 20, 0, 140)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 13
    Status.TextColor3 = Color3.fromRGB(255, 100, 100)
    Status.Parent = Box

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, -40, 0, 45)
    VerifyBtn.Position = UDim2.new(0, 20, 0, 175)
    VerifyBtn.BackgroundColor3 = SHIROKO_PRIMARY
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.Text = "验证卡密"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 16
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Parent = Box
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 10)

    VerifyBtn.MouseEnter:Connect(function()
        TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 200, 255)}):Play()
    end)
    VerifyBtn.MouseLeave:Connect(function()
        TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = SHIROKO_PRIMARY}):Play()
    end)

    local function Verify()
        local key = KeyBox.Text:gsub("%s+", "")
        if #key < 5 then Status.Text = "⚠️ 卡密不能为空" return end
        if key ~= VALID_KEY then Status.Text = "❌ 卡密无效" return end
        Status.TextColor3 = Color3.fromRGB(50, 255, 100)
        Status.Text = "✅ 验证成功! 欢迎回来~"
        SaveVerified(key)
        task.wait(0.8)
        KeyGui:Destroy()
        _G.KittenKeyVerified = true
    end

    VerifyBtn.MouseButton1Click:Connect(Verify)
    KeyBox.FocusLost:Connect(function(enter) if enter then Verify() end end)
end

if not LoadVerified() then
    CreateKeyUI()
    repeat task.wait(0.1) until _G.KittenKeyVerified == true
end

-- ============================================
-- 功能状态
-- ============================================
local Features = {
    LoopSpeed = { Enabled = false, Value = 16 },
    PlayerESP = { Enabled = false, TeamCheck = true },
    Aimbot = { Enabled = true, Active = false, FOV = 150, Smooth = 0.5, 
               ShowFOV = true, TeamCheck = true, WallCheck = true,
               TargetPart = "Head", MobileMode = false },
    NoClip = { Enabled = false },
    NightVision = { Enabled = false, Intensity = 10 },
    InfiniteJump = { Enabled = false },
    SuperJump = { Enabled = false, Power = 100 },
    Fly = { Enabled = false, Speed = 50 },
    Gravity = { Enabled = false, Value = 50 },
    GodMode = { Enabled = false },
    Invisible = { Enabled = false },
    ClickTP = { Enabled = false },
    AutoPickup = { Enabled = false, Range = 15 },
    ItemESP = { Enabled = false },
    PlayerInfo = { Enabled = false },
    AntiAFK = { Enabled = true },
    Coords = { Enabled = false },
    Fling = { Enabled = false, Range = 15, Power = 1000 },
    LoopTeleport = { Enabled = false },
    TeleportTarget = nil,
}

local Hotkeys = {
    AimbotToggle = Enum.KeyCode.Q,
    AimbotHold = Enum.KeyCode.MouseButton2,
    NoClip = Enum.KeyCode.N,
    Fly = Enum.KeyCode.F,
    GodMode = Enum.KeyCode.G,
    InfiniteJump = Enum.KeyCode.Space,
    ClickTP = Enum.KeyCode.LeftControl,
    NightVision = Enum.KeyCode.V,
    Invisible = Enum.KeyCode.I,
    SuperJump = Enum.KeyCode.LeftShift,
    ESP = Enum.KeyCode.E,
    Fling = Enum.KeyCode.R,
}

local MobileAimbot = {
    ButtonSize = 80,
    Position = UDim2.new(0, 20, 0.5, -40),
    Dragging = false,
    Active = false,
}

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    Gravity = Workspace.Gravity
}

-- ============================================
-- 跨段变量声明
-- ============================================
local ScreenGui, MainFrame, FloatBtn, BGImage
local ESPHighlights, ESPConnections = {}, {}
local InfoBillboards, InfoConnections = {}, {}
local ItemESPObjects = {}
local NoClipConn, OrigCollisions = nil, {}
local FlyLV = nil
local AntiAFKConn = nil
local InvisibleParts = {}
local AimbotBtn = nil
local FOVFrame = nil
local CoordLabel = nil
local PlayerListScroll = nil
local PlayerButtons = {}
local MobileAimbotBtn = nil
local MobileAimbotActive = false
local ItemESPUpdateTimer = 0
local AutoPickupTimer = 0
-- ============================================
-- 小猫脚本 v9.1 - 白子修复版 (2/4)
-- 主UI构建 + 白子主题 + 通用功能
-- ============================================

-- ============================================
-- 主UI - 适配手机端 (可缩放)
-- ============================================
ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KittenMobileV91"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 手机端适配尺寸
local UI_WIDTH = IsMobile and 340 or 600
local UI_HEIGHT = IsMobile and 420 or 320

MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
MainFrame.Position = UDim2.new(0.5, -UI_WIDTH/2, 0.5, -UI_HEIGHT/2)
MainFrame.BackgroundColor3 = SHIROKO_DARK
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- ==================== 白子主题背景 ====================
BGImage = Instance.new("ImageLabel")
BGImage.Name = "ShirokoBG"
BGImage.Size = UDim2.new(1, 0, 1, 0)
BGImage.Position = UDim2.new(0, 0, 0, 0)
BGImage.BackgroundTransparency = 1
-- 使用外部图片URL (Zerochan白子图)
BGImage.Image = "https://s1.zerochan.net/Sunaookami.Shiroko.600.3513326.jpg"
BGImage.ImageColor3 = SHIROKO_SECONDARY
BGImage.ImageTransparency = 0.85
BGImage.ScaleType = Enum.ScaleType.Crop
BGImage.Parent = MainFrame

-- 渐变背景叠加
local BGGlow = Instance.new("UIGradient")
BGGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 25, 40)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(30, 50, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(20, 40, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 25, 40))
})
BGGlow.Rotation = 135
BGGlow.Parent = BGImage

-- 背景暗化层
local BGDarken = Instance.new("Frame")
BGDarken.Size = UDim2.new(1, 0, 1, 0)
BGDarken.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
BGDarken.BackgroundTransparency = 0.5
BGDarken.Parent = MainFrame

-- ==================== 标题栏（可拖拽）====================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
TitleBar.BackgroundTransparency = 0.2
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -140, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🐱 小猫脚本 v9.1 | 白子版"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = IsMobile and 14 or 16
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- 设备标识
local DeviceLabel = Instance.new("TextLabel")
DeviceLabel.Size = UDim2.new(0, 80, 0, 20)
DeviceLabel.Position = UDim2.new(0, IsMobile and 160 or 220, 0, 10)
DeviceLabel.BackgroundTransparency = 1
DeviceLabel.Text = IsMobile and "📱 手机端" or "💻 电脑端"
DeviceLabel.Font = Enum.Font.GothamBold
DeviceLabel.TextSize = 11
DeviceLabel.TextColor3 = IsMobile and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 200, 255)
DeviceLabel.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -72, 0.5, -16)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- 拖拽
local dragging = false
local dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ==================== 左侧栏 ====================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, IsMobile and 100 or 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 25, 38)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local GeneralBtn = Instance.new("TextButton")
GeneralBtn.Size = UDim2.new(1, 0, 0, 34)
GeneralBtn.BackgroundColor3 = SHIROKO_PRIMARY
GeneralBtn.Text = "📦 通用脚本"
GeneralBtn.Font = Enum.Font.GothamBold
GeneralBtn.TextSize = 12
GeneralBtn.TextColor3 = Color3.new(1, 1, 1)
GeneralBtn.Parent = Sidebar
Instance.new("UICorner", GeneralBtn).CornerRadius = UDim.new(0, 8)

-- ==================== 右侧内容 ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, IsMobile and -100 or -120, 1, -40)
ContentFrame.Position = UDim2.new(0, IsMobile and 100 or 120, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ==================== 悬浮球（左上角）====================
FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatBtn"
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0, 20)
FloatBtn.BackgroundColor3 = SHIROKO_PRIMARY
FloatBtn.Text = "🐱"
FloatBtn.TextSize = 24
FloatBtn.Parent = ScreenGui
FloatBtn.Visible = false
FloatBtn.Active = true
FloatBtn.Selectable = true
FloatBtn.ZIndex = 10
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

local fStroke = Instance.new("UIStroke")
fStroke.Thickness = 2
fStroke.Color = SHIROKO_SECONDARY
fStroke.Parent = FloatBtn

local fDragging = false
local fDragStart = nil
local fStartPos = nil
local fClickThreshold = 5

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = false
        fDragStart = input.Position
        fStartPos = FloatBtn.Position
    end
end)
FloatBtn.InputChanged:Connect(function(input)
    if fDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - fDragStart
        if math.abs(delta.X) > fClickThreshold or math.abs(delta.Y) > fClickThreshold then
            fDragging = true
            FloatBtn.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
        end
    end
end)
FloatBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not fDragging then
            MainFrame.Visible = true
            FloatBtn.Visible = false
        end
        fDragging = false
        fDragStart = nil
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatBtn.Visible = true
end)

-- ==================== 关闭确认 + 清理 ====================
local function CleanupAllFeatures()
    for k, v in pairs(Features) do
        if type(v) == "table" then
            if v.Enabled ~= nil then v.Enabled = false end
            if v.Active ~= nil then v.Active = false end
        end
    end
    Features.TeleportTarget = nil
    MobileAimbotActive = false

    if FlyLV then 
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local att = hrp:FindFirstChild("FlyAttachment")
                if att then att:Destroy() end
            end
        end)
        FlyLV:Destroy() 
        FlyLV = nil 
    end

    if NoClipConn then NoClipConn:Disconnect() NoClipConn = nil end
    if AntiAFKConn then AntiAFKConn:Disconnect() AntiAFKConn = nil end

    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and OrigCollisions[part] ~= nil then
                part.CanCollide = OrigCollisions[part]
            end
        end
    end
    OrigCollisions = {}

    Workspace.Gravity = OriginalLighting.Gravity
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.FogEnd = OriginalLighting.FogEnd

    for part, old in pairs(InvisibleParts) do
        if part and part.Parent then part.Transparency = old end
    end
    InvisibleParts = {}

    for player, hl in pairs(ESPHighlights) do
        if ESPConnections[player] then ESPConnections[player]:Disconnect() end
        hl:Destroy()
    end
    ESPHighlights, ESPConnections = {}, {}

    for player, bb in pairs(InfoBillboards) do
        if InfoConnections[player] then InfoConnections[player]:Disconnect() end
        bb:Destroy()
    end
    InfoBillboards, InfoConnections = {}, {}

    for obj, bb in pairs(ItemESPObjects) do
        bb:Destroy()
    end
    ItemESPObjects = {}

    if AimbotBtn then AimbotBtn:Destroy() AimbotBtn = nil end
    if FOVFrame then FOVFrame:Destroy() FOVFrame = nil end
    if CoordLabel then CoordLabel:Destroy() CoordLabel = nil end
    if MobileAimbotBtn then MobileAimbotBtn:Destroy() MobileAimbotBtn = nil end
end

CloseBtn.MouseButton1Click:Connect(function()
    local Modal = Instance.new("ScreenGui")
    Modal.Name = "CloseConfirm"
    Modal.Parent = CoreGui
    Modal.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Modal.ResetOnSpawn = false

    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
    Backdrop.BackgroundTransparency = 0.5
    Backdrop.Parent = Modal

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 320, 0, 170)
    Box.Position = UDim2.new(0.5, -160, 0.5, -85)
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Box.BorderSizePixel = 0
    Box.Parent = Modal
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 12)

    local WarnTitle = Instance.new("TextLabel")
    WarnTitle.Size = UDim2.new(1, 0, 0, 40)
    WarnTitle.Position = UDim2.new(0, 0, 0, 8)
    WarnTitle.BackgroundTransparency = 1
    WarnTitle.Text = "⚠️ 确认关闭脚本"
    WarnTitle.Font = Enum.Font.GothamBold
    WarnTitle.TextSize = 18
    WarnTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    WarnTitle.Parent = Box

    local WarnText = Instance.new("TextLabel")
    WarnText.Size = UDim2.new(1, -30, 0, 50)
    WarnText.Position = UDim2.new(0, 15, 0, 48)
    WarnText.BackgroundTransparency = 1
    WarnText.Text = "关闭后将自动停止所有已开启功能并清理内存，是否确认？"
    WarnText.Font = Enum.Font.Gotham
    WarnText.TextSize = 13
    WarnText.TextColor3 = Color3.fromRGB(200, 200, 200)
    WarnText.TextWrapped = true
    WarnText.Parent = Box

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0, 120, 0, 34)
    YesBtn.Position = UDim2.new(0, 25, 1, -48)
    YesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    YesBtn.Text = "确认关闭"
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextSize = 13
    YesBtn.TextColor3 = Color3.new(1, 1, 1)
    YesBtn.Parent = Box
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 8)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0, 120, 0, 34)
    NoBtn.Position = UDim2.new(1, -145, 1, -48)
    NoBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
    NoBtn.Text = "取消"
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextSize = 13
    NoBtn.TextColor3 = Color3.new(1, 1, 1)
    NoBtn.Parent = Box
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 8)

    YesBtn.MouseButton1Click:Connect(function()
        CleanupAllFeatures()
        task.wait(0.05)
        ScreenGui:Destroy()
        Modal:Destroy()
    end)
    NoBtn.MouseButton1Click:Connect(function()
        Modal:Destroy()
    end)
end)
-- ============================================
-- 小猫脚本 v9.1 - 白子修复版 (3/4)
-- UI组件函数 + 功能页面 + 快捷键系统
-- ============================================

-- ==================== UI组件函数 ====================
local function CreateSection(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -6, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = "▸ " .. text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextColor3 = SHIROKO_PRIMARY
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
    return Label
end

local function CreateToggle(parent, name, default, callback, platform)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -6, 0, 36)
    Container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Container.BackgroundTransparency = 0.3
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local platformText = platform or "🌐"

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, IsMobile and 160 or 220, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = platformText .. " " .. name
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 48, 0, 24)
    Btn.Position = UDim2.new(1, -56, 0.5, -12)
    Btn.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
    Btn.Text = default and "ON" or "OFF"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local enabled = default
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
        Btn.Text = enabled and "ON" or "OFF"
        if callback then callback(enabled) end
    end)

    return { GetValue = function() return enabled end }
end

local function CreateSlider(parent, name, min, max, default, callback, platform)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -6, 0, 56)
    Container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Container.BackgroundTransparency = 0.3
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local platformText = platform or "🌐"

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 0, 18)
    Title.Position = UDim2.new(0, 10, 0, 3)
    Title.BackgroundTransparency = 1
    Title.Text = platformText .. " " .. name
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Container

    local NumBox = Instance.new("TextBox")
    NumBox.Size = UDim2.new(0, 55, 0, 20)
    NumBox.Position = UDim2.new(1, -63, 0, 3)
    NumBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    NumBox.Text = tostring(default)
    NumBox.Font = Enum.Font.GothamBold
    NumBox.TextSize = 11
    NumBox.TextColor3 = Color3.new(1, 1, 1)
    NumBox.Parent = Container
    Instance.new("UICorner", NumBox).CornerRadius = UDim.new(0, 6)

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -16, 0, 5)
    SliderBg.Position = UDim2.new(0, 8, 0, 30)
    SliderBg.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    SliderBg.Parent = Container
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = SHIROKO_PRIMARY
    Fill.Parent = SliderBg
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
    Knob.BackgroundColor3 = SHIROKO_SECONDARY
    Knob.Text = ""
    Knob.Parent = SliderBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local currentValue = default
    local function UpdateValue(value)
        currentValue = math.clamp(value, min, max)
        local p = (currentValue - min) / (max - min)
        Fill.Size = UDim2.new(p, 0, 1, 0)
        Knob.Position = UDim2.new(p, -8, 0.5, -8)
        NumBox.Text = string.format("%.1f", currentValue)
        if callback then callback(currentValue) end
    end

    local isDragging = false
    local function HandleInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            UpdateValue(min + pos * (max - min))
        end
    end

    SliderBg.InputBegan:Connect(HandleInput)
    Knob.InputBegan:Connect(HandleInput)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            UpdateValue(min + pos * (max - min))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    NumBox.FocusLost:Connect(function()
        local num = tonumber(NumBox.Text)
        if num then UpdateValue(num) else NumBox.Text = string.format("%.1f", currentValue) end
    end)

    return { GetValue = function() return currentValue end }
end

-- ==================== 通用脚本滚动框 ====================
local TabGeneral = Instance.new("ScrollingFrame")
TabGeneral.Size = UDim2.new(1, -10, 1, -10)
TabGeneral.Position = UDim2.new(0, 5, 0, 5)
TabGeneral.BackgroundTransparency = 1
TabGeneral.ScrollBarThickness = 3
TabGeneral.ScrollBarImageColor3 = SHIROKO_PRIMARY
TabGeneral.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabGeneral.Parent = ContentFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 6)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabGeneral

local TabPad = Instance.new("UIPadding")
TabPad.PaddingBottom = UDim.new(0, 8)
TabPad.Parent = TabGeneral

-- ==================== 快捷键提示 (仅电脑端) ====================
if IsPC then
    CreateSection(TabGeneral, "💻 电脑端快捷键")

    local HotkeyFrame = Instance.new("Frame")
    HotkeyFrame.Size = UDim2.new(1, -6, 0, 200)
    HotkeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    HotkeyFrame.BackgroundTransparency = 0.3
    HotkeyFrame.Parent = TabGeneral
    Instance.new("UICorner", HotkeyFrame).CornerRadius = UDim.new(0, 8)

    local HotkeyText = Instance.new("TextLabel")
    HotkeyText.Size = UDim2.new(1, -10, 1, -10)
    HotkeyText.Position = UDim2.new(0, 5, 0, 5)
    HotkeyText.BackgroundTransparency = 1
    HotkeyText.Text = [[
Q - 切换自瞄开关
右键按住 - 按住自瞄
N - 穿墙系统
F - 飞行系统
G - 上帝模式
V - 夜视系统
I - 隐形模式
E - 玩家透视
R - 甩飞玩家
左Ctrl+点击 - 点击传送
空格(开启后) - 无限跳跃
左Shift(开启后) - 超级跳跃
    ]]
    HotkeyText.Font = Enum.Font.Gotham
    HotkeyText.TextSize = 11
    HotkeyText.TextColor3 = Color3.fromRGB(200, 200, 200)
    HotkeyText.TextXAlignment = Enum.TextXAlignment.Left
    HotkeyText.TextYAlignment = Enum.TextYAlignment.Top
    HotkeyText.Parent = HotkeyFrame
end

-- ==================== 移动功能 ====================
CreateSection(TabGeneral, "🌐 移动功能")
CreateToggle(TabGeneral, "循环速度", false, function(e) Features.LoopSpeed.Enabled = e end, "🌐")
CreateSlider(TabGeneral, "速度", 0, 200, 16, function(v) Features.LoopSpeed.Value = v end, "🌐")
CreateToggle(TabGeneral, "无限跳跃", false, function(e) Features.InfiniteJump.Enabled = e end, "🌐")
CreateToggle(TabGeneral, "超级跳跃", false, function(e) Features.SuperJump.Enabled = e end, "🌐")
CreateSlider(TabGeneral, "跳跃力度", 50, 300, 100, function(v) Features.SuperJump.Power = v end, "🌐")
CreateToggle(TabGeneral, "飞行系统", false, function(e) Features.Fly.Enabled = e end, "🌐")
CreateSlider(TabGeneral, "飞行速度", 10, 200, 50, function(v) Features.Fly.Speed = v end, "🌐")
CreateToggle(TabGeneral, "重力修改", false, function(e) Features.Gravity.Enabled = e end, "🌐")
CreateSlider(TabGeneral, "重力值", 0, 196, 50, function(v) Features.Gravity.Value = v end, "🌐")

-- ==================== 战斗功能 ====================
CreateSection(TabGeneral, "🌐 战斗功能")
CreateToggle(TabGeneral, "自瞄系统", true, function(e) Features.Aimbot.Enabled = e end, "🌐")

-- 手机端自瞄模式
if IsMobile then
    local MobileModeFrame = Instance.new("Frame")
    MobileModeFrame.Size = UDim2.new(1, -6, 0, 36)
    MobileModeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    MobileModeFrame.BackgroundTransparency = 0.3
    MobileModeFrame.Parent = TabGeneral
    Instance.new("UICorner", MobileModeFrame).CornerRadius = UDim.new(0, 8)

    local MobileModeTitle = Instance.new("TextLabel")
    MobileModeTitle.Size = UDim2.new(0, 200, 1, 0)
    MobileModeTitle.Position = UDim2.new(0, 10, 0, 0)
    MobileModeTitle.BackgroundTransparency = 1
    MobileModeTitle.Text = "📱 手机自瞄模式"
    MobileModeTitle.Font = Enum.Font.GothamBold
    MobileModeTitle.TextSize = 12
    MobileModeTitle.TextColor3 = Color3.new(1, 1, 1)
    MobileModeTitle.TextXAlignment = Enum.TextXAlignment.Left
    MobileModeTitle.Parent = MobileModeFrame

    local MobileModeBtn = Instance.new("TextButton")
    MobileModeBtn.Size = UDim2.new(0, 110, 0, 24)
    MobileModeBtn.Position = UDim2.new(1, -122, 0.5, -12)
    MobileModeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    MobileModeBtn.Text = "小型悬浮窗"
    MobileModeBtn.Font = Enum.Font.GothamBold
    MobileModeBtn.TextSize = 11
    MobileModeBtn.TextColor3 = Color3.new(1, 1, 1)
    MobileModeBtn.Parent = MobileModeFrame
    Instance.new("UICorner", MobileModeBtn).CornerRadius = UDim.new(0, 6)

    local MobileModes = {"小型悬浮窗", "全屏按钮", "关闭"}
    local MobileModeIndex = 1
    MobileModeBtn.MouseButton1Click:Connect(function()
        MobileModeIndex = MobileModeIndex % #MobileModes + 1
        local selected = MobileModes[MobileModeIndex]
        MobileModeBtn.Text = selected
        Features.Aimbot.MobileMode = selected ~= "关闭"
        if MobileAimbotBtn then
            MobileAimbotBtn.Visible = selected ~= "关闭"
            -- 调整按钮大小
            if selected == "全屏按钮" then
                MobileAimbotBtn.Size = UDim2.new(0, 120, 0, 120)
                MobileAimbotBtn.TextSize = 18
            else
                MobileAimbotBtn.Size = UDim2.new(0, MobileAimbot.ButtonSize, 0, MobileAimbot.ButtonSize)
                MobileAimbotBtn.TextSize = 13
            end
        end
    end)
end

-- 部位选择
local PartFrame = Instance.new("Frame")
PartFrame.Size = UDim2.new(1, -6, 0, 36)
PartFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
PartFrame.BackgroundTransparency = 0.3
PartFrame.Parent = TabGeneral
Instance.new("UICorner", PartFrame).CornerRadius = UDim.new(0, 8)

local PartTitle = Instance.new("TextLabel")
PartTitle.Size = UDim2.new(0, 120, 1, 0)
PartTitle.Position = UDim2.new(0, 10, 0, 0)
PartTitle.BackgroundTransparency = 1
PartTitle.Text = "锁定部位"
PartTitle.Font = Enum.Font.GothamBold
PartTitle.TextSize = 12
PartTitle.TextColor3 = Color3.new(1, 1, 1)
PartTitle.TextXAlignment = Enum.TextXAlignment.Left
PartTitle.Parent = PartFrame

local PartBtn = Instance.new("TextButton")
PartBtn.Size = UDim2.new(0, 110, 0, 24)
PartBtn.Position = UDim2.new(1, -122, 0.5, -12)
PartBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
PartBtn.Text = "头部"
PartBtn.Font = Enum.Font.GothamBold
PartBtn.TextSize = 11
PartBtn.TextColor3 = Color3.new(1, 1, 1)
PartBtn.Parent = PartFrame
Instance.new("UICorner", PartBtn).CornerRadius = UDim.new(0, 6)

local PartOptions = {"Head", "HumanoidRootPart", "随机"}
local PartIndex = 1
PartBtn.MouseButton1Click:Connect(function()
    PartIndex = PartIndex % #PartOptions + 1
    local selected = PartOptions[PartIndex]
    Features.Aimbot.TargetPart = selected == "随机" and "Random" or selected
    PartBtn.Text = selected
end)

CreateToggle(TabGeneral, "墙体检测", true, function(e) Features.Aimbot.WallCheck = e end, "🌐")
CreateSlider(TabGeneral, "自瞄FOV", 10, 500, 150, function(v) Features.Aimbot.FOV = v end, "🌐")
CreateSlider(TabGeneral, "平滑速度", 0, 1, 0.5, function(v) Features.Aimbot.Smooth = v end, "🌐")
CreateToggle(TabGeneral, "显示FOV圈", true, function(e) Features.Aimbot.ShowFOV = e end, "💻")
CreateToggle(TabGeneral, "团队检测", true, function(e) Features.Aimbot.TeamCheck = e end, "🌐")

CreateToggle(TabGeneral, "甩飞玩家", false, function(e) Features.Fling.Enabled = e end, "🌐")
CreateSlider(TabGeneral, "甩飞范围", 5, 50, 15, function(v) Features.Fling.Range = v end, "🌐")
CreateSlider(TabGeneral, "甩飞力度", 100, 5000, 1000, function(v) Features.Fling.Power = v end, "🌐")

-- ==================== 透视功能 ====================
CreateSection(TabGeneral, "🌐 透视功能")
CreateToggle(TabGeneral, "玩家透视", false, function(e) Features.PlayerESP.Enabled = e end, "🌐")
CreateToggle(TabGeneral, "透视团队检测", true, function(e) Features.PlayerESP.TeamCheck = e end, "🌐")
CreateToggle(TabGeneral, "玩家信息面板", false, function(e) Features.PlayerInfo.Enabled = e end, "🌐")
CreateToggle(TabGeneral, "资源透视", false, function(e) Features.ItemESP.Enabled = e end, "🌐")

-- ==================== 传送功能 ====================
CreateSection(TabGeneral, "🌐 传送功能")

PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Name = "PlayerList"
PlayerListScroll.Size = UDim2.new(1, -6, 0, 90)
PlayerListScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerListScroll.BackgroundTransparency = 0.3
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.ScrollBarThickness = 2
PlayerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScroll.Parent = TabGeneral
Instance.new("UICorner", PlayerListScroll).CornerRadius = UDim.new(0, 8)

local PLList = Instance.new("UIListLayout")
PLList.Padding = UDim.new(0, 4)
PLList.SortOrder = Enum.SortOrder.LayoutOrder
PLList.Parent = PlayerListScroll

local PLPad = Instance.new("UIPadding")
PLPad.Padding = UDim.new(0, 6)
PLPad.Parent = PlayerListScroll

-- 更新玩家列表
local function UpdatePlayerList()
    for _, child in ipairs(PlayerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -12, 0, 28)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Btn.Text = player.Name
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 11
            Btn.TextColor3 = Color3.new(1, 1, 1)
            Btn.Parent = PlayerListScroll
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

            -- 左键点击传送
            Btn.MouseButton1Click:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        myHRP.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                    end
                end
            end)

            -- 右键/长按循环传送 (适配手机端)
            local holdStart = 0
            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    holdStart = tick()
                end
            end)
            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if tick() - holdStart > 0.5 then -- 长按0.5秒触发
                        Features.LoopTeleport.Enabled = not Features.LoopTeleport.Enabled
                        Features.TeleportTarget = Features.LoopTeleport.Enabled and player or nil
                        pcall(function() StarterGui:SetCore("SendNotification", {
                            Title = "循环传送", 
                            Text = Features.LoopTeleport.Enabled and "已锁定: " .. player.Name or "已取消锁定", 
                            Duration = 2
                        }) end)
                    end
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()
-- ============================================
-- 小猫脚本 v9.1 - 白子修复版 (4/4)
-- 核心功能循环 + ESP + 自瞄 + 初始化
-- 修复: 性能优化 + 逻辑错误 + 手机端适配
-- ============================================

-- ==================== 反AFK ====================
RunService.RenderStepped:Connect(function()
    if Features.AntiAFK.Enabled and not AntiAFKConn then
        AntiAFKConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    elseif not Features.AntiAFK.Enabled and AntiAFKConn then
        AntiAFKConn:Disconnect()
        AntiAFKConn = nil
    end
end)

-- ==================== 循环速度 ====================
RunService.RenderStepped:Connect(function()
    if Features.LoopSpeed.Enabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = Features.LoopSpeed.Value end
    end
end)

-- ==================== 无限跳跃 + 超级跳 (修复: 可叠加) ====================
UserInputService.JumpRequest:Connect(function()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local jumpVelocity = 50 -- 基础无限跳跃力度
    local shouldJump = false

    if Features.InfiniteJump.Enabled then
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        shouldJump = true
    end

    if Features.SuperJump.Enabled then
        jumpVelocity = math.max(jumpVelocity, Features.SuperJump.Power)
        shouldJump = true
    end

    if shouldJump then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpVelocity, hrp.Velocity.Z)
    end
end)

-- ==================== 飞行系统 (修复: 角色死亡清理) ====================
RunService.RenderStepped:Connect(function()
    if Features.Fly.Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not FlyLV or FlyLV.Parent ~= hrp then
                -- 清理旧的
                if FlyLV then FlyLV:Destroy() end
                local oldAtt = hrp:FindFirstChild("FlyAttachment")
                if oldAtt then oldAtt:Destroy() end

                local attachment = Instance.new("Attachment")
                attachment.Name = "FlyAttachment"
                attachment.Parent = hrp

                FlyLV = Instance.new("LinearVelocity")
                FlyLV.Attachment0 = attachment
                FlyLV.MaxForce = math.huge
                FlyLV.VectorVelocity = Vector3.zero
                FlyLV.Parent = hrp
            end

            local cam = Workspace.CurrentCamera
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

            FlyLV.VectorVelocity = dir * Features.Fly.Speed
        end
    else
        if FlyLV then
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local att = hrp:FindFirstChild("FlyAttachment")
                    if att then att:Destroy() end
                end
            end)
            FlyLV:Destroy()
            FlyLV = nil
        end
    end
end)

-- ==================== 重力修改 ====================
RunService.RenderStepped:Connect(function()
    if Features.Gravity.Enabled then
        Workspace.Gravity = Features.Gravity.Value
    else
        Workspace.Gravity = OriginalLighting.Gravity
    end
end)

-- ==================== 上帝模式 ====================
RunService.RenderStepped:Connect(function()
    if Features.GodMode.Enabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- ==================== 隐形模式 (修复: 立即恢复) ====================
local function UpdateInvisible()
    if Features.Invisible.Enabled and LocalPlayer.Character then
        for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                if InvisibleParts[obj] == nil then InvisibleParts[obj] = obj.Transparency end
                obj.Transparency = 1
            end
            if obj:IsA("Decal") or obj:IsA("Texture") then
                if InvisibleParts[obj] == nil then InvisibleParts[obj] = obj.Transparency end
                obj.Transparency = 1
            end
            if obj:IsA("MeshPart") and obj.Parent:IsA("Accessory") then
                if InvisibleParts[obj] == nil then InvisibleParts[obj] = obj.Transparency end
                obj.Transparency = 1
            end
        end
    end
end

-- 使用属性变化监听实现立即恢复
local InvisibleConn = nil
RunService.RenderStepped:Connect(function()
    if Features.Invisible.Enabled then
        UpdateInvisible()
    elseif not Features.Invisible.Enabled and next(InvisibleParts) ~= nil then
        -- 立即恢复
        for part, old in pairs(InvisibleParts) do
            if part and part.Parent then 
                part.Transparency = old 
            end
        end
        InvisibleParts = {}
    end
end)

-- ==================== 点击传送 ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if Features.ClickTP.Enabled and input.UserInputType == Enum.UserInputType.MouseButton1 
       and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then 
                hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) 
            end
        end
    end
end)

-- ==================== 夜视系统 ====================
RunService.RenderStepped:Connect(function()
    if Features.NightVision.Enabled then
        Lighting.Brightness = Features.NightVision.Intensity
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
    end
end)

-- ==================== 坐标显示 (修复: ZIndex) ====================
CoordLabel = Instance.new("TextLabel")
CoordLabel.Size = UDim2.new(0, 260, 0, 20)
CoordLabel.Position = UDim2.new(0, 10, 1, -28)
CoordLabel.BackgroundTransparency = 0.3
CoordLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CoordLabel.TextColor3 = Color3.new(1, 1, 1)
CoordLabel.TextSize = 11
CoordLabel.Font = Enum.Font.GothamBold
CoordLabel.Text = ""
CoordLabel.Parent = ScreenGui
CoordLabel.Visible = false
CoordLabel.ZIndex = 5 -- 确保在其他UI之上
Instance.new("UICorner", CoordLabel).CornerRadius = UDim.new(0, 6)

RunService.RenderStepped:Connect(function()
    if Features.Coords.Enabled then
        CoordLabel.Visible = true
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            CoordLabel.Text = string.format("  📍 X:%.0f Y:%.0f Z:%.0f  ", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        end
    else
        CoordLabel.Visible = false
    end
end)

-- ==================== Fling 甩飞玩家 ====================
RunService.RenderStepped:Connect(function()
    if Features.Fling.Enabled and LocalPlayer.Character then
        local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if dist <= Features.Fling.Range then
                        local dir = (hrp.Position - myHRP.Position).Unit
                        -- 使用更兼容的方式
                        pcall(function()
                            hrp.Velocity = dir * Features.Fling.Power + Vector3.new(0, Features.Fling.Power * 0.3, 0)
                            hrp.AssemblyAngularVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.Sit = true
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- ==================== 循环传送 ====================
RunService.RenderStepped:Connect(function()
    if Features.LoopTeleport.Enabled and Features.TeleportTarget then
        local targetHRP = Features.TeleportTarget.Character and Features.TeleportTarget.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP then
            myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- ==================== 通用函数 ====================
local function IsSameTeam(p1, p2)
    if p1.Team and p2.Team and p1.Team == p2.Team then return true end
    if p1.TeamColor and p2.TeamColor and p1.TeamColor == p2.TeamColor then return true end
    return false
end

-- ==================== 玩家透视 ====================
local function CreateESP(player)
    if player == LocalPlayer or ESPHighlights[player] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "KittenESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = CoreGui
    ESPHighlights[player] = highlight

    local function Update()
        if not player.Character then highlight.Adornee = nil return end
        highlight.Adornee = player.Character
        if Features.PlayerESP.TeamCheck and IsSameTeam(LocalPlayer, player) then
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 1
        else
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
            highlight.FillTransparency = 0.3
            highlight.OutlineTransparency = 0
        end
    end

    local conn = RunService.RenderStepped:Connect(Update)
    ESPConnections[player] = conn
    Update()
end

local function RemoveESP(player)
    if ESPHighlights[player] then
        if ESPConnections[player] then ESPConnections[player]:Disconnect() ESPConnections[player] = nil end
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end

Players.PlayerAdded:Connect(function(p) if Features.PlayerESP.Enabled then CreateESP(p) end end)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(function()
    if Features.PlayerESP.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not ESPHighlights[p] then CreateESP(p) end
        end
    else
        for p, _ in pairs(ESPHighlights) do RemoveESP(p) end
    end
end)

-- ==================== 玩家信息面板 ====================
local function CreatePlayerInfo(player)
    if player == LocalPlayer or InfoBillboards[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KittenInfo"
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.Parent = CoreGui
    InfoBillboards[player] = billboard

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.Parent = billboard
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Parent = bg

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "..."
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 9
    infoLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
    infoLabel.Parent = bg

    local conn = RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            billboard.Adornee = nil
            return
        end
        billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")

        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        if hrp and targetHRP and humanoid then
            local dist = math.floor((hrp.Position - targetHRP.Position).Magnitude)
            local hp = math.floor(humanoid.Health)
            local maxHp = math.floor(humanoid.MaxHealth)
            infoLabel.Text = string.format("[%dm] %d/%d HP", dist, hp, maxHp)

            if hp > maxHp * 0.6 then 
                infoLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
            elseif hp > maxHp * 0.3 then 
                infoLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            else 
                infoLabel.TextColor3 = Color3.fromRGB(255, 50, 50) 
            end
        end
    end)

    InfoConnections[player] = conn
end

local function RemovePlayerInfo(player)
    if InfoBillboards[player] then
        if InfoConnections[player] then
            InfoConnections[player]:Disconnect()
            InfoConnections[player] = nil
        end
        InfoBillboards[player]:Destroy()
        InfoBillboards[player] = nil
    end
end

Players.PlayerAdded:Connect(function(p) if Features.PlayerInfo.Enabled then CreatePlayerInfo(p) end end)
Players.PlayerRemoving:Connect(RemovePlayerInfo)

RunService.RenderStepped:Connect(function()
    if Features.PlayerInfo.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not InfoBillboards[p] then CreatePlayerInfo(p) end
        end
    else
        for p, _ in pairs(InfoBillboards) do RemovePlayerInfo(p) end
    end
end)

-- ==================== 自瞄系统 ====================
local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = Features.Aimbot.FOV
    local localChar = LocalPlayer.Character
    if not localChar then return nil end

    local localHRP = localChar:FindFirstChild("HumanoidRootPart")
    local localHead = localChar:FindFirstChild("Head")
    if not localHRP or not localHead then return nil end

    local cam = Workspace.CurrentCamera
    local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local valid = true

            if Features.Aimbot.TeamCheck and IsSameTeam(LocalPlayer, player) then
                valid = false
            end

            if valid then
                local char = player.Character
                if char then
                    local targetPartName = Features.Aimbot.TargetPart
                    if targetPartName == "Random" then
                        targetPartName = math.random() > 0.5 and "Head" or "HumanoidRootPart"
                    end
                    local targetPart = char:FindFirstChild(targetPartName)
                    if not targetPart then
                        targetPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    end

                    if targetPart then
                        if Features.Aimbot.WallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {localChar}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local result = Workspace:Raycast(localHead.Position, (targetPart.Position - localHead.Position).Unit * 1000, rayParams)
                            if result and not result.Instance:IsDescendantOf(char) then
                                valid = false
                            end
                        end

                        if valid then
                            local pos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestPlayer = {Player = player, Part = targetPart}
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if Features.Aimbot.Enabled and Features.Aimbot.Active then
        local target = GetClosestPlayer()
        if target then
            local cam = Workspace.CurrentCamera
            local targetPos = target.Part.Position
            local currentCFrame = cam.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)

            local smooth = 1 - Features.Aimbot.Smooth
            cam.CFrame = currentCFrame:Lerp(targetCFrame, smooth)
        end
    end
end)

-- ==================== 电脑端自瞄悬浮按钮 ====================
if IsPC then
    AimbotBtn = Instance.new("TextButton")
    AimbotBtn.Name = "AimbotFloatBtn"
    AimbotBtn.Size = UDim2.new(0, 70, 0, 70)
    AimbotBtn.Position = UDim2.new(1, -85, 0, 120)
    AimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    AimbotBtn.BackgroundTransparency = 0.2
    AimbotBtn.Text = "自瞄
关闭"
    AimbotBtn.Font = Enum.Font.GothamBold
    AimbotBtn.TextSize = 14
    AimbotBtn.TextColor3 = Color3.new(1, 1, 1)
    AimbotBtn.Parent = ScreenGui
    AimbotBtn.Active = true
    AimbotBtn.Selectable = true
    Instance.new("UICorner", AimbotBtn).CornerRadius = UDim.new(1, 0)

    RunService.RenderStepped:Connect(function()
        if AimbotBtn and AimbotBtn.Parent then
            AimbotBtn.BorderSizePixel = 2
            local t = tick()
            AimbotBtn.BorderColor3 = Color3.new(math.sin(t*2)*0.5+0.5, math.sin(t*2+2)*0.5+0.5, math.sin(t*2+4)*0.5+0.5)
        end
    end)

    local btnDragStart, btnStartPos, btnIsDragging
    AimbotBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDragStart = input.Position
            btnStartPos = AimbotBtn.Position
            btnIsDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if btnDragStart and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - btnDragStart
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
                btnIsDragging = true
                AimbotBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if btnDragStart and not btnIsDragging then
                if not Features.Aimbot.Enabled then
                    pcall(function() StarterGui:SetCore("SendNotification", {Title = "自瞄", Text = "请先开启自瞄系统", Duration = 2}) end)
                else
                    Features.Aimbot.Active = not Features.Aimbot.Active
                    if Features.Aimbot.Active then
                        AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                        AimbotBtn.Text = "自瞄
开启"
                    else
                        AimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        AimbotBtn.Text = "自瞄
关闭"
                    end
                    pcall(function() StarterGui:SetCore("SendNotification", {Title = "自瞄", Text = Features.Aimbot.Active and "已开启" or "已关闭", Duration = 2}) end)
                end
            end
            btnDragStart = nil
        end
    end)
end

-- ==================== FOV圆圈 ====================
if IsPC then
    FOVFrame = Instance.new("Frame")
    FOVFrame.Name = "FOVFrame"
    FOVFrame.Size = UDim2.new(0, 300, 0, 300)
    FOVFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.BorderSizePixel = 0
    FOVFrame.Visible = false
    FOVFrame.Parent = ScreenGui
    Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)

    local FOVStroke = Instance.new("UIStroke")
    FOVStroke.Name = "FOVStroke"
    FOVStroke.Thickness = 2
    FOVStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    FOVStroke.Parent = FOVFrame

    RunService.RenderStepped:Connect(function()
        if Features.Aimbot.ShowFOV and Features.Aimbot.Active and FOVFrame then
            local fov = Features.Aimbot.FOV
            FOVFrame.Size = UDim2.new(0, fov * 2, 0, fov * 2)
            FOVFrame.Position = UDim2.new(0.5, -fov, 0.5, -fov)
            local t = tick()
            FOVStroke.Color = Color3.new(math.sin(t*2)*0.5+0.5, math.sin(t*2+2)*0.5+0.5, math.sin(t*2+4)*0.5+0.5)
            FOVFrame.Visible = true
        elseif FOVFrame then
            FOVFrame.Visible = false
        end
    end)
end

-- ==================== 资源透视 (修复: 性能优化, 0.5秒更新一次) ====================
local function CreateItemESP(obj)
    if ItemESPObjects[obj] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemESP"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.3
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = obj.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.Parent = billboard
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 4)

    ItemESPObjects[obj] = billboard
end

local function RemoveItemESP(obj)
    if ItemESPObjects[obj] then
        ItemESPObjects[obj]:Destroy()
        ItemESPObjects[obj] = nil
    end
end

-- 使用定时器优化性能
RunService.RenderStepped:Connect(function()
    ItemESPUpdateTimer = ItemESPUpdateTimer + 1
    if ItemESPUpdateTimer < 30 then return end -- 约0.5秒更新一次 (30帧)
    ItemESPUpdateTimer = 0

    if Features.ItemESP.Enabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                if obj.Name:lower():match("item") or obj.Name:lower():match("tool") or 
                   obj.Name:lower():match("gun") or obj.Name:lower():match("weapon") or
                   obj.Name:lower():match("ammo") or obj.Name:lower():match("health") or
                   obj.Name:lower():match("money") or obj.Name:lower():match("coin") then
                    if not ItemESPObjects[obj] then
                        CreateItemESP(obj)
                    end
                    if ItemESPObjects[obj] then
                        ItemESPObjects[obj].Adornee = obj
                    end
                end
            end
        end
    else
        for obj, _ in pairs(ItemESPObjects) do
            RemoveItemESP(obj)
        end
    end
end)

-- ==================== 自动拾取 (修复: 性能优化, 1秒更新一次) ====================
RunService.RenderStepped:Connect(function()
    AutoPickupTimer = AutoPickupTimer + 1
    if AutoPickupTimer < 60 then return end -- 约1秒更新一次
    AutoPickupTimer = 0

    if Features.AutoPickup.Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:FindFirstChildOfClass("TouchInterest") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist <= Features.AutoPickup.Range then
                        if obj.Name:lower():match("item") or obj.Name:lower():match("tool") or 
                           obj.Name:lower():match("collect") or obj.Name:lower():match("pickup") or
                           obj.Name:lower():match("drop") then
                            pcall(function()
                                firetouchinterest(hrp, part, 0)
                                task.wait(0.05)
                                firetouchinterest(hrp, part, 1)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- ==================== 手机端自瞄悬浮按钮 ====================
if IsMobile then
    MobileAimbotBtn = Instance.new("TextButton")
    MobileAimbotBtn.Name = "MobileAimbotBtn"
    MobileAimbotBtn.Size = UDim2.new(0, MobileAimbot.ButtonSize, 0, MobileAimbot.ButtonSize)
    MobileAimbotBtn.Position = MobileAimbot.Position
    MobileAimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    MobileAimbotBtn.BackgroundTransparency = 0.2
    MobileAimbotBtn.Text = "自瞄
关闭"
    MobileAimbotBtn.Font = Enum.Font.GothamBold
    MobileAimbotBtn.TextSize = 13
    MobileAimbotBtn.TextColor3 = Color3.new(1, 1, 1)
    MobileAimbotBtn.Parent = ScreenGui
    MobileAimbotBtn.Active = true
    MobileAimbotBtn.Selectable = true
    MobileAimbotBtn.ZIndex = 100
    MobileAimbotBtn.Visible = false
    Instance.new("UICorner", MobileAimbotBtn).CornerRadius = UDim.new(1, 0)

    local MABStroke = Instance.new("UIStroke")
    MABStroke.Thickness = 3
    MABStroke.Parent = MobileAimbotBtn

    RunService.RenderStepped:Connect(function()
        if MobileAimbotBtn and MobileAimbotBtn.Parent then
            local t = tick()
            MABStroke.Color = Color3.new(math.sin(t*3)*0.5+0.5, math.sin(t*3+2)*0.5+0.5, math.sin(t*3+4)*0.5+0.5)
        end
    end)

    local mabDragStart, mabStartPos, mabDragging
    MobileAimbotBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            mabDragStart = input.Position
            mabStartPos = MobileAimbotBtn.Position
            mabDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if mabDragStart and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - mabDragStart
            if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
                mabDragging = true
                MobileAimbotBtn.Position = UDim2.new(mabStartPos.X.Scale, mabStartPos.X.Offset + delta.X, mabStartPos.Y.Scale, mabStartPos.Y.Offset + delta.Y)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and mabDragStart then
            if not mabDragging then
                if not Features.Aimbot.Enabled then
                    pcall(function() StarterGui:SetCore("SendNotification", {Title = "自瞄", Text = "请先在菜单开启自瞄系统", Duration = 2}) end)
                else
                    MobileAimbotActive = not MobileAimbotActive
                    Features.Aimbot.Active = MobileAimbotActive
                    if MobileAimbotActive then
                        MobileAimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                        MobileAimbotBtn.Text = "自瞄
开启"
                    else
                        MobileAimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        MobileAimbotBtn.Text = "自瞄
关闭"
                    end
                    pcall(function() StarterGui:SetCore("SendNotification", {Title = "自瞄", Text = MobileAimbotActive and "手机自瞄已开启" or "手机自瞄已关闭", Duration = 2}) end)
                end
            end
            mabDragStart = nil
        end
    end)
end

-- ==================== 电脑端快捷键系统 (修复: 夜视快捷键完整) ====================
if IsPC then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Hotkeys.AimbotToggle then
            if Features.Aimbot.Enabled then
                Features.Aimbot.Active = not Features.Aimbot.Active
                pcall(function() StarterGui:SetCore("SendNotification", {
                    Title = "自瞄", 
                    Text = Features.Aimbot.Active and "自瞄已开启 [Q切换]" or "自瞄已关闭 [Q切换]", 
                    Duration = 2
                }) end)
                if AimbotBtn then
                    if Features.Aimbot.Active then
                        AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                        AimbotBtn.Text = "自瞄
开启"
                    else
                        AimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        AimbotBtn.Text = "自瞄
关闭"
                    end
                end
            end
        end

        if input.KeyCode == Hotkeys.NoClip then
            local newState = not Features.NoClip.Enabled
            Features.NoClip.Enabled = newState
            pcall(function() StarterGui:SetCore("SendNotification", {
                Title = "穿墙", 
                Text = newState and "穿墙已开启 [N键]" or "穿墙已关闭 [N键]", 
                Duration = 2
            }) end)
            if newState then
                if not NoClipConn then
                    NoClipConn = RunService.Stepped:Connect(function()
                        if not Features.NoClip.Enabled then return end
                        if not LocalPlayer.Character then return end
                        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                if OrigCollisions[part] == nil then 
                                    OrigCollisions[part] = part.CanCollide 
                                end
                                part.CanCollide = false
                            end
                        end
                    end)
                end
            else
                if NoClipConn then NoClipConn:Disconnect() NoClipConn = nil end
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and OrigCollisions[part] ~= nil then
               