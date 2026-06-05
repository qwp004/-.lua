--[[
    小猫脚本 v3.1 - 手机端适配完整版
    虚拟摇杆飞行 | 道具透视优化 | 性能防卡顿
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

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
    Red = Color3.fromRGB(255, 50, 50),
    Background = Color3.fromRGB(15, 8, 25),
    PanelBg = Color3.fromRGB(30, 15, 45),
    SidebarBg = Color3.fromRGB(40, 22, 65),
    ContentBg = Color3.fromRGB(25, 12, 38),
    ButtonBg = Color3.fromRGB(45, 28, 70),
    HoverBg = Color3.fromRGB(65, 38, 95),
    ActiveBg = Color3.fromRGB(85, 50, 120),
    SliderBg = Color3.fromRGB(60, 35, 90),
    SliderFill = Color3.fromRGB(255, 105, 180),
    InputBg = Color3.fromRGB(50, 30, 75),
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

-- 状态管理
local State = {
    speedEnabled = false,
    speedValue = 100,
    jumpEnabled = false,
    jumpValue = 100,
    flyEnabled = false,
    flySpeed = 50,
    flyMobileMode = true, -- 手机端飞行模式
    playerEspEnabled = false,
    playerEspTeamCheck = true,
    npcEspEnabled = false,
    itemEspEnabled = false,
    itemEspRange = 100,
    npcKillEnabled = false,
    npcKillRange = 20,
    npcKillInterval = 1,
    minimized = false,
}

-- 连接存储
local Connections = {}
local RenderConnections = {}

-- ========== 主面板 ==========
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 380)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -190)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

createCorner(MainFrame, 25)
createGlow(MainFrame, Colors.Accent, 3)
createGradient(MainFrame, Color3.fromRGB(45, 22, 75), Color3.fromRGB(12, 6, 22), 135)

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

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -140, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐱 小猫脚本 v3.1"
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

-- 最小化按钮
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeBtn"
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -85, 0, 5)
MinimizeButton.BackgroundColor3 = Colors.Yellow
MinimizeButton.Text = "─"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.ZIndex = 12
MinimizeButton.Parent = TopBar

createCorner(MinimizeButton, 17)
createGlow(MinimizeButton, Colors.Yellow, 2)

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

-- ========== 创建滑动条+数字输入框（双向绑定） ==========
local function createSliderWithInput(parent, name, min, max, default, color, callback)
    local container = Instance.new("Frame")
    container.Name = name.."Container"
    container.Size = UDim2.new(0.95, 0, 0, 70)
    container.BackgroundColor3 = Colors.ButtonBg
    container.BorderSizePixel = 0
    container.ZIndex = 13

    createCorner(container, 15)
    createGlow(container, color, 1)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.6, 0, 0, 22)
    nameLabel.Position = UDim2.new(0, 12, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 15
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    nameLabel.Parent = container

    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(0, 70, 0, 28)
    inputBox.Position = UDim2.new(1, -82, 0, 5)
    inputBox.BackgroundColor3 = Colors.InputBg
    inputBox.Text = tostring(default)
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 14
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.ZIndex = 14
    inputBox.Parent = container

    createCorner(inputBox, 8)
    createGlow(inputBox, color, 1)

    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, -24, 0, 10)
    sliderBg.Position = UDim2.new(0, 12, 0, 42)
    sliderBg.BackgroundColor3 = Colors.SliderBg
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 14
    sliderBg.Parent = container

    createCorner(sliderBg, 5)

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = color
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 15
    sliderFill.Parent = sliderBg

    createCorner(sliderFill, 5)

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Name = "SliderBtn"
    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -9, 0, -4)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 16
    sliderBtn.Parent = sliderBg

    createCorner(sliderBtn, 9)
    createGlow(sliderBtn, color, 2)

    local currentValue = default

    local function updateValue(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderBtn.Position = UDim2.new(percent, -9, 0, -4)
        inputBox.Text = string.format("%.0f", currentValue)
        if callback then callback(currentValue) end
    end

    inputBox.FocusLost:Connect(function()
        local num = tonumber(inputBox.Text)
        if num then
            updateValue(num)
        else
            inputBox.Text = tostring(currentValue)
        end
    end)

    local sliding = false

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            updateValue(min + percent * (max - min))
        end
    end)

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            updateValue(min + percent * (max - min))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)

    container.Parent = parent
    return {container = container, updateValue = updateValue, getValue = function() return currentValue end}
end

