#!/bin/bash

# 🚀 CityPulse Backend Installation Script
echo "🏙️  CityPulse Backend Installation Starting..."

# Check Node.js version
echo "📋 Checking Node.js version..."
node_version=$(node -v 2>/dev/null | cut -d'v' -f2 | cut -d'.' -f1)
if [ -z "$node_version" ] || [ "$node_version" -lt 18 ]; then
    echo "❌ Node.js 18+ is required. Please install Node.js 18 or higher."
    exit 1
fi
echo "✅ Node.js $(node -v) detected"

# Check if npm is available
echo "📋 Checking npm..."
if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not installed."
    exit 1
fi
echo "✅ npm $(npm -v) detected"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Install workspace dependencies
echo "📦 Installing workspace dependencies..."
npm run install:workspaces

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "📄 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your actual configuration values"
else
    echo "📄 .env file already exists"
fi

# Check if MongoDB is running (optional)
echo "📋 Checking services..."
if command -v mongod &> /dev/null; then
    echo "✅ MongoDB detected"
else
    echo "⚠️  MongoDB not detected. You'll need MongoDB running for the application."
fi

if command -v redis-server &> /dev/null; then
    echo "✅ Redis detected"
else
    echo "⚠️  Redis not detected. You'll need Redis running for job queues."
fi

echo ""
echo "🎉 Installation completed!"
echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your configuration"
echo "2. Start MongoDB and Redis services"
echo "3. Run 'npm run db:generate' to generate Prisma client"
echo "4. Run 'npm run db:push' to set up database schema"
echo "5. Run 'npm run dev' to start development servers"
echo ""
echo "🔗 Useful commands:"
echo "  npm run dev          - Start all services in development"
echo "  npm run dev:api      - Start only API service"
echo "  npm run dev:worker   - Start only worker service"
echo "  npm run dev:auth     - Start only auth service"
echo "  npm test             - Run tests"
echo "  npm run lint         - Check code quality"
echo ""
