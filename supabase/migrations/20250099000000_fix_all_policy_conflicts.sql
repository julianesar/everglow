-- ============================================================================
-- FIX: Drop ALL conflicting policies and triggers across all tables
-- ============================================================================
-- This migration cleans up any existing policies and triggers that would
-- conflict with subsequent migrations
-- ============================================================================

DO $$
DECLARE
    pol_record RECORD;
    trig_record RECORD;
BEGIN
    RAISE NOTICE '=== Dropping ALL existing policies ===';

    -- Drop ALL policies from ALL tables in public schema
    FOR pol_record IN
        SELECT schemaname, tablename, policyname
        FROM pg_policies
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I',
            pol_record.policyname,
            pol_record.schemaname,
            pol_record.tablename
        );
        RAISE NOTICE 'Dropped policy: % on %.%',
            pol_record.policyname,
            pol_record.schemaname,
            pol_record.tablename;
    END LOOP;

    RAISE NOTICE '=== Dropping ALL existing triggers ===';

    -- Drop ALL triggers on public schema tables
    FOR trig_record IN
        SELECT trigger_schema, event_object_table, trigger_name
        FROM information_schema.triggers
        WHERE trigger_schema = 'public'
          AND trigger_name LIKE '%updated_at%'
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I',
            trig_record.trigger_name,
            trig_record.trigger_schema,
            trig_record.event_object_table
        );
        RAISE NOTICE 'Dropped trigger: % on %.%',
            trig_record.trigger_name,
            trig_record.trigger_schema,
            trig_record.event_object_table;
    END LOOP;

    RAISE NOTICE '=== Dropping specific constraints that may conflict ===';

    -- Drop specific constraints that are added by security migrations
    BEGIN
        ALTER TABLE public.bookings DROP CONSTRAINT IF EXISTS check_booking_dates_reasonable;
        RAISE NOTICE 'Dropped constraint: check_booking_dates_reasonable from bookings';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Constraint check_booking_dates_reasonable does not exist or could not be dropped';
    END;

    RAISE NOTICE '=== Cleanup complete - Ready for fresh schema ===';
END $$;
