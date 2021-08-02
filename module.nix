{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.services.poliscoops;

  packagesModule =
    { ... }:
    {
      options = {
        htdocs = mkOption {
          description = "htdocs package.";
          type = types.package;
          default = pkgs.poliscoops-htdocs;
        };
      };
    };
in
{
  options.services.poliscoops = {
    enable = mkEnableOption "Enable Poliscoops";

    packages = mkOption {
      description = ''packages'';
      type = types.submodule packagesModule;
      default = {};
    };

    virtualLocations = mkOption {
      description = ''
        An attribute set mapping virtual hosts to the locations for that virtual host.
        Optionally a virtual host can be mapped to multiple locations using a list.
      '';
      type = with types; attrsOf (oneOf [ str (listOf str) ]);
      default = {};
    };
  };

  config = mkIf cfg.enable {
    services.nginx =
      { enable = true;
        virtualHosts =
          mapAttrs (_: v:
            if isList v then
              { locations = genAttrs v (_: { root = cfg.packages.htdocs; });
              }
            else if (v == "/") then
              { root = cfg.packages.htdocs;
              }
            else
              { locations.${v}.root = cfg.packages.htdocs;
              }
          ) cfg.virtualLocations;
      };
  };
}
