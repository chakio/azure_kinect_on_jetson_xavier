#!/bin/bash

echo "# docker setting"
gpasswd -a $(whoami) docker
chgrp docker /var/run/docker.sock
service docker restart
