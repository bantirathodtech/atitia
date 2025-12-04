# Firebase Firestore Deployment Guide

## Overview
This guide explains how to deploy Firestore rules and indexes from the command line.

## Prerequisites

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Verify you're using the correct project**:
   ```bash
   firebase use atitia-87925
   ```

## Deployment Commands

### Deploy Both Rules and Indexes
```bash
./scripts/deploy_firestore.sh
```

### Deploy Only Rules
```bash
./scripts/deploy_firestore.sh --only-rules
```

### Deploy Only Indexes
```bash
./scripts/deploy_firestore.sh --only-indexes
```

### Manual Deployment (Alternative)

**Deploy Firestore Rules:**
```bash
firebase deploy --only firestore:rules
```

**Deploy Firestore Indexes:**
```bash
firebase deploy --only firestore:indexes
```

**Deploy Both:**
```bash
firebase deploy --only firestore
```

## Check PGs in Firestore

### Using Script
```bash
./scripts/check_firestore_pgs.sh
```

### Using Firebase Console
1. Open: https://console.firebase.google.com/project/atitia-87925/firestore/data/~2Fpgs
2. Check each PG document:
   - ✅ `isActive` = `true` (required for guest visibility)
   - ⚠️ `isDraft` = `false` or missing (drafts should not be in Firestore)

## File Locations

- **Firestore Rules**: `config/firestore.rules`
- **Firestore Indexes**: `config/firestore.indexes.json`
- **Firebase Config**: `firebase.json`

## Important Notes

1. **Drafts are Local-Only**: Drafts are saved to local storage (SharedPreferences) and **never** saved to Firestore
2. **Only Published PGs**: Only PGs with `isActive: true` are saved to Firestore and visible to guests
3. **Index Updates**: After deploying indexes, they may take a few minutes to build. Check status in Firebase Console.

## Troubleshooting

### "Permission denied" errors
- Ensure you're logged in: `firebase login`
- Verify project: `firebase use atitia-87925`
- Check Firestore rules allow your operations

### Indexes not building
- Check Firebase Console for index build status
- Some indexes may take 5-10 minutes to build
- Ensure query matches index exactly

### PGs not showing to guests
- Verify PG has `isActive: true` in Firestore
- Check Firestore rules allow list operations
- Ensure indexes are built (if using compound queries)

