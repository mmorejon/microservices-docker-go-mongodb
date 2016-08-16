#!/bin/bash

sed -i 's|$DB_Host|'"$DB_PORT_27017_TCP_ADDR"'|g' common/config.json

/go/bin/showtimes