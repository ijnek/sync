# sync
script to sync a robot from a pre-compiled ROS 2 workspace

# Prerequisite
Make sure you have the prerequisites installed:

```sh
sudo apt update
sudo apt install wget rsync
```

Download the script from this repository and make it executable, using:

```sh
wget https://raw.githubusercontent.com/ijnek/sync/main/sync.sh && chmod +x sync.sh
```

The script can be downloaded to any directory on your computer.

# Run script

**Make sure you are in the workspace that you intend to sync to the robot.**

Then, run:

```sh
/path/to/sync.sh user hostname
# OR
/path/to/sync.sh user ip-address
```

replace ``/path/to/sync.sh`` with the actual path on your computer to the downloaded sync.sh file. This file will exist where you invoked the download from.

where:
* ``user`` is the username on the remote host you are syncing to
* ``hostname`` or ``ip-address`` is the hostname or ip address of the remote host you are syncing to

## Example:

To use the script to sync a workspace to a NAO robot with user name ``nao`` and IP address 10.0.0.18:
```sh
/path/to/sync.sh nao 10.0.0.18
```

