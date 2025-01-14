# Running Hummingbot via Docker

Using a pre-compiled version of Hummingbot from Docker allows you to run instances with a few simple commands.

Docker images of Hummingbot are available on Docker Hub at [coinalpha/hummingbot](https://hub.docker.com/r/coinalpha/hummingbot).

## Automated Docker Scripts (Optional)

We have created Docker command install scripts (for additional details, navigate to [Github: Hummingbot Docker scripts](https://github.com/CoinAlpha/hummingbot/tree/development/installation/docker-commands)).

Copy the commands below and paste into Terminal to download and enable the automated scripts.

```bash tab="Linux"
wget https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/create.sh
wget https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/start.sh
wget https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/connect.sh
wget https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/update.sh
chmod a+x *.sh
```

```bash tab="MacOS"
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/create.sh -o create.sh
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/start.sh -o start.sh
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/connect.sh -o connect.sh
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/update.sh -o update.sh
chmod a+x *.sh
```

```bash tab="Windows (Docker Toolbox)"
cd ~
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/create.sh -o create.sh
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/start.sh -o start.sh
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/connect.sh -o connect.sh
curl https://raw.githubusercontent.com/CoinAlpha/hummingbot/development/installation/docker-commands/update.sh -o update.sh
chmod a+x *.sh
```

## Basic Docker Commands for Hummingbot

#### Create Hummingbot Instance

The following commands will (1) create folders for config and log files, and (2) create and start a new instance of Hummingbot:

```bash tab="Script"
./create.sh
```

```bash tab="Detailed Commands"
# 1) Create folder for your new instance
mkdir hummingbot_files

# 2) Create folder for config files
mkdir hummingbot_files/hummingbot_conf

# 3) Create folder for log files
mkdir hummingbot_files/hummingbot_logs

# 4) Launch a new instance of hummingbot
#    The command below names your new instance "hummingbot-instance" (line 15)
#    and uses the "latest" docker image (line 18).
#    Lines 16-17 specify the location for the folders created in steps 2 and 3.
docker run -it \
--name hummingbot-instance \
--mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf/" \
--mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs/" \
coinalpha/hummingbot:latest
```

#### Connecting to a Running Hummingbot Instance

If you exited terminal (e.g. closed window) and left Hummingbot running, the following command will reconnect to your Hummingbot instance:

```bash tab="Script"
./connect.sh
```

```bash tab="Detailed Command"
docker attach hummingbot-instance
```

#### Restarting Hummingbot after Shutdown

If you have previously created an instance of Hummingbot which you shut down (e.g. by command `exit`), the following command restarts the intance and connects to it:

```bash tab="Script"
./start.sh
```

```bash tab="Detailed Commands"
# 1) Start hummingbot instance
docker start hummingbot-instance

# 2) Connect to hummingbot instance
docker attach hummingbot-instance
```

#### Updating Hummingbot

We regularly update Hummingbot (see: [releases](/release-notes/)) and recommend users to regularly update their installations to get the latest version of the software.  

Updating to the latest docker image (e.g. `coinalpha/hummingbot:latest`) requires users to (1) delete any instances of Hummingbot using that image, (2) delete the old image, and (3) recreate the Hummingbot instance:

```bash tab="Script"
./update.sh
```

```bash tab="Detailed Commands"
# 1) Delete instance
docker rm hummingbot-instance

# 2) Delete old hummingbot image
docker image rm coinalpha/hummingbot:latest

# 3) Re-create instance with latest hummingbot release
docker run -it \
--name hummingbot-instance \
--mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_conf,destination=/conf/" \
--mount "type=bind,source=$(pwd)/hummingbot_files/hummingbot_logs,destination=/logs/" \
coinalpha/hummingbot:latest
```


## Hummingbot Setup

#### Docker Command Parameters

The instructions on this page assume the following variable names and/or parameters.  You can customize these names.

Parameter | Description
---|---
`hummingbot_files` | Name of the folder where your config and log files will be saved
`hummingbot-instance` | Name of your instance
`latest` | Image version, e.g. `latest`, `development`, or a specific version such as `0.9.1`
`hummingbot_conf` | Folder in `hummingbot_files` where config files will be saved (mapped to `conf/` folder used by Hummingbot)
`hummingbot_logs` | Folder in `hummingbot_files` where logs files will be saved (mapped to `logs/` folder used by Hummingbot)

#### Config and Log Files

The above methodology requires you to explicitly specify the paths where you want to mount the `conf/` and `logs/` folders on your local machine.

The example commands above assume that you create three folders:

```
hummingbot_files       # Top level folder for your instance
├── hummingbot_conf    # Maps to hummingbot's conf/ folder, which stores configuration files
└── hummingbot_logs    # Maps to hummingbot's logs/ folder, which stores log files
```

!!! info "`docker run` command and the `hummingbot_files` folder"
    - The `docker run` command (when creating a new instance or updating Hummingbot version) must be run from the folder that contains the `hummingbot_files` folder. By default, this should be the root folder.
    - You must create all folders prior to using the `docker run` command.

## Reference: Useful Docker Commands

Command | Description
---|---
`docker ps` | List all running containers
`docker ps -a` | List all created containers (including stopped containers)
`docker attach hummingbot-instance` | Connect to a running Docker container
`docker start hummingbot-instance` | Start a stopped container
`docker inspect hummingbot-instance` | View details of a Docker container, including details of mounted folders