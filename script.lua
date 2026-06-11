-- Chống chạy đè script
if shared.DeltaMenuV5_Loaded then return end
shared.DeltaMenuV5_Loaded = true

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local lighting = game:GetService("Lighting")

-- HỆ THỐNG TỰ ĐỘNG LƯU TRẠNG THÁI (Bộ nhớ tạm shared)
if not shared.DeltaMenuV5_Config then
    shared.DeltaMenuV5_Config = {
        fly = false, flySpeed = "50", noclip = false, infJump = false, 
        fullbright = false, nofog = false, esp = false,
        tpWalk = false, tpWalkSpeed = "2", waypoints = {}
    }
end
local config = shared.DeltaMenuV5_Config

-- XÓA GUI CŨ NẾU CÓ
local oldGui = game:GetService("CoreGui"):FindFirstChild("DeltaGodMenuV5") or player.PlayerGui:FindFirstChild("DeltaGodMenuV5")
if oldGui then oldGui:Destroy() end

-- TẠO MENU GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaGodMenuV5"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = player:WaitForChild("PlayerGui") end

-- NÚT ẨN / HIỆN
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 90, 0, 30)
toggleButton.Position = UDim2.new(0.02, 0, 0.1, 0)
toggleButton.Text = "Ẩn Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = screenGui
local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 5) tCorner.Parent = toggleButton

-- KHUNG CHÍNH (Sắp xếp khít, không khoảng trống)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 360)
mainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Parent = screenGui
local mCorner = Instance.new("UICorner") mCorner.CornerRadius = UDim.new(0, 8) mCorner.Parent = mainFrame

-- THANH TIÊU ĐỀ (Để nắm kéo di chuyển)
local title = Instance.new("TextButton")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ DELTA GOD V5.3 ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- KHUNG CUỘN TÍNH NĂNG
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- LOGIC KÉO DI CHUYỂN MENU
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
title.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
userInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Hàm tạo nút nhanh
local function createBtn(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = scroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    return btn
end

-- TẠO CÁC NÚT TÍNH NĂNG
-- Khung Fly + Ô nhập Tốc độ bay
local flyFrame = Instance.new("Frame") flyFrame.Size = UDim2.new(1, -10, 0, 32) flyFrame.BackgroundTransparency = 1 flyFrame.Parent = scroll
local flyBtn = Instance.new("TextButton") flyBtn.Size = UDim2.new(0, 140, 1, 0) flyBtn.Text = "Bật Bay (Fly)" flyBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 70) flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255) flyBtn.Font = Enum.Font.SourceSansBold flyBtn.TextSize = 13 flyBtn.Parent = flyFrame
local flyC1 = Instance.new("UICorner") flyC1.CornerRadius = UDim.new(0, 5) flyC1.Parent = flyBtn
local flyVal = Instance.new("TextBox") flyVal.Size = UDim2.new(1, -145, 1, 0) flyVal.Position = UDim2.new(0, 145, 0, 0) flyVal.Text = config.flySpeed flyVal.BackgroundColor3 = Color3.fromRGB(45, 45, 45) flyVal.TextColor3 = Color3.fromRGB(255, 255, 255) flyVal.Font = Enum.Font.SourceSansBold flyVal.TextSize = 13 flyVal.Parent = flyFrame
local flyC2 = Instance.new("UICorner") flyC2.CornerRadius = UDim.new(0, 5) flyC2.Parent = flyVal

local noclipBtn = createBtn("Bật Noclip (Xuyên Tường)", Color3.fromRGB(140, 0, 140))
local infJumpBtn = createBtn("Bật Nhảy Vô Hạn", Color3.fromRGB(0, 110, 140))
local brightBtn = createBtn("Bật Fullbright (Làm Sáng)", Color3.fromRGB(160, 120, 0))
local fogBtn = createBtn("Bật NoFog (Xóa Sương)", Color3.fromRGB(120, 120, 120))
local espBtn = createBtn("Bật ESP", Color3.fromRGB(100, 40, 160))

