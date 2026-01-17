-- [[ PAINEL UNIVERSAL-HUB-V1.5 ]]
-- Codename: @ayuks78 & @GmAI
-- Style: Squared UI / Card System

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 1. CONFIGURAÇÕES GLOBAIS ]]
getgenv().Aimbot = false
getgenv().Hitbox = false
getgenv().HitSize = 5
getgenv().TeamCheck = false

-- [[ 2. INTERFACE E CAMUFLAGEM ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHub_v1.5"
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = game:GetService("CoreGui") end

-- Botão Abrir (Agora Quadrado Preto)
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Image = "rbxassetid://6023454774" -- Selo azul dentro
OpenBtn.BorderSizePixel = 0
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)
OpenBtn.Active = true
OpenBtn.Draggable = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.Text = "Universal-Hub v1.5 ✔️"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Navegação (Abas)
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", MainFrame)
Pages.Size = UDim2.new(1, -20, 1, -100)
Pages.Position = UDim2.new(0, 10, 0, 90)
Pages.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10) -- Espaçamento entre Cards

    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 85, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 27, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        Page.Visible = true
    end)
    return Page
end

local MainP = CreatePage("Main")
local EspP = CreatePage("Visuals")
local SettingsP = CreatePage("Misc")

-- [[ 3. CRIAÇÃO DE CARDS (ESTILO FOTO) ]]
local function AddToggleCard(parent, text, globalVar)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, 0, 0, 50)
    Card.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    
    local Lab = Instance.new("TextLabel", Card)
    Lab.Size = UDim2.new(0.7, 0, 1, 0)
    Lab.Position = UDim2.new(0, 12, 0, 0)
    Lab.Text = text
    Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lab.Font = Enum.Font.GothamSemibold
    Lab.TextSize = 14
    Lab.TextXAlignment = Enum.TextXAlignment.Left
    Lab.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", Card)
    Switch.Size = UDim2.new(0, 45, 0, 24)
    Switch.Position = UDim2.new(1, -55, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 12)

    Switch.MouseButton1Click:Connect(function()
        getgenv()[globalVar] = not getgenv()[globalVar]
        TS:Create(Switch, TweenInfo.new(0.3), {BackgroundColor3 = getgenv()[globalVar] and Color3.fromRGB(0, 130, 255) or Color3.fromRGB(35, 38, 42)}):Play()
    end)
end

local function AddSliderCard(parent)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, 0, 0, 65)
    Card.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

    local Lab = Instance.new("TextLabel", Card)
    Lab.Size = UDim2.new(1, 0, 0, 25)
    Lab.Position = UDim2.new(0, 12, 0, 8)
    Lab.Text = "Hitbox Size: 5 studs"
    Lab.TextColor3 = Color3.fromRGB(180, 180, 180)
    Lab.Font = Enum.Font.Gotham
    Lab.TextSize = 13
    Lab.TextXAlignment = Enum.TextXAlignment.Left
    Lab.BackgroundTransparency = 1

    local Bar = Instance.new("Frame", Card)
    Bar.Size = UDim2.new(1, -30, 0, 5)
    Bar.Position = UDim2.new(0, 15, 0, 45)
    Bar.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
    Instance.new("UICorner", Fill)

    local Dot = Instance.new("TextButton", Bar)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = UDim2.new(0, -7, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Text = ""
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local dragging = false
    Dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Dot.Position = UDim2.new(p, -7, 0.5, -7)
            Fill.Size = UDim2.new(p, 0, 1, 0)
            getgenv().HitSize = math.floor(5 + (p * 45))
            Lab.Text = "Hitbox Size: " .. getgenv().HitSize .. " studs"
        end
    end)
end

-- Montando a página Main (Cards Separados)
AddToggleCard(MainP, "Lock Aimbot (Right Click)", "Aimbot")
AddToggleCard(MainP, "Enable Hitbox Expander", "Hitbox")
AddSliderCard(MainP)

-- [[ 4. LÓGICA DE COMBATE (REFORÇADA) ]]
local function GetClosestTarget()
    local target, dist = nil, 300
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local root = v.Character.HumanoidRootPart
                local pos, vis = camera:WorldToViewportPoint(root.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then target = root; dist = mag end
                end
            end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    if getgenv().Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosestTarget()
        if t then
            TS:Create(camera, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {CFrame = CFrame.new(camera.CFrame.Position, t.Position)}):Play()
        end
    end
end)

RS.Heartbeat:Connect(function()
    if getgenv().Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                hrp.Size = Vector3.new(getgenv().HitSize, getgenv().HitSize, getgenv().HitSize)
                hrp.Transparency = 0.8
                hrp.CanCollide = false
            end
        end
    end
end)

-- [[ 5. CONTROLE DE ANIMAÇÃO ]]
OpenBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
        task.wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 480, 0, 330), "Out", "Back", 0.4, true)
    end
end)

MainP.Visible = true