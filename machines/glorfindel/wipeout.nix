{ pkgs, ... }:

let
  fs-diff = pkgs.writeShellScriptBin "fs-diff" ''
    #!/usr/bin/env bash
    # fs-diff.sh
    set -euo pipefail

    OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/root-blank 9999999 | cut -f4- -d' ')

    sudo btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
    sed '$d' |
    cut -f17- -d' ' |
    sort |
    uniq |
    while read path; do
     path="/$path"
     if [ -L "$path" ]; then
       : # The path is a symbolic link, so is probably handled by NixOS already
     elif [ -d "$path" ]; then
       : # The path is a directory, ignore
     else
       echo "$path"
     fi
   done
  '';

in {
  environment.systemPackages = [ fs-diff ];

  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt
    mount -o subvol=/ /dev/mapper/lvm-root /mnt

    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvol"
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvol" &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvol"
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    umount /mnt
  '';
}
