-- ============================================================================
-- ADD EMAIL FIELD AND AUTO-CREATE USER PROFILES
-- ============================================================================
-- This migration:
-- 1. Adds email field to user_profiles table
-- 2. Creates a trigger to automatically create user_profiles when auth user is created
-- 3. Updates RLS policies to allow the trigger to work
-- 4. Backfills existing users with their email from auth.users
-- ============================================================================

-- Add email field to user_profiles
ALTER TABLE public.user_profiles
ADD COLUMN IF NOT EXISTS email TEXT;

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON public.user_profiles(email);

-- Add comment for documentation
COMMENT ON COLUMN public.user_profiles.email IS 'User email address from auth.users';

-- ============================================================================
-- UPDATE RLS POLICY: Allow trigger to create user profiles
-- ============================================================================
-- Drop and recreate the INSERT policy to allow the trigger function
-- to bypass the "profile already exists" check
-- ============================================================================

DROP POLICY IF EXISTS "Users can insert their own profile once" ON public.user_profiles;

CREATE POLICY "Users can insert their own profile once"
    ON public.user_profiles FOR INSERT
    WITH CHECK (
        auth.uid() = user_id
        -- Removed the "NOT EXISTS" check to allow ON CONFLICT to work
    );

-- ============================================================================
-- TRIGGER FUNCTION: Auto-create user_profiles on signup
-- ============================================================================
-- This function automatically creates a user_profiles record when a new user
-- signs up in auth.users. It copies the email from the auth user.
-- SECURITY DEFINER ensures it runs with owner privileges to bypass RLS
-- SET search_path ensures it runs in the correct schema context
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
    INSERT INTO public.user_profiles (
        user_id,
        email,
        name,
        has_completed_onboarding,
        created_at,
        updated_at
    )
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'name', NULL),
        FALSE,
        NOW(),
        NOW()
    )
    ON CONFLICT (user_id) DO UPDATE
    SET email = EXCLUDED.email,
        name = COALESCE(EXCLUDED.name, public.user_profiles.name),
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Grant necessary permissions to the function
ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

-- Create trigger on auth.users insert
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- BACKFILL: Update existing user_profiles with emails from auth.users
-- ============================================================================
-- This ensures all existing users have their email populated
-- ============================================================================

UPDATE public.user_profiles up
SET email = au.email,
    updated_at = NOW()
FROM auth.users au
WHERE up.user_id = au.id
  AND (up.email IS NULL OR up.email = '');

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON FUNCTION public.handle_new_user() IS 'Automatically creates user_profiles record when new auth user signs up. Runs with SECURITY DEFINER to bypass RLS.';
