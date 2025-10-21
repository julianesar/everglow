import 'package:supabase_flutter/supabase_flutter.dart';

/// Test script to verify Supabase connection and table schema
void main() async {
  print('🔍 Starting Supabase Connection Test...\n');

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://wficuvdsfokzphftvtbi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmaWN1dmRzZm9renBoZnR2dGJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3NTk5NTIsImV4cCI6MjA3NjMzNTk1Mn0.HrFX5gvGVG_mmq4SVHh5nMMqXcf17ZTHUN8mbGwklEc',
    );
    print('✅ Supabase initialized successfully\n');
  } catch (e) {
    print('❌ Failed to initialize Supabase: $e');
    return;
  }

  final supabase = Supabase.instance.client;

  // Test 1: Check onboarding_questions table
  print('📋 Test 1: Checking onboarding_questions table...');
  try {
    final questionsResponse = await supabase
        .from('onboarding_questions')
        .select('id, question_text, category')
        .limit(5);

    print('✅ Found ${questionsResponse.length} questions');
    for (final q in questionsResponse) {
      print('   - ${q['id']}: ${q['question_text']} (${q['category']})');
    }
  } catch (e) {
    print('❌ Error querying onboarding_questions: $e');
  }

  print('');

  // Test 2: Check user_onboarding_responses table structure
  print('📋 Test 2: Checking user_onboarding_responses table...');
  try {
    final responsesResponse =
        await supabase.from('user_onboarding_responses').select('*').limit(5);

    print('✅ Found ${responsesResponse.length} responses in database');
    if (responsesResponse.isNotEmpty) {
      print('Sample response:');
      print('   ${responsesResponse.first}');
    } else {
      print('   (No responses found - this is expected if onboarding hasn\'t been completed)');
    }
  } catch (e) {
    print('❌ Error querying user_onboarding_responses: $e');
  }

  print('');

  // Test 3: Check user_profiles table structure
  print('📋 Test 3: Checking user_profiles table...');
  try {
    final profilesResponse =
        await supabase.from('user_profiles').select('*').limit(5);

    print('✅ Found ${profilesResponse.length} profiles');
    if (profilesResponse.isNotEmpty) {
      print('Sample profile:');
      final profile = profilesResponse.first;
      print('   user_id: ${profile['user_id']}');
      print('   has_completed_onboarding: ${profile['has_completed_onboarding']}');
      print('   name: ${profile['name']}');
    } else {
      print('   (No profiles found)');
    }
  } catch (e) {
    print('❌ Error querying user_profiles: $e');
  }

  print('');

  // Test 4: Try to insert a test response (will fail due to RLS if not authenticated)
  print('📋 Test 4: Testing insert without authentication (should fail)...');
  try {
    await supabase.from('user_onboarding_responses').insert({
      'user_id': '00000000-0000-0000-0000-000000000000', // Dummy UUID
      'question_id': 'test_q1',
      'response_text': 'Test response',
      'response_options': [],
    });
    print('⚠️  Insert succeeded (unexpected - RLS might be disabled)');
  } catch (e) {
    print('✅ Insert failed as expected (RLS is working): $e');
  }

  print('');
  print('🎉 Supabase Connection Test Complete!\n');
  print('Summary:');
  print('- If you see errors above, check:');
  print('  1. Migrations are applied in Supabase');
  print('  2. Tables exist in the public schema');
  print('  3. RLS policies are configured correctly');
  print('  4. User is authenticated when saving responses');
}
