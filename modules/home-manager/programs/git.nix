{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Patryk Grabowski";
        email = "grabowskip@icloud.com";
      };

      blame = {
        coloring = "highlightRecent";
        date = "relative";
      };

      log = {
        abbrevCommit = true;
        graphColors = "blue,yellow,cyan,magenta,green,red";
      };

      pull = {
        rebase = true;
        default = "current";
      };

      push = {
        autoSetupRemote = true;
        default = "current";
        followTags = true;
      };

      rebase = {
        autoStash = true;
        missingCommitsCheck = true;
      };

      core = {
        compression = 9;
        fsync = "none";
        whitespace = "error";
        preloadindex = true;
      };

      commit = {
        verbose = true;
      };

      advice = {
        addEmptyPathspec = false;
        pushNonFastForward = false;
        statusHints = false;
      };

      init = {
        defaultBranch = "main";
      };

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };

      diff = {
        context = 3;
        renames = "copies";
        interHinkContext = 10;
      };

      branch = {
        sort = "-commiterdate";
      };

      tag = {
        sort = "-commiterdate";
      };

      color.blame = {
        highlightRecent = "black bold,1 year ago,white,1 month ago,default,7 days ago,blue";
      };

      color.branch = {
        current = "magenta";
        local = "default";
        remote = "yellow";
        upstream = "green";
        plain = "blue";
      };

      color.diff = {
        meta = "black bold";
        frag = "magenta";
        context = "white";
        whitespace = "yellow reverse";
        old = "red";
      };

      color.decorate = {
        HEAD = "red";
        branch = "blue";
        tag = "yellow";
        remoteBranch = "magenta";
      };
    };

    ignores = [
      "**/.envrc"
      "**/.direnv"
      "**/shell.nix"
      "**/gemset.nix"
      "**/dump.rdb"
      "**/.history"
      ".venv/"
      ".mypy_cache/"
      ".pytest_cache/"
      "__pycache__/"
      ".hypothesis/"
      ".ruff_cache/"
      ".ropeproject/"
      "node_modules/"
    ];
  };
}
