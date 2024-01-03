# Modules that are common to various module systems
# Usually with very small differences, if any, between them.
{ lib, type ? null, ... }:
let
  allowedTypes = [
    "darwin"
    "home"
    "nixos"
  ];

  allowedTypesString = lib.concatStringSep ", " (builtins.map lib.escapeNixString allowedTypes);
in
{
  imports = [
    ./profiles
  ];

  config = {
    assertions = [
      {
        assertion = type != null;
        message = ''
          You must provide `type` as part of specialArgs to use the common modules.
          It must be one of ${allowedTypesString}.
        '';
      }
      {
        assertion = type != null -> builtins.elem type allowedTypes;
        message = ''
          `type` specialArgs must be one of ${allowedTypesString}.
        '';
      }
    ];
  };
}
