## source 
CATKIN_HOME=/home/catkin_ws
source ${CATKIN_HOME}/devel/setup.bash

## setting
network_if=eth0 

## export
#export ros_master=global
export ros_master=local
export ros_master_global=192.168.1.55

export ROS_HOME=~/.ros
export TARGET_IP=$(LANG=C /sbin/ifconfig $network_if | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
if [ -z "$TARGET_IP" ] ; then
    echo "ROS_IP is not set."
else
    export ROS_IP=$TARGET_IP
fi
if [ ${ros_master} = local ] ; then
    echo "ROS_MASER : LOCAL" 
    export ROS_MASTER_URI=http://$TARGET_IP:11311
else
    echo "ROS_MASER : GLOBAL" 
    export ROS_MASTER_URI=http://$ros_master_global:11311
fi

## alias
cdls()
{
    \cd "$@" && ls
}
alias cd="cdls"
alias cm="cd ${CATKIN_HOME} && catkin_make && cd -"

## echo
echo "ROS_IP:"$ROS_IP
echo "ROS_MASTER_URI:"$ROS_MASTER_URI

