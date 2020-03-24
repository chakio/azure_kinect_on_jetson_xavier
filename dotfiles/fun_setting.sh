#!/bin/bash

echo "# fun setting"
sudo  nvpmodel  -m  0 && sudo jetson_clocks
sudo echo "sudo  nvpmodel  -m  0 && sudo jetson_clocks" > /etc/rc.local
sudo chmod u+x /etc/rc.local
