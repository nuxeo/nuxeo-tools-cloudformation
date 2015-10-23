#! /bin/sh
### BEGIN INIT INFO
# Provides:          elasticsearch
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts elasticsearch
# Description:       Starts elasticsearch using start-stop-daemon
### END INIT INFO

export ES_HOME=/opt/es/elasticsearch
# MemTotal * 80% / 2**20 (convert kB to GB)
export ES_HEAP_SIZE=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 131072 / 10 ))g
DAEMON=$ES_HOME/bin/elasticsearch
NAME=elasticsearch
DESC=elasticsearch
PID_DIR=/var/run/$NAME
PID_FILE=$PID_DIR/$NAME.pid
DAEMON_OPTS="-d -p $PID_FILE -Des.path.home=$ES_HOME"
USER=es

ulimit -n 65536
ulimit -l unlimited

test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
    echo -n "Starting $DESC: "
    if [ ! -d $PID_DIR ]; then
        mkdir -p $PID_DIR
        chown $USER:$USER $PID_DIR
    fi
    if start-stop-daemon --start --chuid $USER:$USER --pidfile $PID_FILE --startas $DAEMON -- $DAEMON_OPTS
    then
        echo "started."
    else
        echo "failed."
    fi
    ;;
  stop)
    echo -n "Stopping $DESC: "
    if start-stop-daemon --stop --pidfile $PID_FILE
    then
        echo "stopped."
    else
        echo "failed."
    fi
    ;;
  restart|force-reload)
    ${0} stop
    sleep 0.5
    ${0} start
    ;;
  *)
    N=/etc/init.d/$NAME
    echo "Usage: $N {start|stop|restart|force-reload}" >&2
    exit 1
    ;;
esac

exit 0

