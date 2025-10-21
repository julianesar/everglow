import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/concierge_info.dart';
import '../../domain/repositories/concierge_repository.dart';

part 'concierge_repository_impl.g.dart';

/// Implementation of [ConciergeRepository] with hardcoded data.
class ConciergeRepositoryImpl implements ConciergeRepository {
  @override
  Future<ConciergeInfo> getConciergeInfo(String bookingId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return hardcoded concierge information
    return const ConciergeInfo(
      driverName: 'Carlos Mendoza',
      driverPhone: '+52 998 123 4567',
      conciergeName: 'Sofia Martinez',
      conciergePhone: '+52 998 765 4321',
      conciergePhotoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=988',
      villaAddress: 'Villa Serenidad, Carretera Tulum-Boca Paila Km 7.5, 77780 Tulum, Q.R., Mexico',
      villaImageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=2071',
      checkInInstructions: 'Welcome to Villa Serenidad! Your driver Carlos will pick you up from Cancun Airport. '
          'Please meet him at Terminal 2, Exit Gate B. He will be holding a sign with your name. '
          'The journey to your villa takes approximately 2 hours. Upon arrival, your wellness coordinator '
          'will greet you with a refreshing welcome drink and guide you through your personalized journey.',
    );
  }
}

/// Provider for [ConciergeRepository].
@riverpod
ConciergeRepository conciergeRepository(ConciergeRepositoryRef ref) {
  return ConciergeRepositoryImpl();
}
