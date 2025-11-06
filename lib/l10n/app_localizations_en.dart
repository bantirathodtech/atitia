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
  String get error => 'Error';

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
  String get description => 'Description';

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
  String get personalInformation => 'Personal Information';

  @override
  String get provideDetailsAsPerDocuments =>
      'Please provide your details as per your official documents';

  @override
  String get yourRegisteredPhoneNumber => 'Your registered phone number';

  @override
  String get verifiedDuringLogin => '✓ Verified during login';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourCompleteName => 'Enter your complete name';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get nameMustBeAtLeast3Characters =>
      'Name must be at least 3 characters';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get emailAddressOptional => 'Email Address (Optional)';

  @override
  String get yourEmailExample => 'your.email@example.com';

  @override
  String get aadhaarNumber => 'Aadhaar Number';

  @override
  String get enter12DigitAadhaarNumber => 'Enter 12-digit Aadhaar number';

  @override
  String get contactName => 'Contact Name';

  @override
  String get fullNameOfEmergencyContact => 'Full name of emergency contact';

  @override
  String get contactPhone => 'Contact Phone';

  @override
  String get tenDigitPhoneNumber => '10-digit phone number';

  @override
  String get contactAddressOptional => 'Contact Address (Optional)';

  @override
  String get fullAddressOfEmergencyContact =>
      'Full address of emergency contact';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get aadhaarDocument => 'Aadhaar Document';

  @override
  String get aboutApp => 'About App';

  @override
  String get aboutDeveloper => 'About Developer';

  @override
  String get switchAccount => 'Switch Account';

  @override
  String get switchToGuest => 'Switch to Guest';

  @override
  String get switchToOwner => 'Switch to Owner';

  @override
  String get pgs => 'PGs';

  @override
  String get foods => 'Foods';

  @override
  String get requests => 'Requests';

  @override
  String get complaints => 'Complaints';

  @override
  String get overview => 'Overview';

  @override
  String get food => 'Food';

  @override
  String get guests => 'Guests';

  @override
  String get browsePGAccommodations => 'Browse PG Accommodations';

  @override
  String get viewFoodMenu => 'View Food Menu';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get bookingRequests => 'Booking Requests';

  @override
  String get complaintsRequests => 'Complaints & Requests';

  @override
  String get submitNewComplaint => 'Submit New Complaint';

  @override
  String get briefDescriptionOfComplaint =>
      'Brief description of your complaint';

  @override
  String get detailedDescriptionOfComplaint =>
      'Detailed description of your complaint or request';

  @override
  String get submitComplaint => 'Submit Complaint';

  @override
  String get complaintSubmittedSuccessfully =>
      'Complaint submitted successfully';

  @override
  String get submissionFailed => 'Submission failed';

  @override
  String get errorPickingImage => 'Error picking image';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get pleaseSelectPGFirst =>
      'Please select a PG first to file a complaint';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get paymentNotFound => 'Payment Not Found';

  @override
  String get sendPayment => 'Send Payment';

  @override
  String get sendPaymentNotification => 'Send Payment Notification';

  @override
  String get uploadPaymentScreenshot => 'Upload Payment Screenshot';

  @override
  String get invalidPGSelection =>
      'Invalid PG selection. Owner information not available.';

  @override
  String get paymentSuccessfulOwnerNotified =>
      'Payment successful! Owner will be notified.';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get failedToProcessPayment => 'Failed to process payment';

  @override
  String get pleaseUploadPaymentScreenshot =>
      'Please upload payment screenshot. Transaction ID is visible in the screenshot.';

  @override
  String get failedToSendNotification => 'Failed to send notification';

  @override
  String get invalidPaymentOrOwnerInfo =>
      'Invalid payment or owner information not available.';

  @override
  String get paymentSuccessful => 'Payment successful!';

  @override
  String get upiPaymentNotificationSent =>
      'UPI payment notification sent. Owner will verify and confirm.';

  @override
  String get failedToProcessUPIPayment => 'Failed to process UPI payment';

  @override
  String get cashPaymentNotificationSent =>
      'Cash payment notification sent. Owner will confirm once they receive the payment.';

  @override
  String get failedToProcessCashPayment => 'Failed to process cash payment';

  @override
  String get failedToPickImage => 'Failed to pick image';

  @override
  String get changeScreenshot => 'Change Screenshot';

  @override
  String get backToPayments => 'Back to Payments';

  @override
  String get yesPaid => 'Yes, Paid';

  @override
  String get noPaymentsYet => 'No Payments Yet';

  @override
  String noFilterPayments(String filter) {
    return 'No $filter Payments';
  }

  @override
  String get paymentHistoryTitle => 'Payment History';

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
  String get paymentInformation => 'Payment Information';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get callOwner => 'Call Owner';

  @override
  String get sharePG => 'Share PG';

  @override
  String get requestBooking => 'Request Booking';

  @override
  String get couldNotOpenMaps => 'Could not open maps';

  @override
  String get pgInformationNotAvailable => 'PG information not available';

  @override
  String noMenuForDay(String day) {
    return 'No Menu for $day';
  }

  @override
  String get errorLoadingMenu => 'Error Loading Menu';

  @override
  String get foodDetails => 'Food Details';

  @override
  String get errorLoadingComplaints => 'Error Loading Complaints';

  @override
  String get myRoomBed => 'My Room & Bed';

  @override
  String get noActiveBooking => 'No Active Booking';

  @override
  String get myBookingRequests => 'My Booking Requests';

  @override
  String get getStartedWithBookingRequests =>
      'Get Started with Booking Requests';

  @override
  String get noPGsFound => 'No PGs Found';

  @override
  String get noPGsAvailable => 'No PGs Available';

  @override
  String get newBookingRequest => 'New Booking Request';

  @override
  String get newComplaintFiled => 'New Complaint Filed';

  @override
  String get paymentReceived => 'Payment Received';

  @override
  String get razorpay => 'Razorpay';

  @override
  String get upiPayment => 'UPI Payment';

  @override
  String get cashPayment => 'Cash Payment';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get videoTutorials => 'Watch step-by-step guides';

  @override
  String get documentation => 'Read comprehensive guides';

  @override
  String get emailSupport => 'Email Support';

  @override
  String get supportEmail => 'support@atitia.com';

  @override
  String get phoneSupport => 'Phone Support';

  @override
  String get supportPhone => '+91 1234567890';

  @override
  String get liveChat => 'Live Chat';

  @override
  String get whatsappNumber => 'WhatsApp: +91 7020797849';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get appearance => 'Appearance';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get receiveNotificationsOnDevice =>
      'Receive notifications on your device';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get receiveNotificationsViaEmail => 'Receive notifications via email';

  @override
  String get paymentReminders => 'Payment Reminders';

  @override
  String get getRemindersForPendingPayments =>
      'Get reminders for pending payments';

  @override
  String get dataPrivacy => 'Data & Privacy';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get guest => 'Guest';

  @override
  String get owner => 'Owner';

  @override
  String get noRevenueData => 'No Revenue Data';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get averagePerMonth => 'Average/Month';

  @override
  String get monthlyRevenueBreakdown => 'Monthly Revenue Breakdown';

  @override
  String get totalBookings => 'Total Bookings';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get bedChanges => 'Bed Changes';

  @override
  String get totalGuests => 'Total Guests';

  @override
  String get paidCount => 'Paid Count';

  @override
  String get pendingCount => 'Pending Count';

  @override
  String get totalComplaints => 'Total Complaints';

  @override
  String get inProgress => 'In Progress';

  @override
  String get resolved => 'Resolved';

  @override
  String get myProfile => 'My Profile';

  @override
  String get aadhaarPhoto => 'Aadhaar Photo';

  @override
  String get noBookings => 'No Bookings';

  @override
  String get noPayments => 'No Payments';

  @override
  String get noGuests => 'No Guests';

  @override
  String get ownerRepliedToComplaint => 'Owner replied to your complaint';

  @override
  String complaintStatusDisplay(String statusDisplay) {
    return 'Complaint $statusDisplay';
  }

  @override
  String get bookingApproved => 'Booking Approved';

  @override
  String get bookingRejected => 'Booking Rejected';

  @override
  String get changeStatus => 'Change Status';

  @override
  String updatedGuestsToStatus(int count, String status) {
    return 'Updated $count guests to $status';
  }

  @override
  String get confirmBulkDelete => 'Confirm Bulk Delete';

  @override
  String get guestsDeletedSuccessfully => 'Guests deleted successfully';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String photoSUploadedSuccessfully(int count) {
    return '$count photo(s) uploaded successfully';
  }

  @override
  String photoSUploadedFailed(int successCount, int failCount) {
    return '$successCount photo(s) uploaded, $failCount failed';
  }

  @override
  String get failedToSelectPhotos => 'Failed to select photos';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get housekeeping => 'Housekeeping';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get other => 'Other';

  @override
  String get start => 'Start';

  @override
  String get resume => 'Resume';

  @override
  String get details => 'Details';

  @override
  String get pleaseFillInAllFields => 'Please fill in all fields';

  @override
  String get serviceRequestSubmitted => 'Service request submitted';

  @override
  String get replySentSuccessfully => 'Reply sent successfully';

  @override
  String get serviceCompletedSuccessfully => 'Service completed successfully';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get replyToServiceRequest => 'Reply to Service Request';

  @override
  String get failedToUpdateStatus => 'Failed to update status';

  @override
  String get completeService => 'Complete Service';

  @override
  String get serviceRequest => 'Service Request';

  @override
  String get monthlyRevenue => 'Monthly Revenue';

  @override
  String get startBuildingYourPGProfile => 'Start Building Your PG Profile';

  @override
  String get defineYourPGStructure => 'Define Your PG Structure';

  @override
  String get bedNumberingGuide => 'Bed Numbering Guide';

  @override
  String get configureRentalPricing => 'Configure Rental Pricing';

  @override
  String get addPGAmenities => 'Add PG Amenities';

  @override
  String get uploadPGPhotos => 'Upload PG Photos';

  @override
  String get progress => 'Progress';

  @override
  String get saveDraft => 'Save Draft';

  @override
  String get pleaseEnterPGNameBeforePublishing =>
      'Please enter PG name before publishing';

  @override
  String get pgPublishedSuccessfully => 'PG published successfully';

  @override
  String get draftSaved => 'Draft saved';

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
  String get replyToComplaint => 'Reply to Complaint';

  @override
  String get resolveComplaint => 'Resolve Complaint';

  @override
  String get complaintResolvedSuccessfully => 'Complaint resolved successfully';

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
  String areYouSureRemoveBike(String bikeName) {
    return 'Are you sure you want to remove $bikeName?';
  }

  @override
  String get bikeRemovalRequestCreated => 'Bike removal request created';

  @override
  String get bikeMovementRequestCreated => 'Bike movement request created';

  @override
  String get view => 'View';

  @override
  String get pleaseEnterFestivalEventName => 'Please enter festival/event name';

  @override
  String get specialMenuSavedSuccessfully => 'Special menu saved successfully!';

  @override
  String get failedToSaveSpecialMenu => 'Failed to save special menu';

  @override
  String get errorSavingSpecialMenu => 'Error saving special menu';

  @override
  String get pleaseAddAtLeastOneMealItem => 'Please add at least one meal item';

  @override
  String get failedToSaveMenu => 'Failed to save menu';

  @override
  String get errorSavingMenu => 'Error saving menu';

  @override
  String get menuCleared => 'Menu cleared. Don\'t forget to save changes.';

  @override
  String get clearMenu => 'Clear Menu?';

  @override
  String get createPGWeeklyMenus => 'Create PG Weekly Menus';

  @override
  String get defaultMenusInitializedSuccessfully =>
      'Default menus initialized successfully';

  @override
  String get failedToInitializeMenus => 'Failed to initialize menus';

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
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get revenue => 'Revenue';

  @override
  String get occupancy => 'Occupancy';

  @override
  String get searchServices => 'Search Services';

  @override
  String get searchByTitleGuestRoomOrType =>
      'Search by title, guest, room, or type...';

  @override
  String get createNewServiceRequest => 'Create New Service Request';

  @override
  String get serviceDescription => 'Service Description';

  @override
  String get describeTheServiceNeeded => 'Describe the service needed...';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get type => 'Type';

  @override
  String get priority => 'Priority';

  @override
  String get requested => 'Requested';

  @override
  String get assignedTo => 'Assigned To';

  @override
  String get complete => 'Complete';

  @override
  String get reply => 'Reply';

  @override
  String get sendReply => 'Send Reply';

  @override
  String get typeYourReply => 'Type your reply...';

  @override
  String get completionNotes => 'Completion Notes';

  @override
  String get completionNotesOptional => 'Completion notes (optional)...';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get serviceTitle => 'Service Title';

  @override
  String get guestName => 'Service Title';

  @override
  String get room => 'Room';

  @override
  String get serviceType => 'Service Type';

  @override
  String get searchGuests => 'Search Guests';

  @override
  String get searchByNamePhoneRoomOrEmail =>
      'Search by name, phone, room, or email...';

  @override
  String get guestNameLabel => 'Guest Name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get checkIn => 'Check-in';

  @override
  String get duration => 'Duration';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get emergencyPhone => 'Emergency Phone';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get message => 'Message';

  @override
  String get enterYourMessage => 'Enter your message...';

  @override
  String get send => 'Send';

  @override
  String get searchComplaints => 'Search Complaints';

  @override
  String get searchByTitleGuestRoomOrDescription =>
      'Search by title, guest, room, or description...';

  @override
  String get created => 'Created';

  @override
  String get resolutionNotes => 'Resolution Notes';

  @override
  String get resolutionNotesOptional => 'Resolution notes (optional)...';

  @override
  String get markAsResolved => 'Mark as Resolved';

  @override
  String get complaintTitle => 'Complaint Title';

  @override
  String get priorityLevel => 'Priority level';

  @override
  String get searchBikes => 'Search Bikes';

  @override
  String get searchByNumberNameGuestOrModel =>
      'Search by number, name, guest, or model...';

  @override
  String get parkingSpot => 'Parking Spot';

  @override
  String get color => 'Color';

  @override
  String get bikeType => 'Type';

  @override
  String get registered => 'Registered';

  @override
  String get lastParked => 'Last Parked';

  @override
  String get newParkingSpot => 'New Parking Spot';

  @override
  String get reasonForMove => 'Reason for move';

  @override
  String get reasonForRemoval => 'Reason for removal';

  @override
  String get bikeNumber => 'Bike Number';

  @override
  String get bikeModel => 'Model';

  @override
  String get bikeColor => 'Bike Color';

  @override
  String get addMenu => 'Add Menu';

  @override
  String get saveSpecialMenu => 'Save Special Menu';

  @override
  String get note => 'Note';

  @override
  String get addItem => 'Add Item';

  @override
  String get itemName => 'Item Name';

  @override
  String get add => 'Add';

  @override
  String get items => 'Items';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get photos => 'Photos';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get menuDescription => 'Menu Description';

  @override
  String get addAnySpecialNotesAboutMenu =>
      'Add any special notes about this menu...';

  @override
  String get initialize => 'Initialize';

  @override
  String get clearAll => 'Clear All';

  @override
  String get saveSearch => 'Save Search';

  @override
  String get bookNow => 'Book Now';

  @override
  String get requestChange => 'Request Change';

  @override
  String get submitRequestLabel => 'Submit Request';

  @override
  String get editMenu => 'Edit Menu';

  @override
  String get createMenu => 'Create Menu';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get listYourFirstPG => 'List Your First PG';

  @override
  String get recordPayment => 'Record Payment';

  @override
  String get searchByTitleGuestRoomOrTypeLabel =>
      'Search by title, guest, room, or type';

  @override
  String get searchByGuestName => 'Guest name';

  @override
  String get searchByRoomNumber => 'Room number';

  @override
  String get searchByServiceType => 'Service type';

  @override
  String get searchByComplaintTitle => 'Complaint title';

  @override
  String get searchByBikeNumber => 'Bike number';

  @override
  String get searchByBikeModel => 'Bike model';

  @override
  String get searchByBikeColor => 'Bike Color';

  @override
  String get savePaymentDetails => 'Save Payment Details';

  @override
  String get bankName => 'Bank Name';

  @override
  String get bankNameHint => 'e.g., State Bank of India';

  @override
  String get accountHolderName => 'Account Holder Name';

  @override
  String get nameAsPerBankRecords => 'Name as per bank records';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get enterAccountNumber => 'Enter account number';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get ifscCodeHint => 'e.g., SBIN0001234';

  @override
  String get upiID => 'UPI ID';

  @override
  String get upiIDHint => 'yourname@paytm';

  @override
  String get paymentInstructionsOptional => 'Payment Instructions (Optional)';

  @override
  String get anySpecialInstructionsForGuests =>
      'Any special instructions for guests';

  @override
  String get paymentDetailsSavedSuccessfully =>
      'Payment details saved successfully';

  @override
  String get failedToSave => 'Failed to save';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get enterYourPGAddress => 'Enter your PG address';

  @override
  String get enterPincode => 'Enter pincode';

  @override
  String get selectState => 'Select State';

  @override
  String get enterBusinessName => 'Enter business name';

  @override
  String get enterBusinessType => 'Enter business type';

  @override
  String get enterPANNumber => 'Enter PAN number';

  @override
  String get enterGSTNumber => 'Enter GST number';

  @override
  String get fullAddressWithLandmark => 'Full address with landmark';

  @override
  String get pgNameHint => 'e.g., Green Meadows PG';

  @override
  String get phoneNumberHint => 'e.g., +91 9876543210';

  @override
  String get selectCity => 'Select City';

  @override
  String get addressHint => 'e.g., Sector 5, HSR Layout';

  @override
  String get selectPGType => 'Select PG Type';

  @override
  String get selectMealType => 'Select Meal Type';

  @override
  String get mealTimingsHint =>
      'e.g., Breakfast: 8:00 AM - 10:00 AM, Lunch: 1:00 PM - 2:00 PM, Dinner: 8:00 PM - 9:30 PM';

  @override
  String get describeFoodQuality =>
      'Describe the food quality, cuisine type, specialities, etc.';

  @override
  String get briefDescriptionOfPG => 'Brief description of your PG';

  @override
  String get rentAmountHint => 'e.g., 8000';

  @override
  String get securityDepositHint => 'e.g., 10000';

  @override
  String get maintenanceFeeHint => 'e.g., 500';

  @override
  String get visitingHoursHint => 'e.g., 6:00 AM - 11:00 PM';

  @override
  String get selectPolicy => 'Select Policy';

  @override
  String get noticePeriodHint => 'e.g., 30';

  @override
  String get rulesRegardingGuests =>
      'Rules regarding guests, visitors, overnight stays, etc.';

  @override
  String get termsAndConditions =>
      'Terms and conditions for refunds, deposits, cancellations, etc.';

  @override
  String get nearbyPlacesHint => 'e.g., Metro Station, Shopping Mall, Hospital';

  @override
  String occupiedCount(int count) {
    return 'Occupied $count';
  }

  @override
  String vacantCount(int count) {
    return 'Vacant $count';
  }

  @override
  String pendingCountLabel(int count) {
    return 'Pending $count';
  }

  @override
  String maintenanceCount(int count) {
    return 'Maint. $count';
  }

  @override
  String get publish => 'Publish';

  @override
  String get totalReceived => 'Total Received';

  @override
  String get totalPending => 'Pending';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get userMenu => 'User Menu';

  @override
  String get system => 'System';

  @override
  String get watchStepByStepGuides => 'Watch step-by-step guides';

  @override
  String get readComprehensiveGuides => 'Read comprehensive guides';

  @override
  String get festivalEventNameHint => 'e.g., Diwali, Ugadi, Special Event';

  @override
  String get anySpecialInstructionsOrDetails =>
      'Any special instructions or details...';

  @override
  String get itemNameHint => 'e.g., Special Biryani';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Please enter a valid email address';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get fileSizeExceedsMaximumLimit => 'File size exceeds maximum limit';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get checkYourConnectionAndTryAgain =>
      'Check your connection and try again';

  @override
  String get authenticationFailed => 'Authentication failed';

  @override
  String get pleaseCheckYourCredentialsAndTryAgain =>
      'Please check your credentials and try again';

  @override
  String get failedToParseData => 'Failed to parse data';

  @override
  String get pleaseTryAgainOrContactSupport =>
      'Please try again or contact support if the problem persists';

  @override
  String get configurationError => 'Configuration error';

  @override
  String get pleaseRestartTheAppOrContactSupport =>
      'Please restart the app or contact support';

  @override
  String get validationFailed => 'Validation failed';

  @override
  String get failedToUploadProfilePhoto => 'Failed to upload profile photo';

  @override
  String get failedToUploadAadhaarPhoto => 'Failed to upload Aadhaar photo';

  @override
  String get noProfileDataFound => 'No profile data found';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get areYouSureYouWantToLogout => 'Are you sure you want to logout?';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String get logoutFailed => 'Logout failed';

  @override
  String switchAccountConfirmation(String currentRole, String newRole) {
    return 'Are you sure you want to switch from $currentRole to $newRole account?\n\nYou will need to complete registration for the new role.';
  }

  @override
  String switchedToAccount(String role) {
    return 'Switched to $role account. Please complete your registration.';
  }

  @override
  String get failedToSwitchAccount => 'Failed to switch account';

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
}
