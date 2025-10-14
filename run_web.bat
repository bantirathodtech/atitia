@echo off
REM Flutter Web Development Script for Windows
REM Runs the app on localhost:8080 consistently

SET PORT=%1
IF "%PORT%"=="" SET PORT=8080

echo.
echo ================================================
echo 🚀 Starting Flutter Web App on localhost:%PORT%
echo ================================================
echo.
echo 📱 Access your app at: http://localhost:%PORT%
echo.
echo 🔥 Features Ready:
echo   ✅ Payment System (Bank/UPI/QR Code)
echo   ✅ Guest Management (Search/Filter/Bulk Actions)
echo   ✅ PG Analytics (Revenue/Occupancy/Maintenance)
echo   ✅ Profile Enhancements (Documents/KYC/Notifications)
echo.
echo ================================================
echo.

flutter run -d chrome --web-port=%PORT% --web-hostname=localhost

