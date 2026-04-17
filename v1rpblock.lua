-- Part 1/10
local playersService = game:GetService("Players")
local lightingService = game:GetService("Lighting")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local materialService = game:GetService("MaterialService")
local workspaceService = game:GetService("Workspace")
local statsService = game:GetService("Stats")
local debrisService = game:GetService("Debris")
local textChatService = game:GetService("TextChatService")
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")

local clientPlayer = playersService.LocalPlayer
local PlayerGui = clientPlayer:WaitForChild("PlayerGui", 10)

local fs = {
    hasFolder = isfolder or function() return false end,
    makeFolder = makefolder or function() end,
    write = writefile or function() end,
    hasFile = isfile or function() return false end,
    read = readfile or function() return "" end,
    asset = getcustomasset or function(p) return p end
}
local cfg = {}
do
    local DIR = "V1rpWare2.0"
    local FILE = DIR.."/config.json"
    local function prep() if not fs.hasFolder(DIR) then fs.makeFolder(DIR) end end
    function cfg.load() prep() if not fs.hasFile(FILE) then return end local ok,t=pcall(game:GetService("HttpService").JSONDecode,game:GetService("HttpService"),fs.read(FILE)) if ok and type(t)=="table" then cfg._data=t end end
    function cfg.save() prep() local ok,s=pcall(game:GetService("HttpService").JSONEncode,game:GetService("HttpService"),cfg._data) if ok then fs.write(FILE,s) end end
    function cfg.get(k,default) local v=cfg._data[k] return v~=nil and v or default end
    function cfg.set(k,v) cfg._data[k]=v cfg.save() end
    cfg._data = {}
    cfg.load()
end

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "Loader"
loaderGui.Parent = PlayerGui
loaderGui.IgnoreGuiInset = true
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.DisplayOrder = 9999

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,10)
bg.BackgroundTransparency = 0.2
bg.Parent = loaderGui

local container = Instance.new("Frame")
container.Size = UDim2.new(0,380,0,270)
container.Position = UDim2.new(0.5,-190,0.5,-135)
container.BackgroundColor3 = Color3.fromRGB(20,20,20)
container.BackgroundTransparency = 0.1
container.BorderSizePixel = 0
container.Parent = loaderGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,20)
corner.Parent = container

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,100,0,100)
logo.Position = UDim2.new(0.5,-50,0.1,0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://6031075938"
logo.Parent = container
logo.ImageTransparency = 0

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0.35,0)
title.BackgroundTransparency = 1
title.Text = "V1rpblock 2.0"
title.TextColor3 = Color3.fromRGB(255,215,0)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = container

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0.8,0,0,10)
progressBar.Position = UDim2.new(0.1,0,0.6,0)
progressBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
progressBar.BorderSizePixel = 0
progressBar.Parent = container
local fill = Instance.new("Frame")
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(255,215,0)
fill.BorderSizePixel = 0
fill.Parent = progressBar
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0,5)
fillCorner.Parent = fill
local progCorner = Instance.new("UICorner")
progCorner.CornerRadius = UDim.new(0,5)
progCorner.Parent = progressBar

local spin = Instance.new("Frame")
spin.Size = UDim2.new(0,35,0,35)
spin.Position = UDim2.new(0.5,-17.5,0.75,0)
spin.BackgroundColor3 = Color3.fromRGB(255,215,0)
spin.BackgroundTransparency = 0.5
spin.Parent = container
local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(1,0)
spinCorner.Parent = spin

local thankYou = Instance.new("TextLabel")
thankYou.Size = UDim2.new(1,0,0,30)
thankYou.Position = UDim2.new(0,0,0.9,0)
thankYou.BackgroundTransparency = 1
thankYou.Text = "Thank you, Viper."
thankYou.TextColor3 = Color3.fromRGB(255,215,0)
thankYou.TextSize = 14
thankYou.Font = Enum.Font.Gotham
thankYou.TextScaled = true
thankYou.Parent = container

tweenService:Create(spin, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 360}):Play()

local progressTween = tweenService:Create(fill, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)})
progressTween:Play()

