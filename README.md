# Smart Trip Planner

Production-ready trip planning application with Django & Flutter.

## Features

✅ JWT Authentication
✅ Trip Management with Collaborators
✅ Drag-and-Drop Itinerary
✅ Real-time WebSocket Chat
✅ Polls & Voting
✅ Email Invitations
✅ Expense Splitting
✅ Offline-First Support
✅ CI/CD Pipelines
✅ Docker Deployment

## Quick Start

\`\`\`bash
# Clone repository
git clone https://github.com/sahilburele14/smart-trip-planner
cd smart-trip-planner

# Run setup
chmod +x setup.sh
./setup.sh

# Start backend
cd backend
source venv/bin/activate
python manage.py runserver

# Start frontend
cd frontend
flutter run
\`\`\`

## Tech Stack

- **Backend**: Django 4.2, DRF, PostgreSQL, Redis
- **Frontend**: Flutter 3.16, BLoC, Hive
- **DevOps**: Docker, GitHub Actions, Nginx

## API Documentation

Visit `http://localhost:8000/swagger/` after starting the backend.

## License

MIT License