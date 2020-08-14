{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.dns;
in {
  options.services.dns = {
    enable = mkOption {
      description = "Whether to enable DNS services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    docker-containers.pihole = {
      image = "pihole/pihole:latest";
      ports = [ "0.0.0.0:53:53/tcp" "0.0.0.0:53:53/udp" "3080:80" "30443:443" ];
      volumes =
        [ "/etc/pihole/:/etc/pihole/" "/var/lib/dnsmasq.d:/etc/dnsmasq.d/" ];
      environment = { ServerIP = "0.0.0.0"; };
      extraDockerOptions =
        [ "--cap-add=NET_ADMIN" "--dns=127.0.0.1" "--dns=1.1.1.1" ];
      workdir = "/etc/pihole/";
    };
  };
}
