# Supabase Database Schema

This directory contains SQL migrations for the complete EverGlow application database schema.

## Overview

The EverGlow database stores:
- User bookings and journey dates
- Medical profiles and concierge preferences
- Onboarding questions (admin-editable)
- Daily journey content for Days 1-3 (admin-editable)
- User task completions and journal responses
- Aftercare content and AI-extracted commitments

**All user data is stored in Supabase. All app content is read from Supabase.**

## Migration Files

Apply migrations in this order:

1. **`20250102000000_create_complete_schema.sql`** - Creates all tables, indexes, RLS policies, and triggers
2. **`20250103000000_seed_initial_content.sql`** - Populates initial content (onboarding questions, days 1-3, prompts)

## Quick Setup

### Option 1: Supabase Dashboard (Easiest)

1. Go to your Supabase project: https://supabase.com/dashboard/project/wficuvdsfokzphftvtbi
2. Navigate to **SQL Editor** in the left sidebar
3. Click **New Query**
4. Copy and paste the contents of `20250102000000_create_complete_schema.sql`
5. Click **Run**
6. Repeat steps 3-5 for `20250103000000_seed_initial_content.sql`
7. Go to **Table Editor** to verify all tables were created

### Option 2: Supabase CLI

```bash
# Install Supabase CLI (if not installed)
npm install -g supabase

# Link to your project (first time only)
supabase link --project-ref wficuvdsfokzphftvtbi

# Apply all migrations
supabase db push
```

### Option 3: Direct PostgreSQL Connection

If you have a PostgreSQL client (psql, DBeaver, etc.):

```bash
psql "postgresql://postgres:[YOUR_DB_PASSWORD]@db.wficuvdsfokzphftvtbi.supabase.co:5432/postgres"

# Then run each migration file
\i supabase/migrations/20250102000000_create_complete_schema.sql
\i supabase/migrations/20250103000000_seed_initial_content.sql
```

## Database Schema

### User Data Tables

These tables store user-specific data and are protected by Row Level Security (RLS):

#### `bookings`
Stores user booking information for transformation journeys.

**Columns:**
- `id` (TEXT, PK) - Unique booking identifier
- `user_id` (UUID, FK) - Reference to auth.users
- `start_date` (TIMESTAMPTZ) - Journey start date
- `end_date` (TIMESTAMPTZ) - Journey end date
- `is_checked_in` (BOOLEAN) - Check-in status
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Users can only access their own bookings

---

#### `user_profiles`
Stores medical profiles and concierge preferences.

**Columns:**
- `id` (UUID, PK)
- `user_id` (UUID, FK, UNIQUE) - One profile per user
- `allergies` (TEXT[]) - List of allergies
- `medical_conditions` (TEXT[])
- `medications` (TEXT[])
- `has_signed_medical_consent` (BOOLEAN)
- `dietary_restrictions` (TEXT[])
- `coffee_or_tea` (TEXT)
- `room_temperature` (TEXT)
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Users can only access their own profile

---

#### `user_onboarding_responses`
Stores user answers to onboarding questions.

**Columns:**
- `id` (UUID, PK)
- `user_id` (UUID, FK)
- `question_id` (TEXT, FK)
- `response_text` (TEXT) - For text/yesNo questions
- `response_options` (TEXT[]) - For multiple selection
- `created_at`, `updated_at` (TIMESTAMPTZ)

**Unique Constraint:** (user_id, question_id)
**RLS:** Users can only access their own responses

---

#### `user_task_completions`
Tracks completed itinerary items for each user.

**Columns:**
- `id` (UUID, PK)
- `user_id` (UUID, FK)
- `itinerary_item_id` (TEXT, FK)
- `day_number` (INTEGER) - 1, 2, or 3
- `completed_at` (TIMESTAMPTZ)

**Unique Constraint:** (user_id, itinerary_item_id)
**RLS:** Users can only access their own completions

---

#### `user_journal_responses`
Stores user responses to journaling prompts.

**Columns:**
- `id` (UUID, PK)
- `user_id` (UUID, FK)
- `prompt_id` (TEXT, FK)
- `day_number` (INTEGER) - 1, 2, or 3
- `response_text` (TEXT)
- `created_at`, `updated_at` (TIMESTAMPTZ)

**Unique Constraint:** (user_id, prompt_id)
**RLS:** Users can only access their own responses

---

#### `user_commitments`
AI-extracted commitments from user journal entries.

**Columns:**
- `id` (UUID, PK)
- `user_id` (UUID, FK)
- `commitment_text` (TEXT)
- `source_day` (INTEGER) - Which day it came from
- `created_at` (TIMESTAMPTZ)

**RLS:** Users can only access their own commitments

---

### Content Tables (Admin-Editable)

These tables store app content and are publicly readable but only editable by service role:

#### `onboarding_questions`
Dynamic onboarding questions for medical and concierge sections.

