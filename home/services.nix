{ config, pkgs, inputs, lib, ... }:

{
  # Google Drive Mount
  systemd.user.services.rclone-gdrive-mount = {
    Unit = {
      Description = "Mount Google Drive";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/GoogleDrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive: %h/GoogleDrive --vfs-cache-mode writes";
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/GoogleDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
