local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- FILE CONFIG ĐỂ LƯU DATA (Chỉ hoạt động trên các Executor hỗ trợ file hệ thống như Delta)
local CONFIG_FILE = "DeltaGodMenu_Config.json"

local function saveConfig(data)
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        end)
    end
end

local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success then return result end
    end
    return {
        fly = false, noclip = false, infJump = false, 
        fullbright = false, nofog = false, esp = false,
        tpWalk = false, tpWalkSpeed = "2", waypoints = {}
    }
end

local config = loadConfig()

-- TẠO SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaGodMenuV5"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = player:WaitForChild("PlayerGui") end

-- NÚT ĐÓNG/MỞ MENU CHÍNH
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0.02, 0, 0.1, 0)
toggleButton.Text = "Ẩn Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = screenGui
local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 6) tCorner.Parent = toggleButton

-- KHUNG MENU CHÍNH
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 450)
mainFrame.Position = UDim2.new(0.02, 0, 0.16, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local mCorner = Instance.new("UICorner") mCorner.CornerRadius = UDim.new(0, 10) mCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ DELTA GOD HUB V5 ⚡"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Parent = mainFrame

local mainScroll = Instance.new("ScrollingFrame")
mainScroll.Size = UDim2.new(1, -10, 1, -45)
mainScroll.Position = UDim2.new(0, 5, 0, 40)
mainScroll.BackgroundTransparency = 1
mainScroll.BorderSizePixel = 0
mainScroll.ScrollBarThickness = 4
mainScroll.Parent = mainFrame

local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, 8)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainLayout.Parent = mainScroll

mainLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mainScroll.CanvasSize = UDim2.new(0, 0, 0, mainLayout.AbsoluteContentSize.Y + 20)
end)

local function createHackButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = mainScroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    return btn
end

---------------------------------------------------------
-- KHỞI TẠO CÁC NÚT TÍNH NĂNG
---------------------------------------------------------
local flyButton = createHackButton("Bật Bay (Fly)", Color3.fromRGB(0, 150, 80))
local noclipButton = createHackButton("Bật Noclip (Xuyên Tường)", Color3.fromRGB(150, 0, 150))
local infJumpButton = createHackButton("Bật Nhảy Vô Hạn", Color3.fromRGB(0, 120, 150))
local fullbrightButton = createHackButton("Bật Fullbright (Làm Sáng)", Color3.fromRGB(180, 140, 0))
local nofogButton = createHackButton("Bật NoFog (Xóa Sương)", Color3.fromRGB(140, 140, 140))
local espButton = createHackButton("Bật ESP (Xuyên Tường Người)", Color3.fromRGB(120, 50, 180))

-- Khung TP-Walk
local tpWalkFrame = Instance.new("Frame")
tpWalkFrame.Size = UDim2.new(0, 230, 0, 35)
tpWalkFrame.BackgroundTransparency = 1
tpWalkFrame.Parent = mainScroll

local tpWalkButton = Instance.new("TextButton")
tpWalkButton.Size = UDim2.new(0, 150, 1, 0)
tpWalkButton.Text = "Bật TP-Walk"
tpWalkButton.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
tpWalkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpWalkButton.Font = Enum.Font.SourceSansBold
tpWalkButton.TextSize = 14
tpWalkButton.Parent = tpWalkFrame
local tpBCC = Instance.new("UICorner") tpBCC.CornerRadius = UDim.new(0, 6) tpBCC.Parent = tpWalkButton

local tpWalkValue = Instance.new("TextBox")
tpWalkValue.Size = UDim2.new(0, 75, 1, 0)
tpWalkValue.Position = UDim2.new(0, 155, 0, 0)
tpWalkValue.Text = config.tpWalkSpeed
tpWalkValue.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tpWalkValue.TextColor3 = Color3.fromRGB(255, 255, 255)
tpWalkValue.Font = Enum.Font.SourceSansBold
tpWalkValue.TextSize = 14
tpWalkValue.Parent = tpWalkFrame
local tpVCC = Instance.new("UICorner") tpVCC.CornerRadius = UDim.new(0, 6) tpVCC.Parent = tpWalkValue

