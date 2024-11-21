# docker-xmrig (no fees)

# Get Started
Rename config.json.sample to config.json and edit it to your needs. 
You can use the [Wizard](https://xmrig.com/wizard) to create your config.

Default config will mine for me, thank you :)

The container runs as privileged to enable msr kernel module.

Dockerfile will fetch the last released sources, remove the min fees, and build the binary

# Starting miner
## As daemon

### Start
    sudo docker compose up -d 

### Stop 
    sudo docker compose down

### Logs
    sudo docker compose logs -f

## no daemon

### Start
    sudo docker compose up 

## rebuild (update binaries)
    sudo docker compose up --build

### Strop
    Ctrl + C


# Credits
- Repo creator: @CorentinGC
- Binary creator: https://xmrig.com/
