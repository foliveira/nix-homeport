{ config, pkgs, ... }:
{
  home.username = "foliveira";
  home.homeDirectory = "/home/foliveira";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 125;
  };    

  home.packages = with pkgs; [
    firefox
    _1password
    _1password-gui
    ledger-live-desktop
    alacritty
    vscodium
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "continue";
        publisher = "continue";
        version = "0.8.12";
        sha256 = "4067f9fd6264f4417a1cdf17198bdf0ca5e886ba624a24227d781b750c53875e";
      }
      {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
      }
      {
        name = "vscode-just";
        publisher = "kokakiwi";
        version = "2.1.0";
        sha256 = "d677160c51b5d751c9f8f980ea4d35d6a802e2e58c3acff0884e05d00e3c52d6";
      }
    ];
  };

  programs.git = {
    userName = "foliveira";
    userEmail = "fabio.an.oliveira@gmail.com";
    enable = true;  
    extraConfig = {
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCP5o/KyqNDxTACRgx27p/dZDIYFM3mCE0zO9v48oQy";
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      gpg.format = "ssh";
      commit.gpgsign = true;
      push.autoSetupRemote = true;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}