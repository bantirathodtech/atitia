# 📱 Manual Testing Checklist - Atitia App

**Priority:** 🔴 CRITICAL - Do This First  
**Status:** Ready to Start  
**Estimated Time:** 2-3 hours

---

## ✅ How to Use This Checklist

1. Install app on your device
2. Go through each test case
3. Mark ✅ if it works, ❌ if it fails
4. Write notes for any issues found

---

## 🔐 1. Authentication Testing

### 1.1 Phone OTP Login
- [ ] **Test:** Open app → Select "Guest" role → Enter phone number → Send OTP
- [ ] **Expected:** OTP sent successfully
- [ ] **Test:** Enter correct OTP → Verify
- [ ] **Expected:** Login successful, navigates to Guest Dashboard
- [ ] **Test:** Enter wrong OTP → Verify
- [ ] **Expected:** Shows error message
- [ ] **Notes:** _________________________

### 1.2 Google OAuth Login
- [ ] **Test:** Select "Owner" role → Click "Sign in with Google"
- [ ] **Expected:** Google sign-in popup appears
- [ ] **Test:** Select Google account → Authorize
- [ ] **Expected:** Login successful, navigates to Owner Dashboard
- [ ] **Test:** Cancel Google sign-in
- [ ] **Expected:** Returns to login screen
- [ ] **Notes:** _________________________

### 1.3 Session Persistence
- [ ] **Test:** Login → Close app completely → Reopen app
- [ ] **Expected:** Auto-login, no need to login again
- [ ] **Test:** Logout → Close app → Reopen app
- [ ] **Expected:** Shows login screen
- [ ] **Notes:** _________________________

### 1.4 Logout
- [ ] **Test:** Login → Open drawer → Click "Logout"
- [ ] **Expected:** Logs out successfully, returns to login screen
- [ ] **Notes:** _________________________

---

## 👤 2. Guest Dashboard Testing

### 2.1 PG List Loading
- [ ] **Test:** Login as Guest → Wait for PG list to load
- [ ] **Expected:** PG list displays with cards
- [ ] **Test:** Check if distance is shown (if location permission granted)
- [ ] **Expected:** Distance shown in km/miles
- [ ] **Notes:** _________________________

### 2.2 PG Search
- [ ] **Test:** Type in search box
- [ ] **Expected:** Results filter as you type
- [ ] **Test:** Clear search
- [ ] **Expected:** Shows all PGs again
- [ ] **Notes:** _________________________

### 2.3 PG Details
- [ ] **Test:** Tap on a PG card
- [ ] **Expected:** Opens PG details screen
- [ ] **Test:** Check all information displays (photos, amenities, price)
- [ ] **Expected:** All data visible
- [ ] **Notes:** _________________________

### 2.4 Booking Request
- [ ] **Test:** View PG → Click "Book Now" → Fill form → Submit
- [ ] **Expected:** Booking request created
- [ ] **Test:** Check "My Bookings" tab
- [ ] **Expected:** Booking appears in list
- [ ] **Notes:** _________________________

### 2.5 Payment
- [ ] **Test:** Go to Payments tab → View payment history
- [ ] **Expected:** Payments list displays
- [ ] **Test:** Click "Make Payment" → Enter amount → Pay with Razorpay
- [ ] **Expected:** Razorpay payment screen opens
- [ ] **Notes:** _________________________

### 2.6 Complaints
- [ ] **Test:** Go to Complaints tab → Click "Add Complaint"
- [ ] **Expected:** Complaint form opens
- [ ] **Test:** Fill form → Submit
- [ ] **Expected:** Complaint created, appears in list
- [ ] **Notes:** _________________________

---

## 🏢 3. Owner Dashboard Testing

### 3.1 Overview Screen
- [ ] **Test:** Login as Owner → Check Overview tab
- [ ] **Expected:** Shows stats (properties, revenue, tenants)
- [ ] **Test:** Check if data is real (not zeros/placeholders)
- [ ] **Expected:** Real data from Firestore
- [ ] **Test:** Click "View Details" on payment breakdown
- [ ] **Expected:** Navigates to Guests tab with payments filter
- [ ] **Notes:** _________________________

### 3.2 PG Selector
- [ ] **Test:** If owner has multiple PGs → Check dropdown
- [ ] **Expected:** Shows all PGs, can switch between them
- [ ] **Test:** Switch PG → Check if data updates
- [ ] **Expected:** Data changes based on selected PG
- [ ] **Notes:** _________________________

