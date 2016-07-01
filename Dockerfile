from debian:8

RUN ls
RUN apt-get update
RUN apt-get install -y libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-python-dev libboost-regex-dev libboost-system-dev libboost-thread-dev
RUN apt-get install -y subversion git-core tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libpq-dev libbz2-dev proj-bin munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libpng12-dev libtiff5-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont libproj-dev

RUN mkdir ~/src
RUN cd ~/src && git clone git://github.com/mapnik/mapnik \
    && cd mapnik && git branch 2.0 origin/2.0.x && git checkout 2.0 \
    && python scons/scons.py configure INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/truetype/ \
    && python scons/scons.py -j3 \
    && python scons/scons.py install \
    && ldconfig \
    && python scons/scons.py -c #cleanning

RUN cd ~/src \
    && git clone git://github.com/openstreetmap/mod_tile.git \
    && cd mod_tile \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && make install-mod_tile \
    && ldconfig \
    && make clean

RUN mkdir -p /var/run/renderd /var/lib/mod_tile
RUN apt-get -y install node-carto
RUN mkdir shp && cd shp && wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip \
    && wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip \
    && unzip land-polygons-split-3857.zip \
    && unzip simplified-land-polygons-complete-3857.zip \
    && rm *.zip

RUN apt-get install -y supervisor
WORKDIR /root/
ADD entrypoint.sh /root/entrypoint.sh
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD renderd.conf /usr/local/etc/renderd.conf
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
CMD /root/entrypoint.sh
