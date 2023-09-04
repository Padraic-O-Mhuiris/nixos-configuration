{ lib, config, pkgs, modulesPath, os, inputs, ... }:

# TODO Can this zfs disks approach be automatic for multiple devices
let
  disksByPath = disk: "/dev/disk/by-id/${disk}";

  nvme = {
    type = "disk";
    device = disksByPath (builtins.elemAt os.disks 0);
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = "bootcode";
          start = "0";
          end = "1M";
          part-type = "primary";
          flags = [ "bios_grub" ];
        }
        {
          name = "efiboot";
          fs-type = "fat32";
          start = "1MiB";
          end = "1GiB";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        }
        {
          name = "swap";
          start = "1GiB";
          end = "17GiB";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
        {
          name = "zroot";
          start = "17GiB";
          end = "100%";
          content = {
            type = "zfs";
            pool = "rpool";
          };
        }
      ];
    };
  };

  disk = { inherit nvme; };

  zpool = {
    rpool = {
      type = "zpool";
      rootFsOptions = {
        acltype = "posixacl";
        canmount = "off";
        checksum = "edonr";
        compression = "zstd";
        dnodesize = "auto";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation =
          "file:///tmp/secret.key"; # must be set during initial installation step
        mountpoint = "none";
        normalization = "formD";
        relatime = "on";
        xattr = "sa";
        "com.sun:auto-snapshot" = "false";
      };
      options = {
        ashift = "12";
        autotrim = "on";
      };
      postCreateHook = ''
        zfs set keylocation="prompt" $name;
      '';

      datasets = {
        reserved = {
          options = {
            canmount = "off";
            mountpoint = "none";
            reservation = "5GiB";
          };
          type = "zfs_fs";
        };
        home = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/home";
          options."com.sun:auto-snapshot" = "true";
          postCreateHook = "zfs snapshot rpool/home@empty";
        };
        persist = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/persist";
          options."com.sun:auto-snapshot" = "true";
          postCreateHook = "zfs snapshot rpool/persist@empty";
        };
        nix = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/nix";
          options = {
            atime = "off";
            canmount = "on";
            "com.sun:auto-snapshot" = "true";
          };
          postCreateHook = "zfs snapshot rpool/nix@empty";
        };
        root = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
          postCreateHook = ''
            zfs snapshot rpool/root@empty
            zfs snapshot rpool/root@lastboot
          '';
        };
      };
    };
  };

in {

  imports = [
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices = { inherit disk zpool; };

  boot = {
    initrd = {
      # TODO Debug modules per system
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      postDeviceCommands =
        #wipe / and /var on boot
        lib.mkAfter ''
          zfs rollback -r rpool/root@empty
        '';
    };
    kernelParams = [ "nohibernate" "zfs.zfs_arc_max=17179869184" ];
    supportedFilesystems = [ "vfat" "zfs" ];
    zfs = {
      devNodes = "/dev/disk/by-id/";
      forceImportAll = true;
      removeLinuxDRM = pkgs.hostPlatform.isAarch64;
      requestEncryptionCredentials = true;
    };
  };

  fileSystems."/persist".neededForBoot = true;

  environment.systemPackages = [ pkgs.zfs-prune-snapshots ];

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  systemd.services.zfs-mount.enable = false;
}
