-- ============================================================================
-- EVERGLOW COMPLETE DATABASE SCHEMA
-- ============================================================================
-- This migration creates the complete database schema for the EverGlow app.
-- All user data and app content are stored in Supabase.
--
-- Tables:
-- 1. bookings - User booking information
-- 2. user_profiles - Medical profiles and concierge preferences
-- 3. onboarding_questions - Dynamic onboarding questions (medical & concierge)
-- 4. user_onboarding_responses - User responses to onboarding questions
-- 5. daily_journey_content - Content for days 1-3 (title, mantra, etc.)
-- 6. itinerary_items - Tasks/activities for each day
-- 7. journaling_prompts - Journal prompts for each day
-- 8. user_task_completions - Track which tasks users have completed
-- 9. user_journal_responses - User responses to journal prompts
-- 10. aftercare_content - Aftercare tab content (lab reports, etc.)
-- 11. user_commitments - AI-extracted commitments from journal
-- ============================================================================

-- ============================================================================
-- 1. BOOKINGS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.bookings (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    is_checked_in BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON public.bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_start_date ON public.bookings(start_date);

-- RLS Policies
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own bookings"
    ON public.bookings FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own bookings"
    ON public.bookings FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own bookings"
    ON public.bookings FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own bookings"
    ON public.bookings FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================================================
-- 2. USER PROFILES (Medical + Concierge)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Medical Profile
    allergies TEXT[] DEFAULT '{}',
    medical_conditions TEXT[] DEFAULT '{}',
    medications TEXT[] DEFAULT '{}',
    has_signed_medical_consent BOOLEAN NOT NULL DEFAULT FALSE,

    -- Concierge Preferences
    dietary_restrictions TEXT[] DEFAULT '{}',
    coffee_or_tea TEXT,
    room_temperature TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON public.user_profiles(user_id);

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own profile"
    ON public.user_profiles FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile"
    ON public.user_profiles FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile"
    ON public.user_profiles FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- 3. ONBOARDING QUESTIONS (Admin-editable content)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.onboarding_questions (
    id TEXT PRIMARY KEY,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN ('text', 'multipleChoice', 'yesNo', 'multipleSelection')),
    category TEXT NOT NULL CHECK (category IN ('medical', 'concierge')),
    options TEXT[] DEFAULT '{}',
    placeholder TEXT,
    is_required BOOLEAN NOT NULL DEFAULT TRUE,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_onboarding_questions_category ON public.onboarding_questions(category);
CREATE INDEX IF NOT EXISTS idx_onboarding_questions_order ON public.onboarding_questions(display_order);

-- Public read access (all users need to see questions)
ALTER TABLE public.onboarding_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read onboarding questions"
    ON public.onboarding_questions FOR SELECT
    USING (true);

-- Admin-only write (configure via service role or admin panel later)
CREATE POLICY "Only service role can modify questions"
    ON public.onboarding_questions FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- ============================================================================
-- 4. USER ONBOARDING RESPONSES
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_onboarding_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    question_id TEXT NOT NULL REFERENCES public.onboarding_questions(id) ON DELETE CASCADE,
    response_text TEXT,
    response_options TEXT[] DEFAULT '{}', -- For multiple selection
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_user_onboarding_responses_user_id ON public.user_onboarding_responses(user_id);

ALTER TABLE public.user_onboarding_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own responses"
    ON public.user_onboarding_responses FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own responses"
    ON public.user_onboarding_responses FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own responses"
    ON public.user_onboarding_responses FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- 5. DAILY JOURNEY CONTENT (Days 1-3)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.daily_journey_content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    day_number INTEGER NOT NULL UNIQUE CHECK (day_number BETWEEN 1 AND 3),
    title TEXT NOT NULL,
    mantra TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Public read access
ALTER TABLE public.daily_journey_content ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read daily journey content"
    ON public.daily_journey_content FOR SELECT
    USING (true);

CREATE POLICY "Only service role can modify daily content"
    ON public.daily_journey_content FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- ============================================================================
-- 6. ITINERARY ITEMS (Tasks/Activities for each day)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.itinerary_items (
    id TEXT PRIMARY KEY,
    day_number INTEGER NOT NULL CHECK (day_number BETWEEN 1 AND 3),
    item_type TEXT NOT NULL CHECK (item_type IN ('medical', 'practice', 'journal')),
    time TEXT NOT NULL, -- e.g., "9:00 AM"
    title TEXT NOT NULL,
    description TEXT,
    location TEXT, -- For medical events
    audio_url TEXT, -- For guided practices
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_itinerary_items_day ON public.itinerary_items(day_number);
CREATE INDEX IF NOT EXISTS idx_itinerary_items_type ON public.itinerary_items(item_type);
CREATE INDEX IF NOT EXISTS idx_itinerary_items_order ON public.itinerary_items(display_order);

ALTER TABLE public.itinerary_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read itinerary items"
    ON public.itinerary_items FOR SELECT
    USING (true);

CREATE POLICY "Only service role can modify itinerary items"
    ON public.itinerary_items FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- ============================================================================
-- 7. JOURNALING PROMPTS
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.journaling_prompts (
    id TEXT PRIMARY KEY,
    itinerary_item_id TEXT NOT NULL REFERENCES public.itinerary_items(id) ON DELETE CASCADE,
    prompt_text TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_journaling_prompts_item ON public.journaling_prompts(itinerary_item_id);

ALTER TABLE public.journaling_prompts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read journaling prompts"
    ON public.journaling_prompts FOR SELECT
    USING (true);

CREATE POLICY "Only service role can modify prompts"
    ON public.journaling_prompts FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- ============================================================================
-- 8. USER TASK COMPLETIONS
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_task_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    itinerary_item_id TEXT NOT NULL REFERENCES public.itinerary_items(id) ON DELETE CASCADE,
    day_number INTEGER NOT NULL CHECK (day_number BETWEEN 1 AND 3),
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, itinerary_item_id)
);

CREATE INDEX IF NOT EXISTS idx_user_task_completions_user ON public.user_task_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_task_completions_day ON public.user_task_completions(day_number);

ALTER TABLE public.user_task_completions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own task completions"
    ON public.user_task_completions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own task completions"
    ON public.user_task_completions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own task completions"
    ON public.user_task_completions FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================================================
-- 9. USER JOURNAL RESPONSES
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_journal_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    prompt_id TEXT NOT NULL REFERENCES public.journaling_prompts(id) ON DELETE CASCADE,
    day_number INTEGER NOT NULL CHECK (day_number BETWEEN 1 AND 3),
    response_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, prompt_id)
);