### 3.3 Guest Management
- [ ] **Test:** Go to Guests tab → Check guest list loads
- [ ] **Expected:** List of guests displays
- [ ] **Test:** Search for a guest
- [ ] **Expected:** Results filter correctly
- [ ] **Test:** Click three-dot menu on guest → "Send Message"
- [ ] **Expected:** Message dialog opens
- [ ] **Test:** Type message → Send
- [ ] **Expected:** Message sent, shows success message
- [ ] **Test:** Click "Call Guest"
- [ ] **Expected:** Phone dialer opens with guest's number
- [ ] **Test:** Click "Check Out"
- [ ] **Expected:** Confirmation dialog → Confirm → Guest checked out
- [ ] **Notes:** _________________________

### 3.4 PG Management
- [ ] **Test:** Go to PGs tab → Check PG list
- [ ] **Expected:** Owner's PGs display
- [ ] **Test:** Click "Add PG" → Fill form → Save
- [ ] **Expected:** PG created successfully
- [ ] **Test:** Edit existing PG
- [ ] **Expected:** Changes saved
- [ ] **Notes:** _________________________

### 3.5 Analytics Dashboard
- [ ] **Test:** Open drawer → Click "Analytics"
- [ ] **Expected:** Analytics screen opens (if premium subscription)
- [ ] **Test:** Check Revenue tab
- [ ] **Expected:** Shows real revenue data (not mock data)
- [ ] **Test:** Check Occupancy tab
- [ ] **Expected:** Shows occupancy data
- [ ] **Test:** Check Performance tab
- [ ] **Expected:** Shows real performance metrics
- [ ] **Notes:** _________________________

### 3.6 Profile Photo Upload
- [ ] **Test:** Go to Profile → Click profile photo → Select from gallery
- [ ] **Expected:** Photo selected
- [ ] **Test:** Wait for upload
- [ ] **Expected:** Photo uploads, shows success message
- [ ] **Test:** Check if photo appears in profile
- [ ] **Expected:** New photo displays
- [ ] **Notes:** _________________________

### 3.7 Aadhaar Photo Upload
- [ ] **Test:** Go to Profile → Click Aadhaar photo → Select from gallery
- [ ] **Expected:** Photo selected
- [ ] **Test:** Wait for upload
- [ ] **Expected:** Photo uploads, shows success message
- [ ] **Notes:** _________________________

---

## 🔄 4. Navigation Testing

### 4.1 Tab Navigation
- [ ] **Test:** Guest Dashboard → Switch between tabs (PGs, Foods, Payments, Complaints)
- [ ] **Expected:** Each tab loads correctly
- [ ] **Test:** Owner Dashboard → Switch between tabs (Overview, Foods, PGs, Guests)
- [ ] **Expected:** Each tab loads correctly
- [ ] **Notes:** _________________________

### 4.2 Deep Navigation
- [ ] **Test:** Overview → Click "View Details" → Check navigation
- [ ] **Expected:** Navigates to correct screen with correct tab selected
- [ ] **Test:** Use back button
- [ ] **Expected:** Returns to previous screen
- [ ] **Notes:** _________________________

### 4.3 Drawer Navigation
- [ ] **Test:** Open drawer → Click "Profile"
- [ ] **Expected:** Opens profile screen
- [ ] **Test:** Open drawer → Click "Analytics"
- [ ] **Expected:** Opens analytics screen
- [ ] **Test:** Open drawer → Click "Settings"
- [ ] **Expected:** Opens settings screen
- [ ] **Notes:** _________________________

---

## 📸 5. Image Upload Testing

### 5.1 Profile Photo
- [ ] **Test:** Select photo from gallery
- [ ] **Expected:** Photo picker opens
- [ ] **Test:** Select image → Upload
- [ ] **Expected:** Uploads successfully
- [ ] **Test:** Check if photo displays after upload
- [ ] **Expected:** New photo visible
- [ ] **Notes:** _________________________

### 5.2 Aadhaar Document
- [ ] **Test:** Select document from gallery
- [ ] **Expected:** Document picker opens
- [ ] **Test:** Select image → Upload
- [ ] **Expected:** Uploads successfully
- [ ] **Notes:** _________________________

---

## 📞 6. Communication Testing

