{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dot013.environment.lf;
in
{
  imports = [ ];
  options.dot013.environment.lf = with lib;
    with lib.types; {
      enable = mkOption {
        type = bool;
        default = true;
      };
    };
  config = with lib;
    mkIf cfg.enable {
      programs.lf.enable = true;
      programs.lf.commands = {
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        mkfile = ''
          ''${{
            printf "Dirname: "
            read DIR

            if [[ $DIR = */ ]]; then
              mkdir $DIR
            else
              touch $DIR
            fi
          }}'';
      };
      programs.lf.extraConfig =
        let
          previewer = pkgs.writeShellScriptBin "pv.sh" ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5

            if [[ "$(${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
            fi

            ${pkgs.pistol}/bin/pistol "$file"
          '';
          cleaner = pkgs.writeShellScriptBin "clean.sh" ''
            ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
          '';
        in
        mkDefault ''
          set cleaner ${cleaner}/bin/clean.sh
          set previewer ${previewer}/bin/pv.sh
        '';
    };
}
