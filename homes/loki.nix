{
  config,
  pkgs,
  ...
}: let
  toToml = pkgs.formats.toml {};
in {
  imports = [./common.nix];

  nixpkgs.config.allowUnfree = true;
  home = {
    username = "bene";
    homeDirectory = "/home/bene";

    packages = with pkgs; [
      alejandra
      comma
      fd
      just
      less
      ripgrep
    ];

    sessionVariables = {
      LESS = "--ignore-case --incsearch --HILITE-UNREAD --tabs=4 --prompt=?n?f%f.:?e?x Next\: %x:(EOF).:?p%pb\%...?m (%i/%m).";
      LESSHISTFILE = "/dev/null";
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
      RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgreprc";
    };
  };

  programs = {
    home-manager.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "ansi";
        italic-text = "always";
      };
    };
    broot = {
      enable = true;
      settings.default_flags = "g";
      settings.verbs = [
        {
          key = "ctrl-=";
          execution = ":stage";
        }
        {
          key = "ctrl--";
          execution = ":unstage";
        }
        {
          key = "ctrl-d";
          execution = ":focus ~/dev";
        }
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      functions = {
        brup = builtins.readFile ../extraConfig/brup.fish;
        # e = builtins.readFile ./extraConfig/e.fish;
        fkill = builtins.readFile ../extraConfig/fkill.fish;
        frg = builtins.readFile ../extraConfig/frg.fish;
        mcd = builtins.readFile ../extraConfig/mcd.fish;
      };
      interactiveShellInit = ''
        function last_history_item; echo $history[1]; end
        abbr !! --position anywhere --function last_history_item
        abbr --set-cursor clippy-ped cargo clippy % -- -W clippy::pedantic -Aclippy::must_use_candidate -Aclippy::missing_panics_doc -Wclippy::nursery
        function krg --wraps rg; kitty +kitten hyperlinked_grep $argv; end
        # Kitty shell integration, doesn't work ootb for some reason
        if set -q KITTY_INSTALLATION_DIR
            set --global KITTY_SHELL_INTEGRATION enabled
            source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
            set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
        end
      '';
      # https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
      shellInit = "test -d /opt/homebrew && eval (/opt/homebrew/bin/brew shellenv)";
      shellAbbrs = {
        cat = "bat";
        cdtmp = "cd (mktemp -d)";
        ls = "lsd";
        l = "lsd -l";
        la = "lsd -lA";
        tree = "lsd --tree";
      };
    };
    fzf = {
      enable = true;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --hidden --color always --type directory";
      changeDirWidgetOptions = ["--preview 'lsd --color always --icon always {}'"];
      defaultCommand = "${pkgs.fd}/bin/fd --hidden --color always";
      defaultOptions = [
        "--ansi"
        "--tabstop=4"
        "--preview='bat -p --color=always {}'"
        "--info=inline"
        "--tiebreak=length"
      ];
      fileWidgetCommand = "${pkgs.fd}/bin/fd --hidden --color always --search-path \$dir";
      fileWidgetOptions = [];
      historyWidgetOptions = [
        "--preview 'echo {} |bat -l fish -p --color=always'"
        "--preview-window=down:3:wrap"
        "--reverse"
      ];
    };
    git = {
      enable = true;
      aliases = {
        ci = "commit";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        since = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --reverse ORIG_HEAD..";
        st = "status";
      };
      difftastic.enable = true;
      difftastic.background = "dark";
      extraConfig = {
        init.defaultBranch = "main";
        "filter \"lfs\"" = {
          clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
          smudge = "${pkgs.git-lfs}/bin/git-lfs smudge -- %f";
          process = "${pkgs.git-lfs}/bin/git-lfs filter-process";
          required = true;
        };
      };
      ignores = [
        "Desktop.ini"
        "._*"
        "Thumbs.db"
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"
        "*.pyc"
        "*.out"
        "venv"
        "node_modules"
        ".sass-cache"
        "tags"
        "*.bak"
        ".direnv"
      ];
      signing.signByDefault = true;
      signing.key = "50027A3368AA398E";
      userEmail = "d12bb@posteo.de";
      userName = "Benedikt Müller";
    };
    gitui = {
      enable = true;
      theme = ''
        (
          selected_tab: Reset,
          command_fg: Black,
          selection_bg: Blue,
          selection_fg: Black,
          cmdbar_bg: Blue,
          cmdbar_extra_lines_bg: Blue,
          disabled_fg: DarkGray,
          diff_line_add: Green,
          diff_line_delete: Red,
          diff_file_added: LightGreen,
          diff_file_removed: LightRed,
          diff_file_moved: LightMagenta,
          diff_file_modified: Yellow,
          commit_hash: Magenta,
          commit_time: LightCyan,
          commit_author: Green,
          danger_fg: Red,
          push_gauge_bg: Blue,
          push_gauge_fg: Reset,
          tag_fg: LightMagenta,
          branch_fg: LightYellow,
        )
      '';
    };
    gpg = {
      enable = true;
      settings = {
        auto-key-retrieve = true;
        default-key = "FDD2314C902AFE16DCF6A5A301C9C6235615FB81";
      };
    };
    helix = {
      enable = true;
      # package = helix.packages.${pkgs.system}.default;
      settings = {
        theme = "onedark";
        editor = {
          cursorline = true;
          cursor-shape.insert = "bar";
          indent-guides.render = true;
          line-number = "relative";
          shell = ["${pkgs.fish}/bin/fish" "-c"];
          true-color = true;
          whitespace.characters.nbsp = "+";
          whitespace.characters.newline = "↵";
          whitespace.render.newline = "all";
          soft-wrap.enable = true;
        };
        keys.normal = {
          H = "goto_window_top";
          M = "goto_window_center";
          L = "goto_window_bottom";
        };
      };
    };
    lsd = {
      enable = true;
      settings = {
        color.theme = "default";
        date = "relative";
        hyperlink = "auto";
        sorting.dir-grouping = "first";
      };
    };
    nix-index.enable = true;
    pandoc.enable = true;
    ssh = {
      enable = true;
      matchBlocks."github.com" = {
        identityFile = "~/.ssh/github.pub";
        user = "git";
      };
    };
    starship = {
      enable = true;
      settings = {
        directory.fish_style_pwd_dir_length = 1;
        directory.read_only = " ";
        # Nerd Font Symbols
        aws.symbol = "  ";
        conda.symbol = " ";
        dart.symbol = " ";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = " ";
        nim.symbol = " ";
        nix_shell.symbol = " ";
        package.symbol = " ";
        perl.symbol = " ";
        php.symbol = " ";
        python.symbol = " ";
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        shlvl.symbol = " ";
        swift.symbol = "ﯣ ";
      };
    };
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    vim = {
      enable = true;
      defaultEditor = true;
      extraConfig = builtins.readFile ../extraConfig/vimrc;
      plugins = with pkgs.vimPlugins; [base16-vim fzf-vim rust-vim vim-mucomplete vim-polyglot];
    };
    zoxide.enable = true;
  };

  xdg.enable = true;
  xdg.configFile."fd/ignore".source = ../extraConfig/fdignore;
  xdg.configFile."ripgreprc".text = ''
    --engine=auto
    --smart-case
  '';
}
