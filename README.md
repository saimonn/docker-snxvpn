snx vpn inside docker
===================

How to use:

```shell
  git clone git@github.com:saimonn/docker-snxvpn.git
  cd docker-snxvpn

  # edit snxvpn.cfg to match your configuration.
  editor snxvpn.sh
  
  # Launch the wrapper around the docker image:
  ./snxvpn.sh
```
This will build the image on first run. Use `./snxvpn -b` to build new updated image.


The `-net host` docker option shares the docker host network with the container, allowing it to add routes to local tables.

