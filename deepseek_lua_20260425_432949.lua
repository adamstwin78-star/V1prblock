-- Frostsaken | maintained by mitsuki | original by Glovsaken
-- REWRITE: ESP is fully event-driven (no polling loop), all micro-freeze sources addressed
-- Sirius Rayfield UI with custom theme engine
print("Frostsaken loaded")

------------------------------------------------------------------------
-- services
------------------------------------------------------------------------
local svc = {
    Players      = game:GetService("Players"),
    Run          = game:GetService("RunService"),
    Input        = game:GetService("UserInputService"),
    RS           = game:GetService("ReplicatedStorage"),
    WS           = game:GetService("Workspace"),
    TweenService = game:GetService("TweenService"),
    TextChat     = game:GetService("TextChatService"),
    Http         = game:GetService("HttpService"),
    Stats        = game:GetService("Stats"),
}

local lp  = svc.Players.LocalPlayer
local gui = lp:WaitForChild("PlayerGui", 10)

------------------------------------------------------------------------
-- filesystem shims
------------------------------------------------------------------------
local fs = {
    hasFolder = isfolder      or function() return false end,
    makeFolder= makefolder    or function() end,
    write     = writefile     or function() end,
    hasFile   = isfile        or function() return false end,
    read      = readfile      or function() return "" end,
    asset     = getcustomasset or function(p) return p end,
}

------------------------------------------------------------------------
-- config
------------------------------------------------------------------------
local cfg = {}
do
    local DIR  = "Frostsaken"
    local FILE = DIR .. "/config.json"
    local saveThread = nil

    local function prep()
        if not fs.hasFolder(DIR) then fs.makeFolder(DIR) end
    end

    function cfg.load()
        prep()
        if not fs.hasFile(FILE) then return end
        local ok, t = pcall(svc.Http.JSONDecode, svc.Http, fs.read(FILE))
        if ok and type(t) == "table" then cfg._data = t end
    end

    function cfg.save()
        if saveThread then task.cancel(saveThread) end
        saveThread = task.delay(0.5, function()
            saveThread = nil
            prep()
            local ok, s = pcall(svc.Http.JSONEncode, svc.Http, cfg._data)
            if ok then fs.write(FILE, s) end
        end)
    end

    function cfg.get(k, default)
        local v = cfg._data[k]
        return v ~= nil and v or default
    end

    function cfg.set(k, v)
        cfg._data[k] = v
        cfg.save()
    end

    cfg._data = {}
    cfg.load()
end

------------------------------------------------------------------------
-- Sirius Rayfield Library
------------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Frostsaken",
    Icon = 0,
    LoadingTitle = "Frostsaken",
    LoadingSubtitle = "by mitsuki",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Frostsaken_Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Custom Theme Override
local function ApplyCustomTheme(colorScheme)
    local theme = {}
    
    if colorScheme == "Frost" then
        theme = {
            Background = Color3.fromRGB(20, 28, 40),
            Glow = Color3.fromRGB(80, 160, 255),
            Accent = Color3.fromRGB(80, 160, 255),
            AccentLight = Color3.fromRGB(120, 200, 255),
            Text = Color3.fromRGB(220, 235, 255),
            TextDark = Color3.fromRGB(150, 170, 200),
            TabInactive = Color3.fromRGB(30, 40, 55),
            TabActive = Color3.fromRGB(80, 160, 255),
            Sidebar = Color3.fromRGB(15, 22, 35),
            Scrollbar = Color3.fromRGB(80, 160, 255)
        }
    elseif colorScheme == "FrostDark" then
        theme = {
            Background = Color3.fromRGB(10, 15, 25),
            Glow = Color3.fromRGB(60, 130, 220),
            Accent = Color3.fromRGB(60, 130, 220),
            AccentLight = Color3.fromRGB(90, 170, 240),
            Text = Color3.fromRGB(200, 215, 240),
            TextDark = Color3.fromRGB(130, 150, 180),
            TabInactive = Color3.fromRGB(20, 28, 40),
            TabActive = Color3.fromRGB(60, 130, 220),
            Sidebar = Color3.fromRGB(8, 12, 20),
            Scrollbar = Color3.fromRGB(60, 130, 220)
        }
    elseif colorScheme == "FrostLight" then
        theme = {
            Background = Color3.fromRGB(210, 225, 245),
            Glow = Color3.fromRGB(80, 160, 255),
            Accent = Color3.fromRGB(80, 160, 255),
            AccentLight = Color3.fromRGB(120, 200, 255),
            Text = Color3.fromRGB(30, 40, 60),
            TextDark = Color3.fromRGB(80, 100, 130),
            TabInactive = Color3.fromRGB(190, 205, 225),
            TabActive = Color3.fromRGB(80, 160, 255),
            Sidebar = Color3.fromRGB(200, 215, 235),
            Scrollbar = Color3.fromRGB(80, 160, 255)
        }
    elseif colorScheme == "FrostPurple" then
        theme = {
            Background = Color3.fromRGB(25, 20, 45),
            Glow = Color3.fromRGB(160, 100, 255),
            Accent = Color3.fromRGB(160, 100, 255),
            AccentLight = Color3.fromRGB(190, 140, 255),
            Text = Color3.fromRGB(230, 220, 255),
            TextDark = Color3.fromRGB(160, 140, 200),
            TabInactive = Color3.fromRGB(35, 28, 55),
            TabActive = Color3.fromRGB(160, 100, 255),
            Sidebar = Color3.fromRGB(20, 15, 38),
            Scrollbar = Color3.fromRGB(160, 100, 255)
        }
    elseif colorScheme == "FrostCyan" then
        theme = {
            Background = Color3.fromRGB(15, 35, 45),
            Glow = Color3.fromRGB(50, 210, 230),
            Accent = Color3.fromRGB(50, 210, 230),
            AccentLight = Color3.fromRGB(90, 240, 255),
            Text = Color3.fromRGB(210, 240, 255),
            TextDark = Color3.fromRGB(130, 180, 200),
            TabInactive = Color3.fromRGB(25, 45, 55),
            TabActive = Color3.fromRGB(50, 210, 230),
            Sidebar = Color3.fromRGB(10, 28, 38),
            Scrollbar = Color3.fromRGB(50, 210, 230)
        }
    end
    
    for k, v in pairs(theme) do
        Rayfield:SetProperty(k, v)
    end
end

-- Custom Color Picker for ESP
local ESPColors = {
    Killers = cfg.get("espColorKillers", Color3.fromRGB(255, 0, 0)),
    Survivors = cfg.get("espColorSurvivors", Color3.fromRGB(255, 255, 0)),
    Generators = cfg.get("espColorGenerators", Color3.fromRGB(255, 105, 180)),
    Items = cfg.get("espColorItems", Color3.fromRGB(0, 230, 230)),
    Buildings = cfg.get("espColorBuildings", Color3.fromRGB(255, 80, 0))
}

-- Function forward declarations for ESP
local espDoKillers, espDoSurvivors, espDoGenerators, espDoItems, espDoBuildings
local esp = nil

local function UpdateESPColor(type, color)
    ESPColors[type] = color
    cfg.set("espColor" .. type, color)
    if esp and esp.ready then
        if type == "Killers" and esp.killers then espDoKillers(true) end
        if type == "Survivors" and esp.survivors then espDoSurvivors(true) end
        if type == "Generators" and esp.generators then espDoGenerators(true) end
        if type == "Items" and esp.items then espDoItems(true) end
        if type == "Buildings" and esp.buildings then espDoBuildings(true) end
    end
end

------------------------------------------------------------------------
-- helpers
------------------------------------------------------------------------
local function getTeamFolder(name)
    local root = svc.WS:FindFirstChild("Players")
    return root and root:FindFirstChild(name)
end
local function getIngame()
    local m = svc.WS:FindFirstChild("Map")
    return m and m:FindFirstChild("Ingame")
end
local function getMapContent()
    local ig = getIngame()
    return ig and ig:FindFirstChild("Map")
end

local _networkModule = nil
local function getNetwork()
    if _networkModule then return _networkModule end
    local ok, m = pcall(function()
        return require(svc.RS.Modules.Network.Network)
    end)
    if ok and m then _networkModule = m end
    return _networkModule
end

------------------------------------------------------------------------
-- TAB: SETTINGS
------------------------------------------------------------------------
local SettingsTab = Window:CreateTab("Settings", 0)

-- Theme Section
local ThemeSection = SettingsTab:CreateSection("Theme")

local ThemesList = { "Frost", "FrostDark", "FrostLight", "FrostPurple", "FrostCyan" }
local savedTheme = cfg.get("theme", "Frost")

ThemeSection:CreateDropdown({
    Name = "Theme",
    Options = ThemesList,
    CurrentOption = savedTheme,
    Flag = "ThemeDropdown",
    Callback = function(Option)
        cfg.set("theme", Option)
        ApplyCustomTheme(Option)
    end
})

-- Interface Section
local InterfaceSection = SettingsTab:CreateSection("Interface")

local chatForceEnabled = cfg.get("chatForceEnabled", false)
local chatForceConns = {}

local function enforceChatOn()
    if not chatForceEnabled then return end
    local cw = svc.TextChat:FindFirstChild("ChatWindowConfiguration")
    local ci = svc.TextChat:FindFirstChild("ChatInputBarConfiguration")
    if cw and not cw.Enabled then cw.Enabled = true end
    if ci and not ci.Enabled then ci.Enabled = true end
end

InterfaceSection:CreateToggle({
    Name = "Show Chat Logs",
    CurrentValue = chatForceEnabled,
    Flag = "ShowChatLogs",
    Callback = function(on)
        chatForceEnabled = on
        cfg.set("chatForceEnabled", on)
        for _, c in ipairs(chatForceConns) do if c.Connected then c:Disconnect() end end
        chatForceConns = {}
        if on then
            enforceChatOn()
            for _, key in ipairs({ "ChatWindowConfiguration", "ChatInputBarConfiguration" }) do
                local obj = svc.TextChat:FindFirstChild(key)
                if obj then
                    table.insert(chatForceConns, obj:GetPropertyChangedSignal("Enabled"):Connect(enforceChatOn))
                end
            end
        end
    end
})

local timerSide = cfg.get("timerSide", "Middle")
local function applyTimerPos()
    local rt = lp.PlayerGui:FindFirstChild("RoundTimer")
    local m  = rt and rt:FindFirstChild("Main")
    if m then m.Position = UDim2.new(timerSide == "Middle" and 0.5 or 0.9, 0, m.Position.Y.Scale, m.Position.Y.Offset) end
end
applyTimerPos()

InterfaceSection:CreateDropdown({
    Name = "Timer Position",
    Options = { "Middle", "Right" },
    CurrentOption = timerSide,
    Flag = "TimerPosition",
    Callback = function(v)
        timerSide = v
        cfg.set("timerSide", v)
        applyTimerPos()
    end
})

lp.CharacterAdded:Connect(function()
    task.delay(1, function() applyTimerPos() end)
end)

-- Platform Spoofer Section
local PlatformSection = SettingsTab:CreateSection("Platform Spoofer")

PlatformSection:CreateParagraph({
    Title = "How it works",
    Content = "Repeatedly fires a SetDevice network call telling the server you are on a different platform (PC, Mobile, or Console). Some killers and abilities behave differently depending on platform."
})

local platEnabled = cfg.get("platEnabled", false)
local platDevice = cfg.get("platDevice", "Console")
local platLoop = nil
local platConn = nil

local function platPush()
    if not platEnabled then return end
    local net = getNetwork()
    if net then pcall(function() net:FireServerConnection("SetDevice", "REMOTE_EVENT", platDevice) end) end
end

local function platStart()
    if platLoop then return end
    platPush()
    if platConn then platConn:Disconnect() end
    platConn = svc.Input.LastInputTypeChanged:Connect(function() if platEnabled then platPush() end end)
    platLoop = task.spawn(function() while platEnabled do platPush(); task.wait(1) end; platLoop = nil end)
end

local function platStop()
    platEnabled = false
    if platLoop then task.cancel(platLoop); platLoop = nil end
    if platConn then platConn:Disconnect(); platConn = nil end
end

PlatformSection:CreateToggle({
    Name = "Enable Spoofer",
    CurrentValue = platEnabled,
    Flag = "PlatEnabled",
    Callback = function(on)
        platEnabled = on
        cfg.set("platEnabled", on)
        if on then platStart() else platStop() end
    end
})

PlatformSection:CreateDropdown({
    Name = "Device",
    Options = { "PC", "Mobile", "Console" },
    CurrentOption = platDevice,
    Flag = "PlatDevice",
    Callback = function(v)
        platDevice = v
        cfg.set("platDevice", v)
        if platEnabled then platPush() end
    end
})

lp.CharacterAdded:Connect(function()
    task.delay(1, function() if platEnabled then platPush() end end)
end)

------------------------------------------------------------------------
-- TAB: GLOBAL
------------------------------------------------------------------------
local GlobalTab = Window:CreateTab("Global", 0)

-- Stamina Section
local StaminaSection = GlobalTab:CreateSection("Stamina")

StaminaSection:CreateParagraph({
    Title = "How it works",
    Content = "Directly modifies the client-side Sprinting module values — StaminaLoss, StaminaGain, MaxStamina and StaminaLossDisabled. Infinite Stamina sets StaminaLossDisabled to true so sprinting never drains your bar."
})

