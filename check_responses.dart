import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://jkpcfcyqqjulzliqtkyi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImprcGNmY3lxcWp1bHpsaXF0a3lpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY3MDAyMjMsImV4cCI6MjA1MjI3NjIyM30.P7lYdDtXzDOjPMlz1lPADMu1rFHUAGxbTyDsqQ8r0Uo',
  );

  final supabase = Supabase.instance.client;
  
  print('Checking user_onboarding_responses...');
  try {
    final response = await supabase
        .from('user_onboarding_responses')
        .select('*')
        .limit(10);
    print('Success! Found ${response.length} responses');
    print('Data: $response');
  } catch (e) {
    print('Error: $e');
  }
}
