{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dot013.environment.neovim;
in {
  imports = [];
  options.dot013.environment.neovim = with lib;
  with lib.types; {
    enable = mkOption {
      type = bool;
      default = true;
    };
  };
  config = with lib;
    mkIf cfg.enable {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        defaultEditor = true;
        package = pkgs.neovim-unwrapped;
      };

      home.sessionVariables = {
        EDITOR = "nvim";
      };

      home.packages = with pkgs; [
        git
        lazygit
        gcc
        wget
        nixpkgs-fmt
        nixpkgs-lint
        alejandra
        shellharden
        ripgrep
      ];
      /*
      home.file."${config.xdg.configHome}/nvim" = {
        source = ./.;
        recursive = true;
      };
      */
    };
}
