# A simple podcast fetcher. See [1]
#
# [1]: https://github.com/NixOS/nixpkgs/pull/106008
{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.podgrab;

  domain = config.networking.domain;
  podgrabDomain = "podgrab.${domain}";
in
{
  options.my.services.podgrab = with lib; {
    enable = mkEnableOption "Podgrab, a self-hosted podcast manager";

    passwordFile = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/run/secrets/password.env";
      description = ''
        The path to a file containing the PASSWORD environment variable
        definition for Podgrab's authentification.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      example = 4242;
      description = "The port on which Podgrab will listen for incoming HTTP traffic.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.podgrab = {
      enable = true;
      inherit (cfg) passwordFile port;
    };

    services.nginx.virtualHosts."${podgrabDomain}" = {
      forceSSL = true;
      useACMEHost = domain;

      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
    };
  };
}
