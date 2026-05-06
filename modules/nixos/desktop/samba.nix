{ config, pkgs, ... }:
let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
  credentials = config.sops.secrets.smb_credentials.path;
in
{
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/mnt/share/docker" = {
    device = "//192.168.10.100/docker";
    fsType = "cifs";
    options = [ "${automount_opts},credentials=${credentials},uid=1000,gid=100" ];
  };

  fileSystems."/mnt/share/home" = {
    device = "//192.168.10.100/home";
    fsType = "cifs";
    options = [ "${automount_opts},credentials=${credentials},uid=1000,gid=100" ];
  };
}
