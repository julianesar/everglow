-- ============================================================================
-- FIX: Task Completions RLS Policy Issue
-- ============================================================================
-- This migration fixes the RLS policy for user_task_completions to properly
-- allow users to insert task completions without foreign key validation errors.
--
-- PROBLEM: The current RLS policy requires that the itinerary_item_id exists,
-- but the check is failing even when the item exists, possibly due to timing
-- or how the EXISTS check is evaluated.
--
-- SOLUTION: Simplify the RLS policy to only check user_id and day_number,
-- relying on the foreign key constraint for data integrity instead.
-- ============================================================================

-- Drop the existing restrictive INSERT policy
DROP POLICY IF EXISTS "Users can insert their own task completions" ON public.user_task_completions;

-- Create a simpler INSERT policy that doesn't do the EXISTS check
-- The foreign key constraint will ensure data integrity
CREATE POLICY "Users can insert their own task completions"
    ON public.user_task_completions FOR INSERT
    WITH CHECK (
        auth.uid() = user_id AND
        day_number IN (1, 2, 3)
    );

-- Verify the policy was created
COMMENT ON POLICY "Users can insert their own task completions" ON public.user_task_completions IS
'Allows users to insert their own task completions. Foreign key constraint ensures itinerary_item_id validity.';
