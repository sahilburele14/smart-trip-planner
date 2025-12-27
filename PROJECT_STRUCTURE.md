# Complete Project Structure - Smart Trip Planner

## 📁 Full Directory Tree

```
smart-trip-planner/
│
├── README.md
├── DEPLOYMENT_GUIDE.md
├── PROJECT_STRUCTURE.md
├── setup.sh
├── docker-compose.yml
├── .gitignore
│
├── backend/
│   ├── trip_planner/
│   │   ├── __init__.py
│   │   ├── settings.py           # Django settings with all configurations
│   │   ├── urls.py                # Main URL routing
│   │   ├── asgi.py                # ASGI config for WebSocket support
│   │   └── wsgi.py                # WSGI config for deployment
│   │
│   ├── trips/
│   │   ├── __init__.py
│   │   ├── models.py              # Trip, Itinerary, Poll, Chat, Expense models
│   │   ├── serializers.py         # DRF serializers for all models
│   │   ├── views.py               # API viewsets and endpoints
│   │   ├── consumers.py           # WebSocket consumers for chat
│   │   ├── permissions.py         # Custom permission classes
│   │   ├── middleware.py          # Logging, rate limiting, error handling
│   │   ├── exceptions.py          # Custom exception handlers
│   │   ├── urls.py                # App-specific URLs
│   │   ├── admin.py               # Django admin configuration
│   │   ├── apps.py
│   │   ├── tests.py               # Unit tests
│   │   └── migrations/
│   │       └── __init__.py
│   │
│   ├── requirements.txt           # Python dependencies
│   ├── Dockerfile                 # Docker configuration
│   ├── .env.example               # Environment variables template
│   ├── .env                       # Your local environment (git-ignored)
│   ├── manage.py                  # Django management script
│   ├── .gitignore
│   ├── pytest.ini                 # Test configuration
│   └── logs/                      # Application logs (git-ignored)
│       └── app.log
│
├── frontend/
│   ├── lib/
│   │   ├── main.dart              # App entry point
│   │   │
│   │   ├── bloc/
│   │   │   ├── auth/
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   ├── trip/
│   │   │   │   ├── trip_bloc.dart
│   │   │   │   ├── trip_event.dart
│   │   │   │   └── trip_state.dart
│   │   │   ├── itinerary/
│   │   │   │   ├── itinerary_bloc.dart
│   │   │   │   ├── itinerary_event.dart
│   │   │   │   └── itinerary_state.dart
│   │   │   ├── poll/
│   │   │   │   ├── poll_bloc.dart
│   │   │   │   ├── poll_event.dart
│   │   │   │   └── poll_state.dart
│   │   │   └── chat/
│   │   │       ├── chat_bloc.dart
│   │   │       ├── chat_event.dart
│   │   │       └── chat_state.dart
│   │   │
│   │   ├── models/
│   │   │   ├── trip.dart          # All data models
│   │   │   ├── trip.g.dart        # Generated Hive adapters
│   │   │   └── user.dart
│   │   │
│   │   ├── services/
│   │   │   ├── api_service.dart   # REST API calls with Dio
│   │   │   ├── storage_service.dart  # Hive local storage
│   │   │   ├── websocket_service.dart  # WebSocket chat
│   │   │   └── connectivity_service.dart  # Network monitoring
│   │   │
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── home/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── trip_card.dart
│   │   │   │       └── skeleton_loader.dart
│   │   │   ├── trip/
│   │   │   │   ├── trip_details_screen.dart
│   │   │   │   ├── create_trip_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── itinerary_list.dart
│   │   │   │       ├── poll_widget.dart
│   │   │   │       └── collaborators_widget.dart
│   │   │   ├── itinerary/
│   │   │   │   ├── itinerary_screen.dart
│   │   │   │   ├── create_item_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── draggable_item.dart
│   │   │   └── chat/
│   │   │       ├── chat_screen.dart
│   │   │       └── widgets/
│   │   │           ├── message_bubble.dart
│   │   │           └── message_input.dart
│   │   │
│   │   ├── widgets/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_textfield.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── error_widget.dart
│   │   │
│   │   └── utils/
│   │       ├── constants.dart
│   │       ├── date_formatter.dart
│   │       └── validators.dart
│   │
│   ├── test/
│   │   ├── bloc/
│   │   │   ├── auth_bloc_test.dart
│   │   │   └── trip_bloc_test.dart
│   │   ├── services/
│   │   │   ├── api_service_test.dart
│   │   │   └── storage_service_test.dart
│   │   └── widgets/
│   │       └── trip_card_test.dart
│   │
│   ├── assets/
│   │   ├── images/
│   │   └── icons/
│   │
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   ├── build.yaml
│   └── README.md
│
├── .github/
│   └── workflows/
│       ├── backend.yml             # Backend CI/CD pipeline
│       └── flutter.yml             # Flutter CI/CD pipeline
│
├── nginx/
│   └── nginx.conf                  # Nginx configuration for production
│
└── docs/
    ├── API.md                      # API documentation
    ├── ARCHITECTURE.md             # System architecture
    └── TESTING.md                  # Testing guide
```

