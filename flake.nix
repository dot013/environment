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
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            stylua
          ];
        };
      })
    // {
      nixosModules = {
        dot013-environment = import ./configuration.nix;
        default = self.nixosModules.dot013-environment;
      };
      homeManagerModules = {
        dot013-environment = import ./home.nix;
        default = self.homeManagerModules.dot013-environment;
      };
      homeManagerModule = self.homeManagerModules.dot013-environment;
    };
}
