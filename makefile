up:
	docker compose build --no-cache
	docker compose up 

down:
	docker compose down -v

seed:
	docker exec -ti np-postgresDb psql -U "postgres" -d "postgres" -c "\COPY land_registry_price_paid_uk FROM '/pp-monthly-update-new-version.csv' WITH (FORMAT csv, HEADER true);"
