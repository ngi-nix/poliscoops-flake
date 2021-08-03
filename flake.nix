{
  description =
    "PoliScoops helps you keep track of political news in the 27 Member States of the EU, as well as the political news from the EU Parliament and the UK.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    with nixpkgs.lib; {
      overlays.poliscoops = final: prev: {
        poliscoops-htdocs = final.callPackage ./htdocs { };
        docsplit = final.callPackage ./backend/docsplit { };
      };

      packages = utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = mapAttrsToList (_: id) self.overlays;
          };
        in { inherit (pkgs) poliscoops-htdocs docsplit; });

      nixosModules.poliscoops = import ./module.nix;

      nixosModule = self.nixosModules.poliscoops;

      nixosConfigurations = {
        container = nixosSystem {
          system = "x86_64-linux";

          modules = [
            self.nixosModule
            ({ ... }: {
              boot.isContainer = true;
              nixpkgs.overlays = [ self.overlays.poliscoops ];

              services.poliscoops = {
                enable = true;

                virtualLocations = { localhost = "/"; };
              };

              networking.firewall.enable = false;
            })
          ];
        };
      };
    };
}
