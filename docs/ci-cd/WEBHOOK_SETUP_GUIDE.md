# 🔗 Webhook Setup Guide for CI/CD Notifications

This guide will help you set up Slack and Discord webhooks for production deployment notifications.

---

## 📊 Slack Webhook Setup (Free Version)

### Step 1: Create a Slack App

1. Go to: https://api.slack.com/apps
2. Click **"Create New App"**
3. Select **"From scratch"**
4. Enter app details:
   - **App Name:** `Atitia CI/CD Notifications` (or any name)
   - **Pick a workspace:** Select your workspace
5. Click **"Create App"**

### Step 2: Enable Incoming Webhooks

1. In your app settings, go to **"Incoming Webhooks"** (left sidebar)
2. Toggle **"Activate Incoming Webhooks"** to **ON**
3. Scroll down and click **"Add New Webhook to Workspace"**
4. Select the channel where you want notifications (e.g., `#general` or create `#deployments`)
5. Click **"Allow"**

### Step 3: Copy Webhook URL

1. You'll see a **"Webhook URL"** that starts with:
   ```
   https://hooks.slack.com/services/YOUR/TEAM/ID/YOUR/WEBHOOK/TOKEN
   ```
   (This will be your unique webhook URL)
2. **Copy this entire URL** - this is what we need!

### Step 4: Add to GitHub Secrets

1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `SLACK_WEBHOOK_URL`
4. Value: Paste your webhook URL
5. Click **"Add secret"**

✅ **Done!** Slack notifications are now configured.

---

## 🎮 Discord Webhook Setup

### Step 1: Enable Developer Mode (Optional)

1. Go to Discord Settings → Advanced
2. Enable **"Developer Mode"** (helps with IDs)

### Step 2: Create Webhook in Your Channel

1. Go to your Discord server
2. Navigate to the channel where you want notifications
3. Click on the **channel name** at the top
4. Select **"Edit Channel"** (or right-click channel name)
5. Go to **"Integrations"** tab
6. Click **"Webhooks"** → **"New Webhook"** (or **"Create Webhook"**)
7. Configure:
   - **Name:** `Atitia CI/CD` (or any name)
   - **Channel:** Select your channel
   - **Copy Webhook URL** - Click the **"Copy Webhook URL"** button

### Step 3: Copy Webhook URL

You'll get a URL like:
```
https://discord.com/api/webhooks/1443553654882832436/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**Copy this entire URL** - this is what we need!

### Step 4: Add to GitHub Secrets

1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `DISCORD_WEBHOOK_URL`
4. Value: Paste your webhook URL
5. Click **"Add secret"**

✅ **Done!** Discord notifications are now configured.

---

## 🧪 Testing Webhooks

### Test Slack Webhook

```bash
# Replace YOUR_WEBHOOK_URL with your actual webhook URL from Slack
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"🧪 Test notification from Atitia CI/CD"}' \
  "YOUR_WEBHOOK_URL"
```

### Test Discord Webhook

```bash
# Replace with your actual webhook URL
curl -X POST -H 'Content-type: application/json' \
  --data '{"content":"🧪 Test notification from Atitia CI/CD"}' \
  https://discord.com/api/webhooks/YOUR/WEBHOOK/URL
```

---

## 📋 Quick Checklist

- [ ] Slack webhook created and URL copied
- [ ] `SLACK_WEBHOOK_URL` secret added to GitHub
- [ ] Discord webhook created and URL copied
- [ ] `DISCORD_WEBHOOK_URL` secret added to GitHub
- [ ] Test notifications sent successfully
- [ ] Ready for production deployment notifications!

---

## 🔒 Security Notes

- **Never commit webhook URLs** to git
- Webhooks are stored securely in GitHub Secrets
- Only repository admins can view/edit secrets
- You can revoke webhooks anytime from Slack/Discord settings

---

## 📱 What You'll Receive

When a production deployment runs, you'll get notifications with:

- ✅ Deployment status (Success/Failure/Cancelled)
- 📦 Version number
- 👤 Who triggered the deployment
- 🔗 Link to workflow run
- 📊 Platform deployment status (Android/iOS/Web)

---

## 🆘 Troubleshooting

### Slack webhook not working?

1. Verify webhook URL is correct (starts with `https://hooks.slack.com/services/`)
2. Check webhook is enabled in Slack app settings
3. Verify channel permissions
4. Check GitHub Actions logs for error messages

### Discord webhook not working?

1. Verify webhook URL is correct (starts with `https://discord.com/api/webhooks/`)
2. Check webhook is enabled in channel settings
3. Verify bot permissions in Discord server
4. Check GitHub Actions logs for error messages

### Not receiving notifications?

- Notifications are **optional** - pipeline will work without them
- Check GitHub Secrets are added correctly
- Verify webhook URLs are not expired
- Test webhooks manually using curl commands above

---

**Last Updated:** 2025-01-27

