#!/bin/sh

PATH=/usr/bin:/usr/sbin:/bin:/sbin
export PATH

NEWLINE_IFS='
'

do_ () {
    OLD_IFS="$IFS"; IFS=$NEWLINE_IFS

    signal=''
    host=''
    mac=''

    for iface in `iw dev | grep Interface | awk '{print $2}'`; do
        for line in `iw $iface station dump`; do
            if echo "$line" | grep -q "Station"; then
                mac=$(echo $line | awk '{print $2}' FS=" ")
            fi
            if echo "$line" | grep -q "signal:"; then
                signal=`echo "$line" | awk '{print $2}'`
                if [ $signal -eq 0 ] ; then signal="-100" ; fi
                echo "signal$mac.value $signal"
            fi
        done
    done
    IFS="$OLD_IFS"
}

do_config () {
    cat <<'EOF'
graph_title Ad-Hoc RSSI
graph_vlabel dBm
graph_category network
graph_info This plugin shows the RSSI as reported by the wireless adapter driver.
EOF
    OLD_IFS="$IFS"; IFS=$NEWLINE_IFS

    signal=''
    host=''
    mac=''

    for iface in `iw dev | grep Interface | awk '{print $2}'`; do
        for line in `iw $iface station dump`; do
            if echo "$line" | grep -q "Station"; then
                mac=$(echo $line | awk '{print $2}' FS=" ")
                if [ -f /etc/bat-hosts ]; then
                    host=$(awk -v MAC=$mac 'tolower($1)==MAC {print $2}' FS=" " /etc/bat-hosts)
                    if [ -z "$host" ]; then host=$mac; fi
                fi
                echo signal$mac.label $host
            fi
        done
    done
    IFS="$OLD_IFS"
}

do_autoconf () {
    echo yes
    exit 0
}

case $1 in
	''|config|autoconf)
		eval do_$1;;
esac
