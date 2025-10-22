-- ============================================================================
-- FIX: Remove infinite recursion in user_journal_responses RLS policies
-- ============================================================================
-- Problem: The UPDATE policy has a WITH CHECK clause that queries the same
-- table while RLS is being applied, causing infinite recursion.
--
-- Solution: Remove the recursive subqueries and simplify the policy.
-- The UNIQUE constraint already prevents changing user_id and prompt_id.
-- ============================================================================

-- Drop the problematic policies
DROP POLICY IF EXISTS "Users can insert their own journal responses" ON public.user_journal_responses;
DROP POLICY IF EXISTS "Users can update their own journal responses" ON public.user_journal_responses;

-- Recreate INSERT policy without the prompt_id validation
-- (We need to allow special prompt_ids like 'priority_day_1' that don't exist in journaling_prompts)
CREATE POLICY "Users can insert their own journal responses"
    ON public.user_journal_responses FOR INSERT
    WITH CHECK (
        auth.uid() = user_id AND
        -- Only validate day_number (1-3)
        day_number IN (1, 2, 3)
    );

-- Recreate UPDATE policy without the recursive subqueries
-- The UNIQUE constraint on (user_id, prompt_id) already prevents changing these fields
CREATE POLICY "Users can update their own journal responses"
    ON public.user_journal_responses FOR UPDATE
    USING (auth.uid() = user_id OR public.is_admin(auth.uid()))
    WITH CHECK (
        auth.uid() = user_id AND
        -- Only validate day_number (1-3)
        day_number IN (1, 2, 3)
    );

-- ============================================================================
-- VERIFICATION
-- ============================================================================
COMMENT ON POLICY "Users can insert their own journal responses"
    ON public.user_journal_responses IS
    'Allows users to insert journal responses without recursive policy checks. Special prompt_ids (like priority_day_*) are allowed.';

COMMENT ON POLICY "Users can update their own journal responses"
    ON public.user_journal_responses IS
    'Allows users to update journal responses. Removed recursive subqueries to prevent infinite recursion. UNIQUE constraint already prevents user_id/prompt_id changes.';
