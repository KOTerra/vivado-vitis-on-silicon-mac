#!/bin/zsh

# starts the Docker container and xvcd for USB forwarding
# now automatically installs Vitis dependencies

script_dir=$(dirname -- "$(readlink -nf $0)";)
source "$script_dir/header.sh"
validate_macos

# Host path to your MOUNT repository
MOUNT_HOST_PATH="/path/to/your/MOUNT"

# this is called when the container stops or ctrl+c is hit
function stop_container {
    docker kill vivado_container > /dev/null 2>&1
    f_echo "Stopped Docker container"
    killall xvcd > /dev/null 2>&1
    f_echo "Stopped xvcd"
    exit 0
}
trap 'stop_container' INT

# Make sure everything is setup to run the container
start_docker
if [[ $(docker ps) == *vivado_container* ]]
then
    f_echo "There is already an instance of the container running."
    exit 1
fi
killall xvcd > /dev/null 2>&1

# Run container with MOUNT repo mounted
docker run --init --rm --name vivado_container \
    --mount type=bind,source="$script_dir/..",target="/home/user" \
    --mount type=bind,source="$MOUNT_HOST_PATH",target="/home/user/MOUNT" \
    -p 127.0.0.1:5901:5901 \
    --platform linux/amd64 \
    x64-linux sudo -H -u user bash /home/user/scripts/linux_start.sh &

f_echo "Started container"
sleep 10  # wait for container to fully initialize

# Automatically install Vitis dependencies inside the container
f_echo "Installing Vitis dependencies..."
docker exec -it vivado_container bash -c "apt-get update && apt-get install -y --no-install-recommends libnss3 libasound2 libsecret-1-0"
f_echo "Vitis dependencies installed"

# Start VNC viewer
f_echo "Starting VNC viewer..."
vncpass=$( tr -d "\n\r\t " < "$script_dir/vncpasswd" )
# Wait until the container's VNC server is ready
while ! nc -z localhost 5901; do sleep 1; done
open "vnc://user:$vncpass@localhost:5901"

# Run xvcd for USB forwarding
f_echo "Running xvcd for USB forwarding..."
while [[ $(docker ps) == *vivado_container* ]]
do
    if pg
