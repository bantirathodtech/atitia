# 📧 Google Play Console Email List Guide

This guide explains how to create and manage email lists for Google Play Console closed testing.

## 🎯 Purpose

Email lists in Google Play Console are used to:
- Invite beta testers to closed testing tracks
- Manage internal testing groups
- Send app updates to specific user groups
- Organize testers by role, location, or feature

---

## 📝 Creating an Email List

### Step 1: Access Email Lists

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app (**Atitia**)
3. Navigate to **Testing** → **Closed testing** (or **Internal testing**)
4. Click on **Testers** tab
5. Click **Create email list** or **Manage email lists**

### Step 2: Fill in the Form

**List name** (Required):
- Enter a descriptive name (e.g., "Beta Testers", "Internal Team", "QA Team")
- Maximum 200 characters
- Examples:
  - `Atitia Beta Testers`
  - `Internal QA Team`
  - `Feature Testers - Payment Flow`
  - `Regional Testers - Hyderabad`

**Add email addresses**:
- Enter email addresses separated by commas
- Example: `user1@example.com, user2@example.com, user3@example.com`
- Press Enter to add them to the list
- You can add emails one by one or paste multiple at once

**Email addresses added**:
- Shows all emails you've added
- You can remove individual emails by clicking the X next to them
- Or upload a CSV file with email addresses

### Step 3: Upload CSV File (Optional)

Instead of typing emails, you can upload a CSV file:

**CSV Format:**
```csv
email
user1@example.com
user2@example.com
user3@example.com
```

**Steps:**
1. Create a CSV file with email addresses (one per line)
2. Click **Upload CSV file**
3. Select your CSV file
4. Emails will be automatically added

### Step 4: Save the List

1. Review all email addresses
2. Click **Save** or **Create list**
3. The list will be available for use in testing tracks

---

## 📋 Best Practices

### List Naming Convention

Use clear, descriptive names:
- ✅ `Atitia Beta Testers - Round 1`
- ✅ `Internal Team - Developers`
- ✅ `QA Team - Payment Testing`
- ❌ `List 1`
- ❌ `Test`

### Email Organization

**By Role:**
- `Owners - Internal Testing`
- `Guests - Beta Testing`
- `Developers - Internal`

**By Feature:**
- `Payment Feature Testers`
- `Booking Flow Testers`
- `Food Menu Testers`

**By Location:**
- `Hyderabad Testers`
- `Mumbai Testers`
- `Regional Testers`

### Email Validation

- Ensure all emails are valid and active
- Remove bounced or invalid emails regularly
- Test with a small group first before adding many emails

---

## 🔄 Managing Email Lists

### Adding Emails

1. Go to **Testing** → **Closed testing** → **Testers**
2. Click on your email list
3. Click **Add email addresses**
4. Enter emails (comma-separated) or upload CSV
5. Click **Save**

### Removing Emails

1. Open your email list
2. Find the email you want to remove
3. Click the **X** next to the email
4. Click **Save**

### Editing List Name

1. Open your email list
2. Click **Edit** next to the list name
3. Change the name
4. Click **Save**

### Deleting a List

1. Open your email list
2. Click **Delete list**
3. Confirm deletion

---

## 📊 Using Email Lists

### Assign to Testing Track

1. Go to **Testing** → **Closed testing** → **Testers**
2. Click **Add testers**
3. Select **Email list**
4. Choose your email list from the dropdown
5. Click **Add**

### Multiple Lists

You can add multiple email lists to a testing track:
- Combine different groups
- Mix internal and external testers
- Organize by feature or role

---

## 📧 Email List Examples

### Example 1: Internal Testing

**List Name:** `Atitia Internal Team`

**Emails:**
```
developer1@atitia.com
developer2@atitia.com
qa@atitia.com
product@atitia.com
```

### Example 2: Beta Testers

**List Name:** `Atitia Beta Testers - Round 1`

**Emails:**
```
beta.tester1@gmail.com
beta.tester2@yahoo.com
beta.tester3@outlook.com
```

### Example 3: Feature-Specific

**List Name:** `Payment Feature Testers`

**Emails:**
```
payment.tester1@example.com
payment.tester2@example.com
```

---

## ⚠️ Important Notes

1. **Privacy**: Only add emails of users who have consented to testing
2. **GDPR Compliance**: Ensure you have permission to add emails
3. **Email Limits**: Google Play may have limits on list size
4. **Active Emails**: Use active email addresses to avoid bounces
5. **Regular Updates**: Keep lists updated and remove inactive testers

---

## 🚀 Quick Reference

**Create List:**
1. Testing → Closed testing → Testers
2. Create email list
3. Enter name and emails
4. Save

**Add to Track:**
1. Testing → Closed testing → Testers
2. Add testers
3. Select email list
4. Add

**Manage Lists:**
1. Testing → Closed testing → Testers
2. Manage email lists
3. Edit/Delete as needed

---

## 📝 CSV Template

Create a file `testers.csv`:

```csv
email
tester1@example.com
tester2@example.com
tester3@example.com
```

Then upload it when creating the list.

---

## ❓ Troubleshooting

**Can't add emails?**
- Check email format (must be valid email addresses)
- Ensure you have permission to add testers
- Check if there are any limits on your account

**Emails not receiving invites?**
- Verify email addresses are correct
- Check spam/junk folders
- Ensure testers have Google accounts

**List not showing?**
- Refresh the page
- Check if list was saved successfully
- Verify you're in the correct testing track

---

Good luck with your beta testing! 🎉

