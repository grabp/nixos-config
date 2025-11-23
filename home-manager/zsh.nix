{ config, ... }:

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
      FZF_DEFAULT_OPTS=" \
      --color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
      --color=selected-bg:#45475a \
      --color=border:#313244,label:#cdd6f4";
    };   
 
    shellAliases =
      let
        flakeDir = "~/nixos-config";
        configuration = "BD-1";
      in {
      rb = "sudo nixos-rebuild switch --flake ${flakeDir}#${configuration}";
      upd = "nix flake update ${flakeDir}";
      upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

      hms = "home-manager switch --flake ${flakeDir}";

      conf = "nvim ${flakeDir}/nixos/configuration.nix";
      pkgs = "nvim ${flakeDir}/nixos/packages.nix";

      ll = "ls -l";
      ".." = "cd ..";
      vim = "nvim";
      v = "nvim";
      se = "sudoedit";
      ff = "fastfetch";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };

    # siteFunctions = {
    #   mkcd = ''
    #     mkdir --parents "$1" && cd "$1"
    #   '';
    #   batdiff = ''
    #     git diff --name-only --relative --diff-filter=d | xargs bat --pager='less -R' --diff
    #   '';
    # };

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

    initContent = ''
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

      # # | ftb-tmux-popup
      # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      # zstyle ':fzf-tab:*' popup-min-size 80 12
    '';
    profileExtra = ''
    '';
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };
}
