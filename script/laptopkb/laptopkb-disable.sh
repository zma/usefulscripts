#!/bin/bash

# Written by Eric Zhiqiang Ma (http://www.ericzma.com)

id=`$(dirname $(readlink -f $0))/laptopkb-get-id.sh`

xinput float $id

