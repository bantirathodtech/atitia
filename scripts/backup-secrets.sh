#!/bin/bash

# 📦 Secrets Backup Script
# Creates timestamped backups of all secrets in .secrets/ folder

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SECRETS_DIR="$PROJECT_ROOT/.secrets"
BACKUPS_DIR="$SECRETS_DIR/backups"

# Create backups directory if it doesn't exist
mkdir -p "$BACKUPS_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BACKUPS_DIR/$TIMESTAMP"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 CREATING SECRETS BACKUP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Copy all secrets (excluding README files and backups folder)
echo "📋 Copying secrets..."
rsync -av --exclude='README.md' \
          --exclude='backups/' \
          --exclude='.gitkeep' \
          "$SECRETS_DIR/" "$BACKUP_DIR/" || {
    echo "❌ Error: Failed to copy secrets"
    exit 1
}

# Create manifest file
MANIFEST="$BACKUP_DIR/BACKUP_MANIFEST.txt"
echo "📝 Creating manifest..."

cat > "$MANIFEST" << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECRETS BACKUP MANIFEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Backup Date: $(date)
Backup Location: $BACKUP_DIR

Files Backed Up:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# List all files in backup (excluding manifest itself)
find "$BACKUP_DIR" -type f ! -name "BACKUP_MANIFEST.txt" | sort | while read -r file; do
    RELATIVE_PATH="${file#$BACKUP_DIR/}"
    SIZE=$(du -h "$file" | cut -f1)
    echo "  $RELATIVE_PATH ($SIZE)" >> "$MANIFEST"
done

echo "" >> "$MANIFEST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MANIFEST"
echo "Backup completed successfully!" >> "$MANIFEST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MANIFEST"

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)

echo "✅ Backup completed successfully!"
echo ""
echo "📊 Backup Summary:"
echo "   Location: $BACKUP_DIR"
echo "   Size: $BACKUP_SIZE"
echo "   Manifest: $MANIFEST"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 To restore from this backup:"
echo "   cp -r $BACKUP_DIR/* $SECRETS_DIR/"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

