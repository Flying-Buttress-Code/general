#Sync Windows PDC EMULATOR to ntp
w32tm.exe /config /manualpeerlist:"0.pool.ntp.org,0x8 1.pool.ntp.org,0x8 2.pool.ntp.org,0x8" /syncfromflags:manual /update
w32tm /resync