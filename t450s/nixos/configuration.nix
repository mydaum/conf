{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Sound and video configuration
  hardware = {
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    opengl.driSupport32Bit = true;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "tvestelind-t450s";
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure user
  programs.zsh.enable = true;
  users.extraUsers.tomasos = {
    isNormalUser = true;
    home = "/home/tomasos";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    acpi
    dmenu
    git
    gnome3.dconf
    i3status
    i3blocks
    networkmanagerapplet
    pciutils
    sudo
    vim
    wget
  ];

  services.openssh.enable = true;
  services.printing.enable = true;

  services.xserver = {
    enable = true;
    layout = "se";
    xkbVariant = "nodeadkeys";
    xkbOptions = "ctrl:nocaps,compose:lwin";
    displayManager.sessionCommands = "${pkgs.networkmanagerapplet}/bin/nm-applet &"; 
    windowManager.i3.enable = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
