{ config, hostname, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = { 
      enable = true;
      highlighters = ["main" "brackets" "pattern"];
      styles = {
        "single-hyphen-option" = "fg=magenta,bold";
        "double-hyphen-option" = "fg=yellow";
      };
    };

    localVariables = {
      ZSH_TMUX_AUTOSTART = true;
    };   
 
    shellAliases =
      let
        flakeDir = "~/nixos-config";
      in {
      rb = "sudo nixos-rebuild switch --flake ${flakeDir}#${hostname}";
      rbb = "sudo nixos-rebuild --install-bootloader boot --flake ${flakeDir}#${hostname}";

      upd = "nix flake update ${flakeDir}";
      upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

      # Home-manager
      hms = "home-manager switch --flake ${flakeDir}";

      # Edit Configs
      conf = "nvim ${flakeDir}/nixos/configuration.nix";
      pkgs = "nvim ${flakeDir}/nixos/packages.nix";

      ls = "eza --icons";
      ll = "eza -lah --icons";
      tree = "eza -lah --tree --icons --level = 3 --ignore-glob = 'node_modules|.git|.DS_Store|.nvm|.turbo'";

      cat = "bat";
      less = "bat --pager = 'less -RF'";

      cd = "z";
      ".." = "z ..";
      "..." = "z ...";
      
      vim = "nvim";
      v = "nvim";
      se = "sudoedit";

      ff = "fastfetch";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      append = true;
      expireDuplicatesFirst = true;
      findNoDups = true;
      ignoreAllDups = true;
      share = true;
      ignoreSpace = true;
    };

    # Plugin manager
    antidote = {
      enable = true;
      plugins = [
        # Completions
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "Aloxaf/fzf-tab"
        "zdharma-continuum/fast-syntax-highlighting"
        "so-fancy/diff-so-fancy"

        # OMZ deps
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:plugins/git"
        # "ohmyzsh/ohmyzsh path:plugins/nvm"
        "ohmyzsh/ohmyzsh path:plugins/extract"
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
        "ohmyzsh/ohmyzsh path:plugins/tmux"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
      ];
      useFriendlyNames = true;
    };

    # Loaded first
    envExtra = ''
      export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:-1,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

      export PATH="$HOME/.rd/bin:$PATH"
    '';
    initContent = ''
      # Darwin doesn't use envExtra for some reason, so we duplicate it here
      export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:-1,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

      export PATH="$HOME/.rd/bin:$PATH"

      # fzf https://github.com/Aloxaf/fzf-tab
      # # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

      zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#45475a,border:#313244,label:#cdd6f4
      # zstyle ':fzf-tab:*' use-fzf-default-opts yes

      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # | ftb-tmux-popup
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' popup-min-size 80 12

      # Utils 
      timezsh() {
        shell=''${1-$SHELL}
        for i in $(seq 1 10); do time $shell -i -c exit; done
      }
      batdiff() {
        git diff --name-only --relative --diff-filter=d | xargs bat --pager='less -R' --diff
      }

      # Fast Syntax Highlighting Colors
      fast-theme XDG:catppuccin-mocha > /dev/null
    '';
    profileExtra = ''
    '';
  };
}
