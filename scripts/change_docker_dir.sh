echo "Stop Docker"
sudo /etc/init.d/docker stop
echo "Move Docker Images to Destination"
sudo mv /var/lib/docker /media/ytjs2020d/ssd/
echo "Make Symbolic Link to Destination"
sudo ln -s /media/ytjs2020d/ssd/docker/ /var/lib/docker
echo "Restart Docker"
sudo /etc/init.d/docker start