## 📋 File Descriptions

### Backend Files

| File | Purpose |
|------|---------|
| `settings.py` | Django configuration including database, JWT, channels, middleware |
| `models.py` | Database models: Trip, Collaborator, Itinerary, Poll, Chat, Expense |
| `serializers.py` | DRF serializers for API request/response |
| `views.py` | API viewsets with CRUD operations |
| `consumers.py` | WebSocket consumers for real-time chat |
| `middleware.py` | Request logging, rate limiting, error handling |
| `permissions.py` | Custom permission classes for trip access control |
| `urls.py` | URL routing and API endpoints |
| `Dockerfile` | Container configuration for deployment |

### Frontend Files

| File | Purpose |
|------|---------|
| `main.dart` | App initialization, theming, routing |
| `*_bloc.dart` | BLoC state management logic |
| `models/trip.dart` | Data models with Hive annotations |
| `api_service.dart` | REST API client with Dio, JWT handling |
| `storage_service.dart` | Local storage with Hive, offline sync |
| `websocket_service.dart` | Real-time WebSocket connection |
| `connectivity_service.dart` | Network status monitoring |
| `*_screen.dart` | UI screens for different features |
| `pubspec.yaml` | Flutter dependencies and assets |

### CI/CD Files

| File | Purpose |
|------|---------|
| `backend.yml` | GitHub Actions: lint, test, build, deploy backend |
| `flutter.yml` | GitHub Actions: analyze, test, build Android/iOS/Web |
| `docker-compose.yml` | Multi-container orchestration for deployment |
| `nginx.conf` | Reverse proxy and SSL configuration |

## 🔑 Key Features Implementation

### 1. Authentication
- **Backend**: JWT tokens via `rest_framework_simplejwt`
- **Frontend**: Token storage in Hive, automatic refresh

### 2. Real-time Chat
- **Backend**: Django Channels WebSocket consumer
- **Frontend**: `web_socket_channel` package

### 3. Offline Support
- **Strategy**: Offline-first with Hive
- **Sync**: Automatic when connectivity restored
- **Queue**: Pending operations stored locally

### 4. State Management
- **Pattern**: BLoC (Business Logic Component)
- **Libraries**: `flutter_bloc`, `equatable`

### 5. Drag-and-Drop
- **Implementation**: `ReorderableListView`
- **API**: POST to `/itinerary-items/reorder/`

### 6. Email Invitations
- **Method**: Synchronous in view
- **Library**: Django `send_mail`
- **Token**: Secure URL with expiry

## 🚀 Getting Started Checklist

- [ ] Clone repository
- [ ] Run `setup.sh` script
- [ ] Configure `.env` files
- [ ] Start PostgreSQL and Redis
- [ ] Run backend migrations
- [ ] Start backend server
- [ ] Configure Flutter API endpoint
- [ ] Run Flutter app
- [ ] Create test user
- [ ] Create test trip
- [ ] Test all features

## 📝 Development Workflow

1. **Feature Branch**
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Backend Changes**
   - Update models
   - Create migrations
   - Add serializers
   - Implement views
   - Write tests

3. **Frontend Changes**
   - Create BLoC
   - Add models
   - Build UI
   - Write tests

4. **Testing**
   ```bash
   # Backend
   python manage.py test
   
   # Frontend
   flutter test
   ```

5. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   git push origin feature/new-feature
   ```

6. **Create Pull Request**
   - CI/CD runs automatically
   - Review and merge

## 🔧 Environment Configuration

### Development
- Debug mode enabled
- SQLite optional
- Local Redis
- Mock email backend

### Staging
- Debug disabled
- PostgreSQL required
- Redis required
- Real email service

### Production
- All security enabled
- HTTPS enforced
- Database backups
- Monitoring active

## 📚 Additional Resources

- Django Docs: https://docs.djangoproject.com/
- DRF Docs: https://www.django-rest-framework.org/
- Flutter Docs: https://docs.flutter.dev/
- BLoC Pattern: https://bloclibrary.dev/

---

**Ready to build! 🚀**