{
  description = "Standard Secured System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs.unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };
  in {
    # Shell to build
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nixos-rebuild
      ];
      shellHook = ''
        echo "Ready to build"
      '';
    };

    nixosConfigurations = {
      # replace with hostname
      hostname = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    # With this flake, you can now apply home-manager alone
    homeManagerConfigurations = {
      # replace with username
      username = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
