# 👨‍💻 Developer Guide - CityPulse Backend

This guide contains comprehensive technical documentation for developers working on the CityPulse backend system.

## 📋 Table of Contents

- [Project Structure](#-project-structure)
- [Technology Stack](#-technology-stack)
- [Package Dependencies](#-package-dependencies)
- [Development Workflow](#-development-workflow)
- [Installation & Setup](#-installation--setup)
- [Environment Configuration](#-environment-configuration)
- [Database Setup](#-database-setup)
- [Development Commands](#-development-commands)
- [API Architecture](#-api-architecture)
- [Testing Strategy](#-testing-strategy)
- [Deployment Guide](#-deployment-guide)

---

## 🏗️ Project Structure

### **📁 Monorepo Architecture:**

```
citypulse-backend-skeleton/
├── 📦 package.json                    # Root workspace configuration
├── 🔧 docker-compose.yml             # Container orchestration
├── 🌍 .env.example                   # Environment template
├── 📋 DEVELOPER_GUIDE.md             # This file
│
├── 📂 services/                      # Microservices
│   ├── 🌐 api/                       # Main REST API service
│   │   ├── 📦 package.json
│   │   ├── prisma/
│   │   │   └── schema.prisma         # Database schema
│   │   └── src/
│   │       ├── server.js             # Express server entry point
│   │       ├── controllers/          # Business logic handlers
│   │       ├── middleware/           # Express middleware
│   │       ├── routes/               # API route definitions
│   │       └── lib/                  # Utilities (database, logger)
│   │
│   ├── ⚙️ worker/                     # Background job processor
│   │   ├── 📦 package.json
│   │   └── src/
│   │       ├── index.js              # Worker service entry
│   │       └── jobs/                 # Job processors
│   │
│   └── 🔐 auth/                      # Authentication microservice
│       ├── 📦 package.json
│       └── src/
│           └── index.js              # Auth service entry
│
└── 📂 packages/                      # Shared libraries
    └── 📦 common/                    # Cross-service utilities
        ├── 📦 package.json
        └── src/
            └── events.js             # Event definitions
```

---

## 💻 Technology Stack

### **Core Technologies:**
- **Runtime:** Node.js 18+ with JavaScript (ES6+)
- **Framework:** Express.js
- **Database:** MongoDB with Prisma ORM
- **Job Queue:** Bull + Redis
- **Authentication:** JWT with bcryptjs
- **Real-time:** Socket.io
- **Testing:** Jest + Supertest
- **Code Quality:** ESLint + Standard config

### **External Services:**
- **Cloud Database:** MongoDB Atlas
- **Caching/Queues:** Redis Cloud
- **File Storage:** AWS S3 / Google Cloud Storage
- **Email:** Nodemailer (SMTP/Gmail)
- **SMS:** Twilio
- **Maps:** Google Maps API
- **Error Tracking:** Sentry (optional)

---

## 📦 Package Dependencies

### **🌐 API Service Dependencies:**

```json
{
  "dependencies": {
    "express": "^4.18.2",              // Web framework
    "cors": "^2.8.5",                  // Cross-origin requests
    "helmet": "^7.1.0",                // Security headers
    "compression": "^1.7.4",           // Response compression
    "express-rate-limit": "^7.1.5",    // Rate limiting
    "express-validator": "^7.0.1",     // Input validation
    
    "@prisma/client": "^5.7.1",        // Database ORM client
    "prisma": "^5.7.1",                // Database toolkit
    "mongodb": "^6.3.0",               // MongoDB driver
    
    "bcryptjs": "^2.4.3",              // Password hashing
    "jsonwebtoken": "^9.0.2",          // JWT tokens
    "cookie-parser": "^1.4.6",         // Cookie parsing
    
    "socket.io": "^4.7.4",             // Real-time communication
    "bull": "^4.12.2",                 // Job queue
    "redis": "^4.6.11",                // Redis client
    
    "multer": "^1.4.5-lts.1",          // File uploads
    "sharp": "^0.33.1",                // Image processing
    "winston": "^3.11.0",              // Logging
    "winston-daily-rotate-file": "^4.7.1", // Log rotation
    
    "geolib": "^3.3.4",                // Geospatial calculations
    "nodemailer": "^6.9.7",            // Email sending
    "joi": "^17.11.0",                 // Schema validation
    "moment": "^2.29.4",               // Date manipulation
    "uuid": "^9.0.1",                  // UUID generation
    "axios": "^1.6.2",                 // HTTP client
    "dotenv": "^16.3.1"                // Environment variables
  }
}
```

### **⚙️ Worker Service Dependencies:**

```json
{
  "dependencies": {
    "bull": "^4.12.2",                 // Job processing
    "redis": "^4.6.11",                // Queue backend
    "natural": "^6.8.0",               // NLP for classification
    "compromise": "^14.10.2",          // Text processing
    "geolib": "^3.3.4",                // Location calculations
    "nodemailer": "^6.9.7",            // Email notifications
    "twilio": "^4.19.0",               // SMS notifications
    "sharp": "^0.33.1",                // Image processing
    "lodash": "^4.17.21",              // Utility functions
    "cron": "^3.1.6",                  // Scheduled jobs
    "winston": "^3.11.0",              // Logging
    "@prisma/client": "^5.7.1",        // Database access
    "@citypulse/common": "workspace:*"  // Shared utilities
  }
}
```

### **🔐 Auth Service Dependencies:**

```json
{
  "dependencies": {
    "express": "^4.18.2",              // Web framework
    "passport": "^0.7.0",              // Authentication middleware
    "passport-jwt": "^4.0.1",          // JWT strategy
    "passport-google-oauth20": "^2.0.0", // Google OAuth
    "passport-facebook": "^3.0.0",     // Facebook OAuth
    "speakeasy": "^2.0.0",             // 2FA TOTP
    "qrcode": "^1.5.3",                // QR code generation
    "bcryptjs": "^2.4.3",              // Password hashing
    "jsonwebtoken": "^9.0.2",          // JWT tokens
    "redis": "^4.6.11",                // Session storage
    "nodemailer": "^6.9.7",            // Email verification
    "twilio": "^4.19.0",               // SMS verification
    "@prisma/client": "^5.7.1",        // Database access
    "@citypulse/common": "workspace:*"  // Shared utilities
  }
}
```

---

## 🔄 Development Workflow

### **🚀 npm run dev Process:**

When you run `npm run dev` from the root directory:

```bash
# Root package.json script:
"dev": "concurrently \"npm run dev:api\" \"npm run dev:worker\" \"npm run dev:auth\""

# This executes simultaneously:
# Terminal 1: npm run dev:api    → cd services/api && nodemon src/server.js
# Terminal 2: npm run dev:worker → cd services/worker && nodemon src/index.js  
# Terminal 3: npm run dev:auth   → cd services/auth && nodemon src/index.js
```

### **📊 Terminal Output:**
```bash
$ npm run dev

[0] 🌐 API Server starting on port 3000...
[1] ⚙️ Worker service starting...
[2] 🔐 Auth service starting on port 3002...
[0] ✅ API Server: Connected to MongoDB
[1] ✅ Worker: Connected to Redis for job queues
[2] ✅ Auth: JWT authentication ready
[0] ✅ API Server: Listening on http://localhost:3000
[1] ✅ Worker: Background job processing started
[2] ✅ Auth: Listening on http://localhost:3002
```

---

## ⚙️ Installation & Setup

### **Prerequisites:**
- Node.js 18+ ([Download](https://nodejs.org/))
- npm 8+ (comes with Node.js)
- Git ([Download](https://git-scm.com/))
- MongoDB Atlas account ([Free Tier](https://www.mongodb.com/atlas))
- Redis instance ([Redis Cloud Free](https://redis.com/redis-enterprise-cloud/))

### **🔧 Step-by-Step Installation:**

1. **Clone Repository:**
```bash
git clone https://github.com/TJ456/City-plus-Backend.git
cd City-plus-Backend
```

2. **Install Root Dependencies:**
```bash
npm install
```

3. **Install Service Dependencies:**
```bash
# Install all workspace dependencies
npm run install:workspaces

# OR install individually:
cd services/api && npm install && cd ../..
cd services/worker && npm install && cd ../..
cd services/auth && npm install && cd ../..
cd packages/common && npm install && cd ../..
```

4. **Environment Setup:**
```bash
cp .env.example .env
# Edit .env with your configuration values
```

5. **Database Setup:**
```bash
# Generate Prisma client
npm run db:generate

# Push schema to database (development)
npm run db:push

# OR run migrations (production)
npm run db:migrate
```

6. **Start Development:**
```bash
npm run dev
```

---

## 🌍 Environment Configuration

### **📄 .env File Structure:**

```bash
# Database
DATABASE_URL="mongodb+srv://username:password@cluster.mongodb.net/citypulse"
DATABASE_NAME="citypulse"

# Authentication
JWT_SECRET="your-super-secure-jwt-secret-key"
JWT_EXPIRES_IN="24h"
JWT_REFRESH_SECRET="your-refresh-token-secret"
JWT_REFRESH_EXPIRES_IN="7d"
BCRYPT_SALT_ROUNDS=12

# Server Ports
API_PORT=3000
WORKER_PORT=3001
AUTH_PORT=3002

# Redis (Job Queues)
REDIS_URL="redis://localhost:6379"
REDIS_HOST="localhost"
REDIS_PORT=6379

# Email Service
EMAIL_SERVICE="gmail"
EMAIL_HOST="smtp.gmail.com"
EMAIL_PORT=587
EMAIL_USER="your-email@gmail.com"
EMAIL_PASSWORD="your-app-password"

# SMS Service (Twilio)
TWILIO_ACCOUNT_SID="your-twilio-sid"
TWILIO_AUTH_TOKEN="your-twilio-token"
TWILIO_PHONE_NUMBER="+1234567890"

# External APIs
GOOGLE_MAPS_API_KEY="your-google-maps-key"
WEATHER_API_KEY="your-weather-api-key"

# OAuth
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"
FACEBOOK_APP_ID="your-facebook-app-id"
FACEBOOK_APP_SECRET="your-facebook-app-secret"

# Application
NODE_ENV="development"
LOG_LEVEL="debug"
CORS_ORIGINS="http://localhost:3000,http://localhost:3001"

# Feature Flags
ENABLE_SMS_NOTIFICATIONS=true
ENABLE_EMAIL_NOTIFICATIONS=true
ENABLE_INCIDENT_AUTO_CLASSIFICATION=true
```

---

## 🗄️ Database Setup

### **📋 Prisma Schema Overview:**

```prisma
// services/api/prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "mongodb"
  url      = env("DATABASE_URL")
}

model User {
  id          String   @id @default(auto()) @map("_id") @db.ObjectId
  email       String   @unique
  password    String
  name        String
  role        UserRole
  phone       String?
  trustScore  Float    @default(50.0)
  isVerified  Boolean  @default(false)
  location    Json?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Relations
  incidents   Incident[]
  resources   Resource[]
  assignments Assignment[]
}

model Incident {
  id           String        @id @default(auto()) @map("_id") @db.ObjectId
  title        String
  description  String
  category     IncidentCategory
  severity     IncidentSeverity
  status       IncidentStatus @default(REPORTED)
  location     Json
  reporterId   String        @db.ObjectId
  verifiedBy   String?       @db.ObjectId
  images       String[]
  reportedAt   DateTime      @default(now())
  updatedAt    DateTime      @updatedAt
  resolvedAt   DateTime?
  
  // Relations
  reporter     User          @relation(fields: [reporterId], references: [id])
  assignments  Assignment[]
}

// ... more models
```

### **🔧 Database Commands:**

```bash
# Generate Prisma client after schema changes
npm run db:generate

# Push schema to database (development)
npm run db:push

# Create and run migrations (production)
npm run db:migrate

# Reset database (careful!)
npm run db:reset

# Open Prisma Studio (database GUI)
npm run db:studio

# Seed database with sample data
npm run db:seed
```

---

## 🧪 Testing Strategy

### **📋 Testing Framework:**

```javascript
// jest.config.json
{
  "testEnvironment": "node",
  "collectCoverageFrom": [
    "src/**/*.js",
    "!src/**/*.test.js"
  ],
  "testMatch": [
    "**/__tests__/**/*.js",
    "**/?(*.)+(spec|test).js"
  ],
  "setupFilesAfterEnv": ["<rootDir>/tests/setup.js"]
}
```

### **🧪 Test Commands:**

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch

# Run specific test file
npm test -- incidents.test.js

# Run tests for specific service
npm test --workspace=services/api
```

### **📝 Example Test Structure:**

```javascript
// services/api/src/controllers/__tests__/incidents.test.js
const request = require('supertest')
const app = require('../../server')
const { PrismaClient } = require('@prisma/client')

describe('Incidents API', () => {
  let prisma
  let authToken

  beforeAll(async () => {
    prisma = new PrismaClient()
    authToken = await getAuthToken()
  })

  afterAll(async () => {
    await prisma.$disconnect()
  })

  describe('POST /api/incidents', () => {
    it('should create a new incident', async () => {
      const incidentData = {
        title: 'Fire Emergency',
        description: 'Building fire on Main Street',
        category: 'FIRE',
        severity: 'HIGH',
        location: { lat: 40.7128, lng: -74.0060 }
      }

      const response = await request(app)
        .post('/api/incidents')
        .set('Authorization', `Bearer ${authToken}`)
        .send(incidentData)
        .expect(201)

      expect(response.body.incident).toHaveProperty('id')
      expect(response.body.incident.title).toBe(incidentData.title)
    })
  })
})
```

---

## 📚 API Architecture

### **🛣️ Project Development Workflow:**

Following the step-by-step implementation order from the original README:

#### **Phase 1: Foundation Layer**
1. **Common Events** → Event definitions for service communication
2. **Database Schema** → Data models and relationships  
3. **Database Connection** → Prisma client setup

#### **Phase 2: Core Infrastructure**  
4. **Logger** → Centralized logging system
5. **Error Handler** → Global error management
6. **Auth Middleware** → JWT validation and RBAC

#### **Phase 3: Authentication System**
7. **Auth Controller** → User registration and login
8. **Auth Service** → Dedicated auth microservice

#### **Phase 4: Core Business Logic**
9. **Incident Controller** → Incident CRUD and classification
10. **Resource Controller** → Resource management
11. **Assignment Controller** → Resource-incident matching

#### **Phase 5: API Routes**
12-15. **Route Modules** → REST API endpoint definitions

#### **Phase 6: Background Processing**
16-17. **Worker Services** → Async job processing

#### **Phase 7: Server Assembly**
18. **Main Server** → Express app orchestration

### **🎯 Each File Contains Step-by-Step Instructions:**

Every file includes detailed TODO comments like:

```javascript
// STEP 1: Import required dependencies
// TODO: Set up Express server infrastructure
// - Import Express framework for API server
// - Import CORS for cross-origin resource sharing
// - Import helmet for security headers

// STEP 2: Initialize Express application  
// TODO: Create and configure Express app instance
// - Create Express application instance
// - Set up environment configuration
// - Configure application settings (port, environment)

// ... and so on
```

---

## 🚀 Deployment Guide

### **🐳 Docker Deployment:**

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### **☁️ Cloud Deployment:**

```bash
# Build for production
npm run build

# Start production server
npm start

# OR using PM2 for process management
npm install -g pm2
pm2 start ecosystem.config.js
```

---

## 🔗 Additional Resources

- **[API Documentation](docs/API.md)** - Complete REST API reference
- **[Architecture Guide](docs/ARCHITECTURE.md)** - Detailed system design
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[Deployment Guide](docs/DEPLOYMENT.md)** - Production deployment
- **[Security Guide](docs/SECURITY.md)** - Security best practices

---

**📧 Need help? Reach out to the development team or create an issue on GitHub!**