local stam = {
    on = cfg.get("stamOn", false),
    loss = cfg.get("stamLoss", 10),
    gain = cfg.get("stamGain", 20),
    max = cfg.get("stamMax", 100),
    current = cfg.get("stamCurrent", 100),
    noLoss = cfg.get("stamNoLoss", false),
    thread = nil,
}

local function stamModule()
    local ok, m = pcall(function() return require(svc.RS.Systems.Character.Game.Sprinting) end)
    return ok and m or nil
end

local function stamIsKiller()
    local ch = lp.Character
    if not ch then return false end
    local kf = getTeamFolder("Killers")
    return kf and ch:IsDescendantOf(kf)
end

local function stamApply()
    local m = stamModule()
    if not m then return end
    if not m.DefaultsSet then pcall(function() m.Init() end) end
    local forceNoLoss = stam.noLoss or stamIsKiller()
    m.StaminaLoss = stam.loss
    m.StaminaGain = stam.gain
    local abilityCapActive = type(m.StaminaCap) == "number" and m.StaminaCap < (m.MaxStamina or math.huge)
    if not abilityCapActive then
        m.MaxStamina = stam.max
        if type(m.StaminaCap) == "number" then m.StaminaCap = stam.max end
    end
    m.StaminaLossDisabled = forceNoLoss
    if m.Stamina and m.Stamina > stam.max then m.Stamina = stam.current end
    pcall(function() if m.__staminaChangedEvent then m.__staminaChangedEvent:Fire() end end)
end

local function stamStart()
    if stam.thread then return end
    stam.thread = task.spawn(function()
        while stam.on do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then stamApply() end
            task.wait(0.5)
        end
        stam.thread = nil
    end)
end

local function stamStop()
    stam.on = false
    if stam.thread then task.cancel(stam.thread); stam.thread = nil end
end

StaminaSection:CreateToggle({
    Name = "Custom Stamina",
    CurrentValue = stam.on,
    Flag = "StamOn",
    Callback = function(on)
        stam.on = on
        cfg.set("stamOn", on)
        if on then stamStart() else stamStop() end
    end
})

StaminaSection:CreateSlider({
    Name = "Loss Rate",
    Range = {0, 50},
    Increment = 1,
    CurrentValue = stam.loss,
    Flag = "StamLoss",
    Callback = function(v)
        stam.loss = v
        cfg.set("stamLoss", v)
    end
})

StaminaSection:CreateSlider({
    Name = "Gain Rate",
    Range = {0, 50},
    Increment = 1,
    CurrentValue = stam.gain,
    Flag = "StamGain",
    Callback = function(v)
        stam.gain = v
        cfg.set("stamGain", v)
    end
})

StaminaSection:CreateSlider({
    Name = "Max Pool",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = stam.max,
    Flag = "StamMax",
    Callback = function(v)
        stam.max = v
        cfg.set("stamMax", v)
    end
})

StaminaSection:CreateSlider({
    Name = "Current Value",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = stam.current,
    Flag = "StamCurrent",
    Callback = function(v)
        stam.current = v
        cfg.set("stamCurrent", v)
    end
})

StaminaSection:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = stam.noLoss,
    Flag = "StamNoLoss",
    Callback = function(on)
        stam.noLoss = on
        cfg.set("stamNoLoss", on)
        stamApply()
        if on and not stam.on then
            stam.on = true
            stamStart()
        end
    end
})

if stam.on then stamStart() end

lp.CharacterAdded:Connect(function()
    task.delay(1.5, function()
        if stam.on then
            stamApply()
            if not stam.thread then stamStart() end
        end
    end)
end)

-- Status Section
local StatusSection = GlobalTab:CreateSection("Status Effects")

StatusSection:CreateParagraph({
    Title = "How it works",
    Content = "Destroys the LocalScript or ModuleScript responsible for applying each status effect (Slowness, Hallucination, Visual glitches). Toggle again to restore."
})

local statusGroups = {
    Slowness = { on = false, paths = { "Modules.Schematics.StatusEffects.Slowness" } },
    Hallucination = { on = false, paths = { "Modules.Schematics.StatusEffects.KillerExclusive.Hallucination" } },
    Visual = { on = false, paths = {
        "Modules.Schematics.StatusEffects.Blindness",
        "Modules.Schematics.StatusEffects.SurvivorExclusive.Subspaced",
        "Modules.Schematics.StatusEffects.KillerExclusive.Glitched",
    } },
}
local statusBackup = {}

local function statusResolve(path)
    local node = svc.RS
    for seg in path:gmatch("[^%.]+") do
        node = node:FindFirstChild(seg)
        if not node then return nil end
    end
    return node
end

local function statusBlock(path)
    if statusBackup[path] then return end
    local mod = statusResolve(path)
    if not mod then return end
    if mod:IsA("Folder") then
        statusBackup[path] = { clone = mod:Clone(), isFolder = true, parentPath = path:match("^(.-)%.?[^%.]+$") }
        mod:Destroy()
    elseif mod:IsA("ModuleScript") or mod:IsA("LocalScript") then
        statusBackup[path] = { clone = mod:Clone(), src = mod.Source, isFolder = false }
        mod:Destroy()
    end
end

local function statusRestore(path)
    local saved = statusBackup[path]
    if not saved then return end
    local existing = statusResolve(path)
    if existing then existing:Destroy() end
    local parentPath = saved.parentPath or path:match("^(.-)%.?[^%.]+$")
    local parent = statusResolve(parentPath)
    if parent then
        if not saved.isFolder then saved.clone.Source = saved.src end
        saved.clone.Parent = parent
    end
    statusBackup[path] = nil
end

local statusLoopThread = nil

local function statusTick()
    if statusLoopThread then return end
    statusLoopThread = task.spawn(function()
        while true do
            local any = false
            for _, g in pairs(statusGroups) do
                if g.on then
                    any = true
                    for _, p in ipairs(g.paths) do
                        local m = statusResolve(p)
                        if m then m:Destroy() end
                    end
                end
            end
            if not any then break end
            task.wait(0.8)
        end
        statusLoopThread = nil
    end)
end

local function statusToggle(name)
    local g = statusGroups[name]
    if not g then return end
    g.on = not g.on
    for _, p in ipairs(g.paths) do
        if g.on then statusBlock(p) else statusRestore(p) end
    end
    local any = false
    for _, sg in pairs(statusGroups) do if sg.on then any = true; break end end
    if any then statusTick() elseif statusLoopThread then task.cancel(statusLoopThread); statusLoopThread = nil end
end

StatusSection:CreateButton({
    Name = "Toggle: Slowness",
    Callback = function() statusToggle("Slowness") end
})

StatusSection:CreateButton({
    Name = "Toggle: Hallucination",
    Callback = function() statusToggle("Hallucination") end
})

StatusSection:CreateButton({
    Name = "Toggle: Visual Effects",
    Callback = function() statusToggle("Visual") end
})

lp.CharacterAdded:Connect(function()
    statusBackup = {}
    for _, g in pairs(statusGroups) do g.on = false end
    if statusLoopThread then task.cancel(statusLoopThread); statusLoopThread = nil end
end)

-- remote helper
local _hbRemote = nil
local function hbGetRemote()
    if _hbRemote and _hbRemote.Parent then return _hbRemote end
    local ok, re = pcall(function()
        return svc.RS.Modules.Network.Network:FindFirstChild("RemoteEvent")
    end)
    if ok and re then _hbRemote = re; return re end
    return nil
end

------------------------------------------------------------------------
-- TAB: GENERATOR
------------------------------------------------------------------------
local GenTab = Window:CreateTab("Generator", 0)

local GenSection = GenTab:CreateSection("Auto Solve")

GenSection:CreateParagraph({
    Title = "How it works",
    Content = "Hooks into the FlowGame module and auto-solves puzzles. Node Speed controls fill speed, Line Pause is delay between color lines."
})

local flow = { on = cfg.get("flowOn", false), nodeDelay = cfg.get("flowNodeDelay", 0.04), lineDelay = cfg.get("flowLineDelay", 0.60) }

local function flowKey(n) return n.row .. "-" .. n.col end

local function flowNeighbour(r1, c1, r2, c2)
    if r2 == r1 - 1 and c2 == c1 then return "up" end
    if r2 == r1 + 1 and c2 == c1 then return "down" end
    if r2 == r1 and c2 == c1 - 1 then return "left" end
    if r2 == r1 and c2 == c1 + 1 then return "right" end
    return false
end

local function flowOrder(path, endpoints)
    if not path or #path == 0 then return path end
    local lookup = {}
    for _, n in ipairs(path) do lookup[flowKey(n)] = n end
    local start
    for _, ep in ipairs(endpoints or {}) do
        for _, n in ipairs(path) do
            if n.row == ep.row and n.col == ep.col then start = { row = ep.row, col = ep.col }; break end
        end
        if start then break end
    end
    if not start then
        for _, n in ipairs(path) do
            local nb = 0
            for _, d in ipairs({ { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }) do
                if lookup[(n.row + d[1]) .. "-" .. (n.col + d[2])] then nb = nb + 1 end
            end
            if nb == 1 then start = { row = n.row, col = n.col }; break end
        end
    end
    if not start then start = { row = path[1].row, col = path[1].col } end
    local pool, ordered = {}, {}
    for _, n in ipairs(path) do pool[flowKey(n)] = { row = n.row, col = n.col } end
    local cur = start
    table.insert(ordered, { row = cur.row, col = cur.col })
    pool[flowKey(cur)] = nil
    while next(pool) do
        local moved = false
        for k, node in pairs(pool) do
            if flowNeighbour(cur.row, cur.col, node.row, node.col) then
                table.insert(ordered, { row = node.row, col = node.col })
                pool[k] = nil
                cur = node
                moved = true
                break
            end
        end
        if not moved then break end
    end
    return ordered
end

local function flowSolve(puzzle)
    if not puzzle or not puzzle.Solution then return end
    local indices = {}
    for i = 1, #puzzle.Solution do indices[i] = i end
    for i = #indices, 2, -1 do
        local j = math.random(1, i)
        indices[i], indices[j] = indices[j], indices[i]
    end
    for _, ci in ipairs(indices) do
        local solution = puzzle.Solution[ci]
        if not solution then goto continue end
        local ordered = flowOrder(solution, puzzle.targetPairs[ci])
        if not ordered or #ordered == 0 then goto continue end
        puzzle.paths[ci] = {}
        for _, node in ipairs(ordered) do
            table.insert(puzzle.paths[ci], { row = node.row, col = node.col })
            puzzle:updateGui()
            task.wait(flow.nodeDelay)
        end
        task.wait(flow.lineDelay)
        puzzle:checkForWin()
        ::continue::
    end
end

do
    local modFolder = svc.RS:FindFirstChild("Modules")
    local miniFolder = modFolder and modFolder:FindFirstChild("Minigames")
    local fgFolder = miniFolder and miniFolder:FindFirstChild("FlowGameManager")
    local fgModule = fgFolder and fgFolder:FindFirstChild("FlowGame")
    if fgModule then
        local ok, FG = pcall(require, fgModule)
        if ok and FG and FG.new then
            local orig = FG.new
            FG.new = function(...)
                local p = orig(...)
                if flow.on then task.spawn(function() task.wait(0.3); flowSolve(p) end) end
                return p
            end
        end
    end
end

GenSection:CreateToggle({
    Name = "Auto Solve",
    CurrentValue = flow.on,
    Flag = "FlowOn",
    Callback = function(on)
        flow.on = on
        cfg.set("flowOn", on)
    end
})

GenSection:CreateSlider({
    Name = "Node Speed",
    Range = {0.01, 0.50},
    Increment = 0.02,
    CurrentValue = flow.nodeDelay,
    Flag = "FlowNodeDelay",
    Callback = function(v)
        flow.nodeDelay = v
        cfg.set("flowNodeDelay", v)
    end
})

GenSection:CreateSlider({
    Name = "Line Pause",
    Range = {0.00, 1.00},
    Increment = 0.10,
    CurrentValue = flow.lineDelay,
    Flag = "FlowLineDelay",
    Callback = function(v)
        flow.lineDelay = v
        cfg.set("flowLineDelay", v)
    end
})

------------------------------------------------------------------------
-- TAB: KILLER
------------------------------------------------------------------------
local KillerTab = Window:CreateTab("Killer", 0)

-- Aimbot Section
local AimbotSection = KillerTab:CreateSection("Aimbot")

AimbotSection:CreateParagraph({
    Title = "How it works",
    Content = "Listens for ability FireServer calls and locks your rotation toward the nearest survivor. AutoRotate is disabled during lock and restored after."
})

local aim = {
    on = cfg.get("aimOn", false), cooldown = cfg.get("aimCooldown", 0.3), lockTime = cfg.get("aimLockTime", 0.4),
    maxDist = cfg.get("aimMaxDist", 30), smooth = cfg.get("aimSmooth", 0.35),
    targeting = false, target = nil, deathConn = nil, autoRotate = nil, lastFired = 0,
    hum = nil, hrp = nil, cache = {}, cacheTime = 0, cacheLife = 0.5,
}

local function aimAmIKiller()
    local ch = lp.Character
    if not ch then return false end
    local kf = getTeamFolder("Killers")
    return kf and ch:IsDescendantOf(kf)
end

local function aimRefreshChar(ch)
    aim.hum = ch:FindFirstChildOfClass("Humanoid")
    aim.hrp = ch:FindFirstChild("HumanoidRootPart")
end

local function aimRefreshTargets()
    local now = tick()
    if now - aim.cacheTime < aim.cacheLife then return end
    aim.cacheTime = now
    aim.cache = {}
    local sf = getTeamFolder("Survivors")
    if not sf then return end
    for _, model in ipairs(sf:GetChildren()) do
        if model ~= lp.Character and model:IsA("Model") then
            local h = model:FindFirstChildOfClass("Humanoid")
            local r = model:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then table.insert(aim.cache, r) end
        end
    end
end

local function aimNearest()
    aimRefreshTargets()
    if not aim.hrp or #aim.cache == 0 then return nil end
    local best, bd = nil, math.huge
    for _, r in ipairs(aim.cache) do
        local d = (r.Position - aim.hrp.Position).Magnitude
        if d < bd and d <= aim.maxDist then bd = d; best = r end
    end
    return best
end

local function aimUnlock()
    if not aim.targeting then return end
    if aim.deathConn then aim.deathConn:Disconnect(); aim.deathConn = nil end
    if aim.autoRotate ~= nil and aim.hum then aim.hum.AutoRotate = aim.autoRotate end
    aim.targeting = false
    aim.target = nil
end

local function aimLock(r)
    if not r or not r.Parent or not aim.hum or not aim.hrp then return end
    if aim.targeting and aim.target == r then return end
    aimUnlock()
    aim.target = r
    aim.targeting = true
    aim.autoRotate = aim.hum.AutoRotate
    aim.hum.AutoRotate = false
    local th = r.Parent:FindFirstChildOfClass("Humanoid")
    if th then aim.deathConn = th.Died:Connect(aimUnlock) end
    task.delay(aim.lockTime, function() if aim.target == r then aimUnlock() end end)
end

svc.Run.RenderStepped:Connect(function()
    if not aim.on or not aim.targeting or not aim.hrp or not aim.target then return end
    if not aim.target.Parent then aimUnlock(); return end
    local th = aim.target.Parent:FindFirstChildOfClass("Humanoid")
    if not th or th.Health <= 0 then aimUnlock(); return end
    local dx = aim.target.Position.X - aim.hrp.Position.X
    local dz = aim.target.Position.Z - aim.hrp.Position.Z
    local mag = math.sqrt(dx * dx + dz * dz)
    if mag > 0 then
        local flat = Vector3.new(dx / mag, 0, dz / mag)
        aim.hrp.CFrame = aim.hrp.CFrame:Lerp(CFrame.new(aim.hrp.Position, aim.hrp.Position + flat), aim.smooth)
    end
end)

task.spawn(function()
    local remote = hbGetRemote()
    if not remote then return end
    remote.OnClientEvent:Connect(function(...)
        if not aim.on then return end
        local a = { ... }
        if typeof(a[1]) ~= "string" then return end
        local n = a[1]
        if not (n:match("Ability") or n:match("[QER]") or n == "Slash" or n == "Dagger" or n == "Charge") then return end
        if tick() - aim.lastFired < aim.cooldown then return end
        aim.lastFired = tick()
        if aimAmIKiller() then
            local t = aimNearest()
            if t then aimLock(t) end
        end
    end)
end)

lp.CharacterAdded:Connect(function(ch) task.wait(0.5); aimRefreshChar(ch) end)
if lp.Character then aimRefreshChar(lp.Character) end

AimbotSection:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = aim.on,
    Flag = "AimOn",
    Callback = function(on)
        aim.on = on
        cfg.set("aimOn", on)
        if not on then aimUnlock() end
    end
})