CREATE INDEX IF NOT EXISTS idx_user_journal_responses_user ON public.user_journal_responses(user_id);
CREATE INDEX IF NOT EXISTS idx_user_journal_responses_day ON public.user_journal_responses(day_number);

ALTER TABLE public.user_journal_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own journal responses"
    ON public.user_journal_responses FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own journal responses"
    ON public.user_journal_responses FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own journal responses"
    ON public.user_journal_responses FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- 10. AFTERCARE CONTENT (Lab reports, etc.)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.aftercare_content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content_type TEXT NOT NULL CHECK (content_type IN ('lab_report', 'resource', 'contact')),
    title TEXT NOT NULL,
    description TEXT,
    date_label TEXT, -- e.g., "June 10"
    file_url TEXT, -- For PDF reports
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_aftercare_content_type ON public.aftercare_content(content_type);

ALTER TABLE public.aftercare_content ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read aftercare content"
    ON public.aftercare_content FOR SELECT
    USING (true);

CREATE POLICY "Only service role can modify aftercare content"
    ON public.aftercare_content FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- ============================================================================
-- 11. USER COMMITMENTS (AI-extracted)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_commitments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    commitment_text TEXT NOT NULL,
    source_day INTEGER NOT NULL CHECK (source_day BETWEEN 1 AND 3),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_commitments_user ON public.user_commitments(user_id);

