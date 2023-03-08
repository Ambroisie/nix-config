{ self
, flake-parts
, futils
, home-manager
, nixpkgs
, nur
, ...
} @ inputs:
let
  inherit (self) lib;

  inherit (futils.lib) eachSystem system;

  mySystems = [
    system.aarch64-darwin
    system.aarch64-linux
    system.x86_64-darwin
    system.x86_64-linux
  ];

  eachMySystem = eachSystem mySystems;

  systemDependant = system: {
    # Work-around for https://github.com/nix-community/home-manager/issues/3075
    legacyPackages = {
      homeConfigurations = {
        ambroisie = home-manager.lib.homeManagerConfiguration {
          # Work-around for home-manager
          # * not letting me set `lib` as an extraSpecialArgs
          # * not respecting `nixpkgs.overlays` [1]
          # [1]: https://github.com/nix-community/home-manager/issues/2954
          pkgs = import nixpkgs {
            inherit system;

            overlays = (lib.attrValues self.overlays) ++ [
              nur.overlay
            ];
          };

          modules = [
            "${self}/home"
            {
              # The basics
              home.username = "ambroisie";
              home.homeDirectory = "/home/ambroisie";
              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;
              # This is a generic linux install
              targets.genericLinux.enable = true;
            }
          ];

          extraSpecialArgs = {
            # Inject inputs to use them in global registry
            inherit inputs;
          };
        };
      };
    };
  };
in
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = mySystems;

  imports = [
    ./apps.nix
    ./checks.nix
    ./dev-shells.nix
    ./lib.nix
    ./nixos.nix
    ./overlays.nix
    ./packages.nix
  ];

  flake = (eachMySystem systemDependant);
}
