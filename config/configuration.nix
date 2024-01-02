# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Multi-platform Support
  boot.binfmt.emulatedSystems = [
    "x86_64-windows"
    "aarch64-linux"
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;

  networking.hostName = "overwatch"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "tom";
    extraGroups = [ "networkmanager" "wheel" "vboxusers" "adbusers" ];
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    tmux
    neovim
    gcc
    gdb
    nasm
    fasm
    python3
    nodejs
    jetbrains.jdk
    curl
    wget
    httpie
    git
    powershell
    virt-manager
    qemu
    vscode-with-extensions
    rustup
    radare2
    insomnia
    jetbrains.idea-community
    gnumake
    android-studio
    iaito
    gimp
    zoom-us
    slack
    obs-studio
    blender
    jetbrains.pycharm-community
    google-chrome
    brave
    gef
    magic-wormhole
    qtcreator
    cifs-utils
    neofetch
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    fishPlugins.colored-man-pages
    metasploit
    pwntools
    awscli2
    portaudio
    dbeaver
    ghidra
    panopticon
    python310Packages.pygame
    python310Packages.flask
    python310Packages.django
    python310Packages.pyaudio
    mono5
    wineWowPackages.stable
    remmina
    vscode-extensions.bradlc.vscode-tailwindcss
    unzip
    libclang
    nerdfonts
  ];

  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  environment.variables.ANDROID_HOME = "/home/tom/Android/Sdk";
  
  # enable adb
  programs.adb.enable = true;


  # List services to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # vpn service
  services.tailscale.enable = true;
  

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  fileSystems."/mnt/hcc" = {
    device = "//192.168.0.102/hcc";
    fsType = "cifs";
    options = let
    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/tom/.config/hcc/smb-secrets,uid=1000,gid=100"];
    
  };

   fileSystems."/mnt/strike" = {
    device = "//192.168.137.1/Users/dev/Documents/NetShare";
    fsType = "cifs";
    options = let
    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/tom/.config/strike/smb-secrets,uid=1000,gid=100"];
    
  };


  system.stateVersion = "23.05"; # Did you read the comment?

}
