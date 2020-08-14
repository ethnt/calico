# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/dns.nix
    ./modules/vpn.nix
    ./modules/satan.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "calico.barbossa.dev";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
  networking.interfaces.ens7.useDHCP = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ python3 vim iperf ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 53 3080 5201 ];
  networking.firewall.allowedUDPPorts = [ 5201 9993 51820 ];
  networking.firewall.allowedUDPPortRanges = [{
    from = 60000;
    to = 61000;
  }];

  # Enable Mosh
  programs.mosh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  # Services
  services.dns = { enable = true; };
  services.vpn = { enable = true; };
  services.satan = { enable = true; };

  # Extra users
  users.extraUsers.calico = {
    uid = 1001;
    createHome = true;
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
