# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./sp-hardware.nix
    ];

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # mirror
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
  };

  # net
  networking.hostName = "be";
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ 3000 1234 ];

  # desk
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Hack Nerd Font"
          "Source Han Mono SC"
        ];
        sansSerif = [
          "Source Han Sans SC"
        ];
        serif = [
          "Source Han Serif SC"
        ];
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [ "Hack" ];
      })
      hack-font
      noto-fonts-emoji
      source-han-mono
      source-han-sans
      source-han-serif
    ];
  };

  # locale
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
  time.timeZone = "Asia/Shanghai";

  # service
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      windowManager = {
        leftwm = {
          enable = true;
        };
      };
      dpi = 192;
      resolutions = [
	  {
	    x = 2736;
	    y = 1824;
	  }
      ];
    };
    openssh = {
      enable = true;
    };
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
  };

  # env
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  # media
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # sys
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    xfce.thunar
    polybar
    feh
    rofi
    leftwm
    picom
    dunst
    alacritty
    polkit
    gnupg
    neovim
    chromium
    xclip
    unzip
    zip
    wget
    xorg.xdpyinfo
    nixpkgs-fmt
  ];

  # programs config
  programs = {
    gnupg.agent = {
      enable = true;
    };
    ssh = {
      startAgent = true;
    };
  };

  # users
  users.users = {
    beet = {
      initialPassword = "1111";
      isNormalUser = true;
      group = "docker";
      extraGroups = [
        "wheel"
      ];
    };

  };

  # hardware
  hardware.video.hidpi.enable = true;
  virtualisation.vmware.guest.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "21.11";
}
