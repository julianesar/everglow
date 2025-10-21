-- Create bookings table
-- This table stores user booking information for transformation journeys

CREATE TABLE IF NOT EXISTS public.bookings (
    -- Primary key
    id TEXT PRIMARY KEY,

    -- Foreign key to auth.users
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Booking dates
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,

    -- Check-in status
    is_checked_in BOOLEAN NOT NULL DEFAULT FALSE,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index on user_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON public.bookings(user_id);

-- Create index on start_date for date-based queries
CREATE INDEX IF NOT EXISTS idx_bookings_start_date ON public.bookings(start_date);

-- Add Row Level Security (RLS)
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read their own bookings
CREATE POLICY "Users can read their own bookings"
    ON public.bookings
    FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: Users can insert their own bookings
CREATE POLICY "Users can insert their own bookings"
    ON public.bookings
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own bookings
CREATE POLICY "Users can update their own bookings"
    ON public.bookings
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own bookings
CREATE POLICY "Users can delete their own bookings"
    ON public.bookings
    FOR DELETE
    USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_bookings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at on row update
CREATE TRIGGER update_bookings_updated_at_trigger
    BEFORE UPDATE ON public.bookings
    FOR EACH ROW
    EXECUTE FUNCTION public.update_bookings_updated_at();

-- Add comments for documentation
COMMENT ON TABLE public.bookings IS 'Stores user bookings for transformation journeys';
COMMENT ON COLUMN public.bookings.id IS 'Unique identifier for the booking';
COMMENT ON COLUMN public.bookings.user_id IS 'Reference to the user who made the booking';
COMMENT ON COLUMN public.bookings.start_date IS 'Start date of the transformation journey';
COMMENT ON COLUMN public.bookings.end_date IS 'End date of the transformation journey';
COMMENT ON COLUMN public.bookings.is_checked_in IS 'Whether the user has checked in for their booking';
COMMENT ON COLUMN public.bookings.created_at IS 'Timestamp when the booking was created';
COMMENT ON COLUMN public.bookings.updated_at IS 'Timestamp when the booking was last updated';
