{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
    
  # Bootloader
  boot = {
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
          })
      ];
    };
    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    # Provide the hostname
    hostName = "hostname";
    # Enable networking
    networkmanager.enable = true;

    # Disable ipv6
    # enableIPv6 = false;
  };

  # Set the time zone
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  let
    locale = "fr_FR.UTF-8";
  in {
    i18n = {
      defaultLocale = locale;
      extraLocaleSettings = {
        LC_ADDRESS = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT = locale;
        LC_MONETARY = locale;
        LC_NAME = locale;
        LC_NUMERIC = locale;
        LC_PAPER = locale;
        LC_TELEPHONE = locale;
        LC_TIME = locale;
      };
    };
  };

  # Enable X11
  services.xserver.enable = true;

  # The Desktop (put what you want)
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Your Keyboard
  # In X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  # In console
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire (you can user other lib)
  hardware.pulseaudio.enable = false;
  security.rkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # TODO home-manager is maybe responsible of that configuration
  users.users = {
    username = {
      isNormalUser = true;
      description = "My Long Name";
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "toto";
    };
  };

  # packages to install
  environment.systemPackages = with pkgs; [
    cowsay
    lolcat
  ];

  # Example for GNOME with packages to exclude
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    yelp
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # use username here
      username = import ../home-manager/home.nix;
      };
  };

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.11";
}
