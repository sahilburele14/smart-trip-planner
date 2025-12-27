#!/bin/bash

echo "🚀 Smart Trip Planner - Setup Script"

# Backend Setup
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cp .env.example .env
python manage.py migrate
python manage.py createsuperuser

cd ..

# Frontend Setup
cd frontend
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

echo "✅ Setup Complete!"
echo ""
echo "Start backend: cd backend && python manage.py runserver"
echo "Start frontend: cd frontend && flutter run"