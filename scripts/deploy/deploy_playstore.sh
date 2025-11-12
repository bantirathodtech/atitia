#!/bin/bash
# ==================================================
# 📱 DEPLOY TO GOOGLE PLAY STORE
# ==================================================
# Upload to Google Play using fastlane supply or Play API
# Usage: bash scripts/deploy_playstore.sh [track] [aab-path]
# Tracks: internal, alpha, beta, production (default: internal)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

TRACK="${1:-${PLAY_STORE_TRACK:-internal}}"
AAB_PATH="${2:-$PROJECT_ROOT/build/app/outputs/bundle/release/app-release.aab}"

echo "📱 Deploying to Google Play Store ($TRACK track)"

# Check if AAB exists
if [ ! -f "$AAB_PATH" ]; then
    echo "❌ AAB not found at $AAB_PATH"
    echo "   Building release AAB first..."
    bash "$SCRIPT_DIR/release_android.sh" aab
    AAB_PATH="$PROJECT_ROOT/build/app/outputs/bundle/release/app-release.aab"
fi

# Check for service account
if [ ! -f "$ANDROID_SERVICE_ACCOUNT" ]; then
    echo "❌ Service account JSON not found at $ANDROID_SERVICE_ACCOUNT"
    echo "   Download from Google Cloud Console and place in .secrets/android/"
    exit 1
fi

# Method 1: Using fastlane supply (if installed)
if command -v fastlane &> /dev/null && [ -f "$PROJECT_ROOT/android/fastlane/Fastfile" ]; then
    echo "🚀 Using fastlane supply..."
    cd "$PROJECT_ROOT/android"
    fastlane supply \
        --aab "$AAB_PATH" \
        --track "$TRACK" \
        --json_key "$ANDROID_SERVICE_ACCOUNT" \
        --package_name "$ANDROID_PACKAGE_NAME" \
        --skip_upload_metadata \
        --skip_upload_images \
        --skip_upload_screenshots
    echo "✅ Deployment via fastlane complete"
    
# Method 2: Using Google Play Developer API (via Python script)
elif command -v python3 &> /dev/null; then
    echo "🚀 Using Google Play Developer API..."
    python3 << EOF
import json
import sys
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Load service account
with open('$ANDROID_SERVICE_ACCOUNT', 'r') as f:
    credentials_info = json.load(f)

credentials = service_account.Credentials.from_service_account_info(
    credentials_info,
    scopes=['https://www.googleapis.com/auth/androidpublisher']
)

service = build('androidpublisher', 'v3', credentials=credentials)
package_name = '$ANDROID_PACKAGE_NAME'

# Create edit
edit_request = service.edits().insert(body={}, packageName=package_name)
edit_response = edit_request.execute()
edit_id = edit_response['id']

# Upload AAB
aab_upload = service.edits().bundles().upload(
    editId=edit_id,
    packageName=package_name,
    media_body=MediaFileUpload('$AAB_PATH', mimetype='application/octet-stream')
)
aab_response = aab_upload.execute()

# Commit edit
commit_request = service.edits().commit(
    editId=edit_id,
    packageName=package_name
).execute()

print(f"✅ Uploaded AAB version {aab_response['versionCode']} to $TRACK track")
EOF
    echo "✅ Deployment via API complete"
    
# Method 3: Manual instructions
else
    echo "⚠️  fastlane or Python not available"
    echo ""
    echo "📋 Manual deployment steps:"
    echo "   1. Go to Google Play Console: https://play.google.com/console"
    echo "   2. Select your app: $ANDROID_PACKAGE_NAME"
    echo "   3. Go to Production > Releases > $TRACK"
    echo "   4. Click 'Create new release'"
    echo "   5. Upload AAB: $AAB_PATH"
    echo "   6. Review and roll out"
    echo ""
    echo "   Or install fastlane: gem install fastlane"
    exit 1
fi

echo "✅ Google Play Store deployment complete!"
echo "   Track: $TRACK"
echo "   AAB: $AAB_PATH"

