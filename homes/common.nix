{...}: {
  # TODO: move more here
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
      # don't (fully) support using superior indention
      "{*.yml,*.yaml,*.nim}" = {
        indent_style = "space";
      };
      "{*.nix}" = {
        indent_style = "space";
        indent_size = 2;
      };
    };
  };
}
