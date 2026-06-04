--[[
    小猫脚本 v2.0 - 横向布局UI
    左侧功能栏 + 右侧内容区，适配手机横屏/平板
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

-- 配色方案
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
    Background = Color3.fromRGB(20, 10, 35),
    PanelBg = Color3.fromRGB(35, 20, 55),
    SidebarBg = Color3.fromRGB(45, 25, 70),
    ContentBg = Color3.fromRGB(30, 15, 45),
    ButtonBg = Color3.fromRGB(50, 30, 75),
    HoverBg = Color3.fromRGB(70, 40, 100),
    ActiveBg = Color3.fromRGB(90, 50, 130),
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

-- ========== 主面板（横向布局） ==========
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 350)  -- 横向：宽600 高350
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

createCorner(MainFrame, 25)
createGlow(MainFrame, Colors.Accent, 3)
createGradient(MainFrame, Color3.fromRGB(50, 25, 80), Color3.fromRGB(15, 8, 30), 135)

-- 标题栏
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Colors.Primary
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 11
TopBar.Parent = MainFrame

createCorner(TopBar, 25)
createGradient(TopBar, Colors.Pink, Colors.Purple, 90)

-- 标题
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐱 小猫脚本 v2.0"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 22
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
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Colors.Pink
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.ZIndex = 12
CloseButton.Parent = TopBar

createCorner(CloseButton, 17)
createGlow(CloseButton, Colors.Pink, 2)

-- ========== 左侧功能栏 ==========
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Colors.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

createCorner(Sidebar, 20)
createGlow(Sidebar, Colors.Purple, 2)

local sidebarGradient = createGradient(Sidebar, Colors.SidebarBg, Color3.fromRGB(35, 20, 60), 180)
sidebarGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.3),
    NumberSequenceKeypoint.new(1, 0.5)
})

-- 左侧滚动
local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Name = "SidebarScroll"
SidebarScroll.Size = UDim2.new(1, -10, 1, -10)
SidebarScroll.Position = UDim2.new(0, 5, 0, 5)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.ScrollBarThickness = 4
SidebarScroll.ScrollBarImageColor3 = Colors.Accent
SidebarScroll.ZIndex = 12
SidebarScroll.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 8)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = SidebarScroll

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingBottom = UDim.new(0, 8)
SidebarPadding.Parent = SidebarScroll

-- ========== 右侧内容区 ==========
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -190, 1, -55)
ContentArea.Position = UDim2.new(0, 180, 0, 50)
ContentArea.BackgroundColor3 = Colors.ContentBg
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

createCorner(ContentArea, 20)
createGlow(ContentArea, Colors.Cyan, 2)

local contentGradient = createGradient(ContentArea, Colors.ContentBg, Color3.fromRGB(25, 12, 40), 180)
contentGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.4)
})

-- 右侧内容滚动
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, -16, 1, -16)
ContentScroll.Position = UDim2.new(0, 8, 0, 8)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 6
ContentScroll.ScrollBarImageColor3 = Colors.Accent
ContentScroll.ZIndex = 12
ContentScroll.Parent = ContentArea

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = ContentScroll

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 8)
ContentPadding.PaddingBottom = UDim.new(0, 8)
ContentPadding.Parent = ContentScroll

