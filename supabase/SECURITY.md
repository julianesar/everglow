# Supabase Security Configuration Guide

## Overview

This document outlines the security measures implemented to protect sensitive user data in the EverGlow application, including medical information and personal journal entries.

## 🔐 Security Measures Implemented

### 1. Row Level Security (RLS)

All tables have RLS enabled with the following policies:

#### User Data Isolation
- **Users can only access their own data** (bookings, profiles, responses, journal entries)
- **Admins have full access** to all user data (via `admin_roles` table)
- **Service role has unrestricted access** for backend operations

#### Content Tables (Public Read)
- `onboarding_questions`: Public read, service role write
- `daily_journey_content`: Public read, service role write
- `itinerary_items`: Public read, service role write
- `journaling_prompts`: Public read, service role write
- `aftercare_content`: Public read, service role write

### 2. Audit Logging

All sensitive operations are logged in the `audit_logs` table:

- **Tracked Operations**: INSERT, UPDATE, DELETE
- **Tracked Tables**:
  - `user_profiles` (medical data)
  - `user_onboarding_responses` (medical responses)
  - `user_journal_responses` (personal reflections)
  - `bookings`

**Audit logs include**:
- User ID
- Table name
- Operation type
- Old and new data (for updates)
- Timestamp
- IP address (if available)

### 3. Role-Based Access Control (RBAC)

Three staff roles are supported via the `admin_roles` table:

1. **admin**: Full access to all data and operations
2. **medical_staff**: Access to medical profiles via safe views
3. **concierge_staff**: Access to concierge preferences (future implementation)

**Role management**:
- Only service role can assign/revoke roles
- Users can view their own role
- Helper function `is_admin()` for permission checks

### 4. Data Validation Constraints

#### Booking Constraints
- Start date must be before end date
- Journey duration limited to 30 days maximum
- Future bookings limited to 1 year ahead
- Cannot backdate bookings more than 30 days

#### Response Length Limits
- Journal responses: 10,000 characters max
- Onboarding responses: 5,000 characters max
- Commitments: 500 characters max
- Multiple selection options: 10 items max

#### Data Integrity
- Prevent changing `user_id` after record creation
- Prevent duplicate responses (UNIQUE constraints)
- Validate foreign key references

### 5. GDPR Compliance

#### Right to Erasure
Function: `anonymize_user_data(user_id)`

This function allows users (or admins) to anonymize/erase personal data:
- Clears medical profile data
- Deletes onboarding responses
- Redacts journal responses
- Deletes commitments
- Logs the anonymization operation

**Usage**:
```sql
-- User anonymizes their own data
SELECT public.anonymize_user_data(auth.uid());

-- Admin anonymizes user data
SELECT public.anonymize_user_data('user-uuid-here');
```

#### Data Deletion Policies
Users can delete their own:
- User profiles
- Onboarding responses
- Journal responses
- Task completions
- Commitments

### 6. Medical Data Protection

#### Safe Views for Medical Staff
The `medical_profiles_view` provides:
- Access to medical data for authorized medical staff
- Masked patient identifiers for non-admin staff
- Full patient IDs only for admins

#### HIPAA Considerations
- Audit logging for all medical data access
- Role-based access control
- Data encryption at rest (via Supabase)
- Data encryption in transit (HTTPS/TLS)

### 7. Input Validation

All user inputs are validated:
- Text length limits
- Array size limits
- Date range validation
- Foreign key existence checks
- Enum/CHECK constraints for categorical data

## 🚀 Applying Security Migrations

### Step 1: Apply the Security Migration

```bash
# From the project root
npx supabase db push
```

Or if using Supabase CLI:

```bash
supabase migration up
```

### Step 2: Disable Realtime for Sensitive Tables

Realtime subscriptions should be disabled for tables containing sensitive data.

