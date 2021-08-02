{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { nixpkgs, self }:
    let
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forAllSystems' = systems: fun: nixpkgs.lib.genAttrs systems fun;
      forAllSystems = forAllSystems' supportedSystems;
    in
      with nixpkgs.lib;
      {
        overlays.poliscoops =
          final: prev:
          {
            poliscoops-htdocs = final.callPackage ./htdocs {};
            docsplit = final.callPackage ./backend/docksplit/default.nix {};
          };
        
        packages = forAllSystems (system:
          let
            pkgs = import nixpkgs
              { inherit system;
                overlays = mapAttrsToList (_: id) self.overlays;
              };
          in
            {
              inherit (pkgs)
                poliscoops-htdocs
                docsplit;
            }
        );

        nixosModules.poliscoops = import ./module.nix;

        nixosModule = self.nixosModules.poliscoops;

        nixosConfigurations =
          { container = nixosSystem {
              system = "x86_64-linux";

              modules = [
                self.nixosModule
                ({ ... }:
                  {
                    boot.isContainer = true;
                    nixpkgs.overlays = [ self.overlays.poliscoops ];
                    
                    services.poliscoops = {
                      enable = true;

                      virtualLocations =
                        { localhost = "/"; };
                    };

                    networking.firewall.enable = false;
                  })
              ];
            };
          };
      };
}
