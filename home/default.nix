{ config, pkgs, ... }:
{
    home.username = "foliveira";
    home.homeDirectory = "/home/foliveira";

    # xresources.properties = {
    #     "Xcursor.size" = 16;
    #     "Xft.dpi" = 172;
    # };    

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
       extensions = with pkgs.vscode-extensions; [
         bbenoist.nix
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
        };
    };

#   programs.alacritty = {
#     enable = true;
#     settings = {
#       env.TERM = "xterm-256color";
#       font = {
#         size = 12;
#         draw_bold_text_with_bright_colors = true;
#       };
#       scrolling.multiplier = 5;
#       selection.save_to_clipboard = true;
#     };
#   };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}