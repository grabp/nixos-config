{
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      add_newline = true;
      command_timeout = 500;

      character = {
        success_symbol = "[[󰄛](teal) ❯](peach)";
        error_symbol = "[[󰄛](red) ❯](peach)";
        vimcmd_symbol = "[󰄛 ❮](subtext1)";
      };

      git_branch = {
        style = "bold muave";
      };

      directory = {
        truncation_length = 4;
        style = "bold lavender";
      };
    };
  };
}
