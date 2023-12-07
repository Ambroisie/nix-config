{ self, config, inputs, lib, ... }:
let
  defaultModules = [
    {
      # Let 'nixos-version --json' know about the Git revision
      system.configurationRevision = self.rev or "dirty";
    }
    {
      nixpkgs.overlays = (lib.attrValues self.overlays) ++ [
        inputs.nur.overlay
      ];
    }
    # Include generic settings
    "${self}/modules/nixos"
    # Import common modules
    "${self}/modules/common"
  ];

  buildHost = name: system: lib.nixosSystem {
    inherit system;
    modules = defaultModules ++ [
      "${self}/hosts/nixos/${name}"
    ];
    specialArgs = {
      # Use my extended lib in NixOS configuration
      inherit (self) lib;
      # Inject inputs to use them in global registry
      inherit inputs;
      # For consumption by common modules
      type = "nixos";
    };
  };
in
{
  config = {
    hosts.nixos = {
      aramis = "x86_64-linux";
      porthos = "x86_64-linux";
    };

    flake.nixosConfigurations = lib.mapAttrs buildHost config.hosts.nixos;
  };
}