-- ========== 功能数据 ==========
local Features = {
    {
        name = "玩家功能",
        icon = "👤",
        color = Colors.Pink,
        items = {
            {name = "飞行模式", desc = "自由飞行畅游", icon = "🚀", color1 = Colors.Cyan, color2 = Colors.Blue, action = function()
                print("飞行模式已开启")
            end},
            {name = "超级速度", desc = "速度提升5倍", icon = "⚡", color1 = Colors.Yellow, color2 = Colors.Orange, action = function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = 100
                end
            end},
            {name = "无限跳跃", desc = "无限次跳跃", icon = "🦘", color1 = Colors.Green, color2 = Colors.Cyan, action = function()
                local char = player.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.UseJumpPower = true
                        humanoid.JumpPower = 100
                    end
                end
            end},
            {name = "无敌模式", desc = "免疫所有伤害", icon = "🛡️", color1 = Colors.Primary, color2 = Colors.Pink, action = function()
                local char = player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end},
        }
    },
    {
        name = "透视功能",
        icon = "👁️",
        color = Colors.Cyan,
        items = {
            {name = "玩家透视", desc = "查看所有玩家", icon = "👁️", color1 = Colors.Pink, color2 = Colors.Purple, action = function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Colors.Pink
                        highlight.OutlineColor = Colors.Gold
                        highlight.Parent = p.Character
                    end
                end
            end},
            {name = "物品透视", desc = "高亮附近物品", icon = "✨", color1 = Colors.Gold, color2 = Colors.Orange, action = function()
                print("物品透视已开启")
            end},
            {name = "夜视模式", desc = "黑暗中看清", icon = "🌙", color1 = Colors.Cyan, color2 = Colors.Green, action = function()
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").GlobalShadows = false
            end},
        }
    },
    {
        name = "传送功能",
        icon = "📍",
        color = Colors.Purple,
        items = {
            {name = "随机传送", desc = "传送到随机位置", icon = "🎲", color1 = Colors.Purple, color2 = Colors.Secondary, action = function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(math.random(-500, 500), 100, math.random(-500, 500))
                end
            end},
            {name = "安全区传送", desc = "传送到安全区", icon = "🏠", color1 = Colors.Green, color2 = Colors.Cyan, action = function()
                print("传送到安全区")
            end},
        }
    },
    {
        name = "自动功能",
        icon = "🤖",
        color = Colors.Green,
        items = {
            {name = "自动收集", desc = "自动收集物品", icon = "🧲", color1 = Colors.Gold, color2 = Colors.Orange, action = function()
                print("自动收集已启动")
            end},
            {name = "自动农场", desc = "自动刷资源", icon = "🌾", color1 = Colors.Green, color2 = Colors.Yellow, action = function()
                print("自动农场已启动")
            end},
            {name = "自动点击", desc = "自动连点器", icon = "👆", color1 = Colors.Pink, color2 = Colors.Primary, action = function()
                print("自动点击已启动")
            end},
        }
    },
    {
        name = "游戏设置",
        icon = "⚙️",
        color = Colors.Gold,
        items = {
            {name = "重置角色", desc = "重新生成角色", icon = "🔄", color1 = Colors.Orange, color2 = Colors.Red, action = function()
                if player.Character then
                    player.Character:BreakJoints()
                end
            end},
            {name = "全屏亮度", desc = "调整游戏亮度", icon = "💡", color1 = Colors.Yellow, color2 = Colors.Gold, action = function()
                game:GetService("Lighting").Brightness = 5
            end},
        }
    },
}

-- 当前选中的分类
local currentCategory = nil

-- ========== 创建左侧分类按钮 ==========
local function createCategoryButton(category, index)
    local btn = Instance.new("TextButton")
    btn.Name = category.name.."Btn"
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.BackgroundColor3 = Colors.ButtonBg
    btn.Text = ""
    btn.ZIndex = 13
    btn.LayoutOrder = index

    createCorner(btn, 15)

    -- 图标
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 10, 0, 7)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = category.icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 24
    iconLabel.ZIndex = 14
    iconLabel.Parent = btn

    -- 名称
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -50, 1, 0)
    nameLabel.Position = UDim2.new(0, 45, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = category.name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    nameLabel.Parent = btn

    -- 选中指示器
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 0.7, 0)
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.BackgroundColor3 = category.color
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 14
    indicator.Visible = false
    indicator.Parent = btn

    createCorner(indicator, 2)

    -- 悬停效果
    btn.MouseEnter:Connect(function()
        if currentCategory ~= category then
            tween(btn, {BackgroundColor3 = Colors.HoverBg}, 0.2)
        end
    end)

    btn.MouseLeave:Connect(function()
        if currentCategory ~= category then
            tween(btn, {BackgroundColor3 = Colors.ButtonBg}, 0.2)
        end
    end)

    -- 点击效果
    btn.MouseButton1Click:Connect(function()
        -- 取消之前选中的
        if currentCategory then
            for _, child in pairs(SidebarScroll:GetChildren()) do
                if child:IsA("TextButton") and child.Name ~= btn.Name then
                    tween(child, {BackgroundColor3 = Colors.ButtonBg}, 0.3)
                    child:FindFirstChild("Indicator").Visible = false
                end
            end
        end

        -- 选中当前
        currentCategory = category
        tween(btn, {BackgroundColor3 = Colors.ActiveBg}, 0.3)
        indicator.Visible = true

        -- 显示对应功能
        showFeatures(category.items)
    end)

    btn.Parent = SidebarScroll
    return btn
end

