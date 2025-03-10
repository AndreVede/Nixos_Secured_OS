{
  { inputs, config, pkgs, ... }:
  {
    imports = [
      ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    users.users = {
      username = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        initialPassword = "toto";
      };
    };

    environment.systemPackages = with pkgs; [
      cowsay
      lolcat
    ];

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
        # use username here
        username = import ../home-manager/home.nix;
      };
    };
  };
}
