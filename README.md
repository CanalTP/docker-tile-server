Build the docker
#################

```
 docker build -t tiles .
```
This is a bit long, softwares has to be built from sources

Start the server
################

    docker run -v PATH_TO_YOUR_PROJECT:/root/osm_tiles tiles
