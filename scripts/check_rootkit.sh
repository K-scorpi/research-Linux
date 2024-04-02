#!/bin/bash
dmesg | grep -Eo 'rootkit ok' > /home/os/p.log
