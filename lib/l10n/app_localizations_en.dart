// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Atitia';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get roleGuest => 'I am Guest';

  @override
  String get roleOwner => 'I am PG Owner';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get changeNumber => 'Change Number';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get verify => 'Verify';

  @override
  String get guestRegistration => 'Guest Registration';

  @override
  String get ownerRegistration => 'Owner Registration';

  @override
  String get home => 'Home';

  @override
  String get booking => 'Booking';

  @override
  String get payments => 'Payments';

  @override
  String get feedback => 'Feedback';

  @override
  String get profile => 'Profile';

  @override
  String get selectRole => 'Select Your Role';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get submit => 'Submit';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get telugu => 'తెలుగు';

  @override
  String get loading => 'Loading...';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get retry => 'Retry';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get goBack => 'Go Back';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get subject => 'Subject';

  @override
  String get description => 'Description:';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get pincode => 'Pincode';

  @override
  String get country => 'Country';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get amount => 'Amount';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get failed => 'Failed';

  @override
  String get noData => 'No Data Available';

  @override
  String get noInternet => 'No Internet Connection';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get operationSuccessful => 'Operation successful';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get appInitializationIssue => 'App Initialization Issue';

  @override
  String get troubleConnectingServices =>
      'We\'re having trouble connecting to our services. This might be due to network issues or maintenance.';

  @override
  String get exit => 'Exit';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get pageNotFoundDescription =>
      'The page you are looking for doesn\'t exist or has been moved.';

  @override
  String loginAs(String role) {
    return 'Login as $role';
  }

  @override
  String get logApiResponseLabel => 'RESPONSE';

  @override
  String logAuthEventMessage(String event) {
    return 'Auth: $event';
  }

  @override
  String logRoleActionMessage(String role, String action) {
    return '$role action: $action';
  }

  @override
  String logPgActionMessage(String action) {
    return 'PG $action';
  }

  @override
  String logPaymentEventMessage(String event) {
    return 'Payment: $event';
  }

  @override
  String logFoodActionMessage(String action) {
    return 'Food $action';
  }

  @override
  String logComplaintEventMessage(String event) {
    return 'Complaint: $event';
  }

  @override
  String logGuestActionMessage(String action) {
    return 'Guest $action';
  }

  @override
  String logOwnerActionMessage(String action) {
    return 'Owner $action';
  }

  @override
  String logMethodEntryMessage(String methodName) {
    return 'Entering $methodName';
  }

  @override
  String logMethodExitMessage(String methodName) {
    return 'Exiting $methodName';
  }

  @override
  String logPerformanceMessage(String operation, int durationMs) {
    return 'Performance: $operation took ${durationMs}ms';
  }

  @override
  String logBusinessEventMessage(String event) {
    return 'Business event: $event';
  }

  @override
  String get enterPhoneNumberToReceiveOTP =>
      'Enter your phone number to receive OTP';

  @override
  String get tenDigitMobileNumber => '10-digit mobile number';

  @override
  String get phoneAuthentication => 'Phone Authentication';

  @override
  String get notAvailableOnMacOS =>
      'Not available on macOS. Please use Google Sign-In below.';

  @override
  String get sixDigitCode => '6-digit code';

  @override
  String get pleaseEnterSixDigitCode =>
      'Please enter the 6-digit code sent to your phone';

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get personal => 'Personal';

  @override
  String get documents => 'Documents';

  @override
  String get emergency => 'Emergency';

  @override
  String get areYouSureYouWantToLogout => 'Are you sure you want to logout?';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String get logoutFailed => 'Logout failed';

  @override
  String get switchAccount => 'Switch Account';

  @override
  String switchAccountConfirmation(String currentRole, String newRole) {
    return 'Are you sure you want to switch from $currentRole to $newRole account?\n\nYou will need to complete registration for the new role.';
  }

  @override
  String switchedToAccount(String role) {
    return 'Switched to $role account. Please complete your registration.';
  }

  @override
  String get switchButton => 'Switch';

  @override
  String get role => 'Role';

  @override
  String get verifiedOwner => 'Verified Owner';

  @override
  String get pendingVerification => 'Pending Verification';

  @override
  String get pgManagementSystem => 'PG Management System';

  @override
  String get madeWithLoveByAtitiaTeam => 'Made with ❤️ by Atitia Team';

  @override
  String get version => 'Version';

  @override
  String get poweredByCharyatani => 'Powered by Charyatani';

  @override
  String get chooseHowYouWantToUseTheApp =>
      'Choose how you want to use the app';

  @override
  String get findAndBookPgAccommodations => 'Find and book PG accommodations';

  @override
  String get manageYourPgPropertiesAndGuests =>
      'Manage your PG properties and guests';

  @override
  String get requestTimedOutPleaseTryAgain =>
      'Request timed out. Please try again.';

  @override
  String get googleSignInOnWebRequiresButton =>
      'Google Sign-In on web requires the sign-in button. Please use the Google Sign-In button above.';

  @override
  String get googleSignInTimedOut =>
      'Google Sign-In timed out. Please try again.';

  @override
  String googleSignInFailed(String error) {
    return 'Google Sign-In failed: $error';
  }

  @override
  String get briefDescriptionOfYourComplaint =>
      'Brief description of your complaint';

  @override
  String get detailedDescriptionOfYourComplaint =>
      'Detailed description of your complaint or request';

  @override
  String get subjectRequired => 'Subject is required';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get imageAttachment => 'Image Attachment';

  @override
  String get attachImage => 'Attach Image';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get requestTimedOut => 'Request timed out';

  @override
  String get pleaseTryAgain => 'Please try again';

  @override
  String get phoneNumberIsRequired => 'Phone number is required';

  @override
  String get pleaseEnterValid10DigitPhoneNumber =>
      'Please enter a valid 10-digit phone number';

  @override
  String get otpIsRequired => 'OTP is required';

  @override
  String get otpMustBe6Digits => 'OTP must be 6 digits';

  @override
  String get otpMustContainOnlyDigits => 'OTP must contain only digits';

  @override
  String get authenticationFailedPleaseSelectCorrectRole =>
      'Authentication failed. Please select the correct role.';

  @override
  String get userDataNotFound => 'User data not found';

  @override
  String get invalidUserRolePleaseSelectRole =>
      'Invalid user role. Please select a role.';

  @override
  String verificationFailed(String error) {
    return 'Verification failed: $error';
  }

  @override
  String googleSignInFailedError(String error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String get otpSentSuccessfullyPleaseCheckYourPhone =>
      'OTP sent successfully! Please check your phone.';

  @override
  String get failedToSendOtpPleaseTryAgain =>
      'Failed to send OTP. Please try again.';

  @override
  String get tooManyRequestsPleaseWaitFewMinutes =>
      'Too many requests. Please wait a few minutes before trying again.';

  @override
  String get smsServiceTemporarilyUnavailable =>
      'SMS service temporarily unavailable. Please try again later.';

  @override
  String get securityVerificationFailedPleaseTryAgain =>
      'Security verification failed. Please try again.';

  @override
  String get optional => 'Optional';

  @override
  String get attachPhotosOptional => 'Attach Photos (Optional)';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get complaintSubmittedSuccessfully =>
      'Complaint submitted successfully';

  @override
  String get submissionFailed => 'Submission failed';

  @override
  String get submitNewComplaint => 'Submit New Complaint';

  @override
  String get submitComplaint => 'Submit Complaint';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get yourRegisteredPhoneNumber => 'Your registered phone number';

  @override
  String get verifiedDuringLogin => '✓ Verified during login';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameIsRequired => 'Full name is required';

  @override
  String get nameMustBeAtLeast3Characters =>
      'Name must be at least 3 characters';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get aadhaarNumberIsRequired => 'Aadhaar number is required';

  @override
  String get aadhaarMustBe12Digits => 'Aadhaar must be 12 digits';

  @override
  String get aadhaarMustContainOnlyDigits => 'Aadhaar must contain only digits';

  @override
  String get aadhaarDocumentUploadedSuccessfully =>
      'Aadhaar document uploaded successfully!';

  @override
  String get contactNameIsRequired => 'Contact name is required';

  @override
  String get contactPhoneIsRequired => 'Contact phone is required';

  @override
  String get pleaseSelectRelationship => 'Please select relationship';

  @override
  String get contactAddressOptional => 'Contact Address (Optional)';

  @override
  String get allRequiredFieldsCompletedReadyToSubmit =>
      'All required fields completed! Ready to submit.';

  @override
  String get pleaseProvideYourDetailsAsPerOfficialDocuments =>
      'Please provide your details as per your official documents';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get aadhaarDocument => 'Aadhaar Document';

  @override
  String get yourDocumentsAreSecurelyStored =>
      'Your documents are securely stored and used only for verification purposes';

  @override
  String get provideDetailsOfSomeoneWeCanContact =>
      'Provide details of someone we can contact in case of emergency';

  @override
  String get continueButton => 'Continue';

  @override
  String get finish => 'Finish';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get errorUpdatingProfile => 'Error updating profile';

  @override
  String get pgs => 'PGs';

  @override
  String get foods => 'Foods';

  @override
  String get requests => 'Requests';

  @override
  String get browsePgAccommodations => 'Browse PG Accommodations';

  @override
  String get viewFoodMenu => 'View Food Menu';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get bookingRequests => 'Booking Requests';

  @override
  String get complaintsAndRequests => 'Complaints & Requests';

  @override
  String get findYourPg => 'Find Your PG';

  @override
  String get searchAndFilters => 'Search & Filters';

  @override
  String get hideFilters => 'Hide Filters';

  @override
  String get showFilters => 'Show Filters';

  @override
  String get pgsAvailable => 'PGs Available';

  @override
  String get cities => 'Cities';

  @override
  String get amenities => 'Amenities';

  @override
  String get searchByNameCityArea => 'Search by name, city, area...';

  @override
  String get filters => 'Filters';

  @override
  String get clearAll => 'Clear All';

  @override
  String get activeFilters => 'Active Filters';

  @override
  String get noPgsFound => 'No PGs Found';

  @override
  String get noPgsFoundDescription =>
      'Try adjusting your search or filters to find more options.';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get today => 'Today';

  @override
  String get noMenuAvailable => 'No Menu Available';

  @override
  String get noMenuAvailableDescription => 'Menu will be available soon.';

  @override
  String get refresh => 'Refresh';

  @override
  String get refreshMenu => 'Refresh Menu';

  @override
  String get likeTodaysMenu => 'Like Today\'s Menu';

  @override
  String get dislike => 'Dislike';

  @override
  String get menuNote => 'Menu Note';

  @override
  String get foodGallery => 'Food Gallery';

  @override
  String noMenuForDay(String day) {
    return 'No Menu for $day';
  }

  @override
  String get ownerHasntSetMenuForDay =>
      'The owner hasn\'t set a menu for this day yet.';

  @override
  String get errorLoadingMenu => 'Error Loading Menu';

  @override
  String get unableToLoadMenuPleaseTryAgain =>
      'Unable to load menu. Please try again.';

  @override
  String get foodMenuStatistics => 'Food Menu Statistics';

  @override
  String get weeklyMenus => 'Weekly Menus';

  @override
  String get like => 'Like';

  @override
  String get todayMenu => 'Today\'s Menu';

  @override
  String get history => 'History';

  @override
  String get sendPayment => 'Send Payment';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get message => 'Message';

  @override
  String get ownerResponse => 'Owner Response';

  @override
  String get ownerPaymentDetails => 'Owner Payment Details';

  @override
  String get upiId => 'UPI ID';

  @override
  String get upiQrCode => 'UPI QR Code';

  @override
  String get sendPaymentNotification => 'Send Payment Notification';

  @override
  String get afterMakingPaymentUploadScreenshot =>
      'After making payment, upload screenshot and notify owner';

  @override
  String get addComplaint => 'Add Complaint';

  @override
  String get complaints => 'Complaints';

  @override
  String get noComplaintsFound => 'No Complaints Found';

  @override
  String get noComplaintsFoundDescription =>
      'You haven\'t submitted any complaints yet. Tap the + button to add one.';

  @override
  String get all => 'All';

  @override
  String get resolved => 'Resolved';

  @override
  String get inProgress => 'In Progress';

  @override
  String get total => 'Total';

  @override
  String get myComplaints => 'My Complaints';

  @override
  String get noComplaintsFoundWithSelectedFilter =>
      'No complaints found with the selected filter';

  @override
  String get noComplaintsYet => 'No Complaints Yet';

  @override
  String get noComplaintsYetDescription =>
      'You haven\'t submitted any complaints yet. Tap the + button to add your first complaint.';

  @override
  String get errorLoadingComplaints => 'Error Loading Complaints';

  @override
  String get unableToLoadComplaints => 'Unable to load complaints';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get loadingYourProfile => 'Loading your profile...';

  @override
  String get errorLoadingProfile => 'Error Loading Profile';

  @override
  String get profilePhotos => 'Profile Photos';

  @override
  String get aadhaarPhoto => 'Aadhaar Photo';

  @override
  String failedToUploadProfilePhoto(String error) {
    return 'Failed to upload profile photo: $error';
  }

  @override
  String failedToUploadAadhaarPhoto(String error) {
    return 'Failed to upload Aadhaar photo: $error';
  }

  @override
  String get noProfileDataFound => 'No profile data found';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get vegetarian => 'Vegetarian';

  @override
  String get nonVegetarian => 'Non-Vegetarian';

  @override
  String get single => 'Single';

  @override
  String get married => 'Married';

  @override
  String get foodPreference => 'Food Preference';

  @override
  String get maritalStatus => 'Marital Status';

  @override
  String get other => 'Other';

  @override
  String get contactAndGuardianInformation => 'Contact & Guardian Information';

  @override
  String get currentAddress => 'Current Address';

  @override
  String get guardianName => 'Guardian Name';

  @override
  String get guardianPhone => 'Guardian Phone';

  @override
  String get preferences => 'Preferences';

  @override
  String get eggetarian => 'Eggetarian';

  @override
  String get divorced => 'Divorced';

  @override
  String get items => 'Items';

  @override
  String get overview => 'Overview';

  @override
  String get food => 'Food';

  @override
  String get guests => 'Guests';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get properties => 'Properties';

  @override
  String get activeTenants => 'Active Tenants';

  @override
  String get occupancy => 'Occupancy';

  @override
  String get pendingBookings => 'Pending Bookings';

  @override
  String get pendingComplaints => 'Pending Complaints';

  @override
  String get refreshDashboard => 'Refresh Dashboard';

  @override
  String get loadingDashboard => 'Loading dashboard...';

  @override
  String get errorLoadingDashboard => 'Error Loading Dashboard';

  @override
  String get dashboardDataWillAppearHere =>
      'Dashboard data will appear here once you add properties';

  @override
  String get welcome => 'Welcome';

  @override
  String get heresYourBusinessOverview => 'Here\'s your business overview';

  @override
  String get performance => 'Performance';

  @override
  String get monthlyRevenue => 'Monthly Revenue';

  @override
  String get propertyBreakdown => 'Property Breakdown';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addProperty => 'Add Property';

  @override
  String get addTenant => 'Add Tenant';

  @override
  String get viewReports => 'View Reports';

  @override
  String get propertyRevenue => 'Property Revenue';

  @override
  String totalRevenueWithPgs(int count) {
    return 'Total Revenue ($count PGs)';
  }

  @override
  String get createPgMenus => 'Create PG Menus';

  @override
  String get specialMenus => 'Special Menus';

  @override
  String get loadingMenus => 'Loading menus...';

  @override
  String get failedToLoadMenus => 'Failed to load menus';

  @override
  String get noPgMenusFound => 'No PG Menus Found';

  @override
  String get createWeeklyMenusForThisPg =>
      'Create weekly menus for this PG to get started';

  @override
  String get useCreatePgMenusButton =>
      'Use the \"Create PG Menus\" button in the app bar to get started';

  @override
  String get createPgWeeklyMenus => 'Create PG Weekly Menus';

  @override
  String get thisWillCreateDefaultMenuTemplates =>
      'This will create default menu templates for all 7 days of the week for this PG. You can edit them later.';

  @override
  String get initialize => 'Initialize';

  @override
  String get defaultMenusInitializedSuccessfully =>
      'Default menus initialized successfully';

  @override
  String get failedToInitializeMenus => 'Failed to initialize menus';

  @override
  String failedToInitializeMenusWithError(String error) {
    return 'Failed to initialize menus: $error';
  }

  @override
  String get specialMenuOptions => 'Special Menu Options';

  @override
  String get addFestivalMenu => 'Add Festival Menu';

  @override
  String get createSpecialMenuForFestivals =>
      'Create special menu for festivals';

  @override
  String get addEventMenu => 'Add Event Menu';

  @override
  String get createSpecialMenuForEvents => 'Create special menu for events';

  @override
  String get viewAllSpecialMenus => 'View All Special Menus';

  @override
  String get manageExistingSpecialMenus => 'Manage existing special menus';

  @override
  String get editMenu => 'Edit Menu';

  @override
  String get guestFeedbackToday => 'Guest Feedback (Today)';

  @override
  String get breakfastTime => '7:00 AM - 10:00 AM';

  @override
  String get lunchTime => '12:00 PM - 3:00 PM';

  @override
  String get dinnerTime => '7:00 PM - 10:00 PM';

  @override
  String get createMenuForThisDay =>
      'Create a menu for this day to get started';

  @override
  String get createMenu => 'Create Menu';

  @override
  String get special => 'Special';

  @override
  String get weeklyMenuManagement => 'Weekly Menu Management';

  @override
  String get manageBreakfastLunchDinnerForAllDays =>
      'Manage breakfast, lunch & dinner for all days';

  @override
  String get days => 'Days';

  @override
  String get photos => 'Photos';

  @override
  String get festival => 'Festival';

  @override
  String get ownerFoodNoItemsAddedYet => 'No items added yet';

  @override
  String get specialMenuLabel => 'Special Menu';

  @override
  String get dayShortMon => 'Mon';

  @override
  String get dayShortTue => 'Tue';

  @override
  String get dayShortWed => 'Wed';

  @override
  String get dayShortThu => 'Thu';

  @override
  String get dayShortFri => 'Fri';

  @override
  String get dayShortSat => 'Sat';

  @override
  String get dayShortSun => 'Sun';

  @override
  String get noRequests => 'No Requests';

  @override
  String get bookingAndBedChangeRequestsWillAppearHere =>
      'Booking and bed change requests will appear here';

  @override
  String get bedChanges => 'Bed Changes';

  @override
  String get complaintsFromGuestsWillAppearHere =>
      'Complaints from guests will appear here';

  @override
  String get complaint => 'Complaint';

  @override
  String get guest => 'Guest';

  @override
  String get reply => 'Reply';

  @override
  String get resolve => 'Resolve';

  @override
  String get replyToComplaint => 'Reply to Complaint';

  @override
  String get typeYourReply => 'Type your reply...';

  @override
  String get send => 'Send';

  @override
  String get replySent => 'Reply sent';

  @override
  String get failedToSendReply => 'Failed to send reply';

  @override
  String get resolveComplaint => 'Resolve Complaint';

  @override
  String get resolutionNotesOptional => 'Resolution notes (optional)...';

  @override
  String get markResolved => 'Mark Resolved';

  @override
  String get complaintResolved => 'Complaint resolved';

  @override
  String get failedToResolve => 'Failed to resolve';

  @override
  String get refreshGuestData => 'Refresh Guest Data';

  @override
  String get loadingGuestData => 'Loading guest data...';

  @override
  String get errorLoadingData => 'Error Loading Data';

  @override
  String get bedMap => 'Bed Map';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get refreshPgData => 'Refresh PG Data';

  @override
  String get noPgsListedYet => 'No PGs Listed Yet';

  @override
  String get tapButtonBelowToListFirstPg =>
      'Tap the button below to list your first PG';

  @override
  String get listYourFirstPg => 'List Your First PG';

  @override
  String get loadingPgData => 'Loading PG data...';

  @override
  String get bookingsOverview => 'Bookings Overview';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get occupied => 'Occupied';

  @override
  String get vacant => 'Vacant';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get noGuests => 'No Guests';

  @override
  String get guestListWillAppearHereOnceGuestsAreAdded =>
      'Guest list will appear here once guests are added';

  @override
  String get selected => 'selected';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get selectAll => 'Select All';

  @override
  String get changeStatus => 'Change Status';

  @override
  String get deleteSelected => 'Delete Selected';

  @override
  String updatedGuestsToStatus(int count, String status) {
    return 'Updated $count guests to $status';
  }

  @override
  String get confirmBulkDelete => 'Confirm Bulk Delete';

  @override
  String areYouSureYouWantToDeleteGuests(int count) {
    return 'Are you sure you want to delete $count guests? This action cannot be undone.';
  }

  @override
  String get guestsDeletedSuccessfully => 'Guests deleted successfully';

  @override
  String get totalGuests => 'Total Guests';

  @override
  String get activeGuests => 'Active Guests';

  @override
  String get pendingGuests => 'Pending Guests';

  @override
  String get found => 'found';

  @override
  String get guestOverview => 'Guest Overview';

  @override
  String get recordPayment => 'Record Payment';

  @override
  String get atitiaIsAComprehensivePgManagementPlatform =>
      'Atitia is a comprehensive PG management platform that connects PG owners with guests, streamlining bookings, payments, and daily operations.';

  @override
  String get features => 'Features:';

  @override
  String get easyPgPropertyManagement => '• Easy PG property management';

  @override
  String get secureOnlinePayments => '• Secure online payments';

  @override
  String get realTimeNotifications => '• Real-time notifications';

  @override
  String get menuManagement => '• Menu management';

  @override
  String get complaintTracking => '• Complaint tracking';

  @override
  String get visitorManagement => '• Visitor management';

  @override
  String get copyrightAtitiaAllRightsReserved =>
      '© 2025 Atitia. All rights reserved.';

  @override
  String get charyataniTechnologies => 'Charyatani Technologies';

  @override
  String get weAreALeadingSoftwareDevelopmentCompany =>
      'We are a leading software development company specializing in mobile and web applications for hospitality and property management.';

  @override
  String get contactUs => 'Contact Us:';

  @override
  String get copyrightCharyataniTechnologies =>
      '© 2025 Charyatani Technologies Pvt. Ltd.';

  @override
  String get allRightsReserved => 'All rights reserved.';

  @override
  String get aboutApp => 'About App';

  @override
  String get aboutDeveloper => 'About Developer';

  @override
  String get switchToGuest => 'Switch to Guest';

  @override
  String get switchToOwner => 'Switch to Owner';

  @override
  String get owner => 'Owner';

  @override
  String get failedToSwitchAccount => 'Failed to switch account';

  @override
  String get notifications => 'Notifications';

  @override
  String get userMenu => 'User Menu';

  @override
  String get system => 'System';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get or => 'OR';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get enterYourCompleteName => 'Enter your complete name';

  @override
  String get age => 'Age';

  @override
  String get years => 'years';

  @override
  String get emailAddressOptional => 'Email Address (Optional)';

  @override
  String get yourEmailExampleCom => 'your.email@example.com';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get uploadClearPhotosOfYourDocuments =>
      'Upload clear photos of your documents for verification';

  @override
  String get uploadClearPhotoOfYourself => 'Upload a clear photo of yourself';

  @override
  String get uploadYourAadhaarCard =>
      'Upload your Aadhaar card (front or back)';

  @override
  String get aadhaarNumber => 'Aadhaar Number';

  @override
  String get enter12DigitAadhaarNumber => 'Enter 12-digit Aadhaar number';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get contactName => 'Contact Name';

  @override
  String get fullNameOfEmergencyContact => 'Full name of emergency contact';

  @override
  String get contactRelation => 'Relation';

  @override
  String get fullAddressOfEmergencyContact =>
      'Full address of emergency contact';

  @override
  String get father => 'Father';

  @override
  String get mother => 'Mother';

  @override
  String get brother => 'Brother';

  @override
  String get sister => 'Sister';

  @override
  String get spouse => 'Spouse';

  @override
  String get friend => 'Friend';

  @override
  String get pleaseSelectPgFirst => 'Please select a PG first';

  @override
  String get invalidPgSelectionOwnerInfoNotAvailable =>
      'Invalid PG selection. Owner information not available.';

  @override
  String get paymentSuccessfulOwnerWillBeNotified =>
      'Payment successful! Owner will be notified.';

  @override
  String paymentFailed(String message) {
    return 'Payment failed: $message';
  }

  @override
  String failedToProcessPayment(String error) {
    return 'Failed to process payment: $error';
  }

  @override
  String get pleaseUploadPaymentScreenshot =>
      'Please upload payment screenshot. Transaction ID is visible in the screenshot.';

  @override
  String failedToSendNotification(String error) {
    return 'Failed to send notification: $error';
  }

  @override
  String get uploadPaymentScreenshot => 'Upload Payment Screenshot';

  @override
  String get pleaseSelectPgFirstToFileComplaint =>
      'Please select a PG first to file a complaint';

  @override
  String get submitFirstComplaint => 'Submit First Complaint';

  @override
  String get viewDetails => 'View Details';

  @override
  String get editGuest => 'Edit Guest';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get callGuest => 'Call Guest';

  @override
  String get checkOut => 'Check Out';

  @override
  String get guestUpdatedSuccessfully => 'Guest updated successfully';

  @override
  String get messages => 'Messages:';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get replyToServiceRequest => 'Reply to Service Request';

  @override
  String get sendReply => 'Send Reply';

  @override
  String get pleaseFillInAllFields => 'Please fill in all fields';

  @override
  String get serviceRequestSubmitted => 'Service request submitted';

  @override
  String get replySentSuccessfully => 'Reply sent successfully';

  @override
  String failedToUpdateStatus(String error) {
    return 'Failed to update status: $error';
  }

  @override
  String get completeService => 'Complete Service';

  @override
  String get completionNotes => 'Completion Notes';

  @override
  String get completionNotesOptional => 'Completion notes (optional)...';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get serviceCompletedSuccessfully => 'Service completed successfully';

  @override
  String get editBike => 'Edit Bike';

  @override
  String get bikeUpdatedSuccessfully => 'Bike updated successfully';

  @override
  String get moveBike => 'Move Bike';

  @override
  String currentSpot(String spot) {
    return 'Current spot: $spot';
  }

  @override
  String get removeBike => 'Remove Bike';

  @override
  String areYouSureYouWantToRemoveBike(String bikeName) {
    return 'Are you sure you want to remove $bikeName?';
  }

  @override
  String get bikeRemovalRequestCreated => 'Bike removal request created';

  @override
  String get bikeMovementRequestCreated => 'Bike movement request created';

  @override
  String get invalidPaymentOrOwnerInfoNotAvailable =>
      'Invalid payment or owner information not available.';

  @override
  String get paymentSuccessful => 'Payment successful!';

  @override
  String get upiPaymentNotificationSent =>
      'UPI payment notification sent. Owner will verify and confirm.';

  @override
  String failedToProcessUpiPayment(String error) {
    return 'Failed to process UPI payment: $error';
  }

  @override
  String get cashPaymentNotificationSent =>
      'Cash payment notification sent. Owner will confirm once they receive the payment.';

  @override
  String failedToProcessCashPayment(String error) {
    return 'Failed to process cash payment: $error';
  }

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get changeScreenshot => 'Change Screenshot';

  @override
  String get cashPaymentConfirmation => 'Cash Payment Confirmation';

  @override
  String get haveYouPaidAmountInCash =>
      'Have you paid the amount in cash to the owner? Owner will confirm once they receive the payment.';

  @override
  String get yesPaid => 'Yes, Paid';

  @override
  String get paymentDetailsSavedSuccessfully =>
      'Payment details saved successfully';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get unknownError => 'Unknown error';

  @override
  String get saveDraft => 'Save Draft';

  @override
  String get publish => 'Publish';

  @override
  String get updating => 'Updating...';

  @override
  String get creating => 'Creating...';

  @override
  String get updatePg => 'Update PG';

  @override
  String get createPg => 'Create PG';

  @override
  String get pleaseEnterPgNameBeforePublishing =>
      'Please enter PG name before publishing';

  @override
  String get pgPublishedSuccessfully => 'PG published successfully';

  @override
  String get draftSaved => 'Draft saved';

  @override
  String failedToSelectPhotos(String error) {
    return 'Failed to select photos: $error';
  }

  @override
  String get guestName => 'Guest Name';

  @override
  String get searchGuestsLabel => 'Search Guests';

  @override
  String get searchGuestsHint => 'Search by name, phone, room, or email...';

  @override
  String get statusNew => 'New';

  @override
  String get statusVip => 'VIP';

  @override
  String get exportData => 'Export Data';

  @override
  String get guestDataExportedSuccessfully =>
      'Guest data exported successfully';

  @override
  String get guestListTitle => 'Guest List';

  @override
  String guestCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guests',
      one: '1 guest',
      zero: '0 guests',
    );
    return '$_temp0';
  }

  @override
  String get noGuestsYet => 'No Guests Yet';

  @override
  String get guestsAppearAfterBooking =>
      'Guests will appear here once they book your PG';

  @override
  String get checkIn => 'Check-in';

  @override
  String get duration => 'Duration';

  @override
  String get emergencyPhone => 'Emergency Phone';

  @override
  String get occupation => 'Occupation';

  @override
  String get company => 'Company';

  @override
  String messageToGuest(String name) {
    return 'To: $name';
  }

  @override
  String get enterMessageHint => 'Enter your message...';

  @override
  String get messageSentSuccessfully => 'Message sent successfully';

  @override
  String get checkOutGuest => 'Check Out Guest';

  @override
  String get checkOutGuestConfirmation =>
      'Are you sure you want to check out this guest? This action cannot be undone.';

  @override
  String get guestCheckedOutSuccessfully => 'Guest checked out successfully';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get emailLabel => 'Email';

  @override
  String get emergencyContactLabel => 'Emergency Contact';

  @override
  String get emergencyPhoneLabel => 'Emergency Phone';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get parkingSpot => 'Parking Spot';

  @override
  String get notes => 'Notes';

  @override
  String get complete => 'Complete';

  @override
  String get resolutionNotes => 'Resolution Notes';

  @override
  String get markAsResolved => 'Mark as Resolved';

  @override
  String get complaintResolvedSuccessfully => 'Complaint resolved successfully';

  @override
  String get serviceType => 'Service Type';

  @override
  String get serviceDescription => 'Service Description';

  @override
  String get describeTheServiceNeeded => 'Describe the service needed...';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get replyLabel => 'Reply';

  @override
  String get uPI => 'UPI';

  @override
  String get amountLabel => 'Amount:';

  @override
  String get weeklyMenuPreview => 'Weekly Menu Preview';

  @override
  String get totalItems => 'Total Items';

  @override
  String get breakfastItems => 'Breakfast Items';

  @override
  String get lunchItems => 'Lunch Items';

  @override
  String get dinnerItems => 'Dinner Items';

  @override
  String get snackItems => 'Snack Items';

  @override
  String get complaintStatistics => 'Complaint Statistics';

  @override
  String get totalComplaints => 'Total Complaints';

  @override
  String get highPriority => 'High Priority';

  @override
  String get thisMonth => 'This Month';

  @override
  String get recentComplaintsPreview => 'Recent Complaints Preview';

  @override
  String get category => 'Category';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get maintenanceIssues => 'Maintenance Issues';

  @override
  String get cleanliness => 'Cleanliness';

  @override
  String get foodQuality => 'Food Quality';

  @override
  String get noiseComplaints => 'Noise Complaints';

  @override
  String get backToPayments => 'Back to Payments';

  @override
  String get payNow => 'Pay Now';

  @override
  String get processing => 'Processing...';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get paymentNotFound => 'Payment Not Found';

  @override
  String get theRequestedPaymentCouldNotBeFound =>
      'The requested payment could not be found.';

  @override
  String get dueDate => 'Due Date';

  @override
  String get paymentDate => 'Payment Date';

  @override
  String get uPIReference => 'UPI Reference';

  @override
  String get pgId => 'PG ID';

  @override
  String get ownerId => 'Owner ID';

  @override
  String get timeline => 'Timeline';

  @override
  String get created => 'Created';

  @override
  String get paid => 'Paid';

  @override
  String get transactionIdOptional => 'Transaction ID (Optional)';

  @override
  String get transactionIdIsVisibleInScreenshot =>
      'Transaction ID is visible in screenshot';

  @override
  String get youCanSkipThisTransactionIdIsInScreenshot =>
      'You can skip this - transaction ID is in the screenshot';

  @override
  String get pleaseEnterAmount => 'Please enter amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter valid amount';

  @override
  String get notRequiredAlreadyVisibleInScreenshot =>
      'Not required - already visible in screenshot';

  @override
  String get messageOptional => 'Message (Optional)';

  @override
  String get paymentInformation => 'Payment Information';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get searchServices => 'Search Services';

  @override
  String get searchByTitleGuestRoomOrType =>
      'Search by title, guest, room, or type...';

  @override
  String get createNewServiceRequest => 'Create New Service Request';

  @override
  String get priority => 'Priority';

  @override
  String get requested => 'Requested';

  @override
  String get assignedTo => 'Assigned To';

  @override
  String get serviceRequest => 'Service Request';

  @override
  String get serviceTitle => 'Service Title';

  @override
  String get room => 'Room';

  @override
  String get roomNumber => 'Room number';

  @override
  String get housekeeping => 'Housekeeping';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get start => 'Start';

  @override
  String get resume => 'Resume';

  @override
  String get details => 'Details';

  @override
  String get advancedSearch => 'Advanced Search';

  @override
  String get pgNotFound => 'PG Not Found';

  @override
  String get pricingAvailability => 'Pricing & Availability';

  @override
  String get locationVicinity => 'Location & Vicinity';

  @override
  String get facilitiesAmenities => 'Facilities & Amenities';

  @override
  String get foodMealInformation => 'Food & Meal Information';

  @override
  String get rulesPolicies => 'Rules & Policies';

  @override
  String get contactOwnerInformation => 'Contact & Owner Information';

  @override
  String get callOwner => 'Call Owner';

  @override
  String get sharePg => 'Share PG';

  @override
  String get requestBooking => 'Request Booking';

  @override
  String get couldNotOpenMaps => 'Could not open maps';

  @override
  String get pgInformationNotAvailable => 'PG information not available';

  @override
  String failedToShare(String error) {
    return 'Failed to share: $error';
  }

  @override
  String get searchBikes => 'Search Bikes';

  @override
  String get searchByNumberNameGuestOrModel =>
      'Search by number, name, guest, or model...';

  @override
  String get searchComplaints => 'Search Complaints';

  @override
  String get searchByTitleGuestRoomOrDescription =>
      'Search by title, guest, room, or description...';

  @override
  String get yourCurrentResidentialAddress =>
      'Your current residential address';

  @override
  String get nameOfYourParentOrGuardian => 'Name of your parent or guardian';

  @override
  String get tenDigitPhoneNumber => '10-digit phone number';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Please enter valid 10-digit phone number';

  @override
  String get bank => 'Bank';

  @override
  String get qrCode => 'QR Code';

  @override
  String get configureHowGuestsCanPayYou => 'Configure how guests can pay you';

  @override
  String get bankAccountDetails => 'Bank Account Details';

  @override
  String get addYourBankAccountDetailsForDirectTransfers =>
      'Add your bank account details for direct transfers';

  @override
  String get bankName => 'Bank Name';

  @override
  String get accountHolderName => 'Account Holder Name';

  @override
  String get enterAccountNumber => 'Enter account number';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get uPIDetails => 'UPI Details';

  @override
  String get addYourUpiIdForInstantPayments =>
      'Add your UPI ID for instant payments';

  @override
  String get upiID => 'UPI ID';

  @override
  String get paymentInstructionsOptional => 'Payment Instructions (Optional)';

  @override
  String get uploadYourUpiQrCodeFromAnyPaymentApp =>
      'Upload your UPI QR code from any payment app';

  @override
  String get changeQrCode => 'Change QR Code';

  @override
  String get uploadQrCode => 'Upload QR Code';

  @override
  String get savePaymentDetails => 'Save Payment Details';

  @override
  String get editPg => 'Edit PG';

  @override
  String get newPgSetup => 'New PG Setup';

  @override
  String get basic => 'Basic';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get rent => 'Rent';

  @override
  String get rentConfig => 'Rent Config';

  @override
  String get structure => 'Structure';

  @override
  String get floorStructure => 'Floor Structure';

  @override
  String get rules => 'Rules';

  @override
  String get additionalInfo => 'Additional Info';

  @override
  String get summary => 'Summary';

  @override
  String get startBuildingYourPgProfile => 'Start Building Your PG Profile';

  @override
  String get defineYourPgStructure => 'Define Your PG Structure';

  @override
  String get bedNumberingGuide => 'Bed Numbering Guide';

  @override
  String get configureRentalPricing => 'Configure Rental Pricing';

  @override
  String get addPgAmenities => 'Add PG Amenities';

  @override
  String get uploadPgPhotos => 'Upload PG Photos';

  @override
  String get progress => 'Progress';

  @override
  String get theRequestedPgCouldNotBeFoundOrMayHaveBeenRemoved =>
      'The requested PG could not be found or may have been removed.';

  @override
  String get newParkingSpot => 'New Parking Spot';

  @override
  String get reasonForMove => 'Reason for Move';

  @override
  String get reasonForRemoval => 'Reason for Removal';

  @override
  String get more => 'More';

  @override
  String get nameAsPerBankRecords => 'Name as per bank records';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get anySpecialInstructionsForGuests =>
      'Any special instructions for guests';

  @override
  String get appearance => 'Appearance';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDescription =>
      'Receive notifications on your device';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get emailNotificationsDescription => 'Receive notifications via email';

  @override
  String get paymentReminders => 'Payment Reminders';

  @override
  String get paymentRemindersDescription =>
      'Get reminders for pending payments';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get aboutSection => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get theme => 'Theme';

  @override
  String get themeDescription => 'Choose your preferred theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageDescription => 'Select your preferred language';

  @override
  String get urgent => 'Urgent';

  @override
  String get createServiceRequest => 'Create Service Request';

  @override
  String get collapse => 'Collapse';

  @override
  String get otherServices => 'Other Services';

  @override
  String get serviceRequests => 'Service Requests';

  @override
  String get noServiceRequestsYet => 'No service requests yet';

  @override
  String get serviceRequestsAppearHere =>
      'Guest service requests will appear here when submitted';

  @override
  String get serviceStarted => 'Service started';

  @override
  String get serviceStatusUpdated => 'Service status updated';

  @override
  String unreadMessagesCount(int count) {
    return '$count unread messages';
  }

  @override
  String get searchBikesHint => 'Search by number, name, guest, or model...';

  @override
  String get registered => 'Registered';

  @override
  String get violation => 'Violation';

  @override
  String get violations => 'Violations';

  @override
  String get expired => 'Expired';

  @override
  String get premium => 'Premium';

  @override
  String get totalBikes => 'Total Bikes';

  @override
  String get bikeRegistry => 'Bike Registry';

  @override
  String get noBikesRegistered => 'No Bikes Registered';

  @override
  String get guestBikesWillAppearHere =>
      'Guest bikes will appear here when registered';

  @override
  String bikeCount(int count) {
    return '$count bikes';
  }

  @override
  String get bikeNumber => 'Bike Number';

  @override
  String get bikeName => 'Bike Name';

  @override
  String get bikeType => 'Bike Type';

  @override
  String get bikeModel => 'Bike Model';

  @override
  String get bikeColor => 'Bike Color';

  @override
  String get color => 'Color';

  @override
  String get typeLabel => 'Type';

  @override
  String get registeredOn => 'Registered';

  @override
  String get lastParked => 'Last Parked';

  @override
  String get removed => 'Removed';

  @override
  String get violationLabel => 'Violation';

  @override
  String get ownerRequestedMove => 'Owner requested move';

  @override
  String get ownerRequestedRemoval => 'Owner requested removal';

  @override
  String violationWithReason(String reason) {
    return 'Violation: $reason';
  }

  @override
  String get searchComplaintsHint =>
      'Search by title, guest, room, or description...';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get statusClosed => 'Closed';

  @override
  String complaintCount(int count) {
    return '$count complaints';
  }

  @override
  String get complaintDataExportedSuccessfully =>
      'Complaint data exported successfully';

  @override
  String get complaintTitle => 'Complaint Title';

  @override
  String get priorityLevel => 'Priority Level';

  @override
  String get add => 'Add';

  @override
  String imagesSelected(int count) {
    return '$count image(s) selected';
  }

  @override
  String get commonComplaintCategories => 'Common Complaint Categories:';

  @override
  String get complaintCategoryFood => 'Food';

  @override
  String get complaintCategoryCleanliness => 'Cleanliness';

  @override
  String get complaintCategoryMaintenance => 'Maintenance';

  @override
  String get complaintCategoryWater => 'Water';

  @override
  String get complaintCategoryElectricity => 'Electricity';

  @override
  String get complaintCategoryWifi => 'Wi-Fi';

  @override
  String get complaintCategoryNoise => 'Noise';

  @override
  String get complaintCategoryGeneral => 'General';

  @override
  String todayAt(String time) {
    return 'Today $time';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get bookBed => 'Book a Bed';

  @override
  String get selectFloor => 'Select Floor';

  @override
  String get selectRoom => 'Select Room';

  @override
  String get selectBed => 'Select Bed';

  @override
  String get startDate => 'Start Date';

  @override
  String get selectStartDate => 'Select start date';

  @override
  String get bookingSummary => 'Booking Summary';

  @override
  String get sharing => 'Sharing';

  @override
  String get notSelected => 'Not selected';

  @override
  String get legacyBookingMessage =>
      'Please contact the owner directly to book this PG.';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get bookingRequestSuccess =>
      'Booking request sent! Owner will confirm shortly.';

  @override
  String bookingRequestFailed(String error) {
    return 'Failed to book: $error';
  }

  @override
  String roomOptionLabel(
      String roomNumber, String sharingType, int availableBeds) {
    return '$roomNumber ($sharingType-sharing) - $availableBeds available';
  }

  @override
  String bedLabel(String number) {
    return 'Bed $number';
  }

  @override
  String get bed => 'Bed';

  @override
  String get requestToJoinPg => 'Request to Join PG';

  @override
  String get sendBookingRequestToOwner => 'Send a booking request to the owner';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get enterYourEmailAddress => 'Enter your email address';

  @override
  String get messageOptionalHint =>
      'Any additional information for the owner...';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseEnterYourPhoneNumber => 'Please enter your phone number';

  @override
  String get pleaseEnterYourEmailAddress => 'Please enter your email address';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Please enter a valid email address';

  @override
  String get sendRequest => 'Send Request';

  @override
  String get sending => 'Sending...';

  @override
  String monthlyRentDisplay(String amount) {
    return '₹$amount/month';
  }

  @override
  String get notAvailable => 'Not available';

  @override
  String pgCountSummary(int filtered, int total) {
    return '$filtered of $total PGs';
  }

  @override
  String get errorLoadingPgs => 'Error loading PGs';

  @override
  String get unknownErrorOccurred => 'Unknown error occurred';

  @override
  String get noPgsAvailable => 'No PGs Available';

  @override
  String get pgListingsWillAppear =>
      'PG listings will appear here once they are added to the platform.';

  @override
  String get bookNow => 'Book Now';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String photosBadge(int count) {
    return '$count Photo(s)';
  }

  @override
  String get noImageAvailable => 'No Image Available';

  @override
  String distanceMeters(int meters) {
    return '${meters}m away';
  }

  @override
  String distanceKilometers(double kilometers) {
    return '${kilometers}km away';
  }

  @override
  String sharingLabel(int count) {
    return '$count Sharing';
  }

  @override
  String pgTypeLabel(String type) {
    return '$type';
  }

  @override
  String mealTypeLabel(String type) {
    return '$type';
  }

  @override
  String get noAmenitiesListed => 'No amenities listed for this PG';

  @override
  String get amenitiesSectionTitle => 'Amenities';

  @override
  String get amenitiesSectionSubtitle => 'Amenities available in this PG';

  @override
  String get noPhotosAvailable => 'No photos available';

  @override
  String get failedToLoadImage => 'Failed to load image';

  @override
  String get pgDetails => 'PG Details';

  @override
  String get errorLoadingPgDetails => 'Error loading PG details';

  @override
  String get sharingOptionsPricing => 'Sharing Options & Pricing';

  @override
  String get securityDeposit => 'Security Deposit';

  @override
  String get perMonth => 'Per Month';

  @override
  String get oneTime => 'one-time';

  @override
  String get refundableWhenYouLeave => '(Refundable when you leave)';

  @override
  String get monthlyLabel => '(Monthly)';

  @override
  String get oneTimeLabel => '(One-time)';

  @override
  String get totalInitialPayment => 'Total Initial Payment';

  @override
  String get firstMonthRent => 'First Month Rent';

  @override
  String get totalLabel => 'Total';

  @override
  String secondMonthRentMaintenance(
      String rent, String maintenance, String total) {
    return 'From 2nd month onwards: Rent + Maintenance (₹$rent + ₹$maintenance = ₹$total)';
  }

  @override
  String secondMonthRentOnly(String rent) {
    return 'From 2nd month onwards: Only Rent (₹$rent)';
  }

  @override
  String availableTypes(String types) {
    return 'Available: $types';
  }

  @override
  String sharingLabelDefault(String count) {
    return '$count Sharing';
  }

  @override
  String get completeAddress => 'Complete Address';

  @override
  String get areaLabel => 'Area';

  @override
  String get cityLabel => 'City';

  @override
  String get stateLabel => 'State';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get mealTypeFieldLabel => 'Meal Type';

  @override
  String get pgTypeFieldLabel => 'PG Type';

  @override
  String get mealTimingsFieldLabel => 'Meal Timings';

  @override
  String get foodQualityFieldLabel => 'Food Quality';

  @override
  String get entryTimings => 'Entry Timings';

  @override
  String get exitTimings => 'Exit Timings';

  @override
  String get guestPolicy => 'Guest Policy';

  @override
  String get smokingPolicy => 'Smoking Policy';

  @override
  String get alcoholPolicy => 'Alcohol Policy';

  @override
  String get refundPolicy => 'Refund Policy';

  @override
  String get noticePeriod => 'Notice Period';

  @override
  String get ownerNameLabel => 'Owner Name';

  @override
  String get contactNumberLabel => 'Contact Number';

  @override
  String get accountHolder => 'Account Holder';

  @override
  String get qrCodeForPayment => 'QR Code for Payment';

  @override
  String get paymentInstructionsLabel => 'Payment Instructions';

  @override
  String get parkingDetails => 'Parking Details';

  @override
  String get securityMeasures => 'Security Measures';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get nearbyPlacesLabel => 'Nearby Places';

  @override
  String get pgProperty => 'PG Property';

  @override
  String sharePgHeading(String name) {
    return '🏠 $name';
  }

  @override
  String sharePgAddressLine(String address) {
    return '📍 Address: $address';
  }

  @override
  String get sharePgPricingHeader => '💰 Pricing:';

  @override
  String sharePgPricingEntry(String count, String price) {
    return '$count Share: ₹$price';
  }

  @override
  String sharePgAmenitiesLine(String amenities) {
    return '✨ Amenities: $amenities';
  }

  @override
  String get sharePgFooter => 'Check out this PG on Atitia!';

  @override
  String get myBookingRequests => 'My Booking Requests';

  @override
  String get loadingBookingRequests => 'Loading booking requests...';

  @override
  String get bookingRequestsErrorTitle => 'Error Loading Requests';

  @override
  String get bookingRequestsIntroTitle => 'Get Started with Booking Requests';

  @override
  String get bookingRequestsIntroDescription =>
      'Browse PGs and send booking requests. Owners will review and respond to your requests here.';

  @override
  String get bookingRequestSummary => 'Booking Request Summary';

  @override
  String get bookingRequestAuthDebug =>
      '⚠️ No Firebase Auth user found - user might not be authenticated';

  @override
  String bookingRequestLoadingDebug(String guestId) {
    return '🔑 Loading booking requests for guestId: $guestId';
  }

  @override
  String bookingRequestStreamErrorDebug(String error) {
    return 'Booking requests stream error: $error';
  }

  @override
  String bookingRequestExceptionDebug(String error) {
    return 'Exception loading booking requests: $error';
  }

  @override
  String get pgLocationFallback => 'Location unavailable';

  @override
  String get districtLabel => 'District';

  @override
  String get talukaMandalLabel => 'Taluka/Mandal';

  @override
  String get societyLabel => 'Society';

  @override
  String get selectPgPrompt =>
      'Please select a PG to view details and manage your stay';

  @override
  String get statusMaintenance => 'Maintenance';

  @override
  String currencyAmount(String amount) {
    return '₹$amount';
  }

  @override
  String maintenanceAmountWithFrequency(String amount, String frequency) {
    return '₹$amount/$frequency';
  }

  @override
  String get bookingRequestPending => 'Pending';

  @override
  String get bookingRequestApproved => 'Approved';

  @override
  String get bookingRequestRejected => 'Rejected';

  @override
  String bookingRequestRequestedOn(String date) {
    return 'Requested: $date';
  }

  @override
  String bookingRequestRespondedOn(String date) {
    return 'Responded: $date';
  }

  @override
  String bookingRequestFrom(String name) {
    return 'Request from: $name';
  }

  @override
  String get bookingRequestDetailsTitle => 'Booking Request Details';

  @override
  String get bookingRequestPgName => 'PG Name';

  @override
  String get bookingRequestStatus => 'Status';

  @override
  String get bookingRequestDate => 'Request Date';

  @override
  String get bookingRequestResponseDate => 'Response Date';

  @override
  String get bookingRequestOwnerResponse => 'Owner Response';

  @override
  String get bookingRequestLoadFailed => 'Failed to load booking requests';

  @override
  String get bookingRequestPermissionDenied =>
      'Permission denied. Please ensure you are logged in correctly.';

  @override
  String get bookingRequestNetworkError =>
      'Network error. Please check your connection and try again.';

  @override
  String bookingRequestGeneralError(String error) {
    return 'Failed to load booking requests: $error';
  }

  @override
  String get bookingRequestUserNotAuthenticated =>
      'User not authenticated. Please sign in again.';

  @override
  String get myRoomAndBed => 'My Room & Bed';

  @override
  String get userNotAuthenticatedRoomBed =>
      'User not authenticated. Please sign in again.';

  @override
  String failedToLoadRoomBedInformation(String error) {
    return 'Failed to load room/bed information: $error';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get noActiveBooking => 'No Active Booking';

  @override
  String get noActiveBookingDescription =>
      'You don\'t have an active booking yet. Book a PG to get assigned a room and bed.';

  @override
  String roomLabelWithNumber(String number) {
    return 'Room $number';
  }

  @override
  String bedLabelWithNumber(String number) {
    return 'Bed $number';
  }

  @override
  String get notAssigned => 'Not assigned';

  @override
  String get bookingInformation => 'Booking Information';

  @override
  String get endDate => 'End Date';

  @override
  String get requestBedRoomChange => 'Request Bed/Room Change';

  @override
  String get requestBedRoomChangeDescription =>
      'Need to change your room or bed? Submit a request and the owner will review it.';

  @override
  String get requestChange => 'Request Change';

  @override
  String get requestRoomBedChangeTitle => 'Request Room/Bed Change';

  @override
  String get currentAssignment => 'Current Assignment:';

  @override
  String get preferredRoomNumberOptional => 'Preferred Room Number (Optional)';

  @override
  String get preferredRoomNumberHint => 'Enter preferred room...';

  @override
  String get preferredBedNumberOptional => 'Preferred Bed Number (Optional)';

  @override
  String get preferredBedNumberHint => 'Enter preferred bed...';

  @override
  String get reasonRequiredLabel => 'Reason *';

  @override
  String get reasonRequiredHint => 'Why do you need to change room/bed?';

  @override
  String get provideReasonError => 'Please provide a reason for the change';

  @override
  String get changeRequestSuccess => 'Change request submitted successfully';

  @override
  String get bedChangeRequestStatus => 'Bed Change Request Status';

  @override
  String failedToLoadBedChangeRequests(String error) {
    return 'Failed to load bed change requests: $error';
  }

  @override
  String requestedLabel(String date) {
    return 'Requested: $date';
  }

  @override
  String get preferredLabel => 'Preferred:';

  @override
  String get reasonLabel => 'Reason:';

  @override
  String get ownerResponseLabel => 'Owner Response:';

  @override
  String requestedOnLabel(String date) {
    return 'Requested: $date';
  }

  @override
  String get overdue => 'Overdue';

  @override
  String get refunded => 'Refunded';

  @override
  String paymentMethodWithValue(String method) {
    return 'Payment Method: $method';
  }

  @override
  String get paymentMethodRazorpay => 'Razorpay';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodBankTransfer => 'Bank Transfer';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get noPaymentsYet => 'No Payments Yet';

  @override
  String get noPaymentsYetDescription =>
      'You haven\'t made any payments yet. Payments will appear here once you make them.';

  @override
  String get makePayment => 'Make Payment';

  @override
  String noPaymentsForFilter(String filter) {
    return 'No $filter Payments';
  }

  @override
  String noPaymentsForFilterDescription(String filter) {
    return 'You don\'t have any $filter payments at the moment.';
  }

  @override
  String failedToLoadPaymentDetails(String error) {
    return 'Failed to load payment details: $error';
  }

  @override
  String paymentNumber(String id) {
    return 'Payment #$id';
  }

  @override
  String get confirmed => 'Confirmed';

  @override
  String get upiPaymentNote => 'UPI payment made. Please verify and confirm.';

  @override
  String get cashPaymentNote => 'Cash payment made. Please confirm.';

  @override
  String get upiPaymentTip =>
      '💡 Tip: After making payment via PhonePe, Paytm, Google Pay, etc., upload the payment screenshot. The transaction ID is already visible in the screenshot.';

  @override
  String get paymentStatistics => 'Payment Statistics';

  @override
  String get totalPayments => 'Total Payments';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get recentPaymentsPreview => 'Recent Payments Preview';

  @override
  String get noPaymentHistory => 'No Payment History';

  @override
  String get noPaymentHistoryDescription =>
      'Your payment notifications and history will appear here once you make payments.';

  @override
  String get paymentDetailsNotAvailable => 'Payment Details Not Available';

  @override
  String get ownerPaymentDetailsNotConfigured =>
      'Owner payment details are not configured yet. Please contact your PG owner to set up payment information.';

  @override
  String get paymentMethodsPreview => 'Payment Methods Preview:';

  @override
  String get bankAccount => 'Bank Account';

  @override
  String get cashPaymentNotificationInfo =>
      'You will send a cash payment notification to the owner. Owner will confirm once they receive the cash.';

  @override
  String get payViaRazorpayDescription =>
      'Click \"Pay Now\" to proceed with secure online payment via Razorpay.';

  @override
  String get payViaRazorpay => 'Pay via Razorpay';

  @override
  String get upiPaymentConfirmation => 'UPI Payment Confirmation';

  @override
  String get cashPaymentNotification => 'Cash Payment Notification';

  @override
  String get sendNotification => 'Send Notification';

  @override
  String get paymentNotificationSentSuccessfully =>
      'Payment notification sent successfully';

  @override
  String get screenshotUploaded => 'Screenshot uploaded';

  @override
  String get ownerNoPaymentsTitle => 'No Payments';

  @override
  String get ownerNoPaymentsMessage =>
      'Payment records will appear here once payments are collected.';

  @override
  String get unknownGuest => 'Unknown Guest';

  @override
  String get roomBed => 'Room/Bed';

  @override
  String get markPaymentCollected => 'Mark Payment as Collected';

  @override
  String confirmMarkPaymentCollected(String amount) {
    return 'Are you sure you want to mark this payment of $amount as collected?';
  }

  @override
  String get collectedBy => 'Collected By';

  @override
  String get paymentMarkedCollected => 'Payment marked as collected';

  @override
  String failedToUpdatePayment(String error) {
    return 'Failed to update payment: $error';
  }

  @override
  String get rejectPayment => 'Reject Payment';

  @override
  String get provideRejectionReason =>
      'Please provide a reason for rejecting this payment:';

  @override
  String get rejectionReason => 'Rejection Reason';

  @override
  String get enterRejectionReason => 'Enter reason for rejection...';

  @override
  String get paymentRejected => 'Payment rejected';

  @override
  String get failedToRejectPayment => 'Failed to reject payment';

  @override
  String get paymentRejectedByOwner => 'Payment rejected by owner';

  @override
  String rejectedWithReason(String reason) {
    return 'Rejected: $reason';
  }

  @override
  String get collectedByOwnerFallback => 'Owner';

  @override
  String get recordPaymentDescription =>
      'Manually record a payment received from a guest';

  @override
  String get guestAndBooking => 'Guest & Booking';

  @override
  String get selectGuest => 'Select Guest';

  @override
  String get pleaseSelectGuest => 'Please select a guest';

  @override
  String get selectBookingOptional => 'Select Booking (Optional)';

  @override
  String get paymentAmountLabel => 'Payment Amount *';

  @override
  String get enterAmountHint => 'Enter amount in rupees';

  @override
  String get enterTransactionIdHint =>
      'Enter transaction ID or reference number';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get notesHint => 'Any additional notes about this payment';

  @override
  String get recording => 'Recording...';

  @override
  String get recordPaymentSuccess => 'Payment recorded successfully!';

  @override
  String get recordPaymentFailure => 'Failed to record payment';

  @override
  String errorRecordingPayment(String error) {
    return 'Error recording payment: $error';
  }

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get pendingPayments => 'Pending Payments';

  @override
  String pendingPaymentsWaiting(int count) {
    return '$count waiting';
  }

  @override
  String notificationsCount(int count) {
    return '$count notifications';
  }

  @override
  String get paymentConfirmedSuccessfully => 'Payment confirmed successfully';

  @override
  String transactionIdLabel(String transactionId) {
    return 'TXN: $transactionId';
  }

  @override
  String get rejectionReasonHint => 'e.g., Incorrect amount, wrong transaction';

  @override
  String get ownerNoBookingsTitle => 'No Bookings';

  @override
  String get ownerNoBookingsMessage =>
      'Booking list will appear here once bookings are created';

  @override
  String durationDays(int count) {
    return '$count days';
  }

  @override
  String get rentLabel => 'Rent';

  @override
  String get depositLabel => 'Deposit';

  @override
  String get paidLabel => 'Paid';

  @override
  String get bookingDetailsTitle => 'Booking Details';

  @override
  String get roomBedLabel => 'Room/Bed';

  @override
  String get durationLabel => 'Duration';

  @override
  String get remainingLabel => 'Remaining';

  @override
  String get statusLabel => 'Status';

  @override
  String get paymentStatusLabel => 'Payment Status';

  @override
  String get notesLabel => 'Notes';

  @override
  String get noRequestsFound => 'No requests found';

  @override
  String get bookingRequestAction => 'Action';

  @override
  String get bookingRequestDialogTitle => 'Booking Request';

  @override
  String get guestLabel => 'Guest';

  @override
  String get pgLabel => 'PG';

  @override
  String get dateLabel => 'Date';

  @override
  String get unknownPg => 'Unknown PG';

  @override
  String get unknownValue => 'Unknown';

  @override
  String get approveBookingRequestTitle => 'Approve Booking Request';

  @override
  String get rejectBookingRequestTitle => 'Reject Booking Request';

  @override
  String get approveBookingRequestSubtitle =>
      'Approve this guest\'s request to join your PG';

  @override
  String get rejectBookingRequestSubtitle =>
      'Reject this guest\'s request to join your PG';

  @override
  String get approvalDetails => 'Approval Details';

  @override
  String get rejectionDetails => 'Rejection Details';

  @override
  String get welcomeMessageOptional => 'Welcome Message (Optional)';

  @override
  String get welcomeMessageHint => 'Add a welcome message for the guest...';

  @override
  String get rejectionReasonOptional => 'Reason for Rejection (Optional)';

  @override
  String get rejectionReasonHintDetailed =>
      'Explain why the request is being rejected...';

  @override
  String get roomNumberLabel => 'Room Number *';

  @override
  String get enterRoomNumberHint => 'Enter room number...';

  @override
  String get bedNumberLabel => 'Bed Number *';

  @override
  String get enterBedNumberHint => 'Enter bed number...';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get endDateLabel => 'End Date';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get approving => 'Approving...';

  @override
  String get rejecting => 'Rejecting...';

  @override
  String get approveRequest => 'Approve Request';

  @override
  String get rejectRequest => 'Reject Request';

  @override
  String get roomBedNumbersRequired =>
      'Room and bed numbers are required for approval';

  @override
  String get bookingRequestApprovedSuccess =>
      'Booking request approved successfully!';

  @override
  String get bookingRequestRejectedSuccess =>
      'Booking request rejected successfully!';

  @override
  String bookingRequestActionFailed(String action, String error) {
    return 'Failed to $action request: $error';
  }

  @override
  String get approveAction => 'approve';

  @override
  String get rejectAction => 'reject';

  @override
  String get noBedChangeRequests => 'No Bed Change Requests';

  @override
  String get bedChangeRequestsEmptyBody =>
      'Bed change requests from guests will appear here';

  @override
  String get bedChangeRequestTitle => 'Bed Change Request';

  @override
  String get bedChangeStatusApproved => 'APPROVED';

  @override
  String get bedChangeStatusRejected => 'REJECTED';

  @override
  String get bedChangeStatusPending => 'PENDING';

  @override
  String get bedChangeCurrent => 'Current';

  @override
  String get bedChangePreferred => 'Preferred';

  @override
  String bedChangeCurrentAssignment(String room, String bed) {
    return 'Room $room, Bed $bed';
  }

  @override
  String bedChangePreferredAssignment(String room, String bed) {
    return 'Room $room, Bed $bed';
  }

  @override
  String get anyLabel => 'Any';

  @override
  String get approveBedChangeTitle => 'Approve Bed Change Request';

  @override
  String get approveBedChangeDescription =>
      'The guest will be moved to their preferred room/bed.';

  @override
  String get approvalNotesHint => 'Add approval notes...';

  @override
  String get rejectBedChangeTitle => 'Reject Bed Change Request';

  @override
  String get rejectBedChangeDescription =>
      'Please provide a reason for rejection.';

  @override
  String get rejectionReasonRequired => 'Rejection Reason *';

  @override
  String get bedChangeApproveSuccess => 'Bed change approved successfully';

  @override
  String get bedChangeApproveFailure => 'Failed to approve bed change';

  @override
  String get bedChangeRejectSuccess => 'Bed change rejected';

  @override
  String get bedChangeRejectFailure => 'Failed to reject bed change';

  @override
  String get decisionNotesLabel => 'Decision Notes';

  @override
  String get ownerBedMapNoBookingsTitle => 'No Bed Occupancy Data';

  @override
  String get ownerBedMapNoBookingsMessage =>
      'Bed occupancy map will appear here once bookings are created';

  @override
  String ownerBedMapRoom(String roomNumber) {
    return 'Room $roomNumber';
  }

  @override
  String ownerBedMapOccupiedCount(int occupied, int total) {
    return '$occupied/$total occupied';
  }

  @override
  String get occupiedLabel => 'Occupied';

  @override
  String get ownerGuestSearchHint => 'Search by name, phone, or vehicle...';

  @override
  String get ownerGuestClearSearchTooltip => 'Clear search';

  @override
  String get ownerGuestFilterAll => 'All';

  @override
  String get ownerGuestFilterActive => 'Active';

  @override
  String get ownerGuestFilterPending => 'Pending';

  @override
  String get ownerGuestFilterInactive => 'Inactive';

  @override
  String get ownerGuestFilterVehicles => 'Vehicles';

  @override
  String get ownerGuestPaymentSummaryTitle => 'Payment Summary';

  @override
  String get ownerGuestPaymentPendingLabel => 'Pending';

  @override
  String get ownerGuestPaymentCollectedLabel => 'Collected';

  @override
  String get ownerGuestDetailVehicleNumber => 'Vehicle No';

  @override
  String get ownerGuestDetailVehicle => 'Vehicle';

  @override
  String get ownerGuestDetailRoomBed => 'Room/Bed';

  @override
  String get ownerGuestDetailRent => 'Rent';

  @override
  String get ownerGuestDetailDeposit => 'Deposit';

  @override
  String get ownerGuestDetailJoined => 'Joined';

  @override
  String get ownerGuestDetailStatus => 'Status';

  @override
  String get ownerGuestUpdateRoomBed => 'Update Room/Bed';

  @override
  String get ownerGuestUpdateRoomBedTitle => 'Update Room/Bed Assignment';

  @override
  String get ownerGuestRoomNumberLabel => 'Room Number';

  @override
  String get ownerGuestRoomNumberHint => 'Enter room number';

  @override
  String get ownerGuestBedNumberLabel => 'Bed Number';

  @override
  String get ownerGuestBedNumberHint => 'Enter bed number';

  @override
  String get ownerGuestUpdateAction => 'Update';

  @override
  String get ownerGuestRoomBedUpdateSuccess => 'Room/Bed updated successfully';

  @override
  String get ownerGuestRoomBedUpdateFailure => 'Failed to update room/bed';

  @override
  String get guestDetailsTitle => 'Guest Details';

  @override
  String get bikes => 'Bikes';

  @override
  String get services => 'Services';

  @override
  String get ownerGuestNoPgSelectedTitle => 'No PG Selected';

  @override
  String get ownerGuestNoPgSelectedMessage =>
      'Please select a PG to manage guests';

  @override
  String get ownerGuestFailedToLoadData => 'Failed to load guest data';

  @override
  String get bookingRequestGuestNameLabel => 'Guest Name';

  @override
  String get bookingRequestPhoneLabel => 'Phone';

  @override
  String get bookingRequestEmailLabel => 'Email';

  @override
  String get bookingRequestPgNameLabel => 'PG Name';

  @override
  String get bookingRequestDateLabel => 'Request Date';

  @override
  String get bookingRequestStatusLabel => 'Status';

  @override
  String get bookingRequestMessageLabel => 'Message';

  @override
  String get bookingRequestResponseLabel => 'Response';

  @override
  String offlineSyncingActions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Syncing $count actions...',
      one: 'Syncing 1 action...',
      zero: 'No actions to sync',
    );
    return '$_temp0';
  }

  @override
  String get offlineStatusOffline => 'You\'re offline';

  @override
  String get offlineStatusOfflineShort => 'Offline';

  @override
  String get offlineTapToSync => 'Tap to sync';

  @override
  String get offlineSyncQueueTitle => 'Sync Queue';

  @override
  String get offlineNoPendingActions => 'No pending actions to sync';

  @override
  String offlinePendingActions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actions pending sync:',
      one: '$count action pending sync:',
    );
    return '$_temp0';
  }

  @override
  String get offlineSyncAll => 'Sync All';

  @override
  String get offlineSyncCompleted => 'Sync completed successfully!';

  @override
  String offlineSyncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get offlineSyncNow => 'Sync Now';

  @override
  String get guestBookingProcessedDefault =>
      'Your booking request has been processed';

  @override
  String get guestPaymentReminder =>
      'Payment reminder: Please complete your pending payment';

  @override
  String get guestFoodMenuUpdated =>
      'Food menu has been updated! Check out the new items';

  @override
  String guestComplaintResponseMessage(String response) {
    return 'Complaint Response: $response';
  }

  @override
  String get guestComplaintResponseDefault =>
      'Your complaint has been addressed';

  @override
  String get guestAnnouncementDefaultTitle => 'Announcement';

  @override
  String get guestAnnouncementDefaultMessage =>
      'Important announcement from your PG';

  @override
  String get notificationGuestFallbackName => 'A guest';

  @override
  String ownerBookingRequestMessage(String guestName) {
    return 'New booking request from $guestName';
  }

  @override
  String get viewAction => 'View';

  @override
  String ownerPaymentReceivedMessage(String amount, String guestName) {
    return 'Payment received: ₹$amount from $guestName';
  }

  @override
  String ownerComplaintSubmittedMessage(String guestName) {
    return 'New complaint from $guestName';
  }

  @override
  String ownerGuestCheckInMessage(String guestName) {
    return '$guestName has checked in';
  }

  @override
  String get ownerMaintenanceTaskFallback => 'maintenance task';

  @override
  String ownerMaintenanceReminderMessage(String task) {
    return 'Maintenance reminder: $task';
  }

  @override
  String get analyticsRefreshData => 'Refresh data';

  @override
  String get revenueAnalyticsTitle => 'Revenue Analytics';

  @override
  String get revenueAnalyticsSelectedPg =>
      'Performance insights for selected PG';

  @override
  String get revenueAnalyticsOverall => 'Overall revenue performance';

  @override
  String get revenueMetricTotalRevenue => 'Total Revenue';

  @override
  String get revenueMetricMonthlyGrowth => 'Monthly Growth';

  @override
  String get revenueMetricAvgPerGuest => 'Avg. per Guest';

  @override
  String get analyticsPeriodWeekly => 'Weekly';

  @override
  String get analyticsPeriodMonthly => 'Monthly';

  @override
  String get analyticsPeriodYearly => 'Yearly';

  @override
  String get analyticsMetricRevenue => 'Revenue';

  @override
  String get analyticsMetricOccupancy => 'Occupancy';

  @override
  String get analyticsMetricGuests => 'Guests';

  @override
  String get revenueTrendsLabel => 'Revenue Trends';

  @override
  String revenueTrendLastMonths(int months) {
    return 'Revenue trend (last $months months)';
  }

  @override
  String get revenueForecastTitle => 'Revenue Forecast';

  @override
  String get revenueForecastNextMonth => 'Next Month';

  @override
  String get revenueForecastNextQuarter => 'Next Quarter';

  @override
  String get revenueForecastInsightsTitle => 'Forecast Insights';

  @override
  String get revenueForecastInsufficientData =>
      'Insufficient data for forecasting';

  @override
  String get revenueForecastPositive =>
      'Based on recent trends, revenue is showing positive growth. Consider expanding capacity.';

  @override
  String get revenueForecastDecline =>
      'Based on recent trends, revenue is declining. Review pricing and marketing strategies.';

  @override
  String get revenueForecastStable =>
      'Based on recent trends, revenue is stable. Focus on maintaining current performance.';

  @override
  String get menuTooltip => 'Menu';

  @override
  String get analyticsTabRevenue => 'Revenue';

  @override
  String get analyticsTabOccupancy => 'Occupancy';

  @override
  String get analyticsTabPerformance => 'Performance';

  @override
  String get analyticsNoPgTitle => 'Select a PG';

  @override
  String get analyticsNoPgMessage =>
      'Choose a PG from the dropdown above to view analytics';

  @override
  String get analyticsLoading => 'Loading analytics data...';

  @override
  String get analyticsErrorTitle => 'Error Loading Data';

  @override
  String get analyticsUnknownError => 'Unknown error occurred';

  @override
  String analyticsLoadFailed(String error) {
    return 'Failed to load analytics data: $error';
  }

  @override
  String get performanceAnalyticsTitle => 'Performance Analytics';

  @override
  String get performanceAnalyticsSubtitle =>
      'Comprehensive performance insights and recommendations';

  @override
  String get performanceKpiTitle => 'Key Performance Indicators';

  @override
  String get performanceKpiGuestSatisfaction => 'Guest Satisfaction';

  @override
  String performanceKpiGuestSatisfactionValue(String score) {
    return '$score/5';
  }

  @override
  String get performanceKpiResponseTime => 'Response Time';

  @override
  String performanceKpiResponseTimeValue(String hours) {
    return '$hours hrs';
  }

  @override
  String get performanceKpiMaintenanceScore => 'Maintenance Score';

  @override
  String performanceKpiMaintenanceScoreValue(String score) {
    return '$score/10';
  }

  @override
  String get performanceInsightsTitle => 'Performance Insights';

  @override
  String get performanceInsightsOverall => 'Overall Performance: Excellent';

  @override
  String get performanceInsightsSummary =>
      'Your PG is performing above industry standards with high guest satisfaction and efficient operations.';

  @override
  String get performanceRecommendationsTitle => 'Recommendations:';

  @override
  String get performanceRecommendationMaintainSchedule =>
      'Continue current maintenance schedule';

  @override
  String get performanceRecommendationExpandCapacity =>
      'Consider expanding based on high occupancy';

  @override
  String get performanceRecommendationFeedbackSystem =>
      'Implement guest feedback system';

  @override
  String get performanceRecommendationOptimizeEnergy =>
      'Optimize energy usage for cost savings';

  @override
  String get occupancyAnalyticsTitle => 'Occupancy Analytics';

  @override
  String get occupancyAnalyticsSelectedPg =>
      'Occupancy insights for selected PG';

  @override
  String get occupancyAnalyticsOverall => 'Overall occupancy performance';

  @override
  String get occupancyMetricCurrent => 'Current Occupancy';

  @override
  String get occupancyMetricAverage => 'Avg. Occupancy';

  @override
  String get occupancyMetricPeak => 'Peak Occupancy';

  @override
  String get occupancyTrendsLabel => 'Occupancy Trends';

  @override
  String get occupancyViewOverview => 'Overview';

  @override
  String get occupancyViewByRoom => 'By Room';

  @override
  String get occupancyViewByFloor => 'By Floor';

  @override
  String occupancyTrendLastMonths(int months) {
    return 'Occupancy trend (last $months months)';
  }

  @override
  String get occupancyCapacityTitle => 'Capacity Analysis';

  @override
  String get occupancyCapacityAvailableBeds => 'Available Beds';

  @override
  String get occupancyCapacityOccupiedBeds => 'Occupied Beds';

  @override
  String get occupancyCapacityTotal => 'Total Capacity';

  @override
  String get occupancyInsightsTitle => 'Occupancy Insights';

  @override
  String get occupancyRecommendationsTitle => 'Recommendations:';

  @override
  String occupancyInsightsCurrentRate(String rate) {
    return 'Current occupancy is at $rate.';
  }

  @override
  String get occupancyInsightsNearFull =>
      'Your PG is nearly at full capacity. Consider expanding or opening new rooms.';

  @override
  String get occupancyInsightsGood =>
      'Good occupancy rate. Monitor trends and consider marketing strategies.';

  @override
  String get occupancyInsightsModerate =>
      'Moderate occupancy. There\'s room for improvement through better marketing.';

  @override
  String get occupancyInsightsLow =>
      'Low occupancy rate. Immediate action needed to improve bookings.';

  @override
  String get occupancyRecommendationAddCapacity =>
      'Consider adding more beds or rooms';

  @override
  String get occupancyRecommendationReviewPricing =>
      'Review pricing strategy for high demand';

  @override
  String get occupancyRecommendationMaintainOccupancy =>
      'Focus on maintaining current occupancy';

  @override
  String get occupancyRecommendationSeasonalPricing =>
      'Consider seasonal pricing adjustments';

  @override
  String get occupancyRecommendationIncreaseMarketing =>
      'Increase marketing efforts';

  @override
  String get occupancyRecommendationImproveAmenities =>
      'Review and improve amenities';

  @override
  String get occupancyRecommendationCompetitivePricing =>
      'Consider competitive pricing';

  @override
  String get occupancyRecommendationUrgentCampaign =>
      'Urgent marketing campaign needed';

  @override
  String get occupancyRecommendationReducePricing =>
      'Review and reduce pricing';

  @override
  String get occupancyRecommendationImproveFacilities =>
      'Improve facilities and amenities';

  @override
  String get occupancyRecommendationPartnerships =>
      'Consider partnerships with local businesses';

  @override
  String get pgBasicInfoTitle => 'Basic Information';

  @override
  String get pgBasicInfoAddressLabel => 'Complete Address';

  @override
  String get pgBasicInfoAddressHint => 'Full address with landmark';

  @override
  String get pgBasicInfoPgNameLabel => 'PG Name';

  @override
  String get pgBasicInfoPgNameHint => 'e.g., Green Meadows PG';

  @override
  String get pgBasicInfoContactLabel => 'Contact Number';

  @override
  String get pgBasicInfoContactHint => 'e.g., +91 9876543210';

  @override
  String get pgBasicInfoStateLabel => 'State';

  @override
  String get pgBasicInfoStateHint => 'Select State';

  @override
  String get pgBasicInfoCityLabel => 'City';

  @override
  String get pgBasicInfoCityHint => 'Select City';

  @override
  String get pgBasicInfoAreaLabel => 'Area';

  @override
  String get pgBasicInfoAreaHint => 'e.g., Sector 5, HSR Layout';

  @override
  String get pgBasicInfoPgTypeLabel => 'PG Type';

  @override
  String get pgBasicInfoPgTypeHint => 'Select PG Type';

  @override
  String get pgBasicInfoPgTypeBoys => 'Boys';

  @override
  String get pgBasicInfoPgTypeGirls => 'Girls';

  @override
  String get pgBasicInfoPgTypeCoed => 'Co-ed';

  @override
  String get pgBasicInfoMealTypeLabel => 'Meal Type';

  @override
  String get pgBasicInfoMealTypeHint => 'Select Meal Type';

  @override
  String get pgBasicInfoMealTypeVeg => 'Vegetarian';

  @override
  String get pgBasicInfoMealTypeNonVeg => 'Non-Vegetarian';

  @override
  String get pgBasicInfoMealTypeBoth => 'Both';

  @override
  String get pgBasicInfoFoodSectionTitle => 'Food & Meal Details';

  @override
  String get pgBasicInfoMealTimingsLabel => 'Meal Timings';

  @override
  String get pgBasicInfoMealTimingsHint =>
      'e.g., Breakfast: 8:00 AM - 10:00 AM, Lunch: 1:00 PM - 2:00 PM, Dinner: 8:00 PM - 9:30 PM';

  @override
  String get pgBasicInfoFoodQualityLabel => 'Food Quality Description';

  @override
  String get pgBasicInfoFoodQualityHint =>
      'Describe the food quality, cuisine type, specialities, etc.';

  @override
  String get pgBasicInfoDescriptionLabel => 'Description';

  @override
  String get pgBasicInfoDescriptionHint => 'Brief description of your PG';

  @override
  String get pgFloorStructureTitle => '🏢 Floor Structure';

  @override
  String get pgFloorCountLabel => 'Number of Regular Floors';

  @override
  String get pgFloorCountHint => 'e.g., 1';

  @override
  String get generateAction => 'Generate';

  @override
  String get pgFloorGroundLabel => 'Ground';

  @override
  String get pgFloorTerraceLabel => 'Terrace';

  @override
  String get pgFloorFirstLabel => 'First';

  @override
  String get pgFloorSecondLabel => 'Second';

  @override
  String get pgFloorThirdLabel => 'Third';

  @override
  String get pgFloorFourthLabel => 'Fourth';

  @override
  String get pgFloorFifthLabel => 'Fifth';

  @override
  String pgFloorNthLabel(int number) {
    return 'Floor $number';
  }

  @override
  String pgFloorRoomsBedsSummary(int rooms, int beds) {
    return '$rooms rooms • $beds beds';
  }

  @override
  String get pgFloorAddRoom => 'Add Room';

  @override
  String pgFloorCapacityOption(int capacity) {
    return '$capacity-share';
  }

  @override
  String pgFloorBedLabel(int index) {
    return 'Bed-$index';
  }

  @override
  String pgFloorRoomLabel(String roomNumber) {
    return 'Room $roomNumber';
  }

  @override
  String pgFloorBedsList(String bedList) {
    return 'Beds: $bedList';
  }

  @override
  String get pgFloorNoRoomsMessage =>
      'No rooms added yet. Click \"Add Room\" to get started.';

  @override
  String get pgFloorEmptyTitle => 'No Floors Generated';

  @override
  String get pgFloorEmptyMessage =>
      'Enter the number of floors and click \"Generate\" to create your floor structure.';

  @override
  String get pgRentConfigTitle => 'Rent Configuration';

  @override
  String pgRentConfigSharingLabel(String sharing) {
    return 'Rent ($sharing)';
  }

  @override
  String pgRentConfigRentLabel(String sharing) {
    return 'Rent for $sharing (₹)';
  }

  @override
  String get pgRentConfigRentHint => 'e.g., 8000';

  @override
  String get pgRentConfigDepositLabel => 'Security Deposit (₹)';

  @override
  String get pgRentConfigDepositHint => 'e.g., 10000';

  @override
  String get pgRentConfigMaintenanceTypeLabel => 'Maintenance Type';

  @override
  String get pgRentConfigMaintenanceOneTime => 'One Time';

  @override
  String get pgRentConfigMaintenanceMonthly => 'Monthly';

  @override
  String get pgRentConfigMaintenanceQuarterly => 'Quarterly';

  @override
  String get pgRentConfigMaintenanceYearly => 'Yearly';

  @override
  String get pgRentConfigMaintenanceAmountLabel => 'Maintenance Amount (₹)';

  @override
  String get pgRentConfigMaintenanceAmountHint => 'e.g., 500';

  @override
  String get pgRentConfigRefundTitle => 'Deposit Refund Policy:';

  @override
  String get pgRentConfigRefundFull => '• Full refund if notice ≥ 30 days';

  @override
  String get pgRentConfigRefundPartial => '• 50% refund if notice ≥ 15 days';

  @override
  String get pgRentConfigRefundNone => '• No refund if notice < 15 days';

  @override
  String get pgRulesTitle => 'Rules & Policies';

  @override
  String get pgRulesEntryTimingsLabel => 'Entry Timings';

  @override
  String get pgRulesExitTimingsLabel => 'Exit Timings';

  @override
  String get pgRulesTimingsHint => 'e.g., 6:00 AM - 11:00 PM';

  @override
  String get pgRulesSmokingPolicyLabel => 'Smoking Policy';

  @override
  String get pgRulesAlcoholPolicyLabel => 'Alcohol Policy';

  @override
  String get pgRulesPolicyHint => 'Select Policy';

  @override
  String get pgRulesPolicyNotAllowed => 'Not Allowed';

  @override
  String get pgRulesPolicyAllowed => 'Allowed';

  @override
  String get pgRulesPolicyDesignatedAreas => 'Designated Areas Only';

  @override
  String get pgRulesNoticePeriodLabel => 'Notice Period (Days)';

  @override
  String get pgRulesNoticePeriodHint => 'e.g., 30';

  @override
  String get pgRulesGuestPolicyLabel => 'Guest Policy';

  @override
  String get pgRulesGuestPolicyHint =>
      'Rules regarding guests, visitors, overnight stays, etc.';

  @override
  String get pgRulesRefundPolicyLabel => 'Refund Policy';

  @override
  String get pgRulesRefundPolicyHint =>
      'Terms and conditions for refunds, deposits, cancellations, etc.';

  @override
  String get pgPhotosTitle => 'Photos & Gallery';

  @override
  String get pgPhotosSubtitle =>
      'Add photos of your PG to attract more guests:';

  @override
  String get pgPhotosAddButton => 'Add Photos';

  @override
  String get pgPhotosLimitHint =>
      'You can select multiple images at once (up to 10)';

  @override
  String pgPhotosUploadSuccess(int count) {
    return 'Uploaded $count photos successfully!';
  }

  @override
  String pgPhotosUploadPartial(int success, int failed) {
    return 'Uploaded $success photos, $failed failed.';
  }

  @override
  String get pgPhotosUploadFailed => 'Failed to upload photos';

  @override
  String get pgPhotosEmptyTitle => 'No photos added yet';

  @override
  String get pgPhotosEmptySubtitle => 'Click \"Add Photos\" to upload images';

  @override
  String get pgPhotosRemoveAction => 'Remove photo';

  @override
  String get pgAdditionalInfoTitle => 'Additional Information';

  @override
  String get pgAdditionalInfoParkingLabel => 'Parking Details';

  @override
  String get pgAdditionalInfoParkingHint =>
      'e.g., 2-wheeler parking available, 4-wheeler parking: ₹500/month, Capacity: 20 bikes';

  @override
  String get pgAdditionalInfoSecurityLabel => 'Security Measures';

  @override
  String get pgAdditionalInfoSecurityHint =>
      'e.g., 24/7 Security guard, CCTV surveillance, Biometric access, Fire safety equipment';

  @override
  String get pgAdditionalInfoNearbyPlacesTitle => 'Nearby Places';

  @override
  String get pgAdditionalInfoNearbyPlacesDescription =>
      'Add nearby landmarks, locations, or points of interest';

  @override
  String get pgAdditionalInfoNearbyPlaceLabel => 'Nearby Place';

  @override
  String get pgAdditionalInfoNearbyPlaceHint =>
      'e.g., Metro Station, Shopping Mall, Hospital';

  @override
  String get pgAdditionalInfoAddButton => 'Add';

  @override
  String get pgAdditionalInfoPaymentInstructionsLabel => 'Payment Instructions';

  @override
  String get pgAdditionalInfoPaymentInstructionsHint =>
      'Instructions for making payments, accepted payment methods, payment schedule, etc.';

  @override
  String get pgAmenitiesTitle => 'Amenities & Facilities';

  @override
  String get pgAmenitiesDescription =>
      'Select all amenities available in your PG:';

  @override
  String get pgAmenitiesSelectedLabel => 'Selected';

  @override
  String get pgAmenityWifi => 'Wi-Fi';

  @override
  String get pgAmenityParking => 'Parking';

  @override
  String get pgAmenitySecurity => 'Security';

  @override
  String get pgAmenityCctv => 'CCTV';

  @override
  String get pgAmenityLaundry => 'Laundry';

  @override
  String get pgAmenityKitchen => 'Kitchen';

  @override
  String get pgAmenityAc => 'AC';

  @override
  String get pgAmenityGeyser => 'Geyser';

  @override
  String get pgAmenityTv => 'TV';

  @override
  String get pgAmenityRefrigerator => 'Refrigerator';

  @override
  String get pgAmenityPowerBackup => 'Power Backup';

  @override
  String get pgAmenityGym => 'Gym';

  @override
  String get pgAmenityCurtains => 'Curtains';

  @override
  String get pgAmenityBucket => 'Bucket';

  @override
  String get pgAmenityWaterCooler => 'Water Cooler';

  @override
  String get pgAmenityWashingMachine => 'Washing Machine';

  @override
  String get pgAmenityMicrowave => 'Microwave';

  @override
  String get pgAmenityLift => 'Lift';

  @override
  String get pgAmenityHousekeeping => 'Housekeeping';

  @override
  String get pgAmenityAttachedBathroom => 'Attached Bathroom';

  @override
  String get pgAmenityRoWater => 'RO Water';

  @override
  String get pgAmenityWaterSupply => '24x7 Water Supply';

  @override
  String get pgAmenityBedWithMattress => 'Bed with Mattress';

  @override
  String get pgAmenityWardrobe => 'Wardrobe';

  @override
  String get pgAmenityStudyTable => 'Study Table';

  @override
  String get pgAmenityChair => 'Chair';

  @override
  String get pgAmenityFan => 'Fan';

  @override
  String get pgAmenityLighting => 'Lighting';

  @override
  String get pgAmenityBalcony => 'Balcony';

  @override
  String get pgAmenityCommonArea => 'Common Area';

  @override
  String get pgAmenityDiningArea => 'Dining Area';

  @override
  String get pgAmenityInductionStove => 'Induction Stove';

  @override
  String get pgAmenityCookingAllowed => 'Cooking Allowed';

  @override
  String get pgAmenityFireExtinguisher => 'Fire Extinguisher';

  @override
  String get pgAmenityFirstAidKit => 'First Aid Kit';

  @override
  String get pgAmenitySmokeDetector => 'Smoke Detector';

  @override
  String get pgAmenityVisitorParking => 'Visitor Parking';

  @override
  String get pgAmenityIntercom => 'Intercom';

  @override
  String get pgAmenityMaintenanceStaff => 'Maintenance Staff';

  @override
  String get pgSummaryTitle => 'PG Summary';

  @override
  String get pgSummaryBasicInfoTitle => 'Basic Information';

  @override
  String get pgSummaryRentInfoTitle => 'Rent Information';

  @override
  String get pgSummaryPhotosTitle => 'Photos';

  @override
  String get pgSummaryActionCreate => 'create';

  @override
  String get pgSummaryActionUpdate => 'update';

  @override
  String pgSummaryReadyMessage(String action) {
    return 'Ready to $action your PG!';
  }

  @override
  String get pgSummaryReviewMessage =>
      'Review all details above and click the save button to proceed.';

  @override
  String get pgSummaryNotSpecified => 'Not specified';

  @override
  String get pgSummaryLocationLabel => 'Location';

  @override
  String pgSummaryLocationValue(String city, String state) {
    return '$city, $state';
  }

  @override
  String get pgSummaryTotalFloorsLabel => 'Total Floors';

  @override
  String get pgSummaryTotalRoomsLabel => 'Total Rooms';

  @override
  String get pgSummaryTotalBedsLabel => 'Total Beds';

  @override
  String get pgSummaryEstimatedRevenueLabel => 'Estimated Monthly Revenue';

  @override
  String get pgSummaryMaintenanceLabel => 'Maintenance';

  @override
  String get pgSummarySelectedAmenitiesLabel => 'Selected Amenities';

  @override
  String get pgSummaryListLabel => 'List';

  @override
  String get pgSummaryUploadedPhotosLabel => 'Uploaded Photos';

  @override
  String get pgInfoNoPgSelected => 'No PG selected';

  @override
  String get pgInfoSelectPgPrompt =>
      'Please select a PG from the dropdown above';

  @override
  String get pgInfoEditTooltip => 'Edit PG details';

  @override
  String get pgInfoContactNotProvided => 'Not provided';

  @override
  String get pgInfoPgTypeFallback => 'PG';

  @override
  String get pgInfoLocationFallback => 'Location not available';

  @override
  String get pgInfoStructureOverview => 'PG Structure Overview';

  @override
  String get pgInfoFloorsLabel => 'Floors';

  @override
  String get pgInfoRoomsLabel => 'Rooms';

  @override
  String get pgInfoBedsLabel => 'Beds';

  @override
  String get pgInfoPotentialLabel => 'Potential';

  @override
  String get pgInfoFloorRoomDetails => 'Floor & Room Details';

  @override
  String pgInfoRoomsSummary(int count) {
    return '$count rooms';
  }

  @override
  String pgInfoRoomChip(String roomNumber, String sharingType, int bedsCount) {
    return '$roomNumber ($sharingType, $bedsCount beds)';
  }

  @override
  String get pgFloorLabelFallback => 'Floor';

  @override
  String get ownerBedMapRoomUnknown => 'Unknown';

  @override
  String ownerBedMapOccupancySummary(int occupied, int total, int capacity) {
    return '$occupied/$total occupied • Capacity $capacity';
  }

  @override
  String ownerBedMapStatusChipOccupied(int count) {
    return 'Occupied $count';
  }

  @override
  String ownerBedMapStatusChipVacant(int count) {
    return 'Vacant $count';
  }

  @override
  String ownerBedMapStatusChipPending(int count) {
    return 'Pending $count';
  }

  @override
  String ownerBedMapStatusChipMaintenance(int count) {
    return 'Maint. $count';
  }

  @override
  String get ownerBedMapBedsOverview => 'Beds Overview';

  @override
  String get ownerBedMapMiniStatTotal => 'Total';

  @override
  String get ownerBedMapMiniStatOccupied => 'Occupied';

  @override
  String get ownerBedMapMiniStatVacant => 'Vacant';

  @override
  String get ownerBedMapMiniStatPending => 'Pending';

  @override
  String get ownerBedMapMiniStatMaintenance => 'Maint.';

  @override
  String ownerBedMapPlaceholderSummary(int occupied, int total) {
    return '$occupied/$total occupied';
  }

  @override
  String get ownerBedMapStatusOccupiedLabel => 'Occupied';

  @override
  String get ownerBedMapStatusPendingLabel => 'Pending';

  @override
  String get ownerBedMapStatusMaintenanceLabel => 'Maint.';

  @override
  String get ownerBedMapStatusVacantLabel => 'Vacant';

  @override
  String ownerBedMapTooltipTitle(String bedNumber, String status) {
    return 'Bed $bedNumber • $status';
  }

  @override
  String ownerBedMapTooltipGuest(String guest) {
    return 'Guest: $guest';
  }

  @override
  String ownerBedMapTooltipFrom(String date) {
    return 'From: $date';
  }

  @override
  String ownerBedMapTooltipTill(String date) {
    return 'Till: $date';
  }

  @override
  String get ownerRevenueReportTitle => 'Revenue Report';

  @override
  String get ownerRevenueReportCollectedLabel => 'Collected';

  @override
  String get ownerRevenueReportPendingLabel => 'Pending';

  @override
  String get ownerRevenueReportTotalPaymentsLabel => 'Total Payments';

  @override
  String get ownerRevenueReportCollectedCountLabel => 'Collected Count';

  @override
  String get ownerOccupancyReportTitle => 'Occupancy Report';

  @override
  String get ownerOccupancyReportTotalBedsLabel => 'Total Beds';

  @override
  String get ownerOccupancyReportOccupiedLabel => 'Occupied';

  @override
  String get ownerOccupancyReportVacantLabel => 'Vacant';

  @override
  String get ownerOccupancyReportRateLabel => 'Occupancy Rate';

  @override
  String get ownerOccupancyReportPendingLabel => 'Pending';

  @override
  String get ownerOccupancyReportMaintenanceLabel => 'Maintenance';

  @override
  String ownerBookingRequestsTitle(int count) {
    return 'Pending Requests ($count)';
  }

  @override
  String ownerUpcomingVacatingTitle(int count) {
    return 'Upcoming Vacating ($count)';
  }

  @override
  String get ownerServiceZeroRequests => '0 requests';

  @override
  String get ownerPaymentUpdateFailed => 'Failed to update payment';

  @override
  String get guestHelpTitle => 'Help & Support';

  @override
  String get guestHelpQuickHelp => 'Quick Help';

  @override
  String get guestHelpHeroSubtitle =>
      'Get instant answers to common questions about booking and managing your PG stay.';

  @override
  String get guestHelpVideosTitle => 'Video Tutorials';

  @override
  String get guestHelpVideosSubtitle => 'Watch step-by-step guides';

  @override
  String get guestHelpUnableToOpenVideos => 'Unable to open video tutorials';

  @override
  String get guestHelpDocsTitle => 'Documentation';

  @override
  String get guestHelpDocsSubtitle => 'Read comprehensive guides';

  @override
  String get guestHelpUnableToOpenDocs => 'Unable to open documentation';

  @override
  String get guestHelpFaqTitle => 'Frequently Asked Questions';

  @override
  String get guestHelpFaqBookQuestion => 'How do I book a PG room?';

  @override
  String get guestHelpFaqBookAnswer =>
      'Browse available PGs in the \"PGs\" tab, select a PG, and tap \"Book Now\" to submit a booking request.';

  @override
  String get guestHelpFaqStatusQuestion => 'How do I view my booking status?';

  @override
  String get guestHelpFaqStatusAnswer =>
      'Open the \"Requests\" tab to see all your booking requests and their current status.';

  @override
  String get guestHelpFaqPaymentQuestion => 'How do I make a payment?';

  @override
  String get guestHelpFaqPaymentAnswer =>
      'Go to the \"Payments\" tab to view history and make new payments.';

  @override
  String get guestHelpFaqProfileQuestion => 'How do I update my profile?';

  @override
  String get guestHelpFaqProfileAnswer =>
      'Open the drawer menu and tap \"My Profile\" to edit your details.';

  @override
  String get guestHelpFaqComplaintQuestion => 'How do I file a complaint?';

  @override
  String get guestHelpFaqComplaintAnswer =>
      'Navigate to the \"Complaints\" tab and tap \"Add Complaint\" to submit one.';

  @override
  String get guestHelpContactTitle => 'Contact Support';

  @override
  String get guestHelpContactSubtitle =>
      'Need more help? Reach out to our support team.';

  @override
  String get guestHelpEmailTitle => 'Email Support';

  @override
  String get guestHelpPhoneTitle => 'Phone Support';

  @override
  String get guestHelpChatTitle => 'Live Chat';

  @override
  String get guestHelpChatSubtitle => 'WhatsApp: +91 7020797849';

  @override
  String get guestHelpUnableToOpenChat =>
      'Unable to open chat. Please try WhatsApp: +91 7020797849';

  @override
  String get guestHelpResourcesTitle => 'Resources';

  @override
  String get guestHelpPrivacyPolicy => 'Privacy Policy';

  @override
  String get guestHelpTermsOfService => 'Terms of Service';

  @override
  String get ownerHelpTitle => 'Help & Support';

  @override
  String get ownerHelpQuickHelp => 'Quick Help';

  @override
  String get ownerHelpHeroSubtitle =>
      'Get instant answers to common questions about managing your PG properties.';

  @override
  String get ownerHelpVideosTitle => 'Video Tutorials';

  @override
  String get ownerHelpVideosSubtitle => 'Watch step-by-step guides';

  @override
  String get ownerHelpUnableToOpenVideos => 'Unable to open video tutorials';

  @override
  String get ownerHelpDocsTitle => 'Documentation';

  @override
  String get ownerHelpDocsSubtitle => 'Read comprehensive guides';

  @override
  String get ownerHelpUnableToOpenDocs => 'Unable to open documentation';

  @override
  String get ownerHelpFaqTitle => 'Frequently Asked Questions';

  @override
  String get ownerHelpFaqAddPgQuestion => 'How do I add a new PG property?';

  @override
  String get ownerHelpFaqAddPgAnswer =>
      'Go to the \"My PGs\" tab and tap \"Add New PG\". Fill in the details and submit.';

  @override
  String get ownerHelpFaqBookingsQuestion => 'How do I manage guest bookings?';

  @override
  String get ownerHelpFaqBookingsAnswer =>
      'Open the \"Guests\" tab to review, approve, or reject booking requests.';

  @override
  String get ownerHelpFaqPaymentsQuestion => 'How do I view payment history?';

  @override
  String get ownerHelpFaqPaymentsAnswer =>
      'Use the \"Overview\" tab to review payments or check individual guests under \"Guests\".';

  @override
  String get ownerHelpFaqProfileQuestion => 'How do I update my profile?';

  @override
  String get ownerHelpFaqProfileAnswer =>
      'Open the drawer menu and tap \"My Profile\" to update your information.';

  @override
  String get ownerHelpContactTitle => 'Contact Support';

  @override
  String get ownerHelpContactSubtitle =>
      'Need more help? Reach out to our support team.';

  @override
  String get ownerHelpEmailTitle => 'Email Support';

  @override
  String get ownerHelpPhoneTitle => 'Phone Support';

  @override
  String get ownerHelpChatTitle => 'Live Chat';

  @override
  String get ownerHelpChatSubtitle => 'WhatsApp: +91 7020797849';

  @override
  String get ownerHelpUnableToOpenChat =>
      'Unable to open chat. Please try WhatsApp: +91 7020797849';

  @override
  String get ownerHelpResourcesTitle => 'Resources';

  @override
  String get ownerHelpPrivacyPolicy => 'Privacy Policy';

  @override
  String get ownerHelpTermsOfService => 'Terms of Service';

  @override
  String get guestNotificationsTitle => 'Notifications';

  @override
  String get guestNotificationsLoadFailed => 'Failed to load notifications';

  @override
  String get guestNotificationsEmptyTitle => 'No Notifications';

  @override
  String get guestNotificationsEmptyMessage =>
      'You don\'t have any notifications yet.';

  @override
  String get guestNotificationsFilterAll => 'All';

  @override
  String get guestNotificationsFilterUnread => 'Unread';

  @override
  String get guestNotificationsFilterBookings => 'Bookings';

  @override
  String get guestNotificationsFilterPayments => 'Payments';

  @override
  String get guestNotificationsFilterComplaints => 'Complaints';

  @override
  String get guestNotificationsFilterBedChanges => 'Bed Changes';

  @override
  String get guestNotificationsFilterPgUpdates => 'PG Updates';

  @override
  String get guestNotificationsFilterServices => 'Services';

  @override
  String get guestNotificationsDefaultTitle => 'Notification';

  @override
  String get guestNotificationsDefaultBody => 'No message';

  @override
  String get ownerNotificationsTitle => 'Notifications';

  @override
  String get ownerNotificationsLoadFailed => 'Failed to load notifications';

  @override
  String get ownerNotificationsEmptyTitle => 'No Notifications';

  @override
  String get ownerNotificationsEmptyMessage => 'No notifications yet';

  @override
  String get ownerNotificationsFilterAll => 'All';

  @override
  String get ownerNotificationsFilterUnread => 'Unread';

  @override
  String get ownerNotificationsFilterBookings => 'Bookings';

  @override
  String get ownerNotificationsFilterPayments => 'Payments';

  @override
  String get ownerNotificationsFilterComplaints => 'Complaints';

  @override
  String get ownerNotificationsFilterBedChanges => 'Bed Changes';

  @override
  String get ownerNotificationsFilterServices => 'Services';

  @override
  String get ownerNotificationsDefaultTitle => 'Notification';

  @override
  String get ownerNotificationsDefaultBody => 'No message';

  @override
  String get ownerNotificationsMarkAll => 'Mark all as read';

  @override
  String get ownerNotificationsJustNow => 'Just now';

  @override
  String ownerNotificationsMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '$count minute ago',
    );
    return '$_temp0';
  }

  @override
  String ownerNotificationsHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '$count hour ago',
    );
    return '$_temp0';
  }

  @override
  String ownerNotificationsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '$count day ago',
    );
    return '$_temp0';
  }

  @override
  String get drawerDefaultUserName => 'PG User';

  @override
  String get drawerDefaultInitial => 'U';

  @override
  String drawerVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get drawerContactEmail => 'contact@charyatani.com';

  @override
  String get drawerContactPhone => '+91 98765 43210';

  @override
  String get drawerContactWebsite => 'www.charyatani.com';

  @override
  String get ownerSpecialMenuEditTitle => 'Edit Special Menu';

  @override
  String get ownerSpecialMenuAddTitle => 'Add Special Menu';

  @override
  String get ownerSpecialMenuSaving => 'Saving special menu...';

  @override
  String get ownerSpecialMenuSaveButton => 'Save Special Menu';

  @override
  String get ownerSpecialMenuFestivalHeading => 'Festival/Event Name';

  @override
  String get ownerSpecialMenuFestivalHint =>
      'e.g., Diwali, Ugadi, Special Event';

  @override
  String get ownerSpecialMenuSpecialNoteHeading => 'Special Note';

  @override
  String get ownerSpecialMenuSpecialNoteLabel => 'Note';

  @override
  String get ownerSpecialMenuSpecialNoteHint =>
      'Any special instructions or details...';

  @override
  String get ownerSpecialMenuFallbackInfo =>
      'Leave meal sections empty to use the default weekly menu for this day';

  @override
  String ownerSpecialMenuOptionalSection(String meal) {
    return '$meal (Optional)';
  }

  @override
  String get ownerSpecialMenuNoItems => 'No items added';

  @override
  String get ownerSpecialMenuAddItem => 'Add Item';

  @override
  String ownerSpecialMenuAddMealItemTitle(String mealType) {
    return 'Add $mealType Item';
  }

  @override
  String get ownerSpecialMenuItemNameLabel => 'Item Name';

  @override
  String get ownerSpecialMenuItemNameHint => 'Enter meal item name';

  @override
  String get ownerSpecialMenuFestivalRequired =>
      'Please enter festival/event name';

  @override
  String get ownerSpecialMenuSaveSuccess => 'Special menu saved successfully!';

  @override
  String ownerSpecialMenuSaveFailed(String error) {
    return 'Failed to save special menu: $error';
  }

  @override
  String ownerSpecialMenuSaveError(String error) {
    return 'Error saving special menu: $error';
  }

  @override
  String ownerMenuEditTitleEdit(String day) {
    return 'Edit $day Menu';
  }

  @override
  String ownerMenuEditTitleCreate(String day) {
    return 'Create $day Menu';
  }

  @override
  String get ownerMenuEditDeleteTooltip => 'Delete Menu';

  @override
  String get ownerMenuEditSaving => 'Saving menu...';

  @override
  String get ownerMenuEditUpdateButton => 'Update Menu';

  @override
  String get ownerMenuEditCreateButton => 'Create Menu';

  @override
  String ownerMenuEditOverviewTitle(String day) {
    return '$day Menu';
  }

  @override
  String get ownerMenuEditOverviewSubtitle => 'Create & manage the daily menu';

  @override
  String get ownerMenuEditStatItems => 'Items';

  @override
  String get ownerMenuEditStatPhotos => 'Photos';

  @override
  String ownerMenuEditOptionalSection(String meal) {
    return '$meal (Optional)';
  }

  @override
  String ownerMenuEditLastUpdated(String timestamp) {
    return 'Last Updated: $timestamp';
  }

  @override
  String get ownerMenuEditPhotosHeading => 'Menu Photos';

  @override
  String get ownerMenuEditAddPhoto => 'Add Photo';

  @override
  String get ownerMenuEditUploadingPhoto => 'Uploading photo...';

  @override
  String get ownerMenuEditBadgeNew => 'NEW';

  @override
  String get ownerMenuEditNoPhotos => 'No photos added yet';

  @override
  String ownerMenuEditItemsCount(int count) {
    return '$count items';
  }

  @override
  String ownerMenuEditAddItemTooltip(String meal) {
    return 'Add $meal Item';
  }

  @override
  String ownerMenuEditNoItemsForMeal(String meal) {
    return 'No $meal items added yet';
  }

  @override
  String get ownerMenuEditRemoveItemTooltip => 'Remove Item';

  @override
  String get ownerMenuEditDescriptionHeading => 'Description (Optional)';

  @override
  String get ownerMenuEditDescriptionLabel => 'Menu Description';

  @override
  String get ownerMenuEditDescriptionHint =>
      'Add any special notes about this menu...';

  @override
  String ownerMenuEditAddMealItemTitle(String mealType) {
    return 'Add $mealType Item';
  }

  @override
  String get ownerMenuEditItemNameLabel => 'Item Name';

  @override
  String get ownerMenuEditItemNameHint => 'e.g., Idli with Sambar, Dosa, Poha';

  @override
  String get ownerMenuEditMealRequired => 'Please add at least one meal item';

  @override
  String get ownerMenuEditAuthError =>
      'Error: User not authenticated. Please login again.';

  @override
  String ownerMenuEditUpdateSuccess(String day) {
    return '$day menu updated successfully!';
  }

  @override
  String ownerMenuEditCreateSuccess(String day) {
    return '$day menu created successfully!';
  }

  @override
  String ownerMenuEditSaveFailed(String error) {
    return 'Failed to save menu: $error';
  }

  @override
  String ownerMenuEditSaveError(String error) {
    return 'Error saving menu: $error';
  }

  @override
  String get ownerMenuEditClearTitle => 'Clear Menu?';

  @override
  String get ownerMenuEditClearMessage =>
      'Are you sure you want to clear this menu? This will remove all items and photos.';

  @override
  String get ownerMenuEditClearConfirm => 'Clear';

  @override
  String get ownerMenuEditClearSnackbar =>
      'Menu cleared. Don\'t forget to save changes.';

  @override
  String ownerMenuEditImagePickError(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get chooseYourPreferredTheme => 'Choose your preferred theme';

  @override
  String get selectPreferredLanguage => 'Select your preferred language';

  @override
  String get dataPrivacy => 'Data & Privacy';

  @override
  String get about => 'About';

  @override
  String get receiveNotificationsOnYourDevice =>
      'Receive notifications on your device';

  @override
  String get receiveNotificationsViaEmail => 'Receive notifications via email';

  @override
  String get getRemindersForPendingPayments =>
      'Get reminders for pending payments';

  @override
  String get ownerReportsSelectPeriod => 'Select report period';

  @override
  String get ownerReportsSelectDateRange => 'Select date range';

  @override
  String get ownerReportsRefresh => 'Refresh reports';

  @override
  String get ownerReportsTabRevenue => 'Revenue';

  @override
  String get ownerReportsTabBookings => 'Bookings';

  @override
  String get ownerReportsTabGuests => 'Guests';

  @override
  String get ownerReportsTabPayments => 'Payments';

  @override
  String get ownerReportsTabComplaints => 'Complaints';

  @override
  String get ownerReportsLoading => 'Loading reports...';

  @override
  String get ownerReportsErrorTitle => 'Error loading reports';

  @override
  String get ownerReportsNoRevenueData => 'No revenue data';

  @override
  String get ownerReportsRevenuePlaceholder =>
      'Revenue data will appear here once you have bookings';

  @override
  String get ownerReportsAveragePerMonth => 'Average / month';

  @override
  String get ownerReportsMonthlyRevenueBreakdown => 'Monthly revenue breakdown';

  @override
  String get ownerReportsTotalBookings => 'Total bookings';

  @override
  String get ownerReportsPendingRequests => 'Pending requests';

  @override
  String get ownerReportsTotalReceived => 'Total received';

  @override
  String get ownerReportsPaidCount => 'Paid count';

  @override
  String get ownerReportsPendingCount => 'Pending count';

  @override
  String get ownerReportsChangeDateRange => 'Change';

  @override
  String get ownerReportsPropertyWiseRevenue => 'Property-wise revenue';

  @override
  String ownerReportsPercentageOfTotal(String percentage) {
    return '$percentage% of total';
  }

  @override
  String get ownerReportsBookingTrends => 'Booking trends';

  @override
  String get ownerReportsNoBookingData =>
      'No booking data available for the selected period';

  @override
  String ownerReportsBookingsCount(int count) {
    return '$count bookings';
  }

  @override
  String get ownerReportsGuestStatistics => 'Guest statistics';

  @override
  String get ownerReportsPaymentTrends => 'Payment trends';

  @override
  String get ownerReportsNoPaymentData =>
      'No payment data available for the selected period';

  @override
  String get ownerReportsComplaintTrends => 'Complaint trends';

  @override
  String get ownerReportsNoComplaintData =>
      'No complaint data available for the selected period';

  @override
  String ownerReportsComplaintsCount(int count) {
    return '$count complaints';
  }

  @override
  String get ownerOverviewOccupancyRate => 'Occupancy rate';

  @override
  String get ownerOverviewPerformanceExcellent => 'Excellent';

  @override
  String get ownerOverviewPerformanceGood => 'Good';

  @override
  String get ownerOverviewPerformanceFair => 'Fair';

  @override
  String get ownerOverviewPerformanceNeedsAttention => 'Needs attention';

  @override
  String ownerOverviewPgLabel(int index, String name) {
    return '${index}PG: $name';
  }

  @override
  String get ownerOverviewAveragePerMonth => 'Average / month';

  @override
  String get ownerOverviewHighestMonth => 'Highest month';

  @override
  String get ownerProfileTitle => 'My Profile';

  @override
  String get ownerProfileSaveTooltip => 'Save profile';

  @override
  String get ownerProfileTabPersonalInfo => 'Personal Info';

  @override
  String get ownerProfileTabBusinessInfo => 'Business Info';

  @override
  String get ownerProfileTabDocuments => 'Documents';

  @override
  String get ownerProfileFullNameLabel => 'Full Name';

  @override
  String get ownerProfileFullNameHint => 'Enter your full name';

  @override
  String get ownerProfileEmailLabel => 'Email';

  @override
  String get ownerProfileEmailHint => 'Enter your email';

  @override
  String get ownerProfilePhoneLabel => 'Phone Number';

  @override
  String get ownerProfilePhoneHint => 'Enter your phone number';

  @override
  String get ownerProfileAddressLabel => 'PG Address';

  @override
  String get ownerProfileAddressHint => 'Enter your PG address';

  @override
  String get ownerProfileStateLabel => 'State';

  @override
  String get ownerProfileStateHint => 'Select state';

  @override
  String get ownerProfileCityLabel => 'City';

  @override
  String get ownerProfileCityHint => 'Select city';

  @override
  String get ownerProfileCityHintSelectState => 'Select state first';

  @override
  String get ownerProfilePincodeLabel => 'Pincode';

  @override
  String get ownerProfilePincodeHint => 'Enter pincode';

  @override
  String get ownerProfileSavePersonal => 'Save Personal Info';

  @override
  String get ownerProfileBusinessNameLabel => 'Business Name';

  @override
  String get ownerProfileBusinessNameHint => 'Enter business name';

  @override
  String get ownerProfileBusinessTypeLabel => 'Business Type';

  @override
  String get ownerProfileBusinessTypeHint => 'Enter business type';

  @override
  String get ownerProfilePanLabel => 'PAN Number';

  @override
  String get ownerProfilePanHint => 'Enter PAN number';

  @override
  String get ownerProfileGstLabel => 'GST Number';

  @override
  String get ownerProfileGstHint => 'Enter GST number';

  @override
  String get ownerProfileSaveBusiness => 'Save Business Info';

  @override
  String get ownerProfileDocumentProfileTitle => 'Profile Photo';

  @override
  String get ownerProfileDocumentProfileDescription =>
      'Upload your profile photo';

  @override
  String get ownerProfileDocumentAadhaarTitle => 'Aadhaar Photo';

  @override
  String get ownerProfileDocumentAadhaarDescription =>
      'Upload your Aadhaar card photo';

  @override
  String get ownerProfileDocumentUpload => 'Upload';

  @override
  String get ownerProfileDocumentUpdate => 'Update';

  @override
  String ownerProfilePickImageFailed(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get ownerIdNotAvailable => 'Owner ID not available';

  @override
  String get ownerProfileNotFound => 'Profile not found';

  @override
  String get ownerProfileLoadFailed => 'Failed to load profile';

  @override
  String get ownerProfileStreamFailed => 'Failed to stream profile';

  @override
  String get ownerProfileStreamStartFailed => 'Failed to start profile stream';

  @override
  String get ownerProfileCreateFailed => 'Failed to create profile';

  @override
  String get ownerProfileUpdateFailed => 'Failed to update profile';

  @override
  String get ownerBankDetailsUpdateFailed => 'Failed to update bank details';

  @override
  String get ownerBusinessInfoUpdateFailed =>
      'Failed to update business information';

  @override
  String get ownerProfilePhotoUploadFailed => 'Failed to upload profile photo';

  @override
  String get ownerAadhaarUploadFailed => 'Failed to upload Aadhaar document';

  @override
  String get ownerUpiQrUploadFailed => 'Failed to upload UPI QR code';

  @override
  String get ownerAddPgFailed => 'Failed to add PG';

  @override
  String get ownerRemovePgFailed => 'Failed to remove PG';

  @override
  String get ownerProfileVerifyFailed => 'Failed to verify profile';

  @override
  String get ownerProfileDeactivateFailed => 'Failed to deactivate profile';

  @override
  String get ownerProfileActivateFailed => 'Failed to activate profile';

  @override
  String ownerStateUpdateFailedLog(String error) {
    return 'Error updating selected state: $error';
  }

  @override
  String ownerCityUpdateFailedLog(String error) {
    return 'Error updating selected city: $error';
  }

  @override
  String get ownerStateTelangana => 'Telangana';

  @override
  String get ownerStateAndhraPradesh => 'Andhra Pradesh';

  @override
  String get ownerProfilePhotoUpdateFailed => 'Failed to update profile photo';

  @override
  String get ownerAadhaarUpdateFailed => 'Failed to update Aadhaar photo';

  @override
  String get ownerUpiQrUpdateFailed => 'Failed to update UPI QR code';

  @override
  String get ownerFileDeleteFailed => 'Failed to delete file';

  @override
  String get ownerPgFetchFailed => 'Failed to fetch owner PG IDs';

  @override
  String get ownerOverviewFetchFailed => 'Failed to fetch owner overview data';

  @override
  String get ownerOverviewAggregateFailed => 'Failed to aggregate owner data';

  @override
  String get ownerMonthlyBreakdownFailed => 'Failed to fetch monthly breakdown';

  @override
  String get ownerPropertyBreakdownFailed =>
      'Failed to fetch property breakdown';

  @override
  String ownerPropertyFallbackName(String pgId) {
    return 'Property $pgId';
  }

  @override
  String get ownerOverviewLoadFailed => 'Failed to load overview data';

  @override
  String ownerOverviewLoadFailedWithReason(String error) {
    return 'Failed to load overview data: $error';
  }

  @override
  String ownerOverviewStreamFailedWithReason(String error) {
    return 'Failed to stream overview data: $error';
  }

  @override
  String ownerMonthlyBreakdownLoadFailed(String error) {
    return 'Failed to load monthly breakdown: $error';
  }

  @override
  String ownerPropertyBreakdownLoadFailed(String error) {
    return 'Failed to load property breakdown: $error';
  }

  @override
  String ownerGuestInitializeFailed(String error) {
    return 'Failed to initialize guest management: $error';
  }

  @override
  String ownerGuestStatsLoadFailedLog(String error) {
    return '⚠️ Owner Guest ViewModel: Failed to load guest stats: $error';
  }

  @override
  String ownerGuestUpdateFailed(String error) {
    return 'Failed to update guest: $error';
  }

  @override
  String ownerComplaintReplyFailed(String error) {
    return 'Failed to add reply: $error';
  }

  @override
  String ownerComplaintStatusUpdateFailed(String error) {
    return 'Failed to update complaint status: $error';
  }

  @override
  String ownerBikeUpdateFailed(String error) {
    return 'Failed to update bike: $error';
  }

  @override
  String ownerBikeMovementRequestFailed(String error) {
    return 'Failed to create bike movement request: $error';
  }

  @override
  String ownerServiceCreateFailed(String error) {
    return 'Failed to create service request: $error';
  }

  @override
  String ownerServiceReplyFailed(String error) {
    return 'Failed to add service reply: $error';
  }

  @override
  String ownerServiceStatusUpdateFailed(String error) {
    return 'Failed to update service status: $error';
  }

  @override
  String ownerGuestRefreshFailed(String error) {
    return 'Failed to refresh data: $error';
  }

  @override
  String ownerBookingApproveFailed(String error) {
    return 'Failed to approve booking request: $error';
  }

  @override
  String ownerBookingRejectFailed(String error) {
    return 'Failed to reject booking request: $error';
  }

  @override
  String get ownerResponseNone => 'none';

  @override
  String ownerFoodLoadMenusFailed(String error) {
    return 'Failed to load menus: $error';
  }

  @override
  String ownerFoodStreamMenusFailed(String error) {
    return 'Failed to stream menus: $error';
  }

  @override
  String ownerFoodStreamOverridesFailed(String error) {
    return 'Failed to stream overrides: $error';
  }

  @override
  String ownerFoodSaveMenuFailed(String error) {
    return 'Failed to save menu: $error';
  }

  @override
  String ownerFoodSaveMenusFailed(String error) {
    return 'Failed to save menus: $error';
  }

  @override
  String ownerFoodDeleteMenuFailed(String error) {
    return 'Failed to delete menu: $error';
  }

  @override
  String ownerFoodSaveOverrideFailed(String error) {
    return 'Failed to save override: $error';
  }

  @override
  String ownerFoodDeleteOverrideFailed(String error) {
    return 'Failed to delete override: $error';
  }

  @override
  String ownerFoodUploadPhotoFailed(String error) {
    return 'Failed to upload photo: $error';
  }

  @override
  String ownerFoodDeletePhotoFailed(String error) {
    return 'Failed to delete photo: $error';
  }

  @override
  String ownerFoodInitializeDefaultsFailed(String error) {
    return 'Failed to initialize default menus: $error';
  }

  @override
  String ownerFoodUpdateCurrentMenuFailed(String error) {
    return 'Failed to update current day menu: $error';
  }

  @override
  String ownerFoodSaveStateFailedLog(String error) {
    return '⚠️ Owner Food ViewModel: Failed to save menu state: $error';
  }

  @override
  String ownerFoodClearStateFailedLog(String error) {
    return '⚠️ Owner Food ViewModel: Failed to clear menu state: $error';
  }

  @override
  String get ownerFoodFetchMenuFailed => 'Failed to fetch weekly menu';

  @override
  String get ownerFoodFetchOverridesFailed => 'Failed to fetch menu overrides';

  @override
  String get ownerFoodRepositorySaveMenuFailed => 'Failed to save weekly menu';

  @override
  String get ownerFoodRepositorySaveMenusFailed =>
      'Failed to save weekly menus';

  @override
  String get ownerFoodRepositoryDeleteMenuFailed =>
      'Failed to delete weekly menu';

  @override
  String get ownerFoodRepositorySaveOverrideFailed =>
      'Failed to save menu override';

  @override
  String get ownerFoodRepositoryDeleteOverrideFailed =>
      'Failed to delete menu override';

  @override
  String get ownerFoodRepositoryUploadPhotoFailed => 'Failed to upload photo';

  @override
  String get ownerFoodRepositoryDeletePhotoFailed => 'Failed to delete photo';

  @override
  String get ownerFoodFetchStatsFailed => 'Failed to fetch menu stats';

  @override
  String pgPhotosUploading(int count) {
    return 'Uploading $count photo(s)...';
  }

  @override
  String pgPhotosSelectFailed(String error) {
    return 'Failed to select photos: $error';
  }

  @override
  String pgPhotosUploadErrorLog(int index, String error) {
    return 'Failed to upload image $index: $error';
  }

  @override
  String get pgSupabaseStorageTroubleshoot =>
      '⚠️ Supabase Storage Error: This might be due to:\n1. Storage bucket RLS policies blocking uploads\n2. CORS configuration issues\n3. Authentication required for storage uploads\nPlease check your Supabase Storage policies for the \"atitia-storage\" bucket.';

  @override
  String get ownerPgUnknownName => 'Unknown PG';

  @override
  String ownerPgInitializeFailed(String error) {
    return 'Failed to initialize PG management: $error';
  }

  @override
  String ownerPgApproveBookingFailed(String error) {
    return 'Failed to approve booking: $error';
  }

  @override
  String ownerPgRejectBookingFailed(String error) {
    return 'Failed to reject booking: $error';
  }

  @override
  String ownerPgRescheduleBookingFailed(String error) {
    return 'Failed to reschedule booking: $error';
  }

  @override
  String get ownerPgIdNotInitialized => 'PG ID not initialized';

  @override
  String ownerPgUpdateBedStatusFailed(String error) {
    return 'Failed to update bed status: $error';
  }

  @override
  String ownerPgRefreshFailed(String error) {
    return 'Failed to refresh data: $error';
  }

  @override
  String ownerPgSaveFailed(String error) {
    return 'Failed to save PG: $error';
  }

  @override
  String get ownerPgIdNotProvided => 'PG ID not provided';

  @override
  String ownerPgUpdateFailed(String error) {
    return 'Failed to update PG: $error';
  }

  @override
  String ownerPgDeleteFailed(String error) {
    return 'Failed to delete PG: $error';
  }

  @override
  String ownerPgCreateFailed(String error) {
    return 'Failed to create PG: $error';
  }

  @override
  String ownerPgRevenueReportFailed(String error) {
    return 'Failed to get revenue report: $error';
  }

  @override
  String ownerPgOccupancyReportFailed(String error) {
    return 'Failed to get occupancy report: $error';
  }

  @override
  String ownerPgFetchListFailed(String error) {
    return 'Failed to fetch PGs: $error';
  }

  @override
  String ownerPgFetchDetailsFailed(String error) {
    return 'Failed to fetch PG details: $error';
  }

  @override
  String get ownerPgBasicInfoZeroStateMessage =>
      'Fill in the basic information about your PG to get started.';

  @override
  String get ownerPgQuickStatRequired => 'Required';

  @override
  String get ownerPgQuickStatRentTypes => 'Rent Types';

  @override
  String get ownerPgQuickStatDeposit => 'Deposit';

  @override
  String get ownerPgStatusNotSet => 'Not Set';

  @override
  String get ownerPgStatusSet => 'Set';

  @override
  String get ownerPgFloorStructureZeroStateMessage =>
      'Set up the floor structure, rooms, and beds for your PG.';

  @override
  String get ownerPgQuickStatFloors => 'Floors';

  @override
  String get ownerPgQuickStatRooms => 'Rooms';

  @override
  String get ownerPgQuickStatBeds => 'Beds';

  @override
  String get ownerPgAmenitiesZeroStateMessage =>
      'Select the amenities your PG offers to help guests find you.';

  @override
  String get ownerPgPhotosZeroStateMessage =>
      'Add photos of your PG to showcase it to potential guests.';

  @override
  String get ownerPgQuickStatSelected => 'Selected';

  @override
  String get ownerPgBedNumberingDescription =>
      'Number beds consistently based on door position so everyone agrees.';

  @override
  String get ownerPgBedNumberingRule =>
      'Rule: Stand at the entrance facing inside → left-to-right, front-to-back (door wall to opposite wall).';

  @override
  String get ownerPgBedLayoutTwoByTwo => '2x2 layout';

  @override
  String get ownerPgBedLayoutOneByFour => '1x4 along a wall (door → last wall)';

  @override
  String get ownerPgBed1NearestLeft => 'Bed-1: nearest row, left side';

  @override
  String get ownerPgBed2NearestRight => 'Bed-2: nearest row, right side';

  @override
  String get ownerPgBed3FarLeft => 'Bed-3: far row, left side';

  @override
  String get ownerPgBed4FarRight => 'Bed-4: far row, right side';

  @override
  String get ownerPgBed1ClosestDoor => 'Bed-1: closest to door';

  @override
  String ownerPgBedNext(int number) {
    return 'Bed-$number: next';
  }

  @override
  String get ownerPgBed4Farthest => 'Bed-4: farthest from door';

  @override
  String get ownerPgRentConfigZeroStateMessage =>
      'Set up rent amounts for different sharing types and maintenance charges.';

  @override
  String ownerPgProgressDescription(int completed, int total) {
    return '$completed of $total sections completed';
  }

  @override
  String get ownerPgLoadingDetails => 'Loading PG details...';

  @override
  String get ownerPgPublishedSuccessfully => 'PG published successfully';

  @override
  String get ownerPgPublishFailed => 'Failed to publish PG';

  @override
  String ownerAnalyticsLoadFailed(String error) {
    return 'Failed to load analytics data: $error';
  }

  @override
  String get ownerProfileUpdateSuccess => 'Profile updated successfully';

  @override
  String ownerProfileUpdateFailure(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get replaceQrCode => 'Replace QR Code';

  @override
  String get removeQrCode => 'Remove QR Code';

  @override
  String get previewQrCode => 'Preview QR Code';

  @override
  String get noQrCodeSelected => 'No QR code selected yet';

  @override
  String get newQrCodeSelected => 'New QR code selected';

  @override
  String get existingQrCode => 'Existing QR code';

  @override
  String get exampleBankName => 'e.g., State Bank of India';

  @override
  String get exampleIfsc => 'e.g., SBIN0001234';

  @override
  String get exampleUpiId => 'yourname@paytm';

  @override
  String get qrCodeInfoText =>
      'You can generate a QR code from any UPI app like PhonePe, Paytm, Google Pay, etc.';

  @override
  String get ownerProfileInitialFallback => 'O';

  @override
  String get ownerProfileVerifiedStatus => 'Verified';

  @override
  String get ownerProfilePendingVerificationStatus => 'Pending Verification';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get dateFormatDdMmYyyy => 'DD/MM/YYYY';

  @override
  String get guestUser => 'Guest User';

  @override
  String get guestInitialsFallback => 'GU';

  @override
  String perMonthAmount(String amount) {
    return '$amount/month';
  }

  @override
  String get pgPayment => 'PG Payment';

  @override
  String get paymentTypeRent => 'Rent Payment';

  @override
  String get paymentTypeSecurityDeposit => 'Security Deposit';

  @override
  String get paymentTypeMaintenance => 'Maintenance Fee';

  @override
  String get paymentTypeLateFee => 'Late Fee';

  @override
  String paymentTypeOther(String type) {
    return '$type Payment';
  }

  @override
  String get paymentCompletedSuccessfully => 'Payment completed successfully';

  @override
  String get paymentPending => 'Payment pending';

  @override
  String get paymentOverdue => 'Payment overdue — please pay immediately';

  @override
  String get paymentFailedMessage => 'Payment failed — please try again';

  @override
  String get paymentRefunded => 'Payment has been refunded';

  @override
  String get unknownStatus => 'Unknown status';

  @override
  String get paymentFilterChangedEvent => 'payment_filter_changed';

  @override
  String get paymentLoadErrorEvent => 'payment_load_error';

  @override
  String get pendingPaymentsLoadErrorEvent => 'pending_payments_load_error';

  @override
  String get overduePaymentsLoadErrorEvent => 'overdue_payments_load_error';

  @override
  String get paymentStatsLoadErrorEvent => 'payment_stats_load_error';

  @override
  String get paymentAddedSuccessfullyEvent => 'payment_added_successfully';

  @override
  String get paymentAddFailedEvent => 'payment_add_failed';

  @override
  String get paymentUpdatedSuccessfullyEvent => 'payment_updated_successfully';

  @override
  String get paymentUpdateFailedEvent => 'payment_update_failed';

  @override
  String get paymentStatusUpdatedSuccessfullyEvent =>
      'payment_status_updated_successfully';

  @override
  String get paymentStatusUpdateFailedEvent => 'payment_status_update_failed';

  @override
  String get paymentDeletedSuccessfullyEvent => 'payment_deleted_successfully';

  @override
  String get paymentDeletionFailedEvent => 'payment_deletion_failed';

  @override
  String get paymentsRefreshedEvent => 'payments_refreshed';

  @override
  String failedToLoadPayments(String error) {
    return 'Failed to load payments: $error';
  }

  @override
  String failedToAddPayment(String error) {
    return 'Failed to add payment: $error';
  }

  @override
  String failedToUpdatePaymentStatus(String error) {
    return 'Failed to update payment status: $error';
  }

  @override
  String failedToFetchPayment(String error) {
    return 'Failed to fetch payment: $error';
  }

  @override
  String failedToDeletePayment(String error) {
    return 'Failed to delete payment: $error';
  }

  @override
  String get paymentSimulationDeprecated => 'Payment simulation is deprecated.';

  @override
  String get paymentSimulationRecommendation =>
      'Please use real payment gateways (Razorpay, UPI, or Cash) via the payment method selection dialog.';

  @override
  String get paymentNotificationReceivedTitle => 'Payment Received';

  @override
  String paymentNotificationReceivedBody(Object amount) {
    return 'Payment of $amount received from guest';
  }

  @override
  String get selectPaymentMethodTitle => 'Select Payment Method';

  @override
  String get selectPaymentMethodSubtitle =>
      'Choose how you want to make the payment';

  @override
  String get razorpayPaymentDescription => 'Secure online payment via Razorpay';

  @override
  String get upiPaymentDescription =>
      'Pay via PhonePe, Paytm, Google Pay, etc. and share screenshot';

  @override
  String get cashPaymentDescription =>
      'Pay in cash and request owner confirmation';

  @override
  String get guestProfileLoadedEvent => 'guest_profile_loaded';

  @override
  String get guestProfileUpdateSuccessEvent => 'guest_profile_update_success';

  @override
  String get guestProfileFieldsUpdateSuccessEvent =>
      'guest_profile_fields_update_success';

  @override
  String get profilePhotoUploadSuccessEvent => 'profile_photo_upload_success';

  @override
  String get aadhaarPhotoUploadSuccessEvent => 'aadhaar_photo_upload_success';

  @override
  String get idProofUploadSuccessEvent => 'id_proof_upload_success';

  @override
  String get guestStatusUpdateSuccessEvent => 'guest_status_update_success';

  @override
  String get guestProfileClearedEvent => 'guest_profile_cleared';

  @override
  String get guestProfileEditStartedEvent => 'guest_profile_edit_started';

  @override
  String get guestProfileEditCancelledEvent => 'guest_profile_edit_cancelled';

  @override
  String get guestProfileRefreshedEvent => 'guest_profile_refreshed';

  @override
  String get guestProfileNotFoundEvent => 'guest_profile_not_found';

  @override
  String get guestProfileViewedEvent => 'guest_profile_viewed';

  @override
  String get guestProfileFetchErrorEvent => 'guest_profile_fetch_error';

  @override
  String get guestProfileUpdatedEvent => 'guest_profile_updated';

  @override
  String get guestProfileUpdateErrorEvent => 'guest_profile_update_error';

  @override
  String get guestProfileFieldsUpdatedEvent => 'guest_profile_fields_updated';

  @override
  String get guestProfileFieldsUpdateErrorEvent =>
      'guest_profile_fields_update_error';

  @override
  String get profilePhotoUploadedEvent => 'profile_photo_uploaded';

  @override
  String get profilePhotoUploadErrorEvent => 'profile_photo_upload_error';

  @override
  String get aadhaarPhotoUploadedEvent => 'aadhaar_photo_uploaded';

  @override
  String get aadhaarPhotoUploadErrorEvent => 'aadhaar_photo_upload_error';

  @override
  String get idProofUploadedEvent => 'id_proof_uploaded';

  @override
  String get idProofUploadErrorEvent => 'id_proof_upload_error';

  @override
  String get guestProfileDeletedEvent => 'guest_profile_deleted';

  @override
  String get guestProfileDeleteErrorEvent => 'guest_profile_delete_error';

  @override
  String get guestStatusUpdatedEvent => 'guest_status_updated';

  @override
  String get guestStatusUpdateErrorEvent => 'guest_status_update_error';

  @override
  String failedToLoadProfile(String error) {
    return 'Failed to load profile: $error';
  }

  @override
  String failedToStreamProfile(String error) {
    return 'Failed to stream profile: $error';
  }

  @override
  String failedToUpdateGuestProfile(String error) {
    return 'Failed to update guest profile: $error';
  }

  @override
  String failedToUpdateProfileFields(String error) {
    return 'Failed to update profile fields: $error';
  }

  @override
  String failedToUploadIdProof(String error) {
    return 'Failed to upload ID proof: $error';
  }

  @override
  String failedToUpdateGuestStatus(String error) {
    return 'Failed to update guest status: $error';
  }

  @override
  String failedToFetchGuestProfile(String error) {
    return 'Failed to fetch guest profile: $error';
  }

  @override
  String failedToDeleteGuestProfile(String error) {
    return 'Failed to delete guest profile: $error';
  }

  @override
  String get noChangesToSave => 'No changes to save';

  @override
  String get pgsLoadedEvent => 'pgs_loaded';

  @override
  String get pgsLoadErrorEvent => 'pgs_load_error';

  @override
  String get pgSelectedEvent => 'pg_selected';

  @override
  String get pgFilterChangedEvent => 'pg_filter_changed';

  @override
  String get pgSearchQueryChangedEvent => 'pg_search_query_changed';

  @override
  String get pgAmenitiesFilterChangedEvent => 'pg_amenities_filter_changed';

  @override
  String get pgCityFilterChangedEvent => 'pg_city_filter_changed';

  @override
  String get pgTypeFilterChangedEvent => 'pg_type_filter_changed';

  @override
  String get pgMealTypeFilterChangedEvent => 'pg_meal_type_filter_changed';

  @override
  String get pgWifiFilterChangedEvent => 'pg_wifi_filter_changed';

  @override
  String get pgParkingFilterChangedEvent => 'pg_parking_filter_changed';

  @override
  String get pgFiltersClearedEvent => 'pg_filters_cleared';

  @override
  String get pgSavedEvent => 'pg_saved';

  @override
  String get pgDeletedEvent => 'pg_deleted';

  @override
  String get pgNotFoundEvent => 'pg_not_found';

  @override
  String get pgViewedEvent => 'pg_viewed';

  @override
  String get pgFetchErrorEvent => 'pg_fetch_error';

  @override
  String get pgSaveErrorEvent => 'pg_save_error';

  @override
  String get pgDeleteErrorEvent => 'pg_delete_error';

  @override
  String get pgPhotoUploadedEvent => 'pg_photo_uploaded';

  @override
  String get pgPhotoUploadErrorEvent => 'pg_photo_upload_error';

  @override
  String get pgSearchPerformedEvent => 'pg_search_performed';

  @override
  String get pgSearchErrorEvent => 'pg_search_error';

  @override
  String get ownerPgsFetchedEvent => 'owner_pgs_fetched';

  @override
  String get ownerPgsFetchErrorEvent => 'owner_pgs_fetch_error';

  @override
  String get cityPgsFetchedEvent => 'city_pgs_fetched';

  @override
  String get cityPgsFetchErrorEvent => 'city_pgs_fetch_error';

  @override
  String get amenityPgsFetchedEvent => 'amenity_pgs_fetched';

  @override
  String get amenityPgsFetchErrorEvent => 'amenity_pgs_fetch_error';

  @override
  String failedToLoadPgs(String error) {
    return 'Failed to load PGs: $error';
  }

  @override
  String failedToLoadPgDetails(String error) {
    return 'Failed to load PG details: $error';
  }

  @override
  String failedToSavePg(String error) {
    return 'Failed to save PG: $error';
  }

  @override
  String failedToDeletePg(String error) {
    return 'Failed to delete PG: $error';
  }

  @override
  String failedToLoadPgStats(String error) {
    return 'Failed to load PG statistics: $error';
  }

  @override
  String failedToUploadPgPhoto(String error) {
    return 'Failed to upload PG photo: $error';
  }

  @override
  String failedToPerformPgSearch(String error) {
    return 'Failed to perform search: $error';
  }

  @override
  String failedToFetchPgDetails(String error) {
    return 'Failed to load PG details: $error';
  }

  @override
  String failedToSearchPgs(String error) {
    return 'Failed to search PGs: $error';
  }

  @override
  String failedToFetchOwnerPgs(String error) {
    return 'Failed to fetch owner PGs: $error';
  }

  @override
  String failedToFetchCityPgs(String error) {
    return 'Failed to fetch city PGs: $error';
  }

  @override
  String failedToFetchAmenityPgs(String error) {
    return 'Failed to fetch amenity PGs: $error';
  }

  @override
  String failedToGetPgStats(String error) {
    return 'Failed to get PG stats: $error';
  }

  @override
  String get guestPgProviderInitializedEvent => 'guest_pg_provider_initialized';

  @override
  String get guestPgSelectedEvent => 'guest_pg_selected';

  @override
  String get guestPgClearedEvent => 'guest_pg_cleared';

  @override
  String get guestPgSelectionRestoredEvent => 'guest_pg_selection_restored';

  @override
  String get guestPgSelectionRestoreFailedEvent =>
      'guest_pg_selection_restore_failed';

  @override
  String get guestPgSelectionSavedEvent => 'guest_pg_selection_saved';

  @override
  String get guestPgSelectionSaveFailedEvent =>
      'guest_pg_selection_save_failed';

  @override
  String get guestPgSelectionClearedStorageEvent =>
      'guest_pg_selection_cleared_storage';

  @override
  String get guestPgSelectionClearFailedEvent =>
      'guest_pg_selection_clear_failed';

  @override
  String get guestBookingRequestSentEvent => 'guest_booking_request_sent';

  @override
  String get bookingRequestNotificationFailedEvent =>
      'booking_request_notification_failed';

  @override
  String get newBookingRequestTitle => 'New Booking Request';

  @override
  String newBookingRequestBody(String guestName, String pgName) {
    return '$guestName requested to join $pgName';
  }

  @override
  String failedToInitializeGuestPgSelection(String error) {
    return 'Failed to initialize PG selection: $error';
  }

  @override
  String failedToSelectGuestPg(String error) {
    return 'Failed to select PG: $error';
  }

  @override
  String failedToClearGuestPgSelection(String error) {
    return 'Failed to clear PG selection: $error';
  }

  @override
  String failedToSendBookingRequest(String error) {
    return 'Failed to send booking request: $error';
  }

  @override
  String failedToUpdateBookingStatus(String error) {
    return 'Failed to update booking status: $error';
  }

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyLastUpdatedLabel => 'Last Updated';

  @override
  String get privacyPolicyLastUpdatedDate => 'November 11, 2025';

  @override
  String privacyPolicyHostedNotice(String url) {
    return 'You can review the most recent version online at $url.';
  }

  @override
  String get privacyPolicyViewOnlineButton => 'Open privacy policy website';

  @override
  String get privacyPolicyOpenLinkError =>
      'Unable to open privacy policy. Please try again later.';

  @override
  String get privacyPolicySection1Title => '1. Information We Collect';

  @override
  String get privacyPolicySection1Content =>
      'We collect information that you provide directly to us, including:\n• Account details (name, email address, profile photo, or other identifiers)\n• Communications such as support messages, feedback, and survey responses\n• Content you share, including uploads, media, and in-app inputs\n• Sensitive data only when you give explicit consent for a feature';

  @override
  String get privacyPolicySection2Title => '2. How We Use Your Information';

  @override
  String get privacyPolicySection2Content =>
      'We use the information we collect to:\n• Provide, operate, maintain, and improve the Services\n• Personalize your experience and deliver relevant content\n• Handle account creation, authentication, and customer support\n• Analyze usage trends, diagnose issues, and ensure service reliability\n• Send service announcements, security alerts, and updates\n• Enforce our terms, prevent abuse, and comply with legal obligations';

  @override
  String get privacyPolicySection3Title => '3. Information Sharing';

  @override
  String get privacyPolicySection3Content =>
      'We share personal data only when necessary:\n• With service providers that support hosting, analytics, payments, or security and are bound by confidentiality\n• To comply with applicable laws, regulations, or lawful requests\n• During a business transfer such as a merger, acquisition, or asset sale\n• With your consent or at your direction';

  @override
  String get privacyPolicySection4Title => '4. Data Security';

  @override
  String get privacyPolicySection4Content =>
      'We deploy technical and organizational safeguards—encryption in transit, secure storage, access controls, and regular reviews—to protect your data. However, no transmission or storage system is completely secure, so we encourage you to use strong passwords and notify us of any suspected unauthorized activity.';

  @override
  String get privacyPolicySection5Title => '5. Your Rights';

  @override
  String get privacyPolicySection5Content =>
      'You can:\n• Request access to or a copy of the information we hold about you\n• Update or correct inaccurate data\n• Request deletion of your data, subject to legal retention requirements\n• Withdraw consent for optional data processing\n• Opt out of marketing and non-essential communications';

  @override
  String get privacyPolicySection6Title => '6. Contact Us';

  @override
  String get privacyPolicySection6Content =>
      'If you have questions about this Privacy Policy, please contact us at:\n\nEmail: bantirathodtech@gmail.com\nAddress: Hitech City, Hyderabad, Telangana, India 500083';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get termsOfServiceLastUpdatedLabel => 'Last Updated';

  @override
  String get termsOfServiceLastUpdatedDate => 'November 2025';

  @override
  String get termsOfServiceSection1Title => '1. Acceptance of Terms';

  @override
  String get termsOfServiceSection1Content =>
      'By accessing and using the Atitia app, you accept and agree to be bound by these Terms of Service. If you do not agree, please do not use our services.';

  @override
  String get termsOfServiceSection2Title => '2. User Accounts';

  @override
  String get termsOfServiceSection2Content =>
      'You are responsible for:\n• Maintaining the confidentiality of your account\n• All activities that occur under your account\n• Providing accurate and complete information';

  @override
  String get termsOfServiceSection3Title => '3. Booking and Payments';

  @override
  String get termsOfServiceSection3Content =>
      '• Booking requests are subject to owner approval\n• Payment terms are as agreed with the property owner\n• Refunds are subject to the property\'s cancellation policy\n• We facilitate transactions but are not a party to the rental agreement';

  @override
  String get termsOfServiceSection4Title =>
      '4. Property Owner Responsibilities';

  @override
  String get termsOfServiceSection4Content =>
      'Property owners must:\n• Provide accurate property information\n• Honor confirmed bookings\n• Maintain property standards\n• Respond to guest inquiries promptly';

  @override
  String get termsOfServiceSection5Title => '5. Prohibited Activities';

  @override
  String get termsOfServiceSection5Content =>
      'You agree not to:\n• Use the service for illegal purposes\n• Post false or misleading information\n• Interfere with the app\'s functionality\n• Attempt unauthorized access to the system';

  @override
  String get termsOfServiceSection6Title => '6. Limitation of Liability';

  @override
  String get termsOfServiceSection6Content =>
      'Atitia provides the platform \"as is\" and is not liable for:\n• Disputes between guests and property owners\n• Property condition or safety issues\n• Payment disputes or refunds\n• Indirect or consequential damages';

  @override
  String get termsOfServiceSection7Title => '7. Changes to Terms';

  @override
  String get termsOfServiceSection7Content =>
      'We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.';

  @override
  String get termsOfServiceSection8Title => '8. Contact Information';

  @override
  String get termsOfServiceSection8Content =>
      'For questions about these Terms, contact us at:\n\nEmail: legal@atitia.com\nPhone: +91 1234567890';

  @override
  String get notificationPreferencesTitle => 'Notification Preferences';

  @override
  String get notificationPreferencesSubtitle =>
      'Choose which types of notifications you want to receive';

  @override
  String get notificationSettingsTitle => 'Notification Settings';

  @override
  String get notificationCategoryPaymentTitle => 'Payment Notifications';

  @override
  String get notificationCategoryPaymentSubtitle =>
      'Rent reminders, payment confirmations';

  @override
  String get notificationCategoryBookingTitle => 'Booking Updates';

  @override
  String get notificationCategoryBookingSubtitle =>
      'Booking confirmations, status changes';

  @override
  String get notificationCategoryComplaintTitle => 'Complaint Updates';

  @override
  String get notificationCategoryComplaintSubtitle =>
      'Complaint responses, resolution updates';

  @override
  String get notificationCategoryFoodTitle => 'Food Notifications';

  @override
  String get notificationCategoryFoodSubtitle => 'Menu updates, special meals';

  @override
  String get notificationCategoryMaintenanceTitle => 'Maintenance Alerts';

  @override
  String get notificationCategoryMaintenanceSubtitle =>
      'Scheduled maintenance, repairs';

  @override
  String get notificationCategoryGeneralTitle => 'General Announcements';

  @override
  String get notificationCategoryGeneralSubtitle =>
      'Important updates, announcements';

  @override
  String get analyticsDashboardTitle => 'Analytics Dashboard';

  @override
  String get performanceMetricsTitle => 'Performance Metrics';

  @override
  String get noPerformanceMetricsAvailable =>
      'No performance metrics available';

  @override
  String get userJourneyTitle => 'User Journey';

  @override
  String get userJourneyDescription =>
      'Track user interactions and screen flows';

  @override
  String get viewJourneyDetails => 'View Journey Details';

  @override
  String get businessIntelligenceTitle => 'Business Intelligence';

  @override
  String get metricTotalSessions => 'Total Sessions';

  @override
  String get metricActiveUsers => 'Active Users';

  @override
  String get metricConversionRate => 'Conversion Rate';

  @override
  String get metricAverageSessionDuration => 'Avg Session Duration';

  @override
  String get viewInsights => 'View Insights';

  @override
  String get userJourneyDetailsTitle => 'User Journey Details';

  @override
  String get userJourneyDetailsDescription =>
      'Detailed user journey visualization would be implemented here with charts and flow diagrams.';

  @override
  String get businessInsightsTitle => 'Business Insights';

  @override
  String get businessInsightsDescription =>
      'Advanced business intelligence dashboard with charts, trends, and predictive analytics would be implemented here.';

  @override
  String get analyticsWidgetTitle => 'Analytics';

  @override
  String get analyticsSessionsLabel => 'Sessions';

  @override
  String get analyticsAverageTimeLabel => 'Avg Time';

  @override
  String get networkErrorTryAgain =>
      'Please check your internet connection and try again.';

  @override
  String get permissionDeniedMessage =>
      'You don\'t have permission to perform this action.';

  @override
  String get itemNotFoundMessage => 'The requested item could not be found.';

  @override
  String get requestTimeoutMessage =>
      'The request took too long. Please try again.';

  @override
  String get sessionExpiredMessage =>
      'Your session has expired. Please sign in again.';

  @override
  String get invalidInputMessage => 'Please check your input and try again.';

  @override
  String get genericErrorMessage => 'Something went wrong. Please try again.';

  @override
  String get requiredFieldError => 'This field is required';

  @override
  String get invalidPhoneError => 'Please enter a valid phone number';

  @override
  String get fileSizeExceeded => 'File size exceeds maximum limit';

  @override
  String get workspaceTitle => 'Workspace';

  @override
  String get defaultCompanyName => 'Atitia PG Management';

  @override
  String get noSharingInfoAvailable => 'No sharing info available.';

  @override
  String get sharingAndVacancy => 'Sharing & Vacancy';

  @override
  String get sharingColumn => 'Sharing';

  @override
  String get roomsColumn => 'Rooms';

  @override
  String get vacantBedsColumn => 'Vacant beds';

  @override
  String get rentPerBedColumn => 'Rent / bed';

  @override
  String get vacantBedsAvailable => 'Available';

  @override
  String sharingPricePerBed(String amount) {
    return '$amount/bed';
  }

  @override
  String get anonymousGuest => 'Anonymous Guest';

  @override
  String get locationLabel => 'Location';

  @override
  String get staffLabel => 'Staff';

  @override
  String get viewPhotos => 'View Photos';

  @override
  String helpfulWithCount(int count) {
    return 'Helpful ($count)';
  }

  @override
  String get writeReview => 'Write a Review';

  @override
  String get overallRating => 'Overall Rating';

  @override
  String get aspectRatings => 'Aspect Ratings';

  @override
  String get commentsLabel => 'Comments';

  @override
  String get shareExperienceHint => 'Share your experience...';

  @override
  String get optionalAddPhotos => 'Optional: Add photos to your review';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get submitting => 'Submitting';

  @override
  String get pleaseProvideOverallRating => 'Please provide an overall rating';

  @override
  String get reviewSubmittedSuccessfully => 'Review submitted successfully!';

  @override
  String failedToSubmitReview(String error) {
    return 'Failed to submit review: $error';
  }

  @override
  String get ratingPoor => 'Poor';

  @override
  String get ratingFair => 'Fair';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingVeryGood => 'Very Good';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String get selectRating => 'Select a rating';

  @override
  String photosCountLabel(int count, int max) {
    return 'Photos ($count/$max)';
  }

  @override
  String get uploadingPhotos => 'Uploading photos...';

  @override
  String errorPickingPhotos(String error) {
    return 'Error picking photos: $error';
  }

  @override
  String get allPhotoUploadsFailed =>
      'All photo uploads failed. Please try again.';

  @override
  String failedToUploadPhotos(String error) {
    return 'Failed to upload photos: $error';
  }

  @override
  String get noItemsFound => 'No items found';

  @override
  String get searchHint => 'Search...';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String themeTooltip(String current, String next) {
    return 'Theme: $current\nTap for $next';
  }

  @override
  String get themeModeTitle => 'Theme Mode';

  @override
  String get themeLightDescription => 'Always use bright theme';

  @override
  String get themeDarkDescription => 'Always use dark theme';

  @override
  String get themeSystemDescription => 'Follow device settings';

  @override
  String get menu => 'Menu';

  @override
  String get noPgSelected => 'No PG Selected';

  @override
  String get uploadingStatus => 'Uploading...';

  @override
  String get documentUploadedSuccessfully => 'Document uploaded successfully';

  @override
  String get tapToUpload => 'Tap to upload';

  @override
  String get uploadSupportedFormats => 'JPG, PNG up to 10MB';

  @override
  String unsupportedFileType(String type) {
    return 'Unsupported file type: $type';
  }

  @override
  String get offlineActionCreate => 'Create';

  @override
  String get offlineActionUpdate => 'Update';

  @override
  String get offlineActionDelete => 'Delete';

  @override
  String get offlineActionSync => 'Sync';

  @override
  String get weekday_monday => 'Monday';

  @override
  String get weekday_tuesday => 'Tuesday';

  @override
  String get weekday_wednesday => 'Wednesday';

  @override
  String get weekday_thursday => 'Thursday';

  @override
  String get weekday_friday => 'Friday';

  @override
  String get weekday_saturday => 'Saturday';

  @override
  String get weekday_sunday => 'Sunday';

  @override
  String menuDefaultDescription(String day) {
    return 'Default menu for $day - customize as needed';
  }

  @override
  String get menuBreakfast_monday =>
      'Idli with Sambar and Coconut Chutney|Vada (2 pieces)|Filter Coffee|Banana';

  @override
  String get menuBreakfast_tuesday =>
      'Masala Dosa with Sambar and Chutney|Medu Vada|Tea|Seasonal Fruit';

  @override
  String get menuBreakfast_wednesday =>
      'Upma with Coconut Chutney|Vada (2 pieces)|Coffee|Boiled Eggs (2)';

  @override
  String get menuBreakfast_thursday =>
      'Poha with Peanuts and Curry Leaves|Banana Chips|Tea|Papaya';

  @override
  String get menuBreakfast_friday =>
      'Puri with Potato Bhaji|Halwa|Coffee|Orange';

  @override
  String get menuBreakfast_saturday =>
      'Pesarattu (Green Gram Dosa) with Ginger Chutney|Upma|Tea|Seasonal Fruit';

  @override
  String get menuBreakfast_sunday =>
      'Special Breakfast - Pongal with Vada|Sweet Pongal|Filter Coffee|Banana';

  @override
  String get menuLunch_monday =>
      'Steamed Rice|Sambar|Rasam|Vegetable Curry (Beans Palya)|Curd|Papad|Buttermilk';

  @override
  String get menuLunch_tuesday =>
      'Steamed Rice|Dal Tadka|Rasam|Cabbage Poriyal|Brinjal Curry|Curd|Pickle';

  @override
  String get menuLunch_wednesday =>
      'Jeera Rice|Sambar|Rasam|Potato Fry|Spinach Dal|Curd|Papad';

  @override
  String get menuLunch_thursday =>
      'Steamed Rice|Moong Dal|Rasam|Mixed Vegetable Curry|Beetroot Poriyal|Curd|Buttermilk';

  @override
  String get menuLunch_friday =>
      'Lemon Rice|Sambar|Rasam|Okra Fry (Bhendi)|Carrot Poriyal|Curd|Pickle';

  @override
  String get menuLunch_saturday =>
      'Steamed Rice|Toor Dal|Rasam|Pumpkin Curry|Green Beans Poriyal|Curd|Papad';

  @override
  String get menuLunch_sunday =>
      'Special Lunch - Pulao|Sambar|Rasam|Paneer Butter Masala|Raita|Sweet (Payasam)|Papad';

  @override
  String get menuDinner_monday =>
      'Chapati (4 pieces)|Mixed Vegetable Curry|Dal Fry|Rice|Curd';

  @override
  String get menuDinner_tuesday =>
      'Chapati (4 pieces)|Palak Paneer|Dal Tadka|Rice|Pickle';

  @override
  String get menuDinner_wednesday =>
      'Paratha (3 pieces)|Aloo Gobi|Moong Dal|Rice|Curd';

  @override
  String get menuDinner_thursday =>
      'Chapati (4 pieces)|Chana Masala|Tomato Rasam|Rice|Raita';

  @override
  String get menuDinner_friday =>
      'Puri (6 pieces)|Aloo Curry|Chana Dal|Rice|Curd';

  @override
  String get menuDinner_saturday =>
      'Chapati (4 pieces)|Egg Curry (2 eggs)|Dal Tadka|Rice|Pickle';

  @override
  String get menuDinner_sunday =>
      'Special Dinner - Naan (3 pieces)|Paneer Tikka Masala|Dal Makhani|Jeera Rice|Raita|Gulab Jamun (2 pieces)';

  @override
  String get menuMealTypeBreakfastDescription =>
      'Morning meal (6:00 AM - 10:00 AM)';

  @override
  String get menuMealTypeLunchDescription =>
      'Afternoon meal (12:00 PM - 3:00 PM)';

  @override
  String get menuMealTypeDinnerDescription =>
      'Evening meal (7:00 PM - 10:00 PM)';

  @override
  String get menuMealTypeGeneric => 'Meal';

  @override
  String logButtonClicked(String buttonName) {
    return 'Button clicked: $buttonName';
  }

  @override
  String logFormSubmitted(String formName) {
    return 'Form submitted: $formName';
  }

  @override
  String logFilterChanged(String filterType) {
    return 'Filter changed: $filterType';
  }

  @override
  String get logSearchPerformed => 'Search performed';

  @override
  String logScreenViewed(String screenName) {
    return 'Screen viewed: $screenName';
  }

  @override
  String logDataLoading(String dataType) {
    return 'Data loading: $dataType';
  }

  @override
  String logErrorOperation(String operation, String error) {
    return 'Error in $operation: $error';
  }

  @override
  String dateInvalidFormat(String expected, String value) {
    return 'Invalid date format. Expected $expected but got \"$value\"';
  }

  @override
  String dateComponentsNotNumbers(String value) {
    return 'Date components must be valid numbers: \"$value\"';
  }

  @override
  String dateInvalidCalendar(String value) {
    return 'Invalid calendar date: \"$value\"';
  }

  @override
  String dateEnterAsExpected(String expected) {
    return 'Enter date as $expected';
  }

  @override
  String get dateDigitsOnly => 'Date must contain only digits';

  @override
  String get dateCalendarInvalid => 'Enter a valid calendar date';

  @override
  String dateGenericInvalid(String expected) {
    return 'Enter a valid date ($expected)';
  }

  @override
  String get dateDayRange => 'Day must be between 1 and 31';

  @override
  String get dateMonthRange => 'Month must be between 1 and 12';

  @override
  String dateYearRange(int min, int max) {
    return 'Year must be between $min and $max';
  }

  @override
  String get credentialInvalidWebClientId =>
      'Invalid Google Web Client ID format';

  @override
  String get credentialStoredWebClientId =>
      'Google Web Client ID stored in secure storage';

  @override
  String credentialStoreWebClientIdFailure(String error) {
    return 'Failed to store Google Web Client ID: $error';
  }

  @override
  String get credentialInvalidAndroidClientId =>
      'Invalid Google Android Client ID format';

  @override
  String get credentialStoredAndroidClientId =>
      'Google Android Client ID stored in secure storage';

  @override
  String credentialStoreAndroidClientIdFailure(String error) {
    return 'Failed to store Google Android Client ID: $error';
  }

  @override
  String get credentialInvalidIosClientId =>
      'Invalid Google iOS Client ID format';

  @override
  String get credentialStoredIosClientId =>
      'Google iOS Client ID stored in secure storage';

  @override
  String credentialStoreIosClientIdFailure(String error) {
    return 'Failed to store Google iOS Client ID: $error';
  }

  @override
  String get credentialInvalidClientSecret =>
      'Invalid Google Client Secret format';

  @override
  String get credentialStoredClientSecret =>
      'Google Client Secret stored in secure storage';

  @override
  String credentialStoreClientSecretFailure(String error) {
    return 'Failed to store Google Client Secret: $error';
  }

  @override
  String get credentialClearedAll =>
      'All Google OAuth credentials cleared from secure storage';

  @override
  String credentialClearFailure(String error) {
    return 'Failed to clear credentials: $error';
  }

  @override
  String credentialCheckFailure(String error) {
    return 'Failed to check stored credentials: $error';
  }

  @override
  String securityAuthFailureDescription(String userId, String failureReason) {
    return 'Authentication failed for user $userId: $failureReason';
  }

  @override
  String securityMultipleFailuresDetected(String userId) {
    return 'Multiple failed authentication attempts detected for user $userId';
  }

  @override
  String securityAuthSuccessDescription(String userId) {
    return 'Successful authentication for user $userId';
  }

  @override
  String securityMultipleFailuresAlertDescription(String userId) {
    return 'Multiple failed authentication attempts for user $userId';
  }

  @override
  String securityEventConsoleLog(String eventType, String description) {
    return 'Security Event: $eventType - $description';
  }

  @override
  String securityEventSendFailure(String error) {
    return 'Failed to send security event to analytics: $error';
  }

  @override
  String securityAlertConsoleLog(
      String severity, String alertType, String description) {
    return 'Security Alert [$severity]: $alertType - $description';
  }

  @override
  String securityAlertSendFailure(String error) {
    return 'Failed to send security alert to services: $error';
  }

  @override
  String securitySuspiciousHeader(String header) {
    return 'Suspicious header detected: $header';
  }

  @override
  String get securitySuspiciousBody =>
      'Suspicious content detected in request body';

  @override
  String securityIpBlocked(String ip) {
    return 'IP blocked: $ip';
  }

  @override
  String get securityRateLimitExceeded => 'Rate limit exceeded';

  @override
  String get securityInvalidHeaders => 'Invalid request headers';

  @override
  String get securityInvalidBody => 'Invalid request body';

  @override
  String securityUnsupportedMethod(String method) {
    return 'Unsupported HTTP method: $method';
  }

  @override
  String securityRequestFailed(String error) {
    return 'Request failed: $error';
  }

  @override
  String securitySuspiciousResponseHeader(String header) {
    return 'Suspicious response header: $header';
  }

  @override
  String securityServerErrorResponse(String statusCode) {
    return 'Server error response: $statusCode';
  }

  @override
  String encryptionEncryptFailed(String error) {
    return 'Failed to encrypt data: $error';
  }

  @override
  String encryptionDecryptFailed(String error) {
    return 'Failed to decrypt data: $error';
  }

  @override
  String encryptionFileEncryptFailed(String error) {
    return 'Failed to encrypt file data: $error';
  }

  @override
  String encryptionFileDecryptFailed(String error) {
    return 'Failed to decrypt file data: $error';
  }

  @override
  String get securityInvalidEmailFormat => 'Invalid email format';

  @override
  String get securityInvalidPhoneFormat => 'Invalid phone number format';

  @override
  String secureStorageStoreFailed(String error) {
    return 'Failed to store secure data: $error';
  }

  @override
  String secureStorageRetrieveFailed(String error) {
    return 'Failed to retrieve secure data: $error';
  }

  @override
  String secureStorageStoreCredentialsFailed(String error) {
    return 'Failed to store user credentials: $error';
  }

  @override
  String secureStorageRetrieveCredentialsFailed(String error) {
    return 'Failed to retrieve user credentials: $error';
  }

  @override
  String secureStorageStoreAuthTokenFailed(String error) {
    return 'Failed to store auth token: $error';
  }

  @override
  String secureStorageRetrieveAuthTokenFailed(String error) {
    return 'Failed to retrieve auth token: $error';
  }

  @override
  String secureStorageStoreSessionFailed(String error) {
    return 'Failed to store user session: $error';
  }

  @override
  String secureStorageRetrieveSessionFailed(String error) {
    return 'Failed to retrieve user session: $error';
  }

  @override
  String secureStorageStoreProfileFailed(String error) {
    return 'Failed to store user profile: $error';
  }

  @override
  String secureStorageRetrieveProfileFailed(String error) {
    return 'Failed to retrieve user profile: $error';
  }

  @override
  String secureStorageStoreApiKeyFailed(String error) {
    return 'Failed to store API key: $error';
  }

  @override
  String secureStorageRetrieveApiKeyFailed(String error) {
    return 'Failed to retrieve API key: $error';
  }

  @override
  String secureStorageStorePaymentFailed(String error) {
    return 'Failed to store payment info: $error';
  }

  @override
  String secureStorageRetrievePaymentFailed(String error) {
    return 'Failed to retrieve payment info: $error';
  }

  @override
  String secureStorageStoreBiometricFailed(String error) {
    return 'Failed to store biometric data: $error';
  }

  @override
  String secureStorageRetrieveBiometricFailed(String error) {
    return 'Failed to retrieve biometric data: $error';
  }

  @override
  String secureStorageStoreDeviceSecurityFailed(String error) {
    return 'Failed to store device security data: $error';
  }

  @override
  String secureStorageRetrieveDeviceSecurityFailed(String error) {
    return 'Failed to retrieve device security data: $error';
  }

  @override
  String secureStorageDeleteFailed(String error) {
    return 'Failed to delete secure data: $error';
  }

  @override
  String secureStorageDeleteAllFailed(String error) {
    return 'Failed to delete all secure data: $error';
  }

  @override
  String secureStorageGetKeysFailed(String error) {
    return 'Failed to get all keys: $error';
  }

  @override
  String secureStorageClearUserDataFailed(String error) {
    return 'Failed to clear user data: $error';
  }

  @override
  String secureStorageGetStatsFailed(String error) {
    return 'Failed to get storage stats: $error';
  }

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationInvalidEmailFormat => 'Invalid email format';

  @override
  String get validationEmailInvalidAddress =>
      'Please enter a valid email address';

  @override
  String get validationEmailTooLong => 'Email address is too long';

  @override
  String get validationPhoneRequired => 'Phone number is required';

  @override
  String get validationInvalidPhoneFormat => 'Invalid phone number format';

  @override
  String get validationPhoneLength => 'Phone number must be 10 digits';

  @override
  String get validationPhoneInvalid =>
      'Please enter a valid Indian phone number';

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String get validationInvalidNameFormat => 'Invalid name format';

  @override
  String get validationNameTooShort => 'Name must be at least 2 characters';

  @override
  String validationNameTooLong(String max) {
    return 'Name must be less than $max characters';
  }

  @override
  String get validationNameInvalid =>
      'Name can only contain letters and spaces';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationInvalidPasswordFormat => 'Invalid password format';

  @override
  String validationPasswordTooShort(String min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get validationPasswordTooLong => 'Password is too long';

  @override
  String get validationPasswordUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get validationPasswordLowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get validationPasswordDigit =>
      'Password must contain at least one number';

  @override
  String get validationPasswordSpecial =>
      'Password must contain at least one special character';

  @override
  String get validationPasswordStrength =>
      'Password must include uppercase, lowercase, number, and special character';

  @override
  String get validationOtpRequired => 'OTP is required';

  @override
  String get validationInvalidOtpFormat => 'Invalid OTP format';

  @override
  String get validationOtpLength => 'OTP must be 6 digits';

  @override
  String get validationOtpDigitsOnly => 'OTP must contain only digits';

  @override
  String get validationAddressRequired => 'Address is required';

  @override
  String get validationInvalidAddressFormat => 'Invalid address format';

  @override
  String get validationAddressTooShort =>
      'Address must be at least 10 characters';

  @override
  String get validationAddressTooLong =>
      'Address must be less than 200 characters';

  @override
  String get validationAadhaarRequired => 'Aadhaar number is required';

  @override
  String get validationInvalidAadhaarFormat => 'Invalid Aadhaar number format';

  @override
  String get validationAadhaarLength => 'Aadhaar number must be 12 digits';

  @override
  String get validationPanRequired => 'PAN number is required';

  @override
  String get validationInvalidPanFormat => 'Invalid PAN number format';

  @override
  String get validationPanInvalid => 'Please enter a valid PAN number';

  @override
  String get validationFileRequired => 'File is required';

  @override
  String get validationFileMissing => 'File does not exist';

  @override
  String validationFileSizeExceeded(String max) {
    return 'File size must be less than ${max}MB';
  }

  @override
  String validationFileTypeNotAllowed(String types) {
    return 'File type not allowed. Allowed types: $types';
  }

  @override
  String get validationFieldRequired => 'This field is required';

  @override
  String validationFieldNameRequired(String field) {
    return '$field is required';
  }

  @override
  String get validationInvalidTextFormat => 'Invalid text format';

  @override
  String validationTextTooShort(String min) {
    return 'Text must be at least $min characters';
  }

  @override
  String validationTextTooLong(String max) {
    return 'Text must be less than $max characters';
  }

  @override
  String validationFieldMinLength(String field, String min) {
    return '$field must be at least $min characters';
  }

  @override
  String validationFieldMaxLength(String field, String max) {
    return '$field must be less than $max characters';
  }

  @override
  String validationFieldMustBeNumber(String field) {
    return '$field must be a valid number';
  }

  @override
  String validationFieldMustBeGreaterThanZero(String field) {
    return '$field must be greater than zero';
  }

  @override
  String validationFileSizeExceededDetailed(String fileType, String max) {
    return '${fileType}File size must be less than ${max}MB';
  }

  @override
  String get validationInvalidInput => 'Invalid input';

  @override
  String get validationDobRequired => 'Date of birth is required';

  @override
  String get validationDobFormat => 'Please enter date in DD/MM/YYYY format';

  @override
  String get validationDobInvalidDate => 'Invalid date format';

  @override
  String get validationDobFuture => 'Date of birth cannot be in the future';

  @override
  String get validationDobMinimumAge => 'You must be at least 18 years old';

  @override
  String get validationDobInvalid => 'Invalid date';

  @override
  String get appExceptionDefaultMessage => 'An error occurred';

  @override
  String get appExceptionDefaultRecovery => 'Please try again later';

  @override
  String get appExceptionDetailsLabel => 'Details';

  @override
  String get appExceptionSuggestionLabel => '💡 Suggestion';

  @override
  String get networkExceptionPrefix => 'Network Error';

  @override
  String get networkExceptionMessage => 'No internet connection';

  @override
  String get networkExceptionRecovery => 'Check your connection and try again';

  @override
  String get authExceptionPrefix => 'Auth Error';

  @override
  String get authExceptionMessage => 'Authentication failed';

  @override
  String get authExceptionRecovery =>
      'Please check your credentials and try again';

  @override
  String get dataParsingExceptionPrefix => 'Parsing Error';

  @override
  String get dataParsingExceptionMessage => 'Failed to parse data';

  @override
  String get dataParsingExceptionRecovery =>
      'Please try again or contact support if the problem persists';

  @override
  String get configurationExceptionPrefix => 'Config Error';

  @override
  String get configurationExceptionMessage => 'Configuration error';

  @override
  String get configurationExceptionRecovery =>
      'Please restart the app or contact support';

  @override
  String get validationExceptionPrefix => 'Validation Error';

  @override
  String validationExceptionMessage(String field) {
    return 'Validation failed for $field';
  }

  @override
  String get validationExceptionRecovery =>
      'Please check the entered information';

  @override
  String imagePickerMultipleSelectionError(String error) {
    return 'Multiple image selection not available, error: $error';
  }

  @override
  String get validationFieldDefaultName => 'Field';

  @override
  String get fileTypeProfilePhoto => 'Profile photo';

  @override
  String get fileTypeAadhaarDocument => 'Aadhaar document';

  @override
  String get performanceReportTitle => '=== PERFORMANCE REPORT ===';

  @override
  String performanceReportGenerated(String timestamp) {
    return 'Generated: $timestamp';
  }

  @override
  String performanceReportOperation(String operation) {
    return 'Operation: $operation';
  }

  @override
  String performanceReportCount(String count) {
    return '  Count: $count';
  }

  @override
  String performanceReportMin(String value) {
    return '  Min: $value';
  }

  @override
  String performanceReportMax(String value) {
    return '  Max: $value';
  }

  @override
  String performanceReportAverage(String value) {
    return '  Average: $value';
  }

  @override
  String performanceReportMedian(String value) {
    return '  Median: $value';
  }

  @override
  String get guestPgStartingLoad => 'Starting to load PGs';

  @override
  String get guestPgLoadSuccess => 'PGs loaded successfully';

  @override
  String get guestPgLoadFailure => 'Failed to load PGs';

  @override
  String get guestPgRefreshAction => 'Refresh PGs';

  @override
  String get guestPgSelectedAction => 'PG Selected';

  @override
  String get guestPgClearSelectionAction => 'Clear Selected PG';

  @override
  String get guestPgSearchQueryChangedAction => 'Search Query Changed';

  @override
  String ownerMenuEditLogTotalItems(int count) {
    return '   - Total items: $count';
  }

  @override
  String get ownerMenuEditLogUpdateSuccess => '✅ Menu updated successfully!';

  @override
  String get ownerMenuEditLogCreateSuccess => '✅ Menu created successfully!';

  @override
  String get ownerSettingsBuildNumberValue => '1';

  @override
  String get ownerSettingsAppVersionValue => '1.0.0';

  @override
  String get ownerOverviewOwnerFallback => 'Owner';
}
