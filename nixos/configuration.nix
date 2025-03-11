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
      # SELinux
      "security=selinux"
    ];
    kernelPatches = [
      # SELinux
      {
        name = "selinux-config";
        patch = null;
        extraConfig = ''
                SECURITY_SELINUX y
                SECURITY_SELINUX_BOOTPARAM n
                SECURITY_SELINUX_DISABLE n
                SECURITY_SELINUX_DEVELOP y
                SECURITY_SELINUX_AVC_STATS y
                SECURITY_SELINUX_CHECKREQPROT_VALUE 0
                DEFAULT_SECURITY_SELINUX n
              '';
      }
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
  i18n = let
    locale = "fr_FR.UTF-8";
  in
  {
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

  # packages to install (what you want)
  environment.systemPackages = with pkgs; [
    # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
    policycoreutils
    vim
    git
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

  # Security Layer
  # Firewall
  networking.firewall = {
    # enable or disable firewall
    enable = true;

    # Open ports in the Firewall
    # allowedTCPPorts = [];
    # allowedUDPPorts = [];
  };
  # build systemd with SELinux support so it loads policy at boot and supports file labelling
  systemd.package = pkgs.systemd.override {
    withSelinux = true;
  };

  # Enable the OpenSSH daemon. (disable it if no use)
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  nix = {
    # Auto Clean
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      # Data optimization
      auto-optimise-store = true;

      # Experimental features
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  system.stateVersion = "24.11";
}
