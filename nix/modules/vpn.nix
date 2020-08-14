{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.vpn;
in {
  options.services.vpn = {
    enable = mkOption {
      description = "Whether to enable VPN services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wireguard ];

    networking = {
      nat = {
        enable = true;
        externalInterface = "ens3";
        internalInterfaces = [ "wg0" ];
      };

      wg-quick.interfaces = {
        wg0 = {
          address = [ "10.0.2.1/24" ];
          listenPort = 51820;
          privateKeyFile = "/etc/wireguard/wg-private.key";

          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i %i -j ACCEPT
            ${pkgs.iptables}/bin/iptables -A FORWARD -o %i -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
          '';

          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i %i -j ACCEPT
            ${pkgs.iptables}/bin/iptables -D FORWARD -o %i -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE
          '';

          peers = [
            {
              publicKey = "/8wwsFw8a/itIfw4bUsYuRkXRdnMd5gpcwSa13YyZjk=";
              allowedIPs = [ "10.0.2.2/32" ];
            }
            {
              publicKey = "0GI3+qAjZmQp0Mndj2ZJsp2MSC8nqVDpZzXPNrKvGgM=";
              allowedIPs = [ "10.0.2.3/32" ];
            }
          ];
        };
      };
    };
  };
}
