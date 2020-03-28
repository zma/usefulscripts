#!/bin/bash

# Written by Eric Ma (https://www.ericzma.com)

id=`$(dirname $(readlink -f $0))/laptopkb-get-id.sh`

xinput reattach $id 3

