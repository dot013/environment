{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dot013.environment.zsh;
in
{
  imports = [ ];
  options.dot013.environment.zsh = with lib;
    with lib.types; {
      enable = mkOption {
        type = bool;
        default = true;
      };
    };
  config = with lib;
    mkIf cfg.enable {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        initExtra = ''
          export GPG_TTY=$(tty)
          ${
            if config.dot013.environment.tmux.enable
            then ''
              alias tmux="tmux -f ${config.xdg.configHome}/tmux/tmux.conf";
            ''
            else ""
          }
          alias lg="${pkgs.lazygit}/bin/lazygit";
          ${
            if config.dot013.environment.tmux.sessionizer.enable
            then let
              sessionizer = config.dot013.environment.tmux.sessionizer.package;
            in ''
              alias goto="${sessionizer}/bin/sessionizer"
              alias gt="${sessionizer}/bin/sessionizer"
            ''
            else ""
          }
        '';
      };
    };
}
