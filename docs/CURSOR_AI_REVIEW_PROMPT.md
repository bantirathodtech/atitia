# Comprehensive App Review Prompt for Cursor AI

## Copy this prompt and paste it into Cursor AI:

---

**You are an expert team reviewing a complete Flutter app called "Atitia" - a PG (Paying Guest) management platform with dual roles (Guest and Owner). The app has been fully developed through 11 phases. Please review this codebase from multiple professional perspectives.**

---

## 📋 **Context & Architecture**

**App Type**: Flutter PG Management Platform  
**Backend**: Firebase (Firestore, Auth, Storage, Analytics) + Supabase (Storage)  
**State Management**: Provider pattern with `BaseProviderState`  
**Architecture**: MVVM (Model-View-ViewModel-Repository)  
**DI**: Dependency Injection with `get_it`, interface-based services  
**Navigation**: `go_router` with centralized NavigationService  
**Phases Completed**: 0-11 (Full bidirectional communication, DI migration, Firestore rules/indexes)

**Key Features**:
- Guest: Browse PGs, send booking requests, view payments, submit complaints, view food menus, manage profile
- Owner: Manage PGs, approve/reject bookings, collect payments, respond to complaints, publish food menus, assign beds/rooms
- Cross-role: Real-time notifications, bidirectional data sync, role-based access control

---

## 🎯 **Multi-Role Review Requirements**

Please analyze this entire codebase from **ALL FOUR roles** simultaneously:

### 1️⃣ **Senior Flutter Developer Review**
**Focus Areas:**
- Code quality, architecture patterns, best practices
- Performance optimization opportunities
- State management efficiency
- Error handling and edge cases
- Code organization and modularity
- Dependency injection implementation
- Widget tree optimization
- Memory leaks and resource management
- Async/await usage and stream handling
- Null safety compliance

**Specific Checks:**
- Are ViewModels properly separated from UI?
- Do Repositories follow single responsibility?
- Is DI pattern correctly implemented throughout?
- Are streams properly disposed?
- Is error handling comprehensive?
- Are there any anti-patterns or technical debt?
- Are there unused imports, widgets, or code?
- Is the codebase maintainable and scalable?

---

### 2️⃣ **Product Manager Review**
**Focus Areas:**
- Feature completeness vs requirements
- User experience and flow
- Business logic correctness
- Edge cases and user scenarios
- Feature gaps or missing functionality
- User journey completeness
- Data consistency across features
- Compliance with user stories

**Specific Checks:**
- Can guests complete the full booking flow end-to-end?
- Can owners manage all aspects of their PG business?
- Are all cross-role communications working as expected?
- Are notifications delivered at the right moments?
- Is data visible to the correct roles?
- Are there any missing features from the PRD?
- Are user workflows intuitive and complete?
- Are error messages user-friendly?

---

### 3️⃣ **Frontend Tester Review**
**Focus Areas:**
- UI/UX consistency and quality
- Screen responsiveness and layouts
- Widget functionality and interactions
- Navigation flow and routing
- Loading states and error states
- Empty states and edge cases
- Accessibility considerations
- Platform-specific issues (Android/iOS/Web)

**Specific Checks:**
- Do all screens load data correctly?
- Are loading indicators shown appropriately?
- Are error states handled with user-friendly messages?
- Do navigation flows work correctly?
- Are all interactive widgets functional?
- Is the UI consistent across all screens?
- Are empty states properly displayed?
- Do real-time updates reflect in the UI?
- Are there any UI bugs or glitches?
- Is the app responsive on different screen sizes?

---

### 4️⃣ **Backend Tester Review**
**Focus Areas:**
- API/Service layer connectivity
- Data persistence and sync
- Real-time stream functionality
- Security rules compliance
- Data integrity and validation
- Firestore query efficiency
- Error handling in data operations
- Offline capability considerations

**Specific Checks:**
- Are all Firestore collections properly connected?
- Do real-time streams work correctly?
- Are security rules properly enforced?
- Is data saved/updated correctly?
- Do queries use proper indexes?
- Are error cases handled in data operations?
- Is data validation performed?
- Are notifications sent correctly?
- Do cross-role data syncs work?
- Are batch operations optimized?

---

## 📊 **Review Output Format**

Please provide your analysis in this structure:

### **Executive Summary**
- Overall app health score (1-100)
- Critical issues count
- High priority items count
- Medium priority items count
- Low priority items count

### **For Each Role, Provide:**

#### **✅ STRENGTHS** (What's working well)
- List key strengths from that role's perspective

#### **⚠️ ISSUES FOUND** (What needs attention)
- Critical: [List critical issues]
- High Priority: [List high priority issues]
- Medium Priority: [List medium priority issues]
- Low Priority: [List low priority issues]

#### **💡 RECOMMENDATIONS** (Improvements)
- Actionable recommendations for that role

### **Cross-Role Findings**
- Issues that affect multiple perspectives
- Systemic problems
- Architecture concerns

---

## 🔍 **Specific Areas to Deep Dive**

### **Feature Completeness Check:**
1. **Authentication Flow**: Sign-in, OTP, role selection
2. **Guest Features**: PG browsing, booking requests, payments, complaints, food menus, profile, room/bed view
3. **Owner Features**: Guest management, booking approvals, payment collection, complaint resolution, food menu management, PG management, bed assignment
4. **Cross-Role Features**: Notifications, real-time sync, data visibility

### **Critical Paths to Verify:**
1. **Guest → Owner Flow**: Booking request sent → Owner receives → Owner approves → Guest notified → Booking created
2. **Owner → Guest Flow**: Owner collects payment → Payment status updated → Guest sees update → Notification sent
3. **Complaint Flow**: Guest submits → Owner receives → Owner responds → Guest notified
4. **Bed Change Flow**: Guest requests → Owner reviews → Owner approves/rejects → Guest sees status

### **Technical Deep Dives:**
1. **DI Implementation**: Are all services properly injected? Are there any direct GetIt calls that should use DI?
2. **Stream Management**: Are all streams properly disposed? Any memory leaks?
3. **Error Handling**: Are try-catch blocks comprehensive? Are errors user-friendly?
4. **Performance**: Are queries optimized? Are widgets rebuilt unnecessarily?
5. **State Management**: Is Provider used correctly? Are state updates efficient?

---

## 🎯 **What I Need From You**

Please analyze the **entire codebase** and provide:

1. **Comprehensive audit** from all four perspectives
2. **Prioritized issue list** with severity levels
3. **Actionable recommendations** for each role
4. **Code examples** of issues found (if any)
5. **Specific file references** for issues
6. **Testing scenarios** that should be verified
7. **Production readiness assessment**

**Be thorough, specific, and actionable. Reference exact files and line numbers when identifying issues. Provide code suggestions when recommending fixes.**

---

## 📁 **Codebase Structure**

- `lib/feature/` - Feature modules (guest_dashboard, owner_dashboard, auth)
- `lib/core/` - Core services, repositories, interfaces, DI
- `lib/common/` - Shared widgets, utilities, styles
- `firestore.rules` - Security rules
- `firestore.indexes.json` - Database indexes

**Key Files to Review:**
- All ViewModels in `lib/feature/*/viewmodel/`
- All Repositories in `lib/feature/*/repository/` and `lib/core/repositories/`
- All Screens in `lib/feature/*/view/screens/`
- DI setup in `lib/core/di/`
- Interfaces in `lib/core/interfaces/`
- Routes in `lib/core/navigation/app_router.dart`

---

**Start the comprehensive review now. Be thorough and provide specific, actionable feedback from all four roles.**

---

