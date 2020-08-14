# Calico

VPN server running NixOS on Vultr.

## Installation

The Nix configuration expects a `private.key` and `public.key` located at `/etc/wireguard`.

```
sudo mkdir /etc/wireguard
sudo chown -R $(whoami) /etc/wireguard
umask 077
wg genkey | tee private.key | wg pubkey > public.key
```
