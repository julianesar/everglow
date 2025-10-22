-- Verify which tables have Realtime enabled
SELECT schemaname, tablename
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
ORDER BY tablename;