### 6.1 Send Message
- [ ] **Test:** Owner → Guest list → Send message to guest
- [ ] **Expected:** Message dialog opens
- [ ] **Test:** Type message → Send
- [ ] **Expected:** Message sent, success message shown
- [ ] **Test:** Check if guest receives push notification
- [ ] **Expected:** Notification received (if guest app is open)
- [ ] **Notes:** _________________________

### 6.2 Phone Call
- [ ] **Test:** Owner → Guest list → Call guest
- [ ] **Expected:** Phone dialer opens with guest's number
- [ ] **Notes:** _________________________

---

## 💳 7. Payment Testing

### 7.1 Razorpay Integration
- [ ] **Test:** Guest → Make payment → Razorpay screen opens
- [ ] **Expected:** Razorpay payment UI appears
- [ ] **Test:** Complete test payment
- [ ] **Expected:** Payment processes (use test mode)
- [ ] **Test:** Check payment status updates
- [ ] **Expected:** Status changes to "Paid"
- [ ] **Notes:** _________________________

---

## 📍 8. Location Services Testing

### 8.1 Location Permission
- [ ] **Test:** First time opening PG list
- [ ] **Expected:** Location permission request appears
- [ ] **Test:** Grant permission
- [ ] **Expected:** Distance calculated and shown
- [ ] **Test:** Deny permission
- [ ] **Expected:** App still works, distance not shown
- [ ] **Notes:** _________________________

### 8.2 Distance Calculation
- [ ] **Test:** Grant location permission → Check PG list
- [ ] **Expected:** Distance shown for each PG
- [ ] **Test:** Move to different location → Refresh
- [ ] **Expected:** Distances update
- [ ] **Notes:** _________________________

---

## 🌐 9. Network Testing

### 9.1 Offline Mode
- [ ] **Test:** Turn off internet → Open app
- [ ] **Expected:** Shows cached data or error message
- [ ] **Test:** Turn on internet → Refresh
- [ ] **Expected:** Data loads correctly
- [ ] **Notes:** _________________________

### 9.2 Slow Network
- [ ] **Test:** Use slow network (3G) → Load PG list
- [ ] **Expected:** Loading indicator shows, data eventually loads
- [ ] **Notes:** _________________________

---

## 🎨 10. UI/UX Testing

### 10.1 Theme Switching
- [ ] **Test:** Open drawer → Toggle dark/light theme
- [ ] **Expected:** Theme changes immediately
- [ ] **Test:** Close app → Reopen
- [ ] **Expected:** Theme persists
- [ ] **Notes:** _________________________

### 10.2 Language Switching
- [ ] **Test:** Open drawer → Change language (English/Telugu)
- [ ] **Expected:** All text changes language
- [ ] **Test:** Close app → Reopen
- [ ] **Expected:** Language persists
- [ ] **Notes:** _________________________

### 10.3 Responsive Design
- [ ] **Test:** Rotate device (if supported)
- [ ] **Expected:** Layout adapts correctly
- [ ] **Test:** Check on tablet (if available)
- [ ] **Expected:** UI scales properly
- [ ] **Notes:** _________________________

---

## ⚠️ 11. Error Handling Testing

### 11.1 Network Errors
- [ ] **Test:** Turn off internet → Try to load data
- [ ] **Expected:** Shows user-friendly error message
- [ ] **Test:** Click retry
- [ ] **Expected:** Retries loading
- [ ] **Notes:** _________________________

### 11.2 Invalid Input
- [ ] **Test:** Login → Enter invalid phone number
- [ ] **Expected:** Shows validation error
- [ ] **Test:** Booking form → Leave required fields empty
- [ ] **Expected:** Shows validation errors
- [ ] **Notes:** _________________________

---

## 📊 Test Results Summary

**Total Test Cases:** ~50  
**Passed:** ___  
**Failed:** ___  
**Notes:** _________________________

---

## 🐛 Issues Found

### Critical Issues:
1. _________________________
2. _________________________

### High Priority Issues:
1. _________________________
2. _________________________

### Medium Priority Issues:
1. _________________________
2. _________________________

---

## ✅ Sign Off

**Tester Name:** _________________________  
**Date:** _________________________  
**Device:** _________________________  
**OS Version:** _________________________  
**App Version:** _________________________  

**Overall Status:** ✅ Pass / ⚠️ Pass with Issues / ❌ Fail

---

**Next Steps:**
1. Fix critical issues
2. Fix high priority issues
3. Re-test fixed issues
4. Move to next testing type (Unit Testing)

