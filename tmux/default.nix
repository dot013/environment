{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dot013.environment.tmux;
  PATHS =
    lib.strings.concatMapStringsSep " "
      (p: (builtins.replaceStrings [ "~/" ] [ "${config.home.homeDirectory}/" ] p))
      cfg.sessionizer.paths;
  sessionizer = pkgs.writeShellScriptBin "sessionizer" ''
    function tmux() { ${pkgs.tmux}/bin/tmux "$@"; }
    function fzf() { ${pkgs.fzf}/bin/fzf "$@"; }

    PATHS="${PATHS}"

    ${builtins.readFile ./sessionizer.sh}
  '';
in
{
  imports = [ ];
  options.dot013.environment.tmux = with lib;
    with lib.types; {
      enable = mkOption {
        type = bool;
        default = true;
      };
      sessionizer = {
        enable = mkOption {
          type = bool;
          default = true;
        };
        paths = mkOption {
          type = listOf str;
          default = [ ];
        };
        package = mkOption {
          type = package;
          default = sessionizer;
        };
      };
    };
  config = with lib;
    mkIf cfg.enable {
      programs.tmux.enable = true;
      programs.tmux.baseIndex = 1;
      programs.tmux.extraConfig = ''
        ${builtins.readFile ./tmux.conf}
        ${
          if cfg.sessionizer.enable
          then "bind -T prefix g run-shell \"tmux neww ${cfg.sessionizer.package}/bin/sessionizer\""
          else ""
        }
      '';
      programs.tmux.keyMode = "vi";
      programs.tmux.newSession = true;
      programs.tmux.mouse = true;
      programs.tmux.prefix = "C-Space";
      programs.tmux.plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin.overrideAttrs (_: {
            src = fetchFromGitHub {
              owner = "guz013";
              repo = "frappuccino-tmux";
              rev = "4255b0a769cc6f35e12595fe5a33273a247630aa";
              sha256 = "0k8yprhx5cd8v1ddpcr0dkssspc17lq2a51qniwafkkzxi3kz3i5";
            };
          });
        }
        { plugin = tmuxPlugins.better-mouse-mode; }
        {
          plugin = tmuxPlugins.mkTmuxPlugin {
            pluginName = "tmux.nvim";
            version = "unstable-2024-04-05";
            src = fetchFromGitHub {
              owner = "aserowy";
              repo = "tmux.nvim";
              rev = "63e9c5e054099dd30af306bd8ceaa2f1086e1b07";
              sha256 = "0ynzljwq6hv7415p7pr0aqx8kycp84p3p3dy4jcx61dxfgdpgc4c";
            };
          };
        }
        { plugin = tmuxPlugins.resurrect; }
        { plugin = tmuxPlugins.continuum; }
      ];
      programs.tmux.shell = "${config.programs.zsh.package}/bin/zsh";
      programs.tmux.terminal = "screen-256color";
    };
}
