docker rm geoserver
docker run -d -p 8080:8080 --name=geoserver geoserver
docker logs -f geoserver
xdg-open http://localhost:8080/geoserver/web/
