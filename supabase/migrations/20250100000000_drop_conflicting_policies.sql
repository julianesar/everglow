-- ============================================================================
-- FIX: Drop conflicting policies before applying new migrations
-- ============================================================================
-- This migration runs BEFORE the main schema migration to clean up
-- any existing policies that would conflict with the new ones.
-- ============================================================================

-- Drop all existing policies on bookings table (if they exist)
DROP POLICY IF EXISTS "Users can read their own bookings" ON public.bookings;
DROP POLICY IF EXISTS "Users can insert their own bookings" ON public.bookings;
DROP POLICY IF EXISTS "Users can update their own bookings" ON public.bookings;
DROP POLICY IF EXISTS "Users can delete their own bookings" ON public.bookings;
DROP POLICY IF EXISTS "Users can manage own bookings" ON public.bookings;

-- Drop any other conflicting policies on other tables (preventive)
DROP POLICY IF EXISTS "Users can read their own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.user_profiles;

DROP POLICY IF EXISTS "Users can read their own responses" ON public.user_onboarding_responses;
DROP POLICY IF EXISTS "Users can insert their own responses" ON public.user_onboarding_responses;
DROP POLICY IF EXISTS "Users can update their own responses" ON public.user_onboarding_responses;
DROP POLICY IF EXISTS "Users can delete their own responses" ON public.user_onboarding_responses;

DROP POLICY IF EXISTS "Users can read their own task completions" ON public.user_task_completions;
DROP POLICY IF EXISTS "Users can insert their own task completions" ON public.user_task_completions;
DROP POLICY IF EXISTS "Users can delete their own task completions" ON public.user_task_completions;

DROP POLICY IF EXISTS "Users can read their own journal responses" ON public.user_journal_responses;
DROP POLICY IF EXISTS "Users can insert their own journal responses" ON public.user_journal_responses;
DROP POLICY IF EXISTS "Users can update their own journal responses" ON public.user_journal_responses;
DROP POLICY IF EXISTS "Users can delete their own journal responses" ON public.user_journal_responses;

DROP POLICY IF EXISTS "Users can read their own commitments" ON public.user_commitments;
DROP POLICY IF EXISTS "Users can insert their own commitments" ON public.user_commitments;
DROP POLICY IF EXISTS "Users can delete their own commitments" ON public.user_commitments;

DROP POLICY IF EXISTS "Public read access" ON public.onboarding_questions;
DROP POLICY IF EXISTS "Anyone can read onboarding questions" ON public.onboarding_questions;
DROP POLICY IF EXISTS "Public read access" ON public.daily_journey_content;
DROP POLICY IF EXISTS "Anyone can read daily journey content" ON public.daily_journey_content;
DROP POLICY IF EXISTS "Public read access" ON public.itinerary_items;
DROP POLICY IF EXISTS "Anyone can read itinerary items" ON public.itinerary_items;
DROP POLICY IF EXISTS "Public read access" ON public.journaling_prompts;
DROP POLICY IF EXISTS "Anyone can read journaling prompts" ON public.journaling_prompts;
DROP POLICY IF EXISTS "Public read access" ON public.aftercare_content;
DROP POLICY IF EXISTS "Anyone can read aftercare content" ON public.aftercare_content;

-- Log completion
DO $$
BEGIN
  RAISE NOTICE 'Conflicting policies dropped successfully';
END $$;
