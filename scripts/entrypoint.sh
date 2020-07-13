#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start ${PGHOST} ${PGPORT} ${PGUSER}"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
   mix ecto.create
   mix ecto.migrate
   mix run priv/repo/seeds.exs
  ./_build/prod/rel/$APP_NAME/bin/$APP_NAME eval "Mysolat.Release.migrate"
  echo "Database $PGDATABASE created."

else
  ./_build/prod/rel/$APP_NAME/bin/$APP_NAME eval "Mysolat.Release.migrate"
fi

#exec mix phx.server
exec ./_build/prod/rel/$APP_NAME/bin/$APP_NAME start