-- ========== 创建开关按钮 ==========
local function createToggle(parent, name, defaultState, color, callback)
    local container = Instance.new("Frame")
    container.Name = name.."Toggle"
    container.Size = UDim2.new(0.95, 0, 0, 50)
    container.BackgroundColor3 = Colors.ButtonBg
    container.BorderSizePixel = 0
    container.ZIndex = 13

    createCorner(container, 15)
    createGlow(container, color, 1)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 12, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    nameLabel.Parent = container

    local toggleBg = Instance.new("TextButton")
    toggleBg.Name = "ToggleBg"
    toggleBg.Size = UDim2.new(0, 55, 0, 28)
    toggleBg.Position = UDim2.new(1, -67, 0.5, -14)
    toggleBg.BackgroundColor3 = defaultState and color or Color3.fromRGB(80, 80, 80)
    toggleBg.Text = ""
    toggleBg.ZIndex = 14
    toggleBg.Parent = container

    createCorner(toggleBg, 14)

    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "ToggleDot"
    toggleDot.Size = UDim2.new(0, 22, 0, 22)
    toggleDot.Position = defaultState and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.ZIndex = 15
    toggleDot.Parent = toggleBg

    createCorner(toggleDot, 11)

    local state = defaultState

    toggleBg.MouseButton1Click:Connect(function()
        state = not state
        tween(toggleBg, {BackgroundColor3 = state and color or Color3.fromRGB(80, 80, 80)}, 0.2)
        tween(toggleDot, {Position = state and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)}, 0.2)
        if callback then callback(state) end
    end)

    container.Parent = parent
    return {container = container, getState = function() return state end, setState = function(s) state = s end}
end

-- ========== 创建功能按钮 ==========
local function createActionButton(parent, name, desc, icon, color1, color2, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Name = name.."Btn"
    btnFrame.Size = UDim2.new(0.95, 0, 0, 65)
    btnFrame.BackgroundColor3 = Colors.ButtonBg
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 13

    createCorner(btnFrame, 18)
    createGlow(btnFrame, color1, 2)

    local bgGradient = createGradient(btnFrame, color1, color2, 0)
    bgGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.85)
    })

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Position = UDim2.new(0, 12, 0, 12)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 26
    IconLabel.ZIndex = 14
    IconLabel.Parent = btnFrame

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -65, 0, 22)
    NameLabel.Position = UDim2.new(0, 60, 0, 8)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 16
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ZIndex = 14
    NameLabel.Parent = btnFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -65, 0, 18)
    DescLabel.Position = UDim2.new(0, 60, 0, 32)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.ZIndex = 14
    DescLabel.Parent = btnFrame

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 15
    ClickBtn.Parent = btnFrame

    ClickBtn.MouseEnter:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.97, 0, 0, 68)}, 0.2)
        bgGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0.6)})
    end)

    ClickBtn.MouseLeave:Connect(function()
        tween(btnFrame, {Size = UDim2.new(0.95, 0, 0, 65)}, 0.2)
        bgGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85), NumberSequenceKeypoint.new(1, 0.85)})
    end)

    ClickBtn.MouseButton1Click:Connect(function()
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
        if callback then callback() end
    end)

    btnFrame.Parent = parent
    return btnFrame
end

-- ========== 核心功能实现 ==========

-- 速度循环
local speedConnection = nil
local function updateSpeedLoop()
    if speedConnection then speedConnection:Disconnect() end
    if State.speedEnabled then
        speedConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = State.speedValue
            end
        end)
    end
end

-- 跳跃循环
local jumpConnection = nil
local function updateJumpLoop()
    if jumpConnection then jumpConnection:Disconnect() end
    if State.jumpEnabled then
        jumpConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.UseJumpPower = true
                char.Humanoid.JumpPower = State.jumpValue
            end
        end)
    end
end

-- ========== 手机端虚拟摇杆飞行 ==========
local flyConnection = nil
local flyBodyVelocity = nil
local flyMobileConnection = nil

-- 获取虚拟摇杆输入
local function getMobileThumbstickInput()
    local touchInputs = {}
    for _, input in pairs(UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)) do
        -- 这个方法不适用，改用另一种方式
    end

    -- 检测触摸输入来模拟摇杆
    local moveDirection = Vector3.new(0, 0, 0)
    local char = player.Character
    if not char then return moveDirection end

    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return moveDirection end

    -- 使用 Humanoid 的 MoveDirection 来获取摇杆方向
    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0.1 then
        moveDirection = moveDir
    end

    return moveDirection
