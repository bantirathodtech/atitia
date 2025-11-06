import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Atitia'**
  String get appTitle;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @roleGuest.
  ///
  /// In en, this message translates to:
  /// **'I am Guest'**
  String get roleGuest;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'I am PG Owner'**
  String get roleOwner;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get changeNumber;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @guestRegistration.
  ///
  /// In en, this message translates to:
  /// **'Guest Registration'**
  String get guestRegistration;

  /// No description provided for @ownerRegistration.
  ///
  /// In en, this message translates to:
  /// **'Owner Registration'**
  String get ownerRegistration;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectRole;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'తెలుగు'**
  String get telugu;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get noData;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation successful'**
  String get operationSuccessful;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @appInitializationIssue.
  ///
  /// In en, this message translates to:
  /// **'App Initialization Issue'**
  String get appInitializationIssue;

  /// No description provided for @troubleConnectingServices.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble connecting to our services. This might be due to network issues or maintenance.'**
  String get troubleConnectingServices;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for doesn\'t exist or has been moved.'**
  String get pageNotFoundDescription;

  /// No description provided for @loginAs.
  ///
  /// In en, this message translates to:
  /// **'Login as {role}'**
  String loginAs(String role);

  /// No description provided for @enterPhoneNumberToReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive OTP'**
  String get enterPhoneNumberToReceiveOTP;

  /// No description provided for @tenDigitMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get tenDigitMobileNumber;

  /// No description provided for @phoneAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Phone Authentication'**
  String get phoneAuthentication;

  /// No description provided for @notAvailableOnMacOS.
  ///
  /// In en, this message translates to:
  /// **'Not available on macOS. Please use Google Sign-In below.'**
  String get notAvailableOnMacOS;

  /// No description provided for @sixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get sixDigitCode;

  /// No description provided for @pleaseEnterSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code sent to your phone'**
  String get pleaseEnterSixDigitCode;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @provideDetailsAsPerDocuments.
  ///
  /// In en, this message translates to:
  /// **'Please provide your details as per your official documents'**
  String get provideDetailsAsPerDocuments;

  /// No description provided for @yourRegisteredPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Your registered phone number'**
  String get yourRegisteredPhoneNumber;

  /// No description provided for @verifiedDuringLogin.
  ///
  /// In en, this message translates to:
  /// **'✓ Verified during login'**
  String get verifiedDuringLogin;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Enter your complete name'**
  String get enterYourCompleteName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @nameMustBeAtLeast3Characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameMustBeAtLeast3Characters;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @emailAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get emailAddressOptional;

  /// No description provided for @yourEmailExample.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get yourEmailExample;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNumber;

  /// No description provided for @enter12DigitAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 12-digit Aadhaar number'**
  String get enter12DigitAadhaarNumber;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @fullNameOfEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Full name of emergency contact'**
  String get fullNameOfEmergencyContact;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// No description provided for @tenDigitPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'10-digit phone number'**
  String get tenDigitPhoneNumber;

  /// No description provided for @contactAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Contact Address (Optional)'**
  String get contactAddressOptional;

  /// No description provided for @fullAddressOfEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Full address of emergency contact'**
  String get fullAddressOfEmergencyContact;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @aadhaarDocument.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Document'**
  String get aadhaarDocument;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'About Developer'**
  String get aboutDeveloper;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccount;

  /// No description provided for @switchToGuest.
  ///
  /// In en, this message translates to:
  /// **'Switch to Guest'**
  String get switchToGuest;

  /// No description provided for @switchToOwner.
  ///
  /// In en, this message translates to:
  /// **'Switch to Owner'**
  String get switchToOwner;

  /// No description provided for @pgs.
  ///
  /// In en, this message translates to:
  /// **'PGs'**
  String get pgs;

  /// No description provided for @foods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get foods;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @browsePGAccommodations.
  ///
  /// In en, this message translates to:
  /// **'Browse PG Accommodations'**
  String get browsePGAccommodations;

  /// No description provided for @viewFoodMenu.
  ///
  /// In en, this message translates to:
  /// **'View Food Menu'**
  String get viewFoodMenu;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @bookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get bookingRequests;

  /// No description provided for @complaintsRequests.
  ///
  /// In en, this message translates to:
  /// **'Complaints & Requests'**
  String get complaintsRequests;

  /// No description provided for @submitNewComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit New Complaint'**
  String get submitNewComplaint;

  /// No description provided for @briefDescriptionOfComplaint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your complaint'**
  String get briefDescriptionOfComplaint;

  /// No description provided for @detailedDescriptionOfComplaint.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of your complaint or request'**
  String get detailedDescriptionOfComplaint;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @complaintSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted successfully'**
  String get complaintSubmittedSuccessfully;

  /// No description provided for @submissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Submission failed'**
  String get submissionFailed;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get errorPickingImage;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @pleaseSelectPGFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a PG first to file a complaint'**
  String get pleaseSelectPGFirst;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @paymentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Payment Not Found'**
  String get paymentNotFound;

  /// No description provided for @sendPayment.
  ///
  /// In en, this message translates to:
  /// **'Send Payment'**
  String get sendPayment;

  /// No description provided for @sendPaymentNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Payment Notification'**
  String get sendPaymentNotification;

  /// No description provided for @uploadPaymentScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Upload Payment Screenshot'**
  String get uploadPaymentScreenshot;

  /// No description provided for @invalidPGSelection.
  ///
  /// In en, this message translates to:
  /// **'Invalid PG selection. Owner information not available.'**
  String get invalidPGSelection;

  /// No description provided for @paymentSuccessfulOwnerNotified.
  ///
  /// In en, this message translates to:
  /// **'Payment successful! Owner will be notified.'**
  String get paymentSuccessfulOwnerNotified;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @failedToProcessPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process payment'**
  String get failedToProcessPayment;

  /// No description provided for @pleaseUploadPaymentScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Please upload payment screenshot. Transaction ID is visible in the screenshot.'**
  String get pleaseUploadPaymentScreenshot;

  /// No description provided for @failedToSendNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed to send notification'**
  String get failedToSendNotification;

  /// No description provided for @invalidPaymentOrOwnerInfo.
  ///
  /// In en, this message translates to:
  /// **'Invalid payment or owner information not available.'**
  String get invalidPaymentOrOwnerInfo;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get paymentSuccessful;

  /// No description provided for @upiPaymentNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'UPI payment notification sent. Owner will verify and confirm.'**
  String get upiPaymentNotificationSent;

  /// No description provided for @failedToProcessUPIPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process UPI payment'**
  String get failedToProcessUPIPayment;

  /// No description provided for @cashPaymentNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Cash payment notification sent. Owner will confirm once they receive the payment.'**
  String get cashPaymentNotificationSent;

  /// No description provided for @failedToProcessCashPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process cash payment'**
  String get failedToProcessCashPayment;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @changeScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Change Screenshot'**
  String get changeScreenshot;

  /// No description provided for @backToPayments.
  ///
  /// In en, this message translates to:
  /// **'Back to Payments'**
  String get backToPayments;

  /// No description provided for @yesPaid.
  ///
  /// In en, this message translates to:
  /// **'Yes, Paid'**
  String get yesPaid;

  /// No description provided for @noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No Payments Yet'**
  String get noPaymentsYet;

  /// No description provided for @noFilterPayments.
  ///
  /// In en, this message translates to:
  /// **'No {filter} Payments'**
  String noFilterPayments(String filter);

  /// No description provided for @paymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistoryTitle;

  /// No description provided for @pgNotFound.
  ///
  /// In en, this message translates to:
  /// **'PG Not Found'**
  String get pgNotFound;

  /// No description provided for @pricingAvailability.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Availability'**
  String get pricingAvailability;

  /// No description provided for @locationVicinity.
  ///
  /// In en, this message translates to:
  /// **'Location & Vicinity'**
  String get locationVicinity;

  /// No description provided for @facilitiesAmenities.
  ///
  /// In en, this message translates to:
  /// **'Facilities & Amenities'**
  String get facilitiesAmenities;

  /// No description provided for @foodMealInformation.
  ///
  /// In en, this message translates to:
  /// **'Food & Meal Information'**
  String get foodMealInformation;

  /// No description provided for @rulesPolicies.
  ///
  /// In en, this message translates to:
  /// **'Rules & Policies'**
  String get rulesPolicies;

  /// No description provided for @contactOwnerInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact & Owner Information'**
  String get contactOwnerInformation;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInformation;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @callOwner.
  ///
  /// In en, this message translates to:
  /// **'Call Owner'**
  String get callOwner;

  /// No description provided for @sharePG.
  ///
  /// In en, this message translates to:
  /// **'Share PG'**
  String get sharePG;

  /// No description provided for @requestBooking.
  ///
  /// In en, this message translates to:
  /// **'Request Booking'**
  String get requestBooking;

  /// No description provided for @couldNotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open maps'**
  String get couldNotOpenMaps;

  /// No description provided for @pgInformationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'PG information not available'**
  String get pgInformationNotAvailable;

  /// No description provided for @noMenuForDay.
  ///
  /// In en, this message translates to:
  /// **'No Menu for {day}'**
  String noMenuForDay(String day);

  /// No description provided for @errorLoadingMenu.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Menu'**
  String get errorLoadingMenu;

  /// No description provided for @foodDetails.
  ///
  /// In en, this message translates to:
  /// **'Food Details'**
  String get foodDetails;

  /// No description provided for @errorLoadingComplaints.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Complaints'**
  String get errorLoadingComplaints;

  /// No description provided for @myRoomBed.
  ///
  /// In en, this message translates to:
  /// **'My Room & Bed'**
  String get myRoomBed;

  /// No description provided for @noActiveBooking.
  ///
  /// In en, this message translates to:
  /// **'No Active Booking'**
  String get noActiveBooking;

  /// No description provided for @myBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'My Booking Requests'**
  String get myBookingRequests;

  /// No description provided for @getStartedWithBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Get Started with Booking Requests'**
  String get getStartedWithBookingRequests;

  /// No description provided for @noPGsFound.
  ///
  /// In en, this message translates to:
  /// **'No PGs Found'**
  String get noPGsFound;

  /// No description provided for @noPGsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No PGs Available'**
  String get noPGsAvailable;

  /// No description provided for @newBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'New Booking Request'**
  String get newBookingRequest;

  /// No description provided for @newComplaintFiled.
  ///
  /// In en, this message translates to:
  /// **'New Complaint Filed'**
  String get newComplaintFiled;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @razorpay.
  ///
  /// In en, this message translates to:
  /// **'Razorpay'**
  String get razorpay;

  /// No description provided for @upiPayment.
  ///
  /// In en, this message translates to:
  /// **'UPI Payment'**
  String get upiPayment;

  /// No description provided for @cashPayment.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cashPayment;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
  String get videoTutorials;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Read comprehensive guides'**
  String get documentation;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'support@atitia.com'**
  String get supportEmail;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phoneSupport;

  /// No description provided for @supportPhone.
  ///
  /// In en, this message translates to:
  /// **'+91 1234567890'**
  String get supportPhone;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp: +91 7020797849'**
  String get whatsappNumber;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @receiveNotificationsOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get receiveNotificationsOnDevice;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @receiveNotificationsViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get receiveNotificationsViaEmail;

  /// No description provided for @paymentReminders.
  ///
  /// In en, this message translates to:
  /// **'Payment Reminders'**
  String get paymentReminders;

  /// No description provided for @getRemindersForPendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Get reminders for pending payments'**
  String get getRemindersForPendingPayments;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataPrivacy;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @noRevenueData.
  ///
  /// In en, this message translates to:
  /// **'No Revenue Data'**
  String get noRevenueData;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @averagePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Average/Month'**
  String get averagePerMonth;

  /// No description provided for @monthlyRevenueBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue Breakdown'**
  String get monthlyRevenueBreakdown;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @bedChanges.
  ///
  /// In en, this message translates to:
  /// **'Bed Changes'**
  String get bedChanges;

  /// No description provided for @totalGuests.
  ///
  /// In en, this message translates to:
  /// **'Total Guests'**
  String get totalGuests;

  /// No description provided for @paidCount.
  ///
  /// In en, this message translates to:
  /// **'Paid Count'**
  String get paidCount;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending Count'**
  String get pendingCount;

  /// No description provided for @totalComplaints.
  ///
  /// In en, this message translates to:
  /// **'Total Complaints'**
  String get totalComplaints;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @aadhaarPhoto.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Photo'**
  String get aadhaarPhoto;

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No Bookings'**
  String get noBookings;

  /// No description provided for @noPayments.
  ///
  /// In en, this message translates to:
  /// **'No Payments'**
  String get noPayments;

  /// No description provided for @noGuests.
  ///
  /// In en, this message translates to:
  /// **'No Guests'**
  String get noGuests;

  /// No description provided for @ownerRepliedToComplaint.
  ///
  /// In en, this message translates to:
  /// **'Owner replied to your complaint'**
  String get ownerRepliedToComplaint;

  /// No description provided for @complaintStatusDisplay.
  ///
  /// In en, this message translates to:
  /// **'Complaint {statusDisplay}'**
  String complaintStatusDisplay(String statusDisplay);

  /// No description provided for @bookingApproved.
  ///
  /// In en, this message translates to:
  /// **'Booking Approved'**
  String get bookingApproved;

  /// No description provided for @bookingRejected.
  ///
  /// In en, this message translates to:
  /// **'Booking Rejected'**
  String get bookingRejected;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changeStatus;

  /// No description provided for @updatedGuestsToStatus.
  ///
  /// In en, this message translates to:
  /// **'Updated {count} guests to {status}'**
  String updatedGuestsToStatus(int count, String status);

  /// No description provided for @confirmBulkDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Bulk Delete'**
  String get confirmBulkDelete;

  /// No description provided for @guestsDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Guests deleted successfully'**
  String get guestsDeletedSuccessfully;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @photoSUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} photo(s) uploaded successfully'**
  String photoSUploadedSuccessfully(int count);

  /// No description provided for @photoSUploadedFailed.
  ///
  /// In en, this message translates to:
  /// **'{successCount} photo(s) uploaded, {failCount} failed'**
  String photoSUploadedFailed(int successCount, int failCount);

  /// No description provided for @failedToSelectPhotos.
  ///
  /// In en, this message translates to:
  /// **'Failed to select photos'**
  String get failedToSelectPhotos;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @housekeeping.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping'**
  String get housekeeping;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @pleaseFillInAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillInAllFields;

  /// No description provided for @serviceRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Service request submitted'**
  String get serviceRequestSubmitted;

  /// No description provided for @replySentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully'**
  String get replySentSuccessfully;

  /// No description provided for @serviceCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service completed successfully'**
  String get serviceCompletedSuccessfully;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @replyToServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Reply to Service Request'**
  String get replyToServiceRequest;

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status'**
  String get failedToUpdateStatus;

  /// No description provided for @completeService.
  ///
  /// In en, this message translates to:
  /// **'Complete Service'**
  String get completeService;

  /// No description provided for @serviceRequest.
  ///
  /// In en, this message translates to:
  /// **'Service Request'**
  String get serviceRequest;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @startBuildingYourPGProfile.
  ///
  /// In en, this message translates to:
  /// **'Start Building Your PG Profile'**
  String get startBuildingYourPGProfile;

  /// No description provided for @defineYourPGStructure.
  ///
  /// In en, this message translates to:
  /// **'Define Your PG Structure'**
  String get defineYourPGStructure;

  /// No description provided for @bedNumberingGuide.
  ///
  /// In en, this message translates to:
  /// **'Bed Numbering Guide'**
  String get bedNumberingGuide;

  /// No description provided for @configureRentalPricing.
  ///
  /// In en, this message translates to:
  /// **'Configure Rental Pricing'**
  String get configureRentalPricing;

  /// No description provided for @addPGAmenities.
  ///
  /// In en, this message translates to:
  /// **'Add PG Amenities'**
  String get addPGAmenities;

  /// No description provided for @uploadPGPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload PG Photos'**
  String get uploadPGPhotos;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @pleaseEnterPGNameBeforePublishing.
  ///
  /// In en, this message translates to:
  /// **'Please enter PG name before publishing'**
  String get pleaseEnterPGNameBeforePublishing;

  /// No description provided for @pgPublishedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PG published successfully'**
  String get pgPublishedSuccessfully;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @editGuest.
  ///
  /// In en, this message translates to:
  /// **'Edit Guest'**
  String get editGuest;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @callGuest.
  ///
  /// In en, this message translates to:
  /// **'Call Guest'**
  String get callGuest;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @guestUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Guest updated successfully'**
  String get guestUpdatedSuccessfully;

  /// No description provided for @replyToComplaint.
  ///
  /// In en, this message translates to:
  /// **'Reply to Complaint'**
  String get replyToComplaint;

  /// No description provided for @resolveComplaint.
  ///
  /// In en, this message translates to:
  /// **'Resolve Complaint'**
  String get resolveComplaint;

  /// No description provided for @complaintResolvedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint resolved successfully'**
  String get complaintResolvedSuccessfully;

  /// No description provided for @editBike.
  ///
  /// In en, this message translates to:
  /// **'Edit Bike'**
  String get editBike;

  /// No description provided for @bikeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Bike updated successfully'**
  String get bikeUpdatedSuccessfully;

  /// No description provided for @moveBike.
  ///
  /// In en, this message translates to:
  /// **'Move Bike'**
  String get moveBike;

  /// No description provided for @currentSpot.
  ///
  /// In en, this message translates to:
  /// **'Current spot: {spot}'**
  String currentSpot(String spot);

  /// No description provided for @removeBike.
  ///
  /// In en, this message translates to:
  /// **'Remove Bike'**
  String get removeBike;

  /// No description provided for @areYouSureRemoveBike.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {bikeName}?'**
  String areYouSureRemoveBike(String bikeName);

  /// No description provided for @bikeRemovalRequestCreated.
  ///
  /// In en, this message translates to:
  /// **'Bike removal request created'**
  String get bikeRemovalRequestCreated;

  /// No description provided for @bikeMovementRequestCreated.
  ///
  /// In en, this message translates to:
  /// **'Bike movement request created'**
  String get bikeMovementRequestCreated;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @pleaseEnterFestivalEventName.
  ///
  /// In en, this message translates to:
  /// **'Please enter festival/event name'**
  String get pleaseEnterFestivalEventName;

  /// No description provided for @specialMenuSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Special menu saved successfully!'**
  String get specialMenuSavedSuccessfully;

  /// No description provided for @failedToSaveSpecialMenu.
  ///
  /// In en, this message translates to:
  /// **'Failed to save special menu'**
  String get failedToSaveSpecialMenu;

  /// No description provided for @errorSavingSpecialMenu.
  ///
  /// In en, this message translates to:
  /// **'Error saving special menu'**
  String get errorSavingSpecialMenu;

  /// No description provided for @pleaseAddAtLeastOneMealItem.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one meal item'**
  String get pleaseAddAtLeastOneMealItem;

  /// No description provided for @failedToSaveMenu.
  ///
  /// In en, this message translates to:
  /// **'Failed to save menu'**
  String get failedToSaveMenu;

  /// No description provided for @errorSavingMenu.
  ///
  /// In en, this message translates to:
  /// **'Error saving menu'**
  String get errorSavingMenu;

  /// No description provided for @menuCleared.
  ///
  /// In en, this message translates to:
  /// **'Menu cleared. Don\'t forget to save changes.'**
  String get menuCleared;

  /// No description provided for @clearMenu.
  ///
  /// In en, this message translates to:
  /// **'Clear Menu?'**
  String get clearMenu;

  /// No description provided for @createPGWeeklyMenus.
  ///
  /// In en, this message translates to:
  /// **'Create PG Weekly Menus'**
  String get createPGWeeklyMenus;

  /// No description provided for @defaultMenusInitializedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Default menus initialized successfully'**
  String get defaultMenusInitializedSuccessfully;

  /// No description provided for @failedToInitializeMenus.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize menus'**
  String get failedToInitializeMenus;

  /// No description provided for @addFestivalMenu.
  ///
  /// In en, this message translates to:
  /// **'Add Festival Menu'**
  String get addFestivalMenu;

  /// No description provided for @createSpecialMenuForFestivals.
  ///
  /// In en, this message translates to:
  /// **'Create special menu for festivals'**
  String get createSpecialMenuForFestivals;

  /// No description provided for @addEventMenu.
  ///
  /// In en, this message translates to:
  /// **'Add Event Menu'**
  String get addEventMenu;

  /// No description provided for @createSpecialMenuForEvents.
  ///
  /// In en, this message translates to:
  /// **'Create special menu for events'**
  String get createSpecialMenuForEvents;

  /// No description provided for @viewAllSpecialMenus.
  ///
  /// In en, this message translates to:
  /// **'View All Special Menus'**
  String get viewAllSpecialMenus;

  /// No description provided for @manageExistingSpecialMenus.
  ///
  /// In en, this message translates to:
  /// **'Manage existing special menus'**
  String get manageExistingSpecialMenus;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @occupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// No description provided for @searchServices.
  ///
  /// In en, this message translates to:
  /// **'Search Services'**
  String get searchServices;

  /// No description provided for @searchByTitleGuestRoomOrType.
  ///
  /// In en, this message translates to:
  /// **'Search by title, guest, room, or type...'**
  String get searchByTitleGuestRoomOrType;

  /// No description provided for @createNewServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Create New Service Request'**
  String get createNewServiceRequest;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get serviceDescription;

  /// No description provided for @describeTheServiceNeeded.
  ///
  /// In en, this message translates to:
  /// **'Describe the service needed...'**
  String get describeTheServiceNeeded;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned To'**
  String get assignedTo;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get sendReply;

  /// No description provided for @typeYourReply.
  ///
  /// In en, this message translates to:
  /// **'Type your reply...'**
  String get typeYourReply;

  /// No description provided for @completionNotes.
  ///
  /// In en, this message translates to:
  /// **'Completion Notes'**
  String get completionNotes;

  /// No description provided for @completionNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Completion notes (optional)...'**
  String get completionNotesOptional;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get serviceTitle;

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get guestName;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @searchGuests.
  ///
  /// In en, this message translates to:
  /// **'Search Guests'**
  String get searchGuests;

  /// No description provided for @searchByNamePhoneRoomOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, room, or email...'**
  String get searchByNamePhoneRoomOrEmail;

  /// No description provided for @guestNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest Name'**
  String get guestNameLabel;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get emergencyPhone;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @enterYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your message...'**
  String get enterYourMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @searchComplaints.
  ///
  /// In en, this message translates to:
  /// **'Search Complaints'**
  String get searchComplaints;

  /// No description provided for @searchByTitleGuestRoomOrDescription.
  ///
  /// In en, this message translates to:
  /// **'Search by title, guest, room, or description...'**
  String get searchByTitleGuestRoomOrDescription;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @resolutionNotes.
  ///
  /// In en, this message translates to:
  /// **'Resolution Notes'**
  String get resolutionNotes;

  /// No description provided for @resolutionNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Resolution notes (optional)...'**
  String get resolutionNotesOptional;

  /// No description provided for @markAsResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark as Resolved'**
  String get markAsResolved;

  /// No description provided for @complaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint Title'**
  String get complaintTitle;

  /// No description provided for @priorityLevel.
  ///
  /// In en, this message translates to:
  /// **'Priority level'**
  String get priorityLevel;

  /// No description provided for @searchBikes.
  ///
  /// In en, this message translates to:
  /// **'Search Bikes'**
  String get searchBikes;

  /// No description provided for @searchByNumberNameGuestOrModel.
  ///
  /// In en, this message translates to:
  /// **'Search by number, name, guest, or model...'**
  String get searchByNumberNameGuestOrModel;

  /// No description provided for @parkingSpot.
  ///
  /// In en, this message translates to:
  /// **'Parking Spot'**
  String get parkingSpot;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @bikeType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bikeType;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @lastParked.
  ///
  /// In en, this message translates to:
  /// **'Last Parked'**
  String get lastParked;

  /// No description provided for @newParkingSpot.
  ///
  /// In en, this message translates to:
  /// **'New Parking Spot'**
  String get newParkingSpot;

  /// No description provided for @reasonForMove.
  ///
  /// In en, this message translates to:
  /// **'Reason for move'**
  String get reasonForMove;

  /// No description provided for @reasonForRemoval.
  ///
  /// In en, this message translates to:
  /// **'Reason for removal'**
  String get reasonForRemoval;

  /// No description provided for @bikeNumber.
  ///
  /// In en, this message translates to:
  /// **'Bike Number'**
  String get bikeNumber;

  /// No description provided for @bikeModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get bikeModel;

  /// No description provided for @bikeColor.
  ///
  /// In en, this message translates to:
  /// **'Bike Color'**
  String get bikeColor;

  /// No description provided for @addMenu.
  ///
  /// In en, this message translates to:
  /// **'Add Menu'**
  String get addMenu;

  /// No description provided for @saveSpecialMenu.
  ///
  /// In en, this message translates to:
  /// **'Save Special Menu'**
  String get saveSpecialMenu;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @menuDescription.
  ///
  /// In en, this message translates to:
  /// **'Menu Description'**
  String get menuDescription;

  /// No description provided for @addAnySpecialNotesAboutMenu.
  ///
  /// In en, this message translates to:
  /// **'Add any special notes about this menu...'**
  String get addAnySpecialNotesAboutMenu;

  /// No description provided for @initialize.
  ///
  /// In en, this message translates to:
  /// **'Initialize'**
  String get initialize;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @saveSearch.
  ///
  /// In en, this message translates to:
  /// **'Save Search'**
  String get saveSearch;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @requestChange.
  ///
  /// In en, this message translates to:
  /// **'Request Change'**
  String get requestChange;

  /// No description provided for @submitRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequestLabel;

  /// No description provided for @editMenu.
  ///
  /// In en, this message translates to:
  /// **'Edit Menu'**
  String get editMenu;

  /// No description provided for @createMenu.
  ///
  /// In en, this message translates to:
  /// **'Create Menu'**
  String get createMenu;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @listYourFirstPG.
  ///
  /// In en, this message translates to:
  /// **'List Your First PG'**
  String get listYourFirstPG;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @searchByTitleGuestRoomOrTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Search by title, guest, room, or type'**
  String get searchByTitleGuestRoomOrTypeLabel;

  /// No description provided for @searchByGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest name'**
  String get searchByGuestName;

  /// No description provided for @searchByRoomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room number'**
  String get searchByRoomNumber;

  /// No description provided for @searchByServiceType.
  ///
  /// In en, this message translates to:
  /// **'Service type'**
  String get searchByServiceType;

  /// No description provided for @searchByComplaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint title'**
  String get searchByComplaintTitle;

  /// No description provided for @searchByBikeNumber.
  ///
  /// In en, this message translates to:
  /// **'Bike number'**
  String get searchByBikeNumber;

  /// No description provided for @searchByBikeModel.
  ///
  /// In en, this message translates to:
  /// **'Bike model'**
  String get searchByBikeModel;

  /// No description provided for @searchByBikeColor.
  ///
  /// In en, this message translates to:
  /// **'Bike Color'**
  String get searchByBikeColor;

  /// No description provided for @savePaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Payment Details'**
  String get savePaymentDetails;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @bankNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., State Bank of India'**
  String get bankNameHint;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @nameAsPerBankRecords.
  ///
  /// In en, this message translates to:
  /// **'Name as per bank records'**
  String get nameAsPerBankRecords;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @enterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter account number'**
  String get enterAccountNumber;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @ifscCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., SBIN0001234'**
  String get ifscCodeHint;

  /// No description provided for @upiID.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiID;

  /// No description provided for @upiIDHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@paytm'**
  String get upiIDHint;

  /// No description provided for @paymentInstructionsOptional.
  ///
  /// In en, this message translates to:
  /// **'Payment Instructions (Optional)'**
  String get paymentInstructionsOptional;

  /// No description provided for @anySpecialInstructionsForGuests.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions for guests'**
  String get anySpecialInstructionsForGuests;

  /// No description provided for @paymentDetailsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment details saved successfully'**
  String get paymentDetailsSavedSuccessfully;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save'**
  String get failedToSave;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @enterYourPGAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your PG address'**
  String get enterYourPGAddress;

  /// No description provided for @enterPincode.
  ///
  /// In en, this message translates to:
  /// **'Enter pincode'**
  String get enterPincode;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter business name'**
  String get enterBusinessName;

  /// No description provided for @enterBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Enter business type'**
  String get enterBusinessType;

  /// No description provided for @enterPANNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter PAN number'**
  String get enterPANNumber;

  /// No description provided for @enterGSTNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter GST number'**
  String get enterGSTNumber;

  /// No description provided for @fullAddressWithLandmark.
  ///
  /// In en, this message translates to:
  /// **'Full address with landmark'**
  String get fullAddressWithLandmark;

  /// No description provided for @pgNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Green Meadows PG'**
  String get pgNameHint;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., +91 9876543210'**
  String get phoneNumberHint;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Sector 5, HSR Layout'**
  String get addressHint;

  /// No description provided for @selectPGType.
  ///
  /// In en, this message translates to:
  /// **'Select PG Type'**
  String get selectPGType;

  /// No description provided for @selectMealType.
  ///
  /// In en, this message translates to:
  /// **'Select Meal Type'**
  String get selectMealType;

  /// No description provided for @mealTimingsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Breakfast: 8:00 AM - 10:00 AM, Lunch: 1:00 PM - 2:00 PM, Dinner: 8:00 PM - 9:30 PM'**
  String get mealTimingsHint;

  /// No description provided for @describeFoodQuality.
  ///
  /// In en, this message translates to:
  /// **'Describe the food quality, cuisine type, specialities, etc.'**
  String get describeFoodQuality;

  /// No description provided for @briefDescriptionOfPG.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your PG'**
  String get briefDescriptionOfPG;

  /// No description provided for @rentAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 8000'**
  String get rentAmountHint;

  /// No description provided for @securityDepositHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 10000'**
  String get securityDepositHint;

  /// No description provided for @maintenanceFeeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 500'**
  String get maintenanceFeeHint;

  /// No description provided for @visitingHoursHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 6:00 AM - 11:00 PM'**
  String get visitingHoursHint;

  /// No description provided for @selectPolicy.
  ///
  /// In en, this message translates to:
  /// **'Select Policy'**
  String get selectPolicy;

  /// No description provided for @noticePeriodHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 30'**
  String get noticePeriodHint;

  /// No description provided for @rulesRegardingGuests.
  ///
  /// In en, this message translates to:
  /// **'Rules regarding guests, visitors, overnight stays, etc.'**
  String get rulesRegardingGuests;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions for refunds, deposits, cancellations, etc.'**
  String get termsAndConditions;

  /// No description provided for @nearbyPlacesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Metro Station, Shopping Mall, Hospital'**
  String get nearbyPlacesHint;

  /// No description provided for @occupiedCount.
  ///
  /// In en, this message translates to:
  /// **'Occupied {count}'**
  String occupiedCount(int count);

  /// No description provided for @vacantCount.
  ///
  /// In en, this message translates to:
  /// **'Vacant {count}'**
  String vacantCount(int count);

  /// No description provided for @pendingCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending {count}'**
  String pendingCountLabel(int count);

  /// No description provided for @maintenanceCount.
  ///
  /// In en, this message translates to:
  /// **'Maint. {count}'**
  String maintenanceCount(int count);

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get totalReceived;

  /// No description provided for @totalPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get totalPending;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @userMenu.
  ///
  /// In en, this message translates to:
  /// **'User Menu'**
  String get userMenu;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @watchStepByStepGuides.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
  String get watchStepByStepGuides;

  /// No description provided for @readComprehensiveGuides.
  ///
  /// In en, this message translates to:
  /// **'Read comprehensive guides'**
  String get readComprehensiveGuides;

  /// No description provided for @festivalEventNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Diwali, Ugadi, Special Event'**
  String get festivalEventNameHint;

  /// No description provided for @anySpecialInstructionsOrDetails.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions or details...'**
  String get anySpecialInstructionsOrDetails;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Special Biryani'**
  String get itemNameHint;

  /// No description provided for @pleaseEnterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmailAddress;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @fileSizeExceedsMaximumLimit.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds maximum limit'**
  String get fileSizeExceedsMaximumLimit;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @checkYourConnectionAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get checkYourConnectionAndTryAgain;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// No description provided for @pleaseCheckYourCredentialsAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please check your credentials and try again'**
  String get pleaseCheckYourCredentialsAndTryAgain;

  /// No description provided for @failedToParseData.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse data'**
  String get failedToParseData;

  /// No description provided for @pleaseTryAgainOrContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Please try again or contact support if the problem persists'**
  String get pleaseTryAgainOrContactSupport;

  /// No description provided for @configurationError.
  ///
  /// In en, this message translates to:
  /// **'Configuration error'**
  String get configurationError;

  /// No description provided for @pleaseRestartTheAppOrContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app or contact support'**
  String get pleaseRestartTheAppOrContactSupport;

  /// No description provided for @validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed'**
  String get validationFailed;

  /// No description provided for @failedToUploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload profile photo'**
  String get failedToUploadProfilePhoto;

  /// No description provided for @failedToUploadAadhaarPhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload Aadhaar photo'**
  String get failedToUploadAadhaarPhoto;

  /// No description provided for @noProfileDataFound.
  ///
  /// In en, this message translates to:
  /// **'No profile data found'**
  String get noProfileDataFound;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get logoutFailed;

  /// No description provided for @switchAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch from {currentRole} to {newRole} account?\n\nYou will need to complete registration for the new role.'**
  String switchAccountConfirmation(String currentRole, String newRole);

  /// No description provided for @switchedToAccount.
  ///
  /// In en, this message translates to:
  /// **'Switched to {role} account. Please complete your registration.'**
  String switchedToAccount(String role);

  /// No description provided for @failedToSwitchAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to switch account'**
  String get failedToSwitchAccount;

  /// No description provided for @switchButton.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchButton;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @verifiedOwner.
  ///
  /// In en, this message translates to:
  /// **'Verified Owner'**
  String get verifiedOwner;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get pendingVerification;

  /// No description provided for @pgManagementSystem.
  ///
  /// In en, this message translates to:
  /// **'PG Management System'**
  String get pgManagementSystem;

  /// No description provided for @madeWithLoveByAtitiaTeam.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by Atitia Team'**
  String get madeWithLoveByAtitiaTeam;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @poweredByCharyatani.
  ///
  /// In en, this message translates to:
  /// **'Powered by Charyatani'**
  String get poweredByCharyatani;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
