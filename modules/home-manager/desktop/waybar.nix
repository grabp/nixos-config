{ config, ... }:

{
  xdg.configFile."waybar/mako-count.sh" = {
    source = ../waybar/mako-count.sh;
    executable = true;
  };

  xdg.configFile."waybar/weather.sh" = {
    source = ../waybar/weather.sh;
    executable = true;
  };

  xdg.configFile."waybar/disk-io.sh" = {
    source = ../waybar/disk-io.sh;
    executable = true;
  };

  xdg.configFile."waybar/gpu-temp.sh" = {
    source = ../waybar/gpu-temp.sh;
    executable = true;
  };

  xdg.configFile."waybar/cpu-temp.sh" = {
    source = ../waybar/cpu-temp.sh;
    executable = true;
  };

  xdg.configFile."waybar/power_menu.xml" = {
    source = ../waybar/power_menu.xml;
  };

  programs.waybar = {
    enable = true;
    style = builtins.readFile ../waybar/style.css;

    settings = [{
      layer = "top";
      position = "top";

      # Modules
      modules-left = [
        "hyprland/workspaces"
        "power-profiles-daemon"
      ];
      modules-center = [
        "custom/music"
        "clock"
        "custom/weather"
      ];
      modules-right = [
        # System Performance Group
        "cpu"
        "custom/cpu-temp"
        "memory"
        "custom/gpu-temp"
        "temperature"
        
        # Storage Group
        "disk"
        # "custom/disk-io"
        
        # Connectivity & Audio Group
        # "network"
        "pulseaudio"
        
        # Notifications & Apps Group
        "custom/notification"
        "tray"
        
        # System Actions Group
        "custom/lock"
        "custom/power"
      ];
      "hyprland/workspaces" = {
        disable-scroll = true;
        sort-by-number = true;
        format = "{id}: {windows} ";
        window-rewrite = {
          # Browsers
          "class<firefox>" = "󰈹";
          "class<Firefox>" = "󰈹";
          "class<brave-browser>" = "󰊯";
          "class<Brave-browser>" = "󰊯";
          "class<chromium>" = "󰊯";
          "class<Chromium>" = "󰊯";
          "class<google-chrome>" = "󰊯";
          "class<Google-chrome>" = "󰊯";
          "class<vivaldi>" = "󰨸";
          "class<Vivaldi>" = "󰨸";
          
          # Code Editors & IDEs
          "class<cursor>" = "󰨞";
          "class<Cursor>" = "󰨞";
          "class<code>" = "󰨞";
          "class<Code>" = "󰨞";
          "class<code-oss>" = "󰨞";
          "class<VSCodium>" = "󰨞";
          "class<jetbrains-idea>" = "󰨞";
          "class<jetbrains-pycharm>" = "󰨞";
          "class<jetbrains-clion>" = "󰨞";
          "class<jetbrains-goland>" = "󰨞";
          "class<jetbrains-rubymine>" = "󰨞";
          "class<jetbrains-webstorm>" = "󰨞";
          "class<jetbrains-phpstorm>" = "󰨞";
          "class<jetbrains-fleet>" = "󰨞";
          "class<neovide>" = "󰢻";
          "class<Neovide>" = "󰢻";
          
          # Terminals
          "class<kitty>" = "󰞷";
          "class<Kitty>" = "󰞷";
          "class<alacritty>" = "󰞷";
          "class<Alacritty>" = "󰞷";
          "class<wezterm>" = "󰞷";
          "class<WezTerm>" = "󰞷";
          "class<foot>" = "󰞷";
          "class<Foot>" = "󰞷";
          "class<konsole>" = "󰞷";
          "class<Konsole>" = "󰞷";
          "class<gnome-terminal>" = "󰞷";
          "class<Gnome-terminal>" = "󰞷";
          "class<terminator>" = "󰞷";
          "class<Terminator>" = "󰞷";
          
          # Email
          "class<thunderbird>" = "󰇮";
          "class<Thunderbird>" = "󰇮";
          "class<evolution>" = "󰇮";
          "class<Evolution>" = "󰇮";
          "class<geary>" = "󰇮";
          "class<Geary>" = "󰇮";
          
          # Communication
          "class<discord>" = "󰙯";
          "class<Discord>" = "󰙯";
          "class<slack>" = "󰒱";
          "class<Slack>" = "󰒱";
          "class<telegram-desktop>" = "󰞒";
          "class<TelegramDesktop>" = "󰞒";
          "class<signal-desktop>" = "󰨀";
          "class<Signal>" = "󰨀";
          "class<element>" = "󰨀";
          "class<Element>" = "󰨀";
          "class<teams-for-linux>" = "󰍻";
          "class<Teams>" = "󰍻";
          
          # Gaming
          "class<steam>" = "󰓓";
          "class<Steam>" = "󰓓";
          "class<lutris>" = "󰓓";
          "class<Lutris>" = "󰓓";
          "class<heroic>" = "󰓓";
          "class<Heroic>" = "󰓓";
          
          # Media
          "class<spotify>" = "󰓇";
          "class<Spotify>" = "󰓇";
          "class<vlc>" = "󰎆";
          "class<VLC>" = "󰎆";
          "class<mpv>" = "󰎆";
          "class<MPV>" = "󰎆";
          "class<obs>" = "󰨁";
          "class<OBS>" = "󰨁";
          
          # File Managers
          "class<thunar>" = "󰉋";
          "class<Thunar>" = "󰉋";
          "class<nemo>" = "󰉋";
          "class<Nemo>" = "󰉋";
          "class<nautilus>" = "󰉋";
          "class<Nautilus>" = "󰉋";
          "class<dolphin>" = "󰉋";
          "class<Dolphin>" = "󰉋";
          "class<pcmanfm>" = "󰉋";
          "class<PCManFM>" = "󰉋";
          
          # Password Managers
          "class<1password>" = "󰢁";
          "class<1Password>" = "󰢁";
          "class<bitwarden>" = "󰢁";
          "class<Bitwarden>" = "󰢁";
          "class<keepassxc>" = "󰢁";
          "class<KeePassXC>" = "󰢁";
          
          # System Tools
          "class<solaar>" = "󰍽";
          "class<Solaar>" = "󰍽";
          "class<pavucontrol>" = "󰓃";
          "class<Pavucontrol>" = "󰓃";
          "class<blueman-manager>" = "󰂯";
          "class<Blueman>" = "󰂯";
          "class<gparted>" = "󰨣";
          "class<GParted>" = "󰨣";
          "class<systemsettings>" = "󰒓";
          "class<SystemSettings>" = "󰒓";
          
          # Office & Productivity
          "class<libreoffice>" = "󰈙";
          "class<LibreOffice>" = "󰈙";
          "class<libreoffice-writer>" = "󰈙";
          "class<libreoffice-calc>" = "󰈙";
          "class<libreoffice-impress>" = "󰈙";
          "class<okular>" = "󰈙";
          "class<Okular>" = "󰈙";
          "class<zathura>" = "󰈙";
          "class<Zathura>" = "󰈙";
          
          # Development Tools
          "class<gitkraken>" = "󰊢";
          "class<GitKraken>" = "󰊢";
          "class<sublime_text>" = "󰨞";
          "class<Sublime_text>" = "󰨞";
        };
        window-rewrite-default = "󰣇";
        format-window-separator = " ";
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
        on-click-right = "kitty -e btop";
      };
      memory = {
        interval = 30;
        format = "  {}%";
        format-alt = "  {used:0.1f}G";
        max-length = 10;
        on-click-right = "kitty -e btop";
      };
      disk = {
        interval = 30;
        format = "💾 {percentage_free}%";
        path = "/";
        tooltip-format = "{used}/{total} ({percentage_used}%)";
        on-click-right = "kitty -e btop";
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
        format = "{:%H:%M}";
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
        format  = " ⏻ ";
        tooltip = false;
        menu = "on-click";
        menu-file = "${config.xdg.configHome}/waybar/power_menu.xml";
        menu-actions = {
          shutdown = "systemctl poweroff";
          reboot = "systemctl reboot";
          suspend = "systemctl suspend";
          hibernate = "systemctl hibernate";
        };
      };
      "custom/notification" = {
        tooltip = false;
        format = "{}";
        return-type = "json";
        exec-if = "which makoctl";
        exec = "${config.xdg.configHome}/waybar/mako-count.sh";
        interval = 2;
        on-click = "makoctl dismiss";
        on-click-right = "makoctl dismiss-all";
      };
      "custom/lock" = {
        tooltip = false;
        on-click = "hyprlock";
        format = "  ";
      };
      "custom/weather" = {
        format = "{}";
        tooltip = true;
        exec = "${config.xdg.configHome}/waybar/weather.sh";
        interval = 1800;
        on-click = "kitty -e curl wttr.in";
      };
      "custom/disk-io" = {
        format = "{}";
        tooltip = false;
        exec = "${config.xdg.configHome}/waybar/disk-io.sh";
        interval = 2;
      };
      "custom/gpu-temp" = {
        format = "{}";
        tooltip = false;
        exec = "${config.xdg.configHome}/waybar/gpu-temp.sh";
        interval = 5;
      };
      "custom/cpu-temp" = {
        format = "{}";
        tooltip = false;
        exec = "${config.xdg.configHome}/waybar/cpu-temp.sh";
        interval = 5;
      };

    }];
  };
}
