{
  description = "My development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    dot013-nvim.url = "git+https://forge.capytal.company/dot013/nvim";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system: let
        pkgs = import nixpkgs {inherit system overlays;};
      in
        f system pkgs);
  in {
    nixosModules = {
      dot013-environment = import ./configuration.nix;
      default = self.nixosModules.dot013-environment;
    };
    homeManagerModules = {
      dot013-environment = import ./home.nix {inherit inputs;};
      default = self.homeManagerModules.dot013-environment;
    };
    homeManagerModule = self.homeManagerModules.dot013-environment;
    devShells = forAllSystems (system: pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          stylua
        ];
      };
    });
  };
}
