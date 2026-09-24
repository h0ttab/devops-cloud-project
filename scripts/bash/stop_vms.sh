#!/bin/bash
set -e
yc compute instance stop "ci-server" 2>/dev/null &
yc compute instance stop "app-server" 2>/dev/null &
yc compute instance stop "obs-server" 2>/dev/null &
wait
echo "VMs has been stopped"