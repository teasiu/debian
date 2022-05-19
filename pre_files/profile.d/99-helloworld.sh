IP=$(ifconfig eth0 | grep '\<inet\>'| grep -v '127.0.0.1' | awk '{print $2}' | awk 'NR==1')
clear
linuxlogo -L 16
echo -e "\e[0m
		Welcome to use\e[31m Debian NAS server\e[0m
		Design by Teasiu & Hyy2001
		Internat IP : \e[32mhttp://$IP\e[0m
		Our Website : \e[32mhttps://bbs.histb.com\e[0m

   Device  : $(dmesg | grep "CPU: hi" | awk -F ':[ ]' '/CPU/{printf ($2)}')
   Version : $(awk -F '[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release) | V$(cat /etc/nasversion)-$(uname -r)
   Uptime  : $(awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=($1%60)} {printf("%d day %d hour %d min %d sec\n",a,b,c,d)}' /proc/uptime)
   IP Add  : $IP
   Temp    : \e[31m$(cat /proc/msp/pm_cpu | grep Tsensor | awk '{print $4}')\e[0m\e[32m C \e[0m
"

alias reload='. /etc/profile'
alias ramfree='sync && echo 3 > /proc/sys/vm/drop_caches'
alias cls='clear'
alias ll='ls -al'
alias syslog='cat /var/log/syslog'
