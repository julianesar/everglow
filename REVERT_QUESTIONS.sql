-- ============================================================================
-- REVERT QUESTION INSERTS - DELETE NEW QUESTIONS
-- ============================================================================
-- This script deletes the questions that were just inserted (med_01 to con_05)
-- to restore the database to its previous state with original questions
-- ============================================================================

-- Step 1: Check what questions currently exist
SELECT
    id,
    question_text,
    category,
    display_order
FROM public.onboarding_questions
ORDER BY display_order;

-- Step 2: Delete the newly inserted questions (med_01 to med_05, con_01 to con_05)
DELETE FROM public.onboarding_questions
WHERE id IN (
    'med_01', 'med_02', 'med_03', 'med_04', 'med_05',
    'con_01', 'con_02', 'con_03', 'con_04', 'con_05'
);

-- Step 3: Verify deletion - should show only original questions now
SELECT
    id,
    question_text,
    category,
    display_order
FROM public.onboarding_questions
ORDER BY display_order;

-- Step 4: Show count by category
SELECT
    category,
    COUNT(*) as count
FROM public.onboarding_questions
GROUP BY category;
