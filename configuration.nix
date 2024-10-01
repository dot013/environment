{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dot013.environment;
in {
  imports = [];
  options.dot013.environment = with lib;
  with lib.types; {
    enable = mkEnableOption "";
    interception-tools.enable = mkOption {
      type = bool;
      default = true;
    };
    interception-tools.devices = mkOption {
      type = listOf str;
      default = [];
    };
    mosh.enable = mkOption {
      type = bool;
      default = true;
    };
  };
  config = with lib;
    mkIf cfg.enable {
      services.interception-tools = mkIf cfg.interception-tools.enable {
        enable = true;
        plugins = [pkgs.interception-tools-plugins.caps2esc];
        udevmonConfig = with builtins;
          concatStringsSep "\n" (map (device: ''
              - JOB: "${pkgs.interception-tools}/bin/intercept -g ${device} | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 2 | ${pkgs.interception-tools}/bin/uinput -d ${device}"
                DEVICE:
                  EVENTS:
                    EV_KEY: [[KEY_CAPSLOCK, KEY_ESC]]
                  LINK: ${device}
            '')
            cfg.interception-tools.devices);
      };

      programs.mosh = mkIf cfg.mosh.enable {
        enable = true;
      };

      environment.sessionVariables = {
        EDITOR = mkDefault "nvim";
      };

      environment.pathsToLink = [" /share/zsh "];

      programs.zsh.enable = mkDefault true;

      # So mason.nvim can work properly
      programs.nix-ld.enable = mkDefault true;

      fonts.fontconfig.enable = mkDefault true;
      fonts.packages = with pkgs; [
        fira-code
        (nerdfonts.override {fonts = ["FiraCode"];})
      ];
    };
}
