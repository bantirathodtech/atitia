#!/bin/bash
# Flutter Web Development Script
# Runs the app on localhost:8080 consistently
# 
# Usage:
#   ./run_web.sh          # Default port 8080
#   ./run_web.sh 5000     # Custom port

PORT=${1:-8080}

echo "🚀 Starting Flutter Web App on localhost:$PORT"
echo "================================================"
echo ""

# Kill any existing process on the port
echo "🔍 Checking if port $PORT is in use..."
if lsof -ti:$PORT > /dev/null 2>&1; then
  echo "⚠️  Port $PORT is already in use. Killing existing process..."
  lsof -ti:$PORT | xargs kill -9 2>/dev/null
  sleep 1
  echo "✅ Port $PORT is now free"
else
  echo "✅ Port $PORT is available"
fi

echo ""
echo "📱 Access your app at: http://localhost:$PORT"
echo ""
echo "🔥 Features Ready:"
echo "  ✅ Payment System (Bank/UPI/QR Code)"
echo "  ✅ Guest Management (Search/Filter/Bulk Actions)"
echo "  ✅ PG Analytics (Revenue/Occupancy/Maintenance)"
echo "  ✅ Profile Enhancements (Documents/KYC/Notifications)"
echo ""
echo "================================================"
echo ""

cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia

flutter run -d chrome \
  --web-port=$PORT \
  --web-hostname=localhost \
  --web-browser-flag="--disable-web-security" \
  --web-browser-flag="--disable-gpu" \
  --web-browser-flag="--no-sandbox"