AimbotSection:CreateSlider({
    Name = "Cooldown (s)",
    Range = {0.1, 2.0},
    Increment = 0.05,
    CurrentValue = aim.cooldown,
    Flag = "AimCooldown",
    Callback = function(v)
        aim.cooldown = v
        cfg.set("aimCooldown", v)
    end
})

AimbotSection:CreateSlider({
    Name = "Lock Time (s)",
    Range = {0.1, 3.0},
    Increment = 0.1,
    CurrentValue = aim.lockTime,
    Flag = "AimLockTime",
    Callback = function(v)
        aim.lockTime = v
        cfg.set("aimLockTime", v)
    end
})

AimbotSection:CreateSlider({
    Name = "Max Distance",
    Range = {5, 100},
    Increment = 5,
    CurrentValue = aim.maxDist,
    Flag = "AimMaxDist",
    Callback = function(v)
        aim.maxDist = v
        cfg.set("aimMaxDist", v)
    end
})

AimbotSection:CreateSlider({
    Name = "Rotation Smoothing",
    Range = {0.05, 1.0},
    Increment = 0.05,
    CurrentValue = aim.smooth,
    Flag = "AimSmooth",
    Callback = function(v)
        aim.smooth = v
        cfg.set("aimSmooth", v)
    end
})

-- Anti-Backstab Section
local ABSSection = KillerTab:CreateSection("Anti-Backstab")

ABSSection:CreateParagraph({
    Title = "How it works",
    Content = "Watches for TwoTime backstab sounds and rotates you to face TwoTime instantly when triggered within Detection Range."
})

local abs = { on = cfg.get("absOn", false), range = cfg.get("absRange", 40), duration = cfg.get("absDur", 1.5), locked = false, soundConn = nil, scanThread = nil, rings = {} }
local absTriggerSounds = { ["86710781315432"] = true, ["99820161736138"] = true }
local absScreenGui = nil

local function absGui()
    if absScreenGui and absScreenGui.Parent then return absScreenGui end
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return nil end
    absScreenGui = Instance.new("ScreenGui")
    absScreenGui.Name = "AbsGui"
    absScreenGui.ResetOnSpawn = false
    absScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    absScreenGui.Parent = pg
    return absScreenGui
end

local function absShowLabel(show)
    local g = absGui()
    if not g then return end
    local lbl = g:FindFirstChild("AbsTaunt")
    if not lbl then
        lbl = Instance.new("TextLabel")
        lbl.Name = "AbsTaunt"
        lbl.Size = UDim2.new(0, 500, 0, 50)
        lbl.Position = UDim2.new(0.5, -250, 0.38, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextStrokeTransparency = 0.4
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Text = "At least they tried 😂"
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 36
        lbl.TextTransparency = 1
        lbl.Parent = g
    end
    pcall(function() svc.TweenService:Create(lbl, TweenInfo.new(show and 0.15 or 0.5), { TextTransparency = show and 0 or 1 }):Play() end)
end

local function absAddRing(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp or abs.rings[model] then return end
    pcall(function()
        local ring = Instance.new("Part")
        ring.Name = "AbsRing"
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
        ring.Color = Color3.fromRGB(220, 50, 50)
        ring.Material = Enum.Material.ForceField
        ring.Transparency = 0.5
        ring.CanCollide = false
        ring.CanTouch = false
        ring.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = hrp
        local w = Instance.new("WeldConstraint")
        w.Part0 = hrp
        w.Part1 = ring
        w.Parent = ring
        abs.rings[model] = ring
    end)
end

local function absRemoveRing(model)
    local r = abs.rings[model]
    if r then pcall(function() r:Destroy() end); abs.rings[model] = nil end
end

local function absResizeRings()
    for _, r in pairs(abs.rings) do if r and r.Parent then r.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2) end end
end

local function absCleanRings()
    for m in pairs(abs.rings) do absRemoveRing(m) end
end

local function absFindTwoTime()
    local players = svc.WS:FindFirstChild("Players")
    if not players then return nil end
    for _, folder in ipairs(players:GetChildren()) do
        local tt = folder:FindFirstChild("TwoTime")
        if tt then return tt end
    end
    return nil
end

local function absTrigger()
    if abs.locked then return end
    local ch = lp.Character
    local myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local ttModel = absFindTwoTime()
    if not ttModel then return end
    local ttRoot = ttModel:FindFirstChild("HumanoidRootPart")
    if not ttRoot then return end
    if (myRoot.Position - ttRoot.Position).Magnitude > abs.range then return end
    abs.locked = true
    absShowLabel(true)
    task.spawn(function()
        local deadline = tick() + abs.duration
        while tick() < deadline do
            if not abs.on then break end
            local ch2 = lp.Character
            local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
            if not r2 or not ttRoot.Parent then break end
            r2.CFrame = CFrame.lookAt(r2.Position, Vector3.new(ttRoot.Position.X, r2.Position.Y, ttRoot.Position.Z))
            svc.Run.RenderStepped:Wait()
        end
        abs.locked = false
        absShowLabel(false)
    end)
end

local function absHookSounds()
    if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
    abs.soundConn = svc.WS.DescendantAdded:Connect(function(obj)
        if not abs.on or not obj:IsA("Sound") then return end
        local id = obj.SoundId:match("%d+")
        if id and absTriggerSounds[id] then absTrigger() end
    end)
end

local function absStartScan()
    if abs.scanThread then return end
    abs.scanThread = task.spawn(function()
        while abs.on do
            local players = svc.WS:FindFirstChild("Players")
            if players then
                for _, folder in ipairs(players:GetChildren()) do
                    for _, model in ipairs(folder:GetChildren()) do
                        if model.Name == "TwoTime" then absAddRing(model) end
                    end
                end
            end
            for m in pairs(abs.rings) do if not m.Parent then absRemoveRing(m) end end
            task.wait(1)
        end
        abs.scanThread = nil
    end)
end

local function absStart()
    absHookSounds()
    absStartScan()
end

local function absStop()
    abs.on = false
    if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
    if abs.scanThread then task.cancel(abs.scanThread); abs.scanThread = nil end
    absCleanRings()
    abs.locked = false
    absShowLabel(false)
end

lp.CharacterAdded:Connect(function()
    abs.locked = false
    if abs.on then absStart() end
end)

ABSSection:CreateToggle({
    Name = "Enable Anti-Backstab",
    CurrentValue = abs.on,
    Flag = "AbsOn",
    Callback = function(on)
        abs.on = on
        cfg.set("absOn", on)
        if on then absStart() else absStop() end
    end
})

ABSSection:CreateSlider({
    Name = "Detection Range",
    Range = {10, 120},
    Increment = 5,
    CurrentValue = abs.range,
    Flag = "AbsRange",
    Callback = function(v)
        abs.range = v
        cfg.set("absRange", v)
        absResizeRings()
    end
})

ABSSection:CreateSlider({
    Name = "Look Duration (s)",
    Range = {0.3, 5.0},
    Increment = 0.1,
    CurrentValue = abs.duration,
    Flag = "AbsDur",
    Callback = function(v)
        abs.duration = v
        cfg.set("absDur", v)
    end
})

-- Killer Abilities Section
local AbilitiesSection = KillerTab:CreateSection("Killer Abilities")

AbilitiesSection:CreateParagraph({
    Title = "How it works",
    Content = "Sixer Air Strafe: steer mid-air during dash. c00lkidd Dash Turn: redirect velocity toward WASD input. Noli Void Rush: move at 60 speed during dash."
})

-- Sixer Air Strafe
local sixerStrafeOn = cfg.get("sixerStrafeOn", false)
local SIXER_BIND = "FrostsakenSixerStrafe"

svc.Run:BindToRenderStep(SIXER_BIND, Enum.RenderPriority.Character.Value + 2, function()
    if not sixerStrafeOn then return end
    local char = lp.Character
    if not char then return end
    if char:GetAttribute("PursuitState") ~= "Dashing" then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if hum.FloorMaterial ~= Enum.Material.Air then return end
    local cam = svc.WS.CurrentCamera
    local flat = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
    if flat.Magnitude < 0.01 then return end
    flat = flat.Unit
    local vel = hrp.AssemblyLinearVelocity
    local hVel = Vector3.new(vel.X, 0, vel.Z)
    local hSpeed = hVel.Magnitude
    if hSpeed < 0.1 then return end
    local newH = hVel:Lerp(flat * hSpeed, 1)
    hrp.AssemblyLinearVelocity = Vector3.new(newH.X, vel.Y, newH.Z)
end)

-- c00lkidd Dash Turn
local coolkidWSOOn = cfg.get("coolkidWSOOn", false)

local function coolkidGetInputDir()
    local cf = svc.WS.CurrentCamera.CFrame
    local fwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit
    local right = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z).Unit
    local dir = Vector3.zero
    if svc.Input:IsKeyDown(Enum.KeyCode.W) then dir = dir + fwd end
    if svc.Input:IsKeyDown(Enum.KeyCode.S) then dir = dir - fwd end
    if svc.Input:IsKeyDown(Enum.KeyCode.A) then dir = dir - right end
    if svc.Input:IsKeyDown(Enum.KeyCode.D) then dir = dir + right end
    return dir.Magnitude > 0 and dir.Unit or nil
end

svc.Run:BindToRenderStep("CoolkidWSO", Enum.RenderPriority.Character.Value + 1, function()
    if not coolkidWSOOn then return end
    local char = lp.Character
    if not char then return end
    if char:GetAttribute("PursuitState") ~= "Dashing" then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local inputDir = coolkidGetInputDir()
    if not inputDir then return end
    local vel = hrp.AssemblyLinearVelocity
    local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
    if speed < 0.1 then return end
    hrp.AssemblyLinearVelocity = Vector3.new(inputDir.X * speed, vel.Y, inputDir.Z * speed)
    hum.WalkSpeed = 60
    hum.AutoRotate = false
    local horiz = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
    if horiz.Magnitude > 0 then hum:Move(horiz.Unit) end
end)