-- Khung Waypoint
local wpFrame = Instance.new("Frame")
wpFrame.Size = UDim2.new(0, 230, 0, 35)
wpFrame.BackgroundTransparency = 1
wpFrame.Parent = mainScroll

local wpInput = Instance.new("TextBox")
wpInput.Size = UDim2.new(0, 150, 1, 0)
wpInput.PlaceholderText = "Tên Waypoint..."
wpInput.Text = ""
wpInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
wpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
wpInput.Font = Enum.Font.SourceSans
wpInput.TextSize = 14
wpInput.Parent = wpFrame
local wpICorner = Instance.new("UICorner") wpICorner.CornerRadius = UDim.new(0, 6) wpICorner.Parent = wpInput

local addWpButton = Instance.new("TextButton")
addWpButton.Size = UDim2.new(0, 75, 1, 0)
addWpButton.Position = UDim2.new(0, 155, 0, 0)
addWpButton.Text = "Lưu Điểm"
addWpButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
addWpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addWpButton.Font = Enum.Font.SourceSansBold
addWpButton.TextSize = 13
addWpButton.Parent = wpFrame
local aCorner = Instance.new("UICorner") aCorner.CornerRadius = UDim.new(0, 6) aCorner.Parent = addWpButton

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(0, 230, 0, 120)
scrollList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollList.BorderSizePixel = 0
scrollList.ScrollBarThickness = 4
scrollList.Parent = mainScroll
local sCorner = Instance.new("UICorner") sCorner.CornerRadius = UDim.new(0, 6) sCorner.Parent = scrollList

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollList
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

---------------------------------------------------------
-- LOGIC CHI TIẾT & ĐỒNG BỘ AUTO-SAVE
---------------------------------------------------------

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "Ẩn Menu" or "Hiện Menu"
    toggleButton.BackgroundColor3 = mainFrame.Visible and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(200, 50, 50)
end)

-- Đổi trạng thái hiển thị của nút dựa theo config đã load
local function updateBtnVisual(button, state, onText, offText, onColor, offColor)
    button.Text = state and onText or offText
    button.BackgroundColor3 = state and onColor or offColor
end

-- 1. FLY
local bodyVelocity, bodyGyro, flyConnection
local function setFly(state)
    config.fly = state; saveConfig(config)
    updateBtnVisual(flyButton, state, "Tắt Bay", "Bật Bay (Fly)", Color3.fromRGB(200, 40, 40), Color3.fromRGB(0, 150, 80))
    
    if flyConnection then flyConnection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end
    
    if state then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity") bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) bodyVelocity.Parent = rootPart
        bodyGyro = Instance.new("BodyGyro") bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) bodyGyro.P = 10000 bodyGyro.Parent = rootPart
        
        flyConnection = runService.RenderStepped:Connect(function()
            if not rootPart or not rootPart.Parent then return end
            local moveVector = Vector3.zero
            if userInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += camera.CFrame.LookVector end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= camera.CFrame.LookVector end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += camera.CFrame.RightVector end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= camera.CFrame.RightVector end
            if moveVector.Magnitude > 0 then moveVector = moveVector.Unit * 60 end
            bodyVelocity.Velocity = moveVector bodyGyro.CFrame = camera.CFrame
        end)
    else
        humanoid.PlatformStand = false
    end
end
flyButton.MouseButton1Click:Connect(function() setFly(not config.fly) end)
player.CharacterAdded:Connect(function() task.wait(0.5); if config.fly then setFly(true) end end)

-- 2. NOCLIP
local noclipConnection
local function setNoclip(state)
    config.noclip = state; saveConfig(config)
    updateBtnVisual(noclipButton, state, "Tắt Noclip", "Bật Noclip (Xuyên Tường)", Color3.fromRGB(200, 40, 40), Color3.fromRGB(150, 0, 150))
    if noclipConnection then noclipConnection:Disconnect() end
    if state then
        noclipConnection = runService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end