**Columns:**
- `id` (TEXT, PK)
- `question_text` (TEXT)
- `question_type` (TEXT) - 'text', 'multipleChoice', 'yesNo', 'multipleSelection'
- `category` (TEXT) - 'medical' or 'concierge'
- `options` (TEXT[]) - For multiple choice questions
- `placeholder` (TEXT)
- `is_required` (BOOLEAN)
- `display_order` (INTEGER)
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Public read, service role write

---

#### `daily_journey_content`
Content for Days 1-3 (title and mantra).

**Columns:**
- `id` (UUID, PK)
- `day_number` (INTEGER, UNIQUE) - 1, 2, or 3
- `title` (TEXT) - e.g., "DAY ONE — RELEASE"
- `mantra` (TEXT) - Daily mantra
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Public read, service role write

---

#### `itinerary_items`
Tasks and activities for each day.

**Columns:**
- `id` (TEXT, PK)
- `day_number` (INTEGER) - 1, 2, or 3
- `item_type` (TEXT) - 'medical', 'practice', 'journal'
- `time` (TEXT) - e.g., "9:00 AM" or "Morning"
- `title` (TEXT)
- `description` (TEXT) - For medical events
- `location` (TEXT) - For medical events
- `audio_url` (TEXT) - For guided practices
- `display_order` (INTEGER)
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Public read, service role write

---

#### `journaling_prompts`
Journal prompts linked to itinerary items.

**Columns:**
- `id` (TEXT, PK)
- `itinerary_item_id` (TEXT, FK)
- `prompt_text` (TEXT)
- `display_order` (INTEGER)
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Public read, service role write

---

#### `aftercare_content`
Aftercare resources (lab reports, etc.).

**Columns:**
- `id` (UUID, PK)
- `content_type` (TEXT) - 'lab_report', 'resource', 'contact'
- `title` (TEXT)
- `description` (TEXT)
- `date_label` (TEXT) - e.g., "June 10"
- `file_url` (TEXT) - For PDFs
- `display_order` (INTEGER)
- `created_at`, `updated_at` (TIMESTAMPTZ)

**RLS:** Public read, service role write

---

## Row Level Security (RLS)

All tables have RLS enabled:

**User Data Tables:**
- Users can SELECT, INSERT, UPDATE, DELETE their own data only
- Filtered by `auth.uid() = user_id`

**Content Tables:**
- All authenticated users can SELECT (read)
- Only service role can INSERT, UPDATE, DELETE
- Content is global and shared across all users

## Automatic Timestamps

All tables with `updated_at` columns have triggers that automatically update the timestamp on every UPDATE operation.

## Indexes

Performance indexes are created on:
- Foreign keys (user_id, itinerary_item_id, prompt_id, etc.)
- Frequently queried columns (day_number, category, content_type, etc.)
- Date columns for range queries (start_date, created_at)

## Editing Content

To update app content (onboarding questions, daily journey content, etc.):

1. Use the Supabase Dashboard **Table Editor**
2. Or use the Supabase service role key in your application
3. Or run SQL queries directly in the SQL Editor

Example: Adding a new onboarding question:

```sql
INSERT INTO public.onboarding_questions (
  id, question_text, question_type, category, is_required, display_order
) VALUES (
  'med_06',
  'Do you have any history of heart disease?',
  'yesNo',
  'medical',
  true,
  11
);
```

## Verification

After applying migrations, verify with:

```sql
-- Check all tables were created
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Check row counts
SELECT
  'onboarding_questions' as table_name, COUNT(*) FROM public.onboarding_questions
UNION ALL
SELECT 'daily_journey_content', COUNT(*) FROM public.daily_journey_content
UNION ALL
SELECT 'itinerary_items', COUNT(*) FROM public.itinerary_items
UNION ALL
SELECT 'journaling_prompts', COUNT(*) FROM public.journaling_prompts
UNION ALL
SELECT 'aftercare_content', COUNT(*) FROM public.aftercare_content;

-- Expected counts:
-- onboarding_questions: 10
-- daily_journey_content: 3
-- itinerary_items: 9
-- journaling_prompts: 15
-- aftercare_content: 3
```

## Troubleshooting

**Error: "relation already exists"**
- Safe to ignore. The migrations use `IF NOT EXISTS` and `ON CONFLICT` clauses.

**Error: "permission denied"**
- Make sure you're using the service role key or are logged in with proper permissions.

**RLS prevents reading data**
- Ensure the user is authenticated (`auth.uid()` is not null)
- For content tables, any authenticated user can read
- For user data tables, check that `user_id` matches the authenticated user

## Next Steps

After applying migrations:

1. Update Flutter data models to match Supabase schema
2. Create Supabase repositories to replace static repositories
3. Update providers to use Supabase repositories
4. Test data flow: read content, save user data, complete tasks, etc.
