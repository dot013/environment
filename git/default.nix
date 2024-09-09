{
  config,
  lib,
  ...
}: let
  cfg = config.dot013.environment.git;
in {
  imports = [];
  options.dot013.environment.git = with lib;
  with lib.types; {
    enable = mkOption {
      type = bool;
      default = true;
    };
    delta = mkOption {
      type = bool;
      default = true;
    };
    lazygit = mkOption {
      type = bool;
      default = true;
    };
    gpgsign = mkOption {
      type = bool;
      default = true;
    };
  };
  config = let
    delta = config.programs.git.delta.package;
  in
    with lib;
      mkIf cfg.enable {
        programs.git = {
          enable = true;
          signing = mkIf cfg.gpgsign {
            key = null;
            signByDefault = true;
          };
          userEmail = "contact@guz.one";
          userName = "Gustavo L de Mello (Guz)";
          extraConfig = {
            credential.helper = "store";
          };
        };

        programs.gpg = mkIf cfg.gpgsign {
          enable = true;
          mutableKeys = true;
          mutableTrust = true;
        };
        services.gpg-agent = mkIf cfg.gpgsign {
          enable = true;
          enableZshIntegration = config.dot013.environment.zsh.enable;
          enableBashIntegration = config.dot013.environment.zsh.enable;
          defaultCacheTtl = 3600 * 24;
        };

        programs.git.delta = mkIf cfg.delta {
          enable = true;
        };

        programs.lazygit = mkIf cfg.lazygit {
          enable = true;
          settings = {
            git.paging = mkIf cfg.delta {
              colorArg = "always";
              pager = "${delta}/bin/delta --dark --paging=never";
            };
          };
        };
      };
}
