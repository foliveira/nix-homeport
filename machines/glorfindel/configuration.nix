# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

let user = "foliveira"; in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./impermanence.nix
      ./wipeout.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.enableAllFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    layout = "us";
    xkbVariant = "colemak";
    xkbModel = "apple_laptop";
  };

  users.mutableUsers = false;
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel" 
      "docker" 
    ];
    shell = pkgs.zsh; 
    hashedPassword = "$6$LzE6eeGR7lm3vQfe$G2hYfeCGY.zRxNciGpWk0M/c9E7eAfA5R.RixFxZ8bIWkKD30r3dKANpr7w5b9C72tyU9/JesNr1mEuI7T9qH/";
  };
  users.users.root = {
    initialHashedPassword = "$6$Y6fh9Hl94Fgtg0lG$EmE1ZrMZ32/jH.I7m0/Fe5ZU3hmAPR2t81V469aWv32W1gl03UOBXm9Hdj2Po3FDfuytUCwOTsn4r4gj7fH5H.";
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {  
        users = [ "${user}" ];
        commands = [ 
          { 
            command = "ALL" ;
            options= [ "NOPASSWD" "SETENV" ];
          }
        ];
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    tmux
    zsh
    jq
    gitAndTools.gitFull
    firefox
    tailscale
    auto-cpufreq
    _1password
    _1password-gui
    ledger-live-desktop
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
      ];
    })
  ];

  programs.zsh.enable = true;
  hardware.ledger.enable = true;
  services.tailscale.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "glorfindel"; 
    
    useDHCP = false;

    networkmanager.enable = true;
    interfaces.wlp3s0.useDHCP = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "@admin" "@wheel" ];
    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  services.auto-cpufreq.enable = true;

  system.stateVersion = "23.05";
}

