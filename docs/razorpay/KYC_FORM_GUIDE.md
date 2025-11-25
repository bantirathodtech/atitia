# Razorpay KYC Form - Filling Guide

## 📋 Form Fields to Fill

### **1. Business Type**
**Select:** `Unregistered business type`
- Since you're operating as a personal venture initially (not registered as Pvt Ltd)
- This is appropriate for freelancers or small businesses who haven't registered yet
- ⚠️ **Note:** Business type cannot be changed once submitted

---

### **2. Business Category**
**Already Selected:** ✅ `IT and Software`

---

### **3. Sub Category**
**Already Selected:** ✅ `SaaS (Software as a service)`

---

### **4. Business Description** (Minimum 50 characters)
**Suggested Text:**

```
Atitia is a SaaS platform providing PG (Paying Guest) accommodation management services in India. We offer subscription-based software solutions to PG property owners for managing their properties, guests, bookings, payments, and operations through our mobile app (Android/iOS) and web platform. Our customers are PG owners who pay monthly subscription fees to access premium features like advanced analytics, featured listing services, and unlimited property management. We operate primarily through our mobile application available on Google Play Store and website, serving the growing PG accommodation market in India.
```

**Character Count:** ~530 characters (well above 50 minimum)

---

### **5. Average Order Value**
**Select:** Based on your subscription pricing:
- **Free Plan:** ₹0
- **Premium Plan:** ₹499-999/month (suggest selecting `₹500 - ₹5,000`)
- **Enterprise Plan:** ₹2,499-4,999/month (suggest selecting `₹500 - ₹5,000` or `₹5,000 - ₹50,000`)

**Recommended Selection:** `₹500 - ₹5,000`
- Covers Premium subscriptions (₹499-999)
- Covers Featured Listing purchases (typically ₹500-2000)
- Most common transaction range

---

### **6. How do you wish to accept payments**
**Select:** ✅ `On my website/app`

---

### **7. Accept payments on app**
**Enter URL:**
```
https://play.google.com/store/apps/details?id=com.avishio.atitia
```

---

## ⚠️ **REQUIRED PAGES VERIFICATION**

Razorpay requires these pages on your website/app for verification:

### ✅ **What You Have:**
1. **Privacy Policy** ✅
   - Screen exists: `lib/common/screens/privacy_policy_screen.dart`
   - Should be accessible via web URL

2. **Terms & Conditions** ✅
   - Screen exists: `lib/common/screens/terms_of_service_screen.dart`
   - Should be accessible via web URL

3. **Cancellation/Refund Policy** ✅
   - Refund process implemented in app
   - Need to create web-accessible refund policy page

### ❌ **What You Need to Create:**

4. **About Us** ❌
   - Need to create and make accessible via web

5. **Contact Us** ❌
   - Need to create and make accessible via web

6. **Pricing** ❌
   - Subscription plans exist in app
   - Need to create web-accessible pricing page

---

## 🔧 **ACTION REQUIRED: Create Missing Pages**

You need to create these pages and make them accessible via web URLs:

### **1. About Us Page**
Create a web page with information about:
- What Atitia is
- Your mission/vision
- Team (if applicable)
- Contact information

**Suggested URL:** `https://your-domain.com/about` or `https://your-domain.com/about-us`

### **2. Contact Us Page**
Create a web page with:
- Email address
- Phone number (if applicable)
- Support hours
- Contact form or email link

**Suggested URL:** `https://your-domain.com/contact` or `https://your-domain.com/contact-us`

### **3. Pricing Page**
Create a web page showing:
- Free Plan features
- Premium Plan (₹499-999/month) features
- Enterprise Plan (₹2,499-4,999/month) features
- Featured Listing pricing
- Compare plans

**Suggested URL:** `https://your-domain.com/pricing`

### **4. Refund Policy Page**
Create a detailed web page with:
- Refund eligibility
- Refund process
- Timeline for refunds
- Contact for refund requests

**Suggested URL:** `https://your-domain.com/refund-policy` or `https://your-domain.com/cancellation-refund-policy`

### **5. Update Privacy Policy & Terms URLs**
Ensure these are accessible via web:
- Privacy Policy: `https://your-domain.com/privacy-policy`
- Terms & Conditions: `https://your-domain.com/terms` or `https://your-domain.com/terms-of-service`

---

## 📝 **Additional Notes for Razorpay KYC**

### **Website/App Verification Requirements:**
Razorpay will verify that your app/website contains:

1. ✅ **About Us** - Company information, mission
2. ✅ **Contact Us** - How to reach you
3. ✅ **Pricing** - Clear pricing information
4. ✅ **Privacy Policy** - Data handling policy
5. ✅ **Terms & Conditions** - Service terms
6. ✅ **Cancellation/Refund Policy** - Refund terms

### **Best Practices:**
- All pages should be publicly accessible (no login required)
- Pages should be professional and clearly written
- Links should be in footer or easily accessible navigation
- Content should match your business description

---

## 🚀 **Next Steps**

1. **Create missing web pages** (About Us, Contact Us, Pricing, Refund Policy)
2. **Ensure all pages are publicly accessible** via web URLs
3. **Add links to these pages** in your app (footer, settings, etc.)
4. **Fill out the Razorpay KYC form** using the information above
5. **Submit the form** and wait for Razorpay verification
6. **Once approved**, you'll receive live API keys

---

## 📧 **For Support**

If you need help creating these pages, I can help you:
- Create the content for each page
- Set up web routes for these pages
- Integrate them into your app's navigation

---

**Last Updated:** After checking app structure
**Status:** Ready to fill form after creating missing web pages

