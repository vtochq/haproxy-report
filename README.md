# haproxy-report

Script for generating daily reports. Backends usage by countries.

Requirements: geoiplookup

Usage:

./geo.sh \<backend> [\<logfile>] - geo stat by backend
  
./geo.sh report [backends (space separated)] - generate daily report by backends [<logfile>]
  
./geo.sh list [\<logfile>] - list frontends and backends
  
For daily reports just run it in cron at 23:59 and send output by email or smth like that.

crontab:

59 23 * * * /root/geo.sh report | smtp="<SMARTHOST:25>" mailx -s "HA-Proxy report" "<MAILTO>"
