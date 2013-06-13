#!/bin/bash
# ferm daemon
# chkconfig: 345 20 80
# description: ferm daemon
# processname: ferm

DAEMON_PATH="/usr/sbin/ferm"

DAEMON=ferm
DAEMONOPTS=""

NAME=ferm
DESC="My daemon description"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

case "$1" in
start)
	printf "%-50s" "Starting $NAME..."
	ferm -nl /etc/ferm.conf 1>/dev/null 2>&1
	if [ ! $? -eq 0 ] ; then
		printf "%s\n" "Fail" 
	else
		/usr/sbin/ferm /etc/ferm.conf
		printf "%s\n" "Ok"
	fi
#	cd $DAEMON_PATH
#	PID=`$DAEMON $DAEMONOPTS > /dev/null 2>&1 & echo $!`
#	#echo "Saving PID" $PID " to " $PIDFILE
#        if [ -z $PID ]; then
#            printf "%s\n" "Fail"
#        else
#            echo $PID > $PIDFILE
#            printf "%s\n" "Ok"
#        fi
;;
status)
        printf "%-50s" "Checking $NAME..."
	/usr/sbin/ferm -nl /etc/ferm.conf 2>&1
#        if [ -f $PIDFILE ]; then
#            PID=`cat $PIDFILE`
#            if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
#                printf "%s\n" "Process dead but pidfile exists"
#            else
#                echo "Running"
#            fi
#        else
#            printf "%s\n" "Service not running"
#        fi
;;
stop)
        printf "%-50s" "Stopping $NAME"
	ferm -F /etc/ferm.conf
	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -P FORWARD ACCEPT
	printf "%s\n" "Ok"
#            cd $DAEMON_PATH
#        if [ -f $PIDFILE ]; then
#            kill -HUP $PID
#            printf "%s\n" "Ok"
#            rm -f $PIDFILE
#        else
#            printf "%s\n" "pidfile not found"
#        fi
;;

restart)
  	$0 stop
  	$0 start
;;

*)
        echo "Usage: $0 {status|start|stop|restart}"
        exit 1
esac