-- Khung TP-Walk
local tpFrame = Instance.new("Frame") tpFrame.Size = UDim2.new(1, -10, 0, 32) tpFrame.BackgroundTransparency = 1 tpFrame.Parent = scroll
local tpBtn = Instance.new("TextButton") tpBtn.Size = UDim2.new(0, 140, 1, 0) tpBtn.Text = "Bật TP-Walk" tpBtn.BackgroundColor3 = Color3.fromRGB(140, 70, 0) tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255) tpBtn.Font = Enum.Font.SourceSansBold tpBtn.TextSize = 13 tpBtn.Parent = tpFrame
local tpc1 = Instance.new("UICorner") tpc1.CornerRadius = UDim.new(0, 5) tpc1.Parent = tpBtn
local tpVal = Instance.new("TextBox") tpVal.Size = UDim2.new(1, -145, 1, 0) tpVal.Position = UDim2.new(0, 145, 0, 0) tpVal.Text = config.tpWalkSpeed tpVal.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tpVal.TextColor3 = Color3.fromRGB(255, 255, 255) tpVal.Font = Enum.Font.SourceSansBold tpVal.TextSize = 13 tpVal.Parent = tpFrame
local tpc2 = Instance.new("UICorner") tpc2.CornerRadius = UDim.new(0, 5) tpc2.Parent = tpVal

-- Khung Waypoint
local wpFrame = Instance.new("Frame") wpFrame.Size = UDim2.new(1, -10, 0, 32) wpFrame.BackgroundTransparency = 1 wpFrame.Parent = scroll
local wpInp = Instance.new("TextBox") wpInp.Size = UDim2.new(0, 140, 1, 0) wpInp.PlaceholderText = "Tên điểm..." wpInp.Text = "" wpInp.BackgroundColor3 = Color3.fromRGB(45, 45, 45) wpInp.TextColor3 = Color3.fromRGB(255, 255, 255) wpInp.Font = Enum.Font.SourceSans wpInp.TextSize = 13 wpInp.Parent = wpFrame
local wpc1 = Instance.new("UICorner") wpc1.CornerRadius = UDim.new(0, 5) wpc1.Parent = wpInp
local wpAdd = Instance.new("TextButton") wpAdd.Size = UDim2.new(1, -145, 1, 0) wpAdd.Position = UDim2.new(0, 145, 0, 0) wpAdd.Text = "Lưu Điểm" wpAdd.BackgroundColor3 = Color3.fromRGB(0, 90, 180) wpAdd.TextColor3 = Color3.fromRGB(255, 255, 255) wpAdd.Font = Enum.Font.SourceSansBold wpAdd.TextSize = 12 wpAdd.Parent = wpFrame
local wpc2 = Instance.new("UICorner") wpc2.CornerRadius = UDim.new(0, 5) wpc2.Parent = wpAdd

local wpScroll = Instance.new("ScrollingFrame") wpScroll.Size = UDim2.new(1, -10, 0, 70) wpScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35) wpScroll.ScrollBarThickness = 2 wpScroll.Parent = scroll
local wpc3 = Instance.new("UICorner") wpc3.CornerRadius = UDim.new(0, 5) wpc3.Parent = wpScroll
local wpList = Instance.new("UIListLayout") wpList.Padding = UDim.new(0, 3) wpList.Parent = wpScroll
wpList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() wpScroll.CanvasSize = UDim2.new(0, 0, 0, wpList.AbsoluteContentSize.Y + 5) end)

---------------------------------------------------------
-- LOGIC TÍNH NĂNG CHUYÊN SÂU
---------------------------------------------------------
toggleButton.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible; toggleButton.Text = mainFrame.Visible and "Ẩn Menu" or "Hiện Menu" end)
local function updateVisual(btn, state, onT, offT, onC, offC) btn.Text = state and onT or offT; btn.BackgroundColor3 = state and onC or offC end

