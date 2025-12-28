# 🚀 Smart Trip Planner

> A production-ready full-stack trip planning application with Django REST API backend and Flutter mobile frontend, featuring real-time chat, offline support, and collaborative planning.

![Python](https://img.shields.io/badge/Python-3.11-blue)
![Django](https://img.shields.io/badge/Django-4.2-green)
![Flutter](https://img.shields.io/badge/Flutter-3.16-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success)

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Live Demo](#-live-demo)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [API Documentation](#-api-documentation)
- [Deployment](#-deployment)
- [Testing](#-testing)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 🔐 **Authentication & Authorization**
- JWT-based secure authentication
- User registration and login
- Token refresh mechanism
- Role-based access control (Owner, Editor, Viewer)

### 🗺️ **Trip Management**
- Create, update, and delete trips
- Share trips with collaborators
- Email invitation system
- Trip dashboard with filters

### 📝 **Itinerary Planning**
- Add activities, accommodations, transport, and food
- Drag-and-drop reordering
- Time-based scheduling
- Category filtering
- Cost tracking per item

### 🗳️ **Collaborative Polls**
- Create polls for group decisions
- Single or multiple choice voting
- Real-time vote counts
- Poll expiration options

### 💬 **Real-time Chat**
- WebSocket-powered group chat
- Message history
- Online/offline status
- Typing indicators

### 📧 **Email Invitations**
- Invite collaborators via email
- Secure invitation tokens
- Token expiration (7 days)
- Accept/decline invitations

### 💰 **Expense Management** (Bonus)
- Track trip expenses
- Split costs among travelers
- Settlement tracking
- Expense categories

### 📴 **Offline Support**
- Offline-first architecture
- Local data caching with Hive
- Automatic synchronization
- Queue pending operations

### 🎨 **Modern UI/UX**
- Material Design 3
- Smooth animations
- Skeleton loaders
- Optimistic updates
- Responsive design

### 🔧 **DevOps & CI/CD**
- Automated testing
- GitHub Actions pipelines
- Docker containerization
- Environment-based configs

---

## 🛠️ Tech Stack

### **Backend**
- **Framework:** Django 4.2
- **API:** Django REST Framework 3.14
- **Authentication:** djangorestframework-simplejwt
- **Real-time:** Django Channels + Redis
- **Database:** PostgreSQL 15
- **Cache:** Redis 7
- **API Docs:** drf-yasg (Swagger/OpenAPI)
- **Server:** Daphne ASGI Server

### **Frontend**
- **Framework:** Flutter 3.16
- **Language:** Dart
- **State Management:** BLoC Pattern (flutter_bloc)
- **HTTP Client:** Dio
- **Local Storage:** Hive + SharedPreferences
- **WebSocket:** web_socket_channel
- **UI:** Material Design 3, Google Fonts

### **DevOps**
- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions
- **Web Server:** Nginx
- **SSL:** Let's Encrypt
- **Cloud Platforms:** Render, Railway, Heroku, AWS, DigitalOcean

---

## 🌐 Live Demo

### **Backend API**
🔗 **Base URL:** `https://trip-planner-backend.onrender.com`

📚 **API Documentation (Swagger):** `https://trip-planner-backend.onrender.com/swagger/`

🔐 **Admin Panel:** `https://trip-planner-backend.onrender.com/admin/`

### **Test Credentials**
```
Username: demo_user
Password: demo_pass_123
```

### **Demo Endpoints**
```bash
# Get authentication token
POST /api/auth/login/

# List all trips
GET /api/trips/

# Get trip details
GET /api/trips/{id}/

# Create new trip
POST /api/trips/
```

---

## ⚡ Quick Start

### **Option 1: Automated Setup (Recommended)**

```bash
# Clone repository
git clone https://github.com/yourusername/smart-trip-planner.git
cd smart-trip-planner

# Run automated setup script
chmod +x setup.sh
./setup.sh

# Script will:
# ✅ Create virtual environment
# ✅ Install dependencies
# ✅ Setup database
# ✅ Run migrations
# ✅ Create superuser
```

### **Option 2: Docker (Fastest)**

```bash
# Clone repository
git clone https://github.com/yourusername/smart-trip-planner.git
cd smart-trip-planner

# Start all services
docker-compose up -d

# Run migrations
docker-compose exec backend python manage.py migrate

# Create superuser
docker-compose exec backend python manage.py createsuperuser

# Access at http://localhost:8000
```

---

## 📦 Installation

### **Prerequisites**

- Python 3.11+
- PostgreSQL 15+
- Redis 7+
- Flutter 3.16+
- Node.js 18+ (for some tools)
- Git

### **Backend Setup**

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/smart-trip-planner.git
cd smart-trip-planner/backend
```

2. **Create virtual environment**
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Setup PostgreSQL database**
```bash
# Login to PostgreSQL
sudo -u postgres psql

# Create database and user
CREATE DATABASE trip_planner;
CREATE USER tripuser WITH PASSWORD 'your_password';
ALTER ROLE tripuser SET client_encoding TO 'utf8';
ALTER ROLE tripuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE tripuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE trip_planner TO tripuser;
\q
```

5. **Configure environment**
```bash
cp .env.example .env
nano .env  # Edit with your settings
```

6. **Run migrations**
```bash
python manage.py migrate
```

7. **Create superuser**
```bash
python manage.py createsuperuser
```

8. **Collect static files**
```bash
python manage.py collectstatic --noinput
```

### **Frontend Setup**

1. **Navigate to frontend**
```bash
cd ../frontend
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Configure API endpoint**

Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
// For production: 'https://your-api-url.com/api'
```

---

## ⚙️ Configuration

### **Backend Environment Variables**

Create `backend/.env` file:

```bash
# Django Settings
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# CORS Settings
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# Database
DB_NAME=trip_planner
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432

# Redis
REDIS_URL=redis://localhost:6379/0

# Email Configuration
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-specific-password
DEFAULT_FROM_EMAIL=noreply@tripplanner.com

# Frontend URL
FRONTEND_URL=http://localhost:3000

# Security
RATE_LIMIT_PER_MINUTE=100
```

### **Frontend Configuration**

1. **API Endpoint:** Update in `lib/services/api_service.dart`
2. **App Name:** Update in `pubspec.yaml`
3. **Assets:** Add images/icons to `assets/` folder

---

## 🚀 Running the Application

### **Development Mode**

#### **Backend**

```bash
# Terminal 1 - Django Backend
cd backend
source venv/bin/activate
python manage.py runserver

# Access at: http://localhost:8000
# Admin: http://localhost:8000/admin/
# API Docs: http://localhost:8000/swagger/
```

#### **Frontend**

```bash
# Terminal 2 - Flutter App
cd frontend
flutter run

# Or for web:
flutter run -d chrome

# Or for specific device:
flutter devices
flutter run -d <device_id>
```

### **Production Mode**

#### **Using Docker Compose**

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

#### **Using Gunicorn/Daphne**

```bash
# Start backend with Daphne (for WebSocket support)
cd backend
daphne -b 0.0.0.0 -p 8000 trip_planner.asgi:application

# Or with Gunicorn (HTTP only, no WebSocket)
gunicorn trip_planner.wsgi:application --bind 0.0.0.0:8000
```

---

## 📚 API Documentation

### **Interactive Documentation**

Once the backend is running, visit:

- **Swagger UI:** http://localhost:8000/swagger/
- **ReDoc:** http://localhost:8000/redoc/
- **JSON Schema:** http://localhost:8000/swagger.json

### **Key Endpoints**

#### **Authentication**
```
POST   /api/auth/register/           # User registration
POST   /api/auth/login/              # User login
GET    /api/auth/profile/            # Get user profile
POST   /api/token/refresh/           # Refresh JWT token
```

#### **Trips**
```
GET    /api/trips/                   # List all trips
POST   /api/trips/                   # Create new trip
GET    /api/trips/{id}/              # Get trip details
PUT    /api/trips/{id}/              # Update trip
DELETE /api/trips/{id}/              # Delete trip
POST   /api/trips/{id}/invite/       # Invite collaborator
POST   /api/trips/accept_invitation/ # Accept invitation
```

#### **Itinerary**
```
GET    /api/itinerary-items/         # List items
POST   /api/itinerary-items/         # Create item
GET    /api/itinerary-items/{id}/    # Get item
PUT    /api/itinerary-items/{id}/    # Update item
DELETE /api/itinerary-items/{id}/    # Delete item
POST   /api/itinerary-items/reorder/ # Reorder items
```

#### **Polls**
```
GET    /api/polls/                   # List polls
POST   /api/polls/                   # Create poll
GET    /api/polls/{id}/              # Get poll
POST   /api/polls/{id}/vote/         # Vote on poll
POST   /api/polls/{id}/add_option/   # Add option
```

#### **Chat**
```
GET    /api/chat-messages/?trip_id={id}  # Get messages
POST   /api/chat-messages/                # Send message
WS     ws://api/ws/chat/{trip_id}/        # WebSocket
```

#### **Expenses**
```
GET    /api/expenses/                # List expenses
POST   /api/expenses/                # Create expense
POST   /api/expenses/{id}/settle/    # Settle expense
```

### **Example API Calls**

```bash
# Login
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username": "demo", "password": "demo123"}'

# Create Trip (with token)
curl -X POST http://localhost:8000/api/trips/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "title": "Summer Vacation",
    "description": "Beach trip",
    "destination": "Bali",
    "start_date": "2024-07-15",
    "end_date": "2024-07-25"
  }'
```

---

## 🌍 Deployment

### **Deploy to Render (Free)**

#### **1. Backend Deployment**

```bash
# Push code to GitHub
git push origin main

# In Render Dashboard:
# 1. Create PostgreSQL database
# 2. Create Redis instance
# 3. Create Web Service
#    - Connect GitHub repo
#    - Root Directory: backend
#    - Build Command: pip install -r requirements.txt && python manage.py migrate
#    - Start Command: daphne -b 0.0.0.0 -p $PORT trip_planner.asgi:application
# 4. Add environment variables
# 5. Deploy
```

#### **2. Frontend Deployment (Firebase)**

```bash
# Build Flutter web
cd frontend
flutter build web --release

# Deploy to Firebase
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

### **Deploy to Railway**

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Deploy
railway up
```

### **Deploy to Heroku**

```bash
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh

# Login
heroku login

# Create app
heroku create trip-planner-backend

# Add PostgreSQL and Redis
heroku addons:create heroku-postgresql:mini
heroku addons:create heroku-redis:mini

# Deploy
git push heroku main

# Run migrations
heroku run python manage.py migrate
```

### **Deploy with Docker**

```bash
# Build image
docker build -t trip-planner-backend ./backend

# Run container
docker run -d -p 8000:8000 \
  -e DATABASE_URL=postgresql://... \
  -e REDIS_URL=redis://... \
  trip-planner-backend
```

**See [DEPLOYMENT_GUIDE.md]https://github.com/sahilburele14/smart-trip-planner/blob/main/DEPLOYMENT_GUIDE.md**

---

## 🧪 Testing

### **Backend Tests**

```bash
cd backend

# Run all tests
python manage.py test

# Run specific app tests
python manage.py test trips

# Run with coverage
pip install coverage
coverage run manage.py test
coverage report
coverage html  # Generate HTML report
```

### **Frontend Tests**

```bash
cd frontend

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### **Integration Tests**

```bash
# Run end-to-end tests
cd frontend
flutter test integration_test/
```

---

## 📁 Project Structure

```
smart-trip-planner/
├── backend/                      # Django Backend
│   ├── trip_planner/            # Main Django project
│   │   ├── settings.py          # Django settings
│   │   ├── urls.py              # URL routing
│   │   ├── asgi.py              # ASGI config for WebSocket
│   │   └── wsgi.py              # WSGI config
│   ├── trips/                   # Main app
│   │   ├── models.py            # Database models
│   │   ├── serializers.py       # DRF serializers
│   │   ├── views.py             # API views
│   │   ├── consumers.py         # WebSocket consumers
│   │   ├── middleware.py        # Custom middleware
│   │   └── permissions.py       # Permission classes
│   ├── requirements.txt         # Python dependencies
│   ├── Dockerfile               # Docker configuration
│   └── manage.py                # Django CLI
│
├── frontend/                     # Flutter Frontend
│   ├── lib/
│   │   ├── main.dart            # App entry point
│   │   ├── bloc/                # BLoC state management
│   │   │   ├── auth/           # Auth BLoC
│   │   │   ├── trip/           # Trip BLoC
│   │   │   └── chat/           # Chat BLoC
│   │   ├── models/              # Data models
│   │   ├── services/            # API & Storage services
│   │   ├── screens/             # UI screens
│   │   └── widgets/             # Reusable widgets
│   ├── test/                    # Unit tests
│   ├── pubspec.yaml             # Flutter dependencies
│   └── analysis_options.yaml   # Linter config
│
├── .github/
│   └── workflows/               # CI/CD pipelines
│       ├── backend.yml          # Backend pipeline
│       └── flutter.yml          # Flutter pipeline
│
├── nginx/
│   └── nginx.conf               # Nginx configuration
│
├── docker-compose.yml           # Docker orchestration
├── setup.sh                     # Automated setup script
├── README.md                    # This file
├── DEPLOYMENT_GUIDE.md          # Deployment instructions
└── LICENSE                      # MIT License
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### **Code Style**

- **Backend:** Follow PEP 8 guidelines
- **Frontend:** Follow Dart style guide
- Run linters before committing:
  ```bash
  # Backend
  flake8 .
  black .
  
  # Frontend
  flutter analyze
  dart format .
  ```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Django and Flutter communities
- All open-source contributors
- RemoteWard for the assignment opportunity

---

## 📞 Support

For issues, questions, or contributions:

- **GitHub Issues:** https://github.com/sahilburele14/smart-trip-planner
- **Email:** sahilburele6789@gmail.com

---

## 📊 Project Status

- ✅ **Backend:** Production Ready
- ✅ **Frontend:** Production Ready
- ✅ **CI/CD:** Configured
- ✅ **Documentation:** Complete
- ✅ **Tests:** Implemented
- ✅ **Deployment:** Ready

---

## 🎯 Roadmap

- [ ] Push notifications
- [ ] Map integration
- [ ] Weather forecasts
- [ ] Currency conversion
- [ ] Photo sharing
- [ ] Trip templates
- [ ] Calendar sync
- [ ] Social media sharing

---

**Built with ❤️ for RemoteWard Assignment**

**⭐ If you find this project useful, please give it a star!**

---

## 📸 Screenshots
<img width="936" height="878" alt="image" src="https://github.com/user-attachments/assets/6697bb5b-f377-4b5d-acb5-627dfad8f46d" />
<img width="928" height="870" alt="image" src="https://github.com/user-attachments/assets/b78772ec-58e7-4b66-9f51-627e273e4fdf" />
<img width="931" height="878" alt="image" src="https://github.com/user-attachments/assets/b711a298-a3c2-4ff8-8e99-aa40af263499" />
<img width="902" height="845" alt="image" src="https://github.com/user-attachments/assets/2cdf8650-c918-461e-a550-bf9199b2b579" />
<img width="901" height="864" alt="image" src="https://github.com/user-attachments/assets/5b343959-51fe-4724-ae91-7e1f9a2842f0" />


---

**Happy Trip Planning! ✈️🗺️**v
