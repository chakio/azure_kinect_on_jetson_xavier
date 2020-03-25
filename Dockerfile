# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM nvcr.io/nvidia/l4t-base:r32.3.1

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
ARG DEBIAN_FRONTEND=noninteractive
#######################################################################
##                    install additional package                     ##
#######################################################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    build-essential \
    libxau-dev \
    libxdmcp-dev \
    libxcb1-dev \
    libxext-dev \
    libx11-dev && \
    rm -rf /var/lib/apt/lists/*

#######################################################################
##                            ros install                            ##
#######################################################################
# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*
# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
# setup keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update && apt-get install -y \
    python-rosinstall \
    python-rosdep \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init 
RUN rosdep update

# install bootstrap tools
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop \
    && rm -rf /var/lib/apt/lists/*

# install ros packages
ENV ROS_DISTRO melodic
 
# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

#######################################################################
##                       install azure kinect                        ##
#######################################################################
RUN apt-get update && apt-get install -y \
    ninja-build \
    doxygen \
    clang \
    gcc-multilib-arm-linux-gnueabihf \
    g++-multilib-arm-linux-gnueabihf && \
   rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    freeglut3-dev \
    libgl1-mesa-dev \
    mesa-common-dev \
    libsoundio-dev \
    libvulkan-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxrandr-dev \
    uuid-dev \
    libsdl2-dev \
    usbutils \
    libusb-1.0-0-dev \
    openssl \
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# update cmake
RUN wget https://cmake.org/files/v3.16/cmake-3.16.5.tar.gz  -O cmake-3.16.5.tar.gz
RUN tar -zxvf cmake-3.16.5.tar.gz 
WORKDIR /cmake-3.16.5

RUN ./bootstrap
RUN make
RUN make install

RUN apt-get update && apt-get install -y \
	g++ \
	perl

# install azure kinect sdk
WORKDIR /
RUN apt-get update && apt-get install -y \
    zip \
    unzip && \
   rm -rf /var/lib/apt/lists/*
RUN wget https://www.nuget.org/api/v2/package/Microsoft.Azure.Kinect.Sensor/1.4.0 -O microsoft.azure.kinect.sensor.1.4.0.nupkg 
RUN mv microsoft.azure.kinect.sensor.1.4.0.nupkg  microsoft.azure.kinect.sensor.1.4.0.zip
RUN unzip -d microsoft.azure.kinect.sensor.1.4.0 microsoft.azure.kinect.sensor.1.4.0.zip

RUN cp /microsoft.azure.kinect.sensor.1.4.0/linux/lib/native/arm64/release/libdepthengine.so.2.0 /lib/aarch64-linux-gnu/
RUN cp /microsoft.azure.kinect.sensor.1.4.0/linux/lib/native/arm64/release/libdepthengine.so.2.0 /usr/lib/aarch64-linux-gnu/
RUN chmod a+rwx /usr/lib/aarch64-linux-gnu
RUN chmod a+rwx -R /lib/aarch64-linux-gnu/

WORKDIR /home

RUN git clone https://github.com/microsoft/Azure-Kinect-Sensor-SDK.git
COPY ./lib/libdepthengine.so.2.0 /home/Azure-Kinect-Sensor-SDK/build/bin/libdepthengine.so.2.0
RUN chmod a+rwx -R /home/Azure-Kinect-Sensor-SDK/build/bin/

RUN cd /home/Azure-Kinect-Sensor-SDK &&\
    mkdir -p build && \
    cd build &&\
    cmake .. -GNinja &&\
    ninja &&\
    ninja install

RUN mkdir -p /etc/udev/rules.d/
RUN cp /home/Azure-Kinect-Sensor-SDK/scripts/99-k4a.rules /etc/udev/rules.d/99-k4a.rules
RUN chmod a+rwx /etc/udev/rules.d

#######################################################################
##                   install additional packages                     ##
#######################################################################
RUN apt-get update && apt-get install -y \
    ros-melodic-tf2-geometry-msgs && \
   rm -rf /var/lib/apt/lists/*

#######################################################################
##                 install azure kinect ros driver                   ##
#######################################################################
   #init catkin_ws
RUN mkdir -p /home/catkin_ws/src && \
   cd /home/catkin_ws/src && \
   /bin/bash -c 'source /opt/ros/melodic/setup.bash;catkin_init_workspace' && \
   cd /home/catkin_ws && \
   /bin/bash -c 'source /opt/ros/melodic/setup.bash;catkin_make' && \
   cd /home/catkin_ws/src && \
   git clone https://github.com/microsoft/Azure_Kinect_ROS_Driver.git

RUN cd /home/catkin_ws && \
   /bin/bash -c 'source /opt/ros/melodic/setup.bash;catkin_make'

#######################################################################
##                           ros settings                            ##
#######################################################################
RUN echo "export PS1='\[\e[1;31;40m\]Azure kinect for jetson\[\e[0m\] \u:\w\$ '">> ~/.bashrc
RUN echo "source /ros_setting.sh">> ~/.bashrc