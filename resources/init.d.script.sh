#!/bin/sh
### BEGIN INIT INFO
# Provides:             mtproxypy
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Default-Start:        2 3 4 5
# Default-Stop:
# Short-Description:    MTProxy service
### END INIT INFO


# Quick start-stop-daemon example, derived from Debian /etc/init.d/ssh
set -e

# Must be a valid filename
NAME=mtproxypy
PIDFILE=/var/run/$NAME.pid
#This is the command to be run, give the full pathname
DIR=/opt/mtprotoproxy
DAEMON=./mtprotoproxy.py
DAEMON_OPTS=""
USER=mtproxy
LOGFILE='/tmp/mtproxy_python.log'

#sysctl -w net.ipv6.conf.all.disable_ipv6=1

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
  start)
        echo -n "Starting daemon: "$NAME
        start-stop-daemon --start --quiet --background --pidfile $PIDFILE -d $DIR -m -c $USER --startas /bin/bash -- -c "exec ${DAEMON} -- ${DAEMON_OPTS} > $LOGFILE 2>&1"
        renice -15 $(cat $PIDFILE)
        echo "."
        ;;
  stop)
        echo -n "Stopping daemon: "$NAME
        start-stop-daemon --stop --signal TERM --quiet --oknodo --pidfile $PIDFILE
        echo "."
        sleep 3
        ;;
  restart)
        echo -n "Restarting daemon: "$NAME
        start-stop-daemon --stop --signal TERM --quiet --oknodo --retry 30 --pidfile $PIDFILE
        start-stop-daemon --start --quiet --background --pidfile $PIDFILE -d $DIR -m -c $USER --startas /bin/bash -- -c "exec ${DAEMON} -- ${DAEMON_OPTS} > $LOGFILE 2>&1"
        renice -15 $(cat $PIDFILE)
        echo "."
        ;;

  *)
        echo "Usage: "$1" {start|stop|restart}"
        exit 1
esac

#sysctl -w net.ipv6.conf.all.disable_ipv6=0

exit 0