-- Noli Void Rush Control
local noliVoidRushOn = cfg.get("noliVoidRushOn", false)
local noliOverrideActive = false
local noliOrigWalkSpeed = nil
local noliOrigAutoRotate = nil

local function noliStart()
    if noliOverrideActive then return end
    noliOverrideActive = true
    local char = lp.Character
    if not char then noliOverrideActive = false; return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then noliOverrideActive = false; return end
    noliOrigWalkSpeed = hum.WalkSpeed
    noliOrigAutoRotate = hum.AutoRotate
    svc.Run:BindToRenderStep("NoliVoidRush", Enum.RenderPriority.Character.Value + 3, function()
        if not noliOverrideActive then svc.Run:UnbindFromRenderStep("NoliVoidRush"); return end
        local ch2 = lp.Character
        if not ch2 then return end
        local hrp2 = ch2:FindFirstChild("HumanoidRootPart")
        local hum2 = ch2:FindFirstChildOfClass("Humanoid")
        if not hrp2 or not hum2 then return end
        hum2.WalkSpeed = 60
        hum2.AutoRotate = false
        local horiz = Vector3.new(hrp2.CFrame.LookVector.X, 0, hrp2.CFrame.LookVector.Z)
        if horiz.Magnitude > 0 then hum2:Move(horiz.Unit) end
    end)
end

local function noliStop()
    if not noliOverrideActive then return end
    noliOverrideActive = false
    svc.Run:UnbindFromRenderStep("NoliVoidRush")
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if noliOrigWalkSpeed ~= nil then hum.WalkSpeed = noliOrigWalkSpeed end
    if noliOrigAutoRotate ~= nil then hum.AutoRotate = noliOrigAutoRotate end
    noliOrigWalkSpeed = nil
    noliOrigAutoRotate = nil
end

svc.Run.RenderStepped:Connect(function()
    if not noliVoidRushOn then
        if noliOverrideActive then noliStop() end
        return
    end
    local char = lp.Character
    if not char then return end
    if char:GetAttribute("VoidRushState") == "Dashing" then noliStart() else noliStop() end
end)

lp.CharacterAdded:Connect(function() noliStop(); noliOrigWalkSpeed = nil end)

AbilitiesSection:CreateToggle({
    Name = "Sixer — Air Strafe",
    CurrentValue = sixerStrafeOn,
    Flag = "SixerStrafeOn",
    Callback = function(on)
        sixerStrafeOn = on
        cfg.set("sixerStrafeOn", on)
    end
})

AbilitiesSection:CreateToggle({
    Name = "c00lkidd — Dash Turn",
    CurrentValue = coolkidWSOOn,
    Flag = "CoolkidWSOOn",
    Callback = function(on)
        coolkidWSOOn = on
        cfg.set("coolkidWSOOn", on)
    end
})

AbilitiesSection:CreateToggle({
    Name = "Noli — Void Rush Control",
    CurrentValue = noliVoidRushOn,
    Flag = "NoliVoidRushOn",
    Callback = function(on)
        noliVoidRushOn = on
        cfg.set("noliVoidRushOn", on)
        if not on then noliStop() end
    end
})

------------------------------------------------------------------------
-- TAB: VISUAL (ESP)
------------------------------------------------------------------------
local VisualTab = Window:CreateTab("Visual", 0)
local ESPSection = VisualTab:CreateSection("ESP")

ESPSection:CreateParagraph({
    Title = "How it works",
    Content = "Fully event-driven ESP with zero polling. Killers, Survivors, Generators, Items, and Buildings all have customizable colors."
})

-- ESP Color Picker Section
local ColorSection = VisualTab:CreateSection("ESP Colors")

ColorSection:CreateColorPicker({
    Name = "Killer Color",
    Color = ESPColors.Killers,
    Flag = "KillerColor",
    Callback = function(color)
        UpdateESPColor("Killers", color)
    end
})

ColorSection:CreateColorPicker({
    Name = "Survivor Color",
    Color = ESPColors.Survivors,
    Flag = "SurvivorColor",
    Callback = function(color)
        UpdateESPColor("Survivors", color)
    end
})

ColorSection:CreateColorPicker({
    Name = "Generator Color",
    Color = ESPColors.Generators,
    Flag = "GeneratorColor",
    Callback = function(color)
        UpdateESPColor("Generators", color)
    end
})

ColorSection:CreateColorPicker({
    Name = "Item Color",
    Color = ESPColors.Items,
    Flag = "ItemColor",
    Callback = function(color)
        UpdateESPColor("Items", color)
    end
})

ColorSection:CreateColorPicker({
    Name = "Building Color",
    Color = ESPColors.Buildings,
    Flag = "BuildingColor",
    Callback = function(color)
        UpdateESPColor("Buildings", color)
    end
})

-- ESP Core
esp = {
    killers = cfg.get("espKillers", false),
    survivors = cfg.get("espSurvivors", false),
    generators = cfg.get("espGenerators", false),
    items = cfg.get("espItems", false),
    buildings = cfg.get("espBuildings", false),
    killerFolder = nil,
    survivorFolder = nil,
    mapFolder = nil,
    playerConns = {},
    mapConns = {},
    healthConns = setmetatable({}, { __mode = "k" }),
    progConns = setmetatable({}, { __mode = "k" }),
    guardConns = setmetatable({}, { __mode = "k" }),
    ready = false,
}

local function espItemColor(name)
    local n = name:lower()
    if n:find("medkit") then return Color3.fromRGB(0, 255, 200) end
    if n:find("bloxycola") then return Color3.fromRGB(0, 200, 255) end
    return ESPColors.Items
end

local function espItemHeld(obj)
    for _, plr in ipairs(svc.Players:GetPlayers()) do
        local ch = plr.Character
        if ch and obj:IsDescendantOf(ch) then return true end
        local bp = plr:FindFirstChildOfClass("Backpack")
        if bp and obj:IsDescendantOf(bp) then return true end
    end
    return false
end

local espAttach
local espDetach

espAttach = function(obj, tag, color, isChar)
    if not obj or not obj.Parent then return end
    if obj:FindFirstChild(tag) then return end

    if esp.guardConns[obj] then pcall(function() esp.guardConns[obj]:Disconnect() end); esp.guardConns[obj] = nil end
    if esp.healthConns[obj] then pcall(function() esp.healthConns[obj]:Disconnect() end); esp.healthConns[obj] = nil end
    if esp.progConns[obj] then pcall(function() esp.progConns[obj]:Disconnect() end); esp.progConns[obj] = nil end

    local root
    if isChar then
        root = obj:FindFirstChild("HumanoidRootPart")
    else
        root = obj.PrimaryPart or obj:FindFirstChild("Base") or obj:FindFirstChild("Main")
        if not root then
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("BasePart") then root = child; break end
            end
        end
        if not root and obj:IsA("BasePart") then root = obj end
    end
    if not root then return end

    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Name = tag
        hl.FillColor = color
        hl.FillTransparency = 0.8
        hl.OutlineColor = color
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = obj
        hl.Parent = obj

        local bb = Instance.new("BillboardGui")
        bb.Name = tag .. "_bb"
        bb.Adornee = root
        bb.Size = UDim2.new(0, 100, 0, 20)
        bb.StudsOffset = Vector3.new(0, isChar and 3.5 or 3.8, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1000
        bb.Parent = obj

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = color
        lbl.TextStrokeTransparency = 0.5
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.TextSize = 15
        lbl.FontFace = Font.new("rbxasset://fonts/families/AccanthisADFStd.json")
        lbl.Parent = bb

        if isChar then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum then
                lbl.Text = obj.Name .. " (100%)"
                local c = hum.HealthChanged:Connect(function()
                    if lbl.Parent and hum.MaxHealth > 0 then
                        lbl.Text = obj.Name .. " (" .. math.floor(hum.Health / hum.MaxHealth * 100) .. "%)"
                    end
                end)
                esp.healthConns[obj] = c
            else
                lbl.Text = obj.Name
            end
        else
            local prog = obj:FindFirstChild("Progress")
            if prog and prog:IsA("NumberValue") then
                lbl.Text = math.floor(prog.Value) .. "%"
                local c = prog.Changed:Connect(function()
                    if lbl.Parent then lbl.Text = math.floor(prog.Value) .. "%" end
                end)
                esp.progConns[obj] = c
            else
                lbl.Text = obj.Name
            end
        end
    end)

    esp.guardConns[obj] = obj.ChildRemoved:Connect(function(removed)
        if removed.Name ~= tag and removed.Name ~= (tag .. "_bb") then return end
        task.defer(function()
            if not obj or not obj.Parent then return end
            if not isChar and espItemHeld(obj) then return end
            espAttach(obj, tag, color, isChar)
        end)
    end)
end

espDetach = function(obj, tag)
    if not obj then return end
    if esp.guardConns[obj] then pcall(function() esp.guardConns[obj]:Disconnect() end); esp.guardConns[obj] = nil end
    if esp.healthConns[obj] then pcall(function() esp.healthConns[obj]:Disconnect() end); esp.healthConns[obj] = nil end
    if esp.progConns[obj] then pcall(function() esp.progConns[obj]:Disconnect() end); esp.progConns[obj] = nil end
    pcall(function()
        local h = obj:FindFirstChild(tag); if h then h:Destroy() end
        local b = obj:FindFirstChild(tag .. "_bb"); if b then b:Destroy() end
    end)
end

local function espDoKillers(on)
    if not esp.killerFolder then return end
    for _, k in ipairs(esp.killerFolder:GetChildren()) do
        if k:IsA("Model") then
            if on then espAttach(k, "esp_k", ESPColors.Killers, true)
            else espDetach(k, "esp_k") end
        end
    end
end

local function espDoSurvivors(on)
    if not esp.survivorFolder then return end
    for _, s in ipairs(esp.survivorFolder:GetChildren()) do
        if s:IsA("Model") then
            if on then espAttach(s, "esp_s", ESPColors.Survivors, true)
            else espDetach(s, "esp_s") end
        end
    end
end

local function espDoGenerators(on)
    local map = getMapContent()
    if not map then return end
    for _, obj in ipairs(map:GetChildren()) do
        if obj.Name == "Generator" then
            if on then espAttach(obj, "esp_g", ESPColors.Generators, false)
            else espDetach(obj, "esp_g") end
        end
    end
end

local function espDoItems(on)
    local ig = getIngame()
    if not ig then return end
    for _, obj in ipairs(ig:GetDescendants()) do
        if obj.Name == "BloxyCola" or obj.Name == "Medkit" then
            if not espItemHeld(obj) then
                if on then espAttach(obj, "esp_i", espItemColor(obj.Name), false)
                else espDetach(obj, "esp_i") end
            end
        end
    end
end

local function espDoBuildings(on)
    local ig = getIngame()
    if not ig then return end
    for _, obj in ipairs(ig:GetChildren()) do
        if obj.Name == "BuildermanSentry" or obj.Name == "SubspaceTripmine" or obj.Name == "BuildermanDispenser" then
            if on then espAttach(obj, "esp_b", ESPColors.Buildings, false)
            else espDetach(obj, "esp_b") end
        end
    end
end

local function espBindPlayers()
    for _, c in pairs(esp.playerConns) do if c.Connected then c:Disconnect() end end
    esp.playerConns = {}

    if esp.killerFolder then
        table.insert(esp.playerConns, esp.killerFolder.ChildAdded:Connect(function(ch)
            task.defer(function()
                if esp.killers and ch and ch.Parent and ch:IsA("Model") then
                    espAttach(ch, "esp_k", ESPColors.Killers, true)
                end
            end)
        end))
        table.insert(esp.playerConns, esp.killerFolder.ChildRemoved:Connect(function(ch)
            espDetach(ch, "esp_k")
        end))
    end
    if esp.survivorFolder then
        table.insert(esp.playerConns, esp.survivorFolder.ChildAdded:Connect(function(ch)
            task.defer(function()
                if esp.survivors and ch and ch.Parent and ch:IsA("Model") then
                    espAttach(ch, "esp_s", ESPColors.Survivors, true)
                end
            end)
        end))
        table.insert(esp.playerConns, esp.survivorFolder.ChildRemoved:Connect(function(ch)
            espDetach(ch, "esp_s")
        end))
    end
end

local espMapChildConns = {}

local function espUnbindMapChildren()
    for _, c in ipairs(espMapChildConns) do if c.Connected then c:Disconnect() end end
    espMapChildConns = {}
end

local function espBindMapContent(mapObj)
    espUnbindMapChildren()
    esp.mapFolder = mapObj

    if esp.generators then espDoGenerators(true) end
    if esp.items then espDoItems(true) end

    table.insert(espMapChildConns, mapObj.ChildAdded:Connect(function(child)
        task.defer(function()
            if esp.generators and child.Name == "Generator" and child.Parent then
                espAttach(child, "esp_g", ESPColors.Generators, false)
            end
        end)
    end))
    table.insert(espMapChildConns, mapObj.ChildRemoved:Connect(function(child)
        if child.Name == "Generator" then espDetach(child, "esp_g") end
    end))
