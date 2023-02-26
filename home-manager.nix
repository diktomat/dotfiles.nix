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
			"{*.yml,*.yaml,*.nim}" = {
				indent_style = "space";
			};
		};
	};
	home.packages = with pkgs; [bacon comma fd ripgrep];
	home.file."Library/Application Support/org.dystroy.bacon/prefs.toml".source = ./extraConfig/bacon.toml;
	# launchd.enable = true;
	# launchd.agents.nix-index = {}; TODO: weekly nix-index update
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
			# TODO: complete config
			enable = true;
			functions = {};
			interactiveShellInit = ''
				function last_history_item; echo $history[1]; end
				abbr !! --position anywhere --function last_history_item
				abbr --set-cursor clippy-ped cargo clippy % -- -W clippy::pedantic -Aclippy::must_use_candidate -Aclippy::missing_panics_doc -Wclippy::nursery
			'';
			loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin"; # https://github.com/LnL7/nix-darwin/issues/122
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
			changeDirWidgetCommand = "fd --hidden --color always --type directory";
			changeDirWidgetOptions = ["--preview 'lsd --color always --icon always {}'"];
			defaultCommand = "fd --hidden --color always";
			defaultOptions = ["--ansi" "--tabstop=4" "--preview='bat -p --color=always {}'" "--info=inline" "--tiebreak=length"];
			fileWidgetCommand = "fd --hidden --color always --search-path \$dir";
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
					shell = ["fish" "-c"];
					cursorshape.insert = "bar";
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
			# TODO
		};
		starship.enable = true; # TODO: config
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
}
