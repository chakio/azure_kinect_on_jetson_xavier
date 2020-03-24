#!/bin/bash

echo "# fun setting"
sudo  nvpmodel  -m  0 && sudo jetson_clocks
sudo echo -e "#!/bin/sh -e \n nvpmodel  -m  0 && jetson_clocks \n exit 0" >> /etc/rc.local
sudo chmod u+x /etc/rc.local