task.delay(3, function()
    progressTween:Cancel()
    fill.Size = UDim2.new(1,0,1,0)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://130149751335710"
        sound.Volume = 1
        sound.Parent = soundService
        sound:Play()
        debrisService:AddItem(sound, 5)
    end)
    tweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    tweenService:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    tweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    tweenService:Create(progressBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    tweenService:Create(spin, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    tweenService:Create(thankYou, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    tweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.delay(0.6, function() loaderGui:Destroy() end)
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
if not WindUI then error("WindUI failed to load") end

WindUI:AddTheme({
    Name = "RedGoldBlack",
    Accent = Color3.fromRGB(255, 215, 0),
    Background = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0,
    Outline = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(200, 200, 200),
    Button = Color3.fromRGB(139, 0, 0),
    Icon = Color3.fromRGB(255, 215, 0),
    Hover = Color3.fromRGB(255, 215, 0),
    WindowBackground = Color3.fromRGB(0, 0, 0),
    WindowShadow = Color3.fromRGB(20, 20, 20),
    DialogBackground = Color3.fromRGB(0, 0, 0),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromRGB(255, 215, 0),
    DialogContent = Color3.fromRGB(255, 255, 255),
    DialogIcon = Color3.fromRGB(255, 215, 0),
    WindowTopbarButtonIcon = Color3.fromRGB(255, 215, 0),
    WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
    WindowTopbarAuthor = Color3.fromRGB(200, 200, 200),
    WindowTopbarIcon = Color3.fromRGB(255, 215, 0),
    TabBackground = Color3.fromRGB(20, 20, 20),
    TabTitle = Color3.fromRGB(255, 255, 255),
    TabIcon = Color3.fromRGB(255, 215, 0),
    ElementBackground = Color3.fromRGB(25, 25, 25),
    ElementTitle = Color3.fromRGB(255, 255, 255),
    ElementDesc = Color3.fromRGB(200, 200, 200),
    ElementIcon = Color3.fromRGB(255, 215, 0),
    PopupBackground = Color3.fromRGB(0, 0, 0),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromRGB(255, 215, 0),
    PopupContent = Color3.fromRGB(255, 255, 255),
    PopupIcon = Color3.fromRGB(255, 215, 0),
    Toggle = Color3.fromRGB(139, 0, 0),
    ToggleBar = Color3.fromRGB(80, 80, 80),
    Checkbox = Color3.fromRGB(139, 0, 0),
    CheckboxIcon = Color3.fromRGB(255, 215, 0),
    Slider = Color3.fromRGB(139, 0, 0),
    SliderThumb = Color3.fromRGB(255, 215, 0),
})
WindUI:SetTheme("RedGoldBlack")

local Window = WindUI:CreateWindow({
    Title = "V1rpblock 2.0",
    Icon = "sparkles",
    Author = "TheLevelist",
    Folder = "V1rpWare2.0",
    Size = UDim2.fromOffset(420, 550),
    Theme = "RedGoldBlack",
    Resizable = false,
    SideBarWidth = 160,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})
Window:SetToggleKey(Enum.KeyCode.K)
WindUI:SetFont("rbxasset://fonts/families/AccanthisADFStd.json")
Window:EditOpenButton({
    Title = "V1rpblock",
    Icon = "sparkles",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 0,
    Color = ColorSequence.new(Color3.fromHex("000000"), Color3.fromHex("000000")),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

local SentinelTab = Window:Tab({Title = "Sentinel", Icon = "shield"})
local BetterDetectionTab = Window:Tab({Title = "Better Detection", Icon = "target"})
local SphereTab = Window:Tab({Title = "Sphere Block", Icon = "target"})
local ReverseTab = Window:Tab({Title = "Reverse Block", Icon = "refresh"})
local LegacyTab = Window:Tab({Title = "Legacy", Icon = "history"})
local PunchTab = Window:Tab({Title = "Punch Controller", Icon = "fist"})
local MiscTab = Window:Tab({Title = "Misc", Icon = "settings"})
local InterfaceTab = Window:Tab({Title = "Interface", Icon = "scan"})
-- Part 2/10
local BASE_SPEED = 12
local BASE_PUNCH_FORCE = 40
local PUNCH_WINDUP = 0.7
local PARRY_WINDUP = 0.4

local stamModule = nil
local function getStamModule()
    if stamModule == nil then
        local ok, m = pcall(function() return require(replicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")) end)
        if ok then stamModule = m else stamModule = false end
    end
    return stamModule ~= false and stamModule or nil
end

local function setSprintingEnabled(enabled)
    local mod = getStamModule()
    if mod then
        if mod.SetSprinting then
            mod:SetSprinting(enabled)
        elseif mod.SetSprintingEnabled then
            mod:SetSprintingEnabled(enabled)
        elseif mod.SetStaminaEnabled then
            mod:SetStaminaEnabled(enabled)
        elseif mod.DisableSprinting then
            mod:DisableSprinting(not enabled)
        end
    end
end

local function findHitboxPart(killerModel)
    local globalHitboxes = workspaceService:FindFirstChild("Hitboxes")
    if globalHitboxes then
        local bestPart = nil
        local bestVolume = 0
        for _, child in ipairs(globalHitboxes:GetChildren()) do
            if child:IsA("BasePart") then
                local vol = child.Size.X * child.Size.Y * child.Size.Z
                if vol > bestVolume then
                    bestVolume = vol
                    bestPart = child
                end
            end
        end
        if bestPart then return bestPart end
    end
    local hitboxesFolder = killerModel:FindFirstChild("Hitboxes")
    if hitboxesFolder then
        for _, child in ipairs(hitboxesFolder:GetChildren()) do
            if child:IsA("BasePart") then
                return child
            end
        end
    end
    for _, child in ipairs(killerModel:GetDescendants()) do
        if child:IsA("BasePart") and child.Name:lower():find("hitbox") then
            return child
        end
    end
    return nil
end

local function getBetterDetectionSize()
    local preset = cfg.get("guestBetterDetectionPreset", "Standard")
    if preset == "Standard" then
        return Vector3.new(4.5, 6, 7.5)
    elseif preset == "Short" then
        return Vector3.new(4.5, 6, 5.5)
    elseif preset == "Forward-offset" then
        return Vector3.new(4.5, 6, 7.5)
    elseif preset == "Manual" then
        return Vector3.new(cfg.get("guestBetterDetectionManualX", 4.5), cfg.get("guestBetterDetectionManualY", 6), cfg.get("guestBetterDetectionManualZ", 7.5))
    end
    return Vector3.new(4.5, 6, 7.5)
end

local function isBlockReady()
    if cfg.get("noHDTCooldown", false) then return true end
    local mainUI = PlayerGui:FindFirstChild("MainUI")
    if mainUI then
        local abilityContainer = mainUI:FindFirstChild("AbilityContainer")
        if abilityContainer then
            local block = abilityContainer:FindFirstChild("Block")
            if block then
                local cooldownTime = block:FindFirstChild("CooldownTime")
                if cooldownTime and cooldownTime:IsA("TextLabel") then
                    local text = cooldownTime.Text
                    local num = text:match("[%d%.]+")
                    if num then
                        local val = tonumber(num)
                        if val and val <= 0 then
                            return true
                        else
                            return false
                        end
                    else
                        return true
                    end
                end
            end
        end
    end
    return true
end

local function guestFireRemoteBlock()
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    remote:FireServer("UseActorAbility", { [1] = buffer.fromstring("\3\5\0\0\0Block") })
end

local function guestFireRemotePunch()
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    remote:FireServer("UseActorAbility", { [1] = buffer.fromstring("\3\5\0\0\0Punch") })
end

local function isPointInsidePart(part, point)
    if not part or not point then return false end
    local rel = part.CFrame:PointToObjectSpace(point)
    local half = part.Size * 0.5
    return math.abs(rel.X) <= half.X + 0.001 and math.abs(rel.Y) <= half.Y + 0.001 and math.abs(rel.Z) <= half.Z + 0.001
end

local function showCinematicText()
    if not cfg.get("guestCinematicTextEnabled", false) then return end
    local text = cfg.get("guestCinematicText", "PARRY!")
    if cinematicGui then cinematicGui:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "CinematicText"
    gui.Parent = PlayerGui
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 10000
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 100)
    textLabel.Position = UDim2.new(0, 0, 0.4, -50)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextSize = 60
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.RichText = true
    textLabel.Parent = gui
    cinematicGui = gui
    task.delay(1.5, function() if cinematicGui then cinematicGui:Destroy() end end)
end

local function playCustomPunchSound()
    local soundId = cfg.get("customPunchSoundId", 0)
    if soundId and soundId ~= 0 then
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(soundId)
            sound.Volume = 1
            sound.Parent = soundService
            sound:Play()
            debrisService:AddItem(sound, 3)
        end)
    end
end
-- Part 3/10
local function guestPerformHitboxDrag(killerModel)
    if not cfg.get("guestHitboxDraggingOn", false) or not killerModel then return end
    local dragMode = cfg.get("guestHitboxMode", "Blatant")
    local faceKiller = cfg.get("guestHitboxFaceKiller", false)
    local visual = cfg.get("guestHitboxVisual", false)
    local targetMode = cfg.get("guestHitboxTargetMode", "Root")
    local dragDuration = cfg.get("guestHitboxDragDuration", 1.0)

    local targetPart
    if dragMode == "Hitbox" then
        targetPart = findHitboxPart(killerModel)
        if not targetPart then
            dragMode = "Blatant"
        end
    end

    if dragMode ~= "Hitbox" and not targetPart then
        if targetMode == "Arms" or targetMode == "Random" then
            local armNames = {"Right Arm", "Left Arm", "RightHand", "LeftHand", "RightUpperArm", "LeftUpperArm"}
            local arms = {}
            for _, name in ipairs(armNames) do
                local arm = killerModel:FindFirstChild(name)
                if arm and arm:IsA("BasePart") then
                    table.insert(arms, arm)
                end
            end
            if #arms > 0 then
                if targetMode == "Arms" then
                    targetPart = arms[1]
                elseif targetMode == "Random" then
                    if math.random() < 0.5 then
                        targetPart = killerModel:FindFirstChild("HumanoidRootPart") or killerModel:FindFirstChild("Torso")
                    else
                        targetPart = arms[math.random(#arms)]
                    end
                end
            end
        end
        if not targetPart then
            targetPart = killerModel:FindFirstChild("HumanoidRootPart") or killerModel:FindFirstChild("Torso")
        end
        if not targetPart then
            for _, child in ipairs(killerModel:GetDescendants()) do
                if child:IsA("BasePart") then
                    targetPart = child
                    break
                end
            end
        end
    end

    if not targetPart then return end

    local myChar = clientPlayer.Character
    local myHumanoid = myChar and myChar:FindFirstChild("Humanoid")
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHumanoid or not myRoot then return end

    if dragMode == "Legit" then
        local legitSpeed = cfg.get("hdtLegitSpeed", 140)
        local originalWalkSpeed = myHumanoid.WalkSpeed
        local originalAutoRotate = myHumanoid.AutoRotate
        myHumanoid.AutoRotate = false
        myHumanoid.WalkSpeed = 0
        setSprintingEnabled(true)

        local startTime = tick()
        local moveConnection
        local beam
        if visual then
            beam = Instance.new("Part")
            beam.Size = Vector3.new(0.5, 0.5, 0.5)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Transparency = 0.3
            beam.Color = Color3.fromRGB(0, 255, 0)
            beam.Parent = workspaceService
            debrisService:AddItem(beam, dragDuration + 0.1)
        end
        WindUI:Notify({Title="HDT (Legit)", Content="Sprinting toward killer for "..dragDuration.."s", Duration=2})

        moveConnection = runService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            if elapsed >= dragDuration or not cfg.get("guestHitboxDraggingOn", false) or not targetPart or not targetPart.Parent or not myHumanoid or not myHumanoid.Parent then
                moveConnection:Disconnect()
                myHumanoid.WalkSpeed = originalWalkSpeed
                myHumanoid.AutoRotate = originalAutoRotate
                setSprintingEnabled(false)
                if beam then beam:Destroy() end
                return
            end
            local targetPos = targetPart.Position
            myHumanoid:MoveTo(targetPos)
            if faceKiller then
                local dir = (targetPart.Position - myRoot.Position).Unit
                myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + dir)
            end
            if beam then
                beam.CFrame = CFrame.lookAt(myRoot.Position, targetPart.Position)
                beam.Size = Vector3.new(0.5, 0.5, (myRoot.Position - targetPart.Position).Magnitude)
            end
        end)
    else
        local blatantSpeed = cfg.get("hdtBlatantSpeed", 150)
        local targetSpeed = blatantSpeed
        local originalWalkSpeed = myHumanoid.WalkSpeed
        local originalAutoRotate = myHumanoid.AutoRotate
        myHumanoid.WalkSpeed = 0
        myHumanoid.AutoRotate = false
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.P = 100000
        bodyVelocity.Parent = myRoot
        local startTime = tick()
        local dragConnection
        local beam
        if visual then
            beam = Instance.new("Part")
            beam.Size = Vector3.new(0.5, 0.5, 0.5)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Transparency = 0.3
            beam.Color = Color3.fromRGB(0, 255, 0)
            beam.Parent = workspaceService
            debrisService:AddItem(beam, dragDuration + 0.1)
        end
        WindUI:Notify({Title="HDT (Blatant)", Content="Tweening for "..dragDuration.."s", Duration=2})
        dragConnection = runService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            if elapsed >= dragDuration or not cfg.get("guestHitboxDraggingOn", false) or not targetPart or not targetPart.Parent or not myHumanoid or not myHumanoid.Parent then
                dragConnection:Disconnect()
                dragConnection = nil
                bodyVelocity:Destroy()
                myHumanoid.WalkSpeed = originalWalkSpeed
                myHumanoid.AutoRotate = originalAutoRotate
                if beam then beam:Destroy() end
                return
            end
            local predictionTime = 0.15
            local targetPos = targetPart.Position + targetPart.Velocity * predictionTime
            local direction = (targetPos - myRoot.Position).Unit
            bodyVelocity.Velocity = direction * targetSpeed
            if faceKiller then
                local dir = (targetPart.Position - myRoot.Position).Unit
                myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + dir)
            end
            if beam then
                beam.CFrame = CFrame.lookAt(myRoot.Position, targetPart.Position)
                beam.Size = Vector3.new(0.5, 0.5, (myRoot.Position - targetPart.Position).Magnitude)
            end
        end)
    end
end

local function guestSpawnBetterDetection(killerModel)
    if not killerModel or not cfg.get("guestBetterDetectionEnabled", false) then return end
    local hrp = killerModel:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local size = getBetterDetectionSize()
    local offset = cfg.get("guestBetterDetectionOffset", 0)
    local count = math.max(1, cfg.get("guestBetterDetectionSegments", 6))
    local startDist = cfg.get("guestBetterDetectionStartDist", 2.7)
    local stepDist = cfg.get("guestBetterDetectionStepDist", 0.2)
    local preDelay = cfg.get("guestBetterDetectionDelay", 0)
    local stagger = cfg.get("guestBetterDetectionStagger", 0.02)
    local lifetime = cfg.get("guestBetterDetectionLifetime", 0.25)

    task.spawn(function()
        if preDelay > 0 then task.wait(preDelay) end
        for i = 1, count do
            if not hrp or not hrp.Parent then break end
            local dist = startDist + (i-1) * stepDist
            local forward = hrp.CFrame.LookVector
            local spawnPos = hrp.Position + forward * (dist + offset)

            local part = Instance.new("Part")
            part.Name = "BetterDetection"
            part.Size = size
            part.Anchored = true
            part.CanCollide = false
            part.CanTouch = true
            part.Transparency = 0.7
            part.Color = Color3.fromRGB(0,150,255)
            part.Material = Enum.Material.ForceField
            part.CFrame = CFrame.lookAt(spawnPos, hrp.Position)
            part.Parent = workspaceService
            debrisService:AddItem(part, lifetime)

            local myChar = clientPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot and isPointInsidePart(part, myRoot.Position) then
                guestFireRemoteBlock()
                cfg.set("guestLastBlockTime", tick())
                if cfg.get("guestAutoPunchOn", true) then task.delay(0.3, guestFireRemotePunch) end
                showCinematicText()
                break
            end
            if i < count and stagger > 0 then
                task.wait(stagger)
            end
        end
    end)
end
-- Part 4/10
local function guestAttemptBlock(killerModel)
    if not cfg.get("guestAutoBlockAudioOn", true) then return end
    local t = tick()
    local lastBlock = cfg.get("guestLastBlockTime", 0)
    local blockCooldown = cfg.get("guestBlockCooldown", 0.35)
    if t < lastBlock + blockCooldown then return end
    if not isBlockReady() then return end

    local myChar = clientPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not killerModel then return end
    local killerHRP = killerModel:FindFirstChild("HumanoidRootPart")
    if not killerHRP then return end

    local blockDelay = cfg.get("guestBlockDelay", 0)
    task.delay(blockDelay, function()
        local stillValid = myChar and myChar:FindFirstChild("HumanoidRootPart") and killerModel and killerModel.Parent
        if not stillValid then return end
        if not isBlockReady() then return end

        local useBlockBox = cfg.get("guestUseBlockBox", false)
        local reverseEnabled = cfg.get("guestReverseEnabled", false)
        local sphereMode = cfg.get("guestSphereModeEnabled", false)
        local sphereSize = cfg.get("guestSphereSize", 10)
        local detectionRange = cfg.get("guestDetectionRange", 20)
        local hitboxDrag = cfg.get("guestHitboxDraggingOn", false)
        local triggerRadius = cfg.get("guestHitboxTriggerRadius", 15)

        local shouldBlock = false
        if useBlockBox then
            if reverseEnabled then
                if blockBoxPart and isPointInsidePart(blockBoxPart, killerHRP.Position) then
                    shouldBlock = true
                end
            else
                if blockBoxPart and isPointInsidePart(blockBoxPart, myRoot.Position) then
                    shouldBlock = true
                end
            end
        elseif sphereMode then
            local dist = (killerHRP.Position - myRoot.Position).Magnitude
            if dist <= sphereSize then
                shouldBlock = true
            end
        else
            local dist = (killerHRP.Position - myRoot.Position).Magnitude
            if dist <= detectionRange then
                shouldBlock = true
            end
        end

        if shouldBlock then
            if hitboxDrag then
                local distToKiller = (killerHRP.Position - myRoot.Position).Magnitude
                if distToKiller <= triggerRadius then
                    guestPerformHitboxDrag(killerModel)
                end
            end
            guestFireRemoteBlock()
            cfg.set("guestLastBlockTime", tick())
            if cfg.get("guestAutoPunchOn", true) then task.delay(0.3, guestFireRemotePunch) end
            showCinematicText()
        end
    end)
end

local guestAutoBlockTriggerSounds = {
    ["102228729296384"] = true, ["140242176732868"] = true, ["112809109188560"] = true, ["136323728355613"] = true,
    ["115026634746636"] = true, ["84116622032112"] = true, ["108907358619313"] = true, ["127793641088496"] = true,
    ["86174610237192"] = true, ["95079963655241"] = true, ["101199185291628"] = true, ["119942598489800"] = true,
    ["84307400688050"] = true, ["113037804008732"] = true, ["105200830849301"] = true, ["75330693422988"] = true,
    ["82221759983649"] = true, ["109348678063422"] = true, ["81702359653578"] = true, ["85853080745515"] = true,
    ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true, ["12222216"] = true,
    ["79980897195554"] = true, ["119583605486352"] = true, ["71834552297085"] = true, ["116581754553533"] = true,
    ["86833981571073"] = true, ["110372418055226"] = true, ["105840448036441"] = true, ["86494585504534"] = true,
    ["80516583309685"] = true, ["131406927389838"] = true, ["89004992452376"] = true, ["117231507259853"] = true,
    ["101698569375359"] = true, ["101553872555606"] = true, ["140412278320643"] = true, ["106300477136129"] = true,
    ["117173212095661"] = true, ["104910828105172"] = true, ["140194172008986"] = true, ["85544168523099"] = true,
    ["114506382930939"] = true, ["99829427721752"] = true, ["120059928759346"] = true, ["104625283622511"] = true,
    ["105316545074913"] = true, ["126131675979001"] = true, ["82336352305186"] = true, ["93366464803829"] = true,
    ["84069821282466"] = true, ["128856426573270"] = true, ["121954639447247"] = true, ["128195973631079"] = true,
    ["124903763333174"] = true, ["94317217837143"] = true, ["98111231282218"] = true, ["119089145505438"] = true,
    ["136728245733659"] = true, ["71310583817000"] = true, ["107444859834748"] = true, ["76959687420003"] = true,
    ["72425554233832"] = true, ["96594507550917"] = true, ["139996647355899"] = true, ["107345261604889"] = true,
    ["127557531826290"] = true, ["108651070773439"] = true, ["74842815979546"] = true,
    ["124397369810639"] = true, 
    ["76467993976301"] = true, ["118493324723683"] = true, ["78298577002481"] = true, ["116527305931161"] = true,["5148302439"] = true, ["98675142200448"] = true, ["128367348686124"] = true, ["71805956520207"] = true, ["125213046326879"] = true,["84353899757208"] = true,
    ["103684883268194"] = true,
    ["109246041199659"] = true,
    ["80540530406270"] = true,
    ["139523195429581"] = true,
    ["105204810054381"] = true,
}

local function guestExtractNumericSoundId(sound)
    if not sound then return nil end
    local sid = tostring(sound.SoundId)
    local num = sid:match("%d+")
    if num then return num end
    local hash = sid:match("[&%?]hash=([^&]+)")
    if hash then return "&hash="..hash end
    local path = sid:match("rbxasset://sounds/.+")
    if path then return path end
    return nil
end

local function guestGetSoundWorldPosition(sound)
    if not sound then return nil end
    if sound.Parent and sound.Parent:IsA("BasePart") then
        return sound.Parent.Position, sound.Parent
    end
    if sound.Parent and sound.Parent:IsA("Attachment") and sound.Parent.Parent and sound.Parent.Parent:IsA("BasePart") then
        return sound.Parent.Parent.Position, sound.Parent.Parent
    end
    local found = sound.Parent and sound.Parent:FindFirstChildWhichIsA("BasePart", true)
    if found then return found.Position, found end
    return nil, nil
end

local function guestGetCharacterFromDescendant(inst)
    if not inst then return nil end
    local model = inst:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
        if killersFolder and model:IsDescendantOf(killersFolder) then
            return model
        end
    end
    return nil
end
-- Part 5/10
local function guestAttemptBlockForSound(sound, preId)
    if not cfg.get("guestAutoBlockAudioOn", true) then return end
    if not sound or not sound:IsA("Sound") then return end
    local id = preId or guestExtractNumericSoundId(sound)
    if not id or not guestAutoBlockTriggerSounds[id] then return end
    local t = tick()
    local blockedUntil = cfg.get("guestSoundBlockedUntil", {})[sound]
    if blockedUntil and t < blockedUntil then return end
    local lastBlock = cfg.get("guestLastBlockTime", 0)
    local blockCooldown = cfg.get("guestBlockCooldown", 0.35)
    if t < lastBlock + blockCooldown then return end

    local myChar = clientPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local _, soundPart = guestGetSoundWorldPosition(sound)
    if not soundPart then return end
    local killerModel = guestGetCharacterFromDescendant(soundPart)
    if not killerModel then return end
    local hrp = killerModel:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not cfg.get("guestUseBlockBox", false) and not cfg.get("guestSphereModeEnabled", false) then
        local detectionRange = cfg.get("guestDetectionRange", 20)
        local detectionRangeSq = detectionRange * detectionRange
        local distSq = (hrp.Position - myRoot.Position).Magnitude^2
        local pingComp = 0.2 * detectionRange
        if distSq > detectionRangeSq + pingComp then return end
        if cfg.get("guestVerifyFacingCheckOn", true) then
            local success, result = pcall(function()
                local dirToPlayer = (myRoot.Position - hrp.Position).Unit
                local dot = hrp.CFrame.LookVector:Dot(dirToPlayer)
                local visionAngle = cfg.get("guestVisionAngle", 85)
                local cosAngle = math.cos(math.rad(visionAngle / 2))
                local close = distSq < 25
                return close or dot >= cosAngle
            end)
            if not success or not result then return end
        end
    end

    if cfg.get("guestBetterDetectionEnabled", false) then
        guestSpawnBetterDetection(killerModel)
    end
    guestAttemptBlock(killerModel)

    local soundBlockedUntil = cfg.get("guestSoundBlockedUntil", {})
    soundBlockedUntil[sound] = t + cfg.get("guestSoundBlockDuration", 0.5)
    cfg.set("guestSoundBlockedUntil", soundBlockedUntil)
end

local function guestHookSound(sound)
    if not sound or not sound:IsA("Sound") then return end
    local hooks = cfg.get("guestSoundHooks", {})
    if hooks[sound] then return end
    local preId = guestExtractNumericSoundId(sound)
    if not preId then return end
    local playedConn = sound.Played:Connect(function() if cfg.get("guestAutoBlockAudioOn", true) then task.spawn(guestAttemptBlockForSound, sound, preId) end end)
    local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function() if sound.IsPlaying and cfg.get("guestAutoBlockAudioOn", true) then task.spawn(guestAttemptBlockForSound, sound, preId) end end)
    local destroyConn = sound.Destroying:Connect(function()
        pcall(function() playedConn:Disconnect() propConn:Disconnect() destroyConn:Disconnect() end)
        local hooks = cfg.get("guestSoundHooks", {})
        hooks[sound] = nil
        cfg.set("guestSoundHooks", hooks)
        local blocked = cfg.get("guestSoundBlockedUntil", {})
        blocked[sound] = nil
        cfg.set("guestSoundBlockedUntil", blocked)
    end)
    hooks[sound] = {playedConn, propConn, destroyConn, id = preId}
    cfg.set("guestSoundHooks", hooks)
    if sound.IsPlaying then task.spawn(guestAttemptBlockForSound, sound, preId) end
end

local function guestHookExistingSounds()
    local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, killer in pairs(killersFolder:GetChildren()) do
            for _, desc in pairs(killer:GetDescendants()) do
                if desc:IsA("Sound") then pcall(guestHookSound, desc) end
            end
        end
    end
end

local function guestSetupSoundHooks()
    local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
    if killersFolder then
        guestHookExistingSounds()
        killersFolder.DescendantAdded:Connect(function(desc) if desc:IsA("Sound") then pcall(guestHookSound, desc) end end)
        killersFolder.ChildRemoved:Connect(function()
            task.wait(0.1)
            guestHookExistingSounds()
        end)
    else
        local folder = workspaceService:WaitForChild("Players"):WaitForChild("Killers")
        guestSetupSoundHooks()
    end
end

local guestHumanoid, guestHRP = nil, nil
local guestPunchAiming = false
local guestPunchLastTriggerTime = 0
local guestOriginalWS, guestOriginalJP, guestOriginalAutoRotate = nil, nil, nil
local guestAimConnection = nil
local guestKillerState = {}
local guestTrackedPunchAnimations = {
    ["87259391926321"] = true, ["140703210927645"] = true, ["136007065400978"] = true, ["129843313690921"] = true,
    ["86709774283672"] = true, ["108807732150251"] = true, ["138040001965654"] = true, ["86096387000557"] = true,
    ["81905101227053"] = true, ["108807732150251"] = true, ["127777649118195"] = true, ["99100240941590"] = true,
    ["92831180929659"] = true, ["112081768119093"] = true, ["117587689359268"] = true, ["91830732867282"] = true,
    ["91730605416216"] = true, ["100184164753080"] = true, ["91730605416216"] = true,
}
local guestAimTargets = {"Slasher", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli", "Sixer", "Nosferatu"}
local SMOOTHING_LERP = 0.22
local blockBoxPart = nil
local spherePart = nil
local hdtRangePart = nil
local pingLabel = nil
local cinematicGui = nil
local hdtCooldownGui = nil
local hdtCooldownLabel = nil

local function guestSetupCharacter(char)
    guestHumanoid = char:FindFirstChild("Humanoid")
    guestHRP = char:FindFirstChild("HumanoidRootPart")
    if guestAimConnection then guestAimConnection:Disconnect() guestAimConnection = nil end
    local animator = guestHumanoid and guestHumanoid:FindFirstChildOfClass("Animator")
    if animator and cfg.get("guestAimPunchActive", true) then
        guestAimConnection = animator.AnimationPlayed:Connect(function(track)
            local animId = track.Animation.AnimationId:match("%d+")
            if cfg.get("guestAimPunchActive", true) and guestTrackedPunchAnimations[animId] then
                guestPunchLastTriggerTime = tick()
                guestPunchAiming = true
            end
        end)
    end
end

guestSetupSoundHooks()
playersService.LocalPlayer.CharacterAdded:Connect(function(char) task.delay(0.5, function() guestCleanupVisionCone() guestSetupCharacter(char) end) end)
if clientPlayer.Character then guestSetupCharacter(clientPlayer.Character) end
-- Part 6/10
local guestCenterPart, guestLeftPart, guestRightPart, guestLeftToKillerPart, guestRightToKillerPart, guestLeftToCenterPart, guestCenterToRightPart = nil, nil, nil, nil, nil, nil, nil

local function guestCreateVisionPart()
    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Shape = Enum.PartType.Ball
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    part.Color = Color3.fromRGB(255,0,0)
    part.Parent = workspaceService
    return part
end

local function guestCreateConnectionPart()
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.1,0.1,1)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.Color = Color3.fromRGB(255,0,0)
    part.Parent = workspaceService
    return part
end

local function guestCleanupVisionCone()
    if guestCenterPart then guestCenterPart:Destroy() guestCenterPart = nil end
    if guestLeftPart then guestLeftPart:Destroy() guestLeftPart = nil end
    if guestRightPart then guestRightPart:Destroy() guestRightPart = nil end
    if guestLeftToKillerPart then guestLeftToKillerPart:Destroy() guestLeftToKillerPart = nil end
    if guestRightToKillerPart then guestRightToKillerPart:Destroy() guestRightToKillerPart = nil end
    if guestLeftToCenterPart then guestLeftToCenterPart:Destroy() guestLeftToCenterPart = nil end
    if guestCenterToRightPart then guestCenterToRightPart:Destroy() guestCenterToRightPart = nil end
end

local function guestUpdateVisionCone()
    if not cfg.get("guestLegacyShowVisionRange", false) then
        if guestCenterPart then guestCleanupVisionCone() end
        return
    end
    local myChar = clientPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then guestCleanupVisionCone() return end
    local originHRP
    if cfg.get("guestReverseEnabled", false) then
        originHRP = myRoot
    else
        local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
        if not killersFolder then guestCleanupVisionCone() return end
        for _, name in ipairs(guestAimTargets) do
            local target = killersFolder:FindFirstChild(name)
            if target and target:FindFirstChild("HumanoidRootPart") then
                originHRP = target.HumanoidRootPart
                break
            end
        end
        if not originHRP then guestCleanupVisionCone() return end
    end

    local visionRange = cfg.get("guestLegacyVisionRange", 13.5)
    local visionAngle = cfg.get("guestLegacyVisionAngle", 85)
    local fwd = originHRP.CFrame.LookVector
    local halfAngleRad = math.rad(visionAngle / 2)
    local right = Vector3.new(-fwd.Z, 0, fwd.X).Unit
    local leftDir = (fwd * math.cos(halfAngleRad) + right * math.sin(halfAngleRad)).Unit
    local rightDir = (fwd * math.cos(halfAngleRad) - right * math.sin(halfAngleRad)).Unit
    local centerPos = originHRP.Position + fwd * visionRange
    local leftPos = originHRP.Position + leftDir * visionRange
    local rightPos = originHRP.Position + rightDir * visionRange
    if not guestCenterPart then guestCenterPart = guestCreateVisionPart() end
    if not guestLeftPart then guestLeftPart = guestCreateVisionPart() end
    if not guestRightPart then guestRightPart = guestCreateVisionPart() end
    guestCenterPart.Position = centerPos
    guestLeftPart.Position = leftPos
    guestRightPart.Position = rightPos
    if not guestLeftToKillerPart then guestLeftToKillerPart = guestCreateConnectionPart() end
    if not guestRightToKillerPart then guestRightToKillerPart = guestCreateConnectionPart() end
    if not guestLeftToCenterPart then guestLeftToCenterPart = guestCreateConnectionPart() end
    if not guestCenterToRightPart then guestCenterToRightPart = guestCreateConnectionPart() end
    local function updateLine(part, p1, p2)
        local mid = (p1 + p2) / 2
        local dist = (p2 - p1).Magnitude
        part.Size = Vector3.new(0.1, 0.1, dist)
        part.CFrame = CFrame.new(mid, p2)
    end
    updateLine(guestLeftToKillerPart, originHRP.Position, leftPos)
    updateLine(guestRightToKillerPart, originHRP.Position, rightPos)
    updateLine(guestLeftToCenterPart, leftPos, centerPos)
    updateLine(guestCenterToRightPart, centerPos, rightPos)
end

runService.RenderStepped:Connect(function(dt)
    if cfg.get("guestAimPunchActive", true) and guestHumanoid and guestHRP and guestPunchAiming then
        local elapsed = tick() - guestPunchLastTriggerTime
        local aimDuration = cfg.get("guestAimPunchDuration", 0.7)
        if elapsed > aimDuration then
            guestPunchAiming = false
            if guestOriginalWS then
                guestHumanoid.WalkSpeed = guestOriginalWS
                guestHumanoid.JumpPower = guestOriginalJP
                guestHumanoid.AutoRotate = guestOriginalAutoRotate
                guestOriginalWS, guestOriginalJP, guestOriginalAutoRotate = nil, nil, nil
            end
            return
        end
        if not guestOriginalWS then
            guestOriginalWS = guestHumanoid.WalkSpeed
            guestOriginalJP = guestHumanoid.JumpPower
            guestOriginalAutoRotate = guestHumanoid.AutoRotate
        end
        guestHumanoid.AutoRotate = false
        guestHRP.AssemblyAngularVelocity = Vector3.zero
        local targetHRP = nil
        local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
        if killersFolder then
            for _, name in ipairs(guestAimTargets) do
                local target = killersFolder:FindFirstChild(name)
                if target and target:FindFirstChild("HumanoidRootPart") then
                    targetHRP = target.HumanoidRootPart
                    break
                end
            end
        end
        if targetHRP then
            local pred = cfg.get("guestPunchPrediction", 1.6)
            local predictPos = targetHRP.Velocity.Magnitude > 0.5 and (targetHRP.Position + targetHRP.Velocity * (pred / 60)) or targetHRP.Position
            local dir = (predictPos - guestHRP.Position).Unit
            local yaw = math.atan2(-dir.X, -dir.Z)
            guestHRP.CFrame = CFrame.new(guestHRP.Position) * CFrame.Angles(0, yaw, 0)
        end
    end

    local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, name in ipairs(guestAimTargets) do
            local target = killersFolder:FindFirstChild(name)
            if target and target:FindFirstChild("HumanoidRootPart") then
                local killerHRP = target.HumanoidRootPart
                if cfg.get("guestShowBlockBox", false) and cfg.get("guestUseBlockBox", false) and killerHRP then
                    if not blockBoxPart then
                        blockBoxPart = Instance.new("Part")
                        blockBoxPart.Anchored = true
                        blockBoxPart.CanCollide = false
                        blockBoxPart.Transparency = 0.4
                        blockBoxPart.Color = Color3.fromRGB(255, 0, 0)
                        blockBoxPart.Material = Enum.Material.ForceField
                        blockBoxPart.Parent = workspaceService
                    end
                    local sizeX = cfg.get("guestBlockBoxSizeX", 5)
                    local sizeY = cfg.get("guestBlockBoxSizeY", 5)
                    local sizeZ = cfg.get("guestBlockBoxSizeZ", 5)
                    local size = Vector3.new(sizeX, sizeY, sizeZ)
                    if cfg.get("guestExpandBoxOnTrigger", false) then size = size * 1.25 end
                    local center = cfg.get("guestReverseEnabled", false) and guestHRP or killerHRP
                    local offset = cfg.get("guestBoxZForwardOnly", false) and (cfg.get("guestReverseEnabled", false) and guestHRP.CFrame.LookVector or killerHRP.CFrame.LookVector) * (size.Z/2) or Vector3.new()
                    blockBoxPart.Size = size
                    blockBoxPart.CFrame = CFrame.new(center.Position + offset) * CFrame.Angles(0, cfg.get("guestBoxZForwardOnly", false) and 0 or (cfg.get("guestReverseEnabled", false) and guestHRP.Orientation.Y or killerHRP.Orientation.Y), 0)
                else
                    if blockBoxPart then blockBoxPart:Destroy() blockBoxPart = nil end
                end
                break
            end
        end
    end

    if cfg.get("guestSphereModeEnabled", false) and cfg.get("guestShowSphere", true) and guestHRP then
        local center
        if cfg.get("guestReverseEnabled", false) then
            center = guestHRP.Position
        else
            local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
            if killersFolder then
                for _, name in ipairs(guestAimTargets) do
                    local target = killersFolder:FindFirstChild(name)
                    if target and target:FindFirstChild("HumanoidRootPart") then
                        center = target.HumanoidRootPart.Position
                        break
                    end
                end
            end
        end
        if center then
            if not spherePart then
                spherePart = Instance.new("Part")
                spherePart.Anchored = true
                spherePart.CanCollide = false
                spherePart.Shape = Enum.PartType.Ball
                spherePart.Transparency = 0.4
                spherePart.Color = Color3.fromRGB(0, 255, 0)
                spherePart.Material = Enum.Material.ForceField
                spherePart.Parent = workspaceService
            end
            local radius = cfg.get("guestSphereSize", 10)
            spherePart.Size = Vector3.new(radius*2, radius*2, radius*2)
            spherePart.CFrame = CFrame.new(center)
        else
            if spherePart then spherePart:Destroy() spherePart = nil end
        end
    else
        if spherePart then spherePart:Destroy() spherePart = nil end
    end

    if cfg.get("guestShowHDTRange", false) and guestHRP then
        if not hdtRangePart then
            hdtRangePart = Instance.new("Part")
            hdtRangePart.Anchored = true
            hdtRangePart.CanCollide = false
            hdtRangePart.Shape = Enum.PartType.Ball
            hdtRangePart.Transparency = 0.5
            hdtRangePart.Color = Color3.fromRGB(255, 255, 0)
            hdtRangePart.Material = Enum.Material.ForceField
            hdtRangePart.Parent = workspaceService
        end
        local radius = cfg.get("guestHitboxTriggerRadius", 15)
        hdtRangePart.Size = Vector3.new(radius*2, radius*2, radius*2)
        hdtRangePart.CFrame = CFrame.new(guestHRP.Position)
    else
        if hdtRangePart then hdtRangePart:Destroy() hdtRangePart = nil end
    end

    pcall(guestUpdateVisionCone)

    if cfg.get("pingCheckerEnabled", false) then
        if not pingLabel then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "PingChecker"
            screenGui.Parent = PlayerGui
            screenGui.IgnoreGuiInset = true
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.DisplayOrder = 9998
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 150, 0, 40)
            frame.Position = UDim2.new(0, 10, 1, -50)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 0
            frame.Parent = screenGui
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -10, 1, -10)
            textLabel.Position = UDim2.new(0, 5, 0, 5)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Text = "Ping: 0ms"
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 18
            textLabel.Parent = frame
            pingLabel = textLabel
        end
        local ping = statsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        pingLabel.Text = "Ping: " .. math.floor(ping) .. "ms"
    else
        if pingLabel then pingLabel.Parent.Parent:Destroy() pingLabel = nil end
    end

    if cfg.get("hdtCooldownChecker", false) then
        if not hdtCooldownGui then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "HDTCooldownChecker"
            screenGui.Parent = PlayerGui
            screenGui.IgnoreGuiInset = true
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.DisplayOrder = 9998
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 150, 0, 40)
            frame.Position = UDim2.new(0, 10, 0, 100)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 0
            frame.Parent = screenGui
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -10, 1, -10)
            textLabel.Position = UDim2.new(0, 5, 0, 5)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Text = "Block CD: ?"
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 18
            textLabel.Parent = frame
            hdtCooldownGui = screenGui
            hdtCooldownLabel = textLabel
        end
        local mainUI = PlayerGui:FindFirstChild("MainUI")
        if mainUI then
            local abilityContainer = mainUI:FindFirstChild("AbilityContainer")
            if abilityContainer then
                local block = abilityContainer:FindFirstChild("Block")
                if block then
                    local cooldownTime = block:FindFirstChild("CooldownTime")
                    if cooldownTime and cooldownTime:IsA("TextLabel") then
                        local val = cooldownTime.Text
                        hdtCooldownLabel.Text = "Block CD: " .. val
                    else
                        hdtCooldownLabel.Text = "Block CD: ?"
                    end
                else
                    hdtCooldownLabel.Text = "Block CD: ?"
                end
            else
                hdtCooldownLabel.Text = "Block CD: ?"
            end
        else
            hdtCooldownLabel.Text = "Block CD: ?"
        end
    else
        if hdtCooldownGui then
            hdtCooldownGui:Destroy()
            hdtCooldownGui = nil
        end
    end
