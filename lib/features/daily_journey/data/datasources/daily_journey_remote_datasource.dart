import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for daily journey content using Supabase.
///
/// Fetches static content like daily titles, mantras, itinerary items, and prompts.
class DailyJourneyRemoteDatasource {
  final SupabaseClient _supabase;

  DailyJourneyRemoteDatasource(this._supabase);

  /// Fetches daily journey content (title, mantra) for all days.
  Future<List<DailyContentData>> getDailyContent() async {
    try {
      final response = await _supabase
          .from('daily_journey_content')
          .select()
          .order('day_number', ascending: true);

      return (response as List)
          .map((json) => DailyContentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch daily content: $e');
    }
  }

  /// Fetches daily journey content for a specific day.
  Future<DailyContentData?> getDailyContentByDay(int dayNumber) async {
    try {
      final response = await _supabase
          .from('daily_journey_content')
          .select()
          .eq('day_number', dayNumber)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return DailyContentData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch daily content for day: $e');
    }
  }

  /// Fetches all itinerary items.
  Future<List<ItineraryItemData>> getItineraryItems() async {
    try {
      final response = await _supabase
          .from('itinerary_items')
          .select()
          .order('day_number', ascending: true)
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => ItineraryItemData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch itinerary items: $e');
    }
  }

  /// Fetches itinerary items for a specific day.
  Future<List<ItineraryItemData>> getItineraryItemsByDay(
      int dayNumber) async {
    try {
      final response = await _supabase
          .from('itinerary_items')
          .select()
          .eq('day_number', dayNumber)
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => ItineraryItemData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch itinerary items for day: $e');
    }
  }

  /// Fetches all journaling prompts.
  Future<List<JournalingPromptData>> getJournalingPrompts() async {
    try {
      final response = await _supabase
          .from('journaling_prompts')
          .select('*, itinerary_items!inner(day_number)')
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => JournalingPromptData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch journaling prompts: $e');
    }
  }

  /// Fetches journaling prompts for a specific itinerary item.
  Future<List<JournalingPromptData>> getPromptsByItineraryItem(
      String itineraryItemId) async {
    try {
      final response = await _supabase
          .from('journaling_prompts')
          .select()
          .eq('itinerary_item_id', itineraryItemId)
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => JournalingPromptData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch prompts for itinerary item: $e');
    }
  }

  /// Fetches journaling prompts for a specific day.
  Future<List<JournalingPromptData>> getPromptsByDay(int dayNumber) async {
    try {
      final response = await _supabase
          .from('journaling_prompts')
          .select('*, itinerary_items!inner(day_number)')
          .eq('itinerary_items.day_number', dayNumber)
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => JournalingPromptData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch prompts for day: $e');
    }
  }
}

/// Data model for daily journey content (title and mantra).
class DailyContentData {
  final String id;
  final int dayNumber;
  final String title;
  final String mantra;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyContentData({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.mantra,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyContentData.fromJson(Map<String, dynamic> json) {
    return DailyContentData(
      id: json['id'] as String,
      dayNumber: json['day_number'] as int,
      title: json['title'] as String,
      mantra: json['mantra'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_number': dayNumber,
      'title': title,
      'mantra': mantra,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Data model for itinerary items (tasks/activities).
class ItineraryItemData {
  final String id;
  final int dayNumber;
  final String itemType;
  final String time;
  final String title;
  final String? description;
  final String? location;
  final String? audioUrl;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItineraryItemData({
    required this.id,
    required this.dayNumber,
    required this.itemType,
    required this.time,
    required this.title,
    this.description,
    this.location,
    this.audioUrl,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItineraryItemData.fromJson(Map<String, dynamic> json) {
    return ItineraryItemData(
      id: json['id'] as String,
      dayNumber: json['day_number'] as int,
      itemType: json['item_type'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      audioUrl: json['audio_url'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_number': dayNumber,
      'item_type': itemType,
      'time': time,
      'title': title,
      'description': description,
      'location': location,
      'audio_url': audioUrl,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Data model for journaling prompts.
class JournalingPromptData {
  final String id;
  final String itineraryItemId;
  final String promptText;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalingPromptData({
    required this.id,
    required this.itineraryItemId,
    required this.promptText,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalingPromptData.fromJson(Map<String, dynamic> json) {
    return JournalingPromptData(
      id: json['id'] as String,
      itineraryItemId: json['itinerary_item_id'] as String,
      promptText: json['prompt_text'] as String,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itinerary_item_id': itineraryItemId,
      'prompt_text': promptText,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