ALTER TABLE public.user_commitments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own commitments"
    ON public.user_commitments FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own commitments"
    ON public.user_commitments FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own commitments"
    ON public.user_commitments FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT TIMESTAMPS
-- ============================================================================

-- Bookings
CREATE OR REPLACE FUNCTION public.update_bookings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_bookings_updated_at_trigger
    BEFORE UPDATE ON public.bookings
    FOR EACH ROW
    EXECUTE FUNCTION public.update_bookings_updated_at();

-- User Profiles
CREATE OR REPLACE FUNCTION public.update_user_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_profiles_updated_at_trigger
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_user_profiles_updated_at();

-- Onboarding Questions
CREATE OR REPLACE FUNCTION public.update_onboarding_questions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_onboarding_questions_updated_at_trigger
    BEFORE UPDATE ON public.onboarding_questions
    FOR EACH ROW
    EXECUTE FUNCTION public.update_onboarding_questions_updated_at();

-- User Onboarding Responses
CREATE OR REPLACE FUNCTION public.update_user_onboarding_responses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_onboarding_responses_updated_at_trigger
    BEFORE UPDATE ON public.user_onboarding_responses
    FOR EACH ROW
    EXECUTE FUNCTION public.update_user_onboarding_responses_updated_at();

-- Daily Journey Content
CREATE OR REPLACE FUNCTION public.update_daily_journey_content_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_daily_journey_content_updated_at_trigger
    BEFORE UPDATE ON public.daily_journey_content
    FOR EACH ROW
    EXECUTE FUNCTION public.update_daily_journey_content_updated_at();

-- Itinerary Items
CREATE OR REPLACE FUNCTION public.update_itinerary_items_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_itinerary_items_updated_at_trigger
    BEFORE UPDATE ON public.itinerary_items
    FOR EACH ROW
    EXECUTE FUNCTION public.update_itinerary_items_updated_at();

-- Journaling Prompts
CREATE OR REPLACE FUNCTION public.update_journaling_prompts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_journaling_prompts_updated_at_trigger
    BEFORE UPDATE ON public.journaling_prompts
    FOR EACH ROW
    EXECUTE FUNCTION public.update_journaling_prompts_updated_at();

-- User Journal Responses
CREATE OR REPLACE FUNCTION public.update_user_journal_responses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_journal_responses_updated_at_trigger
    BEFORE UPDATE ON public.user_journal_responses
    FOR EACH ROW
    EXECUTE FUNCTION public.update_user_journal_responses_updated_at();

-- Aftercare Content
CREATE OR REPLACE FUNCTION public.update_aftercare_content_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_aftercare_content_updated_at_trigger
    BEFORE UPDATE ON public.aftercare_content
    FOR EACH ROW
    EXECUTE FUNCTION public.update_aftercare_content_updated_at();

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE public.bookings IS 'Stores user bookings for transformation journeys';
COMMENT ON TABLE public.user_profiles IS 'Stores medical profiles and concierge preferences for users';
COMMENT ON TABLE public.onboarding_questions IS 'Admin-editable onboarding questions (medical and concierge)';
COMMENT ON TABLE public.user_onboarding_responses IS 'User responses to onboarding questions';
COMMENT ON TABLE public.daily_journey_content IS 'Content for each day (1-3) including title and mantra';
COMMENT ON TABLE public.itinerary_items IS 'Tasks and activities for each day of the journey';
COMMENT ON TABLE public.journaling_prompts IS 'Journal prompts associated with itinerary items';
COMMENT ON TABLE public.user_task_completions IS 'Tracks which tasks users have completed';
COMMENT ON TABLE public.user_journal_responses IS 'User responses to journaling prompts';
COMMENT ON TABLE public.aftercare_content IS 'Aftercare content including lab reports and resources';
COMMENT ON TABLE public.user_commitments IS 'AI-extracted commitments from user journal entries';
