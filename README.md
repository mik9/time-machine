Configuration example:
===

docker-compose.yml:
---

```
version: '2'

services:
  samba:
    container_name: samba
    image: mik9/samba-time-machine
    environment:
    - USERNAME=<DESIRED_USERNAME>
    - PASSWORD=<DESIRED_PASSWORD>
    network_mode: host # TODO
    volumes:
    - ./smb.conf:/etc/samba/smb.conf
    - /data/TimeMachine:/data/TimeMachine
    restart: always

  avahi:
    container_name: avahi
    image: solidnerd/avahi:0.7
    network_mode: host
    volumes:
    - ./avahi:/etc/avahi:ro
    restart: always
```

smb.conf:
---

```
[global]
server role = standalone server
rpc_server:mdssvc = embedded
passdb backend = tdbsam
obey pam restrictions = yes
unix password sync = yes
security = user
printcap name = /dev/null #this works around non-loadable printers
load printers = no
fruit:model = MacPro

[Time Capsule]
fruit:aapl = yes
fruit:time machine = yes
fruit:time machine max size = 1T
path = /data/TimeMachine/
valid users = %$(USERNAME)
writable = yes
kernel oplocks = no
kernel share modes = no
posix locking = no
vfs objects = catia fruit streams_xattr
```

avahi/services/samba.service:
---

```
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
    <name replace-wildcards="yes">%h Samba</name>
    <service>
      <type>_adisk._tcp</type>
      <txt-record>sys=waMa=0,adVF=0x100</txt-record>
      <txt-record>dk0=adVN=Time Capsule,adVF=0x82</txt-record>
    </service>
    <service>
        <type>_smb._tcp</type>
        <port>445</port>
    </service>
</service-group>
```

avahi/avahi-daemon.conf:
---

```
[server]
use-ipv4=yes
use-ipv6=yes
enable-dbus=no
ratelimit-interval-usec=1000000
ratelimit-burst=1000

[wide-area]
enable-wide-area=yes

[publish]
publish-hinfo=no
publish-workstation=no

[reflector]
#enable-reflector=no
#reflect-ipv=no

[rlimits]
```

