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
    };   
 
    shellAliases =
      let
        flakeDir = "~/nixos-config";
      in {
      rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
      upd = "nix flake update ${flakeDir}";
      upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

      hms = "home-manager switch --flake ${flakeDir}";

      conf = "nvim ${flakeDir}/nixos/configuration.nix";
      pkgs = "nvim ${flakeDir}/nixos/packages.nix";

      ll = "ls -l";
      vim = "nvim";
      se = "sudoedit";
      ff = "fastfetch";
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "tmux" "direnv" "fzf" "command-not-found" "compleat" ];
      theme = "risto";
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };
}
