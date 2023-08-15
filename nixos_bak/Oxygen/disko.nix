{ flake, lib, config, pkgs, modulesPath, ... }:

let
  devices = [
    "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NF0NC04658B"
    "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_2TB_S4X1NJ0NB04835M"
  ];

  nvme = {
    type = "disk";
    device = builtins.elemAt devices 0;
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

  sda = {
    type = "disk";
    device = builtins.elemAt devices 1;
    content = {
      type = "table";
      format = "gpt";
      partitions = [{
        name = "zroot";
        start = "0";
        end = "100%";
        content = {
          type = "zfs";
          pool = "rpool";
        };
      }];
    };
  };

  disk = { inherit nvme sda; };

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
        keylocation = "file:///tmp/secret.key";
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
    flake.inputs.disko.nixosModules.disko
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices = { inherit disk zpool; };

  networking.hostId = "83b0a257";

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
    };

    kernelModules = [ "kvm-amd" ];

    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ ];

      # TODO Uncomment for persistance
      # postDeviceCommands =
      #   #wipe / and /var on boot
      #   lib.mkAfter ''
      #     zfs rollback -r rpool/root@empty
      #   '';
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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

  # Don't let zfs mount the the datasets, because of legacy mounting
  systemd.services.zfs-mount.enable = false;
}