end

-- 改进的手机端飞行
local function toggleFly(enabled)
    State.flyEnabled = enabled
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if enabled then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp

        -- 手机端飞行控制
        flyMobileConnection = RunService.Heartbeat:Connect(function()
            if not flyBodyVelocity or not flyBodyVelocity.Parent then return end

            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            if not hrp or not humanoid then return end

            local camCF = camera.CFrame
            local velocity = Vector3.new(0, 0, 0)

            if State.flyMobileMode then
                -- 手机端：使用虚拟摇杆方向
                local moveDir = humanoid.MoveDirection

                if moveDir.Magnitude > 0.1 then
                    -- 摇杆向上 = 向前飞行（基于相机朝向）
                    -- 摇杆向下 = 向后飞行
                    -- 摇杆向左 = 向左飞行
                    -- 摇杆向右 = 向右飞行

                    local forward = camCF.LookVector * Vector3.new(1, 0, 1)
                    forward = forward.Unit
                    local right = camCF.RightVector * Vector3.new(1, 0, 1)
                    right = right.Unit

                    -- 根据摇杆方向计算飞行方向
                    velocity = (forward * -moveDir.Z + right * moveDir.X) * State.flySpeed

                    -- 如果摇杆向上推得很大，添加一点上升
                    if moveDir.Z < -0.8 then
                        velocity = velocity + Vector3.new(0, State.flySpeed * 0.3, 0)
                    end
                    -- 如果摇杆向下推得很大，添加一点下降
                    if moveDir.Z > 0.8 then
                        velocity = velocity - Vector3.new(0, State.flySpeed * 0.3, 0)
                    end
                end

                -- 检测跳跃按钮（上升）
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump then
                    velocity = velocity + Vector3.new(0, State.flySpeed, 0)
                end
            else
                -- PC端：WASD + 空格/Shift
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, 1, 0) end
                velocity = velocity * State.flySpeed
            end

            flyBodyVelocity.Velocity = velocity
        end)

        table.insert(Connections, flyMobileConnection)
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyMobileConnection then flyMobileConnection:Disconnect() end
        flyMobileConnection = nil
    end
end

-- ========== 玩家透视 ==========
local playerHighlights = {}
local function updatePlayerEsp()
    for _, hl in pairs(playerHighlights) do
        if hl then hl:Destroy() end
    end
    playerHighlights = {}

    if not State.playerEspEnabled then return end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if State.playerEspTeamCheck and p.Team == player.Team then continue end

            local highlight = Instance.new("Highlight")
            highlight.FillColor = Colors.Pink
            highlight.OutlineColor = Colors.Gold
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = p.Character
            table.insert(playerHighlights, highlight)

            local head = p.Character:FindFirstChild("Head")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = p.Name
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.TextColor3 = Colors.Pink
                nameLabel.Parent = billboard

                local distLabel = Instance.new("TextLabel")
                distLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distLabel.BackgroundTransparency = 1
                distLabel.Text = "0m"
                distLabel.Font = Enum.Font.Gotham
                distLabel.TextSize = 12
                distLabel.TextColor3 = Colors.Cyan
                distLabel.Parent = billboard

                spawn(function()
                    while billboard and billboard.Parent do
                        local myChar = player.Character
                        local theirChar = p.Character
                        if myChar and theirChar and myChar:FindFirstChild("HumanoidRootPart") and theirChar:FindFirstChild("HumanoidRootPart") then
                            local dist = (myChar.HumanoidRootPart.Position - theirChar.HumanoidRootPart.Position).Magnitude
                            distLabel.Text = string.format("%.0fm", dist)
                        end
                        wait(0.5)
                    end
                end)

                table.insert(playerHighlights, billboard)
            end
        end
    end
end

