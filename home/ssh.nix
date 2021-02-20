{ ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/shared_rsa";
        user = "git";
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = "~/.ssh/shared_rsa";
        user = "git";
      };

      "git.sr.ht" = {
        hostname = "git.sr.ht";
        identityFile = "~/.ssh/shared_rsa";
        user = "git";
      };

      porthos = {
        hostname = "91.121.177.163";
        identityFile = "~/.ssh/shared_rsa";
        user = "ambroisie";
      };
    };

    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
