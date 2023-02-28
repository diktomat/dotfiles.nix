{
	config,
	pkgs,
	...
}: {
	home.stateVersion = "22.11";
	editorconfig = {
		enable = true;
		settings = {
			"*" = {
				charset = "utf-8";
				end_of_line = "lf";
				trim_trailing_whitespace = true;
				insert_final_newline = true;
				max_line_width = 78;
				indent_style = "tab";
				indent_size = 4;
			};
			"{*.yml,*.yaml,*.nim}" = { # don't support using superior indention
				indent_style = "space";
			};
		};
	};
	home.packages = with pkgs; [bacon comma fd ripgrep];
	home.file."Library/Application Support/org.dystroy.bacon/prefs.toml".source = ./extraConfig/bacon.toml;
	# launchd.enable = true;
	# launchd.agents.nix-index = {}; TODO: launchd weekly nix-index update
	programs = {
		bat = {
			enable = true;
			config = {
				theme = "catpuccin-macchiato";
				italic-text = "always";
			};
			themes = {
				catpuccin-macchiato = builtins.readFile (pkgs.fetchFromGitHub {
						owner = "catppuccin";
						repo = "bat";
						rev = "ba4d168";
						sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
					}
					+ "/Catppuccin-macchiato.tmTheme");
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
		fish = {
			# TODO: fish complete config
			enable = true;
			functions = {};
			interactiveShellInit = ''
				function last_history_item; echo $history[1]; end
				abbr !! --position anywhere --function last_history_item
				abbr --set-cursor clippy-ped cargo clippy % -- -W clippy::pedantic -Aclippy::must_use_candidate -Aclippy::missing_panics_doc -Wclippy::nursery
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
			defaultOptions = ["--ansi" "--tabstop=4" "--preview='bat -p --color=always {}'" "--info=inline" "--tiebreak=length"];
			fileWidgetCommand = "${pkgs.fd}/bin/fd --hidden --color always --search-path \$dir";
			fileWidgetOptions = [];
			historyWidgetOptions = ["--preview 'echo {} |bat -l fish -p --color=always'" "--preview-window=down:3:wrap" "--reverse"];
		};
		git = {
			enable = true;
			aliases = {
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
			ignores = [ # TODO: gitignore auslagern?
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
			];
			signing.signByDefault = true;
			signing.key = "50027A3368AA398E";
			userEmail = "d12bb@posteo.de";
			userName = "Benedikt Müller";
			# delta = {
			#   enable = true;
			#   options = {
			#       line-numbers = true;
			#       syntax-theme = "catppuccin-macchiato";
			#       side-by-side = true;
			#   };
			# };
		};
		gitui.enable = true;
		gpg.enable = true;
		helix = {
			enable = true;
			settings = {
				theme = "base16_transparent";
				editor = {
					line-number = "relative";
					cursorline = true;
					indent-guides.render = true;
					shell = ["${pkgs.fish}/bin/fish" "-c"];
					cursor-shape.insert = "bar";
					whitespace.render.newline = "all";
					whitespace.characters.newline = "↵";
					whitespace.characters.nbsp = "+";
					keys.normal = {
						H = "goto_window_top";
						M = "goto_window_center";
						L = "goto_window_bottom";
					};
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
				shell_integration = "enabled";
				# https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
				symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E634,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF Symbols Nerd Font Mono";
				tab_activity_symbol = "!";
				tab_bar_edge = "top";
				tab_bar_style = "powerline";
				tab_powerline_style = "angled";
			};
			theme = "Catppuccin-Macchiato";
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
		ssh = {
			enable = true;
			# TODO: ssh config
		};
		starship.enable = true; # TODO: starship config
		tealdeer = {
			enable = true;
			settings.updates.auto_update = true;
		};
		vim = {
			enable = true;
			defaultEditor = true;
			extraConfig = builtins.readFile ./extraConfig/vimrc;
			plugins = with pkgs.vimPlugins; [base16-vim fzf-vim rust-vim vim-mucomplete vim-polyglot];
		};
		yt-dlp = {
			enable = true;
			settings = {
				embed-chapters = true;
				embed-metadata = true;
				embed-subs = true;
				embed-thumbnail = true;
				format-sort =  "ext";
				output = "%(title)s.%(ext)s";
				xattrs = true;
			};
		};
		zoxide.enable = true;
	};
	xdg.enable = true;
	xdg.configFile."kitty/open-actions.conf".text = ''
# Fragment == line number, fragments are generated
# by the hyperlink_grep kitten and nothing else so far.
protocol file
fragment_matches [0-9]+
action launch --type=overlay --cwd=current vim +''${FRAGMENT} ''${FILE_PATH}

# Open text files without fragments in bat
protocol file
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
	# TODO: xdg.file something for ripgreprc, don't forget setting $RIPGREP_CONFIG_PATH
}
