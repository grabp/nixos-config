{ pkgs, ... }:
let
  # On Darwin, kitty is installed via Homebrew (properly Apple-signed).
  # Use a stub so home-manager still generates the config without also
  # installing the unsigned Nix binary.
  kittyPkg = if pkgs.stdenv.isDarwin
    then pkgs.runCommand "kitty-stub" { } "mkdir -p $out"
    else pkgs.kitty;
in
{
  catppuccin.kitty = {
    enable = true;
    flavor = "mocha";
  };

  programs.kitty = {
    enable = true;
    package = kittyPkg;

    settings = {
      # Font configuration with fallbacks
      font_family = "Maple Mono NF Light";
      bold_font = "Maple Mono NF Bold";
      italic_font = "Maple Mono NF Medium";
      bold_italic_font = "Maple Mono NF Bold";
      font_size = "12.0";

      # Disable ligatures globally (avoids PostScript name parsing issues)
      disable_ligatures = "always";

      # Fallback fonts - use Apple Color Emoji (always present on macOS)
      symbol_map = "U+1F300-U+1F9FF Apple Color Emoji";

      # Appearance
      background_opacity = "0.8";
      hide_window_decorations = "no";

      # Tab bar - hidden (matching wezterm)
      tab_bar_style = "hidden";

      # Wayland support
      wayland_titlebar_color = "background";

      # Window settings
      remember_window_size = true;
      initial_window_width = 640;
      initial_window_height = 400;

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = -1;

      # Scrollback
      scrollback_lines = 2000;
      wheel_scroll_multiplier = 5.0;
    };

    # Color scheme will be set via catppuccin module
    # Additional settings can be added here if needed
  };
}
