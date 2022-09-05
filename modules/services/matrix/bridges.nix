# Matrix bridges, thanks to [1].
#
# [1]: https://gitlab.com/coffeetables/nix-matrix-appservices/
{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.my.services.matrix.bridges;
  domain = config.networking.domain;
in
{
  imports = [
    inputs.matrix-appservices.nixosModules.matrix-appservices
  ];

  options.my.services.matrix.bridges = with lib; {
    enable = mkEnableOption "Matrix bridges configuration";
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "matrix.${domain}" = {
        locations."/bridges/facebook/login" = {
          proxyPass = "http://[::1]:29181";
        };
      };
    };

    services.matrix-appservices = {
      homeserver = "matrix-synapse";

      homeserverDomain = "belanyi.fr";
      homeserverURL = "https://matrix.belanyi.fr";

      addRegistrationFiles = true;

      # FIXME: explicitly configure logging through systemd, not log files
      # FIXME: register ports to avoid conflicts
      services = {
        # discord = {
        #   port = 29180;
        #   format = "mautrix-go";
        #   package = pkgs.mautrix-discord;
        # };

        facebook = {
          port = 29181;
          format = "mautrix-python";
          package = pkgs.mautrix-facebook;

          settings = {
            appservice = {
              # Enable login by link
              public = {
                enabled = true;
                prefix = "/bridges/facebook/login";
                external = "https://matrix.${domain}/bridges/facebook/login";
              };
            };

            bridge = {
              # Enable encryption by default
              encryption = {
                allow = true;
                default = true;
                allow_key_sharing = true;

                # FIXME: crash loop if not defined explicitly...
                verification_levels = {
                  # Minimum level for which the bridge should send keys to when bridging messages from Telegram to Matrix.
                  receive = "unverified";
                  # Minimum level that the bridge should accept for incoming Matrix messages.
                  send = "unverified";
                  # Minimum level that the bridge should require for accepting key requests.
                  share = "cross-signed-tofu";
                };
              };
            };
          };
        };

        whatsapp = {
          port = 29182;
          format = "mautrix-go";
          package = pkgs.mautrix-whatsapp;

          settings = {
            bridge = {
              # Create a space for all bridges chat rooms
              personal_filtering_spaces = true;
              # Enable encryption by default
              encryption = {
                allow = true;
                default = true;
                allow_key_sharing = true;
              };
            };
          };
        };
      };
    };
  };
}
