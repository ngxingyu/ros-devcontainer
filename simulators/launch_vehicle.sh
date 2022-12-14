#!/usr/bin/env bash

# launch auv4_urdf
docker exec -ti ros-devcontainer-simulator-1 bash -c "/ros_entrypoint.sh roslaunch auv4_urdf upload.launch x:=5 y:=-10 yaw:=1.57"

# launch asv_urdf
docker exec -ti ros-devcontainer-simulator-1 bash -c "/ros_entrypoint.sh roslaunch asv_urdf upload.launch x:=-916.93 y:=266.84 yaw:=1.970796327"

# qualification_course
docker exec -ti ros-devcontainer-simulator-1 bash -c '/ros_entrypoint.sh rosservice call /gazebo/set_model_state "{'\''model_state'\'':
    {'\''model_name'\'': '\''asv'\'', '\''pose'\'': {'\''position'\'':{'\''x'\'': -857.0, '\''y'\'': 324.0, '\''z'\'': 0.0}}}}"'
# semis course
docker exec -ti ros-devcontainer-simulator-1 bash -c '/ros_entrypoint.sh rosservice call /gazebo/set_model_state "{'\''model_state'\'':
    {'\''model_name'\'': '\''asv'\'', '\''pose'\'': {'\''position'\'':{'\''x'\'': -663.0, '\''y'\'': 291.0, '\''z'\'': 0.0}}}}"'
