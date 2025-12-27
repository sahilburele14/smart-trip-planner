import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/trip.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

// Events
abstract class TripEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTrips extends TripEvent {}

class LoadTripDetails extends TripEvent {
  final int tripId;
  LoadTripDetails(this.tripId);
  @override
  List<Object?> get props => [tripId];
}

class CreateTrip extends TripEvent {
  final Map<String, dynamic> tripData;
  CreateTrip(this.tripData);
  @override
  List<Object?> get props => [tripData];
}

class UpdateTrip extends TripEvent {
  final int tripId;
  final Map<String, dynamic> tripData;
  UpdateTrip(this.tripId, this.tripData);
  @override
  List<Object?> get props => [tripId, tripData];
}

class DeleteTrip extends TripEvent {
  final int tripId;
  DeleteTrip(this.tripId);
  @override
  List<Object?> get props => [tripId];
}

class SyncTrips extends TripEvent {}

// States
abstract class TripState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripsLoaded extends TripState {
  final List<Trip> trips;
  final bool isFromCache;
  
  TripsLoaded(this.trips, {this.isFromCache = false});
  
  @override
  List<Object?> get props => [trips, isFromCache];
}

class TripDetailsLoaded extends TripState {
  final Trip trip;
  
  TripDetailsLoaded(this.trip);
  
  @override
  List<Object?> get props => [trip];
}

class TripOperationSuccess extends TripState {
  final String message;
  
  TripOperationSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}

class TripError extends TripState {
  final String message;
  
  TripError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class TripBloc extends Bloc<TripEvent, TripState> {
  final ApiService apiService;
  final StorageService storageService;

  TripBloc({
    required this.apiService,
    required this.storageService,
  }) : super(TripInitial()) {
    on<LoadTrips>(_onLoadTrips);
    on<LoadTripDetails>(_onLoadTripDetails);
    on<CreateTrip>(_onCreateTrip);
    on<UpdateTrip>(_onUpdateTrip);
    on<DeleteTrip>(_onDeleteTrip);
    on<SyncTrips>(_onSyncTrips);
  }

  Future<void> _onLoadTrips(LoadTrips event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Try to load from cache first
      final cachedTrips = await storageService.getTrips();
      if (cachedTrips.isNotEmpty) {
        emit(TripsLoaded(cachedTrips, isFromCache: true));
      }
      
      // Fetch fresh data from API
      final trips = await apiService.getTrips();
      await storageService.saveTrips(trips);
      emit(TripsLoaded(trips, isFromCache: false));
    } catch (e) {
      // If API fails, use cached data
      final cachedTrips = await storageService.getTrips();
      if (cachedTrips.isNotEmpty) {
        emit(TripsLoaded(cachedTrips, isFromCache: true));
      } else {
        emit(TripError('Failed to load trips: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadTripDetails(
      LoadTripDetails event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Try cache first
      final cachedTrip = await storageService.getTrip(event.tripId);
      if (cachedTrip != null) {
        emit(TripDetailsLoaded(cachedTrip));
      }
      
      // Fetch from API
      final trip = await apiService.getTripDetails(event.tripId);
      await storageService.saveTrip(trip);
      emit(TripDetailsLoaded(trip));
    } catch (e) {
      // Fallback to cache
      final cachedTrip = await storageService.getTrip(event.tripId);
      if (cachedTrip != null) {
        emit(TripDetailsLoaded(cachedTrip));
      } else {
        emit(TripError('Failed to load trip details: ${e.toString()}'));
      }
    }
  }

  Future<void> _onCreateTrip(CreateTrip event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      final trip = await apiService.createTrip(event.tripData);
      await storageService.saveTrip(trip);
      emit(TripOperationSuccess('Trip created successfully'));
    } catch (e) {
      // Store for offline sync
      await storageService.savePendingOperation({
        'type': 'create_trip',
        'data': event.tripData,
        'timestamp': DateTime.now().toIso8601String(),
      });
      emit(TripOperationSuccess('Trip saved offline. Will sync when online.'));
    }
  }

  Future<void> _onUpdateTrip(UpdateTrip event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      final trip = await apiService.updateTrip(event.tripId, event.tripData);
      await storageService.saveTrip(trip);
      emit(TripOperationSuccess('Trip updated successfully'));
    } catch (e) {
      // Store for offline sync
      await storageService.savePendingOperation({
        'type': 'update_trip',
        'tripId': event.tripId,
        'data': event.tripData,
        'timestamp': DateTime.now().toIso8601String(),
      });
      emit(TripOperationSuccess('Changes saved offline. Will sync when online.'));
    }
  }

  Future<void> _onDeleteTrip(DeleteTrip event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      await apiService.deleteTrip(event.tripId);
      await storageService.deleteTrip(event.tripId);
      emit(TripOperationSuccess('Trip deleted successfully'));
    } catch (e) {
      emit(TripError('Failed to delete trip: ${e.toString()}'));
    }
  }

  Future<void> _onSyncTrips(SyncTrips event, Emitter<TripState> emit) async {
    try {
      final pendingOps = await storageService.getPendingOperations();
      
      for (var op in pendingOps) {
        try {
          switch (op['type']) {
            case 'create_trip':
              await apiService.createTrip(op['data']);
              break;
            case 'update_trip':
              await apiService.updateTrip(op['tripId'], op['data']);
              break;
            // Add more operation types as needed
          }
          await storageService.removePendingOperation(op);
        } catch (e) {
          // Keep operation in queue for next sync
          continue;
        }
      }
      
      // Reload trips after sync
      add(LoadTrips());
    } catch (e) {
      // Sync will be retried on next connection
    }
  }
}