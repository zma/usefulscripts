#!/bin/bash

# Written by Eric Zhiqiang Ma (http://www.ericzma.com)

xinput list | grep 'AT Translated Set' | cut -f2 | cut -d'=' -f2

