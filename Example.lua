local repo = 'https://raw.githubusercontent.com/Bucknbilly/TCOLib/main/'

local Library      = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'TCOLib Example',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local LocalPlayer = Players.LocalPlayer

local Tabs = {
    Player    = Window:AddTab('Player'),
    Teleport  = Window:AddTab('Teleport'),
    World     = Window:AddTab('World'),
    Settings  = Window:AddTab('Settings'),
    Cards     = Window:AddTab('Cards'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local PlayerLeft = Tabs.Player:AddLeftGroupbox('Movement')
local PlayerRight = Tabs.Player:AddRightGroupbox('Look & Combat')

local defaultWalk = 16
local defaultJump = 50

PlayerLeft:AddToggle('SpeedEnabled', {
    Text = 'Enable Speed',
    Default = false,
    Tooltip = 'Multiplies WalkSpeed by the slider value.',
    Callback = function(v)
        if v then
            RunService.Heartbeat:Connect(function()
                if Toggles.SpeedEnabled.Value and LocalPlayer.Character then
                    local hum = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    if hum then hum.WalkSpeed = defaultWalk * Options.SpeedMultiplier.Value end
                end
            end)
        end
    end,
})
PlayerLeft:AddSlider('SpeedMultiplier', {
    Text = 'Speed Multiplier',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Suffix = 'x',
})

PlayerLeft:AddToggle('JumpEnabled', {
    Text = 'Enable Jump Power',
    Default = false,
    Tooltip = 'Sets JumpPower to the slider value each frame.',
    Callback = function(v)
        if v then
            RunService.Heartbeat:Connect(function()
                if Toggles.JumpEnabled.Value and LocalPlayer.Character then
                    local hum = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    if hum then hum.JumpPower = defaultJump * Options.JumpMultiplier.Value end
                end
            end)
        end
    end,
})
PlayerLeft:AddSlider('JumpMultiplier', {
    Text = 'Jump Multiplier',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Suffix = 'x',
})

PlayerLeft:AddSlider('HipHeight', {
    Text = 'HipHeight',
    Default = 0,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Suffix = ' studs',
    Compact = false,
})
Toggles.SpeedEnabled:OnChanged(function()
    if not Toggles.SpeedEnabled.Value then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if hum then hum.WalkSpeed = defaultWalk end
    end
end)
Toggles.JumpEnabled:OnChanged(function()
    if not Toggles.JumpEnabled.Value then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if hum then hum.JumpPower = defaultJump end
    end
end)

PlayerLeft:AddDivider()
PlayerLeft:AddDropdown('Gravity', {
    Text = 'Gravity Mode',
    Values = { 'Normal', 'Low', 'Moon', 'Zero' },
    Default = 1,
    Callback = function(value)
        if value == 'Normal' then workspace.Gravity = 196.2
        elseif value == 'Low' then workspace.Gravity = 100
        elseif value == 'Moon' then workspace.Gravity = 30
        elseif value == 'Zero' then workspace.Gravity = 0 end
    end,
})

PlayerLeft:AddInput('ChatMessage', {
    Text = 'Quick Chat',
    Default = '',
    Placeholder = 'Type a message...',
    Finished = true,
    MaxLength = 200,
    Callback = function(text)
        if text and text ~= '' then
            pcall(function()
                local chat = game:GetService('TextChatService')
                local channel = chat:FindFirstChild('TextChannels')
                    and chat.TextChannels:FindFirstChild('RBXGeneral')
                if channel and channel.SendAsync then
                    channel:SendAsync(text)
                elseif LocalPlayer.Character then
                    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, 'All')
                end
            end)
        end
    end,
})

PlayerRight:AddToggle('Noclip', {
    Text = 'Noclip',
    Default = false,
    Tooltip = 'Walk through solid parts.',
    Callback = function(v)
        if v then
            RunService.Stepped:Connect(function()
                if Toggles.Noclip.Value and LocalPlayer.Character then
                    for _, p in next, LocalPlayer.Character:GetDescendants() do
                        if p:IsA('BasePart') then p.CanCollide = false end
                    end
                end
            end)
        end
    end,
})

PlayerRight:AddToggle('InfiniteJump', {
    Text = 'Infinite Jump',
    Default = false,
    Tooltip = 'Lets you jump in mid-air.',
    Callback = function(v)
        if v then
            UserInputService.JumpRequest:Connect(function()
                if Toggles.InfiniteJump.Value and LocalPlayer.Character then
                    local hum = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end
    end,
})

PlayerRight:AddSlider('FOV', {
    Text = 'Camera FOV',
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
})

PlayerRight:AddDropdown('CameraMode', {
    Text = 'Camera Mode',
    Values = { 'Default', 'First Person', 'Follow', 'Free' },
    Default = 1,
})

PlayerRight:AddKeyPicker('FreecamKey', {
    Text = 'Freecam Toggle',
    Default = 'F',
    Mode = 'Toggle',
})

local TPLeft = Tabs.Teleport:AddLeftGroupbox('Waypoints')
TPLeft:AddInput('WaypointName', {
    Text = 'New waypoint name',
    Default = '',
    Placeholder = 'e.g. spawn',
})
TPLeft:AddDropdown('WaypointList', {
    Text = 'Saved waypoints',
    Values = {},
    AllowNull = true,
    SpecialType = 'Player',
})

local waypoints = {}
local function addWaypoint(name, pos)
    table.insert(waypoints, { name = name, pos = pos })
    local names = {}
    for _, w in next, waypoints do table.insert(names, w.name) end
    Options.WaypointList:SetValues(names)
end
TPLeft:AddButton({ Text = 'Save current position', Func = function()
    local name = Options.WaypointName.Value
    if name == '' then return Library:Notify('Name required', 3) end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        addWaypoint(name, LocalPlayer.Character.HumanoidRootPart.Position)
        Library:Notify('Saved ' .. name, 3)
    end
end })
TPLeft:AddButton({ Text = 'Teleport to waypoint', Func = function()
    local sel = Options.WaypointList.Value
    for _, w in next, waypoints do
        if w.name == sel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(w.pos)
            Library:Notify('Teleported to ' .. sel, 3)
            return
        end
    end
    Library:Notify('Pick a waypoint first', 3)
end, DoubleClick = true })

TPLeft:AddDivider()

local TPRight = Tabs.Teleport:AddRightGroupbox('Player Teleport')
TPRight:AddButton({ Text = 'Teleport to Player', Func = function()
    local name = Options.WaypointList.Value
    if not name then return Library:Notify('Pick a player', 3) end
    local target = Players:FindFirstChild(name)
    if not target or not target.Character then return Library:Notify('Not in game', 3) end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end, DoubleClick = true })

TPRight:AddButton({ Text = 'Spectate Player', Func = function()
    local name = Options.WaypointList.Value
    if not name then return Library:Notify('Pick a player', 3) end
    local target = Players:FindFirstChild(name)
    if target and target.Character and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass('Humanoid')
    end
end })

local WorldLeft = Tabs.World:AddLeftGroupbox('Lighting')
WorldLeft:AddSlider('Brightness', {
    Text = 'Brightness',
    Default = 2, Min = 0, Max = 10, Rounding = 1,
    Compact = true,
})
WorldLeft:AddToggle('Fullbright', {
    Text = 'Fullbright',
    Default = false,
    Callback = function(v)
        local lighting = game:GetService('Lighting')
        if v then
            lighting.Brightness = Options.Brightness.Value
            lighting.GlobalShadows = false
            lighting.FogEnd = 1e9
        else
            lighting.Brightness = 1
            lighting.GlobalShadows = true
            lighting.FogEnd = 100000
        end
    end,
})

WorldLeft:AddLabel('Ambient color'):AddColorPicker('AmbientColor', {
    Default = Color3.fromRGB(127, 127, 127),
    Title = 'Ambient',
    Transparency = 0,
})

WorldLeft:AddDropdown('TimeOfDay', {
    Text = 'Time of Day',
    Values = { 'Day', 'Night', 'Dusk', 'Dawn' },
    Default = 1,
    Callback = function(value)
        local lighting = game:GetService('Lighting')
        if value == 'Day' then lighting.ClockTime = 14
        elseif value == 'Night' then lighting.ClockTime = 0
        elseif value == 'Dusk' then lighting.ClockTime = 19
        elseif value == 'Dawn' then lighting.ClockTime = 6 end
    end,
})

local WorldRight = Tabs.World:AddRightGroupbox('Fog & Atmosphere')
WorldRight:AddToggle('RemoveFog', {
    Text = 'Remove Fog',
    Default = false,
    Callback = function(v)
        if v then
            game:GetService('Lighting').FogEnd = 1e9
            game:GetService('Lighting').FogStart = 0
        else
            game:GetService('Lighting').FogEnd = 100000
        end
    end,
})
WorldRight:AddSlider('FogStart', {
    Text = 'Fog Start',
    Default = 0, Min = 0, Max = 1000, Rounding = 0,
})
WorldRight:AddSlider('FogEnd', {
    Text = 'Fog End',
    Default = 100000, Min = 1000, Max = 1000000, Rounding = 0,
})
WorldRight:AddBlank(8)
WorldRight:AddDivider()
WorldRight:AddLabel('Choose a background color')
WorldRight:AddLabel('Sky tint'):AddColorPicker('SkyTint', {
    Default = Color3.fromRGB(255, 204, 0),
})

local SettingsLeft = Tabs.Settings:AddLeftGroupbox('Hotkeys')
SettingsLeft:AddLabel('Speed hotkey'):AddKeyPicker('SpeedHotkey', {
    Default = 'X',
    Mode = 'Toggle',
    Text = 'Toggle Speed',
    NoUI = false,
    SyncToggleState = true,
})
SettingsLeft:AddLabel('Jump hotkey'):AddKeyPicker('JumpHotkey', {
    Default = 'C',
    Mode = 'Toggle',
    Text = 'Toggle Jump Power',
})
SettingsLeft:AddLabel('Noclip hotkey'):AddKeyPicker('NoclipHotkey', {
    Default = 'V',
    Mode = 'Hold',
    Text = 'Hold Noclip',
})
SettingsLeft:AddDivider()
SettingsLeft:AddToggle('AntiAFK', { Text = 'Anti-AFK', Default = false })

local SettingsRight = Tabs.Settings:AddRightGroupbox('Misc')
SettingsRight:AddButton({ Text = 'Respawn', Func = function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end, DoubleClick = true })
SettingsRight:AddButton({ Text = 'Rejoin Server', Func = function
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end, DoubleClick = true })
SettingsRight:AddButton({ Text = 'Copy Place ID', Func = function()
    pcall(function()
        if setclipboard then setclipboard(tostring(game.PlaceId)) end
    end)
end })
SettingsRight:AddButton({ Text = 'Copy Job ID', Func = function()
    pcall(function()
        if setclipboard then setclipboard(game.JobId) end
    end)
end })

SettingsRight:AddDivider()
local Row1 = SettingsRight:AddRow({
    Text = 'Server status',
    Value = 'online',
    ButtonText = 'Refresh',
    ButtonCallback = function() Row1:SetText('Server status: ' .. tostring(#Players:GetPlayers()) .. ' players') end,
})
local Row2 = SettingsRight:AddRow({
    Text = 'Place ID',
    Value = tostring(game.PlaceId),
})
local Row3 = SettingsRight:AddRow({
    Text = 'Job ID',
    Value = game.JobId,
})
Row1:SetText('Server status: ' .. #Players:GetPlayers() .. ' players')
Row2:SetText('Place ID: ' .. tostring(game.PlaceId))

local CardsLeft = Tabs.Cards:AddLeftGroupbox('Server Info Cards')

local Card1 = CardsLeft:AddCard({
    Title = 'Current Server',
    Subtitle = #Players:GetPlayers() .. ' players online',
    Badge = 'Live',
    BadgeColor = Library.AccentColor,
    ButtonText = 'Copy ID',
    ButtonFunc = function()
        if setclipboard then setclipboard(game.JobId) end
    end,
})

CardsLeft:AddBlank(8)

local Card2 = CardsLeft:AddCard({
    Title = 'Roblox Profile',
    Subtitle = '@' .. (LocalPlayer.Name or 'guest'),
    Badge = 'You',
    BadgeColor = Color3.fromRGB(120, 120, 120),
    ButtonText = 'Open Profile',
    ButtonFunc = function()
        pcall(function()
            game:GetService('GuiService'):OpenBrowserWindow('https://www.roblox.com/users/' .. LocalPlayer.UserId .. '/profile')
        end)
    end,
})

Card1:SetBadge('Online')
Card1:SetSubtitle(#Players:GetPlayers() .. ' in server')

local CardsRight = Tabs.Cards:AddRightGroupbox('Quick Links')
local Card3 = CardsRight:AddCard({
    Title = 'Roblox Home',
    Subtitle = 'Open roblox.com',
    ButtonText = 'Visit',
    ButtonFunc = function()
        pcall(function() game:GetService('GuiService'):OpenBrowserWindow('https://www.roblox.com') end)
    end,
})
CardsRight:AddBlank(6)
local Card4 = CardsRight:AddCard({
    Title = 'Game Page',
    Subtitle = 'View place info',
    ButtonText = 'Visit',
    ButtonFunc = function()
        pcall(function()
            game:GetService('GuiService'):OpenBrowserWindow('https://www.roblox.com/games/' .. game.PlaceId)
        end)
    end,
})

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    Library:SetWatermark(('TCOLib | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library.KeybindFrame.Visible = true

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind',
})
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyTCOScript')
SaveManager:SetFolder('MyTCOScript/specific-game')

ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()