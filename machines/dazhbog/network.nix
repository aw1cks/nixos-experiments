{ config, lib, pkgs, ... }:
let
  ipv4Addr = "188.34.202.238";
  ipv4Cidr = "32";

  ipv6Addr = "2a01:4f8:c2c:72ef::";
  ipv6Cidr = "64";
in
{
  networking.hostName = "dazhbog";
  networking.domain   = "nc-nl.pub.awicks.io";

  networking.networkmanager.dns = "none";
  networking.nameservers = [
    "1.1.1.1"
    "2606:4700:4700::1111"
    "8.8.8.8"
    "2001:4860:4860::8888"
  ];
  networking.hosts = [
    "${ipv4Addr}" = [ "${networking.hostName}.${networking.domain}" "${networking.hostname}" ]
    "${ipv6Addr}1" = [ "${networking.hostName}.${networking.domain}" "${networking.hostname}" ]
  ];

  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.networkmanager.settings = {
    main = {
      no-auto-default = "*";
    };
  };
  networking.networkmanager.ensureProfiles.profiles = {
    wan = {
      connection = {
        id = "wan";
        type = "ethernet";
        interface-name = "enp1s0";
        autoconnect-priority = "100";
      };
      ethernet = {};
      ipv4 = {
        method = "manual";
        address1 = "${ipv4Addr}/${ipv4Cidr},172.31.1.1";
        route1 = "172.31.1.1";
      };
      ipv6 = {
        method = "manual";
        address1 = "${ipv6Addr}/${ipv6Cidr},fe80::1";
        route1 = "::/0,fe80::1";
      };
    };
  };

  # Allow murmur traffic
  networking.firewall.allowedTCPPorts = [ 64738 ];
  networking.firewall.allowedUDPPorts = [ 64738 ];
}