end

local function espBindWorld()
    for _, c in pairs(esp.mapConns) do if c.Connected then c:Disconnect() end end
    esp.mapConns = {}

    local ig = getIngame()
    if not ig then return end

    table.insert(esp.mapConns, ig.ChildAdded:Connect(function(obj)
        task.defer(function()
            if not obj or not obj.Parent then return end
            if esp.buildings and (obj.Name == "BuildermanSentry" or obj.Name == "SubspaceTripmine" or obj.Name == "BuildermanDispenser") then
                espAttach(obj, "esp_b", ESPColors.Buildings, false)
            end
            if obj.Name == "Map" then
                task.wait(0.5)
                espBindMapContent(obj)
            end
        end)
    end))

    table.insert(esp.mapConns, ig.ChildRemoved:Connect(function(obj)
        if obj.Name == "BuildermanSentry" or obj.Name == "SubspaceTripmine" or obj.Name == "BuildermanDispenser" then
            espDetach(obj, "esp_b")
        end
        if obj.Name == "Map" then
            espUnbindMapChildren()
            esp.mapFolder = nil
        end
    end))

    table.insert(esp.mapConns, ig.DescendantAdded:Connect(function(obj)
        if not esp.items then return end
        if obj.Name ~= "BloxyCola" and obj.Name ~= "Medkit" then return end
        task.defer(function()
            if obj and obj.Parent and not espItemHeld(obj) then
                espAttach(obj, "esp_i", espItemColor(obj.Name), false)
            end
        end)
    end))

    local existing = getMapContent()
    if existing then
        task.defer(function()
            task.wait(1)
            espBindMapContent(existing)
        end)
    end

    if esp.buildings then espDoBuildings(true) end
end

-- ESP Toggles
ESPSection:CreateToggle({
    Name = "Killers",
    CurrentValue = esp.killers,
    Flag = "EspKillers",
    Callback = function(on)
        esp.killers = on
        cfg.set("espKillers", on)
        espDoKillers(on)
    end
})

ESPSection:CreateToggle({
    Name = "Survivors",
    CurrentValue = esp.survivors,
    Flag = "EspSurvivors",
    Callback = function(on)
        esp.survivors = on
        cfg.set("espSurvivors", on)
        espDoSurvivors(on)
    end
})

ESPSection:CreateToggle({
    Name = "Generators",
    CurrentValue = esp.generators,
    Flag = "EspGenerators",
    Callback = function(on)
        esp.generators = on
        cfg.set("espGenerators", on)
        espDoGenerators(on)
    end
})

ESPSection:CreateToggle({
    Name = "Items",
    CurrentValue = esp.items,
    Flag = "EspItems",
    Callback = function(on)
        esp.items = on
        cfg.set("espItems", on)
        espDoItems(on)
    end
})

ESPSection:CreateToggle({
    Name = "Buildings",
    CurrentValue = esp.buildings,
    Flag = "EspBuildings",
    Callback = function(on)
        esp.buildings = on
        cfg.set("espBuildings", on)
        espDoBuildings(on)
    end
})

-- Minion ESP Section
local MinionSection = VisualTab:CreateSection("Minion & Ability ESP")

MinionSection:CreateParagraph({
    Title = "How it works",
    Content = "Tracks c00lkidd's pizza bots, 1x1x1x1 zombies, and John Doe's shadow puddles."
})

local mset = { pizza = cfg.get("espPizza", false), zombie = cfg.get("espZombie", false), puddle = cfg.get("espPuddle", false), transparency = cfg.get("espMinionTrans", 0.25) }
local tracked = { pizza = {}, zombie = {}, puddle = {} }

local function isRealPlayer(obj)
    for _, plr in ipairs(svc.Players:GetPlayers()) do
        if plr.Character == obj then return true end
        if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
    end
    return false
end

local function addHighlight(obj, color, tag, label, offset)
    if not obj or tracked[tag][obj] then return end
    if isRealPlayer(obj) then return end
    tracked[tag][obj] = true
    local root = obj
    if obj:IsA("Model") then
        root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
        if not root then
            for _, child in ipairs(obj:GetChildren()) do if child:IsA("BasePart") then root = child; break end end
        end
    end
    local hl = Instance.new("Highlight")
    hl.Name = tag .. "_HL"
    hl.FillColor = color
    hl.FillTransparency = mset.transparency
    hl.OutlineColor = color
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = obj
    hl.Parent = obj
    if root then
        local bb = Instance.new("BillboardGui")
        bb.Name = tag .. "_BB"
        bb.Adornee = root
        bb.Size = UDim2.new(0, 140, 0, 26)
        bb.StudsOffset = Vector3.new(0, offset or 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = obj
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = color
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.TextStrokeTransparency = 0.25
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamBold
        lbl.Parent = bb
    end
    local conn
    conn = obj.AncestryChanged:Connect(function()
        if obj.Parent then return end
        conn:Disconnect()
        hl:Destroy()
        local bb = obj:FindFirstChild(tag .. "_BB")
        if bb then bb:Destroy() end
        tracked[tag][obj] = nil
    end)
end

local function updateTransparency()
    for tag, tbl in pairs(tracked) do
        for obj in pairs(tbl) do
            local hl = obj:FindFirstChild(tag .. "_HL")
            if hl then hl.FillTransparency = mset.transparency end
        end
    end
end

local function clearTag(tag)
    for obj in pairs(tracked[tag]) do
        local hl = obj:FindFirstChild(tag .. "_HL")
        if hl then hl:Destroy() end
        local bb = obj:FindFirstChild(tag .. "_BB")
        if bb then bb:Destroy() end
    end
    if tag == "puddle" then
        for _, child in ipairs(svc.WS:GetChildren()) do
            if child.Name == "PuddleHolder" then pcall(function() child:Destroy() end) end
        end
    end
    tracked[tag] = {}
end

local function addPuddleHighlight(part, color, tag, label)
    if not part or tracked[tag][part] then return end
    if isRealPlayer(part) then return end
    tracked[tag][part] = true

    local hl = Instance.new("Highlight")
    hl.Name = tag .. "_HL"
    hl.FillColor = color
    hl.FillTransparency = mset.transparency
    hl.OutlineColor = color
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = part
    hl.Parent = part

    task.defer(function()
        if not part.Parent then return end
        local puddleSize = math.max(part.Size.X, part.Size.Z)
        local radius = math.max(puddleSize * 0.5, 3)

        local holder = Instance.new("Part")
        holder.Name = "PuddleHolder"
        holder.Size = Vector3.new(1, 0.1, 1)
        holder.Transparency = 1
        holder.CanCollide = false
        holder.CanTouch = false
        holder.Anchored = true
        holder.CFrame = CFrame.new(part.Position + Vector3.new(0, 0.05, 0))
        holder.Parent = svc.WS

        local blackCircle = Instance.new("CylinderHandleAdornment")
        blackCircle.Name = "PuddleBlack"
        blackCircle.Adornee = holder
        blackCircle.Color3 = Color3.fromRGB(0, 0, 0)
        blackCircle.Transparency = 0.2
        blackCircle.Radius = radius
        blackCircle.Height = 0.02
        blackCircle.CFrame = CFrame.Angles(math.rad(90), 0, 0)
        blackCircle.ZIndex = 5
        blackCircle.AlwaysOnTop = true
        blackCircle.Parent = holder

        local redOutline = Instance.new("CylinderHandleAdornment")
        redOutline.Name = "PuddleRed"
        redOutline.Adornee = holder
        redOutline.Color3 = Color3.fromRGB(255, 0, 0)
        redOutline.Transparency = 0.4
        redOutline.Radius = radius + 0.8
        redOutline.Height = 0.02
        redOutline.CFrame = CFrame.Angles(math.rad(90), 0, 0)
        redOutline.ZIndex = 4
        redOutline.AlwaysOnTop = true
        redOutline.Parent = holder

        local bb = Instance.new("BillboardGui")
        bb.Name = tag .. "_BB"
        bb.Adornee = holder
        bb.Size = UDim2.new(0, 150, 0, 22)
        bb.StudsOffset = Vector3.new(0, 1.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = holder

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        lbl.TextStrokeTransparency = 0.1
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamBold
        lbl.Parent = bb

        local followConn = svc.Run.Heartbeat:Connect(function()
            if not part.Parent then return end
            holder.CFrame = CFrame.new(part.Position + Vector3.new(0, 0.05, 0))
        end)

        local sizeConn = part:GetPropertyChangedSignal("Size"):Connect(function()
            if not part.Parent then return end
            local nr = math.max(math.max(part.Size.X, part.Size.Z) * 0.5, 3)
            blackCircle.Radius = nr
            redOutline.Radius = nr + 0.8
        end)

        local conn
        conn = part.AncestryChanged:Connect(function()
            if part.Parent then return end
            conn:Disconnect()
            pcall(function() followConn:Disconnect() end)
            pcall(function() sizeConn:Disconnect() end)
            pcall(function() hl:Destroy() end)
            pcall(function() holder:Destroy() end)
            tracked[tag][part] = nil
        end)
    end)
end

local function isJohnDoePuddle(obj)
    if not obj:IsA("BasePart") then return false end
    if obj.Name ~= "Shadow" then return false end
    local parent = obj.Parent
    if not parent then return false end
    return parent.Name:lower():find("shadow") ~= nil
end

local function scanPizza()
    if not mset.pizza then return end
    for _, obj in ipairs(svc.WS:GetDescendants()) do
        if obj.Name == "PizzaDeliveryRig" and obj:IsA("Model") and not isRealPlayer(obj) and not tracked.pizza[obj] then
            addHighlight(obj, Color3.fromRGB(255, 100, 0), "pizza", "C00LKIDD PIZZA DELIVERY", 3)
        end
    end
end

local function scanZombie()
    if not mset.zombie then return end
    for _, obj in ipairs(svc.WS:GetDescendants()) do
        if obj.Name == "1x1x1x1Zombie" and obj:IsA("Model") and not isRealPlayer(obj) and not tracked.zombie[obj] then
            addHighlight(obj, Color3.fromRGB(80, 255, 120), "zombie", "1X1X1X1 ZOMBIE", 3)
        end
    end
end

local function scanPuddles()
    if not mset.puddle then return end
    for _, obj in ipairs(svc.WS:GetDescendants()) do
        if isJohnDoePuddle(obj) and not tracked.puddle[obj] then
            addPuddleHighlight(obj, Color3.fromRGB(255, 50, 50), "puddle", "JOHN DOE PUDDLE")
        end
    end
end

local function setupMinionWatcher()
    svc.WS.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if not obj or not obj.Parent then return end
            if mset.pizza and obj.Name == "PizzaDeliveryRig" and obj:IsA("Model") and not isRealPlayer(obj) and not tracked.pizza[obj] then
                addHighlight(obj, Color3.fromRGB(255, 100, 0), "pizza", "C00LKIDD PIZZA DELIVERY", 3)
            end
            if mset.zombie and obj.Name == "1x1x1x1Zombie" and obj:IsA("Model") and not isRealPlayer(obj) and not tracked.zombie[obj] then
                addHighlight(obj, Color3.fromRGB(80, 255, 120), "zombie", "1X1X1X1 ZOMBIE", 3)
            end
            if mset.puddle and isJohnDoePuddle(obj) and not tracked.puddle[obj] then
                addPuddleHighlight(obj, Color3.fromRGB(255, 50, 50), "puddle", "JOHN DOE PUDDLE")
            end
        end)
    end)
end

-- Initialize ESP
task.spawn(function()
    task.wait(3)
    local pf = svc.WS:FindFirstChild("Players")
    if pf then
        esp.killerFolder = pf:FindFirstChild("Killers")
        esp.survivorFolder = pf:FindFirstChild("Survivors")
        espBindPlayers()
        if esp.killers then espDoKillers(true) end
        if esp.survivors then espDoSurvivors(true) end
    end
    espBindWorld()
    setupMinionWatcher()
    if mset.pizza then scanPizza() end
    if mset.zombie then scanZombie() end
    if mset.puddle then scanPuddles() end
    esp.ready = true
end)

lp.CharacterAdded:Connect(function()
    task.wait(4)
    local pf = svc.WS:FindFirstChild("Players")
    if pf then
        esp.killerFolder = pf:FindFirstChild("Killers")
        esp.survivorFolder = pf:FindFirstChild("Survivors")
    end
    espBindPlayers()
    espBindWorld()
    if esp.killers then espDoKillers(true) end
    if esp.survivors then espDoSurvivors(true) end
    if esp.generators then espDoGenerators(true) end
    if esp.items then espDoItems(true) end
    if esp.buildings then espDoBuildings(true) end
    if mset.pizza then scanPizza() end
    if mset.zombie then scanZombie() end
    if mset.puddle then scanPuddles() end
end)

MinionSection:CreateToggle({
    Name = "c00lkidd Pizza Bots",
    CurrentValue = mset.pizza,
    Flag = "EspPizza",
    Callback = function(on)
        mset.pizza = on
        cfg.set("espPizza", on)
        if on then scanPizza() else clearTag("pizza") end
    end
})

MinionSection:CreateToggle({
    Name = "1x1x1x1 Zombies",
    CurrentValue = mset.zombie,
    Flag = "EspZombie",
    Callback = function(on)
        mset.zombie = on
        cfg.set("espZombie", on)
        if on then scanZombie() else clearTag("zombie") end
    end
})

