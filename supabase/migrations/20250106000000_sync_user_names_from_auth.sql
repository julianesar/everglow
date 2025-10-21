-- ============================================================================
-- SYNC USER NAMES FROM AUTH METADATA TO USER_PROFILES
-- ============================================================================
-- This migration copies user names from auth.users.raw_user_meta_data
-- to user_profiles.name for existing users who don't have their name set.
-- ============================================================================

-- Update user_profiles with names from auth metadata where name is null
UPDATE public.user_profiles up
SET name = (au.raw_user_meta_data->>'name')
FROM auth.users au
WHERE up.user_id = au.id
  AND up.name IS NULL
  AND au.raw_user_meta_data->>'name' IS NOT NULL;

-- ============================================================================
-- VERIFICATION
-- ============================================================================
-- Verify that names were synced:
-- SELECT
--   up.user_id,
--   up.name as profile_name,
--   au.raw_user_meta_data->>'name' as auth_name
-- FROM public.user_profiles up
-- JOIN auth.users au ON up.user_id = au.id;
