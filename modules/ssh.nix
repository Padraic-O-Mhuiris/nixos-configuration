{ config, lib, pkgs, inputs, ... }:

lib.mkMerge [
  (lib.os.user ({ name, ssh, ... }: {
    users.users.${name}.openssh.authorizedKeys.keys = [ ssh ];
  }))

  {
    services = {
      openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
        allowSFTP = false;
        # TODO Figure out how to reproducibly automate ssh key generation from sops/initial deployment
        hostKeys = [{
          type = "ed25519";
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          rounds = 100;
          comment = "${config.networking.hostName}";
        }];
      };
    };

    # impermanence
    environment.persistence."/persist".files =
      [ "/etc/ssh/ssh_host_ed25519_key" "/etc/ssh/ssh_host_ed25519_key.pub" ];
  }

  # https://github.com/numtide/srvos/blob/main/nixos/common/well-known-hosts.nix
  {
    programs.ssh.knownHosts = {
      "github.com".hostNames = [ "github.com" ];
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

      "gitlab.com".hostNames = [ "gitlab.com" ];
      "gitlab.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";

      "git.sr.ht".hostNames = [ "git.sr.ht" ];
      "git.sr.ht".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60";
    };
  }

  # https://github.com/numtide/srvos/blob/main/nixos/common/openssh.nix
  {
    services.openssh = {
      settings.X11Forwarding = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PasswordAuthentication = false;
      settings.UseDns = false;
      settings.KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
      ];
      # unbind gnupg sockets if they exists
      extraConfig = "StreamLocalBindUnlink yes";
    };
  }
]
