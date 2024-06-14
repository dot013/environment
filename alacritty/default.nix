{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.dot013.environment.alacritty;
in
{
  imports = [ ];
  options.dot013.environment.alacritty = with lib;
    with lib.types; {
      enable = mkOption {
        type = bool;
        default = true;
      };
    };
  config = with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      programs.alacritty = {
        enable = mkDefault true;
        settings = {
          shell.program = "${config.programs.zsh.package}/bin/zsh";
          shell.args = [ "--login" ];
          window = {
            padding.x = 5;
            padding.y = 5;
          };
          font = {
            normal = {
              family = "FiraCode Nerd Font";
              style = "Regular";
            };
            size = 10;
          };
        };
      };
    };
}
