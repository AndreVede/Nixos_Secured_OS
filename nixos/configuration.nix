{
  { inputs, config, pkgs, ... }:
  {
    imports = [
      ./hardware-configuration.nix
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
