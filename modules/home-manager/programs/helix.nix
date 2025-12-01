{pkgs, ...}: {
  home.packages = with pkgs; [
    vscode-langservers-extracted
    yaml-language-server
    taplo
    nil
    nixpkgs-fmt
    alejandra
    lua-language-server
    tinymist
  ];
  programs.helix = {
    enable = true;

    settings = {
      editor = {
        auto-completion = false;
        auto-format = true;
        scrolloff = 10;
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        true-color = true;
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "disable";
        };
        search = {
          wrap-around = true;
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "block";
        };
        indent-guides = {
          render = true;
          character = "·";
        };
        bufferline = "multiple";
        file-picker = {
          hidden = false;
        };
      };
    };
    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
        }
        {
          name = "toml";
          auto-format = true;
        }
        {
          name = "typst";
          language-servers = ["tinymist"];
        }
        {
          name = "python";
          auto-format = true;
        }
      ];

      language-server.nil = {
        command = "nil";
        config = {
          nix = {
            flake = {
              autoEvalInputs = true;
              autoArchive = true;
            };
            maxMemoryMB = 8192;
          };

          formatting.command = [
            "alejandra"
            "--"
          ];
        };
      };
    };
  };
}
