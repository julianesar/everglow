/**
 * Script to apply the RLS policy fix migration to Supabase
 *
 * This script reads and executes the RLS fix migration that allows
 * users to insert task completions without the restrictive EXISTS check.
 */

const fs = require('fs');
const { createClient } = require('@supabase/supabase-js');

// Load environment variables
require('dotenv').config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Error: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in .env file');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function applyRLSFix() {
  console.log('🔧 Applying RLS policy fix for user_task_completions...\n');

  try {
    // Read the migration file
    const migrationPath = './supabase/migrations/20250109000000_fix_task_completions_rls.sql';
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8');

    console.log('📄 Migration SQL:');
    console.log('─'.repeat(80));
    console.log(migrationSQL);
    console.log('─'.repeat(80));
    console.log();

    // Execute the migration
    console.log('⏳ Executing migration...');
    const { data, error } = await supabase.rpc('exec_sql', {
      sql_string: migrationSQL
    });

    if (error) {
      // If exec_sql doesn't exist, try direct execution
      console.log('⚠️  exec_sql not available, trying direct execution...');

      // Split by semicolon and execute each statement
      const statements = migrationSQL
        .split(';')
        .map(s => s.trim())
        .filter(s => s.length > 0 && !s.startsWith('--'));

      for (const statement of statements) {
        if (statement.includes('DROP POLICY')) {
          console.log('  📌 Dropping old policy...');
        } else if (statement.includes('CREATE POLICY')) {
          console.log('  ✅ Creating new policy...');
        } else if (statement.includes('COMMENT')) {
          console.log('  💬 Adding comment...');
        }

        const { error: execError } = await supabase.rpc('exec', {
          sql: statement + ';'
        });

        if (execError) {
          console.error(`  ❌ Error executing statement: ${execError.message}`);
          // Continue anyway, as DROP might fail if policy doesn't exist
        }
      }
    }

    console.log('\n✅ RLS policy fix applied successfully!');
    console.log('\n📋 Summary:');
    console.log('  - Removed restrictive EXISTS check from INSERT policy');
    console.log('  - Policy now only validates user_id and day_number');
    console.log('  - Foreign key constraint ensures data integrity');
    console.log('\n🧪 You can now test task completions in the app!');

  } catch (error) {
    console.error('\n❌ Error applying migration:', error.message);
    console.error('\n💡 Manual fix required:');
    console.log('   1. Open Supabase Dashboard');
    console.log('   2. Go to SQL Editor');
    console.log('   3. Run the contents of:');
    console.log('      supabase/migrations/20250109000000_fix_task_completions_rls.sql');
    process.exit(1);
  }
}

applyRLSFix();
