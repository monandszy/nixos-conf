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
      extraGroups = [ "wheel" "docker" ];
    };
    git = {
      isNormalUser = true;
      home = "/home/git";
      description = "Git";
      extraGroups = [ "docker" ]; 
    openssh.authorizedKeys.keyFiles = [
        /home/git/.ssh/authorized_keys
      ];
    };
    root.openssh.authorizedKeys.keyFiles = [
      /root/.ssh/authorized_keys
    ];
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

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.java.enable = true;

  # Networks
  networking.hostName = "nixos";
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

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  system.stateVersion = "23.11"; # NEVER CHANGE
}

