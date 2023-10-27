docker-compose up -d

docker logs -f geoserver-h2 >& logs/geoserver.log &
docker logs -f h2-geodb >& logs/h2.log &
