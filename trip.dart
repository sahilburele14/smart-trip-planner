import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'trip.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? firstName;
  @HiveField(4)
  final String? lastName;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
      };

  @override
  List<Object?> get props => [id, username, email, firstName, lastName];
}

@HiveType(typeId: 1)
class Trip extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String destination;
  @HiveField(4)
  final DateTime startDate;
  @HiveField(5)
  final DateTime endDate;
  @HiveField(6)
  final User createdBy;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  final bool isActive;
  @HiveField(9)
  final List<Collaborator>? collaborators;
  @HiveField(10)
  final List<ItineraryItem>? itineraryItems;

  const Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.createdAt,
    this.isActive = true,
    this.collaborators,
    this.itineraryItems,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        destination: json['destination'],
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
        createdBy: User.fromJson(json['created_by']),
        createdAt: DateTime.parse(json['created_at']),
        isActive: json['is_active'] ?? true,
        collaborators: json['collaborators'] != null
            ? (json['collaborators'] as List)
                .map((e) => Collaborator.fromJson(e))
                .toList()
            : null,
        itineraryItems: json['itinerary_items'] != null
            ? (json['itinerary_items'] as List)
                .map((e) => ItineraryItem.fromJson(e))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'destination': destination,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
        'created_by': createdBy.toJson(),
        'created_at': createdAt.toIso8601String(),
        'is_active': isActive,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        destination,
        startDate,
        endDate,
        createdBy,
        createdAt,
        isActive
      ];
}

@HiveType(typeId: 2)
class Collaborator extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final User user;
  @HiveField(2)
  final String role;
  @HiveField(3)
  final DateTime joinedAt;

  const Collaborator({
    required this.id,
    required this.user,
    required this.role,
    required this.joinedAt,
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) => Collaborator(
        id: json['id'],
        user: User.fromJson(json['user']),
        role: json['role'],
        joinedAt: DateTime.parse(json['joined_at']),
      );

  @override
  List<Object?> get props => [id, user, role, joinedAt];
}

@HiveType(typeId: 3)
class ItineraryItem extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int tripId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final DateTime startTime;
  @HiveField(6)
  final DateTime? endTime;
  @HiveField(7)
  final String? location;
  @HiveField(8)
  final double? cost;
  @HiveField(9)
  final int order;
  @HiveField(10)
  final User createdBy;

  const ItineraryItem({
    required this.id,
    required this.tripId,
    required this.title,
    required this.description,
    required this.category,
    required this.startTime,
    this.endTime,
    this.location,
    this.cost,
    required this.order,
    required this.createdBy,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) => ItineraryItem(
        id: json['id'],
        tripId: json['trip'],
        title: json['title'],
        description: json['description'] ?? '',
        category: json['category'],
        startTime: DateTime.parse(json['start_time']),
        endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
        location: json['location'],
        cost: json['cost'] != null ? double.parse(json['cost'].toString()) : null,
        order: json['order'],
        createdBy: User.fromJson(json['created_by']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'trip': tripId,
        'title': title,
        'description': description,
        'category': category,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'location': location,
        'cost': cost,
        'order': order,
      };

  ItineraryItem copyWith({
    int? id,
    int? tripId,
    String? title,
    String? description,
    String? category,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    double? cost,
    int? order,
    User? createdBy,
  }) {
    return ItineraryItem(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      order: order ?? this.order,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        title,
        description,
        category,
        startTime,
        endTime,
        location,
        cost,
        order
      ];
}

@HiveType(typeId: 4)
class Poll extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int tripId;
  @HiveField(2)
  final String question;
  @HiveField(3)
  final User createdBy;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final bool isActive;
  @HiveField(6)
  final bool allowMultiple;
  @HiveField(7)
  final List<PollOption> options;
  @HiveField(8)
  final List<int> userVotes;
  @HiveField(9)
  final int totalVotes;

  const Poll({
    required this.id,
    required this.tripId,
    required this.question,
    required this.createdBy,
    required this.createdAt,
    required this.isActive,
    required this.allowMultiple,
    required this.options,
    required this.userVotes,
    required this.totalVotes,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
        id: json['id'],
        tripId: json['trip'],
        question: json['question'],
        createdBy: User.fromJson(json['created_by']),
        createdAt: DateTime.parse(json['created_at']),
        isActive: json['is_active'],
        allowMultiple: json['allow_multiple'],
        options: (json['options'] as List)
            .map((e) => PollOption.fromJson(e))
            .toList(),
        userVotes: List<int>.from(json['user_votes'] ?? []),
        totalVotes: json['total_votes'] ?? 0,
      );

  @override
  List<Object?> get props => [
        id,
        tripId,
        question,
        createdBy,
        createdAt,
        isActive,
        allowMultiple,
        options,
        userVotes,
        totalVotes
      ];
}

@HiveType(typeId: 5)
class PollOption extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final int order;
  @HiveField(3)
  final int voteCount;

  const PollOption({
    required this.id,
    required this.text,
    required this.order,
    required this.voteCount,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) => PollOption(
        id: json['id'],
        text: json['text'],
        order: json['order'],
        voteCount: json['vote_count'] ?? 0,
      );

  @override
  List<Object?> get props => [id, text, order, voteCount];
}

@HiveType(typeId: 6)
class ChatMessage extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int tripId;
  @HiveField(2)
  final User user;
  @HiveField(3)
  final String message;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final bool isDeleted;

  const ChatMessage({
    required this.id,
    required this.tripId,
    required this.user,
    required this.message,
    required this.createdAt,
    this.isDeleted = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        tripId: json['trip'],
        user: User.fromJson(json['user']),
        message: json['message'],
        createdAt: DateTime.parse(json['created_at']),
        isDeleted: json['is_deleted'] ?? false,
      );

  @override
  List<Object?> get props => [id, tripId, user, message, createdAt, isDeleted];
}