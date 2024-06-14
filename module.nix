{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dot013.environment;
in
{
  options.dot013.environment = with lib;
    with lib.types; {
      enable = mkEnableOption "";
    };
  config = with lib;
    mkIf cfg.enable {
    };
}
