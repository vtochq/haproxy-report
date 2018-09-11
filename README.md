# haproxy-report

Script for generating daily reports. Backends usage by countries.

Requirements: geoiplookup

Usage:

geo \<backend> [\<logfile>] - geo stat by backend
  
geo report [backends (space separated)] - generate daily report by backends [<logfile>]
  
geo list [\<logfile>] - list frontends and backends
  
