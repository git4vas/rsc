# dec/30/2023 21:47:16 by RouterOS 6.49.8
# software id = 8D08-DBGA
#
# model = RBmAPL-2nD
# serial number = HEF08VE02GZ
/interface bridge
add name=local-bridge
/interface list
add name=local-svc
add name=external
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa2-psk group-ciphers=tkip mode=dynamic-keys name=\
    home supplicant-identity=MikroTik unicast-ciphers=tkip
add authentication-types=wpa2-psk mode=dynamic-keys name=comunic \
    supplicant-identity=""
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-onlyn country=france disabled=no \
    frequency=2437 installation=indoor keepalive-frames=disabled \
    security-profile=home ssid=Kingd-Home
/ip pool
add name=dhcp_pool0 ranges=192.168.88.100-192.168.88.200
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=local-bridge lease-time=22m \
    name=dhcp1
/interface bridge port
add bridge=local-bridge interface=ether1
/ip firewall connection tracking
set enabled=yes
/ip neighbor discovery-settings
set discover-interface-list=local-svc
/interface list member
add interface=local-bridge list=local-svc
add interface=wlan1 list=external
/interface wireless connect-list
add disabled=yes interface=wlan1 security-profile=comunic ssid=COMUNIC \
    wireless-protocol=802.11
add interface=wlan1 security-profile=home ssid=kingdhome
/ip address
add address=192.168.88.254/24 interface=local-bridge network=192.168.88.0
/ip dhcp-client
add disabled=no interface=wlan1
/ip dhcp-server network
add address=192.168.88.0/24 gateway=192.168.88.254
/ip firewall filter
add action=accept chain=input comment="established, related" \
    connection-state=established,related
add action=drop chain=input comment=invalid connection-state=invalid
add action=accept chain=input comment="allow ICMP" in-interface-list=external \
    protocol=icmp
add action=accept chain=input comment="allow winbox" in-interface-list=\
    external port=8291 protocol=tcp
add action=accept chain=input comment="allow SSH" in-interface-list=external \
    port=22 protocol=tcp
add action=drop chain=input comment="drop the rest of external input" \
    in-interface-list=external
add action=fasttrack-connection chain=forward connection-state=\
    established,related
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward connection-state=invalid
add action=drop chain=forward comment=\
    "new connection from outside except for dstnat" connection-nat-state=\
    !dstnat connection-state=new in-interface=wlan1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=wlan1
/ip service
set telnet disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system clock
set time-zone-name=Europe/Paris
/tool mac-server
set allowed-interface-list=local-svc
/tool mac-server mac-winbox
set allowed-interface-list=local-svc