-- 1. FIX FLY MƯỢT MÀ + CHỈNH TỐC ĐỘ (Bằng CFrame gốc)
local flyConn, flyBV, flyBG
local function setFly(state)
    config.fly = state; config.flySpeed = flyVal.Text
    updateVisual(flyBtn, state, "Tắt Bay", "Bật Bay (Fly)", Color3.fromRGB(180, 30, 30), Color3.fromRGB(0, 140, 70))
    if flyConn then flyConn:Disconnect() end
    if flyBV then flyBV:Destroy() end if flyBG then flyBG:Destroy() end
    
    local char = player.Character local root = char and char:FindFirstChild("HumanoidRootPart") local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    
    if state then
        hum.PlatformStand = true
        flyBV = Instance.new("BodyVelocity") flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) flyBV.Velocity = Vector3.zero flyBV.Parent = root
        flyBG = Instance.new("BodyGyro") flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) flyBG.CFrame = root.CFrame flyBG.P = 15000 flyBG.Parent = root
        
        flyConn = runService.RenderStepped:Connect(function()
            if not root or not root.Parent then return end
            local speed = tonumber(flyVal.Text) or 50
            local direction = Vector3.zero
            if userInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
            if userInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
            if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction -= Vector3.new(0, 1, 0) end
            
            if direction.Magnitude > 0 then flyBV.Velocity = direction.Unit * speed else flyBV.Velocity = Vector3.zero end
            flyBG.CFrame = camera.CFrame
        end)
    else
        hum.PlatformStand = false
    end
end
flyBtn.MouseButton1Click:Connect(function() setFly(not config.fly) end)
flyVal.FocusLost:Connect(function() config.flySpeed = flyVal.Text; if config.fly then setFly(true) end end)

