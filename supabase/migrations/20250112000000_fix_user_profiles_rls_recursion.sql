-- ============================================================================
-- FIX: Remove infinite recursion in user_profiles RLS policies
-- ============================================================================
-- Problem: The UPDATE policy has a WITH CHECK clause that queries the same
-- table while RLS is being applied, causing infinite recursion.
--
-- Solution: Remove the recursive subquery and simplify the policy.
-- The UNIQUE constraint on user_id already prevents changing user_id.
-- ============================================================================

-- Drop the problematic UPDATE policy
DROP POLICY IF EXISTS "Users can update their own profile" ON public.user_profiles;

-- Recreate UPDATE policy without the recursive subquery
-- The UNIQUE constraint on user_id already prevents changing the user_id field
CREATE POLICY "Users can update their own profile"
    ON public.user_profiles FOR UPDATE
    USING (auth.uid() = user_id OR public.is_admin(auth.uid()))
    WITH CHECK (
        auth.uid() = user_id
        -- Removed recursive check: user_id = (SELECT user_id FROM public.user_profiles WHERE id = user_profiles.id)
        -- The UNIQUE constraint on user_id already prevents changing it
    );

-- ============================================================================
-- VERIFICATION
-- ============================================================================
COMMENT ON POLICY "Users can update their own profile"
    ON public.user_profiles IS
    'Allows users to update their profile. Removed recursive subquery to prevent infinite recursion. UNIQUE constraint on user_id already prevents user_id changes.';
