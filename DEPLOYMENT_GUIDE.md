# Deployment Guide - Smart Trip Planner

This guide covers deploying the Smart Trip Planner application to various cloud platforms.

## 🚀 Quick Deploy Options

### Option 1: Deploy to Render (Recommended - Free Tier Available)

#### 1. Backend Deployment

1. **Create Render Account**
   - Go to [render.com](https://render.com)
   - Sign up with GitHub

2. **Create PostgreSQL Database**
   - Click "New" → "PostgreSQL"
   - Name: `trip-planner-db`
   - Plan: Free
   - Copy the "Internal Database URL"

3. **Create Redis Instance**
   - Click "New" → "Redis"
   - Name: `trip-planner-redis`
   - Plan: Free
   - Copy the Redis URL

4. **Create Web Service**
   - Click "New" → "Web Service"
   - Connect your GitHub repository
   - Settings:
     - Name: `trip-planner-backend`
     - Root Directory: `backend`
     - Environment: Python 3
     - Build Command: 
       ```bash
       pip install -r requirements.txt && python manage.py collectstatic --noinput && python manage.py migrate
       ```
     - Start Command:
       ```bash
       daphne -b 0.0.0.0 -p $PORT trip_planner.asgi:application
       ```

5. **Configure Environment Variables**
   Add these in Render dashboard:
   ```
   SECRET_KEY=<generate-random-secret>
   DEBUG=False
   ALLOWED_HOSTS=.onrender.com
   CORS_ORIGINS=https://your-frontend-url.com
   
   DATABASE_URL=<paste-postgres-url>
   REDIS_URL=<paste-redis-url>
   
   EMAIL_HOST=smtp.gmail.com
   EMAIL_PORT=587
   EMAIL_HOST_USER=your-email@gmail.com
   EMAIL_HOST_PASSWORD=your-app-password
   DEFAULT_FROM_EMAIL=noreply@yourdomain.com
   
   FRONTEND_URL=https://your-frontend-url.com
   ```

6. **Deploy**
   - Click "Create Web Service"
   - Wait for deployment to complete
   - Your API will be live at `https://trip-planner-backend.onrender.com`

#### 2. Frontend Deployment (Flutter Web)

1. **Build Flutter Web**
   ```bash
   cd frontend
   flutter build web --release
   ```

2. **Deploy to Render Static Site**
   - Click "New" → "Static Site"
   - Connect repository
   - Settings:
     - Name: `trip-planner-frontend`
     - Build Command: `flutter build web --release`
     - Publish Directory: `frontend/build/web`

---

### Option 2: Deploy to DigitalOcean (Droplet)

#### 1. Create Droplet

```bash
# SSH into your droplet
ssh root@your-droplet-ip

# Update system
apt update && apt upgrade -y

# Install dependencies
apt install -y python3-pip python3-venv postgresql postgresql-contrib redis-server nginx git

# Create app user
useradd -m -s /bin/bash tripapp
```

#### 2. Setup PostgreSQL

```bash
sudo -u postgres psql

CREATE DATABASE trip_planner;
CREATE USER tripuser WITH PASSWORD 'secure-password';
ALTER ROLE tripuser SET client_encoding TO 'utf8';
ALTER ROLE tripuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE tripuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE trip_planner TO tripuser;
\q
```

#### 3. Clone and Setup Backend

```bash
su - tripapp
git clone https://github.com/yourusername/smart-trip-planner.git
cd smart-trip-planner/backend

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt gunicorn

# Create .env file
cp .env.example .env
nano .env  # Edit with your settings

# Run migrations
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
```

#### 4. Setup Systemd Service

Create `/etc/systemd/system/tripplanner.service`:

```ini
[Unit]
Description=Trip Planner Django App
After=network.target

[Service]
User=tripapp
Group=tripapp
WorkingDirectory=/home/tripapp/smart-trip-planner/backend
Environment="PATH=/home/tripapp/smart-trip-planner/backend/venv/bin"
ExecStart=/home/tripapp/smart-trip-planner/backend/venv/bin/daphne -b 0.0.0.0 -p 8000 trip_planner.asgi:application

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload
systemctl start tripplanner
systemctl enable tripplanner
```

#### 5. Configure Nginx

Create `/etc/nginx/sites-available/tripplanner`:

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /home/tripapp/smart-trip-planner/backend/staticfiles/;
    }

    location /media/ {
        alias /home/tripapp/smart-trip-planner/backend/media/;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/tripplanner /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

#### 6. Setup SSL with Let's Encrypt

```bash
apt install -y certbot python3-certbot-nginx
certbot --nginx -d yourdomain.com
```

---

### Option 3: Deploy with Docker (Any Cloud Provider)

#### 1. Build and Push Images

```bash
# Build backend image
cd backend
docker build -t yourdockerhub/trip-planner-backend:latest .
docker push yourdockerhub/trip-planner-backend:latest
```

#### 2. Use Docker Compose

On your server:

```bash
# Clone repository
git clone https://github.com/yourusername/smart-trip-planner.git
cd smart-trip-planner

# Create .env file
cp backend/.env.example backend/.env
nano backend/.env  # Edit settings

# Start services
docker-compose up -d

# Run migrations
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py createsuperuser
```

---

### Option 4: Deploy to AWS

#### Using AWS Elastic Beanstalk

1. **Install EB CLI**
   ```bash
   pip install awsebcli
   ```

2. **Initialize EB**
   ```bash
   cd backend
   eb init -p python-3.11 trip-planner-backend
   ```

3. **Create Environment**
   ```bash
   eb create trip-planner-env
   ```

4. **Configure Environment Variables**
   ```bash
   eb setenv SECRET_KEY=xxx DEBUG=False ALLOWED_HOSTS=.elasticbeanstalk.com
   ```

5. **Deploy**
   ```bash
   eb deploy
   ```

#### Using AWS App Runner

1. Push Docker image to ECR
2. Create App Runner service
3. Connect to ECR repository
4. Configure environment variables
5. Deploy

---

## 📱 Flutter App Distribution

### Android

1. **Build Release APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle for Play Store**
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Google Play Console**
   - Create app in Play Console
   - Upload AAB file
   - Fill in store listing
   - Submit for review

### iOS

1. **Build Release**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Product → Archive
   - Distribute App → App Store Connect

3. **Upload to App Store Connect**
   - Use Xcode or Application Loader
   - Submit for review

### Web

1. **Build**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase Hosting**
   ```bash
   firebase init hosting
   firebase deploy
   ```

---

## 🔧 Post-Deployment Checklist

- [ ] SSL certificate installed and working
- [ ] Database backups configured
- [ ] Environment variables secured
- [ ] CORS origins configured correctly
- [ ] Email sending working
- [ ] WebSocket connections working
- [ ] File uploads working (if applicable)
- [ ] Monitoring setup (e.g., Sentry)
- [ ] Log aggregation setup
- [ ] Database connection pooling configured
- [ ] Redis caching working
- [ ] API documentation accessible
- [ ] Admin panel accessible
- [ ] Test all critical user flows

---

## 📊 Monitoring & Maintenance

### Setup Logging

1. **Sentry for Error Tracking**
   ```bash
   pip install sentry-sdk
   ```

   Add to settings.py:
   ```python
   import sentry_sdk
   sentry_sdk.init(dsn="your-sentry-dsn")
   ```

2. **Database Backup**
   ```bash
   # Daily backup cron job
   0 2 * * * pg_dump trip_planner > /backups/trip_planner_$(date +\%Y\%m\%d).sql
   ```

3. **Health Checks**
   - Setup uptime monitoring (UptimeRobot, Pingdom)
   - Configure alerts for downtime

---

## 🐛 Troubleshooting

### Common Issues

1. **Static files not loading**
   ```bash
   python manage.py collectstatic --noinput
   ```

2. **Database connection errors**
   - Check DATABASE_URL format
   - Verify database is accessible
   - Check firewall rules

3. **WebSocket not connecting**
   - Ensure Daphne is running (not Gunicorn)
   - Check ALLOWED_HOSTS includes your domain
   - Verify Redis is accessible

4. **CORS errors**
   - Add frontend domain to CORS_ORIGINS
   - Check protocol (http vs https)

---

## 📞 Support

For deployment issues:
1. Check application logs
2. Review server logs
3. Test locally first
4. Open GitHub issue with error details

---

**Happy Deploying! 🚀**