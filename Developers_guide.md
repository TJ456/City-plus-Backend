# CityPulse — Real-time Community Incident Reporting & Resource Routing

## Overview
CityPulse is a backend platform for real-time community incident reporting and intelligent resource routing.
Citizens can submit reports about incidents (e.g., fire, accident, flood). Volunteers, NGOs, and agencies can register resources (e.g., ambulances, fire trucks, relief packages).

The system will:
- Classify incidents by category and severity.
- Compute trust scores for reporters.
- Deduplicate reports for the same incident.
- Route the best-matching resources in real time.
- Keep audit logs for transparency.

## Vision
To create a scalable, hackathon-worthy solution that has real-world impact by bridging citizens and responders through technology.

## 🚀 PROJECT DEVELOPMENT WORKFLOW 

### Phase 1: Foundation Layer (Start Here)
**Order of Implementation & Why:**

1. **Common Events (`packages/common/src/events.ts`)** 
   - **Why First:** Defines the communication contract between all services
   - **Purpose:** Establishes event-driven architecture foundation
   - **Connection:** Used by API service to emit events and Worker service to consume them

2. **Database Schema (`services/api/prisma/schema.prisma`)**
   - **Why Second:** Data models must be defined before any CRUD operations
   - **Purpose:** Defines all entities (User, Incident, Resource, Assignment) and relationships
   - **Connection:** Required by database.ts and all controllers for data operations

3. **Database Connection (`services/api/src/lib/database.ts`)**
   - **Why Third:** Enables database connectivity for the application
   - **Purpose:** Establishes Prisma client connection to MongoDB
   - **Connection:** Used by all controllers and middleware for database operations

### Phase 2: Core Infrastructure
4. **Logger (`services/api/src/lib/logger.ts`)**
   - **Why Fourth:** Logging is essential for debugging and monitoring
   - **Purpose:** Centralized logging for error tracking and audit trails
   - **Connection:** Used by all controllers, middleware, and services

5. **Error Handler Middleware (`services/api/src/middleware/errorHandler.ts`)**
   - **Why Fifth:** Global error handling prevents application crashes
   - **Purpose:** Catches and formats all errors consistently
   - **Connection:** Used by server.ts and all route handlers

6. **Authentication Middleware (`services/api/src/middleware/auth.ts`)**
   - **Why Sixth:** Security layer must be established before protected routes
   - **Purpose:** JWT validation and role-based access control
   - **Connection:** Used by protected routes in all route files

### Phase 3: Authentication System
7. **Auth Controller (`services/api/src/controllers/authController.ts`)**
   - **Why Seventh:** User management is prerequisite for all other features
   - **Purpose:** Handles user registration, login, and token management
   - **Connection:** Creates users that report incidents and register resources

8. **Auth Service (`services/auth/src/index.ts`)**
   - **Why Eighth:** Dedicated authentication microservice
   - **Purpose:** Handles complex auth logic and token validation
   - **Connection:** Called by auth middleware and auth controller

### Phase 4: Core Business Logic
9. **Incident Controller (`services/api/src/controllers/incidentController.ts`)**
   - **Why Ninth:** Core feature - incident reporting functionality
   - **Purpose:** Handles incident CRUD operations and classification
   - **Connection:** Creates incidents that trigger events for worker processing

10. **Resource Controller (`services/api/src/controllers/resourceController.ts`)**
    - **Why Tenth:** Resources are needed to respond to incidents
    - **Purpose:** Manages resource registration and availability
    - **Connection:** Resources are matched to incidents via assignment system

11. **Assignment Controller (`services/api/src/controllers/assignmentController.ts`)**
    - **Why Eleventh:** Links incidents with appropriate resources
    - **Purpose:** Manages incident-resource assignments and routing logic
    - **Connection:** Bridges incidents and resources, triggers notifications

### Phase 5: API Routes
12. **Incidents Routes (`services/api/src/routes/incidents.ts`)**
    - **Why Twelfth:** Exposes incident functionality via REST API
    - **Purpose:** Defines endpoints for incident operations
    - **Connection:** Uses incident controller and auth middleware

13. **Resources Routes (`services/api/src/routes/resources.ts`)**
    - **Why Thirteenth:** Exposes resource functionality via REST API
    - **Purpose:** Defines endpoints for resource operations
    - **Connection:** Uses resource controller and auth middleware

14. **Assignments Routes (`services/api/src/routes/assignments.ts`)**
    - **Why Fourteenth:** Exposes assignment functionality via REST API
    - **Purpose:** Defines endpoints for assignment operations
    - **Connection:** Uses assignment controller and auth middleware

