{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require('wezterm')
      local config = wezterm.config_builder()

      config.default_prog = {
        "/bin/sh",
	"-c",
	"tmux attach -t my_session || tmux new -s my_session"
      }

      config.default_gui_startup_args = {'start', '--always-new-process'}
      config.enable_wayland = false
      config.enable_tab_bar = false
      config.dpi = 196

      -- Terminal Theme
      
      config.font = wezterm.font_with_fallback {
      {
	family = 'JetBrains Mono',
	weight = 'Medium',
	harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
      },
      { family = 'Terminus', weight = 'Bold' },
      'Noto Color Emoji',
      }

      config.font_size = 20.0

      config.color_scheme = 'Tokyo Night'

      return config
    '';
  };
}