noclipButton.MouseButton1Click:Connect(function() setNoclip(not config.noclip) end)

-- 3. INFINITE JUMP
local infJumpConnection
local function setInfJump(state)
    config.infJump = state; saveConfig(config)
    updateBtnVisual(infJumpButton, state, "Tắt Nhảy Vô Hạn", "Bật Nhảy Vô Hạn", Color3.fromRGB(200, 40, 40), Color3.fromRGB(0, 120, 150))
    if infJumpConnection then infJumpConnection:Disconnect() end
    if state then
        infJumpConnection = userInputService.JumpRequest:Connect(function()
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end
infJumpButton.MouseButton1Click:Connect(function() setInfJump(not config.infJump) end)

-- 4. FULLBRIGHT
local brightConnection
local function setFullbright(state)
    config.fullbright = state; saveConfig(config)
    updateBtnVisual(fullbrightButton, state, "Tắt Fullbright", "Bật Fullbright (Làm Sáng)", Color3.fromRGB(200, 40, 40), Color3.fromRGB(180, 140, 0))
    if brightConnection then brightConnection:Disconnect() end
    if state then
        brightConnection = runService.RenderStepped:Connect(function()
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 999999
            lighting.GlobalShadows = false
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end)
    end
end
fullbrightButton.MouseButton1Click:Connect(function() setFullbright(not config.fullbright) end)

-- 5. NO FOG
local fogConnection
local function setNoFog(state)
    config.nofog = state; saveConfig(config)
    updateBtnVisual(nofogButton, state, "Tắt NoFog", "Bật NoFog (Xóa Sương)", Color3.fromRGB(200, 40, 40), Color3.fromRGB(140, 140, 140))
    if fogConnection then fogConnection:Disconnect() end
    if state then
        fogConnection = runService.RenderStepped:Connect(function()
            lighting.FogStart = 999999
            lighting.FogEnd = 999999
            for _, v in pairs(lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then v.Density = 0 end
            end
        end)
    end
end
nofogButton.MouseButton1Click:Connect(function() setNoFog(not config.nofog) end)

-- 6. ESP (CHAMS)
local espConnections = {}
local function addESP(plr)
    if plr == player then return end
    local function applyChams(char)
        if not config.esp then return end
        local hl = char:FindFirstChild("GodHighlight") or Instance.new("Highlight")
        hl.Name = "GodHighlight"; hl.FillColor = Color3.fromRGB(0, 255, 255); hl.FillTransparency = 0.4; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
        local head = char:WaitForChild("Head", 5)
        if head and not head:FindFirstChild("ESPName") then
            local bb = Instance.new("BillboardGui") bb.Name = "ESPName"; bb.Size = UDim2.new(0, 100, 0, 30); bb.AlwaysOnTop = true; bb.StudsOffset = Vector3.new(0, 3, 0)
            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, 0, 1, 0); lbl.Text = plr.Name; lbl.TextColor3 = Color3.fromRGB(255, 255, 0); lbl.BackgroundTransparency = 1; lbl.Font = Enum.Font.SourceSansBold; lbl.TextSize = 13; lbl.Parent = bb; bb.Parent = head
        end
    end
    if plr.Character then applyChams(plr.Character) end
    espConnections[plr] = plr.CharacterAdded:Connect(applyChams)
end
local function removeESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character then
            if plr.Character:FindFirstChild("GodHighlight") then plr.Character.GodHighlight:Destroy() end
            if plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("ESPName") then plr.Character.Head.ESPName:Destroy() end
        end
    end
    for k, conn in pairs(espConnections) do conn:Disconnect() end; espConnections = {}
end
local function setESP(state)
    config.esp = state; saveConfig(config)
    updateBtnVisual(espButton, state, "Tắt ESP", "Bật ESP (Xuyên Tường Người)", Color3.fromRGB(200, 40, 40), Color3.fromRGB(120, 50, 180))
    removeESP()
    if state then
        for _, plr in pairs(game.Players:GetPlayers()) do addESP(plr) end
        espConnections["PlayerAdded"] = game.Players.PlayerAdded:Connect(addESP)
    end
end
espButton.MouseButton1Click:Connect(function() setESP(not config.esp) end)

-- 7. TP-WALK
local tpWalkConnection
local function setTpWalk(state)
    config.tpWalk = state; config.tpWalkSpeed = tpWalkValue.Text; saveConfig(config)
    updateBtnVisual(tpWalkButton, state, "Tắt TP-Walk", "Bật TP-Walk", Color3.fromRGB(200, 40, 40), Color3.fromRGB(150, 80, 0))
    if tpWalkConnection then tpWalkConnection:Disconnect() end
    if state then
        tpWalkConnection = runService.RenderStepped:Connect(function()
            local character = player.Character local rootPart = character and character:FindFirstChild("HumanoidRootPart") local humanoid = character and character:FindFirstChild("Humanoid")
            if not rootPart or not humanoid then return end
            local speedMultiplier = tonumber(tpWalkValue.Text) or 2
            if humanoid.MoveDirection.Magnitude > 0 then rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * speedMultiplier) end
        end)
    end
