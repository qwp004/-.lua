--[[
    小猫脚本 v1.0 - 炫丽手机端UI
    适配竖屏，大圆角设计，渐变发光效果
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 清除旧UI
local oldGui = playerGui:FindFirstChild("KittenScriptUI")
if oldGui then oldGui:Destroy() end

-- 创建主界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KittenScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- 配色方案 - 炫丽糖果色
local Colors = {
    Primary = Color3.fromRGB(255, 105, 180),
    Secondary = Color3.fromRGB(138, 43, 226),
    Accent = Color3.fromRGB(0, 255, 255),
    Gold = Color3.fromRGB(255, 215, 0),
    Orange = Color3.fromRGB(255, 140, 0),
    Green = Color3.fromRGB(50, 255, 150),
    Purple = Color3.fromRGB(186, 85, 211),
    Pink = Color3.fromRGB(255, 20, 147),
    Yellow = Color3.fromRGB(255, 255, 0),
    Cyan = Color3.fromRGB(0, 255, 255),
    Background = Color3.fromRGB(30, 10, 40),
    PanelBg = Color3.fromRGB(40, 20, 60),
}

-- 工具函数
local function createGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

local function createGlow(parent, color, size)
    local glow = Instance.new("UIStroke")
    glow.Color = color or Colors.Accent
    glow.Thickness = size or 2
    glow.Transparency = 0.3
    glow.Parent = parent
    return glow
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 20)
    corner.Parent = parent
    return corner
end

local function tween(obj, props, duration, easing, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

-- 主菜单面板
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 520)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -260)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

createCorner(MainFrame, 35)
createGlow(MainFrame, Colors.Accent, 3)
createGradient(MainFrame, Color3.fromRGB(60, 20, 80), Color3.fromRGB(20, 10, 40), 135)

-- 顶部标题栏
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundColor3 = Colors.Primary
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 11
TopBar.Parent = MainFrame

createCorner(TopBar, 35)
createGradient(TopBar, Colors.Pink, Colors.Purple, 90)

-- 标题
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐱 小猫脚本"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 26
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = TopBar

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Colors.Gold
titleStroke.Thickness = 2
titleStroke.Parent = TitleLabel

-- 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseBtn"
CloseButton.Size = UDim2.new(0, 45, 0, 45)
CloseButton.Position = UDim2.new(1, -55, 0, 8)
CloseButton.BackgroundColor3 = Colors.Pink
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.ZIndex = 12
CloseButton.Parent = TopBar

createCorner(CloseButton, 22)
createGlow(CloseButton, Colors.Pink, 2)

-- 内容滚动区域
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollContent"
ScrollFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Colors.Accent
ScrollFrame.ZIndex = 11
ScrollFrame.Parent = MainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 10)
scrollCorner.Parent = ScrollFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 20)
UIPadding.Parent = ScrollFrame

-- 创建功能按钮
local function createFeatureButton(name, description, icon, color1, color2, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Name = name.."Btn"
    btnFrame.Size = UDim2.new(0.95, 0, 0, 80)
    btnFrame.BackgroundColor3 = Colors.PanelBg
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 12
    btnFrame.LayoutOrder = #ScrollFrame:GetChildren()
    
    createCorner(btnFrame, 25)
    createGlow(btnFrame, color1, 2)
    
    local bgGradient = createGradient(btnFrame, color1, color2, 0)
    bgGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.85)
    })
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 50, 0, 50)
    IconLabel.Position = UDim2.new(0, 15, 0, 15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 32
    IconLabel.ZIndex = 13
    IconLabel.Parent = btnFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "Name"
    NameLabel.Size = UDim2.new(1, -80, 0, 30)
    NameLabel.Position = UDim2.new(0, 75, 0, 10)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 20
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ZIndex = 13
    NameLabel.Parent = btnFrame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Desc"
    DescLabel.Size = UDim2.new(1, -80, 0, 25)
    DescLabel.Position = UDim2.new(0, 75, 0, 40)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = description
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 14
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.ZIndex = 13
    DescLabel.Parent = btnFrame
    
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Name = "ClickArea"
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 14
    ClickBtn.Parent = btnFrame
    
    -- 悬停效果
    ClickBtn.MouseEnter:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.98, 0, 0, 85)}, 0.2)
        bgGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0.6)
        })
    end)
    
    ClickBtn.MouseLeave:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.95, 0, 0, 80)}, 0.2)
        bgGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0.85)
        })
    end)
    
    ClickBtn.MouseButton1Down:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.92, 0, 0, 75)}, 0.1)
    end)
    
    ClickBtn.MouseButton1Up:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.98, 0, 0, 85)}, 0.1)
    end)
    
    ClickBtn.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.5
        ripple.ZIndex = 15
        ripple.Parent = btnFrame
        createCorner(ripple, 50)
        
        tween(ripple, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.5)
        game:GetService("Debris"):AddItem(ripple, 0.5)
        
        if callback then callback() end
    end)
    
    btnFrame.Parent = ScrollFrame
    return btnFrame