-- ========== NPC透视 ==========
local npcHighlights = {}
local npcConnections = {}
local function updateNpcEsp()
    for _, obj in pairs(npcHighlights) do
        if obj then obj:Destroy() end
    end
    npcHighlights = {}
    for _, conn in pairs(npcConnections) do
        if conn then conn:Disconnect() end
    end
    npcConnections = {}

    if not State.npcEspEnabled then return end

    local function processNpc(npc)
        if not npc:IsA("Model") then return end
        if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Colors.Red
            highlight.OutlineColor = Colors.Orange
            highlight.FillTransparency = 0.6
            highlight.OutlineTransparency = 0
            highlight.Parent = npc
            table.insert(npcHighlights, highlight)

            local myChar = player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("HumanoidRootPart") then
                local line = Instance.new("Beam")
                local attach1 = Instance.new("Attachment", myChar.HumanoidRootPart)
                local attach2 = Instance.new("Attachment", npc.HumanoidRootPart)
                line.Attachment0 = attach1
                line.Attachment1 = attach2
                line.Color = ColorSequence.new(Colors.Red)
                line.Width0 = 0.1
                line.Width1 = 0.1
                line.FaceCamera = true
                line.Parent = myChar.HumanoidRootPart
                table.insert(npcHighlights, line)
                table.insert(npcHighlights, attach1)
                table.insert(npcHighlights, attach2)
            end

            local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 180, 0, 60)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = npc.Name
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.TextColor3 = Colors.Red
                nameLabel.Parent = billboard

                local distLabel = Instance.new("TextLabel")
                distLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distLabel.BackgroundTransparency = 1
                distLabel.Text = "0m"
                distLabel.Font = Enum.Font.Gotham
                distLabel.TextSize = 12
                distLabel.TextColor3 = Colors.Yellow
                distLabel.Parent = billboard

                local updateConn = RunService.Heartbeat:Connect(function()
                    if billboard and billboard.Parent and myChar and myChar:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("HumanoidRootPart") then
                        local dist = (myChar.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                        distLabel.Text = string.format("%.0fm", dist)
                    end
                end)
                table.insert(npcConnections, updateConn)
                table.insert(npcHighlights, billboard)
            end
        end
    end

    for _, npc in pairs(Workspace:GetDescendants()) do
        processNpc(npc)
    end

    local addedConn = Workspace.DescendantAdded:Connect(processNpc)
    table.insert(npcConnections, addedConn)
end

-- ========== 可互动道具透视（优化版防卡顿） ==========
local itemHighlights = {}
local itemUpdateConnection = nil
local lastItemUpdate = 0
local ITEM_UPDATE_INTERVAL = 0.5 -- 每0.5秒更新一次，防止卡顿

local function updateItemEsp()
    -- 清理旧的高亮
    for _, obj in pairs(itemHighlights) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    itemHighlights = {}

    if not State.itemEspEnabled then
        if itemUpdateConnection then
            itemUpdateConnection:Disconnect()
            itemUpdateConnection = nil
        end
        return
    end

    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position

    -- 使用批量处理减少卡顿
    local itemsToProcess = {}
    local count = 0

    -- 收集可互动道具（使用范围限制）
    for _, obj in pairs(Workspace:GetDescendants()) do
        if count > 100 then break end -- 限制处理数量

        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            -- 检测可互动道具的特征
            local isInteractable = false
            local itemName = obj.Name

            -- 检测常见的可互动道具名称
            local interactableKeywords = {
                "Coin", "Gem", "Item", "Tool", "Weapon", "Potion", "Food", "Money", "Cash",
                "Collect", "Pickup", "Loot", "Drop", "Reward", "Chest", "Box", "Crate",
                "蛋", "金币", "宝石", "道具", "武器", "药水", "食物", "钱", "收集",
                "掉落", "奖励", "宝箱", "盒子", "物品"
            }

            for _, keyword in ipairs(interactableKeywords) do
                if string.find(string.lower(itemName), string.lower(keyword)) then
                    isInteractable = true
                    break
                end
            end

            -- 检测是否有 ClickDetector 或 TouchInterest
            if not isInteractable then
                if obj:FindFirstChild("ClickDetector") or obj:FindFirstChild("TouchInterest") then
                    isInteractable = true
                end
            end

            -- 检测 ProximityPrompt
            if not isInteractable then
                if obj:FindFirstChild("ProximityPrompt") then
                    isInteractable = true
                end
            end

            -- 检测常见的可收集物品材质/颜色
            if not isInteractable then
                if obj.Material == Enum.Material.Neon or obj.Material == Enum.Material.ForceField then
                    isInteractable = true
                end
            end

            if isInteractable then
                local dist = (obj.Position - myPos).Magnitude
                if dist <= State.itemEspRange then
                    table.insert(itemsToProcess, {obj = obj, dist = dist, name = itemName})
                    count = count + 1
                end
            end
        end
    end

    -- 批量创建高亮（分帧处理防卡顿）
    spawn(function()
        for i, itemData in ipairs(itemsToProcess) do
            if not State.itemEspEnabled then return end

            local obj = itemData.obj
            if not obj or not obj.Parent