15. **Main Routes Index (`services/api/src/routes/index.ts`)**
    - **Why Fifteenth:** Centralizes all route definitions
    - **Purpose:** Aggregates all route modules for server registration
    - **Connection:** Used by server.ts to register all API endpoints

### Phase 6: Background Processing
16. **Process Incident Job (`services/worker/src/jobs/processIncident.ts`)**
    - **Why Sixteenth:** Handles complex incident processing asynchronously
    - **Purpose:** Deduplication, classification, and resource matching
    - **Connection:** Listens to events from incident controller

17. **Worker Service (`services/worker/src/index.ts`)**
    - **Why Seventeenth:** Orchestrates all background job processing
    - **Purpose:** Event listener and job queue management
    - **Connection:** Processes events emitted by API service

### Phase 7: Server Assembly
18. **Main Server (`services/api/src/server.ts`)**
    - **Why Last:** Assembles all components into working application
    - **Purpose:** Express server setup with middleware and routes
    - **Connection:** Entry point that ties together all previous components

### 🔄 Data Flow Architecture:
```
Citizen Reports Incident → API Controller → Database → Event Emitted → 
Worker Processes → Resource Matching → Assignment Created → Notification Sent
```

### 🧩 Service Interdependencies:
- **API Service:** Depends on common events, database, auth service
- **Worker Service:** Depends on common events, database access
- **Auth Service:** Standalone service with minimal dependencies
- **Common Package:** Shared by all services for type safety

## Tech Stack
- **Runtime:** Node.js 18+ with JavaScript (ES6+)
- **Framework:** Express.js
- **Database:** MongoDB with Prisma ORM
- **Job Queue:** Bull + Redis
- **Authentication:** JWT with bcryptjs
- **Real-time:** Socket.io
- **Testing:** Jest + Supertest
- **Code Quality:** ESLint + Standard config

## 📦 Package Dependencies

### Core Dependencies by Service:

**🚀 API Service:**
- `express`, `cors`, `helmet`, `compression` - Web server & security
- `@prisma/client`, `mongodb` - Database connectivity
- `bcryptjs`, `jsonwebtoken` - Authentication & security
- `winston`, `winston-daily-rotate-file` - Logging
- `bull`, `redis` - Job queue management
- `socket.io` - Real-time communication
- `multer`, `sharp` - File upload & image processing
- `geolib` - Geospatial calculations
- `nodemailer` - Email notifications

**🔧 Worker Service:**
- `bull`, `redis` - Background job processing
- `natural`, `compromise` - NLP for incident classification
- `geolib` - Location-based matching
- `nodemailer`, `twilio` - Notifications
- `cron` - Scheduled jobs

**🔐 Auth Service:**
- `express`, `passport` - Authentication server
- `passport-google-oauth20`, `passport-facebook` - OAuth providers
- `speakeasy`, `qrcode` - Two-factor authentication
- `bcryptjs`, `jsonwebtoken` - Password & token management

**📦 Common Package:**
- Shared utilities, event definitions, and types

## Setup Instructions

### 1. Install Dependencies
```bash
# Install all packages for all services
npm run install:all

# OR install individually
npm install                    # Root dependencies
npm install --workspace=services/api
npm install --workspace=services/worker
npm install --workspace=services/auth
npm install --workspace=packages/common
```

### 2. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your actual values:
# - DATABASE_URL (MongoDB connection string)
# - JWT_SECRET (secure random string)
# - REDIS_URL (Redis connection for job queues)
# - Email/SMS service credentials
```

### 3. Database Setup
```bash
# Generate Prisma client
npm run db:generate

# Push schema to database (for development)
npm run db:push

# OR run migrations (for production)
npm run db:migrate
```

### 4. Development
```bash
# Start all services in development mode
npm run dev

# OR start services individually
npm run dev:api      # API service on port 3000
npm run dev:worker   # Worker service (background jobs)
npm run dev:auth     # Auth service on port 3002
```

### 5. Production
```bash
# Start all services in production mode
npm start

# OR using Docker
docker-compose up -d
```

### 6. Testing
```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch
```
- Secure JWT implementation.
- Centralized error handling.

## Implementation Plan
1. Define Prisma schema.
2. Build authentication module.
3. Implement Incident & Resource controllers.
4. Add Worker jobs for async processing.
5. Connect real-time events (optional with Socket.io or Kafka).

