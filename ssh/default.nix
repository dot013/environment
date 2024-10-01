{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  cfg = config.dot013.environment.ssh;
in {
  imports = [];
  options.dot013.environment.ssh = with lib;
  with lib.types; {
    enable = mkOption {
      type = bool;
      default = true;
    };
    devices = let
      defaultMosh =
        args.osConfig.dot013.environment.mosh.enable;
    in {
      createAliases = mkOption {
        type = bool;
        default = true;
      };
      "battleship" = {
        hostname = mkOption {
          type = str;
          default = "0.0.0.0";
        };
        user = mkOption {
          type = str;
          default = config.home.username;
        };
        identity = mkOption {
          type = str;
          default = "${config.home.homeDirectory}/.ssh/battleship";
        };
        mosh = mkOption {
          type = bool;
          default = defaultMosh;
        };
      };
      "cruiser" = {
        hostname = mkOption {
          type = str;
          default = "0.0.0.0";
        };
        user = mkOption {
          type = str;
          default = config.home.username;
        };
        identity = mkOption {
          type = str;
          default = "${config.home.homeDirectory}/.ssh/cruiser";
        };
        mosh = mkOption {
          type = bool;
          default = defaultMosh;
        };
      };
      "figther" = {
        hostname = mkOption {
          type = str;
          default = "0.0.0.0";
        };
        user = mkOption {
          type = str;
          default = config.home.username;
        };
        identity = mkOption {
          type = str;
          default = "${config.home.homeDirectory}/.ssh/fighter";
        };
        mosh = mkOption {
          type = bool;
          default = defaultMosh;
        };
      };
      "spacestation" = {
        hostname = mkOption {
          type = str;
          default = "0.0.0.0";
        };
        user = mkOption {
          type = str;
          default = config.home.username;
        };
        identity = mkOption {
          type = str;
          default = "${config.home.homeDirectory}/.ssh/spacestation";
        };
        mosh = mkOption {
          type = bool;
          default = defaultMosh;
        };
      };
    };
  };
  config = with lib;
    mkIf cfg.enable {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "battleship" = with cfg.devices.battleship; {
            hostname = hostname;
            user = user;
            identityFile = identity;
            identitiesOnly = true;
            extraOptions = {RequestTTY = "yes";};
          };
          "cruiser" = with cfg.devices.cruiser; {
            hostname = hostname;
            user = user;
            identityFile = identity;
            identitiesOnly = true;
            extraOptions = {RequestTTY = "yes";};
          };
          "figther" = with cfg.devices.figther; {
            hostname = hostname;
            user = user;
            identityFile = identity;
            identitiesOnly = true;
            extraOptions = {RequestTTY = "yes";};
          };
          "spacestation" = with cfg.devices.spacestation; {
            hostname = hostname;
            user = user;
            identityFile = identity;
            identitiesOnly = true;
            extraOptions = {RequestTTY = "yes";};
          };
        };
      };

      programs.zsh.shellAliases = let
        mosh = "${pkgs.mosh}/bin/mosh";
        tmux = "${config.programs.tmux.package}/bin/tmux";
      in
        with lib.attrsets;
          (mapAttrs (n: v: "${mosh} ${n} -- ${tmux} a"))
          cfg.devices;
    };
}
