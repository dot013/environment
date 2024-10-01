{
  config,
  lib,
  ...
} @ args: let
  cfg = config.dot013.environment;
in {
  imports = [
    ./alacritty
    ./direnv
    ./lf
    ./git
    ./nvim
    ./starship
    ./ssh
    ./tmux
    ./zsh
  ];
  options.dot013.environment = with lib;
  with lib.types; {
    enable = mkOption {
      type = bool;
      default = args.osConfig.dot013.environment.enable or false;
    };
  };
  config = with lib;
    mkIf cfg.enable {};
}
