# syntax=docker/dockerfile:experimental
FROM ngxingyu/ros-devcontainer:noetic-base as noetic

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl python3-pip python3-rosdep python3-catkin-pkg python3-catkin-tools git && \
    apt-get clean
RUN pip3 install -U --no-cache-dir supervisor supervisor_twiddler

# OSRF distribution is better for gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -L http://packages.osrfoundation.org/gazebo.key | apt-key add -



FROM alpine AS ssh_auth
# install ssh client and git
RUN apk add --no-cache openssh-client git
# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone any private repository
RUN --mount=type=ssh git clone git@github.com:ngxingyu/bbasv_descriptions.git && cd bbasv_descriptions && git checkout c19e50b45b2716f36b0c3002d548b838e41e468e
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/simulator.git && cd simulator && git checkout deab89d7575b419c64e5b7f0e17d29c78ce75137
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/bb_msgs.git && cd bb_msgs && git checkout 869a975ec102de2055818e612758c4bd3c141d49

FROM noetic AS noetic2
COPY --from=ssh_auth /bbasv_descriptions /root/catkin_ws/src/bbasv_descriptions
COPY --from=ssh_auth /simulator /root/catkin_ws/src/simulator
COPY --from=ssh_auth /bb_msgs /root/catkin_ws/src/bb_msgs

RUN source /opt/ros/noetic/setup.bash && \
    mkdir -p ~/vrx_ws/src && cd ~/vrx_ws/src && git clone --depth 1 https://github.com/ngxingyu/vrx.git -b robotx22 && \
    cd ~/vrx_ws && \
    rosdep install -i --from-path src --ignore-src -r -y --rosdistro noetic && \
    catkin build && source ~/vrx_ws/devel/setup.bash && \
    cd ~/catkin_ws && \
    catkin config -a --blacklist bbuav_gazebo_plugins && \
    catkin build bbasv_gazebo_plugins bbasv_gazebo_worlds vrx_urdf asv_urdf bb_sim_bridge

# RUN apt-get update && apt-get install -y mesa-utils bash libxtst6:amd64 libgl1-mesa-glx:amd64 libegl1-mesa && curl -L https://sourceforge.net/projects/virtualgl/files/3.0.2/virtualgl_3.0.2_amd64.deb/download --output virtualgl_3.0.2_amd64.deb && \ 
#     dpkg -i virtualgl_3.0.2_amd64.deb && apt --fix-broken install && dpkg -i virtualgl_3.0.2_amd64.deb && rm -rf /var/lib/apt/lists/*
# RUN printf "1\nn\nn\nn\nx\n" | /opt/VirtualGL/bin/vglserver_config

# COPY marker /dev/null
ADD ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod 755 /ros_entrypoint.sh

RUN sh -c 'echo "source /opt/ros/noetic/setup.bash && source ~/vrx_ws/devel/setup.bash && source ~/catkin_ws/devel/setup.bash" > ~/.bashrc'

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/root/vrx_ws/src/", "/home/developer/vrx_ws/src/"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
