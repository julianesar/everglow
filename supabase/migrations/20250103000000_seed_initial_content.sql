-- ============================================================================
-- EVERGLOW INITIAL CONTENT SEED DATA
-- ============================================================================
-- This migration populates the database with initial content:
-- - Onboarding questions (medical and concierge)
-- - Daily journey content for Days 1-3
-- - Itinerary items and tasks
-- - Journaling prompts
-- - Aftercare content
-- ============================================================================

-- ============================================================================
-- 1. ONBOARDING QUESTIONS - MEDICAL SECTION
-- ============================================================================
INSERT INTO public.onboarding_questions (id, question_text, question_type, category, placeholder, is_required, display_order) VALUES
('med_01', 'Do you have any known allergies to medications, food, or the environment?', 'text', 'medical', 'Please list all known allergies', true, 1),
('med_02', 'Please list any pre-existing medical conditions we should be aware of.', 'text', 'medical', 'e.g., diabetes, hypertension, asthma', true, 2),
('med_03', 'Please list any medications or supplements you are currently taking.', 'text', 'medical', 'Include dosages if known', true, 3),
('med_04', 'Have you had any major surgeries or medical procedures in the past 5 years?', 'yesNo', 'medical', null, true, 4),
('med_05', 'Are you currently under a doctor''s care for a specific health issue?', 'yesNo', 'medical', null, true, 5)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 2. ONBOARDING QUESTIONS - CONCIERGE SECTION
-- ============================================================================
INSERT INTO public.onboarding_questions (id, question_text, question_type, category, options, is_required, display_order) VALUES
('con_01', 'To ensure your mornings are perfect, do you prefer: Coffee or a selection of Herbal Teas?', 'multipleChoice', 'concierge', '{"Coffee","Herbal Teas","Both"}', true, 6),
('con_02', 'Do you have any strict dietary restrictions or preferences? (e.g., vegan, gluten-free, keto)', 'text', 'concierge', null, true, 7),
('con_03', 'For your comfort, how do you prefer your suite''s temperature?', 'multipleChoice', 'concierge', '{"Cool","Mild","Warm"}', true, 8),
('con_04', 'During your relaxation time, what type of music or sound do you prefer?', 'multipleChoice', 'concierge', '{"Nature Sounds","Classical","Ambient Electronic","Silence"}', true, 9),
('con_05', 'Is there anything, no matter how small, we can prepare to make your arrival and stay exceptional?', 'text', 'concierge', null, true, 10)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 3. DAILY JOURNEY CONTENT (Days 1-3)
-- ============================================================================
INSERT INTO public.daily_journey_content (day_number, title, mantra) VALUES
(1, 'DAY ONE — RELEASE', 'You cannot step into your future while clinging to your past.'),
(2, 'DAY TWO — RISE', 'Energy returns when clarity aligns with purpose.'),
(3, 'DAY THREE — REBIRTH', 'I am the designer of my destiny.')
ON CONFLICT (day_number) DO NOTHING;

-- ============================================================================
-- 4. ITINERARY ITEMS - DAY 1
-- ============================================================================
INSERT INTO public.itinerary_items (id, day_number, item_type, time, title, description, location, audio_url, display_order) VALUES
-- Day 1
('d1_gp1', 1, 'practice', 'Morning', 'Morning Intention Ceremony', null, null, 'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test.mp3', 1),
('d1_me1', 1, 'medical', '9 AM - 11 AM', 'Medical Detox Program', 'Plasmapheresis detox, IV nutrient infusions, and heavy-metal elimination. Your body and mind begin to let go of stored weight — physical, emotional, and energetic.', 'Medical Wing', null, 2),
('d1_js1', 1, 'journal', 'Afternoon', 'Journaling: Releasing Attachments', null, null, null, 3),

