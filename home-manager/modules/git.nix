{
  programs.git = {
    enable = true;
    userName = "Patryk Grabowski";
    userEmail = "grabowskip@icloud.com";

    ignores = [
      "**/.envrc"  
      "**/.direnv"
      "**/shell.nix"
      "**/gemset.nix"
      "**/dump.rdb"
      "**/.history"
    ];
  };
}
