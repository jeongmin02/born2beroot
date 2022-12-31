#!/bin/sh

echo -n "#Architecture : "
uname -a
echo -n "#CPU physical : "
grep 'physical id' /proc/cpuinfo | sort | uniq | wc -l
echo -n "#vCPU : "
grep ^processor /proc/cpuinfo | wc -l
echo -n "#Memory Usage : "
MEM_TOTAL=`free -m | grep ^Mem | awk '{print $2}'`
MEM_FREE=`free -m | grep ^Mem | awk '{print $4}'`
MEM_RATE=`echo "100 * ${MEM_FREE} / ${MEM_TOTAL}" | bc`
echo "${MEM_FREE}/${MEM_TOTAL}MB (${MEM_RATE}%)"
echo -n "#Disk Usage : "
DISK_TOTAL=`df -P | grep -v ^Filesystem | awk '{sum += $2} END { print sum/1024/1024; }'`
DISK_AVAIL_MB=`df -P | grep -v ^Filesystem | awk '{sum += $4} END { print sum/1024; }'`
DISK_AVAIL_GB=`df -P | grep -v ^Filesystem | awk '{sum += $4} END { print sum/1024/1024; }'`
DISK_RATE=`echo "scale=2;100 * ${DISK_AVAIL_GB} / ${DISK_TOTAL}" | bc -l`
echo "${DISK_AVAIL_MB}/${DISK_TOTAL}Gb (${DISK_RATE}%)"
echo -n "#CPU load : "
echo `mpstat | tail -1 | awk '{print 100-$NF}'`%
echo -n "#Last boot : "
who -b | awk '{print $3, $4}'
echo -n "#LVM use : "
if lsblk | awk '{print $6}' | grep lvm > /dev/null; then echo 'yes'; else echo 'no'; fi
echo -n "#Connections TCP : "
echo "`netstat -anp | grep :4242 | grep ESTABLISHED | wc -l` ESTABLISHED"
echo -n "#User log : "
users | wc -w
echo -n "#Network : "
echo "IP `hostname -I` (`ip link show | grep link/ether | awk '{print $2}'`)"
echo -n "#Sudo : "
echo `sudoreplay -d /var/log/sudo -l | wc -l` cmd