end
tpWalkButton.MouseButton1Click:Connect(function() setTpWalk(not config.tpWalk) end)
tpWalkValue.FocusLost:Connect(function() config.tpWalkSpeed = tpWalkValue.Text; saveConfig(config) end)

-- 8. WAYPOINT SYSTEM
local function createWaypointUI(name, x, y, z)
    local itemFrame = Instance.new("Frame") itemFrame.Size = UDim2.new(1, -6, 0, 30) itemFrame.BackgroundTransparency = 1 itemFrame.Name = name itemFrame.Parent = scrollList
    local tpBtn = Instance.new("TextButton") tpBtn.Size = UDim2.new(0, 180, 1, 0) tpBtn.Text = "📍 " .. name tpBtn.TextXAlignment = Enum.TextXAlignment.Left tpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255) tpBtn.Font = Enum.Font.SourceSans tpBtn.TextSize = 13 tpBtn.Parent = itemFrame
    local tpC = Instance.new("UICorner") tpC.CornerRadius = UDim.new(0, 4) tpC.Parent = tpBtn
    local delBtn = Instance.new("TextButton") delBtn.Size = UDim2.new(0, 30, 1, 0) delBtn.Position = UDim2.new(0, 185, 0, 0) delBtn.Text = "❌" delBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0) delBtn.TextColor3 = Color3.fromRGB(255, 255, 255) delBtn.Font = Enum.Font.SourceSansBold delBtn.TextSize = 11 delBtn.Parent = itemFrame
    local delC = Instance.new("UICorner") delC.CornerRadius = UDim.new(0, 4) delC.Parent = delBtn
    
    tpBtn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if config.fly and bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
            player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y + 3, z)
        end
    end)
    delBtn.MouseButton1Click:Connect(function()
        config.waypoints[name] = nil; saveConfig(config)
        itemFrame:Destroy()
    end)
end

addWpButton.MouseButton1Click:Connect(function()
    local wpName = wpInput.Text if wpName == "" or wpName:match("^%s*$") or config.waypoints[wpName] then return end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        config.waypoints[wpName] = {pos.X, pos.Y, pos.Z}
        saveConfig(config)
        createWaypointUI(wpName, pos.X, pos.Y, pos.Z)
        wpInput.Text = ""
    end
end)

-- KÍCH HOẠT CONFIG KHI MỞ MENU
task.spawn(function()
    task.wait(1)
    if config.fly then setFly(true) end
    if config.noclip then setNoclip(true) end
    if config.infJump then setInfJump(true) end
    if config.fullbright then setFullbright(true) end
    if config.nofog then setNoFog(true) end
    if config.esp then setESP(true) end
    if config.tpWalk then setTpWalk(true) end
    for name, pos in pairs(config.waypoints) do
        createWaypointUI(name, pos[1], pos[2], pos[3])
    end
end)
