-- ============================================================================
-- Ultra-Performance WezTerm Config (Alacritty Killer Mode)
-- Target: <50ms startup | <10ms input latency | <100MB memory
-- Optimized for Neovim + Odoo Development
-- ============================================================================

local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- ============================================================================
-- PERFORMANCE CRITICAL (Alacritty-Level Speed)
-- ============================================================================

-- GPU & Rendering (Fastest possible)
config.front_end = "WebGpu"              -- Modern, fastest on Win11
config.webgpu_power_preference = "HighPerformance"
config.prefer_egl = true

-- Frame Rate (Balance speed vs battery)
config.animation_fps = 1                 -- Disable animations (instant response)
config.max_fps = 144                     -- Match monitor refresh rate (adjust: 60/120/144/240)
config.cursor_blink_rate = 0             -- Disable cursor blink (saves redraws)

-- Memory Optimization
config.scrollback_lines = 3000           -- Reduced from 5000 (save ~40% memory)
config.enable_scroll_bar = false         -- No scrollbar = less rendering

-- ============================================================================
-- FONT (Optimized for Neovim)
-- ============================================================================

config.font = wezterm.font_with_fallback({
  { family = "FiraCode Nerd Font", weight = "Regular" },
  { family = "JetBrainsMono Nerd Font" },  -- Fallback for better glyph coverage
})
config.font_size = 11.0
config.line_height = 1.0
config.cell_width = 1.0

-- Ligatures (Fira Code programming ligatures)
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1', 'ss01=1', 'ss03=1', 'ss05=1' }

-- Font rendering optimization
config.freetype_load_target = "Normal"
config.freetype_render_target = "HorizontalLcd"

-- ============================================================================
-- COLORS (Tokyo Night - matches your Neovim Catppuccin style)
-- ============================================================================

config.color_scheme = 'Tokyo Night'

-- Transparency (minimal for performance)
config.window_background_opacity = 0.95
config.text_background_opacity = 1.0     -- Keep text fully opaque (readability)

-- ============================================================================
-- WINDOW BEHAVIOR
-- ============================================================================

config.initial_cols = 120                -- Wider for side-by-side code
config.initial_rows = 30
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- Performance: Disable window blur effects
config.win32_system_backdrop = "Disable" -- Windows 11 acrylic OFF (saves GPU)

-- ============================================================================
-- SHELL & STARTUP
-- ============================================================================

config.default_cwd = "D:/"
config.default_prog = { 'powershell.exe', '-NoLogo' }  -- Use regular PowerShell (change to pwsh.exe if you have PowerShell Core)

-- Skip update checks (faster startup)
config.check_for_updates = false
config.show_update_window = false

-- ============================================================================
-- KEYBINDINGS (Vim-centric + Neovim-friendly)
-- ============================================================================

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- ============================================================================
  -- PANE MANAGEMENT (Vim-style)
  -- ============================================================================

  -- Split panes (like Neovim :vsp / :sp)
  { key = '|', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = '_', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },

  -- Navigate panes (Alt + Vim keys - DOESN'T conflict with Neovim's Ctrl+h/j/k/l)
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Right') },

  -- Resize panes (Alt + Arrow keys - same as your Neovim config)
  { key = 'LeftArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize({ 'Left', 2 }) },
  { key = 'RightArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize({ 'Right', 2 }) },
  { key = 'UpArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize({ 'Up', 2 }) },
  { key = 'DownArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize({ 'Down', 2 }) },

  -- Close pane
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane({ confirm = false }) },

  -- ============================================================================
  -- TAB MANAGEMENT
  -- ============================================================================

  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },

  -- Quick tab switching (Alt + number)
  { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4) },

  -- ============================================================================
  -- COPY/PASTE (Performance optimized)
  -- ============================================================================

  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo('Clipboard') },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom('Clipboard') },

  -- ============================================================================
  -- SEARCH (for scrollback)
  -- ============================================================================

  { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.Search({ CaseInSensitiveString = '' }) },

  -- ============================================================================
  -- ZOOM
  -- ============================================================================

  { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },

  -- ============================================================================
  -- LAUNCHER (Ctrl+Shift+Space untuk akses cepat)
  -- ============================================================================

  { key = 'Space', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
}

-- ============================================================================
-- MOUSE BEHAVIOR
-- ============================================================================

config.mouse_bindings = {
  -- Paste on right-click
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom('Clipboard'),
  },

  -- Disable Ctrl+Click opening URLs (can interfere with Neovim)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

-- ============================================================================
-- TAB BAR (Minimal, performance-friendly)
-- ============================================================================

config.use_fancy_tab_bar = false         -- Use retro tab bar (faster rendering)
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

-- ============================================================================
-- NEOVIM-SPECIFIC OPTIMIZATIONS
-- ============================================================================

-- Ensure true color support for Catppuccin theme
config.term = "xterm-256color"

-- Quick paste without bracketed paste delay
config.enable_kitty_keyboard = true      -- Better key handling

-- ============================================================================
-- QUICK LAUNCH MENU (Odoo Development)
-- ============================================================================

config.launch_menu = {
  {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo', '-NoExit', '-Command', 'cd D:/odoo/odoo14; .\\venv\\Scripts\\Activate.ps1' },
  },
  {
    label = 'CMD',
    args = { 'cmd.exe' },
  },
  {
    label = 'Neovim (Odoo)',
    args = { 'powershell.exe', '-NoLogo', '-NoExit', '-Command', 'cd D:/odoo/odoo14; nvim' },
  },
}

-- ============================================================================
-- PERFORMANCE MONITORING (Optional - comment out in production)
-- ============================================================================

-- Uncomment to see FPS and performance stats (Ctrl+Shift+L)
-- wezterm.on('update-right-status', function(window, pane)
--   window:set_right_status(window:active_workspace() .. ' | FPS: ' .. wezterm.fps())
-- end)

-- ============================================================================
-- FINAL TWEAKS
-- ============================================================================

-- Disable bell (saves audio processing)
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 0,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 0,
}

-- Exit behavior (instant close without confirmation)
config.exit_behavior = 'CloseOnCleanExit'  -- Change to 'Close' if you get exit code errors
config.window_close_confirmation = 'NeverPrompt'

-- Skip initial startup messages
config.skip_close_confirmation_for_processes_named = {
  'bash', 'sh', 'zsh', 'fish', 'pwsh', 'powershell',
}

return config
