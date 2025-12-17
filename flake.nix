{
  description = "DeloNIX NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    # hyprland.url = "github:hyprwm/Hyprland";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-alien.url = "github:thiagokokada/nix-alien";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/default/configuration.nix
        ./hosts/default/hardware-configuration.nix
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd  # Framework 13 AMD hardware support
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [ inputs.nixvim.homeManagerModules.nixvim ];
          home-manager.users.falconnor4 = import ./home/default.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    packages.x86_64-linux.iso = inputs.nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      format = "install-iso";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/default/configuration.nix
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
        {
          # Disable Lanzaboote for ISO as it requires Secure Boot setup which isn't present
          boot.lanzaboote.enable = nixpkgs.lib.mkForce false;
          boot.loader.systemd-boot.enable = nixpkgs.lib.mkOverride 40 true; # Let the ISO generator handle booting

          # User config for the live session
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [ inputs.nixvim.homeManagerModules.nixvim ];
          home-manager.users.falconnor4 = import ./home/default.nix;
        }
      ];
    };
  };
}
