import 'package:supabase_flutter/supabase_flutter.dart';

/// Script to check if onboarding questions exist in the database
void main() async {
  print('═══════════════════════════════════════════════════');
  print('🔍 Checking Supabase for onboarding questions...');
  print('═══════════════════════════════════════════════════');

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://nyhfjnykxxbqkumhwfkb.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55aGZqbnlreHhicWt1bWh3ZmtiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0MTU4NTksImV4cCI6MjA1Mjk5MTg1OX0.5uHrDBokJVzuuSQ_IUwEU6LRhQ9YwVn-qCNUmK_VFYQ',
    );

    final supabase = Supabase.instance.client;

    // Check onboarding_questions table
    print('\n📋 Fetching onboarding questions...');
    final questionsResponse = await supabase
        .from('onboarding_questions')
        .select()
        .order('display_order', ascending: true);

    final questions = questionsResponse as List;
    print('✅ Found ${questions.length} questions in the database\n');

    if (questions.isEmpty) {
      print('⚠️ WARNING: No questions found in the database!');
      print('   You need to add questions to the onboarding_questions table.');
    } else {
      // Group by category
      final medicalQuestions = questions.where((q) => q['category'] == 'medical').toList();
      final conciergeQuestions = questions.where((q) => q['category'] == 'concierge').toList();

      print('📊 Questions breakdown:');
      print('   Medical questions: ${medicalQuestions.length}');
      print('   Concierge questions: ${conciergeQuestions.length}');
      print('');

      if (medicalQuestions.isEmpty) {
        print('⚠️ WARNING: No MEDICAL questions found!');
      } else {
        print('✅ Medical questions:');
        for (final q in medicalQuestions) {
          print('   ${q['display_order']}. ${q['question_text']}');
        }
      }

      print('');

      if (conciergeQuestions.isEmpty) {
        print('⚠️ WARNING: No CONCIERGE questions found!');
      } else {
        print('✅ Concierge questions:');
        for (final q in conciergeQuestions) {
          print('   ${q['display_order']}. ${q['question_text']}');
        }
      }
    }

    print('\n═══════════════════════════════════════════════════');
    print('✅ Check complete');
    print('═══════════════════════════════════════════════════');
  } catch (e, stackTrace) {
    print('\n❌ ERROR: $e');
    print('Stack trace:');
    print(stackTrace);
    print('═══════════════════════════════════════════════════');
  }
}
