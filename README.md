## Build the docker

```
 docker build -t tiles .
```
This is a bit long, softwares has to be built from sources

## Start the server

    docker run --name tiles -v PATH_TO_YOUR_PROJECT:/root/osm_tiles tiles

Get the ip adress or your docker:

    docker inspect --format '{{ .NetworkSettings.IPAddress }}' tiles

You can to http://PREVIOUS-IP/osm_tiles/15/16600/11274.png
