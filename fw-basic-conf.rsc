# dec/30/2023 21:48:17 by RouterOS 6.49.8
# software id = 8D08-DBGA
#
# model = RBmAPL-2nD
# serial number = HEF08VE02GZ
/ip firewall connection tracking
set enabled=yes
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
