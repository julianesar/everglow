-- ============================================================================
-- CONCIERGE ASSIGNMENTS TABLE
-- ============================================================================
-- This migration creates the concierge_assignments table to store driver,
-- concierge, and villa information for each booking.
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.concierge_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id TEXT NOT NULL UNIQUE REFERENCES public.bookings(id) ON DELETE CASCADE,

    -- Driver Information
    driver_name TEXT,
    driver_phone TEXT,

    -- Concierge Information
    concierge_name TEXT,
    concierge_phone TEXT,
    concierge_photo_url TEXT,

    -- Villa Information
    villa_address TEXT,
    villa_image_url TEXT,

    -- Check-in Instructions
    check_in_instructions TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_concierge_assignments_booking_id ON public.concierge_assignments(booking_id);

-- RLS Policies
ALTER TABLE public.concierge_assignments ENABLE ROW LEVEL SECURITY;

-- Users can read concierge assignments for their own bookings
CREATE POLICY "Users can read their own concierge assignments"
    ON public.concierge_assignments FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.bookings
            WHERE bookings.id = concierge_assignments.booking_id
            AND bookings.user_id = auth.uid()
        )
    );

-- Only service role can insert/update concierge assignments
CREATE POLICY "Only service role can insert concierge assignments"
    ON public.concierge_assignments FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Only service role can update concierge assignments"
    ON public.concierge_assignments FOR UPDATE
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- Trigger for updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_concierge_assignments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_concierge_assignments_updated_at_trigger
    BEFORE UPDATE ON public.concierge_assignments
    FOR EACH ROW
    EXECUTE FUNCTION public.update_concierge_assignments_updated_at();

COMMENT ON TABLE public.concierge_assignments IS 'Stores driver, concierge, and villa assignments for bookings';
