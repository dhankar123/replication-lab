ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET max_replication_slots = 10;
ALTER SYSTEM SET listen_addresses = '*';
SELECT pg_reload_conf();
DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_roles WHERE rolname = 'replicator'
   ) THEN
      CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replica123';
   END IF;
END
$$;

-- VERY IMPORTANT: allow replication connections
ALTER SYSTEM SET password_encryption = 'scram-sha-256';