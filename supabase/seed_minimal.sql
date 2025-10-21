-- ============================================================================
-- MINIMAL SEED DATA FOR EVERGLOW APP
-- ============================================================================
-- This inserts the minimum required data to get the app working.
-- ============================================================================

-- ============================================================================
-- 1. DAILY JOURNEY CONTENT (Days 1-3)
-- ============================================================================
INSERT INTO public.daily_journey_content (day_number, title, mantra) VALUES
(1, 'DAY ONE — RELEASE', 'You cannot step into your future while clinging to your past.'),
(2, 'DAY TWO — RISE', 'Energy returns when clarity aligns with purpose.'),
(3, 'DAY THREE — REBIRTH', 'You are not who you were yesterday. You are who you choose to be today.')
ON CONFLICT (day_number) DO NOTHING;

-- ============================================================================
-- 2. SAMPLE ONBOARDING QUESTIONS
-- ============================================================================

-- Medical questions
INSERT INTO public.onboarding_questions (id, question_text, question_type, category, options, is_required, display_order) VALUES
('med_allergies', 'Do you have any allergies?', 'text', 'medical', '{}', true, 1),
('med_conditions', 'Do you have any medical conditions we should know about?', 'text', 'medical', '{}', true, 2),
('med_medications', 'Are you currently taking any medications?', 'text', 'medical', '{}', true, 3),
('med_consent', 'I consent to medical treatment', 'yesNo', 'medical', '{}', true, 4)
ON CONFLICT (id) DO NOTHING;

-- Concierge questions
INSERT INTO public.onboarding_questions (id, question_text, question_type, category, options, is_required, display_order) VALUES
('conc_dietary', 'Do you have any dietary restrictions?', 'text', 'concierge', '{}', false, 1),
('conc_beverage', 'Coffee or tea preference?', 'multipleChoice', 'concierge', ARRAY['Coffee', 'Tea', 'Both', 'Neither'], false, 2),
('conc_temp', 'Room temperature preference?', 'multipleChoice', 'concierge', ARRAY['Warm', 'Cool', 'No preference'], false, 3)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 3. SAMPLE ITINERARY ITEMS (Just Day 1 for now)
-- ============================================================================
INSERT INTO public.itinerary_items (id, day_number, item_type, time, title, description, display_order) VALUES
('d1_practice1', 1, 'practice', 'Morning', 'Morning Intention Ceremony', 'Start your day with intention', 1),
('d1_medical1', 1, 'medical', '9 AM - 11 AM', 'Medical Detox Program', 'Plasmapheresis detox and IV nutrient infusions', 2),
('d1_journal1', 1, 'journal', 'Afternoon', 'Journaling: Releasing Attachments', 'Reflect on what you are ready to release', 3)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 4. SAMPLE JOURNALING PROMPTS
-- ============================================================================
INSERT INTO public.journaling_prompts (id, itinerary_item_id, prompt_text, display_order) VALUES
('d1q1', 'd1_journal1', 'What am I finally ready to release?', 1),
('d1q2', 'd1_journal1', 'Who or what no longer has permission to occupy space in my energy?', 2),
('d1q3', 'd1_journal1', 'What old identities or patterns am I saying goodbye to?', 3),
('d1q4', 'd1_journal1', 'Today I choose to release _____ so I can create space for _____.', 4),
('d1q5', 'd1_journal1', 'If I were free of this weight, how would I feel tomorrow?', 5)
ON CONFLICT (id) DO NOTHING;
