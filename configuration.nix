# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).


{ config, lib, pkgs, ... }:

{
  imports = [ (./hardware-configuration.nix) ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Copy the NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix). 
  system.copySystemConfiguration = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nixos = {
      isNormalUser = true;
      home = "/home/nixos";
      description = "Nixos";
      extraGroups = [ "wheel" ];
    };
    git = {
      isNormalUser = true;
      home = "/home/git";
      description = "Git";
#      extraGroups = [ "docker" ]; 
#    openssh.authorizedKeys.keyFiles = [
#        /home/git/.ssh/authorized_keys
#      ];
    };
#    root.openssh.authorizedKeys.keyFiles = [
#      /root/.ssh/authorized_keys
#    ];
  };

  # Personalization
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; 
  };

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
    lsof
    cron
  ];

  environment.sessionVariables = {
  DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
  };

  services.cron = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

#  virtualisation.docker = {
#    enable = true;
#    rootless = {
#      enable = true;
#      setSocketVariable = true;
#    };
#  };

  programs.java.enable = true;

  # Networks
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles = {
    "fiberway.pl_20a_2_5GHz" = {
      connection = {
        id = "fiberway.pl";
        interface = "wlp2s0";
        type = "wifi";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "fiberway.pl_20a/2_5GHz";
        key-mgmt = "wpa-psk";
        psk = (builtins.readFile ./wifi_passwd);
      };
    };
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 8080 8000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  #  settings.PasswordAuthentication = false;
  #  settings.KbdInteractiveAuthentication = false;
  };

  system.stateVersion = "24.05"; # NEVER CHANGE
}

  # services.xserver.enable = true;
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