-- 2. NOCLIP
local noclipConn
local function setNoclip(state)
    config.noclip = state; updateVisual(noclipBtn, state, "Tắt Noclip", "Bật Noclip (Xuyên Tường)", Color3.fromRGB(180, 30, 30), Color3.fromRGB(140, 0, 140))
    if noclipConn then noclipConn:Disconnect() end
    if state then
        noclipConn = runService.Stepped:Connect(function()
            if player.Character then for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
    end
end
noclipBtn.MouseButton1Click:Connect(function() setNoclip(not config.noclip) end)

-- 3. INF JUMP
local jumpConn
local function setInfJump(state)
    config.infJump = state; updateVisual(infJumpBtn, state, "Tắt Nhảy Vô Hạn", "Bật Nhảy Vô Hạn", Color3.fromRGB(180, 30, 30), Color3.fromRGB(0, 110, 140))
    if jumpConn then jumpConn:Disconnect() end
    if state then jumpConn = userInputService.JumpRequest:Connect(function() pcall(function() player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end) end
end
infJumpBtn.MouseButton1Click:Connect(function() setInfJump(not config.infJump) end)

-- 4. FULLBRIGHT
local brightConn
local function setFullbright(state)
    config.fullbright = state; updateVisual(brightBtn, state, "Tắt Fullbright", "Bật Fullbright (Làm Sáng)", Color3.fromRGB(180, 30, 30), Color3.fromRGB(160, 120, 0))
    if brightConn then brightConn:Disconnect() end
    if state then
        brightConn = runService.RenderStepped:Connect(function()
            lighting.Brightness = 2; lighting.ClockTime = 14; lighting.GlobalShadows = false; lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end)
    end
end
brightBtn.MouseButton1Click:Connect(function() setFullbright(not config.fullbright) end)

-- 5. NO FOG
local fogConn
local function setNoFog(state)
    config.nofog = state; updateVisual(fogBtn, state, "Tắt NoFog", "Bật NoFog (Xóa Sương)", Color3.fromRGB(180, 30, 30), Color3.fromRGB(120, 120, 120))
    if fogConn then fogConn:Disconnect() end
    if state then
        fogConn = runService.RenderStepped:Connect(function()
            lighting.FogStart = 999999; lighting.FogEnd = 999999
            for _, v in pairs(lighting:GetDescendants()) do if v:IsA("Atmosphere") then v.Density = 0 end end
        end)
    end
end
fogBtn.MouseButton1Click:Connect(function() setNoFog(not config.nofog) end)

-- 6. ESP
local espConns = {}
local function addESP(plr)
    if plr == player then return end
    local function apply(char)
        if not config.esp then return end
        local hl = char:FindFirstChild("GodHighlight") or Instance.new("Highlight")
        hl.Name = "GodHighlight"; hl.FillColor = Color3.fromRGB(0, 255, 255); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
    end
    if plr.Character then apply(plr.Character) end
    espConns[plr] = plr.CharacterAdded:Connect(apply)
end
local function setESP(state)
    config.esp = state; updateVisual(espBtn, state, "Tắt ESP", "Bật ESP", Color3.fromRGB(180, 30, 30), Color3.fromRGB(100, 40, 160))
    for _, p in pairs(game.Players:GetPlayers()) do pcall(function() p.Character.GodHighlight:Destroy() end) end
    for _, c in pairs(espConns) do c:Disconnect() end espConns = {}
    if state then
        for _, p in pairs(game.Players:GetPlayers()) do addESP(p) end
        espConns["Add"] = game.Players.PlayerAdded:Connect(addESP)
    end
end
espBtn.MouseButton1Click:Connect(function() setESP(not config.esp) end)

-- 7. TP-WALK
local tpConn
local function setTpWalk(state)
    config.tpWalk = state; config.tpWalkSpeed = tpVal.Text
    updateVisual(tpBtn, state, "Tắt TP-Walk", "Bật TP-Walk", Color3.fromRGB(180, 30, 30), Color3.fromRGB(140, 70, 0))
    if tpConn then tpConn:Disconnect() end
    if state then
        tpConn = runService.RenderStepped:Connect(function()
            local char = player.Character local root = char and char:FindFirstChild("HumanoidRootPart") local hum = char and char:FindFirstChild("Humanoid")
            if root and hum and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * (tonumber(tpVal.Text) or 2)) end
        end)
    end
end
tpBtn.MouseButton1Click:Connect(function() setTpWalk(not config.tpWalk) end)
tpVal.FocusLost:Connect(function() config.tpWalkSpeed = tpVal.Text end)

-- 8. WAYPOINTS
local function createWpUI(name, x, y, z)
    local f = Instance.new("Frame") f.Size = UDim2.new(1, 0, 0, 24) f.BackgroundTransparency = 1 f.Name = name f.Parent = wpScroll
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, -30, 1, 0) b.Text = "📍 "..name b.BackgroundColor3 = Color3.fromRGB(50, 50, 50) b.TextColor3 = Color3.fromRGB(255,255,255) b.TextSize = 11 b.Parent = f
    local d = Instance.new("TextButton") d.Size = UDim2.new(0, 25, 1, 0) d.Position = UDim2.new(1, -25, 0, 0) d.Text = "❌" d.BackgroundColor3 = Color3.fromRGB(100,0,0) d.TextColor3 = Color3.fromRGB(255,255,255) d.TextSize = 10 d.Parent = f
    b.MouseButton1Click:Connect(function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y + 3, z) end end)
    d.MouseButton1Click:Connect(function() config.waypoints[name] = nil; f:Destroy() end)
end
wpAdd.MouseButton1Click:Connect(function()
    local n = wpInp.Text if n == "" or config.waypoints[n] then return end
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if r then local p = r.Position config.waypoints[n] = {p.X, p.Y, p.Z}; createWpUI(n, p.X, p.Y, p.Z); wpInp.Text = "" end
end)

-- RESET KHI HỒI SINH
player.CharacterAdded:Connect(function()
    task.wait(0.6)
    if config.fly then setFly(true) end
    if config.noclip then setNoclip(true) end
end)

-- KHỞI CHẠY CONFIG ĐÃ LƯU
if config.fly then setFly(true) end
if config.noclip then setNoclip(true) end
if config.infJump then setInfJump(true) end
if config.fullbright then setFullbright(true) end
if config.nofog then setNoFog(true) end
if config.esp then setESP(true) end
if config.tpWalk then setTpWalk(true) end
for n, p in pairs(config.waypoints) do createWpUI(n, p[1], p[2], p[3]) end
