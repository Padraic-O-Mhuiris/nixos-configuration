let
  padraic = {
    email = "patrick.morris.310@gmail.com";
    github = "Padraic-O-Mhuiris";
    ssh =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
    gpg.fingerprint = "18F528675193C19214A73F1DEF4CEF1AF71A4EDD";
    gpg.key = ''
      -----BEGIN PGP PUBLIC KEY BLOCK-----

      mDMEZaLSohYJKwYBBAHaRw8BAQdAjjBWHkp/5DuqnbystGUXCyZLorvzLe13Aa0e
      +a+9YNK0L1BhdHJpY2sgSCBNb3JyaXMgPHBhdHJpY2subW9ycmlzLjMxMEBnbWFp
      bC5jb20+iI4EExYKADYWIQQY9ShnUZPBkhSnPx3vTO8a9xpO3QUCZaLSogIbAQQL
      CQgHBBUKCQgFFgIDAQACHgUCF4AACgkQ70zvGvcaTt0iegD+MgSaI4JQGzyxqPH4
      xiBPvS7WaGKwBSFzxrJRN1G+rJIA/3/xn39apL+7DuzFfKe7+OP3jfHMMErSsp7S
      WyTJDyMGuDMEZaLTeRYJKwYBBAHaRw8BAQdAMnhqdI6qfPPy2gg1/OwvVzrvu/jm
      Zym+XLz+TdHC7qOI9QQYFgoAJhYhBBj1KGdRk8GSFKc/He9M7xr3Gk7dBQJlotN5
      AhsCBQkFo5qAAIEJEO9M7xr3Gk7ddiAEGRYKAB0WIQS7biGZohmT2vhfyV91Y6Tu
      HWtT0wUCZaLTeQAKCRB1Y6TuHWtT03GSAQC7EaCGPCC6piz+ziZiNGnIGGFM4VQX
      ZjZ3kNxhmOUn1wEAvQSt8zK97gF4JguLNjtxz1XIAx7Rol6etN+8fV71SwFAogEA
      m8Ltwj4RK4KQXHyRelvseFsSWD5IM8iq/ua4TnMJSmYA/0580zrrvNOnrQUd0Z6K
      KBFgD+Q6JWbILol3zR53e7EIuDgEZaLToBIKKwYBBAGXVQEFAQEHQHyz5+gsTHMx
      Xfp80ha8erN5aMMafu5Alx80iftbFsI4AwEIB4h+BBgWCgAmFiEEGPUoZ1GTwZIU
      pz8d70zvGvcaTt0FAmWi06ACGwwFCQWjmoAACgkQ70zvGvcaTt3u0AEA2ig/cg6b
      k7JsBhPOzGts6YWqfbkEgSgZQpuc6rwXt1cA+gJETrRAfrRckxzsDKiQv/5FiY5A
      +wCK8eicZVfskIkPuDMEZaLTtRYJKwYBBAHaRw8BAQdArx5kSCm3WJbw0mj8oAb1
      bf6ATCNb7nywA/aXWrPat4SIfgQYFgoAJhYhBBj1KGdRk8GSFKc/He9M7xr3Gk7d
      BQJlotO1AhsgBQkFo5qAAAoJEO9M7xr3Gk7daEQA/jJwnfR+geI99bwAEpTpqW7f
      BpWBtXRV3cZLM3s0f6ByAQCgo1/ilNFUP4AFkTnJqMVUTxKpKZhOrvVZCh50cqYo
      Cw==
      =3oRa
      -----END PGP PUBLIC KEY BLOCK-----
    '';
  };

  Oxygen = {
    cpu = "amd";
    ip = {
      local = "192.168.0.214";
      # remote = "192.168.0.214";
    };
    disks = [
      "nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NF0NC04658B"
      "ata-Samsung_SSD_860_EVO_2TB_S4X1NJ0NB04835M"
    ];
    users = { inherit padraic; };
  };

  Hydrogen = {
    cpu = "intel";
    theme = "catppuccin-frappe";
    ip = {
      local = "192.168.0.184";
      # remote = "192.168.0.214";
    };
    disks = [ "nvme-PC_SN810_NVMe_WDC_1024GB_222320805140" ];
    users = { inherit padraic; };
  };
in {
  configuration = { inherit Oxygen Hydrogen; };
  settings = { modulesPath = ./modules; };
}