end)
-- Part 7/10
local fpsGui = nil
local fpsLabel = nil
local lastFpsUpdate = 0
local frameCount = 0
local fps = 0

runService.RenderStepped:Connect(function(dt)
    if cfg.get("fpsCounterEnabled", false) then
        if not fpsGui then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "FpsCounter"
            screenGui.Parent = PlayerGui
            screenGui.IgnoreGuiInset = true
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.DisplayOrder = 9999
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 100, 0, 30)
            frame.Position = UDim2.new(0, 10, 0, 150)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 0
            frame.Parent = screenGui
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -10, 1, -10)
            textLabel.Position = UDim2.new(0, 5, 0, 5)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Text = "FPS: 0"
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 16
            textLabel.Parent = frame
            fpsGui = screenGui
            fpsLabel = textLabel
            lastFpsUpdate = tick()
            frameCount = 0
            fps = 0
        end
        frameCount = frameCount + 1
        local now = tick()
        if now - lastFpsUpdate >= 1 then
            fps = frameCount
            frameCount = 0
            lastFpsUpdate = now
            fpsLabel.Text = "FPS: " .. fps
        end
    else
        if fpsGui then fpsGui:Destroy() fpsGui = nil fpsLabel = nil end
    end
end)

runService.RenderStepped:Connect(function(dt)
    local killersFolder = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
    if not killersFolder then return end
    for _, killer in ipairs(killersFolder:GetChildren()) do
        local hrp = killer:FindFirstChild("HumanoidRootPart")
        if hrp then
            local state = guestKillerState[killer] or {prevPos = hrp.Position, prevLook = hrp.CFrame.LookVector, vel = Vector3.new(), angVel = 0}
            local newVel = (hrp.Position - state.prevPos) / math.max(dt, 1e-6)
            state.vel = state.vel:Lerp(newVel, SMOOTHING_LERP)
            local look = hrp.CFrame.LookVector
            local dot = math.clamp(state.prevLook:Dot(look), -1, 1)
            local angle = math.acos(dot)
            local crossY = state.prevLook:Cross(look).Y
            local angSign = crossY >= 0 and 1 or -1
            local newAngVel = (angle / math.max(dt, 1e-6)) * angSign
            state.angVel = state.angVel * (1 - SMOOTHING_LERP) + newAngVel * SMOOTHING_LERP
            state.prevPos = hrp.Position
            state.prevLook = look
            guestKillerState[killer] = state
        end
    end
end)

