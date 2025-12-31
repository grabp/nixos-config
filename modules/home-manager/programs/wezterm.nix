{ pkgs, ... }:
{
  catppuccin.wezterm = {
    enable = false;
  };
  programs.wezterm = {
    enable = true;
    extraConfig =
      let
        font-size = if pkgs.stdenv.isDarwin then "32.0" else "14.0";
      in
      ''
        local wezterm = require('wezterm')
        local config = wezterm.config_builder()
        local act = wezterm.action

        config.keys = {
          -- paste from the clipboard
          -- { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
        }

        config.default_gui_startup_args = {'start', '--always-new-process'}
        config.enable_wayland = false
        config.enable_tab_bar = false
        config.dpi = 192
        config.front_end = 'Software'

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

        config.font_size = ${font-size}

        config.color_scheme = "Catppuccin Mocha" 
        config.window_background_opacity = 0.8

        return config
      '';
  };
}
