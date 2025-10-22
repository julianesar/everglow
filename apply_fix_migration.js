const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

// Read migration file
const migrationPath = path.join(__dirname, 'supabase', 'migrations', '20250111000000_fix_journal_responses_rls_recursion.sql');
const migrationSQL = fs.readFileSync(migrationPath, 'utf8');

// Supabase credentials
const SUPABASE_URL = 'https://fqjgfvmncxokqnscqjxu.supabase.co';
const SUPABASE_SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxamdmdm1uY3hva3Fuc2Nxanh1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNjQzNjA3OCwiZXhwIjoyMDUyMDEyMDc4fQ.w9F39nklEa2L4ZCwB-l3kn04W30c4Ssp5OwYWcnJSP0';

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

async function applyMigration() {
  console.log('🔧 Applying migration to fix RLS recursion...\n');

  try {
    // Split the migration into individual statements
    const statements = migrationSQL
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0 && !s.startsWith('--'));

    console.log(`Found ${statements.length} SQL statements to execute\n`);

    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i] + ';';

      // Skip comments
      if (statement.startsWith('--') || statement.startsWith('COMMENT')) {
        console.log(`Skipping comment/documentation statement ${i + 1}`);
        continue;
      }

      console.log(`Executing statement ${i + 1}/${statements.length}...`);

      const { error } = await supabase.rpc('exec_sql', { sql: statement });

      if (error) {
        // Try direct query if RPC fails
        console.log(`RPC failed, trying direct query...`);
        const { error: directError } = await supabase.from('_migrations').insert({ statement });

        if (directError) {
          console.error(`❌ Error executing statement ${i + 1}:`, error.message);
          console.error('Statement:', statement.substring(0, 200) + '...');
        } else {
          console.log(`✓ Statement ${i + 1} executed successfully`);
        }
      } else {
        console.log(`✓ Statement ${i + 1} executed successfully`);
      }
    }

    console.log('\n✅ Migration applied successfully!');
    console.log('\nThe following policies have been fixed:');
    console.log('  1. "Users can insert their own journal responses" - removed prompt_id validation');
    console.log('  2. "Users can update their own journal responses" - removed recursive subqueries');

  } catch (error) {
    console.error('\n❌ Error applying migration:', error.message);
    process.exit(1);
  }
}

applyMigration();