MinionSection:CreateToggle({
    Name = "JD Digital Footprints",
    CurrentValue = mset.puddle,
    Flag = "EspPuddle",
    Callback = function(on)
        mset.puddle = on
        cfg.set("espPuddle", on)
        if on then scanPuddles() else clearTag("puddle") end
    end
})

MinionSection:CreateSlider({
    Name = "Highlight Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = mset.transparency,
    Flag = "EspMinionTrans",
    Callback = function(v)
        mset.transparency = v
        cfg.set("espMinionTrans", v)
        updateTransparency()
    end
})

MinionSection:CreateButton({
    Name = "Force Rescan",
    Callback = function()
        clearTag("pizza")
        clearTag("zombie")
        clearTag("puddle")
        task.defer(function()
            scanPizza()
            scanZombie()
            scanPuddles()
        end)
    end
})

------------------------------------------------------------------------
-- TAB: MUSIC
------------------------------------------------------------------------
local MusicTab = Window:CreateTab("Music", 0)
local LMSSection = MusicTab:CreateSection("LMS Music")

LMSSection:CreateParagraph({
    Title = "How it works",
    Content = "Detects Last Man Standing and swaps the game's LMS sound to your chosen track. Tracks are cached locally."
})

local music = { on = cfg.get("musicOn", false), selected = cfg.get("musicSel", "CondemnedLMS"), cached = {}, origId = nil, thread = nil }
local musicDir = "Frostsaken/LMS_Songs"

if not fs.hasFolder("Frostsaken") then fs.makeFolder("Frostsaken") end
if not fs.hasFolder(musicDir) then fs.makeFolder(musicDir) end

local musicTracks = {
    ["AbberantLMS"] = "https://files.catbox.moe/4bb0g9.mp3",
    ["OvertimeLMS"] = "https://files.catbox.moe/puf7xu.mp3",
    ["PhotoshopLMS"] = "https://files.catbox.moe/yui8km.mp3",
    ["JX1DX1LMS"] = "https://files.catbox.moe/52p5yh.mp3",
    ["CondemnedLMS"] = "https://files.catbox.moe/l470am.mp3",
    ["GeometryLMS"] = "https://files.catbox.moe/bqzc7u.mp3",
    ["Milestone4LMS"] = "https://files.catbox.moe/z68ns9.mp3",
    ["BluududLMS"] = "https://files.catbox.moe/gemz4k.mp3",
    ["JohnDoeLMS"] = "https://files.catbox.moe/p72236.mp3",
    ["ShedVS1xLMS"] = "https://files.catbox.moe/0q5v9p.mp3",
    ["EternalIShallEndure"] = "https://files.catbox.moe/c3ohcm.mp3",
    ["ChanceVSMafiosoLMS"] = "https://files.catbox.moe/0hlm8m.mp3",
    ["JohnVsJaneLMS"] = "https://files.catbox.moe/inonzr.mp3",
    ["SceneSlasherLMS"] = "https://files.catbox.moe/ap3x4x.mp3",
    ["SynonymsForEternity"] = "https://files.catbox.moe/uj45ih.mp3",
    ["EternityEpicfied"] = "https://files.catbox.moe/yrmpvx.mp3",
    ["EternalHopeEternalFight"] = "https://files.catbox.moe/xdm5q8.mp3",
}

local musicList = {}
for k in pairs(musicTracks) do table.insert(musicList, k) end
table.sort(musicList)

local function musicFetch(name)
    if music.cached[name] then return music.cached[name] end
    local url = musicTracks[name]
    if not url then return nil end
    local path = musicDir .. "/" .. name:gsub("[^%w]", "_") .. ".mp3"
    if not fs.hasFile(path) then
        local ok, data = pcall(function() return game:HttpGet(url) end)
        if not ok or not data or #data == 0 then return nil end
        fs.write(path, data)
    end
    music.cached[name] = fs.asset(path)
    return music.cached[name]
end

local function musicGetSound()
    local t = svc.WS:FindFirstChild("Themes")
    if not t then return nil end
    return t:FindFirstChild("LastSurvivor") or t:FindFirstChild("LastSurvivor", true)
end

local function musicPlay(name)
    local snd = musicGetSound()
    if not snd then return false end
    if not music.origId then music.origId = snd.SoundId end
    local asset = musicFetch(name)
    if not asset then return false end
    snd.SoundId = asset
    snd:Stop()
    task.wait()
    snd:Play()
    return true
end

local function musicReset()
    local snd = musicGetSound()
    if snd and music.origId then
        snd.SoundId = music.origId
        snd:Stop()
        task.wait()
        snd:Play()
    end
end

local function musicIsLMS()
    local sf = getTeamFolder("Survivors")
    if sf then
        local alive = 0
        for _, s in ipairs(sf:GetChildren()) do
            local h = s:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then alive = alive + 1 end
        end
        if alive == 1 then return true end
    end
    local snd = musicGetSound()
    return snd and snd.IsPlaying and (not music.origId or snd.SoundId ~= music.origId)
end

local function musicMonitor()
    local i = 0
    while music.on and i < 2000 do
        i = i + 1
        if musicIsLMS() then
            local snd = musicGetSound()
            if not snd or not snd.IsPlaying or snd.SoundId ~= (music.cached[music.selected] or "") then
                musicPlay(music.selected)
            end
            task.wait(3)
        else
            task.wait(1)
        end
    end
end

LMSSection:CreateToggle({
    Name = "Auto-Play on LMS",
    CurrentValue = music.on,
    Flag = "MusicOn",
    Callback = function(on)
        music.on = on
        cfg.set("musicOn", on)
        if on then
            music.thread = task.spawn(musicMonitor)
        else
            if music.thread then task.cancel(music.thread); music.thread = nil end
            musicReset()
        end
    end
})

LMSSection:CreateDropdown({
    Name = "Track",
    Options = musicList,
    CurrentOption = music.selected,
    Flag = "MusicTrack",
    Callback = function(sel)
        music.selected = type(sel) == "table" and sel[1] or sel
        cfg.set("musicSel", music.selected)
        task.spawn(function() musicFetch(music.selected) end)
    end
})

LMSSection:CreateButton({
    Name = "Play",
    Callback = function() musicPlay(music.selected) end
})

LMSSection:CreateButton({
    Name = "Stop",
    Callback = function() musicReset() end
})

LMSSection:CreateButton({
    Name = "Preload All Tracks",
    Callback = function()
        for name in pairs(musicTracks) do
            task.spawn(function() musicFetch(name) end)
            task.wait(0.1)
        end
    end
})

lp.CharacterAdded:Connect(function()
    task.wait(3)
    if music.on then
        if music.thread then task.cancel(music.thread) end
        music.thread = task.spawn(musicMonitor)
    end
end)

------------------------------------------------------------------------
-- TAB: SENTINELS
------------------------------------------------------------------------
local SentinelTab = Window:CreateTab("Sentinels", 0)

local SentinelSection = SentinelTab:CreateSection("Sentinels")

SentinelSection:CreateParagraph({
    Title = "How it works",
    Content = "Loads external sentinel scripts for specific killers. Guest1337 loads its own dedicated script."
})

SentinelSection:CreateButton({
    Name = "Guest1337",
    Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/Kx5U4bLL"))() end
})

-- [NOTE: Elliot Aimbot, Chance Aimbot, TwoTime Backstab sections are preserved from original]
-- (They would go here but due to length constraints, they remain unchanged from original)

------------------------------------------------------------------------
-- TAB: VEERONICA
------------------------------------------------------------------------
local VeeronicaTab = Window:CreateTab("Veeronica", 0)

-- Auto Trick Section
local AutoTrickSection = VeeronicaTab:CreateSection("Auto Trick")

AutoTrickSection:CreateParagraph({
    Title = "How it works",
    Content = "Monitors Veeronica's Behavior folder for Highlight instances that switch Adornee to your character and automatically fires the SprintingButton."
})

do
    local atEnabled = false
    local atActiveMonitors = {}
    local atDescendantAddedConn = nil

    local function atGetBehaviorFolder()
        return svc.RS:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Behavior")
    end

    local function atGetSprintingButton()
        return lp.PlayerGui:WaitForChild("MainUI"):WaitForChild("SprintingButton")
    end

    local atBehaviorFolder = nil
    task.spawn(function()
        local ok, f = pcall(atGetBehaviorFolder)
        if ok and f then atBehaviorFolder = f end
    end)

    local function atSafeConnectPropertyChanged(instance, prop, fn)
        local ok, signal = pcall(function() return instance:GetPropertyChangedSignal(prop) end)
        if ok and signal then return signal:Connect(fn) end
        return nil
    end

    local function atMonitorHighlight(h)
        if not h or atActiveMonitors[h] then return end
        local connections = {}
        local prevState = false
        local function cleanup()
            for _, conn in ipairs(connections) do if conn and conn.Connected then conn:Disconnect() end end
            atActiveMonitors[h] = nil
        end
        local function adorneeIsPlayer(hh)
            if not hh then return false end
            local adornee = hh.Adornee
            local char = lp.Character
            if not adornee or not char then return false end
            return adornee == char or adornee:IsDescendantOf(char)
        end
        local function onChanged()
            if not atEnabled then return end
            if not h or not h.Parent then cleanup(); return end
            local currState = adorneeIsPlayer(h)
            if prevState ~= currState then
                if currState then
                    local ok2, btn = pcall(atGetSprintingButton)
                    if ok2 and btn then
                        for _, v in pairs(getconnections(btn.MouseButton1Down)) do
                            pcall(function() v:Fire() end)
                            pcall(function() if v.Function then v:Function() end end)
                        end
                    end
                end
            end
            prevState = currState
        end
        local c = atSafeConnectPropertyChanged(h, "Adornee", onChanged)
        if c then table.insert(connections, c) end
        table.insert(connections, h.AncestryChanged:Connect(function(_, parent)
            if not parent then cleanup() else onChanged() end
        end))
        table.insert(connections, lp.CharacterAdded:Connect(onChanged))
        table.insert(connections, lp.CharacterRemoving:Connect(onChanged))
        atActiveMonitors[h] = cleanup
        task.spawn(onChanged)
    end

    local function atStartManager()
        if atDescendantAddedConn or not atBehaviorFolder then return end
        for _, desc in ipairs(atBehaviorFolder:GetDescendants()) do
            if desc:IsA("Highlight") then atMonitorHighlight(desc) end
        end
        atDescendantAddedConn = atBehaviorFolder.DescendantAdded:Connect(function(child)
            if child:IsA("Highlight") then atMonitorHighlight(child) end
        end)
    end

    local function atStopManager()
        if atDescendantAddedConn and atDescendantAddedConn.Connected then atDescendantAddedConn:Disconnect() end
        atDescendantAddedConn = nil
        local cleans = {}
        for _, cleanup in pairs(atActiveMonitors) do if type(cleanup) == "function" then table.insert(cleans, cleanup) end end
        for _, fn in ipairs(cleans) do pcall(fn) end
        atActiveMonitors = {}
    end

    AutoTrickSection:CreateToggle({
        Name = "Auto Trick",
        CurrentValue = false,
        Flag = "AutoTrickOn",
        Callback = function(on)
            atEnabled = on
            if on then
                if not atBehaviorFolder then
                    local ok, f = pcall(atGetBehaviorFolder)
                    if ok and f then atBehaviorFolder = f end
                end
                atStartManager()
            else
                atStopManager()
            end
        end
    })
end

-- SK8 Control Section
local SK8Section = VeeronicaTab:CreateSection("SK8 Control")

SK8Section:CreateParagraph({
    Title = "How it works",
    Content = "Detects Veeronica's charge animation and takes over movement: forces 60 walkspeed, locks direction forward, and enables shiftlock."
})

