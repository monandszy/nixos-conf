# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
      (./hardware-configuration.nix)
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles = {
    "fiberway.pl_20a_2_5GHz" = {
      connection = {
        id = "fiberway.pl_20a/2_5GHz";
        interface = "wlp2s0";
        type = "wifi";
      };wifi = {
        mode = "infrastructure";
        ssid = "fiberway.pl_20a/2_5GHz";
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk = (builtins.readFile ./wifi_passwd);
      };
    };
  };

  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nixos = {
      isNormalUser = true;
      home = "/home/nixos";
      description = "Nixos";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
    git = {
      isNormalUser = true;
      home = "/home/git";
      description = "Git";
      openssh.authorizedKeys.keyFiles = [
        /home/git/.ssh/authorized_keys
      ];
    };
    root.openssh.authorizedKeys.keyFiles = [
      /root/.ssh/authorized_keys
    ];
  };

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    tmux
    docker
    docker-compose
    git
    bash
    gradle
    zulu
    android-tools
    toybox
    patchelf
    nmap
    caddy
    iptables
    traceroute
    tree
    sshfs
    niv
    git-credential-manager
    dotnet-runtime_7
  ];

  environment.sessionVariables = {
  DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
  };

  programs.git = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.java.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Copy the NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix). 
  # This is useful in case you accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

