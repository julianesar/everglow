-- ============================================================================
-- ENABLE REALTIME FOR LOGISTICS HUB TABLES
-- ============================================================================
-- This migration enables Supabase Realtime for the bookings and
-- concierge_assignments tables so that the app can receive live updates
-- when data changes.
-- ============================================================================

-- Enable Realtime for bookings table
ALTER PUBLICATION supabase_realtime ADD TABLE public.bookings;

-- Enable Realtime for concierge_assignments table
ALTER PUBLICATION supabase_realtime ADD TABLE public.concierge_assignments;

COMMENT ON PUBLICATION supabase_realtime IS 'Publication for Supabase Realtime subscriptions';
