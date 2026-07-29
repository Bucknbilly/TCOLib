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

local Tabs = {
    Main    = Window:AddTab('Main'),
    Build   = Window:AddTab('Build'),
    Visuals = Window:AddTab('Visuals'),
    Cards   = Window:AddTab('Cards'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox  = Tabs.Main:AddLeftGroupbox('Toggles')
local RightGroupBox = Tabs.Main:AddRightGroupbox('Information')

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'This is a toggle',
    Default = true,
    Tooltip = 'Tooltip text on hover.',
    Callback = function(Value) print('[cb] MyToggle:', Value) end,
})
Toggles.MyToggle:OnChanged(function()
    print('MyToggle ->', Toggles.MyToggle.Value)
end)

LeftGroupBox:AddButton({
    Text = 'Main button',
    Func = function() print('Clicked main!') end,
    DoubleClick = false,
    Tooltip = 'Single-click trigger.',
})
LeftGroupBox:AddButton({
    Text = 'Double-click button',
    Func = function() print('Clicked double!') end,
    DoubleClick = true,
    Tooltip = 'Requires two clicks to trigger.',
})

LeftGroupBox:AddLabel('This is a label')
LeftGroupBox:AddLabel('Multi-line label\ndemonstrates text wrapping!', true)
LeftGroupBox:AddDivider()

LeftGroupBox:AddSlider('MySlider', {
    Text = 'Slider with suffix',
    Default = 16,
    Min = 4, Max = 128,
    Rounding = 0,
    Suffix = ' studs',
    Callback = function(Value) print('[cb] MySlider:', Value) end,
})

LeftGroupBox:AddInput('MyInput', {
    Text = 'Text input',
    Default = '',
    Placeholder = 'Type here...',
    Finished = false,
    Callback = function(Value) print('[cb] MyInput:', Value) end,
})

LeftGroupBox:AddDropdown('MyDropdown', {
    Text = 'Single dropdown',
    Values = { 'Plastic', 'Neon', 'Metal', 'Glass', 'Wood' },
    Default = 1,
    Multi = false,
    Callback = function(Value) print('[cb] MyDropdown:', Value) end,
})

LeftGroupBox:AddDropdown('MyMultiDropdown', {
    Text = 'Multi dropdown',
    Values = { 'Red', 'Green', 'Blue', 'Yellow' },
    Default = 'Yellow',
    Multi = true,
    Callback = function(Value) print('[cb] MyMultiDropdown changed') end,
})

LeftGroupBox:AddDropdown('MyPlayerDropdown', {
    SpecialType = 'Player',
    Text = 'Player dropdown',
    Tooltip = 'Populates with players in the server.',
    Callback = function(Value) print('[cb] PlayerDropdown:', Value) end,
})

RightGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
    Default = Color3.fromRGB(255, 204, 0),
    Title = 'Pick a color',
    Transparency = 0,
    Callback = function(Value) print('[cb] ColorPicker:', Value) end,
})

RightGroupBox:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
    Default = 'MB2',
    Mode = 'Toggle',
    Text = 'Auto lockpick',
    Callback = function(Value) print('[cb] KeyPicker:', Value) end,
    ChangedCallback = function(New) print('[cb] KeyPicker changed:', New) end,
})

Options.KeyPicker:OnClick(function()
    print('KeyPicker clicked!', Options.KeyPicker:GetState())
end)

task.spawn(function()
    while true do
        wait(1)
        if Options.KeyPicker:GetState() then
            print('KeyPicker is being held down')
        end
        if Library.Unloaded then break end
    end
end)

local RightGroupbox2 = Tabs.Main:AddRightGroupbox('Dependency Boxes')
RightGroupbox2:AddToggle('ControlToggle', { Text = 'Dependency box toggle' })

local Depbox = RightGroupbox2:AddDependencyBox()
Depbox:AddToggle('DepboxToggle', { Text = 'Sub-dependency box toggle' })

local SubDepbox = Depbox:AddDependencyBox()
SubDepbox:AddSlider('DepboxSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 })
SubDepbox:AddDropdown('DepboxDropdown', { Text = 'Dropdown', Default = 1, Values = { 'a', 'b', 'c' } })

Depbox:SetupDependencies({ { Toggles.ControlToggle, true } })
SubDepbox:SetupDependencies({ { Toggles.DepboxToggle, true } })

local TabBox = Tabs.Main:AddRightTabbox()
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab1 Toggle' })
local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Tab2 Toggle' })

local BuildLeftBox = Tabs.Build:AddLeftGroupbox('Build Settings')
BuildLeftBox:AddToggle('AutoBuild', { Text = 'Auto-Build', Default = false })
BuildLeftBox:AddSlider('BuildSpeed', {
    Text = 'Place delay (s)',
    Default = 0.05, Min = 0, Max = 1, Rounding = 3,
    Suffix = 's',
})
BuildLeftBox:AddDropdown('BuildMode', {
    Text = 'Build mode',
    Values = { 'Adhere', 'Free', 'Symmetric', 'Mirror' },
    Default = 1,
})

local BuildRightBox = Tabs.Build:AddRightGroupbox('Transform')
BuildRightBox:AddToggle('TransformEnabled', { Text = 'Enable Transform handles', Default = false })
BuildRightBox:AddSlider('TransformSnap', {
    Text = 'Snap step',
    Default = 4, Min = 1, Max = 32, Rounding = 0,
    Suffix = ' studs',
})
BuildRightBox:AddDropdown('RotationAxis', {
    Text = 'Rotation axis',
    Values = { 'X', 'Y', 'Z', 'Multi' },
    Default = 2,
})

local VisualsLeftBox = Tabs.Visuals:AddLeftGroupbox('Preview')
VisualsLeftBox:AddToggle('PreviewEnabled', { Text = '3D Preview overlay', Default = true })
VisualsLeftBox:AddSlider('PreviewAlpha', {
    Text = 'Preview alpha',
    Default = 0.4, Min = 0, Max = 1, Rounding = 2,
})

local CardsLeftBox = Tabs.Cards:AddLeftGroupbox('Info Cards')

local Card1 = CardsLeftBox:AddCard({
    Title = 'Build Slot #1',
    Subtitle = 'Last edited 2 minutes ago',
    Badge = 'Active',
    BadgeColor = Library.AccentColor,
    Thumbnail = 'https://i.imgur.com/qs0Hqc6.png',
    ButtonText = 'Load',
    ButtonFunc = function() print('Card1 load pressed') end,
})

local Card2 = CardsLeftBox:AddCard({
    Title = 'Build Slot #2',
    Subtitle = 'Empty',
    Badge = 'Empty',
    BadgeColor = Color3.fromRGB(120, 120, 120),
    ButtonText = 'Create',
    ButtonFunc = function() print('Card2 create pressed') end,
})

Card1:SetBadge('Verified')
Card1:SetSubtitle('Just updated')

local CardsRightBox = Tabs.Cards:AddRightGroupbox('Rows')

local Row1 = CardsRightBox:AddRow({
    Text = 'Status',
    Value = 'Idle',
    ButtonText = 'Refresh',
    ButtonCallback = function() print('Refresh pressed') end,
})
Row1:SetText('Status: Ready')

local Row2 = CardsRightBox:AddRow({
    Text = 'Build count',
    Value = '0',
})
Row2:SetText('Build count: 42')

CardsRightBox:AddBlank(8)
CardsRightBox:AddDivider()
CardsRightBox:AddBlank(8)

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
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
