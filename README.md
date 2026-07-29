<div align="center">

# TCOLib

**A library for The Chosen One.**

[![Forked from peal-lib](https://img.shields.io/badge/fork-peal--lib-yellow)](https://github.com/pealz1/PealLib)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A UI library for [The Chosen One](https://www.roblox.com/games/2753915549) and other Roblox games,
forked from [peal-lib](https://github.com/pealz1/PealLib).


Credits to [Pealz](https://www.roblox.com/users/9763171531/profile) for making the original [peal-lib](https://github.com/pealz1/PealLib)
</div>

---

## Quick Start

```lua
local repo = 'https://raw.githubusercontent.com/Bucknbilly/TCOLib/main/'

local Library      = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'My Script',
    Center = true,
    AutoShow = true,
})

local Tab = Window:AddTab('Main')
local Box = Tab:AddLeftGroupbox('Features')

Box:AddToggle('Enabled', { Text = 'Enable feature', Default = false })
Box:AddSlider('Speed',   { Text = 'Speed', Default = 16, Min = 0, Max = 100, Rounding = 0 })
Box:AddDropdown('Mode',  { Text = 'Mode', Values = { 'A', 'B', 'C' }, Default = 1 })
```

See `Example.lua` for a full walkthrough.

---

## Project Structure

```
TCOLib/
├── Library.lua              -- Core UI library
├── Example.lua              -- Full usage example
├── addons/
│   ├── ThemeManager.lua     -- Theme system
│   └── SaveManager.lua      -- Config persistence
├── README.md
└── LICENSE
```

---

## API Reference

Every element is added to a groupbox (`Tab:AddLeftGroupbox`, `Tab:AddRightGroupbox`, or `Tabbox:AddTab`).
After adding, the element is reachable globally through `Toggles` (booleans) or `Options` (everything else)
using the `Idx` you passed.

### `Library:CreateWindow(Options) → Window`

| Option | Type | Default | Notes |
|--------|------|---------|-------|
| `Title` | string | — | Window title text. |
| `Center` | bool | `false` | Center on screen at startup. |
| `AutoShow` | bool | `false` | Show immediately after creation. |
| `Position` | UDim2 | centered | Manual position. |
| `Size` | UDim2 | default | Manual size. |
| `TabPadding` | number | — | Gap between tabs. |
| `MenuFadeTime` | number | `0.2` | Fade-in seconds. |

```lua
local Window = Library:CreateWindow({ Title = 'My Script', Center = true, AutoShow = true })
```

### `Window:AddTab(Name) → Tab`

### `Tab:AddLeftGroupbox(Name) / AddRightGroupbox(Name) → Groupbox`

### `Groupbox:AddToggle(Idx, Options) → Toggle`

| Option | Type | Notes |
|--------|------|-------|
| `Text` | string | Label text. |
| `Default` | bool | Initial value. |
| `Tooltip` | string | Hover tooltip. |
| `Callback` | function | Fires on change. |

```lua
Box:AddToggle('Enabled', { Text = 'Enable feature', Default = false })
Toggles.Enabled:OnChanged(function() print(Toggles.Enabled.Value) end)
Toggles.Enabled:SetValue(true)
```

### `Groupbox:AddSlider(Idx, Options) → Slider`

| Option | Type | Notes |
|--------|------|-------|
| `Text` | string | Label. |
| `Default` / `Min` / `Max` | number | Range. |
| `Rounding` | number | Decimal places. |
| `Suffix` | string | Unit suffix (e.g. `' studs'`). |
| `Compact` | bool | Hide the title. |
| `HideMax` | bool | Only show value, not max. |

```lua
Box:AddSlider('Speed', { Text = 'Speed', Default = 16, Min = 0, Max = 100, Rounding = 0, Suffix = ' studs' })
```

### `Groupbox:AddDropdown(Idx, Options) → Dropdown`

| Option | Type | Notes |
|--------|------|-------|
| `Values` | table | List of strings. |
| `Default` | number / string | Initial selection or pre-set key. |
| `Multi` | bool | Multi-select. |
| `SpecialType` | string | `'Player'` to populate with players. |
| `AllowNull` | bool | Allow no selection. |

```lua
Box:AddDropdown('Mode', { Values = { 'A', 'B' }, Default = 1, Multi = false })
Options.Mode:OnChanged(function() print(Options.Mode.Value) end)
Options.Mode:SetValue('B')
```

### `Groupbox:AddInput(Idx, Options) → Input`

| Option | Type | Notes |
|--------|------|-------|
| `Default` | string | Initial text. |
| `Placeholder` | string | Empty-state text. |
| `Numeric` | bool | Numeric-only. |
| `Finished` | bool | Only fire callback on Enter. |
| `MaxLength` | number | Cap characters. |

```lua
Box:AddInput('Name', { Default = '', Placeholder = 'Type here...' })
```

### `Groupbox:AddButton(Options) → Button`

| Option | Type | Notes |
|--------|------|-------|
| `Text` | string | Button label. |
| `Func` | function | Click handler. |
| `DoubleClick` | bool | Require two clicks. |
| `Tooltip` | string | Hover tooltip. |

```lua
local Btn = Box:AddButton({ Text = 'Run', Func = function() print('clicked') end })
Btn:AddButton({ Text = 'Sub', Func = function() end, DoubleClick = true })
```

### `Groupbox:AddLabel(Text, DoesWrap) → Label`

`Label:SetText(str)` updates the text at runtime.

### `Groupbox:AddDivider()`

### `Groupbox:AddCard(Options) → Card`

| Option | Type | Notes |
|--------|------|-------|
| `Title` | string | Card title. |
| `Subtitle` | string | Subtitle text. |
| `Badge` | string | Badge text. |
| `BadgeColor` | Color3 | Badge background. |
| `Thumbnail` | string | Image URL. |
| `ButtonText` | string | Button label. |
| `ButtonFunc` | function | Button click handler. |

```lua
local Card = Box:AddCard({ Title = 'Item 1', Subtitle = 'Last edited 2m ago', Badge = 'Active', BadgeColor = Library.AccentColor, ButtonText = 'Load', ButtonFunc = function() end })
Card:SetBadge('Verified')
Card:SetSubtitle('Updated')
Card:SetVisible(false)
```

### `Groupbox:AddRow(Options) → Row`

| Option | Type | Notes |
|--------|------|-------|
| `Text` | string | Row label. |
| `Value` | string | Right-side value. |
| `ButtonText` | string | Optional embedded button. |
| `ButtonCallback` | function | Button click. |

```lua
Row:SetText('Status: Ready')
Row:SetVisible(false)
```

### `Groupbox:AddBlank(Size)` — vertical spacer of `Size` pixels.

### `Groupbox:AddDependencyBox() → Depbox`

```lua
local Dep = Box:AddDependencyBox()
Dep:AddToggle('Sub', { Text = 'Sub toggle' })
Dep:SetupDependencies({ { Toggles.Enabled, true } })
```

`SetupDependencies` takes `{ { Toggles.X, wantState }, ... }`. Sub-Depboxes auto-inherit the parent's visibility.

### `Label:AddColorPicker(Idx, Options) → ColorPicker`

| Option | Type | Notes |
|--------|------|-------|
| `Default` | Color3 | Initial color. |
| `Title` | string | Picker window title. |
| `Transparency` | number | 0–1, enables alpha slider. |

```lua
Box:AddLabel('Tint'):AddColorPicker('Tint', { Default = Color3.fromRGB(255, 204, 0), Transparency = 0 })
Options.Tint:OnChanged(function() print(Options.Tint.Value, Options.Tint.Transparency) end)
Options.Tint:SetValueRGB(Color3.fromRGB(0, 255, 0))
```

### `Label:AddKeyPicker(Idx, Options) → KeyPicker`

| Option | Type | Notes |
|--------|------|-------|
| `Default` | string | `'MB2'`, `'F'`, `Enum.KeyCode.X` etc. |
| `Mode` | string | `'Always'` / `'Toggle'` / `'Hold'`. |
| `Text` | string | Display label. |
| `NoUI` | bool | Hide from the keybind menu. |
| `SyncToggleState` | bool | Mirror a parent toggle. |
| `Callback` | function | Fires on press. |
| `ChangedCallback` | function | Fires on rebind. |

```lua
Box:AddLabel('Bind'):AddKeyPicker('Bind', { Default = 'MB2', Mode = 'Toggle', Text = 'Trigger' })
Options.Bind:OnClick(function() print(Options.Bind:GetState()) end)
Options.Bind:SetValue({ 'MB2', 'Hold' })
```

### `Tab:AddLeftTabbox() / AddRightTabbox() → Tabbox`

```lua
local TabBox = Tab:AddRightTabbox()
local T1 = TabBox:AddTab('Tab 1')
local T2 = TabBox:AddTab('Tab 2')
T1:AddToggle('T1', { Text = 'T1 toggle' })
```

### `Card:SetBadge(text) / SetBadgeColor(color) / SetSubtitle(text) / SetLeftText(text) / SetThumbnails(urls) / SetButtonFunc(func) / SetVisible(bool) / GetFrame() → Frame`

### `Row:SetText(text) / SetVisible(bool) / GetFrame() → Frame`

### `Library:Notify(Text, Time?)`

Pushes a notification. `Time` defaults to a few seconds.

```lua
Library:Notify('Done', 5)
```

### `Library:SetWatermark(Text)` / `Library:SetWatermarkVisibility(bool)`

```lua
Library:SetWatermarkVisibility(true)
Library:SetWatermark('MyScript | 60 fps | 32 ms')
```

### `Library:CreatePopout(Config) → Popout`

Detached floating panel.

```lua
local Pop = Library:CreatePopout({ Title = 'Mini' })
Pop:AddGroupbox('Settings'):AddToggle('A', { Text = 'A' })
Pop:Show()
```

### `Library:CreateHomeTab(Window, Info) → HomeTab`

A landing tab with multiple sections at once.

```lua
local Home = Library:CreateHomeTab(Window, { Title = 'Welcome' })
Home:AddLeftGroupbox('Info'):AddLabel('Hello')
```

### `Library:CreateToggleButton(Text) → Button`

Floating on-screen toggle (useful for touch/mobile).

### `Library:OnUnload(callback)` / `Library:Unload()`

`OnUnload` registers cleanup. `Unload` fires all registered callbacks and tears down the UI.

```lua
local C = someSignal:Connect(...)
Library:GiveSignal(C)
Library:OnUnload(function() C:Disconnect() end)
```

### `Library:SafeCallback(fn, ...)` / `Library:AttemptSave()`

Use `SafeCallback` to pcalled user callbacks. `AttemptSave` is the autosave hook used by SaveManager.

### Window → Tab methods

`Window:SetWindowTitle(str)`, `Window:AddTab(name)`, `Window:SetToggleKeybind(Options.Keybind)`.

### Tab → Groupbox methods

`Tab:ShowTab()` / `HideTab()`, `Tab:SetLayoutOrder(n)`, `Tab:AddGroupbox(Info)`, `Tab:AddLeftGroupbox(name)`, `Tab:AddRightGroupbox(name)`, `Tab:AddTabbox(Info)`, `Tab:AddLeftTabbox(name)`, `Tab:AddRightTabbox(name)`.

### ThemeManager

| Method | Notes |
|--------|-------|
| `ThemeManager:SetLibrary(Library)` | Required. |
| `ThemeManager:SetFolder(folder)` | Disk folder for themes. |
| `ThemeManager:ApplyToTab(tab)` | Adds the theme picker to a tab. |
| `ThemeManager:ApplyToGroupbox(groupbox)` | Adds to a specific groupbox. |
| `ThemeManager:ApplyTheme(name)` | Programmatic theme switch. |
| `ThemeManager:LoadDefault()` | Loads the saved default theme. |
| `ThemeManager:SaveDefault(name)` | Sets the autoload pointer. |

### SaveManager

| Method | Notes |
|--------|-------|
| `SaveManager:SetLibrary(Library)` | Required. |
| `SaveManager:SetFolder(folder)` | Disk folder for configs. |
| `SaveManager:IgnoreThemeSettings()` | Don't persist theme color picker values. |
| `SaveManager:SetIgnoreIndexes({...})` | Skip these index names. |
| `SaveManager:BuildConfigSection(tab)` | Adds the save/load/autoload UI. |
| `SaveManager:LoadAutoloadConfig()` | Loads the autoload pointer's config. |
| `SaveManager:Save(name)` / `SaveManager:Load(name)` | Programmatic. |
| `SaveManager:RefreshConfigList()` | Returns current config names. |

### Library globals

After `Library:CreateWindow`, the following are populated:

- `Toggles.<Idx>.Value` — bool, read/write.
- `Options.<Idx>.Value` — current value (number, string, Color3, table for multi, etc.).
- `Options.<Idx>.Transparency` — color picker only.
- `Library.Unloaded` — set to `true` after `Unload()`.
- `Library.ToggleKeybind` — accepts an `Options.KeyPicker` to rebind the menu key.

### Globals declared by the library

```lua
getgenv().Toggles = Toggles
getgenv().Options = Options
```

---

## License

MIT — see [LICENSE](LICENSE).
