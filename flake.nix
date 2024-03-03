{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }: rec {
    images = {
      pi = (self.nixosConfigurations.pi.extendModules {
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            disabledModules = [ "profiles/base.nix" ];
          }
        ];
      }).config.system.build.sdImage;
    };
    packages.x86_64-linux.pi-image = images.pi;
    packages.aarch64-linux.pi-image = images.pi;

    nixosConfigurations = {
      Galadriel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.apple-macbook-pro-11-5
          ./hosts/galadriel

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.foliveira = import ./home;
          }
        ];
      };
      
      Mirkwood = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./hosts/Mirkwood
        ];
      };  

      BagEnd = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./hosts/Mirkwood
        ];
      };  

      # Rivendell = nix-darwin.lib.darwinSystem {
      #   system = "aarch64-darwin";
      # };
    };
  };
}