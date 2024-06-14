{ config
, lib
, ...
}:
let
  cfg = config.dot013.environment.starship;
in
{
  imports = [ ];
  options.dot013.environment.starship = with lib;
    with lib.types; {
      enable = mkOption {
        type = bool;
        default = true;
      };
    };
  config = with lib;
    mkIf cfg.enable {
      programs.starship.enable = true;
      programs.starship.enableZshIntegration = mkIf config.dot013.environment.zsh.enable true;
    };
}
