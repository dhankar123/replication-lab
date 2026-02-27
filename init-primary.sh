#!/bin/bash
set -e

# 1. Add replication permission to pg_hba.conf
# This allows the 'replicator' user to connect from any IP in the docker network
echo "host replication replicator 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

# 2. Create the replicator user with the correct permissions
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE replicator WITH REPLICATION PASSWORD '1234' LOGIN;
EOSQL