**Via Supabase Dashboard**:
1. Go to Database → Replication
2. Disable replication for:
   - `user_profiles`
   - `user_onboarding_responses`
   - `user_journal_responses`
   - `bookings`
   - `user_commitments`
   - `audit_logs`

**Via SQL** (run in Supabase SQL Editor):
```sql
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_profiles;
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_onboarding_responses;
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_journal_responses;
ALTER PUBLICATION supabase_realtime DROP TABLE public.bookings;
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_commitments;
ALTER PUBLICATION supabase_realtime DROP TABLE public.audit_logs;
```

### Step 3: Configure Supabase Settings

#### Enable Email Confirmations (Recommended)
1. Go to Authentication → Settings
2. Enable "Confirm email" for new signups
3. Configure email templates

#### Enable Multi-Factor Authentication (Optional but Recommended)
1. Go to Authentication → Settings
2. Enable MFA options (TOTP, SMS)

#### Configure Rate Limiting
1. Go to Settings → API
2. Set rate limits for anonymous requests
3. Set rate limits for authenticated requests

Recommended limits:
- Anonymous: 100 requests per hour
- Authenticated: 1000 requests per hour

#### Enable Database Backups
1. Go to Settings → Database
2. Enable daily backups
3. Configure backup retention (7-30 days recommended)

### Step 4: Create Admin Users

To create admin users, you need to insert into the `admin_roles` table using the service role key.

**Via Supabase SQL Editor**:
```sql
-- Replace 'user-uuid-here' with actual user UUID from auth.users
INSERT INTO public.admin_roles (user_id, role, granted_by)
VALUES ('user-uuid-here', 'admin', auth.uid())
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';
```

**Via Backend/Service**:
```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY! // Service role key
)

async function makeUserAdmin(userId: string) {
  const { error } = await supabase
    .from('admin_roles')
    .insert({
      user_id: userId,
      role: 'admin'
    })

  if (error) throw error
}
```

## 🛡️ Additional Security Best Practices

### 1. Environment Variables

Store sensitive keys in `.env` (NEVER commit to git):

```bash
# .env.local
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key  # Backend only!
```

**IMPORTANT**:
- ✅ Use `SUPABASE_ANON_KEY` in Flutter app
- ❌ NEVER use `SUPABASE_SERVICE_ROLE_KEY` in Flutter app
- ✅ Use `SUPABASE_SERVICE_ROLE_KEY` only in backend services

### 2. Secure API Keys

For AI services (Google AI, etc.):
- Store API keys in Supabase Edge Functions (not in app)
- Use environment variables in Edge Functions
- Never hardcode API keys in Flutter code

### 3. Transport Security

- Always use HTTPS/TLS for API calls
- Enable certificate pinning in production (optional)
- Use Supabase's built-in SSL/TLS

### 4. Authentication Best Practices

- Enforce strong password policies (via Supabase Auth settings)
- Enable email verification
- Consider MFA for admin users
- Implement session timeout (configurable in Supabase)
- Use secure password reset flow

### 5. Client-Side Security

In your Flutter app:

```dart
// ✅ Good: Use RLS-protected queries
final response = await supabase
    .from('user_profiles')
    .select()
    .eq('user_id', supabase.auth.currentUser!.id);

// ❌ Bad: Trying to query other users' data (will be blocked by RLS)
final response = await supabase
    .from('user_profiles')
    .select(); // Returns only current user's data
```

### 6. Logging and Monitoring

- Enable Supabase logging (Settings → Logs)
- Monitor audit logs regularly
- Set up alerts for suspicious activity
- Review access patterns periodically

### 7. Data Encryption

**Encryption at Rest** (Supabase default):
- All data encrypted using AES-256
- Automatic encryption for all tables

**Encryption in Transit**:
- All API calls use HTTPS/TLS 1.2+
- WebSocket connections use WSS

