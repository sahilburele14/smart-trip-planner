import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip.dart';

class StorageService {
  static const String tripsBoxName = 'trips';
  static const String itineraryBoxName = 'itinerary';
  static const String pollsBoxName = 'polls';
  static const String messagesBoxName = 'messages';
  static const String pendingOpsBoxName = 'pending_operations';
  
  late Box<Trip> _tripsBox;
  late Box<ItineraryItem> _itineraryBox;
  late Box<Poll> _pollsBox;
  late Box<ChatMessage> _messagesBox;
  late Box _pendingOpsBox;
  late SharedPreferences _prefs;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TripAdapter());
    Hive.registerAdapter(CollaboratorAdapter());
    Hive.registerAdapter(ItineraryItemAdapter());
    Hive.registerAdapter(PollAdapter());
    Hive.registerAdapter(PollOptionAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    
    // Open boxes
    _tripsBox = await Hive.openBox<Trip>(tripsBoxName);
    _itineraryBox = await Hive.openBox<ItineraryItem>(itineraryBoxName);
    _pollsBox = await Hive.openBox<Poll>(pollsBoxName);
    _messagesBox = await Hive.openBox<ChatMessage>(messagesBoxName);
    _pendingOpsBox = await Hive.openBox(pendingOpsBoxName);
    
    _prefs = await SharedPreferences.getInstance();
  }

  // Authentication
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  Future<String?> getAuthToken() async {
    return _prefs.getString('auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString('refresh_token', token);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString('refresh_token');
  }

  Future<void> clearAuth() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('refresh_token');
  }

  Future<void> saveUser(User user) async {
    await _prefs.setInt('user_id', user.id);
    await _prefs.setString('username', user.username);
    await _prefs.setString('email', user.email);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userId = _prefs.getInt('user_id');
    if (userId == null) return null;
    
    return {
      'id': userId,
      'username': _prefs.getString('username'),
      'email': _prefs.getString('email'),
    };
  }

  // Trips
  Future<void> saveTrip(Trip trip) async {
    await _tripsBox.put(trip.id, trip);
  }

  Future<void> saveTrips(List<Trip> trips) async {
    final map = {for (var trip in trips) trip.id: trip};
    await _tripsBox.putAll(map);
  }

  Future<Trip?> getTrip(int tripId) async {
    return _tripsBox.get(tripId);
  }

  Future<List<Trip>> getTrips() async {
    return _tripsBox.values.toList();
  }

  Future<void> deleteTrip(int tripId) async {
    await _tripsBox.delete(tripId);
  }

  // Itinerary Items
  Future<void> saveItineraryItem(ItineraryItem item) async {
    await _itineraryBox.put(item.id, item);
  }

  Future<void> saveItineraryItems(List<ItineraryItem> items) async {
    final map = {for (var item in items) item.id: item};
    await _itineraryBox.putAll(map);
  }

  Future<List<ItineraryItem>> getItineraryItems(int tripId) async {
    return _itineraryBox.values
        .where((item) => item.tripId == tripId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<void> deleteItineraryItem(int itemId) async {
    await _itineraryBox.delete(itemId);
  }

  // Polls
  Future<void> savePoll(Poll poll) async {
    await _pollsBox.put(poll.id, poll);
  }

  Future<void> savePolls(List<Poll> polls) async {
    final map = {for (var poll in polls) poll.id: poll};
    await _pollsBox.putAll(map);
  }

  Future<List<Poll>> getPolls(int tripId) async {
    return _pollsBox.values
        .where((poll) => poll.tripId == tripId)
        .toList();
  }

  // Chat Messages
  Future<void> saveChatMessage(ChatMessage message) async {
    await _messagesBox.put(message.id, message);
  }

  Future<void> saveChatMessages(List<ChatMessage> messages) async {
    final map = {for (var msg in messages) msg.id: msg};
    await _messagesBox.putAll(map);
  }

  Future<List<ChatMessage>> getChatMessages(int tripId) async {
    return _messagesBox.values
        .where((msg) => msg.tripId == tripId && !msg.isDeleted)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  // Pending Operations (for offline sync)
  Future<void> savePendingOperation(Map<String, dynamic> operation) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _pendingOpsBox.put(key, operation);
  }

  Future<List<Map<String, dynamic>>> getPendingOperations() async {
    return _pendingOpsBox.values
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<void> removePendingOperation(Map<String, dynamic> operation) async {
    final keys = _pendingOpsBox.keys.where((key) {
      final value = _pendingOpsBox.get(key);
      return value == operation;
    });
    
    for (var key in keys) {
      await _pendingOpsBox.delete(key);
    }
  }

  Future<void> clearPendingOperations() async {
    await _pendingOpsBox.clear();
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _tripsBox.clear();
    await _itineraryBox.clear();
    await _pollsBox.clear();
    await _messagesBox.clear();
    await _pendingOpsBox.clear();
    await clearAuth();
  }
}