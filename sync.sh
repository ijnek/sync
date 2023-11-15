#! /usr/bin/env bash

Help()
{
  # Display Help
  echo -e "Syncs a robot with the current workspace."
  echo -e "Usage: sync.sh [options] <user> <hostname>"
  echo -e "       sync.sh [options] <user> <ip address>"
  echo -e
  echo -e "Options:"
  echo -e "\t-h\tDisplay this help message."
}

# Get the options
while getopts ":h" option; do
  case $option in
    h) # display Help
      Help
      exit;;
    \?) # incorrect option
      echo "Error: Invalid option"
      exit;;
  esac
done

# Remove the options from the positional parameters
shift $((OPTIND - 1))

# Check if the positional parameters are valid
if [ $# -ne 2 ]; then
  echo "Error: Invalid number of positional parameters"
  exit
fi

user=$1
hostname=$2
port=22

echo "Checking if $user@$hostname is up"
ssh -p $port -q $user@$hostname -o ConnectTimeout=1 exit
if [ $? -ne 0 ]; then
  echo "Error: $user@$hostname is down. Please make sure that you can access the robot via 'ssh $user@$hostname'."
  exit
fi
echo "$user@$hostname is up"

# Create /tmp/install_dependencies.sh
echo "Creating /tmp/install_dependencies.sh"
AMENT_PREFIX_PATH="none" bash -c "rosdep install --default-yes --ignore-src -r --simulate --reinstall --as-root apt:false -n --from-paths src > /tmp/install_dependencies.sh"
chmod +x /tmp/install_dependencies.sh

# Copy the install_dependencies.sh to the robot
echo "Copying install_dependencies.sh to the robot"
rsync -e "ssh -p $port" --progress /tmp/install_dependencies.sh $1@$2:/tmp/install_dependencies.sh

# Copy the install/ directory to the robot
remote_install_dir='~/'$(basename $(pwd))
echo "Copying contents of install/ to $1@$2:$remote_install_dir"
rsync -e "ssh -p $port" --progress -r install $1@$2:$remote_install_dir

echo "Installing dependencies on the robot"
ssh -p $port $1@$2 "sudo /tmp/install_dependencies.sh"

echo "Syncing done! Run 'source $remote_install_dir/setup.bash' on the robot."