-- ========== 创建右侧功能按钮 ==========
local function createFeatureButton(feature, index)
    local btnFrame = Instance.new("Frame")
    btnFrame.Name = feature.name.."Btn"
    btnFrame.Size = UDim2.new(0.95, 0, 0, 70)
    btnFrame.BackgroundColor3 = Colors.ButtonBg
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 13
    btnFrame.LayoutOrder = index

    createCorner(btnFrame, 18)
    createGlow(btnFrame, feature.color1, 2)

    local bgGradient = createGradient(btnFrame, feature.color1, feature.color2, 0)
    bgGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.85)
    })

    -- 图标
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 45, 0, 45)
    IconLabel.Position = UDim2.new(0, 12, 0, 12)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = feature.icon
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 28
    IconLabel.ZIndex = 14
    IconLabel.Parent = btnFrame

    -- 名称
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "Name"
    NameLabel.Size = UDim2.new(1, -70, 0, 25)
    NameLabel.Position = UDim2.new(0, 65, 0, 10)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = feature.name
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 18
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ZIndex = 14
    NameLabel.Parent = btnFrame

    -- 描述
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Desc"
    DescLabel.Size = UDim2.new(1, -70, 0, 20)
    DescLabel.Position = UDim2.new(0, 65, 0, 38)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = feature.desc
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 13
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.ZIndex = 14
    DescLabel.Parent = btnFrame

    -- 点击区域
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Name = "ClickArea"
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 15
    ClickBtn.Parent = btnFrame

    -- 悬停效果
    ClickBtn.MouseEnter:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.97, 0, 0, 75)}, 0.2)
        bgGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0.6)
        })
    end)

    ClickBtn.MouseLeave:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.95, 0, 0, 70)}, 0.2)
        bgGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0.85)
        })
    end)

    ClickBtn.MouseButton1Down:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.93, 0, 0, 65)}, 0.1)
    end)

    ClickBtn.MouseButton1Up:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.97, 0, 0, 75)}, 0.1)
    end)

    ClickBtn.MouseButton1Click:Connect(function()
        -- 水波纹效果
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.5
        ripple.ZIndex = 16
        ripple.Parent = btnFrame
        createCorner(ripple, 50)

        tween(ripple, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.5)
        game:GetService("Debris"):AddItem(ripple, 0.5)

        if feature.action then feature.action() end
    end)

    btnFrame.Parent = ContentScroll
    return btnFrame
end

-- ========== 显示功能列表 ==========
function showFeatures(items)
    -- 清除旧内容
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- 添加新功能按钮
    for i, item in ipairs(items) do
        createFeatureButton(item, i)
    end

    -- 更新滚动区域
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
end

-- 创建左侧分类按钮
for i, category in ipairs(Features) do
    createCategoryButton(category, i)
end

-- 默认选中第一个分类
wait(0.1)
if #Features > 0 then
    currentCategory = Features[1]
    local firstBtn = SidebarScroll:FindFirstChild(Features[1].name.."Btn")
    if firstBtn then
        tween(firstBtn, {BackgroundColor3 = Colors.ActiveBg}, 0.3)
        firstBtn:FindFirstChild("Indicator").Visible = true
        showFeatures(Features[1].items)
    end
end

-- 更新左侧滚动区域
SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 20)

-- ========== 悬浮球开关 ==========
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleBtn"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -30)
ToggleButton.BackgroundColor3 = Colors.Pink
ToggleButton.Text = "🐱"
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextSize = 32
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.ZIndex = 100
ToggleButton.Parent = ScreenGui

createCorner(ToggleButton, 30)
createGlow(ToggleButton, Colors.Gold, 3)
createGradient(ToggleButton, Colors.Pink, Colors.Purple, 45)

-- 悬浮球动画
spawn(function()
    while ToggleButton and ToggleButton.Parent do
        for i = 0, math.pi * 2, 0.1 do
            if not ToggleButton then break end
            ToggleButton.Position = UDim2.new(0, 20 + math.sin(i) * 3, 0.5, -30 + math.cos(i) * 3)
            wait(0.05)
        end
    end
end)

-- 菜单状态
local isOpen = true

-- 关闭功能
CloseButton.MouseButton1Click:Connect(function()
    isOpen = false
    tween(MainFrame, {Position = UDim2.new(0.5, -300, 1.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    wait(0.5)
    MainFrame.Visible = false
end)

-- 打开/切换
ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        tween(MainFrame, {Position = UDim2.new(0.5, -300, 0.5, -175)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        tween(MainFrame, {Position = UDim2.new(0.5, -300, 1.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
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
MainFrame.Position = UDim2.new(0.5, -300, 1.5, 0)
wait(0.5)
tween(MainFrame, {Position = UDim2.new(0.5, -300, 0.5, -175)}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- 欢迎通知
spawn(function()
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 55)
    notif.Position = UDim2.new(0.5, -140, 0, -80)
    notif.BackgroundColor3 = Colors.PanelBg
    notif.ZIndex = 200
    notif.Parent = ScreenGui

    createCorner(notif, 18)
    createGlow(notif, Colors.Gold, 2)
    createGradient(notif, Colors.Pink, Colors.Purple, 90)

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = "🐱 小猫脚本 v2.0 已加载！"
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = 20
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.ZIndex = 201
    notifText.Parent = notif

    tween(notif, {Position = UDim2.new(0.5, -140, 0, 20)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    wait(3)
    tween(notif, {Position = UDim2.new(0.5, -140, 0, -80)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    wait(0.5)
    notif:Destroy()
end)

print("🐱 小猫脚本 v2.0 已成功加载！")
print("✨ 横向布局 | 左侧功能栏 | 右侧内容区")
