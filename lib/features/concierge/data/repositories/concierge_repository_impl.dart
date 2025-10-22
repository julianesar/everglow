import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/isar_provider.dart';
import '../../domain/entities/concierge_info.dart';
import '../../domain/repositories/concierge_repository.dart';
import '../datasources/concierge_remote_datasource.dart';
import '../models/concierge_info_model.dart';

part 'concierge_repository_impl.g.dart';

/// Implementation of [ConciergeRepository] with Isar and Supabase persistence.
///
/// This repository uses a dual-persistence strategy:
/// - Isar for local caching and offline access
/// - Supabase for remote synchronization and data retrieval
class ConciergeRepositoryImpl implements ConciergeRepository {
  /// The Isar database instance for local storage.
  final Isar _isar;

  /// The remote datasource for Supabase operations.
  final ConciergeRemoteDatasource _remoteDatasource;

  /// Creates an instance of [ConciergeRepositoryImpl].
  ///
  /// [isar] The Isar database instance to use for local storage.
  /// [remoteDatasource] The remote datasource for Supabase operations.
  const ConciergeRepositoryImpl(this._isar, this._remoteDatasource);

  @override
  Future<ConciergeInfo> getConciergeInfo(String bookingId) async {
    try {
      // Try to fetch from Supabase first
      final remoteData = await _remoteDatasource.getConciergeInfo(bookingId);

      if (remoteData != null) {
        // Convert remote data to model
        final model = ConciergeInfoModel.fromSupabaseJson(remoteData);

        // Update local cache
        await _updateLocalConciergeInfo(model);

        // Return as entity
        return model.toEntity();
      }
    } catch (e) {
      // If remote fetch fails, continue to local fallback
      print('Failed to fetch concierge info from Supabase: $e');
    }

    // Fallback to local database
    final cachedModel = await _isar.conciergeInfoModels
        .filter()
        .bookingIdEqualTo(bookingId)
        .findFirst();

    if (cachedModel != null) {
      return cachedModel.toEntity();
    }

    // If no data exists in either location, return empty info
    // This allows the UI to show "---" for missing fields
    return const ConciergeInfo();
  }

  @override
  Stream<ConciergeInfo> watchConciergeInfo(String bookingId) {
    // Start with local cached data for immediate UI update
    return _remoteDatasource.watchConciergeInfo(bookingId).asyncMap((remoteData) async {
      if (remoteData != null) {
        // Convert remote data to model
        final model = ConciergeInfoModel.fromSupabaseJson(remoteData);

        // Update local cache in the background
        _updateLocalConciergeInfo(model);

        // Return as entity
        return model.toEntity();
      }

      // If no remote data, try to get from local cache
      final cachedModel = await _isar.conciergeInfoModels
          .filter()
          .bookingIdEqualTo(bookingId)
          .findFirst();

      if (cachedModel != null) {
        return cachedModel.toEntity();
      }

      // Return empty info if no data exists
      return const ConciergeInfo();
    });
  }

  /// Updates or inserts concierge info in the local Isar database.
  Future<void> _updateLocalConciergeInfo(ConciergeInfoModel model) async {
    await _isar.writeTxn(() async {
      // Find existing model by booking ID
      final existingModel = await _isar.conciergeInfoModels
          .filter()
          .bookingIdEqualTo(model.bookingId)
          .findFirst();

      if (existingModel != null) {
        // Update the existing model
        existingModel.driverName = model.driverName;
        existingModel.driverPhone = model.driverPhone;
        existingModel.conciergeName = model.conciergeName;
        existingModel.conciergePhone = model.conciergePhone;
        existingModel.conciergePhotoUrl = model.conciergePhotoUrl;
        existingModel.villaAddress = model.villaAddress;
        existingModel.villaImageUrl = model.villaImageUrl;
        existingModel.checkInInstructions = model.checkInInstructions;

        await _isar.conciergeInfoModels.put(existingModel);
      } else {
        // Insert new model
        await _isar.conciergeInfoModels.put(model);
      }
    });
  }
}

/// Provider for [ConciergeRemoteDatasource].
///
/// This provider creates and provides the Supabase-based remote datasource.
@Riverpod(keepAlive: true)
ConciergeRemoteDatasource conciergeRemoteDatasource(
    ConciergeRemoteDatasourceRef ref) {
  return ConciergeRemoteDatasource(
    supabaseClient: Supabase.instance.client,
  );
}

/// Provider for [ConciergeRepository].
///
/// This provider creates and provides the concierge repository with
/// both Isar (local) and Supabase (remote) persistence.
@Riverpod(keepAlive: true)
Future<ConciergeRepository> conciergeRepository(
    ConciergeRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  final remoteDatasource = ref.watch(conciergeRemoteDatasourceProvider);
  return ConciergeRepositoryImpl(isar, remoteDatasource);
}
