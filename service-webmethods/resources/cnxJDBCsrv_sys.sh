#!/bin/sh
#
if [ -z "$SAG" ] ; then
    SAG="/opt/softwareag"
    export SAG
fi
#
if [ -z "$CNXDIR" ] ; then
    CNXDIR=$SAG/connx
        export CNXDIR
fi
#
if [ -z "$CONNXREGISTRY64" ] ; then
    CONNXREGISTRY64=$CNXDIR/connxreg64.db
        export CONNXREGISTRY64
fi
#
CNX_HOME=$CNXDIR
CNXADM=saguser
# Set /usr/bin to make sure to find system commands like su, ps (HP)
# 
PATH=/usr/bin:$PATH;
export PATH 
#
CNXJDBCSRV=$CNXDIR/jdbcserver64
#
echo "SAG: " $SAG
echo "CNXDIR: " $CNXDIR
echo "CONNXREGISTRY64: " $CONNXREGISTRY64
echo "CNX_HOME: " $CNX_HOME
echo "CNXADM: " $CNXADM
echo "CNXJDBCSRV: " $CNXJDBCSRV
#
# managing life cycle of JDBC server 64 bit
#
case "$1" in
  start)
    echo "Starting ConnX JDBC Server 64 bit ..."
    if [ -x "${CNXJDBCSRV}" ]; then
       su ${CNXADM} -c "${CNXJDBCSRV} START"
    else
       exit 1
    fi
    echo "done..."
    ;;
  stop)
    echo "Stopping ConnX JDBC Server 64 bit ..."
    if [ -x "${CNXJDBCSRV}" ]; then
       su ${CNXADM} -c "${CNXJDBCSRV} STOP"
    else
       exit 1
    fi
    echo "done..."
    ;;
esac
exit 0

#end CONNX life cycle script