-- Day 2
('d2_gp1', 2, 'practice', 'Morning', 'Cold Plunge or Power Breath', null, null, 'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test.mp3', 1),
('d2_me1', 2, 'medical', '9 AM - 10 AM', 'Energy Optimization Program', '10-Pass Ozone Therapy and Peptides & NAD+ Optimization. Super-oxygenating your system for peak energy and activating cellular repair and vitality.', 'Medical Wing', null, 2),
('d2_js1', 2, 'journal', 'Afternoon', 'Journaling: Activating Your Future Self', null, null, null, 3),

-- Day 3
('d3_gp1', 3, 'practice', 'Morning', 'Quantum Heart Coherence Meditation', null, null, 'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test.mp3', 1),
('d3_me1', 3, 'medical', '9 AM - 10 AM', 'Regeneration & Longevity Program', 'Stem-Cell Therapy, Longevity Infusions & Neural Rejuvenation. The pinnacle of regeneration begins, supporting your system for long-term transformation.', 'Medical Wing', null, 2),
('d3_js1', 3, 'journal', 'Afternoon', 'Journaling: Anchoring Your New Identity', null, null, null, 3)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 5. JOURNALING PROMPTS - DAY 1
-- ============================================================================
INSERT INTO public.journaling_prompts (id, itinerary_item_id, prompt_text, display_order) VALUES
-- Day 1 Prompts
('d1q1', 'd1_js1', 'What am I finally ready to release?', 1),
('d1q2', 'd1_js1', 'Who or what no longer has permission to occupy space in my energy?', 2),
('d1q3', 'd1_js1', 'What old identities or patterns am I saying goodbye to?', 3),
('d1q4', 'd1_js1', 'Today I choose to release _____ so I can create space for _____.', 4),
('d1q5', 'd1_js1', 'If I were free of this weight, how would I feel tomorrow?', 5),

-- Day 2 Prompts
('d2q1', 'd2_js1', 'Who is my next-level self?', 1),
('d2q2', 'd2_js1', 'What would I do if I fully trusted myself?', 2),
('d2q3', 'd2_js1', 'How do I show up when I lead from clarity?', 3),
('d2q4', 'd2_js1', 'How does my most powerful self speak, move, and lead?', 4),
('d2q5', 'd2_js1', 'What action anchors this identity?', 5),

-- Day 3 Prompts
('d3q1', 'd3_js1', 'Who am I, now that I''ve chosen to rise?', 1),
('d3q2', 'd3_js1', 'What rituals will anchor this identity daily?', 2),
('d3q3', 'd3_js1', 'What does my new reality look and feel like?', 3),
('d3q4', 'd3_js1', 'What boundaries protect this version of me?', 4),
('d3q5', 'd3_js1', 'What am I no longer willing to tolerate?', 5)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 6. AFTERCARE CONTENT - LAB REPORTS (Dummy Data for MVP)
-- ============================================================================
INSERT INTO public.aftercare_content (content_type, title, description, date_label, file_url, display_order) VALUES
('lab_report', 'Pre-Treatment Analysis', 'Comprehensive baseline biomarker assessment before your journey began.', 'June 10', null, 1),
('lab_report', 'Mid-Journey Biomarkers', 'Progress check showing changes during your transformation.', 'June 12', null, 2),
('lab_report', 'Post-Treatment Biomarkers', 'Final biomarker results showcasing your complete transformation.', 'June 14', null, 3)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- VERIFICATION QUERIES (Optional - for testing)
-- ============================================================================
-- Run these queries to verify the seed data was inserted correctly:
--
-- SELECT COUNT(*) FROM public.onboarding_questions; -- Should be 10
-- SELECT COUNT(*) FROM public.daily_journey_content; -- Should be 3
-- SELECT COUNT(*) FROM public.itinerary_items; -- Should be 9
-- SELECT COUNT(*) FROM public.journaling_prompts; -- Should be 15
-- SELECT COUNT(*) FROM public.aftercare_content; -- Should be 3
