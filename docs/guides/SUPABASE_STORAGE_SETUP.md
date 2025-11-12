# Supabase Storage Setup Guide

## Problem
Photo uploads are failing with "Failed to fetch" error. This is due to Supabase Storage RLS (Row Level Security) policies blocking anonymous uploads.

## Solution: Configure Supabase Storage Policies

### Method 1: Allow Anonymous Uploads (Recommended for Testing)

1. **Go to Supabase Dashboard**
   - Visit: https://app.supabase.com
   - Select your project: `iteharwqzobkolybqvsl`

2. **Navigate to Storage**
   - Click **Storage** in the left sidebar
   - Find bucket: `atitia-storage`

3. **Create Upload Policy**
   - Click on **Policies** tab
   - Click **New Policy**
   - Choose **For full customization** option

4. **Policy Details:**
   ```
   Policy name: Allow anonymous uploads to pg_photos
   Allowed operation: INSERT
   Target roles: anon
   ```

5. **Policy Definition (SQL):**
   ```sql
   (bucket_id = 'atitia-storage'::text) 
   AND 
   ((storage.foldername(name))[1] = 'pg_photos'::text)
   ```

   Or for all folders in the bucket:
   ```sql
   bucket_id = 'atitia-storage'::text
   ```

6. **Create the Policy**
   - Click **Review** then **Save policy**

### Method 2: Make Bucket Public (Quick but Less Secure)

1. Go to **Storage** → `atitia-storage`
2. Click **Settings** tab
3. Enable **Public bucket** toggle
4. This allows anyone to upload (use only for testing!)

### Method 3: Require Authentication (Most Secure)

If you want authenticated uploads only:

1. **Create Policy for Authenticated Users:**
   ```
   Policy name: Allow authenticated uploads to pg_photos
   Allowed operation: INSERT
   Target roles: authenticated
   ```

2. **Policy Definition:**
   ```sql
   (bucket_id = 'atitia-storage'::text) 
   AND 
   ((storage.foldername(name))[1] = 'pg_photos'::text)
   AND
   (auth.role() = 'authenticated'::text)
   ```

3. **Sync Firebase Auth with Supabase:**
   - This requires implementing Firebase custom token generation
   - And calling Supabase `auth.signInWithIdToken()` with the Firebase token

## Verify the Fix

After creating the policy:

1. Go back to your Flutter app
2. Try uploading photos again
3. The upload should work now!

## Troubleshooting

### Still getting "Failed to fetch"?

1. **Check CORS Settings:**
   - Storage → Settings → CORS
   - Add your domain: `localhost` (for dev) or your production domain

2. **Check Bucket Exists:**
   - The bucket `atitia-storage` should exist
   - If not, it will be created on first upload (if permissions allow)

3. **Check Network Tab:**
   - Open browser DevTools → Network
   - Look for the failed request
   - Check the error response for more details

## Current Configuration

- **Bucket Name:** `atitia-storage`
- **Upload Path:** `pg_photos/`
- **Full URL:** `https://iteharwqzobkolybqvsl.supabase.co/storage/v1/object/atitia-storage/pg_photos/`

## Recommended Setup for Production

1. Use **authenticated uploads** (Method 3)
2. Sync Firebase Auth tokens with Supabase
3. Add file size limits
4. Add file type validation
5. Implement upload progress tracking

