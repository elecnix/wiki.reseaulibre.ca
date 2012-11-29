#!/bin/bash
FILE="HomeGateway.conf"
OLD="^\ *(telnets(ports))"
NEW="    (telnets\n      (ports\n        (0\n          (port(23))\n          (ssl_mode(none))\n          (remote_access(0))\n        )\n      )\n    )"

curl http://admin:admin@192.168.2.1/save_rg_conf.cgi > $FILE
sed --in-place "s/$OLD/$NEW/" $FILE
curl --data-urlencode new_rg_conf@$FILE http://admin:admin@192.168.2.1/replace_rg_conf.cgi
