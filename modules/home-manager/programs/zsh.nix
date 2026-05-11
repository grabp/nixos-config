{
  pkgs,
  config,
  hostname,
  ...
}:

let
  mkZshInit =
    name: cmd:
    pkgs.runCommand "${name}-zsh-init" { } ''
      ${cmd} > $out
    '';
  zshInits = {
    zoxide = mkZshInit "zoxide" "${pkgs.zoxide}/bin/zoxide init zsh";
    direnv = mkZshInit "direnv" "${pkgs.direnv}/bin/direnv hook zsh";
    fzf = mkZshInit "fzf" "${pkgs.fzf}/bin/fzf --zsh";
  };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    localVariables = {
      EDITOR = "nvim";
    };

    shellAliases =
      let
        flakeDir = "~/nixos-config";
      in
      {
        rb = (
          if pkgs.stdenv.isDarwin then
            "sudo darwin-rebuild switch --flake ${flakeDir}#${hostname}"
          else
            "sudo nixos-rebuild switch --flake ${flakeDir}#${hostname}"
        );
        upd = "nix flake update --flake ${flakeDir}";
        upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}#${hostname}";

        # Zellij
        zd = "zellij --layout ~/default.kdl";

        ls = "eza --icons";
        ll = "eza -lah --icons";
        tree = "eza -lah --tree --icons --level 3 --ignore-glob 'node_modules|.git|.DS_Store|.nvm|.turbo'";

        cat = "bat --paging=never";
        less = "bat";

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
        # Completions (synchronous — must run before compinit)
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions"

        # Synchronous — calls compinit internally, must run with ez-compinit in scope
        "Aloxaf/fzf-tab"

        # Defer engine — must precede any kind:defer plugin
        "romkatv/zsh-defer"

        # Deferred — ZLE-only, safe to load after first prompt
        "zsh-users/zsh-autosuggestions kind:defer"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "so-fancy/diff-so-fancy kind:defer"

        # Catppuccin Powerlevel10k theme (reads zstyle set in envExtra)
        "tolkonepiu/catppuccin-powerlevel10k-themes"

        # OMZ deps (synchronous — aliases needed immediately)
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/extract"
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "ohmyzsh/ohmyzsh path:plugins/aws"
        "ohmyzsh/ohmyzsh path:plugins/docker"
        "ohmyzsh/ohmyzsh path:plugins/docker-compose"
        "ohmyzsh/ohmyzsh path:plugins/podman"
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
            # Enable Powerlevel10k instant prompt — must come before anything that writes to stdout
            [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]] && \
              source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"

            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

            # GPG agent SSH support
            export GPG_TTY=$(tty)
            export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
            gpgconf --launch gpg-agent 2>/dev/null || true

            # Darwin doesn't use envExtra for some reason, so we duplicate it here
            export FZF_DEFAULT_OPTS=" \
      --color=bg+:#313244,bg:-1,spinner:#F5E0DC,hl:#F38BA8 \
      --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
      --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
      --color=selected-bg:#45475A \
      --color=border:#6C7086,label:#CDD6F4"

            export PATH="$HOME/.rd/bin:$PATH"

            # fzf https://github.com/Aloxaf/fzf-tab
            zstyle ':completion:*:git-checkout:*' sort false
            zstyle ':completion:*:descriptions' format '[%d]'
            zstyle ':completion:*' menu no
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
            zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#45475a,border:#313244,label:#cdd6f4
            zstyle ':fzf-tab:*' switch-group '<' '>'
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

            # FSH theme — deferred so FSH is loaded first
            [[ -f "${config.xdg.cacheHome}/fast-syntax-highlighting/current_theme.zsh" ]] || \
              (( ''${+functions[zsh-defer]} )) && zsh-defer fast-theme XDG:catppuccin-mocha

            _fnm_load() {
              unfunction _fnm_load node npm npx fnm 2>/dev/null
              eval "$(command fnm env --use-on-cd --shell zsh)"
            }
            fnm()  { _fnm_load; fnm  "$@"; }
            node() { _fnm_load; node "$@"; }
            npm()  { _fnm_load; npm  "$@"; }
            npx()  { _fnm_load; npx  "$@"; }

            # Pre-generated init scripts — sourced from nix store, no subprocess at shell start
            source ${zshInits.zoxide}
            source ${zshInits.direnv}
            source ${zshInits.fzf}

            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

            ${
              if pkgs.stdenv.isDarwin then
                ''
                  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
                ''
              else
                ''
                  export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
                ''
            }
    '';
    profileExtra =
      if pkgs.stdenv.isDarwin then
        ''
          eval "$(/opt/homebrew/bin/brew shellenv zsh)"
        ''
      else
        "";
  };

  home.packages = [ pkgs.zsh-powerlevel10k ];
  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