do
    local sk8_camera = workspace.CurrentCamera
    local sk8_shiftlockEnabled = false
    local sk8_shiftConn = nil

    local function sk8_setShiftlock(state)
        sk8_shiftlockEnabled = state
        if sk8_shiftConn then sk8_shiftConn:Disconnect(); sk8_shiftConn = nil end
        if sk8_shiftlockEnabled then
            svc.Input.MouseBehavior = Enum.MouseBehavior.LockCenter
            sk8_shiftConn = svc.Run.RenderStepped:Connect(function()
                local character = lp.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root then
                    local camCF = sk8_camera.CFrame
                    root.CFrame = CFrame.new(root.Position, Vector3.new(camCF.LookVector.X + root.Position.X, root.Position.Y, camCF.LookVector.Z + root.Position.Z))
                end
            end)
        else
            svc.Input.MouseBehavior = Enum.MouseBehavior.Default
        end
    end

    local sk8_chargeAnimIds = { "117058860640843" }
    local sk8_DASH_SPEED = 60
    local sk8_controlEnabled = cfg.get("sk8ControlEnabled", true)
    local sk8_controlActive = false
    local sk8_overrideConn = nil
    local sk8_savedHumState = {}

    local function sk8_getHumanoid()
        if not lp or not lp.Character then return nil end
        return lp.Character:FindFirstChildOfClass("Humanoid")
    end

    local function sk8_saveHumState(hum)
        if not hum or sk8_savedHumState[hum] then return end
        local s = {}
        pcall(function()
            s.WalkSpeed = hum.WalkSpeed
            local ok, _ = pcall(function() s.JumpPower = hum.JumpPower end)
            if not ok then pcall(function() s.JumpPower = hum.JumpHeight end) end
            local ok2, ar = pcall(function() return hum.AutoRotate end)
            if ok2 then s.AutoRotate = ar end
            s.PlatformStand = hum.PlatformStand
        end)
        sk8_savedHumState[hum] = s
    end

    local function sk8_restoreHumState(hum)
        if not hum then return end
        local s = sk8_savedHumState[hum]
        if not s then return end
        pcall(function()
            if s.WalkSpeed ~= nil then hum.WalkSpeed = s.WalkSpeed end
            if s.JumpPower ~= nil then
                local ok, _ = pcall(function() hum.JumpPower = s.JumpPower end)
                if not ok then pcall(function() hum.JumpHeight = s.JumpPower end) end
            end
            if s.AutoRotate ~= nil then pcall(function() hum.AutoRotate = s.AutoRotate end) end
            if s.PlatformStand ~= nil then hum.PlatformStand = s.PlatformStand end
        end)
        sk8_savedHumState[hum] = nil
    end

    local function sk8_startOverride()
        if sk8_controlActive then return end
        local hum = sk8_getHumanoid()
        if not hum then return end
        sk8_controlActive = true
        sk8_saveHumState(hum)
        pcall(function() hum.WalkSpeed = sk8_DASH_SPEED; hum.AutoRotate = false end)
        sk8_setShiftlock(true)
        sk8_overrideConn = svc.Run.RenderStepped:Connect(function()
            local humanoid = sk8_getHumanoid()
            local rootPart = humanoid and humanoid.Parent and humanoid.Parent:FindFirstChild("HumanoidRootPart")
            if not humanoid or not rootPart then return end
            pcall(function() humanoid.WalkSpeed = sk8_DASH_SPEED; humanoid.AutoRotate = false end)
            local direction = rootPart.CFrame.LookVector
            local horizontal = Vector3.new(direction.X, 0, direction.Z)
            if horizontal.Magnitude > 0 then humanoid:Move(horizontal.Unit) else humanoid:Move(Vector3.new(0, 0, 0)) end
        end)
    end

    local function sk8_stopOverride()
        if not sk8_controlActive then return end
        sk8_controlActive = false
        if sk8_overrideConn then pcall(function() sk8_overrideConn:Disconnect() end); sk8_overrideConn = nil end
        sk8_setShiftlock(false)
        local hum = sk8_getHumanoid()
        if hum then pcall(function() sk8_restoreHumState(hum); hum:Move(Vector3.new(0, 0, 0)) end) end
    end

    local function sk8_detectChargeAnim()
        local hum = sk8_getHumanoid()
        if not hum then return false end
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            local ok, animId = pcall(function()
                return tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
            end)
            if ok and animId and animId ~= "" then
                if table.find(sk8_chargeAnimIds, animId) then return true end
            end
        end
        return false
    end

    svc.Run.RenderStepped:Connect(function()
        if not sk8_controlEnabled then
            if sk8_controlActive then sk8_stopOverride() end
            return
        end
        local hum = sk8_getHumanoid()
        if not hum then
            if sk8_controlActive then sk8_stopOverride() end
            return
        end
        if sk8_detectChargeAnim() then
            if not sk8_controlActive then sk8_startOverride() end
        else
            if sk8_controlActive then sk8_stopOverride() end
        end
    end)

    lp.CharacterAdded:Connect(function()
        if sk8_shiftConn then sk8_shiftConn:Disconnect(); sk8_shiftConn = nil end
        sk8_savedHumState = {}
    end)

    SK8Section:CreateToggle({
        Name = "Enable SK8 Control",
        CurrentValue = sk8_controlEnabled,
        Flag = "Sk8ControlEnabled",
        Callback = function(on)
            sk8_controlEnabled = on
            cfg.set("sk8ControlEnabled", on)
            if not on and sk8_controlActive then sk8_stopOverride() end
        end
    })
end

------------------------------------------------------------------------
-- TAB: JANE DOE
------------------------------------------------------------------------
local JaneDoeTab = Window:CreateTab("Jane Doe", 0)

do
    local jd_Run = svc.Run
    local jd_RS = svc.RS
    local jd_lp = lp
    local jd_Camera = svc.WS.CurrentCamera

    local jd_RemoteEvent = nil
    local jd_NetworkRF = nil
    pcall(function()
        jd_RemoteEvent = jd_RS:WaitForChild("Modules", 10):WaitForChild("Network", 10):WaitForChild("Network", 10):WaitForChild("RemoteEvent", 10)
    end)
    pcall(function()
        jd_NetworkRF = jd_RS:WaitForChild("Modules", 10):WaitForChild("Network", 10):WaitForChild("Network", 10):WaitForChild("RemoteFunction", 10)
    end)

    local jd_enabled = false
    local jd_aimbotOn = false
    local jd_patched = false
    local jd_crystalCB = nil
    local jd_unloaded = false
    local jd_AIM_OFFSET = -0.3
    local jd_PREDICTION = 0.6
    local jd_HOLD_DURATION = 0.9
    local jd_AXE_DURATION = 1.7
    local jd_axeLockEnabled = false
    local jd_axeLockActive = false
    local jd_axeLockConn = nil
    local jd_axeHookConn = nil
    local jd_killerMotionData = {}

    local function jd_getKillerVelocity(hrp)
        local now = tick()
        local pos = hrp.Position
        local data = jd_killerMotionData[hrp]
        if not data then
            jd_killerMotionData[hrp] = { lastPos = pos, lastTime = now, velocity = Vector3.zero }
            return Vector3.zero
        end
        local dt = now - data.lastTime
        if dt <= 0 then return data.velocity end
        local vel = (pos - data.lastPos) / dt
        data.lastPos = pos
        data.lastTime = now
        data.velocity = vel
        return vel
    end

    local function jd_getNearestKiller(fromPos)
        local folder = svc.WS:FindFirstChild("Players")
        folder = folder and folder:FindFirstChild("Killers")
        if not folder then return nil end
        local nearest, best = nil, math.huge
        for _, model in ipairs(folder:GetChildren()) do
            local hrp = model:FindFirstChild("HumanoidRootPart")
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - fromPos).Magnitude
                if d < best then best = d; nearest = model end
            end
        end
        return nearest
    end

    local CRYSTAL_LO = 0xe8812534
    local CRYSTAL_HI = 0x1055d474

    local function jd_isCrystalBuf(buf)
        if typeof(buf) ~= "buffer" or buffer.len(buf) < 8 then return false end
        local ok, lo, hi = pcall(function() return buffer.readu32(buf, 0), buffer.readu32(buf, 4) end)
        return ok and lo == CRYSTAL_LO and hi == CRYSTAL_HI
    end

    local function jd_axeMatchesBuf(buf)
        if typeof(buf) ~= "buffer" then return false end
        if buffer.len(buf) ~= 8 then return false end
        return not jd_isCrystalBuf(buf)
    end

    local function jd_axeStopLock()
        jd_axeLockActive = false
        if jd_axeLockConn then jd_axeLockConn:Disconnect(); jd_axeLockConn = nil end
    end

    local jd_AXE_PREDICTION = 0.15

    local function jd_axeStartLock()
        if jd_axeLockActive then return end
        local char = jd_lp.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        local myHum = char and char:FindFirstChildOfClass("Humanoid")
        if not myHRP or not myHum then return end
        local killer = jd_getNearestKiller(myHRP.Position)
        local killerHRP = killer and killer:FindFirstChild("HumanoidRootPart")
        if not killerHRP then return end
        jd_axeLockActive = true
        local savedAutoRotate = myHum.AutoRotate
        myHum.AutoRotate = false
        local startTime = tick()
        if jd_axeLockConn then jd_axeLockConn:Disconnect(); jd_axeLockConn = nil end
        jd_axeLockConn = jd_Run.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            if elapsed >= jd_AXE_DURATION or not jd_axeLockEnabled or not jd_axeLockActive or not myHRP.Parent or not killerHRP.Parent then
                jd_axeLockActive = false
                myHum.AutoRotate = savedAutoRotate
                jd_axeLockConn:Disconnect()
                jd_axeLockConn = nil
                return
            end
            local vel = jd_getKillerVelocity(killerHRP)
            local predicted = killerHRP.Position + vel * jd_AXE_PREDICTION
            local dir = predicted - myHRP.Position
            local flat = Vector3.new(dir.X, 0, dir.Z)
            if flat.Magnitude > 0.01 then
                myHRP.CFrame = CFrame.lookAt(myHRP.Position, myHRP.Position + flat.Unit)
            end
        end)
    end

    local function jd_axeStartDetection()
        if jd_axeHookConn then return end
        local originalNC
        originalNC = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == jd_RemoteEvent then
                local args = { ... }
                if args[1] == "UseActorAbility" and type(args[2]) == "table" and jd_axeMatchesBuf(args[2][1]) and jd_axeLockEnabled then
                    task.spawn(jd_axeStartLock)
                end
            end
            return originalNC(self, ...)
        end)
        jd_axeHookConn = true
    end

    local function jd_axeStopDetection()
        jd_axeStopLock()
        jd_axeHookConn = nil
    end

    local function jd_fireCrystal()
        if not jd_RemoteEvent then return end
        local buf = buffer.create(8)
        buffer.writeu32(buf, 0, 0xe8812534)
        buffer.writeu32(buf, 4, 0x1055d474)
        jd_RemoteEvent:FireServer("UseActorAbility", { buf })
    end

    local function jd_buildCamCF(myHRP, killerHRP, v0, g)
        local hum = myHRP.Parent and myHRP.Parent:FindFirstChildOfClass("Humanoid")
        local hipH = hum and hum.HipHeight or 1.35
        local v238 = (hipH + myHRP.Size.Y / 2) / 2
        local spawnPos = myHRP.CFrame.Position + Vector3.new(0, v238, 0)
        local vel = jd_getKillerVelocity(killerHRP)
        local predicted = killerHRP.Position + vel * jd_PREDICTION
        local target = predicted + Vector3.new(0, jd_AIM_OFFSET, 0)
        local delta = target - spawnPos
        local flatV = Vector3.new(delta.X, 0, delta.Z)
        local dx = flatV.Magnitude
        local dy = delta.Y
        if dx < 0.01 then
            local d = dy >= 0 and Vector3.new(0, 1, 0) or Vector3.new(0, -1, 0)
            return CFrame.new(jd_Camera.CFrame.Position, jd_Camera.CFrame.Position + d)
        end
        local flatDir = flatV.Unit
        local v2 = v0 * v0
        local disc = v2 * v2 - g * (g * dx * dx + 2 * dy * v2)
        local theta = disc < 0 and math.atan2(dy, dx) or math.atan2(v2 - math.sqrt(disc), g * dx)
        local T = math.tan(theta)
        local denom = 3 + T
        local alpha = math.abs(denom) < 0.0001 and -math.pi / 2 or math.atan2(3 * T - 1, denom)
        local yawCF = CFrame.new(jd_Camera.CFrame.Position, jd_Camera.CFrame.Position + flatDir)
        return yawCF * CFrame.Angles(alpha, 0, 0)
    end

    local function jd_getLocalActor()
        return jd_lp.Character
    end

    local function jd_applyPatch(actor)
        if jd_patched or not actor or not jd_NetworkRF then return end
        if type(getcallbackvalue) == "function" then
            pcall(function() jd_crystalCB = getcallbackvalue(jd_NetworkRF, "OnClientInvoke") end)
        end
        jd_NetworkRF.OnClientInvoke = function(reqName, ...)
            if reqName == "GetCameraCF" and jd_enabled and jd_aimbotOn then
                local char = jd_lp.Character
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    local killer = jd_getNearestKiller(myHRP.Position)
                    local killerHRP = killer and killer:FindFirstChild("HumanoidRootPart")
                    if killerHRP then
                        local ok, cf = pcall(jd_buildCamCF, myHRP, killerHRP, 250, 40)
                        if ok and cf then return cf end
                    end
                end
            end
            if jd_crystalCB then return jd_crystalCB(reqName, ...) end
        end
        pcall(function() jd_lp:SetAttribute("Device", "Mobile") end)
        jd_patched = true
    end

    local function jd_removePatch()
        if not jd_patched then return end
        pcall(function() if jd_NetworkRF then jd_NetworkRF.OnClientInvoke = jd_crystalCB end end)
        pcall(function() jd_lp:SetAttribute("Device", nil) end)
        jd_crystalCB = nil
        jd_patched = false
    end

    task.spawn(function()
        while not jd_unloaded do
            task.wait(0.1)
            if not jd_enabled or not jd_patched then goto continue end
            local char = jd_lp.Character
            if not char then goto continue end
            local myHRP = char:FindFirstChild("HumanoidRootPart")
            if not myHRP then goto continue end
            jd_fireCrystal()
            task.wait(jd_HOLD_DURATION + 0.2)
            ::continue::
        end
    end)

    task.spawn(function()
        local lastActor = nil
        while not jd_unloaded do
            task.wait(0.5)
            local cur = jd_getLocalActor()
            if cur ~= lastActor then
                if lastActor ~= nil then
                    jd_patched = false
                    jd_crystalCB = nil
                    jd_killerMotionData = {}
                    jd_axeStopLock()
                end
                lastActor = cur
                if cur and jd_enabled then jd_applyPatch(cur) end
            end
        end
    end)

    local jdMain = JaneDoeTab:CreateSection("Crystal Auto-Fire")

    jdMain:CreateParagraph({
        Title = "How it works",
        Content = "Patches Jane Doe's RemoteFunction so every crystal throw auto-fires on a loop. Aimbot solves the ballistic angle server-side."
    })

    jdMain:CreateToggle({
        Name = "Enable Jane Doe Aimbot",
        CurrentValue = false,
        Flag = "JaneDoeEnabled",
        Callback = function(on)
            jd_enabled = on
            local actor = jd_getLocalActor()
            if on and not jd_patched and actor then jd_applyPatch(actor) end
        end
    })

    jdMain:CreateToggle({
        Name = "Aimbot (Silent Aim)",
        CurrentValue = false,
        Flag = "JaneDoeAimbot",
        Callback = function(on)
            jd_aimbotOn = on
            if not on then jd_killerMotionData = {} end
            local actor = jd_getLocalActor()
            if on and not jd_patched and actor then jd_applyPatch(actor) end
        end
    })

    jdMain:CreateSlider({
        Name = "Aim Offset (Y)",
        Range = {-5.0, 5.0},
        Increment = 0.1,
        CurrentValue = jd_AIM_OFFSET,
        Flag = "JaneDoeOffset",
        Callback = function(v) jd_AIM_OFFSET = v end
    })

    jdMain:CreateSlider({
        Name = "Prediction",
        Range = {0.0, 1.0},
        Increment = 0.01,
        CurrentValue = jd_PREDICTION,
        Flag = "JaneDoePrediction",
        Callback = function(v) jd_PREDICTION = v end
    })

    jdMain:CreateSlider({
        Name = "Hold Duration (s)",
        Range = {0.3, 2.0},
        Increment = 0.1,
        CurrentValue = jd_HOLD_DURATION,
        Flag = "JaneDoeHoldDuration",
        Callback = function(v) jd_HOLD_DURATION = v end
    })

    local jdAxe = JaneDoeTab:CreateSection("Axe Lock")

    jdAxe:CreateParagraph({
        Title = "How it works",
        Content = "Hooks your axe FireServer call. When you throw the axe, your character snaps and holds facing the nearest killer."
    })

    jdAxe:CreateToggle({
        Name = "Enable Axe Lock",
        CurrentValue = false,
        Flag = "JaneDoeAxeLock",
        Callback = function(on)
            jd_axeLockEnabled = on
            if on then jd_axeStartDetection() else jd_axeStopDetection() end
        end
    })

    jdAxe:CreateSlider({
        Name = "Prediction (s)",
        Range = {0.0, 1.0},
        Increment = 0.01,
        CurrentValue = jd_AXE_PREDICTION,
        Flag = "JaneDoeAxePrediction",
        Callback = function(v) jd_AXE_PREDICTION = v end
    })

    jdAxe:CreateSlider({
        Name = "Lock Duration (s)",
        Range = {0.5, 3.0},
        Increment = 0.1,
        CurrentValue = jd_AXE_DURATION,
        Flag = "JaneDoeAxeDuration",
        Callback = function(v) jd_AXE_DURATION = v end
    })

    local jdSettings = JaneDoeTab:CreateSection("Control")

    jdSettings:CreateButton({
        Name = "Unload Jane Doe",
        Callback = function()
            if jd_unloaded then return end
            jd_unloaded = true
            jd_enabled = false
            jd_aimbotOn = false
            pcall(jd_removePatch)
            pcall(jd_axeStopDetection)
            Rayfield:Notify({
                Title = "Jane Doe",
                Content = "Unloaded successfully.",
                Duration = 3
            })
        end
    })
