{
  description = "My development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        nvim-wrapper = pkgs.writeShellScriptBin "nvim" ''
          XDG_CONFIG_HOME=${toString ./.}
          ${pkgs.neovim}/bin/nvim "$@"
        '';
      in
      {
        packages = {
          nvim = nvim-wrapper;
          default = self.packages.${system}.nvim;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (pkgs.writeShellScriptBin "nvim-dev" ''
              ${self.packages.${system}.nvim}/bin/nvim "$@"
            '')
            stylua
          ];
        };
      })
    // {
      homeManagerModules = {
        dot013-environment = import ./module.nix;
        default = self.homeManagerModules.dot013-environment;
      };
      homeManagerModule = self.homeManagerModules.dot013-environment;
    };
}
