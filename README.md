# Vitis-Ready Docker Launcher

This fork updates the original Vivado-on-Silicon-Mac setup to better support **Xilinx Vitis** development by improving automation and adding a shared mount between the host and container.

---

##  What’s New

This version modifies the following scripts:

- **`launcher.sh`**
- **`start_container.sh`**
- **`linux_start.sh`**

### Summary of Changes
- **`launcher.sh`**  
  - Opens a new macOS Terminal window and runs `start_container.sh` automatically.  
  - You must update the script path to point to your local copy of `start_container.sh`.

- **`start_container.sh`**  
  - Automatically installs Vitis dependencies inside the container (`libnss3`, `libasound2`, `libsecret-1-0`).  
  - Mounts a shared host folder to `/home/user/MOUNT` inside the container.  
  - Starts the container, VNC session, and USB forwarding with `xvcd`.  
  - Gracefully stops all processes on exit or `Ctrl+C`.

- **`linux_start.sh`**  
  - Starts the LXDE desktop inside the container with proper VNC configuration.  
  - Automatically restores desktop environment components.  
  - Prepares the container environment for launching Vitis manually.

---

##  How to Use

### 1. Update Paths

You **must edit the following lines** in your local scripts to match your setup:

- In **`launcher.sh`**, update:
  ```bash
  SCRIPT="path/to/vivado-on-silicon-mac-main/scripts/start_container.sh"
Replace this path with the absolute path to your local start_container.sh.

- In **`start_container.sh`**, update:
  ```bash
   MOUNT_HOST_PATH="/path/to/your/MOUN"

 Replace this with the absolute path to the folder you want to share between host and container.
This shared folder will be accessible inside the container at /home/user/MOUNT.

### 2. Launch the Environment

Run the launcher:
  ```bash
./launcher.sh
```

This will:
Open a new Terminal window.
Start the Docker container.
Install Vitis dependencies automatically.
Mount your shared directory.
Start the VNC server and open the remote desktop session.