**Additional Encryption** (if needed for extra sensitive fields):
```sql
-- Example: Encrypt specific fields using pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Encrypt a field
UPDATE user_profiles
SET medical_notes = pgp_sym_encrypt('sensitive data', 'encryption-key');

-- Decrypt a field
SELECT pgp_sym_decrypt(medical_notes::bytea, 'encryption-key')
FROM user_profiles;
```

### 8. Backup and Recovery

- Enable automatic backups in Supabase dashboard
- Test backup restoration periodically
- Maintain off-site backup copies (export via pg_dump)
- Document recovery procedures

### 9. Compliance Checklists

#### HIPAA Compliance (Healthcare Data)
- ✅ Audit logging enabled
- ✅ Encryption at rest and in transit
- ✅ Role-based access control
- ✅ Data anonymization capabilities
- ✅ Access logs maintained
- ⚠️ Business Associate Agreement (BAA) with Supabase required
- ⚠️ Additional infrastructure hardening may be needed

#### GDPR Compliance (EU Users)
- ✅ Right to access (users can read their data)
- ✅ Right to erasure (`anonymize_user_data` function)
- ✅ Right to rectification (users can update their data)
- ✅ Right to data portability (export via Supabase API)
- ✅ Consent management (via onboarding flow)
- ✅ Audit trails
- ⚠️ Privacy policy and terms required
- ⚠️ Cookie consent required (if using web)

## 🧪 Testing Security

### Test RLS Policies

```sql
-- Test as anonymous user (should fail)
SET request.jwt.claims = '{}';
SELECT * FROM user_profiles; -- Should return 0 rows

-- Test as authenticated user (should see only own data)
SET request.jwt.claims = '{"sub": "user-uuid-here"}';
SELECT * FROM user_profiles; -- Should return only that user's profile

-- Test as admin (should see all data)
-- First, make user an admin, then:
SELECT * FROM user_profiles; -- Should return all profiles
```

### Test Audit Logging

```sql
-- Perform an operation
UPDATE user_profiles SET allergies = ARRAY['peanuts'] WHERE user_id = auth.uid();

-- Check audit log
SELECT * FROM audit_logs WHERE table_name = 'user_profiles' ORDER BY created_at DESC LIMIT 1;
```

### Test Data Anonymization

```sql
-- Create test data
INSERT INTO user_profiles (user_id, allergies, medical_conditions)
VALUES (auth.uid(), ARRAY['test'], ARRAY['test']);

-- Anonymize
SELECT anonymize_user_data(auth.uid());

-- Verify anonymization
SELECT * FROM user_profiles WHERE user_id = auth.uid();
-- Should show empty arrays
```

## 📋 Security Checklist

Before going to production:

- [ ] All RLS policies tested and verified
- [ ] Audit logging enabled and tested
- [ ] Admin roles configured
- [ ] Realtime disabled for sensitive tables
- [ ] Rate limiting configured
- [ ] Email verification enabled
- [ ] MFA enabled for admin users
- [ ] Backups enabled and tested
- [ ] Environment variables secured
- [ ] Service role key not exposed in client code
- [ ] Privacy policy and terms of service created
- [ ] GDPR compliance verified (if applicable)
- [ ] HIPAA compliance verified (if applicable)
- [ ] Security monitoring set up
- [ ] Incident response plan documented

## 🆘 Security Incident Response

If you suspect a security breach:

1. **Immediately**:
   - Rotate service role keys (Supabase dashboard)
   - Review audit logs for suspicious activity
   - Disable affected user accounts if needed

2. **Within 24 hours**:
   - Identify scope of breach
   - Document affected data
   - Notify affected users (if required by law)

3. **Within 72 hours** (GDPR requirement if applicable):
   - Report breach to supervisory authority
   - Document breach response
   - Implement corrective measures

## 📞 Support

For security questions:
- Supabase Security: https://supabase.com/docs/guides/platform/security
- Supabase Support: support@supabase.io

For compliance questions:
- Consult with legal counsel
- Review Supabase compliance documentation: https://supabase.com/security
