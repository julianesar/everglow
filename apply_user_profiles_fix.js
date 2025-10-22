const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

const supabaseUrl = 'https://qfmnhwgcoxblgrctuxzg.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmbW5od2djb3hibGdyY3R1eHpnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMzg1MzcxMSwiZXhwIjoyMDQ5NDI5NzExfQ.YpfGCZZWNPrAnLaovB1pfCHCOp06yKLUxH5T9lbX4ow';

const supabase = createClient(supabaseUrl, supabaseKey);

async function applyMigration() {
  try {
    console.log('📦 Reading migration file...');
    const migrationPath = path.join(__dirname, 'supabase', 'migrations', '20250112000000_fix_user_profiles_rls_recursion.sql');
    const sql = fs.readFileSync(migrationPath, 'utf8');

    console.log('🚀 Applying migration to fix user_profiles RLS recursion...');
    const { data, error } = await supabase.rpc('exec_sql', { sql_query: sql });

    if (error) {
      // Try direct SQL execution
      console.log('⚠️  RPC method not available, trying direct execution...');

      // Split SQL into statements and execute them one by one
      const statements = sql
        .split(';')
        .map(s => s.trim())
        .filter(s => s.length > 0 && !s.startsWith('--'));

      for (const statement of statements) {
        if (statement.toUpperCase().includes('COMMENT ON')) {
          console.log('⏭️  Skipping COMMENT statement (not critical)');
          continue;
        }

        console.log(`Executing: ${statement.substring(0, 80)}...`);
        const { error: execError } = await supabase.rpc('exec', { sql: statement });

        if (execError) {
          console.error('❌ Error executing statement:', execError);
          throw execError;
        }
      }
    }

    console.log('✅ Migration applied successfully!');
    console.log('');
    console.log('The user_profiles RLS policy has been fixed.');
    console.log('You can now update user profiles without infinite recursion errors.');
  } catch (error) {
    console.error('❌ Error applying migration:', error);
    process.exit(1);
  }
}

applyMigration();
