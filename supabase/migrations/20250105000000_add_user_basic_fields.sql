-- ============================================================================
-- ADD BASIC USER FIELDS TO USER_PROFILES
-- ============================================================================
-- This migration adds name and integration_statement fields to user_profiles
-- to support the User feature's basic data storage.
-- ============================================================================

-- Add name field
ALTER TABLE public.user_profiles
ADD COLUMN IF NOT EXISTS name TEXT;

-- Add integration_statement field
ALTER TABLE public.user_profiles
ADD COLUMN IF NOT EXISTS integration_statement TEXT;

-- Add generated_report field (cached AI report)
ALTER TABLE public.user_profiles
ADD COLUMN IF NOT EXISTS generated_report TEXT;

-- Add has_completed_onboarding field
ALTER TABLE public.user_profiles
ADD COLUMN IF NOT EXISTS has_completed_onboarding BOOLEAN NOT NULL DEFAULT FALSE;

-- Add booking_id reference (optional, for tracking current booking)
ALTER TABLE public.user_profiles
ADD COLUMN IF NOT EXISTS current_booking_id TEXT REFERENCES public.bookings(id) ON DELETE SET NULL;

-- Comments for documentation
COMMENT ON COLUMN public.user_profiles.name IS 'User display name';
COMMENT ON COLUMN public.user_profiles.integration_statement IS 'User personal integration statement from onboarding';
COMMENT ON COLUMN public.user_profiles.generated_report IS 'Cached AI-generated transformation report';
COMMENT ON COLUMN public.user_profiles.has_completed_onboarding IS 'Whether user has completed the onboarding flow';
COMMENT ON COLUMN public.user_profiles.current_booking_id IS 'Reference to user current active booking';
