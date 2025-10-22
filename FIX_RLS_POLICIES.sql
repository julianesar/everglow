-- ============================================================================
-- FIX RLS POLICIES FOR ONBOARDING_QUESTIONS
-- ============================================================================
-- Execute this script in your Supabase SQL Editor to fix read permissions
-- This ONLY fixes the RLS policies, does NOT modify existing questions
-- ============================================================================

-- Step 1: Check current state of RLS
SELECT
    tablename,
    rowsecurity as "RLS Enabled"
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'onboarding_questions';

-- Step 2: Check existing questions count
SELECT
    category,
    COUNT(*) as count
FROM public.onboarding_questions
GROUP BY category;

-- Step 3: Drop any existing restrictive policies
DROP POLICY IF EXISTS "Allow authenticated users to read onboarding questions" ON public.onboarding_questions;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.onboarding_questions;
DROP POLICY IF EXISTS "Anyone can read onboarding questions" ON public.onboarding_questions;
DROP POLICY IF EXISTS "Enable read access for all users on onboarding_questions" ON public.onboarding_questions;

-- Step 4: Ensure RLS is enabled
ALTER TABLE public.onboarding_questions ENABLE ROW LEVEL SECURITY;

-- Step 5: Create a permissive policy that allows ALL users to read ALL questions
CREATE POLICY "Public read access for onboarding questions"
ON public.onboarding_questions
FOR SELECT
TO public
USING (true);

-- Step 6: Verify the policy was created successfully
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename = 'onboarding_questions';

-- Step 7: Test query - This should return all questions
SELECT
    id,
    question_text,
    category,
    display_order
FROM public.onboarding_questions
ORDER BY display_order;

-- Expected result: Should see all existing questions without errors