local noclipConn = nil
local function enableNoclip()
    if not clientPlayer.Character then return end
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = runService.Stepped:Connect(function(_, _)
        if not cfg.get("noclipEnabled", false) then
            noclipConn:Disconnect()
            noclipConn = nil
            return
        end
        if cfg.get("noclipOnlyWhenBlockReady", false) and not isBlockReady() then
            return
        end
        if not clientPlayer.Character then return end
        for _, part in ipairs(clientPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end
local function disableNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    local char = clientPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end
clientPlayer.CharacterAdded:Connect(function()
    if cfg.get("noclipEnabled", false) then enableNoclip() end
end)

local networkHooked = false
local originalFireConnection = nil
local pinnedConns = {}
local chargePinnedConns = {}
local chargeCapConn = nil
local chargeWatcher = nil
local descendantConn = nil
local isCharging = false
local lungeActive = false
local lungeThread = nil

local function hookNetwork()
    if networkHooked then return end
    pcall(function()
        local Network = require(replicatedStorage.Modules.Network)
        originalFireConnection = Network.FireConnection
        Network.FireConnection = function(self, name, ...)
            if cfg.get("punchMobilityEnabled", false) and name == "DisableSprinting" then return end
            return originalFireConnection(self, name, ...)
        end
        networkHooked = true
    end)
end

local function unhookNetwork()
    if not networkHooked then return end
    pcall(function()
        local Network = require(replicatedStorage.Modules.Network)
        if originalFireConnection then
            Network.FireConnection = originalFireConnection
        end
    end)
    networkHooked = false
    originalFireConnection = nil
end

local function pinValue(v)
    if not v or not v:IsA("NumberValue") then return end
    if v.Value > 1.01 then return end
    pcall(function()
        v.Value = 1
        tweenService:Create(v, TweenInfo.new(0), {Value = 1}):Play()
    end)
    local conn
    conn = v:GetPropertyChangedSignal("Value"):Connect(function()
        if not cfg.get("punchMobilityEnabled", false) then
            pcall(function() conn:Disconnect() end)
            return
        end
        if v.Value < 1 then
            pcall(function() v.Value = 1 end)
        end
    end)
    table.insert(pinnedConns, conn)
end

local function stopPunchOverride()
    pcall(function() runService:UnbindFromRenderStep("PunchMobility") end)
    pcall(function() runService:UnbindFromRenderStep("LungeBoost") end)
    lungeActive = false
    for _, conn in pairs(pinnedConns) do
        pcall(function() conn:Disconnect() end)
    end
    pinnedConns = {}
    if descendantConn then
        descendantConn:Disconnect()
        descendantConn = nil
    end
    if lungeThread then
        task.cancel(lungeThread)
        lungeThread = nil
    end
end

local function applyLunge()
    if not cfg.get("lungeBoostEnabled", false) then return end
    if lungeActive then return end
    local rootPart = getRootPart()
    if not rootPart then return end
    local lv = rootPart.CFrame.LookVector
    local dir = Vector3.new(lv.X, 0, lv.Z)
    if dir.Magnitude == 0 then return end
    dir = dir.Unit
    lungeActive = true
    local speed = BASE_PUNCH_FORCE * cfg.get("lungeMultiplier", 1.0)
    local DURATION = 0.3
    local elapsed = 0
    pcall(function() runService:UnbindFromRenderStep("LungeBoost") end)
    runService:BindToRenderStep("LungeBoost", Enum.RenderPriority.Character.Value + 20, function(dt)
        elapsed = elapsed + dt
        local rp = getRootPart()
        if not rp or elapsed >= DURATION then
            pcall(function() runService:UnbindFromRenderStep("LungeBoost") end)
            lungeActive = false
            return
        end
        local t = 1 - (elapsed / DURATION)
        local currentY = rp.AssemblyLinearVelocity.Y
        rp.AssemblyLinearVelocity = dir * (speed * t) + Vector3.new(0, currentY, 0)
    end)
end
-- Part 8/10
local function startPunchOverride()
    stopPunchOverride()
    local char = clientPlayer.Character
    if not char then return end
    for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("NumberValue") then pinValue(desc) end
    end
    descendantConn = char.DescendantAdded:Connect(function(desc)
        if not cfg.get("punchMobilityEnabled", false) then return end
        if desc:IsA("NumberValue") then
            task.defer(function()
                if desc.Name == "PunchAbility" then
                    local parry = isParryMode()
                    if cfg.get("lungeBoostEnabled", false) then
                        if lungeThread then task.cancel(lungeThread) end
                        local delay = parry and PARRY_WINDUP or PUNCH_WINDUP
                        lungeThread = task.delay(delay, function()
                            lungeThread = nil
                            applyLunge()
                        end)
                    end
                end
                pinValue(desc)
            end)
        end
    end)
    runService:BindToRenderStep("PunchMobility", Enum.RenderPriority.Character.Value + 10, function()
        if lungeActive then return end
        local hum = getHumanoid()
        if not hum then return end
        if hum.WalkSpeed < BASE_SPEED then hum.WalkSpeed = BASE_SPEED end
    end)
end

local function pinChargeValue(v)
    if not v or not v:IsA("NumberValue") then return end
    if v.Value <= 1.01 then return end
    pcall(function()
        v.Value = 1
        tweenService:Create(v, TweenInfo.new(0), {Value = 1}):Play()
    end)
    local conn
    conn = v:GetPropertyChangedSignal("Value"):Connect(function()
        if not isCharging or not cfg.get("chargeSpeedCapEnabled", false) then
            pcall(function() conn:Disconnect() end)
            return
        end
        if v.Value > 1 then
            pcall(function() v.Value = 1 end)
        end
    end)
    table.insert(chargePinnedConns, conn)
end

local function startChargeCap()
    if chargeCapConn then chargeCapConn:Disconnect() end
    for _, c in pairs(chargePinnedConns) do pcall(function() c:Disconnect() end) end
    chargePinnedConns = {}
    local char = clientPlayer.Character
    if not char then return end
    for _, desc in ipairs(char:GetDescendants()) do
        pinChargeValue(desc)
    end
    chargeCapConn = char.DescendantAdded:Connect(function(desc)
        if not isCharging or not cfg.get("chargeSpeedCapEnabled", false) then return end
        if desc:IsA("NumberValue") then
            task.defer(function() pinChargeValue(desc) end)
        end
    end)
    pcall(function() runService:UnbindFromRenderStep("ChargeCap") end)
    runService:BindToRenderStep("ChargeCap", Enum.RenderPriority.Character.Value + 20, function()
        if not isCharging or not cfg.get("chargeSpeedCapEnabled", false) then
            pcall(function() runService:UnbindFromRenderStep("ChargeCap") end)
            return
        end
        local hum = getHumanoid()
        if hum and hum.WalkSpeed > BASE_SPEED then
            hum.WalkSpeed = BASE_SPEED
        end
    end)
end

local function stopChargeCap()
    pcall(function() runService:UnbindFromRenderStep("ChargeCap") end)
    if chargeCapConn then chargeCapConn:Disconnect() end
    for _, c in pairs(chargePinnedConns) do pcall(function() c:Disconnect() end) end
    chargePinnedConns = {}
end

local function startLock()
    pcall(function() runService:UnbindFromRenderStep("ChargeLock") end)
    pcall(function() runService:UnbindFromRenderStep("ChargeSpeedLimit") end)
    isCharging = true
    runService:BindToRenderStep("ChargeLock", Enum.RenderPriority.Character.Value + 2, function()
        local hum = getHumanoid()
        if not hum then return end
        local cam = workspaceService.CurrentCamera.CFrame.LookVector
        local dir = Vector3.new(cam.X, 0, cam.Z)
        if dir.Magnitude > 0 then hum:Move(dir.Unit) end
    end)
    runService:BindToRenderStep("ChargeSpeedLimit", Enum.RenderPriority.Character.Value + 20, function()
        if not isCharging then
            pcall(function() runService:UnbindFromRenderStep("ChargeSpeedLimit") end)
            return
        end
        local hum = getHumanoid()
        if hum and hum.WalkSpeed ~= cfg.get("chargeSpeedLimit", 12) then
            hum.WalkSpeed = cfg.get("chargeSpeedLimit", 12)
        end
    end)
    if cfg.get("chargeSpeedCapEnabled", false) then startChargeCap() end
end

local function stopLock()
    isCharging = false
    pcall(function() runService:UnbindFromRenderStep("ChargeLock") end)
    pcall(function() runService:UnbindFromRenderStep("ChargeSpeedLimit") end)
    stopChargeCap()
end

local function setupChargeWatcher(character)
    if chargeWatcher then chargeWatcher:Disconnect() end
    stopLock()
    stopPunchOverride()
    chargeWatcher = character:GetAttributeChangedSignal("GuestCharging"):Connect(function()
        if not cfg.get("chargeControlEnabled", false) then return end
        if character:GetAttribute("GuestCharging") then
            startLock()
        else
            stopLock()
        end
    end)
end

if clientPlayer.Character then setupChargeWatcher(clientPlayer.Character) end
clientPlayer.CharacterAdded:Connect(function(character)
    task.wait()
    setupChargeWatcher(character)
end)

if cfg.get("punchMobilityEnabled", false) then
    hookNetwork()
    startPunchOverride()
end
-- Part 9/10
local SentinelSection = SentinelTab:Section({Title="Guest1337", Icon="user", Opened=true})

SentinelSection:Toggle({Title="Auto Block", Default=cfg.get("guestAutoBlockAudioOn", true), Callback=function(v) cfg.set("guestAutoBlockAudioOn",v) end})
SentinelSection:Slider({Title="Block Delay", Step=0.05, Value={Min=0,Max=2,Default=cfg.get("guestBlockDelay",0)}, Callback=function(v) cfg.set("guestBlockDelay",v) end})
SentinelSection:Slider({Title="Auto Block Radius", Step=1, Value={Min=1,Max=50,Default=cfg.get("guestDetectionRange",20)}, Callback=function(v) cfg.set("guestDetectionRange",v) end})
SentinelSection:Divider()

SentinelSection:Toggle({Title="Hitbox Dragging (HDT)", Default=cfg.get("guestHitboxDraggingOn",false), Callback=function(v) cfg.set("guestHitboxDraggingOn",v) end})
SentinelSection:Dropdown({Title="HDT Mode", Values={"Blatant","Legit","Hitbox"}, Default=cfg.get("guestHitboxMode","Blatant"), Callback=function(v) cfg.set("guestHitboxMode",v) end})
SentinelSection:Slider({Title="HDT Blatant Speed", Step=5, Value={Min=50,Max=500,Default=cfg.get("hdtBlatantSpeed",150)}, Callback=function(v) cfg.set("hdtBlatantSpeed",v) end})
SentinelSection:Slider({Title="HDT Legit Speed", Step=5, Value={Min=50,Max=500,Default=cfg.get("hdtLegitSpeed",140)}, Callback=function(v) cfg.set("hdtLegitSpeed",v) end})
SentinelSection:Toggle({Title="Face Killer During HDT", Default=cfg.get("guestHitboxFaceKiller",false), Callback=function(v) cfg.set("guestHitboxFaceKiller",v) end})
SentinelSection:Toggle({Title="HDT Visual (Beam)", Default=cfg.get("guestHitboxVisual",false), Callback=function(v) cfg.set("guestHitboxVisual",v) end})
SentinelSection:Slider({Title="Drag Duration", Step=0.05, Value={Min=0.05,Max=2,Default=cfg.get("guestHitboxDragDuration",1.0)}, Callback=function(v) cfg.set("guestHitboxDragDuration",v) end})
SentinelSection:Slider({Title="HDT Trigger Radius", Step=1, Value={Min=0,Max=30,Default=cfg.get("guestHitboxTriggerRadius",15)}, Callback=function(v) cfg.set("guestHitboxTriggerRadius",v) end})
SentinelSection:Toggle({Title="Show HDT Range", Default=cfg.get("guestShowHDTRange",false), Callback=function(v) cfg.set("guestShowHDTRange",v) end})
SentinelSection:Toggle({Title="No HDT Cooldown", Default=cfg.get("noHDTCooldown",false), Callback=function(v) cfg.set("noHDTCooldown",v) end})
SentinelSection:Toggle({Title="HDT Cooldown Checker", Default=cfg.get("hdtCooldownChecker",false), Callback=function(v) cfg.set("hdtCooldownChecker",v) end})
SentinelSection:Dropdown({Title="HDT Target", Values={"Root","Arms","Random"}, Default=cfg.get("guestHitboxTargetMode","Root"), Callback=function(v) cfg.set("guestHitboxTargetMode",v) end})
SentinelSection:Divider()

SentinelSection:Toggle({Title="Use Block Box", Default=cfg.get("guestUseBlockBox",false), Callback=function(v) if v and cfg.get("guestSphereModeEnabled",false) then WindUI:Notify({Title="Mode Conflict", Content="Sphere Mode disabled.", Duration=3}) cfg.set("guestSphereModeEnabled",false) end cfg.set("guestUseBlockBox",v) end})
SentinelSection:Slider({Title="Box Size X", Step=0.5, Value={Min=1,Max=50,Default=cfg.get("guestBlockBoxSizeX",5)}, Callback=function(v) cfg.set("guestBlockBoxSizeX",v) end})
SentinelSection:Slider({Title="Box Size Y", Step=0.5, Value={Min=1,Max=10,Default=cfg.get("guestBlockBoxSizeY",5)}, Callback=function(v) cfg.set("guestBlockBoxSizeY",v) end})
SentinelSection:Slider({Title="Box Size Z", Step=0.5, Value={Min=1,Max=50,Default=cfg.get("guestBlockBoxSizeZ",5)}, Callback=function(v) cfg.set("guestBlockBoxSizeZ",v) end})
SentinelSection:Toggle({Title="Z Forward Only", Default=cfg.get("guestBoxZForwardOnly",false), Callback=function(v) cfg.set("guestBoxZForwardOnly",v) end})
SentinelSection:Toggle({Title="Show Block Box", Default=cfg.get("guestShowBlockBox",false), Callback=function(v) cfg.set("guestShowBlockBox",v) end})
SentinelSection:Toggle({Title="Expand Box on Trigger", Default=cfg.get("guestExpandBoxOnTrigger",false), Callback=function(v) cfg.set("guestExpandBoxOnTrigger",v) end})
SentinelSection:Divider()

SentinelSection:Toggle({Title="Verify Facing Check", Default=cfg.get("guestVerifyFacingCheckOn",true), Callback=function(v) cfg.set("guestVerifyFacingCheckOn",v) end})
SentinelSection:Slider({Title="Set Vision Range", Step=1, Value={Min=1,Max=20,Default=cfg.get("guestVisionRange",13.5)}, Callback=function(v) cfg.set("guestVisionRange",v) end})
SentinelSection:Slider({Title="Set Vision Angle", Step=1, Value={Min=1,Max=200,Default=cfg.get("guestVisionAngle",85)}, Callback=function(v) cfg.set("guestVisionAngle",v) end})
SentinelSection:Toggle({Title="Show Vision Range", Default=cfg.get("guestShowVisionRange",true), Callback=function(v) cfg.set("guestShowVisionRange",v) end})
SentinelSection:Divider()

SentinelSection:Toggle({Title="Auto Punch", Default=cfg.get("guestAutoPunchOn",true), Callback=function(v) cfg.set("guestAutoPunchOn",v) end})
SentinelSection:Toggle({Title="Aim Punch", Default=cfg.get("guestAimPunchActive",true), Callback=function(v) cfg.set("guestAimPunchActive",v) if v and clientPlayer.Character then guestSetupCharacter(clientPlayer.Character) end end})
SentinelSection:Slider({Title="Punch Prediction", Step=1, Value={Min=0,Max=10,Default=cfg.get("guestPunchPrediction",1.6)}, Callback=function(v) cfg.set("guestPunchPrediction",v) end})
SentinelSection:Toggle({Title="Cinematic Text", Default=cfg.get("guestCinematicTextEnabled",false), Callback=function(v) cfg.set("guestCinematicTextEnabled",v) end})
SentinelSection:Input({Title="Cinematic Text", Value=cfg.get("guestCinematicText","PARRY!"), Callback=function(v) cfg.set("guestCinematicText",v) end})
SentinelSection:Toggle({Title="Smart Delay", Default=cfg.get("guestSmartDelayEnabled",false), Callback=function(v) cfg.set("guestSmartDelayEnabled",v) end})
SentinelSection:Toggle({Title="Manual Drag", Default=cfg.get("guestManualDragEnabled",false), Callback=function(v) cfg.set("guestManualDragEnabled",v) end})
SentinelSection:Toggle({Title="Noclip Only When Block Ready", Default=cfg.get("noclipOnlyWhenBlockReady",false), Callback=function(v) cfg.set("noclipOnlyWhenBlockReady",v) if cfg.get("noclipEnabled",false) then disableNoclip() enableNoclip() end end})

local BetterSection = BetterDetectionTab:Section({Title="Better Detection", Opened=true})
BetterSection:Toggle({Title="Enable Better Detection", Default=cfg.get("guestBetterDetectionEnabled",false), Callback=function(v) cfg.set("guestBetterDetectionEnabled",v) end})
BetterSection:Dropdown({Title="Hitbox Preset", Values={"Standard","Short","Forward-offset","Manual"}, Default=cfg.get("guestBetterDetectionPreset","Standard"), Callback=function(v) cfg.set("guestBetterDetectionPreset",v) end})
BetterSection:Input({Title="Manual Size X", Value=tostring(cfg.get("guestBetterDetectionManualX",4.5)), Callback=function(v) local n=tonumber(v); if n then cfg.set("guestBetterDetectionManualX",n) end end})
BetterSection:Input({Title="Manual Size Y", Value=tostring(cfg.get("guestBetterDetectionManualY",6)), Callback=function(v) local n=tonumber(v); if n then cfg.set("guestBetterDetectionManualY",n) end end})
BetterSection:Input({Title="Manual Size Z", Value=tostring(cfg.get("guestBetterDetectionManualZ",7.5)), Callback=function(v) local n=tonumber(v); if n then cfg.set("guestBetterDetectionManualZ",n) end end})
BetterSection:Slider({Title="Forward Offset", Step=0.1, Value={Min=-5,Max=5,Default=cfg.get("guestBetterDetectionOffset",0)}, Callback=function(v) cfg.set("guestBetterDetectionOffset",v) end})
BetterSection:Slider({Title="Spawn Delay", Step=0.01, Value={Min=0,Max=0.5,Default=cfg.get("guestBetterDetectionDelay",0)}, Callback=function(v) cfg.set("guestBetterDetectionDelay",v) end})
BetterSection:Slider({Title="Lifetime", Step=0.05, Value={Min=0.1,Max=1,Default=cfg.get("guestBetterDetectionLifetime",0.25)}, Callback=function(v) cfg.set("guestBetterDetectionLifetime",v) end})
BetterSection:Slider({Title="Segments", Step=1, Value={Min=1,Max=20,Default=cfg.get("guestBetterDetectionSegments",6)}, Callback=function(v) cfg.set("guestBetterDetectionSegments",v) end})
BetterSection:Slider({Title="Start Distance", Step=0.1, Value={Min=0.5,Max=10,Default=cfg.get("guestBetterDetectionStartDist",2.7)}, Callback=function(v) cfg.set("guestBetterDetectionStartDist",v) end})
BetterSection:Slider({Title="Step Distance", Step=0.1, Value={Min=0.1,Max=5,Default=cfg.get("guestBetterDetectionStepDist",0.2)}, Callback=function(v) cfg.set("guestBetterDetectionStepDist",v) end})
BetterSection:Slider({Title="Stagger (per segment)", Step=0.005, Value={Min=0,Max=0.2,Default=cfg.get("guestBetterDetectionStagger",0.02)}, Callback=function(v) cfg.set("guestBetterDetectionStagger",v) end})

local SphereSection = SphereTab:Section({Title="Sphere Block", Opened=true})
SphereSection:Toggle({Title="Enable Sphere Mode", Default=cfg.get("guestSphereModeEnabled",false), Callback=function(v) if v and cfg.get("guestUseBlockBox",false) then WindUI:Notify({Title="Mode Conflict", Content="Block Box disabled.", Duration=3}) cfg.set("guestUseBlockBox",false) end cfg.set("guestSphereModeEnabled",v) end})
SphereSection:Slider({Title="Sphere Size", Step=1, Value={Min=1,Max=20,Default=cfg.get("guestSphereSize",10)}, Callback=function(v) cfg.set("guestSphereSize",v) end})
SphereSection:Toggle({Title="Show Sphere", Default=cfg.get("guestShowSphere",true), Callback=function(v) cfg.set("guestShowSphere",v) end})

local ReverseSection = ReverseTab:Section({Title="Reverse Block", Opened=true})
ReverseSection:Toggle({Title="Enable Reverse", Default=cfg.get("guestReverseEnabled",false), Callback=function(v) cfg.set("guestReverseEnabled",v) if v and cfg.get("guestLegacyFacingEnabled",false) then WindUI:Notify({Title="Warning", Content="Reverse with legacy may be risky.", Duration=5}) end end})
ReverseSection:Paragraph({Title="Info", Desc="When enabled, block zone centers on you."})

local LegacySection = LegacyTab:Section({Title="Facing Check (Killer's View)", Opened=true})
LegacySection:Toggle({Title="Enable Legacy Facing", Default=cfg.get("guestLegacyFacingEnabled",false), Callback=function(v) cfg.set("guestLegacyFacingEnabled",v) if v and cfg.get("guestReverseEnabled",false) then WindUI:Notify({Title="Warning", Content="Reverse with legacy may be risky.", Duration=5}) end end})
LegacySection:Slider({Title="Vision Range", Step=1, Value={Min=1,Max=20,Default=cfg.get("guestLegacyVisionRange",13.5)}, Callback=function(v) cfg.set("guestLegacyVisionRange",v) end})
LegacySection:Slider({Title="Vision Angle", Step=1, Value={Min=1,Max=200,Default=cfg.get("guestLegacyVisionAngle",85)}, Callback=function(v) cfg.set("guestLegacyVisionAngle",v) end})
LegacySection:Toggle({Title="Show Vision Range", Default=cfg.get("guestLegacyShowVisionRange",false), Callback=function(v) cfg.set("guestLegacyShowVisionRange",v) end})
-- Part 10/10
local PunchSection = PunchTab:Section({Title="Punch Controller", Opened=true})
PunchSection:Toggle({Title="Charge Control", Default=cfg.get("chargeControlEnabled",false), Callback=function(v) cfg.set("chargeControlEnabled",v) if not v then stopLock() end end})
PunchSection:Slider({Title="Charge Speed Limit", Step=1, Value={Min=1,Max=50,Default=cfg.get("chargeSpeedLimit",12)}, Callback=function(v) cfg.set("chargeSpeedLimit",v) end})
PunchSection:Toggle({Title="Punch Mobility", Default=cfg.get("punchMobilityEnabled",false), Callback=function(v) cfg.set("punchMobilityEnabled",v) if v then hookNetwork() startPunchOverride() else unhookNetwork() stopPunchOverride() end end})
PunchSection:Toggle({Title="Lunge Boost", Default=cfg.get("lungeBoostEnabled",false), Callback=function(v) cfg.set("lungeBoostEnabled",v) if not v then if lungeThread then task.cancel(lungeThread); lungeThread=nil end pcall(function() runService:UnbindFromRenderStep("LungeBoost") end) lungeActive=false end end})
PunchSection:Slider({Title="Lunge Multiplier", Step=0.1, Value={Min=0.5,Max=5.0,Default=cfg.get("lungeMultiplier",1.0)}, Callback=function(v) cfg.set("lungeMultiplier",v) end})
PunchSection:Toggle({Title="Charge Speed Cap", Default=cfg.get("chargeSpeedCapEnabled",false), Callback=function(v) cfg.set("chargeSpeedCapEnabled",v) if isCharging and v then startChargeCap() elseif not v then stopChargeCap() end end})

local MiscSection = MiscTab:Section({Title="Misc", Opened=true})
MiscSection:Toggle({Title="Noclip", Default=cfg.get("noclipEnabled",false), Callback=function(v) cfg.set("noclipEnabled",v) if v then enableNoclip() else disableNoclip() end end})
MiscSection:Toggle({Title="FPS Counter", Default=cfg.get("fpsCounterEnabled",false), Callback=function(v) cfg.set("fpsCounterEnabled",v) if v then createFpsCounter() else destroyFpsCounter() end end})
MiscSection:Input({Title="Custom Punch Sound ID", Value=tostring(cfg.get("customPunchSoundId",0)), Callback=function(v) local n=tonumber(v); if n then cfg.set("customPunchSoundId",n) else cfg.set("customPunchSoundId",0) end end})

local UISection = InterfaceTab:Section({Title="UI Functions", Opened=true})
UISection:Button({Title="Close UI", Callback=function() Window:Destroy() end})

local function hookPunchSound()
    local oldFire = guestFireRemotePunch
    guestFireRemotePunch = function()
        playCustomPunchSound()
        oldFire()
    end
end
hookPunchSound()

print("V1rpblock 2.0 loaded – the golden dandelion.")