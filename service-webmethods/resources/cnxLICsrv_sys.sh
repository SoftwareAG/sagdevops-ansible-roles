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
CNXLICSRV=$CNXDIR/licenseserver
#
echo "SAG: " $SAG
echo "CNXDIR: " $CNXDIR
echo "CONNXREGISTRY64: " $CONNXREGISTRY64
echo "CNX_HOME: " $CNX_HOME
echo "CNXADM: " $CNXADM
echo "CNXLICSRV: " $CNXLICSRV
#
# managing life cycle of License server
#
case "$1" in
  start)
    echo "Starting ConnX License Server ..."
    if [ -x "${CNXLICSRV}" ]; then
       su ${CNXADM} -c "${CNXLICSRV} START"
    else
       exit 1
    fi
    echo "done..."
    ;;
  stop)
    echo "Stopping ConnX License Server ..."
    if [ -x "${CNXLICSRV}" ]; then
       su ${CNXADM} -c "${CNXLICSRV} STOP"
    else
       exit 1
    fi
    echo "done..."
    ;;
esac
exit 0

#end CONNX life cycle script