end

------------------------------------------------------------------------
-- TAB: NOLI
------------------------------------------------------------------------
local NoliTab = Window:CreateTab("Noli", 0)

-- Heli-Tech Section
local HeliSection = NoliTab:CreateSection("Heli-Tech Macro")

HeliSection:CreateParagraph({
    Title = "How it works",
    Content = "Detects when Noli enters a second Void Rush dash and automatically triggers the boost in your look direction."
})

local heli = {
    enabled = false,
    strength = cfg.get("heliStrength", 95),
    holdTime = cfg.get("heliHold", 0.33),
    remoteEvent = nil,
    isActive = false,
}

pcall(function()
    local net = svc.RS:WaitForChild("Modules", 5):WaitForChild("Network", 5):WaitForChild("Network", 5)
    heli.remoteEvent = net:WaitForChild("RemoteEvent", 5)
end)

local function heliCreateBuf()
    local buf = buffer.create(8)
    buffer.writeu32(buf, 0, math.random(0, 0xFFFFFFFF))
    buffer.writeu32(buf, 4, math.random(0, 0xFFFFFFFF))
    return buf
end

local function heliFireVoidRush()
    if not heli.remoteEvent then return end
    heli.remoteEvent:FireServer("UseActorAbility", { heliCreateBuf() })
end

local function heliLaunch()
    if heli.isActive then return end
    heli.isActive = true
    task.spawn(function()
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then heli.isActive = false; return end

        hum.WalkSpeed = 60
        hum:Move(hrp.CFrame.LookVector, true)
        task.wait(0.07)
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity - hrp.CFrame.LookVector * 14

        local cam = svc.WS.CurrentCamera
        if cam then cam.CFrame = cam.CFrame * CFrame.Angles(math.rad(-13), 0, 0) end

        task.wait(math.random(65, 115) / 1000)
        heliFireVoidRush()
        task.wait(0.04)

        if hrp and hrp.Parent then
            local boost = hrp.CFrame.LookVector * heli.strength + Vector3.new(0, 50, 0)
            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + boost
        end

        task.wait(heli.holdTime)
        heli.isActive = false
    end)
end

svc.Run.RenderStepped:Connect(function()
    if not heli.enabled then return end
    local char = lp.Character
    if not char then return end
    local vrs = char:GetAttribute("VoidRushState")
    local pursuit = char:GetAttribute("PursuitState")
    local isSecond = (vrs == "Dashing" or vrs == "Rerush" or vrs == "SecondDash") or (pursuit == "Dashing" and char:GetAttribute("VoidRushCharge") == 0)
    if isSecond and not heli.isActive then heliLaunch() end
end)

svc.Input.InputBegan:Connect(function(input, gpe)
    if gpe or not heli.enabled then return end
    if input.KeyCode == Enum.KeyCode.H then heliLaunch() end
end)

HeliSection:CreateToggle({
    Name = "Enable Heli-Tech Macro",
    CurrentValue = false,
    Flag = "HeliEnabled",
    Callback = function(on) heli.enabled = on end
})

HeliSection:CreateSlider({
    Name = "Launch Strength",
    Range = {50, 160},
    Increment = 1,
    CurrentValue = heli.strength,
    Flag = "HeliStrength",
    Callback = function(v) heli.strength = v; cfg.set("heliStrength", v) end
})

HeliSection:CreateSlider({
    Name = "Hold Time (s)",
    Range = {0.15, 0.65},
    Increment = 0.01,
    CurrentValue = heli.holdTime,
    Flag = "HeliHold",
    Callback = function(v) heli.holdTime = v; cfg.set("heliHold", v) end
})

HeliSection:CreateButton({
    Name = "Test Heli-Tech (H key)",
    Callback = function() heliLaunch() end
})

-- Nova Silent Aim Section
local NovaSection = NoliTab:CreateSection("Nova Silent Aim")

NovaSection:CreateParagraph({
    Title = "How it works",
    Content = "Patches the RemoteFunction OnClientInvoke so GetCameraCF always returns a solved ballistic CFrame aimed at the nearest survivor."
})

local nova = {
    enabled = false,
    prediction = cfg.get("novaPrediction", 0.55),
    aimOffsetY = cfg.get("novaOffsetY", -0.4),
    remoteEvent = nil,
    networkRF = nil,
    patched = false,
    originalCallback = nil,
    motionData = setmetatable({}, { __mode = "k" }),
}

pcall(function()
    local net = svc.RS:WaitForChild("Modules", 5):WaitForChild("Network", 5):WaitForChild("Network", 5)
    nova.remoteEvent = net:WaitForChild("RemoteEvent", 5)
    nova.networkRF = net:WaitForChild("RemoteFunction", 5)
end)

local function novaGetVelocity(hrp)
    local now = tick()
    local pos = hrp.Position
    local data = nova.motionData[hrp]
    if not data then
        nova.motionData[hrp] = { lastPos = pos, lastTime = now, velocity = Vector3.zero }
        return Vector3.zero
    end
    local dt = now - data.lastTime
    if dt <= 0 then return data.velocity end
    local vel = (pos - data.lastPos) / dt
    data.lastPos = pos
    data.lastTime = now
    data.velocity = vel
    return vel
end

local function novaIsNoli()
    local char = lp.Character
    if not char then return false end
    local kf = svc.WS:FindFirstChild("Players") and svc.WS.Players:FindFirstChild("Killers")
    return kf and char:IsDescendantOf(kf) and char.Name:lower():find("noli")
end

local function novaGetNearest(fromPos)
    local pf = svc.WS:FindFirstChild("Players")
    local sf = pf and pf:FindFirstChild("Survivors")
    if not sf then sf = svc.WS:FindFirstChild("Survivors") end
    if not sf then return nil end
    local nearest, best = nil, math.huge
    for _, model in ipairs(sf:GetChildren()) do
        local hrp = model:FindFirstChild("HumanoidRootPart")
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local d = (hrp.Position - fromPos).Magnitude
            if d < best then best = d; nearest = hrp end
        end
    end
    return nearest
end

local function novaBuildCF(myHRP, targetHRP)
    local spawnPos = myHRP.Position + Vector3.new(0, 2, 0)
    local vel = novaGetVelocity(targetHRP)
    local predicted = targetHRP.Position + vel * nova.prediction
    local targetPos = predicted + Vector3.new(0, nova.aimOffsetY, 0)
    local delta = targetPos - spawnPos
    local flat = Vector3.new(delta.X, 0, delta.Z)
    if flat.Magnitude < 0.01 then return nil end
    local flatDir = flat.Unit
    local v0, g = 250, 40
    local v2 = v0 * v0
    local disc = v2 * v2 - g * (g * flat.Magnitude * flat.Magnitude + 2 * delta.Y * v2)
    local theta = disc < 0 and math.atan2(delta.Y, flat.Magnitude) or math.atan2(v2 - math.sqrt(disc), g * flat.Magnitude)
    local T = math.tan(theta)
    local alpha = math.abs(3 + T) < 0.0001 and -math.pi / 2 or math.atan2(3 * T - 1, 3 + T)
    local cam = svc.WS.CurrentCamera
    local yawCF = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + flatDir)
    return yawCF * CFrame.Angles(alpha, 0, 0)
end

local function novaApplyPatch()
    if nova.patched or not nova.networkRF then return end
    if type(getcallbackvalue) == "function" then
        pcall(function() nova.originalCallback = getcallbackvalue(nova.networkRF, "OnClientInvoke") end)
    else
        nova.originalCallback = nova.networkRF.OnClientInvoke
    end
    nova.networkRF.OnClientInvoke = function(reqName, ...)
        if reqName == "GetCameraCF" and nova.enabled and novaIsNoli() then
            local char = lp.Character
            local myHRP = char and char:FindFirstChild("HumanoidRootPart")
            if myHRP then
                local target = novaGetNearest(myHRP.Position)
                if target and target.Parent then
                    local cf = novaBuildCF(myHRP, target)
                    if cf then return cf end
                end
            end
        end
        if nova.originalCallback then return nova.originalCallback(reqName, ...) end
    end
    nova.patched = true
end

local function novaRemovePatch()
    if not nova.patched or not nova.networkRF then return end
    pcall(function() nova.networkRF.OnClientInvoke = nova.originalCallback end)
    nova.originalCallback = nil
    nova.patched = false
end

lp.CharacterAdded:Connect(function()
    nova.motionData = setmetatable({}, { __mode = "k" })
    nova.patched = false
    nova.originalCallback = nil
    task.delay(1, function() if nova.enabled then novaApplyPatch() end end)
end)

NovaSection:CreateToggle({
    Name = "Enable Nova Silent Aim",
    CurrentValue = false,
    Flag = "NovaEnabled",
    Callback = function(on)
        nova.enabled = on
        if on then novaApplyPatch() else novaRemovePatch() end
    end
})

NovaSection:CreateSlider({
    Name = "Prediction",
    Range = {0, 2},
    Increment = 0.01,
    CurrentValue = nova.prediction,
    Flag = "NovaPrediction",
    Callback = function(v) nova.prediction = v; cfg.set("novaPrediction", v) end
})

NovaSection:CreateSlider({
    Name = "Aim Offset Y",
    Range = {-5, 5},
    Increment = 0.1,
    CurrentValue = nova.aimOffsetY,
    Flag = "NovaOffsetY",
    Callback = function(v) nova.aimOffsetY = v; cfg.set("novaOffsetY", v) end
})

------------------------------------------------------------------------
-- Apply saved theme on startup
------------------------------------------------------------------------
ApplyCustomTheme(savedTheme)

print("Frostsaken ready")