#!/bin/bash

zpool create otus1 mirror /dev/sdb /dev/sdc
zpool create otus2 mirror /dev/sdd /dev/sde
zpool create otus3 mirror /dev/sdf /dev/sdg
zpool create otus4 mirror /dev/sdh /dev/sdi

zfs create otus1/otus1
zfs create otus2/otus2
zfs create otus3/otus3
zfs create otus4/otus4

zfs set compression=lzjb otus1/otus1
zfs set compression=lz4 otus2/otus2
zfs set compression=gzip-9 otus3/otus3
zfs set compression=zle otus4/otus4

