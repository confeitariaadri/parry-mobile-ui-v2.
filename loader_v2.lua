--[[
Parry Mobile UI v2 - treino e temporização
Interface demonstrativa para Delta/ambiente Luau.
Não contém bypass de anti-cheat nem automação real do Death Ball.
Os controles abaixo são úteis para testar a interface e a temporização.
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ParryMobileUI_v2")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(18, 18, 24),
    panel = Color3.fromRGB(28, 28, 39),
    border = Color3.fromRGB(78, 78, 105),
    text = Color3.fromRGB(245, 245, 250),
    muted = Color3.fromRGB(155, 156, 175),
    green = Color3.fromRGB(72, 210, 139),
    yellow = Color3.fromRGB(245, 197, 82),
    red = Color3.fromRGB(231, 78, 95),
    blue = Color3.fromRGB(105, 160, 255),
}

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local gui = create("ScreenGui", {
    Name = "ParryMobileUI_v2",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local panel = create("Frame", {
    Name = "Panel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.52),
    Size = UDim2.fromOffset(290, 310),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
}, gui)
create("UICorner", {CornerRadius = UDim.new(0, 14)}, panel)
create("UIStroke", {Color = C.border, Thickness = 1.2}, panel)

local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, panel)
create("UICorner", {CornerRadius = UDim.new(0, 14)}, header)
create("Frame", {
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, header)

create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -62, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "PARRY  /  MOBILE v2",
    TextColor3 = C.text,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local minimize = create("TextButton", {
    Name = "Minimize",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -9, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Color3.fromRGB(48, 50, 66),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "—",
    TextColor3 = C.text,
    TextSize = 18,
}, header)
create("UICorner", {CornerRadius = UDim.new(0, 8)}, minimize)

local body = create("Frame", {
    Name = "Body",
    Position = UDim2.fromOffset(10, 52),
    Size = UDim2.new(1, -20, 1, -62),
    BackgroundTransparency = 1,
}, panel)
create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, body)

local function makeToggle(label, color, order)
    local row = create("Frame", {
        Name = label:gsub("%s", "") .. "Row",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
        LayoutOrder = order,
    }, body)
    create("UICorner", {CornerRadius = UDim.new(0, 9)}, row)
    create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -76, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = label,
        TextColor3 = C.text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local button = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.fromOffset(58, 26),
        BackgroundColor3 = Color3.fromRGB(60, 61, 76),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "OFF",
        TextColor3 = C.text,
        TextSize = 11,
    }, row)
    create("UICorner", {CornerRadius = UDim.new(0, 7)}, button)
    local enabled = false
    button.Activated:Connect(function()
        enabled = not enabled
        button.Text = enabled and "ON" or "OFF"
        button.BackgroundColor3 = enabled and color or Color3.fromRGB(60, 61, 76)
    end)
    return function() return enabled end
end

local autoOn = makeToggle("Auto Parry • treino", C.green, 1)
local perfectOn = makeToggle("Perfect Parry • treino", C.blue, 2)

local timingRow = create("Frame", {
    Name = "TimingRow",
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    LayoutOrder = 3,
}, body)
create("UICorner", {CornerRadius = UDim.new(0, 9)}, timingRow)

local timingLabel = create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(10, 5),
    Size = UDim2.new(1, -20, 0, 22),
    Font = Enum.Font.GothamSemibold,
    Text = "Janela de treino: 100 ms",
    TextColor3 = C.text,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
}, timingRow)

local slider = create("TextButton", {
    Name = "TimingSlider",
    Position = UDim2.fromOffset(10, 36),
    Size = UDim2.new(1, -20, 0, 24),
    BackgroundColor3 = Color3.fromRGB(53, 54, 70),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
}, timingRow)
create("UICorner", {CornerRadius = UDim.new(0, 7)}, slider)

local fill = create("Frame", {
    Name = "Fill",
    Size = UDim2.new(100/250, 0, 1, 0),
    BackgroundColor3 = C.blue,
    BorderSizePixel = 0,
}, slider)
create("UICorner", {CornerRadius = UDim.new(0, 7)}, fill)

local timing = 100
local function setTimingFromX(x)
    local width = math.max(slider.AbsoluteSize.X, 1)
    local alpha = math.clamp((x - slider.AbsolutePosition.X) / width, 0, 1)
    timing = math.floor((alpha * 250 + 2.5) / 5) * 5
    fill.Size = UDim2.new(timing / 250, 0, 1, 0)
    timingLabel.Text = "Janela de treino: " .. timing .. " ms"
end
slider.Activated:Connect(function()
    -- Activated is used for mobile taps; touch/mouse movement is handled below.
    local mouse = UserInputService:GetMouseLocation()
    setTimingFromX(mouse.X)
end)
slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        setTimingFromX(input.Position.X)
    end
end)
slider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or input.UserInputType == Enum.UserInputType.Touch then
            setTimingFromX(input.Position.X)
        end
    end
end)

local testButton = create("TextButton", {
    Name = "TestTiming",
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = Color3.fromRGB(42, 56, 83),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "TESTAR TEMPO",
    TextColor3 = C.text,
    TextSize = 12,
    LayoutOrder = 4,
}, body)
create("UICorner", {CornerRadius = UDim.new(0, 9)}, testButton)

local status = create("TextLabel", {
    Name = "Status",
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Pronto • modo de treino local",
    TextColor3 = C.muted,
    TextSize = 10,
    TextWrapped = true,
    LayoutOrder = 5,
}, body)

testButton.Activated:Connect(function()
    local modes = {}
    if autoOn() then table.insert(modes, "Auto Parry") end
    if perfectOn() then table.insert(modes, "Perfect Parry") end
    if #modes == 0 then
        status.Text = "Ative um modo para testar a interface."
        status.TextColor3 = C.yellow
    else
        status.Text = table.concat(modes, " + ") .. " • janela " .. timing .. " ms (simulação)"
        status.TextColor3 = C.green
    end
end)

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    panel.Size = minimized and UDim2.fromOffset(210, 44) or UDim2.fromOffset(290, 310)
    minimize.Text = minimized and "+" or "—"
end)

-- Drag support for touch and mouse, initiated from the header.
local dragging = false
local dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
