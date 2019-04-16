@ECHO OFF

cd ../../

ECHO ON

docker-compose up -d && docker-compose down -v

exit 0