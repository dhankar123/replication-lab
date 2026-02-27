#!/bin/bash
set -e

# Create replication user
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
  CREATE ROLE replicator WITH REPLICATION PASSWORD '$REPLICATOR_PASSWORD' LOGIN;
  ALTER SYSTEM SET wal_level = 'replica';
  ALTER SYSTEM SET max_wal_senders = 10;
  ALTER SYSTEM SET wal_keep_size = '64MB';
  ALTER SYSTEM SET listen_addresses = '*';
EOSQL

# Allow replication connections
echo "host replication replicator 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

# Reload configuration
psql -U "$POSTGRES_USER" -c "SELECT pg_reload_conf();"