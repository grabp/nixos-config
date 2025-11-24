{ ... }:

{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ../waybar/style.css;

    settings = [{
      layer = "top";
      position = "top";

      # Modules
      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        # TODO: check out if it's better than custom/music
        "custom/music"
      ];
      modules-right = [
        "power-profiles-daemon"
        "network"
        "cpu"
        "memory"
        "temperature"

        "pulseaudio"
        "clock"

        "tray"

        "custom/lock"
        "custom/power"
      ];
      "hyprland/workspaces" = {
        disable-scroll = true;
        sort-by-name = true;
        format = " {icon} ";
        format-icons = {
          default = "";
        };
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };

      cpu = {
        interval = 10;
        # format = "󰻠 {}%";
        format = "  {usage}%";
        # max-length = 10;
        min-length = 5;
        format-alt-click = "click";
        format-alt = "{icon0}{icon1}{icon2}{icon3} {usage:>2}% 󰍛";
        format-icons = [
            "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"
        ];
        on-click-right = "wezterm -e btop";
      };
      memory = {
        interval = 30;
        format = "  {}%";
        format-alt = "  {used:0.1f}G";
        max-length = 10;
        on-click-right = "wezterm -e btop";
      };
      "custom/music" = {
        format = "  {}";
        escape = true;
        interval = 5;
        tooltip = false;
        exec = "playerctl metadata --format='{{ title }}'";
        on-click = "playerctl play-pause";
      }; 
      pulseaudio = {
          # // scroll-step = 1; // %; can be a float
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "";
          format-icons = {
              default = ["" "" " "];
          };
          on-click = "pavucontrol";
      };
      network = {
        format-wifi = "  {essid} ({signalStrength}%)";
        format-ethernet = "  {ipaddr}/{cidr}";
        tooltip-format = "  {ifname} via {gwaddr}";
        format-linked = "  {ifname} (No IP)";
        format-disconnected = "⚠  Disconnected";
        format-alt = "{ifname} = {ipaddr}/{cidr}";
      };

      clock = {
        timezone = "Europe/Warsaw";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
      };

      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile = {profile}\nDriver = {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };
      "custom/power" = {
        format  = "⏻";
        tooltip = false;
        menu = "on-click";
        menu-file = "$HOME/.config/waybar/power_menu.xml";
        menu-actions = {
          shutdown = "shutdown";
          reboot = "reboot";
          suspend = "systemctl suspend";
          hibernate = "systemctl hibernate";
        };
      };
      "custom/lock" = {
        tooltip = false;
        on-click = "hyprlock";
        format = "";
      };

    }];
  };
}
