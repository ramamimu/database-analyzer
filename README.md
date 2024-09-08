# commands

## copy from CSV to docker container

```
docker cp /path/to/your/file.csv np-postgresDb:/file.csv

docker exec -ti np-postgresDb psql -U postgres

\COPY your_table_name FROM '/file.csv' DELIMITER ',' CSV HEADER;
```

## column metadata

```
SELECT * FROM information_schema.columns WHERE table_name = 'your_column_name';
```