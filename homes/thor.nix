{
  config,
  darwinConfig,
  lib,
  modulesPath,
  options,
  osConfig,
  pkgs,
  specialArgs,
}: let
  toToml = pkgs.formats.toml {};
in {
  imports = [./common.nix];

  home = {
    activation = {
      installDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d "${config.xdg.configHome}/emacs" ]; then
           ${pkgs.git}/bin/git clone --depth=1 "https://github.com/doomemacs/doomemacs" "${config.xdg.configHome}/emacs"
        fi
      '';
    };

    file.".cargo/config.toml".source = toToml.generate "cargo-config" {
      registries.crates-io.protocol = "sparse";
    };
    file.".gnupg/gpg-agent.conf".text = "pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac";
    file."Library/Application Support/org.dystroy.bacon/prefs.toml".source = toToml.generate "bacon-config" {
      default_job = "nextest";
      jobs.nextest = {
        command = ["cargo" "nextest" "run" "--color" "always"];
        watch = ["test"];
        need_stdout = true;
      };
      keybindings = {
        n = "job:nextest";
        m = "job:clippy-all";
      };
    };

    packages = with pkgs; [
      alejandra
      bacon
      comma
      element-desktop
      fd
      ripgrep
      rustup

      # making `doom doctor` happy
      cmake
      editorconfig-core-c
      # jsbeautifier -> project-local
      # shellcheck   -> project-local
    ];

    sessionPath = [
      "$HOME/.local/bin"
      "${config.xdg.configHome}/emacs/bin"
    ];
    sessionVariables = {
      LESS = "--ignore-case --incsearch --HILITE-UNREAD --tabs=4 --prompt=?n?f%f.:?e?x Next\: %x:(EOF).:?p%pb\%...?m (%i/%m).";
      LESSHISTFILE = "/dev/null";
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
      RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgreprc";
      CARGO_HOME = "${config.xdg.cacheHome}/local.cargo";
      CARGO_INSTALL_ROOT = "${config.xdg.dataHome}";
      CARGO_TARGET_DIR = "$CARGO_HOME/target";
      RUSTUP_HOME = "${config.xdg.cacheHome}/local.rustup";
    };
  };

  programs = {
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
        # fish_config theme save "Catppuccin Macchiato"
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
        icat = "kitty +kitten icat";
        kdiff = "kitty +kitten diff";
        ls = "lsd";
        l = "lsd -l";
        la = "lsd -lA";
        ssh = "kitty +kitten ssh";
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
        credential.helper = "osxkeychain";
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
          # soft-wrap.enable = true;
        };
        keys.normal = {
          H = "goto_window_top";
          M = "goto_window_center";
          L = "goto_window_bottom";
        };
      };
    };
    kitty = {
      # extra config files at xdg.configFile.* below
      enable = true;
      font.package = pkgs.iosevka-bin;
      font.name = "Iosevka Term";
      font.size = 14;
      keybindings = {
        "cmd+enter" = "launch --cwd=current --type=window";
        "cmd+]" = "next_window";
        "cmd+[" = "previous_window";
        "cmd+equal" = "change_font_size current +2.0";
        "cmd+minus" = "change_font_size current -2.0";
        "cmd+0" = "change_font_size current 0";
      };
      settings = {
        disable_ligatures = "cursor";
        enabled_layouts = "tall,fat,grid,stack";
        initial_window_height = "24c";
        initial_window_width = "95c";
        macos_option_as_alt = "left";
        remember_window_size = false;
        scrollback_lines = 10000;
        scrollback_pager_history_size = 1024;
        shell_integration = "disabled";
        # https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
        symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E634,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF Symbols Nerd Font Mono";
        tab_activity_symbol = "!";
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
      };
      theme = "One Dark";
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
      extraConfig = ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
      matchBlocks."github.com" = {
        identityFile = "~/.ssh/github.pub";
        user = "git";
      };
      # matchBlocks.pi = {
      #   host = "loki.local";
      #   identityFile = "~/.ssh/loki.pub";
      #   user = "bene";
      # };
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
    yt-dlp = {
      enable = true;
      settings = {
        embed-chapters = true;
        embed-metadata = true;
        embed-subs = true;
        embed-thumbnail = true;
        format-sort = "ext";
        output = "%(title)s.%(ext)s";
        xattrs = true;
      };
    };
    zoxide.enable = true;
  };

  xdg.enable = true;
  xdg.cacheHome = "${config.home.homeDirectory}/Library/Caches";
  xdg.configFile."doom" = {
    onChange = "${pkgs.fish}/bin/fish -lc '${config.xdg.configHome}/emacs/bin/doom sync'";
    recursive = true;
    source = ../extraConfig/doom;
  };
  xdg.configFile."doom/themes/catppuccin-theme.el".text = builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "emacs";
      rev = "cc450390d0b3a8fdbb032ee96deb0aeaa1984ce0";
      sha256 = "sha256-NBenzGSPbMRPAfZWdFmrwe0MFTyMcvHLnJvYL0cXKCg=";
    }
    + "/catppuccin-theme.el"
  );
  xdg.configFile."fd/ignore".source = ../extraConfig/fdignore;
  xdg.configFile."kitty/open-actions.conf".text = ''
    # Fragment == line number, fragments are generated by the hyperlink_grep kitten and nothing else
    # so far.
    protocol file
    fragment_matches [0-9]+
    action launch --type=overlay --cwd=current vim +''${FRAGMENT} ''${FILE_PATH}

    # Open text files without fragments in bat protocol file
    mime text/*
    action launch --type=overlay --cwd=current bat --paging=always ''${FILE_PATH}

    # Open images using the icat kitten
    protocol file
    mime image/*
    action launch --type=overlay kitty +kitten icat --hold ''${FILE_PATH}
  '';
  xdg.configFile."kitty/ssh.conf".text = ''
    copy .vim .config/fish
    env EDITOR=vim
  '';
  xdg.configFile."ripgreprc".text = ''
    --engine=auto
    --smart-case
  '';
}
