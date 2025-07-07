#!/bin/bash
# Development script to start all services locally

echo "🚀 Starting Codebase Tutor development environment..."

# Start backend API
echo "📦 Starting Python backend..."
cd src && python -m app.main &
BACKEND_PID=$!

# Start React web app
echo "🌐 Starting React web app..."
cd web && npm run dev &
WEB_PID=$!

echo "✅ Services started:"
echo "  - Backend API: http://localhost:8080"
echo "  - Web App: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for Ctrl+C and then kill all processes
trap "echo 'Stopping services...'; kill $BACKEND_PID $WEB_PID; exit" INT
wait
