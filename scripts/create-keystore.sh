#!/bin/bash

# 🔐 Keystore Creation Helper Script
# This script helps create a new Android keystore for the Atitia app

set -e

echo "🔐 Atitia Keystore Creation Helper"
echo "=================================="
echo ""

# Check if keystore already exists
if [ -f "android/keystore.jks" ]; then
    echo "⚠️  WARNING: keystore.jks already exists!"
    echo ""
    read -p "Do you want to backup the old keystore and create a new one? (y/n): " backup_choice
    if [ "$backup_choice" = "y" ] || [ "$backup_choice" = "Y" ]; then
        BACKUP_FILE="android/keystore.jks.backup.$(date +%Y%m%d_%H%M%S)"
        cp android/keystore.jks "$BACKUP_FILE"
        echo "✅ Old keystore backed up to: $BACKUP_FILE"
        # Remove old keystore so keytool can create a new one
        rm android/keystore.jks
        echo "✅ Old keystore removed (backup saved)"
        echo ""
    else
        echo "❌ Cancelled. Exiting."
        exit 1
    fi
fi

# Navigate to android directory
cd android

echo "📝 Creating new keystore..."
echo ""
echo "You'll be prompted for:"
echo "  1. Keystore password (save this securely!)"
echo "  2. Your name/company information"
echo "  3. Location information"
echo ""

# Create keystore
keytool -genkey -v \
    -keystore keystore.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias atitia-release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Keystore created successfully!"
    echo ""
    
    # Ask if user wants to update key.properties
    read -p "Do you want to update key.properties with the password? (y/n): " update_choice
    if [ "$update_choice" = "y" ] || [ "$update_choice" = "Y" ]; then
        echo ""
        read -sp "Enter keystore password: " KEYSTORE_PASSWORD
        echo ""
        read -sp "Enter key password (or press Enter to use same): " KEY_PASSWORD
        echo ""
        
        # Use keystore password if key password is empty
        if [ -z "$KEY_PASSWORD" ]; then
            KEY_PASSWORD="$KEYSTORE_PASSWORD"
        fi
        
        # Create key.properties
        cat > key.properties << EOF
# Android Production Signing Configuration
# DO NOT COMMIT THIS FILE TO GIT
# Generated on $(date)

storeFile=keystore.jks
storePassword=$KEYSTORE_PASSWORD
keyAlias=atitia-release
keyPassword=$KEY_PASSWORD
EOF
        
        echo "✅ key.properties updated!"
        echo ""
        echo "📋 Next steps:"
        echo "  1. Test build: flutter build apk --release"
        echo "  2. Verify keystore: keytool -list -v -keystore android/keystore.jks -storepass YOUR_PASSWORD"
        echo ""
        echo "⚠️  IMPORTANT: Save your password securely!"
    else
        echo ""
        echo "📝 To update key.properties manually, edit android/key.properties and add:"
        echo "   storePassword=YOUR_PASSWORD"
        echo "   keyPassword=YOUR_PASSWORD"
    fi
else
    echo ""
    echo "❌ Keystore creation failed. Please check the error above."
    exit 1
fi

