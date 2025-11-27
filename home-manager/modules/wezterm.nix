{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require('wezterm')
      local config = wezterm.config_builder()
      local act = wezterm.action

      config.keys = {
        -- paste from the clipboard
        { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
      }

      config.default_gui_startup_args = {'start', '--always-new-process'}
      config.enable_wayland = false
      config.enable_tab_bar = false
      config.dpi = 196

      -- Terminal Theme
      
      config.font = wezterm.font_with_fallback {
      {
        family = 'Maple Mono NF',
        weight = 'Light',
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
      },
      {
        family = 'Maple Mono NF',
        weight = 'Medium',
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
      },
      {
        family = 'Maple Mono NF',
        weight = 'Bold',
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
      },
      -- { family = 'Terminus', weight = 'Bold' },
      'Noto Color Emoji',
      }

      config.font_size = 14.0

      config.color_scheme = "Catppuccin Mocha" 
      config.window_background_opacity = 0.6

      return config
    '';
  };
}
