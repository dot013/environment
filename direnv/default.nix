{ config
, lib
, ...
}:
let
  cfg = config.dot013.environment.direnv;
in
{
  imports = [ ];
  options.dot013.environment.direnv = with lib;
    with lib.types; {
      enable = mkOption {
        type = bool;
        default = true;
      };
    };
  config = with lib;
    mkIf cfg.enable {
      programs.direnv.enable = true;
      programs.direnv.enableZshIntegration = true;
      programs.direnv.nix-direnv.enable = true;
    };
}
