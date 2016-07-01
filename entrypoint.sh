#!/bin/bash

cd osm_tiles
rm shp
ln -s /shp .
carto project.mml > osm.xml

service apache2 start
renderd -f -c /usr/local/etc/renderd.conf
#/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
