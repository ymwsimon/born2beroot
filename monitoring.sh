arch=$(uname -a | sed 's|PREEMPT_DYNAMIC ||g')
nCPU=$(lscpu | grep "Socket(s):" | sed -E 's|Socket\(s\): +||g')
vCPU=$(lscpu | head -n 5 | grep "CPU(s):" | sed -E 's|CPU\(s\): +||g')
usedMem=$(free -m | grep "Mem:" | tr -s ' ' | cut -d ' ' -f 3)
totalMem=$(free -m | grep "Mem:" | tr -s ' ' | cut -d ' ' -f 2)
memp=$(echo "scale = 2; $usedMem * 100 / $totalMem" | bc)
usedDisk=$(df -h --total | grep "total" | tr -s " " | cut -d " " -f 3 | sed 's|G||g')
totalDisk=$(df -h --total | grep "total" | tr -s " " | cut -d " " -f 2)
diskp=$(df -h --total | grep "total" | tr -s " " | cut -d " " -f 5)
cpuidle=$(mpstat | grep "all" | tr -s " " | cut -d " " -f 12)
cpuload=$(echo "100 $cpuidle" | awk '{printf "%.2f", $1 - $2}')
lastboot=$(who -b | tr -s " " | sed 's| system boot ||g')
lvm(){
	if [ $(expr $(mount | grep "mapper" | wc -l)) != 0 ]
    	then
	    echo "yes"
    	else
	    echo "no"
	fi
     }
tcp=$(netstat | sed -E 's|tcp.+EST|tcpEST|g' | grep "tcpESTABLISHED" | wc -l)
nuser=$(users | wc -w)
ipaddr=$(hostname -I | cut -d " " -f1)
macaddr=$(ip a show enp0s3 | grep "ether" | tr -s " " | cut -d " " -f 3)
nsudo=$(journalctl -q _COMM=sudo | grep -E "TTY.+PWD" | wc -l)
message="	#Architecture 	 : $arch
	#CPU physical	 : $nCPU
	#vCPU		 : $vCPU
	#Memory Usage	 : $usedMem/$totalMem"MB" ($memp%)
	#Disk Usage  	 : $usedDisk/$totalDisk"B" ($diskp)
	#CPU load    	 : $cpuload%
	#Last boot   	 : $lastboot
	#LVM use     	 : $(lvm)
	#Connections TCP : $tcp ESTABLISHED
	#User log	 : $nuser
	#Network	 : IP $ipaddr ($macaddr)
	#Sudo		 : $nsudo cmd"

wall "$message"
