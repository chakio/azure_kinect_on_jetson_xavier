xhost +
docker run -it \
--privileged \
--runtime=nvidia \
--env=DISPLAY=$DISPLAY \
--env="XAUTHORITY=${XAUTH}" \
--env="QT_X11_NO_MITSHM=1" \
--env="LIBGL_ALWAYS_INDIRECT=" \
--env="LIBGL_ALWAYS_SOFTWARE=1" \
--rm \
-v "/$(pwd)/ros_setting.sh:/ros_setting.sh" \
-v "/$(pwd)/ros_workspace/:/home/catkin_ws/" \
-v /etc/group:/etc/group:ro \
-v /etc/passwd:/etc/passwd:ro \
--net host \
chakio:azurekinect_arm \