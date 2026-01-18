-- [[ UNIVERSAL-HUB v2.5 FINAL - THE ARCHITECT ]]
-- Codename: @ayuks78 & @GmAI
-- Staus: 100% Functional | Anti-Bug Architecture

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [[ SISTEMA DE CONFIGURAÇÃO ISOLADO ]]
getgenv().Config = {
    Aimbot = false,
    Hitbox = false,
    HitSize = 12,
    Esp = false,
    Noclip = false,
    Boost = false,
    FovSize = 150,
    Smoothness = 0.25 -- Puxada mediana
}

-- [[ FOV VISUAL ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 150, 255)
FOVCircle.Transparency = 0.8
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [[ INTERFACE PROFISSIONAL - ESTRUTURA RÍGIDA ]]
local UI = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
UI.Name = "FinalHub_" .. math.random(100,999)

local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 0, 0, 0) -- Para animação de abertura
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Barra RGB Azul Animada (Rodapé)
local RGBBar = Instance.new("Frame", Main)
RGBBar.Size = UDim2.new(1, 0, 0, 3)
RGBBar.Position = UDim2.new(0, 0, 1, -3)
RGBBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
RGBBar.BorderSizePixel = 0
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        RGBBar.BackgroundColor3 = Color3.fromHSV(0.6, 0.8, 0.5 + math.sin(tick()*3)*0.3)
    end
end)

-- Sidebar (Cômodos Fixos)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -3)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -20)
Container.Position = UDim2.new(0, 150, 0, 10)
Container.BackgroundTransparency = 1

local Tabs = {}
function NewTab(name, id)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.Visible = (id == 1); P.BackgroundTransparency = 1; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -20, 0, 35); B.Position = UDim2.new(0, 10, 0, 50 + (id-1)*42)
    B.Text = name; B.BackgroundColor3 = (id == 1) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(20, 20, 25)
    B.TextColor3 = Color3.fromRGB(255, 255, 255); B.Font = "GothamBold"; B.TextSize = 11; Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.P.Visible = false; v.B.BackgroundColor3 = Color3.fromRGB(20, 20, 25) end
        P.Visible = true; B.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end)
    Tabs[id] = {P = P, B = B}
    return P
end

function AddToggle(parent, text, key)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 42); f.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", f)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextXAlignment = 0; l.BackgroundTransparency = 1; l.Font = "GothamBold"; l.TextSize = 11
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 36, 0, 18); b.Position = UDim2.new(1, -48, 0.5, -9); b.BackgroundColor3 = Color3.fromRGB(35, 35, 40); b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        getgenv().Config[key] = not getgenv().Config[key]
        TS:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = getgenv().Config[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 40)}):Play()
        if key == "Aimbot" then FOVCircle.Visible = getgenv().Config[key] end
    end)
end

-- CRIAÇÃO DAS ABAS (ORDEAL)
local Tab1 = NewTab("Main", 1)
local Tab2 = NewTab("Visual", 2)
local Tab3 = NewTab("Misc", 3)
local Tab4 = NewTab("Créditos", 4)

-- FUNÇÕES
AddToggle(Tab1, "Aimbot Magnético", "Aimbot")
AddToggle(Tab1, "Hitbox Pro", "Hitbox")
AddToggle(Tab2, "ESP Full Names", "Esp")
AddToggle(Tab3, "Noclip Ghost", "Noclip")
AddToggle(Tab3, "Ultra Boost FPS", "Boost")

-- [[ MOTORES DE FUNCIONAMENTO REAL ]]

-- Aimbot Magnético (Corrigido para não travar)
local function GetClosest()
    local target, dist = nil, getgenv().Config.FovSize
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    FOVCircle.Position = UIS:GetMouseLocation()
    FOVCircle.Radius = getgenv().Config.FovSize
    
    if getgenv().Config.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosest()
        if t then
            local p = camera:WorldToViewportPoint(t.Character.HumanoidRootPart.Position)
            local m = UIS:GetMouseLocation()
            mousemoverel((p.X - m.X) * getgenv().Config.Smoothness, (p.Y - m.Y) * getgenv().Config.Smoothness)
        end
    end

    if getgenv().Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            pcall(function()
                if v ~= lp and v.Character then
                    v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Config.HitSize, getgenv().Config.HitSize, getgenv().Config.HitSize)
                    v.Character.HumanoidRootPart.Transparency = 0.8
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end)
        end
    end
end)

-- Noclip & Boost (Otimizado)
task.spawn(function()
    while task.wait(1) do
        if getgenv().Config.Boost then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
            end
            settings().Rendering.QualityLevel = 1
        end
        if getgenv().Config.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- [[ ANIMAÇÃO DE ENTRADA (ESTILO DELTA) ]]
Main.Visible = true
TS:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back), {Size = UDim2.new(0, 580, 0, 320)}):Play()

-- Minimizar
local MinBtn = Instance.new("ImageButton", UI)
MinBtn.Size = UDim2.new(0, 45, 0, 45); MinBtn.Position = UDim2.new(0, 10, 0.5, -22); MinBtn.Image = "rbxassetid://6023454774"; MinBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Instance.new("UICorner", MinBtn); Instance.new("UIStroke", MinBtn).Color = Color3.fromRGB(0, 120, 255)
MinBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)