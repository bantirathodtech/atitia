#!/bin/bash

# Create key.properties file for Android signing
# This script will prompt for the keystore password securely

echo "🔐 Creating android/key.properties"
echo "==================================="
echo ""

if [ -f "android/key.properties" ]; then
    echo "⚠️  key.properties already exists!"
    read -p "Do you want to overwrite it? (y/N): " overwrite
    if [[ ! $overwrite =~ ^[Yy]$ ]]; then
        echo "Keeping existing file. Exiting."
        exit 0
    fi
fi

echo "Enter your keystore password (the one you used when creating the keystore):"
read -p "Keystore password: " -s store_password
echo ""

read -p "Key password (Press Enter to use same as keystore): " -s key_password
echo ""
if [ -z "$key_password" ]; then
    key_password=$store_password
fi

# Create key.properties file
cat > android/key.properties << EOF
# Android Production Signing Configuration
# DO NOT COMMIT THIS FILE TO GIT
# Generated on $(date)

storeFile=keystore.jks
storePassword=$store_password
keyAlias=atitia-release
keyPassword=$key_password
EOF

echo ""
echo "✅ Created android/key.properties"
echo ""
echo "⚠️  Note: Country code '91' was used. For future certificates, use 'IN' (2-letter code)."
echo "   This keystore will work fine as-is."
echo ""
echo "✅ Step 1 Complete! Ready for Step 2."

