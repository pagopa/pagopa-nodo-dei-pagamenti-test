
docker compose -p "ndp-k6" up -d --remove-orphans --force-recreate --build
docker logs -f k6
docker stop nginx