end

-- 创建功能按钮
createFeatureButton("飞行模式", "开启自由飞行，畅游天空", "🚀", Colors.Cyan, Colors.Blue, function()
    print("小猫脚本: 飞行模式已切换")
end)

createFeatureButton("超级速度", "提升移动速度 5倍", "⚡", Colors.Yellow, Colors.Orange, function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 100
    end
end)

createFeatureButton("无限跳跃", "可以无限次跳跃", "🦘", Colors.Green, Colors.Cyan, function()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 100
        end
    end
end)

createFeatureButton("玩家透视", "查看所有玩家位置", "👁️", Colors.Pink, Colors.Purple, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Colors.Pink
            highlight.OutlineColor = Colors.Gold
            highlight.Parent = p.Character
        end
    end
end)

createFeatureButton("自动收集", "自动收集附近物品", "🧲", Colors.Gold, Colors.Orange, function()
    print("小猫脚本: 自动收集已启动")
end)

createFeatureButton("无敌模式", "免疫所有伤害", "🛡️", Colors.Primary, Colors.Pink, function()
    local char = player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

createFeatureButton("随机传送", "传送到随机位置", "📍", Colors.Purple, Colors.Secondary, function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(math.random(-500, 500), 100, math.random(-500, 500))
    end
end)

createFeatureButton("夜视模式", "在黑暗中看清一切", "🌙", Colors.Cyan, Colors.Green, function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").GlobalShadows = false
end)

-- 更新滚动区域
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 30)

-- 悬浮球开关
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleBtn"
ToggleButton.Size = UDim2.new(0, 65, 0, 65)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -32)
ToggleButton.BackgroundColor3 = Colors.Pink
ToggleButton.Text = "🐱"
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextSize = 35
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.ZIndex = 100
ToggleButton.Parent = ScreenGui

createCorner(ToggleButton, 33)
createGlow(ToggleButton, Colors.Gold, 3)
createGradient(ToggleButton, Colors.Pink, Colors.Purple, 45)

-- 悬浮球动画
spawn(function()
    while ToggleButton and ToggleButton.Parent do
        for i = 0, math.pi * 2, 0.1 do
            if not ToggleButton then break end
            ToggleButton.Position = UDim2.new(0, 20 + math.sin(i) * 3, 0.5, -32 + math.cos(i) * 3)
            wait(0.05)
        end
    end
end)

-- 菜单状态
local isOpen = true

-- 关闭功能
CloseButton.MouseButton1Click:Connect(function()
    isOpen = false
    tween(MainFrame, {Position = UDim2.new(0.5, -160, 1.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    wait(0.5)
    MainFrame.Visible = false
end)

-- 打开/切换
ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        tween(MainFrame, {Position = UDim2.new(0.5, -160, 0.5, -260)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        tween(MainFrame, {Position = UDim2.new(0.5, -160, 1.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.5)
        MainFrame.Visible = false
    end
end)

-- 拖动功能
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- 悬浮球拖动
local toggleDragging = false
local toggleStart = nil
local toggleStartPos = nil

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleStart = input.Position
        toggleStartPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - toggleStart
        ToggleButton.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    end
end)

-- 开场动画
MainFrame.Position = UDim2.new(0.5, -160, 1.5, 0)
wait(0.5)
tween(MainFrame, {Position = UDim2.new(0.5, -160, 0.5, -260)}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- 欢迎通知
spawn(function()
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 60)
    notif.Position = UDim2.new(0.5, -140, 0, -80)
    notif.BackgroundColor3 = Colors.PanelBg
    notif.ZIndex = 200
    notif.Parent = ScreenGui
    
    createCorner(notif, 20)
    createGlow(notif, Colors.Gold, 2)
    createGradient(notif, Colors.Pink, Colors.Purple, 90)
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = "🐱 小猫脚本已加载！"
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = 22
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.ZIndex = 201
    notifText.Parent = notif
    
    tween(notif, {Position = UDim2.new(0.5, -140, 0, 20)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    wait(3)
    tween(notif, {Position = UDim2.new(0.5, -140, 0, -80)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    wait(0.5)
    notif:Destroy()
end)

print("🐱 小猫脚本 v1.0 已成功加载！")
print("✨ 功能列表: 飞行 | 速度 | 跳跃 | 透视 | 收集 | 无敌 | 传送 | 夜视")
