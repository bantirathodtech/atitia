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
  /// **'Error: {error}'**
  String error(String error);

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
  /// **'Description:'**
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

  /// No description provided for @logApiResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'RESPONSE'**
  String get logApiResponseLabel;

  /// No description provided for @logAuthEventMessage.
  ///
  /// In en, this message translates to:
  /// **'Auth: {event}'**
  String logAuthEventMessage(String event);

  /// No description provided for @logRoleActionMessage.
  ///
  /// In en, this message translates to:
  /// **'{role} action: {action}'**
  String logRoleActionMessage(String role, String action);

  /// No description provided for @logPgActionMessage.
  ///
  /// In en, this message translates to:
  /// **'PG {action}'**
  String logPgActionMessage(String action);

  /// No description provided for @logPaymentEventMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment: {event}'**
  String logPaymentEventMessage(String event);

  /// No description provided for @logFoodActionMessage.
  ///
  /// In en, this message translates to:
  /// **'Food {action}'**
  String logFoodActionMessage(String action);

  /// No description provided for @logComplaintEventMessage.
  ///
  /// In en, this message translates to:
  /// **'Complaint: {event}'**
  String logComplaintEventMessage(String event);

  /// No description provided for @logGuestActionMessage.
  ///
  /// In en, this message translates to:
  /// **'Guest {action}'**
  String logGuestActionMessage(String action);

  /// No description provided for @logOwnerActionMessage.
  ///
  /// In en, this message translates to:
  /// **'Owner {action}'**
  String logOwnerActionMessage(String action);

  /// No description provided for @logMethodEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'Entering {methodName}'**
  String logMethodEntryMessage(String methodName);

  /// No description provided for @logMethodExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Exiting {methodName}'**
  String logMethodExitMessage(String methodName);

  /// No description provided for @logPerformanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Performance: {operation} took {durationMs}ms'**
  String logPerformanceMessage(String operation, int durationMs);

  /// No description provided for @logBusinessEventMessage.
  ///
  /// In en, this message translates to:
  /// **'Business event: {event}'**
  String logBusinessEventMessage(String event);

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

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccount;

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

  /// No description provided for @chooseHowYouWantToUseTheApp.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to use the app'**
  String get chooseHowYouWantToUseTheApp;

  /// No description provided for @findAndBookPgAccommodations.
  ///
  /// In en, this message translates to:
  /// **'Find and book PG accommodations'**
  String get findAndBookPgAccommodations;

  /// No description provided for @manageYourPgPropertiesAndGuests.
  ///
  /// In en, this message translates to:
  /// **'Manage your PG properties and guests'**
  String get manageYourPgPropertiesAndGuests;

  /// No description provided for @requestTimedOutPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get requestTimedOutPleaseTryAgain;

  /// No description provided for @googleSignInOnWebRequiresButton.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In on web requires the sign-in button. Please use the Google Sign-In button above.'**
  String get googleSignInOnWebRequiresButton;

  /// No description provided for @googleSignInTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In timed out. Please try again.'**
  String get googleSignInTimedOut;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed: {error}'**
  String googleSignInFailed(String error);

  /// No description provided for @briefDescriptionOfYourComplaint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your complaint'**
  String get briefDescriptionOfYourComplaint;

  /// No description provided for @detailedDescriptionOfYourComplaint.
  ///
  /// In en, this message translates to:
  /// **'Detailed description of your complaint or request'**
  String get detailedDescriptionOfYourComplaint;

  /// No description provided for @subjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get subjectRequired;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @imageAttachment.
  ///
  /// In en, this message translates to:
  /// **'Image Attachment'**
  String get imageAttachment;

  /// No description provided for @attachImage.
  ///
  /// In en, this message translates to:
  /// **'Attach Image'**
  String get attachImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @requestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get requestTimedOut;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @phoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// No description provided for @pleaseEnterValid10DigitPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get pleaseEnterValid10DigitPhoneNumber;

  /// No description provided for @otpIsRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get otpIsRequired;

  /// No description provided for @otpMustBe6Digits.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get otpMustBe6Digits;

  /// No description provided for @otpMustContainOnlyDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP must contain only digits'**
  String get otpMustContainOnlyDigits;

  /// No description provided for @authenticationFailedPleaseSelectCorrectRole.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please select the correct role.'**
  String get authenticationFailedPleaseSelectCorrectRole;

  /// No description provided for @userDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found'**
  String get userDataNotFound;

  /// No description provided for @invalidUserRolePleaseSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Invalid user role. Please select a role.'**
  String get invalidUserRolePleaseSelectRole;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed: {error}'**
  String verificationFailed(String error);

  /// No description provided for @googleSignInFailedError.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: {error}'**
  String googleSignInFailedError(String error);

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(String error);

  /// No description provided for @otpSentSuccessfullyPleaseCheckYourPhone.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully! Please check your phone.'**
  String get otpSentSuccessfullyPleaseCheckYourPhone;

  /// No description provided for @failedToSendOtpPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Please try again.'**
  String get failedToSendOtpPleaseTryAgain;

  /// No description provided for @tooManyRequestsPleaseWaitFewMinutes.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a few minutes before trying again.'**
  String get tooManyRequestsPleaseWaitFewMinutes;

  /// No description provided for @smsServiceTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'SMS service temporarily unavailable. Please try again later.'**
  String get smsServiceTemporarilyUnavailable;

  /// No description provided for @securityVerificationFailedPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Security verification failed. Please try again.'**
  String get securityVerificationFailedPleaseTryAgain;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @attachPhotosOptional.
  ///
  /// In en, this message translates to:
  /// **'Attach Photos (Optional)'**
  String get attachPhotosOptional;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

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

  /// No description provided for @submitNewComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit New Complaint'**
  String get submitNewComplaint;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

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

  /// No description provided for @fullNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequired;

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

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @aadhaarNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number is required'**
  String get aadhaarNumberIsRequired;

  /// No description provided for @aadhaarMustBe12Digits.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar must be 12 digits'**
  String get aadhaarMustBe12Digits;

  /// No description provided for @aadhaarMustContainOnlyDigits.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar must contain only digits'**
  String get aadhaarMustContainOnlyDigits;

  /// No description provided for @aadhaarDocumentUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar document uploaded successfully!'**
  String get aadhaarDocumentUploadedSuccessfully;

  /// No description provided for @contactNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact name is required'**
  String get contactNameIsRequired;

  /// No description provided for @contactPhoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact phone is required'**
  String get contactPhoneIsRequired;

  /// No description provided for @pleaseSelectRelationship.
  ///
  /// In en, this message translates to:
  /// **'Please select relationship'**
  String get pleaseSelectRelationship;

  /// No description provided for @contactAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Contact Address (Optional)'**
  String get contactAddressOptional;

  /// No description provided for @allRequiredFieldsCompletedReadyToSubmit.
  ///
  /// In en, this message translates to:
  /// **'All required fields completed! Ready to submit.'**
  String get allRequiredFieldsCompletedReadyToSubmit;

  /// No description provided for @pleaseProvideYourDetailsAsPerOfficialDocuments.
  ///
  /// In en, this message translates to:
  /// **'Please provide your details as per your official documents'**
  String get pleaseProvideYourDetailsAsPerOfficialDocuments;

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

  /// No description provided for @yourDocumentsAreSecurelyStored.
  ///
  /// In en, this message translates to:
  /// **'Your documents are securely stored and used only for verification purposes'**
  String get yourDocumentsAreSecurelyStored;

  /// No description provided for @provideDetailsOfSomeoneWeCanContact.
  ///
  /// In en, this message translates to:
  /// **'Provide details of someone we can contact in case of emergency'**
  String get provideDetailsOfSomeoneWeCanContact;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorUpdatingProfile;

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

  /// No description provided for @browsePgAccommodations.
  ///
  /// In en, this message translates to:
  /// **'Browse PG Accommodations'**
  String get browsePgAccommodations;

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

  /// No description provided for @complaintsAndRequests.
  ///
  /// In en, this message translates to:
  /// **'Complaints & Requests'**
  String get complaintsAndRequests;

  /// No description provided for @findYourPg.
  ///
  /// In en, this message translates to:
  /// **'Find Your PG'**
  String get findYourPg;

  /// No description provided for @searchAndFilters.
  ///
  /// In en, this message translates to:
  /// **'Search & Filters'**
  String get searchAndFilters;

  /// No description provided for @hideFilters.
  ///
  /// In en, this message translates to:
  /// **'Hide Filters'**
  String get hideFilters;

  /// No description provided for @showFilters.
  ///
  /// In en, this message translates to:
  /// **'Show Filters'**
  String get showFilters;

  /// No description provided for @pgsAvailable.
  ///
  /// In en, this message translates to:
  /// **'PGs Available'**
  String get pgsAvailable;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @searchByNameCityArea.
  ///
  /// In en, this message translates to:
  /// **'Search by name, city, area...'**
  String get searchByNameCityArea;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @activeFilters.
  ///
  /// In en, this message translates to:
  /// **'Active Filters'**
  String get activeFilters;

  /// No description provided for @noPgsFound.
  ///
  /// In en, this message translates to:
  /// **'No PGs Found'**
  String get noPgsFound;

  /// No description provided for @noPgsFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters to find more options.'**
  String get noPgsFoundDescription;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

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

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @noMenuAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Menu Available'**
  String get noMenuAvailable;

  /// No description provided for @noMenuAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Menu will be available soon.'**
  String get noMenuAvailableDescription;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @refreshMenu.
  ///
  /// In en, this message translates to:
  /// **'Refresh Menu'**
  String get refreshMenu;

  /// No description provided for @likeTodaysMenu.
  ///
  /// In en, this message translates to:
  /// **'Like Today\'s Menu'**
  String get likeTodaysMenu;

  /// No description provided for @dislike.
  ///
  /// In en, this message translates to:
  /// **'Dislike'**
  String get dislike;

  /// No description provided for @menuNote.
  ///
  /// In en, this message translates to:
  /// **'Menu Note'**
  String get menuNote;

  /// No description provided for @foodGallery.
  ///
  /// In en, this message translates to:
  /// **'Food Gallery'**
  String get foodGallery;

  /// No description provided for @noMenuForDay.
  ///
  /// In en, this message translates to:
  /// **'No Menu for {day}'**
  String noMenuForDay(String day);

  /// No description provided for @ownerHasntSetMenuForDay.
  ///
  /// In en, this message translates to:
  /// **'The owner hasn\'t set a menu for this day yet.'**
  String get ownerHasntSetMenuForDay;

  /// No description provided for @errorLoadingMenu.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Menu'**
  String get errorLoadingMenu;

  /// No description provided for @unableToLoadMenuPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Unable to load menu. Please try again.'**
  String get unableToLoadMenuPleaseTryAgain;

  /// No description provided for @foodMenuStatistics.
  ///
  /// In en, this message translates to:
  /// **'Food Menu Statistics'**
  String get foodMenuStatistics;

  /// No description provided for @weeklyMenus.
  ///
  /// In en, this message translates to:
  /// **'Weekly Menus'**
  String get weeklyMenus;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @todayMenu.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Menu'**
  String get todayMenu;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @sendPayment.
  ///
  /// In en, this message translates to:
  /// **'Send Payment'**
  String get sendPayment;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @ownerResponse.
  ///
  /// In en, this message translates to:
  /// **'Owner Response'**
  String get ownerResponse;

  /// No description provided for @ownerPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Owner Payment Details'**
  String get ownerPaymentDetails;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiId;

  /// No description provided for @upiQrCode.
  ///
  /// In en, this message translates to:
  /// **'UPI QR Code'**
  String get upiQrCode;

  /// No description provided for @sendPaymentNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Payment Notification'**
  String get sendPaymentNotification;

  /// No description provided for @afterMakingPaymentUploadScreenshot.
  ///
  /// In en, this message translates to:
  /// **'After making payment, upload screenshot and notify owner'**
  String get afterMakingPaymentUploadScreenshot;

  /// No description provided for @addComplaint.
  ///
  /// In en, this message translates to:
  /// **'Add Complaint'**
  String get addComplaint;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @noComplaintsFound.
  ///
  /// In en, this message translates to:
  /// **'No Complaints Found'**
  String get noComplaintsFound;

  /// No description provided for @noComplaintsFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t submitted any complaints yet. Tap the + button to add one.'**
  String get noComplaintsFoundDescription;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @myComplaints.
  ///
  /// In en, this message translates to:
  /// **'My Complaints'**
  String get myComplaints;

  /// No description provided for @noComplaintsFoundWithSelectedFilter.
  ///
  /// In en, this message translates to:
  /// **'No complaints found with the selected filter'**
  String get noComplaintsFoundWithSelectedFilter;

  /// No description provided for @noComplaintsYet.
  ///
  /// In en, this message translates to:
  /// **'No Complaints Yet'**
  String get noComplaintsYet;

  /// No description provided for @noComplaintsYetDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t submitted any complaints yet. Tap the + button to add your first complaint.'**
  String get noComplaintsYetDescription;

  /// No description provided for @errorLoadingComplaints.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Complaints'**
  String get errorLoadingComplaints;

  /// No description provided for @unableToLoadComplaints.
  ///
  /// In en, this message translates to:
  /// **'Unable to load complaints'**
  String get unableToLoadComplaints;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @loadingYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading your profile...'**
  String get loadingYourProfile;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Profile'**
  String get errorLoadingProfile;

  /// No description provided for @profilePhotos.
  ///
  /// In en, this message translates to:
  /// **'Profile Photos'**
  String get profilePhotos;

  /// No description provided for @aadhaarPhoto.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Photo'**
  String get aadhaarPhoto;

  /// No description provided for @failedToUploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload profile photo: {error}'**
  String failedToUploadProfilePhoto(String error);

  /// No description provided for @failedToUploadAadhaarPhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload Aadhaar photo: {error}'**
  String failedToUploadAadhaarPhoto(String error);

  /// No description provided for @noProfileDataFound.
  ///
  /// In en, this message translates to:
  /// **'No profile data found'**
  String get noProfileDataFound;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @nonVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Non-Vegetarian'**
  String get nonVegetarian;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @foodPreference.
  ///
  /// In en, this message translates to:
  /// **'Food Preference'**
  String get foodPreference;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @contactAndGuardianInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact & Guardian Information'**
  String get contactAndGuardianInformation;

  /// No description provided for @currentAddress.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get currentAddress;

  /// No description provided for @guardianName.
  ///
  /// In en, this message translates to:
  /// **'Guardian Name'**
  String get guardianName;

  /// No description provided for @guardianPhone.
  ///
  /// In en, this message translates to:
  /// **'Guardian Phone'**
  String get guardianPhone;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @eggetarian.
  ///
  /// In en, this message translates to:
  /// **'Eggetarian'**
  String get eggetarian;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

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

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @activeTenants.
  ///
  /// In en, this message translates to:
  /// **'Active Tenants'**
  String get activeTenants;

  /// No description provided for @occupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// No description provided for @pendingBookings.
  ///
  /// In en, this message translates to:
  /// **'Pending Bookings'**
  String get pendingBookings;

  /// No description provided for @pendingComplaints.
  ///
  /// In en, this message translates to:
  /// **'Pending Complaints'**
  String get pendingComplaints;

  /// No description provided for @refreshDashboard.
  ///
  /// In en, this message translates to:
  /// **'Refresh Dashboard'**
  String get refreshDashboard;

  /// No description provided for @loadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get loadingDashboard;

  /// No description provided for @errorLoadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Dashboard'**
  String get errorLoadingDashboard;

  /// No description provided for @dashboardDataWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Dashboard data will appear here once you add properties'**
  String get dashboardDataWillAppearHere;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @heresYourBusinessOverview.
  ///
  /// In en, this message translates to:
  /// **'Here\'s your business overview'**
  String get heresYourBusinessOverview;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @propertyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Property Breakdown'**
  String get propertyBreakdown;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add Property'**
  String get addProperty;

  /// No description provided for @addTenant.
  ///
  /// In en, this message translates to:
  /// **'Add Tenant'**
  String get addTenant;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// No description provided for @propertyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Property Revenue'**
  String get propertyRevenue;

  /// No description provided for @totalRevenueWithPgs.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue ({count} PGs)'**
  String totalRevenueWithPgs(int count);

  /// No description provided for @createPgMenus.
  ///
  /// In en, this message translates to:
  /// **'Create PG Menus'**
  String get createPgMenus;

  /// No description provided for @specialMenus.
  ///
  /// In en, this message translates to:
  /// **'Special Menus'**
  String get specialMenus;

  /// No description provided for @loadingMenus.
  ///
  /// In en, this message translates to:
  /// **'Loading menus...'**
  String get loadingMenus;

  /// No description provided for @failedToLoadMenus.
  ///
  /// In en, this message translates to:
  /// **'Failed to load menus'**
  String get failedToLoadMenus;

  /// No description provided for @noPgMenusFound.
  ///
  /// In en, this message translates to:
  /// **'No PG Menus Found'**
  String get noPgMenusFound;

  /// No description provided for @createWeeklyMenusForThisPg.
  ///
  /// In en, this message translates to:
  /// **'Create weekly menus for this PG to get started'**
  String get createWeeklyMenusForThisPg;

  /// No description provided for @useCreatePgMenusButton.
  ///
  /// In en, this message translates to:
  /// **'Use the \"Create PG Menus\" button in the app bar to get started'**
  String get useCreatePgMenusButton;

  /// No description provided for @createPgWeeklyMenus.
  ///
  /// In en, this message translates to:
  /// **'Create PG Weekly Menus'**
  String get createPgWeeklyMenus;

  /// No description provided for @thisWillCreateDefaultMenuTemplates.
  ///
  /// In en, this message translates to:
  /// **'This will create default menu templates for all 7 days of the week for this PG. You can edit them later.'**
  String get thisWillCreateDefaultMenuTemplates;

  /// No description provided for @initialize.
  ///
  /// In en, this message translates to:
  /// **'Initialize'**
  String get initialize;

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

  /// No description provided for @failedToInitializeMenusWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize menus: {error}'**
  String failedToInitializeMenusWithError(String error);

  /// No description provided for @specialMenuOptions.
  ///
  /// In en, this message translates to:
  /// **'Special Menu Options'**
  String get specialMenuOptions;

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

  /// No description provided for @editMenu.
  ///
  /// In en, this message translates to:
  /// **'Edit Menu'**
  String get editMenu;

  /// No description provided for @guestFeedbackToday.
  ///
  /// In en, this message translates to:
  /// **'Guest Feedback (Today)'**
  String get guestFeedbackToday;

  /// No description provided for @breakfastTime.
  ///
  /// In en, this message translates to:
  /// **'7:00 AM - 10:00 AM'**
  String get breakfastTime;

  /// No description provided for @lunchTime.
  ///
  /// In en, this message translates to:
  /// **'12:00 PM - 3:00 PM'**
  String get lunchTime;

  /// No description provided for @dinnerTime.
  ///
  /// In en, this message translates to:
  /// **'7:00 PM - 10:00 PM'**
  String get dinnerTime;

  /// No description provided for @createMenuForThisDay.
  ///
  /// In en, this message translates to:
  /// **'Create a menu for this day to get started'**
  String get createMenuForThisDay;

  /// No description provided for @createMenu.
  ///
  /// In en, this message translates to:
  /// **'Create Menu'**
  String get createMenu;

  /// No description provided for @special.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get special;

  /// No description provided for @weeklyMenuManagement.
  ///
  /// In en, this message translates to:
  /// **'Weekly Menu Management'**
  String get weeklyMenuManagement;

  /// No description provided for @manageBreakfastLunchDinnerForAllDays.
  ///
  /// In en, this message translates to:
  /// **'Manage breakfast, lunch & dinner for all days'**
  String get manageBreakfastLunchDinnerForAllDays;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @festival.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get festival;

  /// No description provided for @ownerFoodNoItemsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No items added yet'**
  String get ownerFoodNoItemsAddedYet;

  /// No description provided for @specialMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Special Menu'**
  String get specialMenuLabel;

  /// No description provided for @dayShortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayShortMon;

  /// No description provided for @dayShortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayShortTue;

  /// No description provided for @dayShortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayShortWed;

  /// No description provided for @dayShortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayShortThu;

  /// No description provided for @dayShortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayShortFri;

  /// No description provided for @dayShortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get dayShortSat;

  /// No description provided for @dayShortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get dayShortSun;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No Requests'**
  String get noRequests;

  /// No description provided for @bookingAndBedChangeRequestsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Booking and bed change requests will appear here'**
  String get bookingAndBedChangeRequestsWillAppearHere;

  /// No description provided for @bedChanges.
  ///
  /// In en, this message translates to:
  /// **'Bed Changes'**
  String get bedChanges;

  /// No description provided for @complaintsFromGuestsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Complaints from guests will appear here'**
  String get complaintsFromGuestsWillAppearHere;

  /// No description provided for @complaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get complaint;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @replyToComplaint.
  ///
  /// In en, this message translates to:
  /// **'Reply to Complaint'**
  String get replyToComplaint;

  /// No description provided for @typeYourReply.
  ///
  /// In en, this message translates to:
  /// **'Type your reply...'**
  String get typeYourReply;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @replySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent'**
  String get replySent;

  /// No description provided for @failedToSendReply.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reply'**
  String get failedToSendReply;

  /// No description provided for @resolveComplaint.
  ///
  /// In en, this message translates to:
  /// **'Resolve Complaint'**
  String get resolveComplaint;

  /// No description provided for @resolutionNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Resolution notes (optional)...'**
  String get resolutionNotesOptional;

  /// No description provided for @markResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark Resolved'**
  String get markResolved;

  /// No description provided for @complaintResolved.
  ///
  /// In en, this message translates to:
  /// **'Complaint resolved'**
  String get complaintResolved;

  /// No description provided for @failedToResolve.
  ///
  /// In en, this message translates to:
  /// **'Failed to resolve'**
  String get failedToResolve;

  /// No description provided for @refreshGuestData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Guest Data'**
  String get refreshGuestData;

  /// No description provided for @loadingGuestData.
  ///
  /// In en, this message translates to:
  /// **'Loading guest data...'**
  String get loadingGuestData;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Data'**
  String get errorLoadingData;

  /// No description provided for @bedMap.
  ///
  /// In en, this message translates to:
  /// **'Bed Map'**
  String get bedMap;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @refreshPgData.
  ///
  /// In en, this message translates to:
  /// **'Refresh PG Data'**
  String get refreshPgData;

  /// No description provided for @noPgsListedYet.
  ///
  /// In en, this message translates to:
  /// **'No PGs Listed Yet'**
  String get noPgsListedYet;

  /// No description provided for @tapButtonBelowToListFirstPg.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to list your first PG'**
  String get tapButtonBelowToListFirstPg;

  /// No description provided for @listYourFirstPg.
  ///
  /// In en, this message translates to:
  /// **'List Your First PG'**
  String get listYourFirstPg;

  /// No description provided for @loadingPgData.
  ///
  /// In en, this message translates to:
  /// **'Loading PG data...'**
  String get loadingPgData;

  /// No description provided for @bookingsOverview.
  ///
  /// In en, this message translates to:
  /// **'Bookings Overview'**
  String get bookingsOverview;

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

  /// No description provided for @occupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupied;

  /// No description provided for @vacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get vacant;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @noGuests.
  ///
  /// In en, this message translates to:
  /// **'No Guests'**
  String get noGuests;

  /// No description provided for @guestListWillAppearHereOnceGuestsAreAdded.
  ///
  /// In en, this message translates to:
  /// **'Guest list will appear here once guests are added'**
  String get guestListWillAppearHereOnceGuestsAreAdded;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changeStatus;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

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

  /// No description provided for @areYouSureYouWantToDeleteGuests.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} guests? This action cannot be undone.'**
  String areYouSureYouWantToDeleteGuests(int count);

  /// No description provided for @guestsDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Guests deleted successfully'**
  String get guestsDeletedSuccessfully;

  /// No description provided for @totalGuests.
  ///
  /// In en, this message translates to:
  /// **'Total Guests'**
  String get totalGuests;

  /// No description provided for @activeGuests.
  ///
  /// In en, this message translates to:
  /// **'Active Guests'**
  String get activeGuests;

  /// No description provided for @pendingGuests.
  ///
  /// In en, this message translates to:
  /// **'Pending Guests'**
  String get pendingGuests;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'found'**
  String get found;

  /// No description provided for @guestOverview.
  ///
  /// In en, this message translates to:
  /// **'Guest Overview'**
  String get guestOverview;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @atitiaIsAComprehensivePgManagementPlatform.
  ///
  /// In en, this message translates to:
  /// **'Atitia is a comprehensive PG management platform that connects PG owners with guests, streamlining bookings, payments, and daily operations.'**
  String get atitiaIsAComprehensivePgManagementPlatform;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// No description provided for @easyPgPropertyManagement.
  ///
  /// In en, this message translates to:
  /// **'• Easy PG property management'**
  String get easyPgPropertyManagement;

  /// No description provided for @secureOnlinePayments.
  ///
  /// In en, this message translates to:
  /// **'• Secure online payments'**
  String get secureOnlinePayments;

  /// No description provided for @realTimeNotifications.
  ///
  /// In en, this message translates to:
  /// **'• Real-time notifications'**
  String get realTimeNotifications;

  /// No description provided for @menuManagement.
  ///
  /// In en, this message translates to:
  /// **'• Menu management'**
  String get menuManagement;

  /// No description provided for @complaintTracking.
  ///
  /// In en, this message translates to:
  /// **'• Complaint tracking'**
  String get complaintTracking;

  /// No description provided for @visitorManagement.
  ///
  /// In en, this message translates to:
  /// **'• Visitor management'**
  String get visitorManagement;

  /// No description provided for @copyrightAtitiaAllRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Atitia. All rights reserved.'**
  String get copyrightAtitiaAllRightsReserved;

  /// No description provided for @charyataniTechnologies.
  ///
  /// In en, this message translates to:
  /// **'Charyatani Technologies'**
  String get charyataniTechnologies;

  /// No description provided for @weAreALeadingSoftwareDevelopmentCompany.
  ///
  /// In en, this message translates to:
  /// **'We are a leading software development company specializing in mobile and web applications for hospitality and property management.'**
  String get weAreALeadingSoftwareDevelopmentCompany;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us:'**
  String get contactUs;

  /// No description provided for @copyrightCharyataniTechnologies.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Charyatani Technologies Pvt. Ltd.'**
  String get copyrightCharyataniTechnologies;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

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

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @failedToSwitchAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to switch account'**
  String get failedToSwitchAccount;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

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

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleSignIn;

  /// No description provided for @enterYourCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Enter your complete name'**
  String get enterYourCompleteName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @emailAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get emailAddressOptional;

  /// No description provided for @yourEmailExampleCom.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get yourEmailExampleCom;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @uploadClearPhotosOfYourDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload clear photos of your documents for verification'**
  String get uploadClearPhotosOfYourDocuments;

  /// No description provided for @uploadClearPhotoOfYourself.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of yourself'**
  String get uploadClearPhotoOfYourself;

  /// No description provided for @uploadYourAadhaarCard.
  ///
  /// In en, this message translates to:
  /// **'Upload your Aadhaar card (front or back)'**
  String get uploadYourAadhaarCard;

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

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

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

  /// No description provided for @contactRelation.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get contactRelation;

  /// No description provided for @fullAddressOfEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Full address of emergency contact'**
  String get fullAddressOfEmergencyContact;

  /// No description provided for @father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get father;

  /// No description provided for @mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get mother;

  /// No description provided for @brother.
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get brother;

  /// No description provided for @sister.
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get sister;

  /// No description provided for @spouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouse;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @pleaseSelectPgFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a PG first'**
  String get pleaseSelectPgFirst;

  /// No description provided for @invalidPgSelectionOwnerInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Invalid PG selection. Owner information not available.'**
  String get invalidPgSelectionOwnerInfoNotAvailable;

  /// No description provided for @paymentSuccessfulOwnerWillBeNotified.
  ///
  /// In en, this message translates to:
  /// **'Payment successful! Owner will be notified.'**
  String get paymentSuccessfulOwnerWillBeNotified;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed: {message}'**
  String paymentFailed(String message);

  /// No description provided for @failedToProcessPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process payment: {error}'**
  String failedToProcessPayment(String error);

  /// No description provided for @pleaseUploadPaymentScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Please upload payment screenshot. Transaction ID is visible in the screenshot.'**
  String get pleaseUploadPaymentScreenshot;

  /// No description provided for @failedToSendNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed to send notification: {error}'**
  String failedToSendNotification(String error);

  /// No description provided for @uploadPaymentScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Upload Payment Screenshot'**
  String get uploadPaymentScreenshot;

  /// No description provided for @pleaseSelectPgFirstToFileComplaint.
  ///
  /// In en, this message translates to:
  /// **'Please select a PG first to file a complaint'**
  String get pleaseSelectPgFirstToFileComplaint;

  /// No description provided for @submitFirstComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit First Complaint'**
  String get submitFirstComplaint;

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

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages:'**
  String get messages;

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

  /// No description provided for @sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get sendReply;

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

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status: {error}'**
  String failedToUpdateStatus(String error);

  /// No description provided for @completeService.
  ///
  /// In en, this message translates to:
  /// **'Complete Service'**
  String get completeService;

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

  /// No description provided for @serviceCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service completed successfully'**
  String get serviceCompletedSuccessfully;

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

  /// No description provided for @areYouSureYouWantToRemoveBike.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {bikeName}?'**
  String areYouSureYouWantToRemoveBike(String bikeName);

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

  /// No description provided for @invalidPaymentOrOwnerInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Invalid payment or owner information not available.'**
  String get invalidPaymentOrOwnerInfoNotAvailable;

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

  /// No description provided for @failedToProcessUpiPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process UPI payment: {error}'**
  String failedToProcessUpiPayment(String error);

  /// No description provided for @cashPaymentNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Cash payment notification sent. Owner will confirm once they receive the payment.'**
  String get cashPaymentNotificationSent;

  /// No description provided for @failedToProcessCashPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to process cash payment: {error}'**
  String failedToProcessCashPayment(String error);

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// No description provided for @changeScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Change Screenshot'**
  String get changeScreenshot;

  /// No description provided for @cashPaymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Confirmation'**
  String get cashPaymentConfirmation;

  /// No description provided for @haveYouPaidAmountInCash.
  ///
  /// In en, this message translates to:
  /// **'Have you paid the amount in cash to the owner? Owner will confirm once they receive the payment.'**
  String get haveYouPaidAmountInCash;

  /// No description provided for @yesPaid.
  ///
  /// In en, this message translates to:
  /// **'Yes, Paid'**
  String get yesPaid;

  /// No description provided for @paymentDetailsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment details saved successfully'**
  String get paymentDetailsSavedSuccessfully;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String failedToSave(String error);

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @updatePg.
  ///
  /// In en, this message translates to:
  /// **'Update PG'**
  String get updatePg;

  /// No description provided for @createPg.
  ///
  /// In en, this message translates to:
  /// **'Create PG'**
  String get createPg;

  /// No description provided for @pleaseEnterPgNameBeforePublishing.
  ///
  /// In en, this message translates to:
  /// **'Please enter PG name before publishing'**
  String get pleaseEnterPgNameBeforePublishing;

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

  /// No description provided for @failedToSelectPhotos.
  ///
  /// In en, this message translates to:
  /// **'Failed to select photos: {error}'**
  String failedToSelectPhotos(String error);

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Guest Name'**
  String get guestName;

  /// No description provided for @searchGuestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Guests'**
  String get searchGuestsLabel;

  /// No description provided for @searchGuestsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, room, or email...'**
  String get searchGuestsHint;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @statusVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get statusVip;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @guestDataExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Guest data exported successfully'**
  String get guestDataExportedSuccessfully;

  /// No description provided for @guestListTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest List'**
  String get guestListTitle;

  /// No description provided for @guestCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 guests} one {1 guest} other {{count} guests}}'**
  String guestCount(num count);

  /// No description provided for @noGuestsYet.
  ///
  /// In en, this message translates to:
  /// **'No Guests Yet'**
  String get noGuestsYet;

  /// No description provided for @guestsAppearAfterBooking.
  ///
  /// In en, this message translates to:
  /// **'Guests will appear here once they book your PG'**
  String get guestsAppearAfterBooking;

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

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get emergencyPhone;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @messageToGuest.
  ///
  /// In en, this message translates to:
  /// **'To: {name}'**
  String messageToGuest(String name);

  /// No description provided for @enterMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your message...'**
  String get enterMessageHint;

  /// No description provided for @messageSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get messageSentSuccessfully;

  /// No description provided for @checkOutGuest.
  ///
  /// In en, this message translates to:
  /// **'Check Out Guest'**
  String get checkOutGuest;

  /// No description provided for @checkOutGuestConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to check out this guest? This action cannot be undone.'**
  String get checkOutGuestConfirmation;

  /// No description provided for @guestCheckedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Guest checked out successfully'**
  String get guestCheckedOutSuccessfully;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emergencyContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContactLabel;

  /// No description provided for @emergencyPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get emergencyPhoneLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @parkingSpot.
  ///
  /// In en, this message translates to:
  /// **'Parking Spot'**
  String get parkingSpot;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @resolutionNotes.
  ///
  /// In en, this message translates to:
  /// **'Resolution Notes'**
  String get resolutionNotes;

  /// No description provided for @markAsResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark as Resolved'**
  String get markAsResolved;

  /// No description provided for @complaintResolvedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint resolved successfully'**
  String get complaintResolvedSuccessfully;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

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

  /// No description provided for @replyLabel.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyLabel;

  /// No description provided for @uPI.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get uPI;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get amountLabel;

  /// No description provided for @weeklyMenuPreview.
  ///
  /// In en, this message translates to:
  /// **'Weekly Menu Preview'**
  String get weeklyMenuPreview;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @breakfastItems.
  ///
  /// In en, this message translates to:
  /// **'Breakfast Items'**
  String get breakfastItems;

  /// No description provided for @lunchItems.
  ///
  /// In en, this message translates to:
  /// **'Lunch Items'**
  String get lunchItems;

  /// No description provided for @dinnerItems.
  ///
  /// In en, this message translates to:
  /// **'Dinner Items'**
  String get dinnerItems;

  /// No description provided for @snackItems.
  ///
  /// In en, this message translates to:
  /// **'Snack Items'**
  String get snackItems;

  /// No description provided for @complaintStatistics.
  ///
  /// In en, this message translates to:
  /// **'Complaint Statistics'**
  String get complaintStatistics;

  /// No description provided for @totalComplaints.
  ///
  /// In en, this message translates to:
  /// **'Total Complaints'**
  String get totalComplaints;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @recentComplaintsPreview.
  ///
  /// In en, this message translates to:
  /// **'Recent Complaints Preview'**
  String get recentComplaintsPreview;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @maintenanceIssues.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Issues'**
  String get maintenanceIssues;

  /// No description provided for @cleanliness.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get cleanliness;

  /// No description provided for @foodQuality.
  ///
  /// In en, this message translates to:
  /// **'Food Quality'**
  String get foodQuality;

  /// No description provided for @noiseComplaints.
  ///
  /// In en, this message translates to:
  /// **'Noise Complaints'**
  String get noiseComplaints;

  /// No description provided for @backToPayments.
  ///
  /// In en, this message translates to:
  /// **'Back to Payments'**
  String get backToPayments;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

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

  /// No description provided for @theRequestedPaymentCouldNotBeFound.
  ///
  /// In en, this message translates to:
  /// **'The requested payment could not be found.'**
  String get theRequestedPaymentCouldNotBeFound;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDate;

  /// No description provided for @uPIReference.
  ///
  /// In en, this message translates to:
  /// **'UPI Reference'**
  String get uPIReference;

  /// No description provided for @pgId.
  ///
  /// In en, this message translates to:
  /// **'PG ID'**
  String get pgId;

  /// No description provided for @ownerId.
  ///
  /// In en, this message translates to:
  /// **'Owner ID'**
  String get ownerId;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @transactionIdOptional.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID (Optional)'**
  String get transactionIdOptional;

  /// No description provided for @transactionIdIsVisibleInScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID is visible in screenshot'**
  String get transactionIdIsVisibleInScreenshot;

  /// No description provided for @youCanSkipThisTransactionIdIsInScreenshot.
  ///
  /// In en, this message translates to:
  /// **'You can skip this - transaction ID is in the screenshot'**
  String get youCanSkipThisTransactionIdIsInScreenshot;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @notRequiredAlreadyVisibleInScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Not required - already visible in screenshot'**
  String get notRequiredAlreadyVisibleInScreenshot;

  /// No description provided for @messageOptional.
  ///
  /// In en, this message translates to:
  /// **'Message (Optional)'**
  String get messageOptional;

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

  /// No description provided for @serviceRequest.
  ///
  /// In en, this message translates to:
  /// **'Service Request'**
  String get serviceRequest;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get serviceTitle;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room number'**
  String get roomNumber;

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

  /// No description provided for @advancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearch;

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

  /// No description provided for @callOwner.
  ///
  /// In en, this message translates to:
  /// **'Call Owner'**
  String get callOwner;

  /// No description provided for @sharePg.
  ///
  /// In en, this message translates to:
  /// **'Share PG'**
  String get sharePg;

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

  /// No description provided for @failedToShare.
  ///
  /// In en, this message translates to:
  /// **'Failed to share: {error}'**
  String failedToShare(String error);

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

  /// No description provided for @yourCurrentResidentialAddress.
  ///
  /// In en, this message translates to:
  /// **'Your current residential address'**
  String get yourCurrentResidentialAddress;

  /// No description provided for @nameOfYourParentOrGuardian.
  ///
  /// In en, this message translates to:
  /// **'Name of your parent or guardian'**
  String get nameOfYourParentOrGuardian;

  /// No description provided for @tenDigitPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'10-digit phone number'**
  String get tenDigitPhoneNumber;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid 10-digit phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @configureHowGuestsCanPayYou.
  ///
  /// In en, this message translates to:
  /// **'Configure how guests can pay you'**
  String get configureHowGuestsCanPayYou;

  /// No description provided for @bankAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Details'**
  String get bankAccountDetails;

  /// No description provided for @addYourBankAccountDetailsForDirectTransfers.
  ///
  /// In en, this message translates to:
  /// **'Add your bank account details for direct transfers'**
  String get addYourBankAccountDetailsForDirectTransfers;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

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

  /// No description provided for @uPIDetails.
  ///
  /// In en, this message translates to:
  /// **'UPI Details'**
  String get uPIDetails;

  /// No description provided for @addYourUpiIdForInstantPayments.
  ///
  /// In en, this message translates to:
  /// **'Add your UPI ID for instant payments'**
  String get addYourUpiIdForInstantPayments;

  /// No description provided for @upiID.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiID;

  /// No description provided for @paymentInstructionsOptional.
  ///
  /// In en, this message translates to:
  /// **'Payment Instructions (Optional)'**
  String get paymentInstructionsOptional;

  /// No description provided for @uploadYourUpiQrCodeFromAnyPaymentApp.
  ///
  /// In en, this message translates to:
  /// **'Upload your UPI QR code from any payment app'**
  String get uploadYourUpiQrCodeFromAnyPaymentApp;

  /// No description provided for @changeQrCode.
  ///
  /// In en, this message translates to:
  /// **'Change QR Code'**
  String get changeQrCode;

  /// No description provided for @uploadQrCode.
  ///
  /// In en, this message translates to:
  /// **'Upload QR Code'**
  String get uploadQrCode;

  /// No description provided for @savePaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Payment Details'**
  String get savePaymentDetails;

  /// No description provided for @editPg.
  ///
  /// In en, this message translates to:
  /// **'Edit PG'**
  String get editPg;

  /// No description provided for @newPgSetup.
  ///
  /// In en, this message translates to:
  /// **'New PG Setup'**
  String get newPgSetup;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @rentConfig.
  ///
  /// In en, this message translates to:
  /// **'Rent Config'**
  String get rentConfig;

  /// No description provided for @structure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get structure;

  /// No description provided for @floorStructure.
  ///
  /// In en, this message translates to:
  /// **'Floor Structure'**
  String get floorStructure;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additionalInfo;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @startBuildingYourPgProfile.
  ///
  /// In en, this message translates to:
  /// **'Start Building Your PG Profile'**
  String get startBuildingYourPgProfile;

  /// No description provided for @defineYourPgStructure.
  ///
  /// In en, this message translates to:
  /// **'Define Your PG Structure'**
  String get defineYourPgStructure;

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

  /// No description provided for @addPgAmenities.
  ///
  /// In en, this message translates to:
  /// **'Add PG Amenities'**
  String get addPgAmenities;

  /// No description provided for @uploadPgPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload PG Photos'**
  String get uploadPgPhotos;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @theRequestedPgCouldNotBeFoundOrMayHaveBeenRemoved.
  ///
  /// In en, this message translates to:
  /// **'The requested PG could not be found or may have been removed.'**
  String get theRequestedPgCouldNotBeFoundOrMayHaveBeenRemoved;

  /// No description provided for @newParkingSpot.
  ///
  /// In en, this message translates to:
  /// **'New Parking Spot'**
  String get newParkingSpot;

  /// No description provided for @reasonForMove.
  ///
  /// In en, this message translates to:
  /// **'Reason for Move'**
  String get reasonForMove;

  /// No description provided for @reasonForRemoval.
  ///
  /// In en, this message translates to:
  /// **'Reason for Removal'**
  String get reasonForRemoval;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

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

  /// No description provided for @anySpecialInstructionsForGuests.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions for guests'**
  String get anySpecialInstructionsForGuests;

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

  /// No description provided for @pushNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get pushNotificationsDescription;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get emailNotificationsDescription;

  /// No description provided for @paymentReminders.
  ///
  /// In en, this message translates to:
  /// **'Payment Reminders'**
  String get paymentReminders;

  /// No description provided for @paymentRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get reminders for pending payments'**
  String get paymentRemindersDescription;

  /// No description provided for @dataAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataAndPrivacy;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

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

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get themeDescription;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get languageDescription;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @createServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Service Request'**
  String get createServiceRequest;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @otherServices.
  ///
  /// In en, this message translates to:
  /// **'Other Services'**
  String get otherServices;

  /// No description provided for @serviceRequests.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get serviceRequests;

  /// No description provided for @noServiceRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No service requests yet'**
  String get noServiceRequestsYet;

  /// No description provided for @serviceRequestsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Guest service requests will appear here when submitted'**
  String get serviceRequestsAppearHere;

  /// No description provided for @serviceStarted.
  ///
  /// In en, this message translates to:
  /// **'Service started'**
  String get serviceStarted;

  /// No description provided for @serviceStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service status updated'**
  String get serviceStatusUpdated;

  /// No description provided for @unreadMessagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread messages'**
  String unreadMessagesCount(int count);

  /// No description provided for @searchBikesHint.
  ///
  /// In en, this message translates to:
  /// **'Search by number, name, guest, or model...'**
  String get searchBikesHint;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @violation.
  ///
  /// In en, this message translates to:
  /// **'Violation'**
  String get violation;

  /// No description provided for @violations.
  ///
  /// In en, this message translates to:
  /// **'Violations'**
  String get violations;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @totalBikes.
  ///
  /// In en, this message translates to:
  /// **'Total Bikes'**
  String get totalBikes;

  /// No description provided for @bikeRegistry.
  ///
  /// In en, this message translates to:
  /// **'Bike Registry'**
  String get bikeRegistry;

  /// No description provided for @noBikesRegistered.
  ///
  /// In en, this message translates to:
  /// **'No Bikes Registered'**
  String get noBikesRegistered;

  /// No description provided for @guestBikesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Guest bikes will appear here when registered'**
  String get guestBikesWillAppearHere;

  /// No description provided for @bikeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bikes'**
  String bikeCount(int count);

  /// No description provided for @bikeNumber.
  ///
  /// In en, this message translates to:
  /// **'Bike Number'**
  String get bikeNumber;

  /// No description provided for @bikeName.
  ///
  /// In en, this message translates to:
  /// **'Bike Name'**
  String get bikeName;

  /// No description provided for @bikeType.
  ///
  /// In en, this message translates to:
  /// **'Bike Type'**
  String get bikeType;

  /// No description provided for @bikeModel.
  ///
  /// In en, this message translates to:
  /// **'Bike Model'**
  String get bikeModel;

  /// No description provided for @bikeColor.
  ///
  /// In en, this message translates to:
  /// **'Bike Color'**
  String get bikeColor;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @registeredOn.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registeredOn;

  /// No description provided for @lastParked.
  ///
  /// In en, this message translates to:
  /// **'Last Parked'**
  String get lastParked;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removed;

  /// No description provided for @violationLabel.
  ///
  /// In en, this message translates to:
  /// **'Violation'**
  String get violationLabel;

  /// No description provided for @ownerRequestedMove.
  ///
  /// In en, this message translates to:
  /// **'Owner requested move'**
  String get ownerRequestedMove;

  /// No description provided for @ownerRequestedRemoval.
  ///
  /// In en, this message translates to:
  /// **'Owner requested removal'**
  String get ownerRequestedRemoval;

  /// No description provided for @violationWithReason.
  ///
  /// In en, this message translates to:
  /// **'Violation: {reason}'**
  String violationWithReason(String reason);

  /// No description provided for @searchComplaintsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title, guest, room, or description...'**
  String get searchComplaintsHint;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get statusResolved;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @complaintCount.
  ///
  /// In en, this message translates to:
  /// **'{count} complaints'**
  String complaintCount(int count);

  /// No description provided for @complaintDataExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint data exported successfully'**
  String get complaintDataExportedSuccessfully;

  /// No description provided for @complaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint Title'**
  String get complaintTitle;

  /// No description provided for @priorityLevel.
  ///
  /// In en, this message translates to:
  /// **'Priority Level'**
  String get priorityLevel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @imagesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} image(s) selected'**
  String imagesSelected(int count);

  /// No description provided for @commonComplaintCategories.
  ///
  /// In en, this message translates to:
  /// **'Common Complaint Categories:'**
  String get commonComplaintCategories;

  /// No description provided for @complaintCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get complaintCategoryFood;

  /// No description provided for @complaintCategoryCleanliness.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get complaintCategoryCleanliness;

  /// No description provided for @complaintCategoryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get complaintCategoryMaintenance;

  /// No description provided for @complaintCategoryWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get complaintCategoryWater;

  /// No description provided for @complaintCategoryElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get complaintCategoryElectricity;

  /// No description provided for @complaintCategoryWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get complaintCategoryWifi;

  /// No description provided for @complaintCategoryNoise.
  ///
  /// In en, this message translates to:
  /// **'Noise'**
  String get complaintCategoryNoise;

  /// No description provided for @complaintCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get complaintCategoryGeneral;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String todayAt(String time);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @bookBed.
  ///
  /// In en, this message translates to:
  /// **'Book a Bed'**
  String get bookBed;

  /// No description provided for @selectFloor.
  ///
  /// In en, this message translates to:
  /// **'Select Floor'**
  String get selectFloor;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select Room'**
  String get selectRoom;

  /// No description provided for @selectBed.
  ///
  /// In en, this message translates to:
  /// **'Select Bed'**
  String get selectBed;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get sharing;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @legacyBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Please contact the owner directly to book this PG.'**
  String get legacyBookingMessage;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @bookingRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking request sent! Owner will confirm shortly.'**
  String get bookingRequestSuccess;

  /// No description provided for @bookingRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to book: {error}'**
  String bookingRequestFailed(String error);

  /// No description provided for @roomOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'{roomNumber} ({sharingType}-sharing) - {availableBeds} available'**
  String roomOptionLabel(
      String roomNumber, String sharingType, int availableBeds);

  /// No description provided for @bedLabel.
  ///
  /// In en, this message translates to:
  /// **'Bed {number}'**
  String bedLabel(String number);

  /// No description provided for @bed.
  ///
  /// In en, this message translates to:
  /// **'Bed'**
  String get bed;

  /// No description provided for @requestToJoinPg.
  ///
  /// In en, this message translates to:
  /// **'Request to Join PG'**
  String get requestToJoinPg;

  /// No description provided for @sendBookingRequestToOwner.
  ///
  /// In en, this message translates to:
  /// **'Send a booking request to the owner'**
  String get sendBookingRequestToOwner;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @enterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmailAddress;

  /// No description provided for @messageOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional information for the owner...'**
  String get messageOptionalHint;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @pleaseEnterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterYourEmailAddress;

  /// No description provided for @pleaseEnterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmailAddress;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @monthlyRentDisplay.
  ///
  /// In en, this message translates to:
  /// **'₹{amount}/month'**
  String monthlyRentDisplay(String amount);

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @pgCountSummary.
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total} PGs'**
  String pgCountSummary(int filtered, int total);

  /// No description provided for @errorLoadingPgs.
  ///
  /// In en, this message translates to:
  /// **'Error loading PGs'**
  String get errorLoadingPgs;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownErrorOccurred;

  /// No description provided for @noPgsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No PGs Available'**
  String get noPgsAvailable;

  /// No description provided for @pgListingsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'PG listings will appear here once they are added to the platform.'**
  String get pgListingsWillAppear;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @photosBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} Photo(s)'**
  String photosBadge(int count);

  /// No description provided for @noImageAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Image Available'**
  String get noImageAvailable;

  /// No description provided for @distanceMeters.
  ///
  /// In en, this message translates to:
  /// **'{meters}m away'**
  String distanceMeters(int meters);

  /// No description provided for @distanceKilometers.
  ///
  /// In en, this message translates to:
  /// **'{kilometers}km away'**
  String distanceKilometers(double kilometers);

  /// No description provided for @sharingLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Sharing'**
  String sharingLabel(int count);

  /// No description provided for @pgTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{type}'**
  String pgTypeLabel(String type);

  /// No description provided for @mealTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{type}'**
  String mealTypeLabel(String type);

  /// No description provided for @noAmenitiesListed.
  ///
  /// In en, this message translates to:
  /// **'No amenities listed for this PG'**
  String get noAmenitiesListed;

  /// No description provided for @amenitiesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenitiesSectionTitle;

  /// No description provided for @amenitiesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amenities available in this PG'**
  String get amenitiesSectionSubtitle;

  /// No description provided for @noPhotosAvailable.
  ///
  /// In en, this message translates to:
  /// **'No photos available'**
  String get noPhotosAvailable;

  /// No description provided for @failedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failedToLoadImage;

  /// No description provided for @pgDetails.
  ///
  /// In en, this message translates to:
  /// **'PG Details'**
  String get pgDetails;

  /// No description provided for @errorLoadingPgDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading PG details'**
  String get errorLoadingPgDetails;

  /// No description provided for @sharingOptionsPricing.
  ///
  /// In en, this message translates to:
  /// **'Sharing Options & Pricing'**
  String get sharingOptionsPricing;

  /// No description provided for @securityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security Deposit'**
  String get securityDeposit;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'Per Month'**
  String get perMonth;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'one-time'**
  String get oneTime;

  /// No description provided for @refundableWhenYouLeave.
  ///
  /// In en, this message translates to:
  /// **'(Refundable when you leave)'**
  String get refundableWhenYouLeave;

  /// No description provided for @monthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'(Monthly)'**
  String get monthlyLabel;

  /// No description provided for @oneTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'(One-time)'**
  String get oneTimeLabel;

  /// No description provided for @totalInitialPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Initial Payment'**
  String get totalInitialPayment;

  /// No description provided for @firstMonthRent.
  ///
  /// In en, this message translates to:
  /// **'First Month Rent'**
  String get firstMonthRent;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @secondMonthRentMaintenance.
  ///
  /// In en, this message translates to:
  /// **'From 2nd month onwards: Rent + Maintenance (₹{rent} + ₹{maintenance} = ₹{total})'**
  String secondMonthRentMaintenance(
      String rent, String maintenance, String total);

  /// No description provided for @secondMonthRentOnly.
  ///
  /// In en, this message translates to:
  /// **'From 2nd month onwards: Only Rent (₹{rent})'**
  String secondMonthRentOnly(String rent);

  /// No description provided for @availableTypes.
  ///
  /// In en, this message translates to:
  /// **'Available: {types}'**
  String availableTypes(String types);

  /// No description provided for @sharingLabelDefault.
  ///
  /// In en, this message translates to:
  /// **'{count} Sharing'**
  String sharingLabelDefault(String count);

  /// No description provided for @completeAddress.
  ///
  /// In en, this message translates to:
  /// **'Complete Address'**
  String get completeAddress;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @mealTypeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal Type'**
  String get mealTypeFieldLabel;

  /// No description provided for @pgTypeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'PG Type'**
  String get pgTypeFieldLabel;

  /// No description provided for @mealTimingsFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal Timings'**
  String get mealTimingsFieldLabel;

  /// No description provided for @foodQualityFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Quality'**
  String get foodQualityFieldLabel;

  /// No description provided for @entryTimings.
  ///
  /// In en, this message translates to:
  /// **'Entry Timings'**
  String get entryTimings;

  /// No description provided for @exitTimings.
  ///
  /// In en, this message translates to:
  /// **'Exit Timings'**
  String get exitTimings;

  /// No description provided for @guestPolicy.
  ///
  /// In en, this message translates to:
  /// **'Guest Policy'**
  String get guestPolicy;

  /// No description provided for @smokingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Smoking Policy'**
  String get smokingPolicy;

  /// No description provided for @alcoholPolicy.
  ///
  /// In en, this message translates to:
  /// **'Alcohol Policy'**
  String get alcoholPolicy;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refundPolicy;

  /// No description provided for @noticePeriod.
  ///
  /// In en, this message translates to:
  /// **'Notice Period'**
  String get noticePeriod;

  /// No description provided for @ownerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerNameLabel;

  /// No description provided for @contactNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumberLabel;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolder;

  /// No description provided for @qrCodeForPayment.
  ///
  /// In en, this message translates to:
  /// **'QR Code for Payment'**
  String get qrCodeForPayment;

  /// No description provided for @paymentInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Instructions'**
  String get paymentInstructionsLabel;

  /// No description provided for @parkingDetails.
  ///
  /// In en, this message translates to:
  /// **'Parking Details'**
  String get parkingDetails;

  /// No description provided for @securityMeasures.
  ///
  /// In en, this message translates to:
  /// **'Security Measures'**
  String get securityMeasures;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @nearbyPlacesLabel.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get nearbyPlacesLabel;

  /// No description provided for @pgProperty.
  ///
  /// In en, this message translates to:
  /// **'PG Property'**
  String get pgProperty;

  /// No description provided for @sharePgHeading.
  ///
  /// In en, this message translates to:
  /// **'🏠 {name}'**
  String sharePgHeading(String name);

  /// No description provided for @sharePgAddressLine.
  ///
  /// In en, this message translates to:
  /// **'📍 Address: {address}'**
  String sharePgAddressLine(String address);

  /// No description provided for @sharePgPricingHeader.
  ///
  /// In en, this message translates to:
  /// **'💰 Pricing:'**
  String get sharePgPricingHeader;

  /// No description provided for @sharePgPricingEntry.
  ///
  /// In en, this message translates to:
  /// **'{count} Share: ₹{price}'**
  String sharePgPricingEntry(String count, String price);

  /// No description provided for @sharePgAmenitiesLine.
  ///
  /// In en, this message translates to:
  /// **'✨ Amenities: {amenities}'**
  String sharePgAmenitiesLine(String amenities);

  /// No description provided for @sharePgFooter.
  ///
  /// In en, this message translates to:
  /// **'Check out this PG on Atitia!'**
  String get sharePgFooter;

  /// No description provided for @myBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'My Booking Requests'**
  String get myBookingRequests;

  /// No description provided for @loadingBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Loading booking requests...'**
  String get loadingBookingRequests;

  /// No description provided for @bookingRequestsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Requests'**
  String get bookingRequestsErrorTitle;

  /// No description provided for @bookingRequestsIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Started with Booking Requests'**
  String get bookingRequestsIntroTitle;

  /// No description provided for @bookingRequestsIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse PGs and send booking requests. Owners will review and respond to your requests here.'**
  String get bookingRequestsIntroDescription;

  /// No description provided for @bookingRequestSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Request Summary'**
  String get bookingRequestSummary;

  /// No description provided for @bookingRequestAuthDebug.
  ///
  /// In en, this message translates to:
  /// **'⚠️ No Firebase Auth user found - user might not be authenticated'**
  String get bookingRequestAuthDebug;

  /// No description provided for @bookingRequestLoadingDebug.
  ///
  /// In en, this message translates to:
  /// **'🔑 Loading booking requests for guestId: {guestId}'**
  String bookingRequestLoadingDebug(String guestId);

  /// No description provided for @bookingRequestStreamErrorDebug.
  ///
  /// In en, this message translates to:
  /// **'Booking requests stream error: {error}'**
  String bookingRequestStreamErrorDebug(String error);

  /// No description provided for @bookingRequestExceptionDebug.
  ///
  /// In en, this message translates to:
  /// **'Exception loading booking requests: {error}'**
  String bookingRequestExceptionDebug(String error);

  /// No description provided for @pgLocationFallback.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get pgLocationFallback;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @talukaMandalLabel.
  ///
  /// In en, this message translates to:
  /// **'Taluka/Mandal'**
  String get talukaMandalLabel;

  /// No description provided for @societyLabel.
  ///
  /// In en, this message translates to:
  /// **'Society'**
  String get societyLabel;

  /// No description provided for @selectPgPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select a PG to view details and manage your stay'**
  String get selectPgPrompt;

  /// No description provided for @statusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get statusMaintenance;

  /// No description provided for @currencyAmount.
  ///
  /// In en, this message translates to:
  /// **'₹{amount}'**
  String currencyAmount(String amount);

  /// No description provided for @maintenanceAmountWithFrequency.
  ///
  /// In en, this message translates to:
  /// **'₹{amount}/{frequency}'**
  String maintenanceAmountWithFrequency(String amount, String frequency);

  /// No description provided for @bookingRequestPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingRequestPending;

  /// No description provided for @bookingRequestApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get bookingRequestApproved;

  /// No description provided for @bookingRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bookingRequestRejected;

  /// No description provided for @bookingRequestRequestedOn.
  ///
  /// In en, this message translates to:
  /// **'Requested: {date}'**
  String bookingRequestRequestedOn(String date);

  /// No description provided for @bookingRequestRespondedOn.
  ///
  /// In en, this message translates to:
  /// **'Responded: {date}'**
  String bookingRequestRespondedOn(String date);

  /// No description provided for @bookingRequestFrom.
  ///
  /// In en, this message translates to:
  /// **'Request from: {name}'**
  String bookingRequestFrom(String name);

  /// No description provided for @bookingRequestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Request Details'**
  String get bookingRequestDetailsTitle;

  /// No description provided for @bookingRequestPgName.
  ///
  /// In en, this message translates to:
  /// **'PG Name'**
  String get bookingRequestPgName;

  /// No description provided for @bookingRequestStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bookingRequestStatus;

  /// No description provided for @bookingRequestDate.
  ///
  /// In en, this message translates to:
  /// **'Request Date'**
  String get bookingRequestDate;

  /// No description provided for @bookingRequestResponseDate.
  ///
  /// In en, this message translates to:
  /// **'Response Date'**
  String get bookingRequestResponseDate;

  /// No description provided for @bookingRequestOwnerResponse.
  ///
  /// In en, this message translates to:
  /// **'Owner Response'**
  String get bookingRequestOwnerResponse;

  /// No description provided for @bookingRequestLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load booking requests'**
  String get bookingRequestLoadFailed;

  /// No description provided for @bookingRequestPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please ensure you are logged in correctly.'**
  String get bookingRequestPermissionDenied;

  /// No description provided for @bookingRequestNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get bookingRequestNetworkError;

  /// No description provided for @bookingRequestGeneralError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load booking requests: {error}'**
  String bookingRequestGeneralError(String error);

  /// No description provided for @bookingRequestUserNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated. Please sign in again.'**
  String get bookingRequestUserNotAuthenticated;

  /// No description provided for @myRoomAndBed.
  ///
  /// In en, this message translates to:
  /// **'My Room & Bed'**
  String get myRoomAndBed;

  /// No description provided for @userNotAuthenticatedRoomBed.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated. Please sign in again.'**
  String get userNotAuthenticatedRoomBed;

  /// No description provided for @failedToLoadRoomBedInformation.
  ///
  /// In en, this message translates to:
  /// **'Failed to load room/bed information: {error}'**
  String failedToLoadRoomBedInformation(String error);

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @noActiveBooking.
  ///
  /// In en, this message translates to:
  /// **'No Active Booking'**
  String get noActiveBooking;

  /// No description provided for @noActiveBookingDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an active booking yet. Book a PG to get assigned a room and bed.'**
  String get noActiveBookingDescription;

  /// No description provided for @roomLabelWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Room {number}'**
  String roomLabelWithNumber(String number);

  /// No description provided for @bedLabelWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Bed {number}'**
  String bedLabelWithNumber(String number);

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get notAssigned;

  /// No description provided for @bookingInformation.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get bookingInformation;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @requestBedRoomChange.
  ///
  /// In en, this message translates to:
  /// **'Request Bed/Room Change'**
  String get requestBedRoomChange;

  /// No description provided for @requestBedRoomChangeDescription.
  ///
  /// In en, this message translates to:
  /// **'Need to change your room or bed? Submit a request and the owner will review it.'**
  String get requestBedRoomChangeDescription;

  /// No description provided for @requestChange.
  ///
  /// In en, this message translates to:
  /// **'Request Change'**
  String get requestChange;

  /// No description provided for @requestRoomBedChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Room/Bed Change'**
  String get requestRoomBedChangeTitle;

  /// No description provided for @currentAssignment.
  ///
  /// In en, this message translates to:
  /// **'Current Assignment:'**
  String get currentAssignment;

  /// No description provided for @preferredRoomNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Preferred Room Number (Optional)'**
  String get preferredRoomNumberOptional;

  /// No description provided for @preferredRoomNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter preferred room...'**
  String get preferredRoomNumberHint;

  /// No description provided for @preferredBedNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Preferred Bed Number (Optional)'**
  String get preferredBedNumberOptional;

  /// No description provided for @preferredBedNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter preferred bed...'**
  String get preferredBedNumberHint;

  /// No description provided for @reasonRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason *'**
  String get reasonRequiredLabel;

  /// No description provided for @reasonRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'Why do you need to change room/bed?'**
  String get reasonRequiredHint;

  /// No description provided for @provideReasonError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for the change'**
  String get provideReasonError;

  /// No description provided for @changeRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Change request submitted successfully'**
  String get changeRequestSuccess;

  /// No description provided for @bedChangeRequestStatus.
  ///
  /// In en, this message translates to:
  /// **'Bed Change Request Status'**
  String get bedChangeRequestStatus;

  /// No description provided for @failedToLoadBedChangeRequests.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bed change requests: {error}'**
  String failedToLoadBedChangeRequests(String error);

  /// No description provided for @requestedLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested: {date}'**
  String requestedLabel(String date);

  /// No description provided for @preferredLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred:'**
  String get preferredLabel;

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason:'**
  String get reasonLabel;

  /// No description provided for @ownerResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Response:'**
  String get ownerResponseLabel;

  /// No description provided for @requestedOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested: {date}'**
  String requestedOnLabel(String date);

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @paymentMethodWithValue.
  ///
  /// In en, this message translates to:
  /// **'Payment Method: {method}'**
  String paymentMethodWithValue(String method);

  /// No description provided for @paymentMethodRazorpay.
  ///
  /// In en, this message translates to:
  /// **'Razorpay'**
  String get paymentMethodRazorpay;

  /// No description provided for @paymentMethodUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentMethodUpi;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No Payments Yet'**
  String get noPaymentsYet;

  /// No description provided for @noPaymentsYetDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t made any payments yet. Payments will appear here once you make them.'**
  String get noPaymentsYetDescription;

  /// No description provided for @makePayment.
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get makePayment;

  /// No description provided for @noPaymentsForFilter.
  ///
  /// In en, this message translates to:
  /// **'No {filter} Payments'**
  String noPaymentsForFilter(String filter);

  /// No description provided for @noPaymentsForFilterDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any {filter} payments at the moment.'**
  String noPaymentsForFilterDescription(String filter);

  /// No description provided for @failedToLoadPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payment details: {error}'**
  String failedToLoadPaymentDetails(String error);

  /// No description provided for @paymentNumber.
  ///
  /// In en, this message translates to:
  /// **'Payment #{id}'**
  String paymentNumber(String id);

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @upiPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'UPI payment made. Please verify and confirm.'**
  String get upiPaymentNote;

  /// No description provided for @cashPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Cash payment made. Please confirm.'**
  String get cashPaymentNote;

  /// No description provided for @upiPaymentTip.
  ///
  /// In en, this message translates to:
  /// **'💡 Tip: After making payment via PhonePe, Paytm, Google Pay, etc., upload the payment screenshot. The transaction ID is already visible in the screenshot.'**
  String get upiPaymentTip;

  /// No description provided for @paymentStatistics.
  ///
  /// In en, this message translates to:
  /// **'Payment Statistics'**
  String get paymentStatistics;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get totalPayments;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @recentPaymentsPreview.
  ///
  /// In en, this message translates to:
  /// **'Recent Payments Preview'**
  String get recentPaymentsPreview;

  /// No description provided for @noPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'No Payment History'**
  String get noPaymentHistory;

  /// No description provided for @noPaymentHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Your payment notifications and history will appear here once you make payments.'**
  String get noPaymentHistoryDescription;

  /// No description provided for @paymentDetailsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Payment Details Not Available'**
  String get paymentDetailsNotAvailable;

  /// No description provided for @ownerPaymentDetailsNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Owner payment details are not configured yet. Please contact your PG owner to set up payment information.'**
  String get ownerPaymentDetailsNotConfigured;

  /// No description provided for @paymentMethodsPreview.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods Preview:'**
  String get paymentMethodsPreview;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// No description provided for @cashPaymentNotificationInfo.
  ///
  /// In en, this message translates to:
  /// **'You will send a cash payment notification to the owner. Owner will confirm once they receive the cash.'**
  String get cashPaymentNotificationInfo;

  /// No description provided for @payViaRazorpayDescription.
  ///
  /// In en, this message translates to:
  /// **'Click \"Pay Now\" to proceed with secure online payment via Razorpay.'**
  String get payViaRazorpayDescription;

  /// No description provided for @payViaRazorpay.
  ///
  /// In en, this message translates to:
  /// **'Pay via Razorpay'**
  String get payViaRazorpay;

  /// No description provided for @upiPaymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'UPI Payment Confirmation'**
  String get upiPaymentConfirmation;

  /// No description provided for @cashPaymentNotification.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Notification'**
  String get cashPaymentNotification;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @paymentNotificationSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment notification sent successfully'**
  String get paymentNotificationSentSuccessfully;

  /// No description provided for @screenshotUploaded.
  ///
  /// In en, this message translates to:
  /// **'Screenshot uploaded'**
  String get screenshotUploaded;

  /// No description provided for @ownerNoPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Payments'**
  String get ownerNoPaymentsTitle;

  /// No description provided for @ownerNoPaymentsMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment records will appear here once payments are collected.'**
  String get ownerNoPaymentsMessage;

  /// No description provided for @unknownGuest.
  ///
  /// In en, this message translates to:
  /// **'Unknown Guest'**
  String get unknownGuest;

  /// No description provided for @roomBed.
  ///
  /// In en, this message translates to:
  /// **'Room/Bed'**
  String get roomBed;

  /// No description provided for @markPaymentCollected.
  ///
  /// In en, this message translates to:
  /// **'Mark Payment as Collected'**
  String get markPaymentCollected;

  /// No description provided for @confirmMarkPaymentCollected.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this payment of {amount} as collected?'**
  String confirmMarkPaymentCollected(String amount);

  /// No description provided for @collectedBy.
  ///
  /// In en, this message translates to:
  /// **'Collected By'**
  String get collectedBy;

  /// No description provided for @paymentMarkedCollected.
  ///
  /// In en, this message translates to:
  /// **'Payment marked as collected'**
  String get paymentMarkedCollected;

  /// No description provided for @failedToUpdatePayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to update payment: {error}'**
  String failedToUpdatePayment(String error);

  /// No description provided for @rejectPayment.
  ///
  /// In en, this message translates to:
  /// **'Reject Payment'**
  String get rejectPayment;

  /// No description provided for @provideRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for rejecting this payment:'**
  String get provideRejectionReason;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @enterRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Enter reason for rejection...'**
  String get enterRejectionReason;

  /// No description provided for @paymentRejected.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected'**
  String get paymentRejected;

  /// No description provided for @failedToRejectPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject payment'**
  String get failedToRejectPayment;

  /// No description provided for @paymentRejectedByOwner.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected by owner'**
  String get paymentRejectedByOwner;

  /// No description provided for @rejectedWithReason.
  ///
  /// In en, this message translates to:
  /// **'Rejected: {reason}'**
  String rejectedWithReason(String reason);

  /// No description provided for @collectedByOwnerFallback.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get collectedByOwnerFallback;

  /// No description provided for @recordPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Manually record a payment received from a guest'**
  String get recordPaymentDescription;

  /// No description provided for @guestAndBooking.
  ///
  /// In en, this message translates to:
  /// **'Guest & Booking'**
  String get guestAndBooking;

  /// No description provided for @selectGuest.
  ///
  /// In en, this message translates to:
  /// **'Select Guest'**
  String get selectGuest;

  /// No description provided for @pleaseSelectGuest.
  ///
  /// In en, this message translates to:
  /// **'Please select a guest'**
  String get pleaseSelectGuest;

  /// No description provided for @selectBookingOptional.
  ///
  /// In en, this message translates to:
  /// **'Select Booking (Optional)'**
  String get selectBookingOptional;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount *'**
  String get paymentAmountLabel;

  /// No description provided for @enterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount in rupees'**
  String get enterAmountHint;

  /// No description provided for @enterTransactionIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction ID or reference number'**
  String get enterTransactionIdHint;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional notes about this payment'**
  String get notesHint;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @recordPaymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully!'**
  String get recordPaymentSuccess;

  /// No description provided for @recordPaymentFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to record payment'**
  String get recordPaymentFailure;

  /// No description provided for @errorRecordingPayment.
  ///
  /// In en, this message translates to:
  /// **'Error recording payment: {error}'**
  String errorRecordingPayment(String error);

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @pendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Pending Payments'**
  String get pendingPayments;

  /// No description provided for @pendingPaymentsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting'**
  String pendingPaymentsWaiting(int count);

  /// No description provided for @notificationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications'**
  String notificationsCount(int count);

  /// No description provided for @paymentConfirmedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed successfully'**
  String get paymentConfirmedSuccessfully;

  /// No description provided for @transactionIdLabel.
  ///
  /// In en, this message translates to:
  /// **'TXN: {transactionId}'**
  String transactionIdLabel(String transactionId);

  /// No description provided for @rejectionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Incorrect amount, wrong transaction'**
  String get rejectionReasonHint;

  /// No description provided for @ownerNoBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Bookings'**
  String get ownerNoBookingsTitle;

  /// No description provided for @ownerNoBookingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Booking list will appear here once bookings are created'**
  String get ownerNoBookingsMessage;

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String durationDays(int count);

  /// No description provided for @rentLabel.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rentLabel;

  /// No description provided for @depositLabel.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get depositLabel;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidLabel;

  /// No description provided for @bookingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetailsTitle;

  /// No description provided for @roomBedLabel.
  ///
  /// In en, this message translates to:
  /// **'Room/Bed'**
  String get roomBedLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @remainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatusLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @noRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No requests found'**
  String get noRequestsFound;

  /// No description provided for @bookingRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get bookingRequestAction;

  /// No description provided for @bookingRequestDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Request'**
  String get bookingRequestDialogTitle;

  /// No description provided for @guestLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestLabel;

  /// No description provided for @pgLabel.
  ///
  /// In en, this message translates to:
  /// **'PG'**
  String get pgLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @unknownPg.
  ///
  /// In en, this message translates to:
  /// **'Unknown PG'**
  String get unknownPg;

  /// No description provided for @unknownValue.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownValue;

  /// No description provided for @approveBookingRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve Booking Request'**
  String get approveBookingRequestTitle;

  /// No description provided for @rejectBookingRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking Request'**
  String get rejectBookingRequestTitle;

  /// No description provided for @approveBookingRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Approve this guest\'s request to join your PG'**
  String get approveBookingRequestSubtitle;

  /// No description provided for @rejectBookingRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this guest\'s request to join your PG'**
  String get rejectBookingRequestSubtitle;

  /// No description provided for @approvalDetails.
  ///
  /// In en, this message translates to:
  /// **'Approval Details'**
  String get approvalDetails;

  /// No description provided for @rejectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Rejection Details'**
  String get rejectionDetails;

  /// No description provided for @welcomeMessageOptional.
  ///
  /// In en, this message translates to:
  /// **'Welcome Message (Optional)'**
  String get welcomeMessageOptional;

  /// No description provided for @welcomeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Add a welcome message for the guest...'**
  String get welcomeMessageHint;

  /// No description provided for @rejectionReasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Reason for Rejection (Optional)'**
  String get rejectionReasonOptional;

  /// No description provided for @rejectionReasonHintDetailed.
  ///
  /// In en, this message translates to:
  /// **'Explain why the request is being rejected...'**
  String get rejectionReasonHintDetailed;

  /// No description provided for @roomNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Number *'**
  String get roomNumberLabel;

  /// No description provided for @enterRoomNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter room number...'**
  String get enterRoomNumberHint;

  /// No description provided for @bedNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Bed Number *'**
  String get bedNumberLabel;

  /// No description provided for @enterBedNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter bed number...'**
  String get enterBedNumberHint;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDateLabel;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @approving.
  ///
  /// In en, this message translates to:
  /// **'Approving...'**
  String get approving;

  /// No description provided for @rejecting.
  ///
  /// In en, this message translates to:
  /// **'Rejecting...'**
  String get rejecting;

  /// No description provided for @approveRequest.
  ///
  /// In en, this message translates to:
  /// **'Approve Request'**
  String get approveRequest;

  /// No description provided for @rejectRequest.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get rejectRequest;

  /// No description provided for @roomBedNumbersRequired.
  ///
  /// In en, this message translates to:
  /// **'Room and bed numbers are required for approval'**
  String get roomBedNumbersRequired;

  /// No description provided for @bookingRequestApprovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking request approved successfully!'**
  String get bookingRequestApprovedSuccess;

  /// No description provided for @bookingRequestRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking request rejected successfully!'**
  String get bookingRequestRejectedSuccess;

  /// No description provided for @bookingRequestActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} request: {error}'**
  String bookingRequestActionFailed(String action, String error);

  /// No description provided for @approveAction.
  ///
  /// In en, this message translates to:
  /// **'approve'**
  String get approveAction;

  /// No description provided for @rejectAction.
  ///
  /// In en, this message translates to:
  /// **'reject'**
  String get rejectAction;

  /// No description provided for @noBedChangeRequests.
  ///
  /// In en, this message translates to:
  /// **'No Bed Change Requests'**
  String get noBedChangeRequests;

  /// No description provided for @bedChangeRequestsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Bed change requests from guests will appear here'**
  String get bedChangeRequestsEmptyBody;

  /// No description provided for @bedChangeRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Bed Change Request'**
  String get bedChangeRequestTitle;

  /// No description provided for @bedChangeStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get bedChangeStatusApproved;

  /// No description provided for @bedChangeStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get bedChangeStatusRejected;

  /// No description provided for @bedChangeStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get bedChangeStatusPending;

  /// No description provided for @bedChangeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get bedChangeCurrent;

  /// No description provided for @bedChangePreferred.
  ///
  /// In en, this message translates to:
  /// **'Preferred'**
  String get bedChangePreferred;

  /// No description provided for @bedChangeCurrentAssignment.
  ///
  /// In en, this message translates to:
  /// **'Room {room}, Bed {bed}'**
  String bedChangeCurrentAssignment(String room, String bed);

  /// No description provided for @bedChangePreferredAssignment.
  ///
  /// In en, this message translates to:
  /// **'Room {room}, Bed {bed}'**
  String bedChangePreferredAssignment(String room, String bed);

  /// No description provided for @anyLabel.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get anyLabel;

  /// No description provided for @approveBedChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve Bed Change Request'**
  String get approveBedChangeTitle;

  /// No description provided for @approveBedChangeDescription.
  ///
  /// In en, this message translates to:
  /// **'The guest will be moved to their preferred room/bed.'**
  String get approveBedChangeDescription;

  /// No description provided for @approvalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add approval notes...'**
  String get approvalNotesHint;

  /// No description provided for @rejectBedChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Bed Change Request'**
  String get rejectBedChangeTitle;

  /// No description provided for @rejectBedChangeDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for rejection.'**
  String get rejectBedChangeDescription;

  /// No description provided for @rejectionReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason *'**
  String get rejectionReasonRequired;

  /// No description provided for @bedChangeApproveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bed change approved successfully'**
  String get bedChangeApproveSuccess;

  /// No description provided for @bedChangeApproveFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve bed change'**
  String get bedChangeApproveFailure;

  /// No description provided for @bedChangeRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bed change rejected'**
  String get bedChangeRejectSuccess;

  /// No description provided for @bedChangeRejectFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject bed change'**
  String get bedChangeRejectFailure;

  /// No description provided for @decisionNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Decision Notes'**
  String get decisionNotesLabel;

  /// No description provided for @ownerBedMapNoBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Bed Occupancy Data'**
  String get ownerBedMapNoBookingsTitle;

  /// No description provided for @ownerBedMapNoBookingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Bed occupancy map will appear here once bookings are created'**
  String get ownerBedMapNoBookingsMessage;

  /// No description provided for @ownerBedMapRoom.
  ///
  /// In en, this message translates to:
  /// **'Room {roomNumber}'**
  String ownerBedMapRoom(String roomNumber);

  /// No description provided for @ownerBedMapOccupiedCount.
  ///
  /// In en, this message translates to:
  /// **'{occupied}/{total} occupied'**
  String ownerBedMapOccupiedCount(int occupied, int total);

  /// No description provided for @occupiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupiedLabel;

  /// No description provided for @ownerGuestSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, or vehicle...'**
  String get ownerGuestSearchHint;

  /// No description provided for @ownerGuestClearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get ownerGuestClearSearchTooltip;

  /// No description provided for @ownerGuestFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ownerGuestFilterAll;

  /// No description provided for @ownerGuestFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ownerGuestFilterActive;

  /// No description provided for @ownerGuestFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ownerGuestFilterPending;

  /// No description provided for @ownerGuestFilterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get ownerGuestFilterInactive;

  /// No description provided for @ownerGuestFilterVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get ownerGuestFilterVehicles;

  /// No description provided for @ownerGuestPaymentSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get ownerGuestPaymentSummaryTitle;

  /// No description provided for @ownerGuestPaymentPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ownerGuestPaymentPendingLabel;

  /// No description provided for @ownerGuestPaymentCollectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get ownerGuestPaymentCollectedLabel;

  /// No description provided for @ownerGuestDetailVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle No'**
  String get ownerGuestDetailVehicleNumber;

  /// No description provided for @ownerGuestDetailVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get ownerGuestDetailVehicle;

  /// No description provided for @ownerGuestDetailRoomBed.
  ///
  /// In en, this message translates to:
  /// **'Room/Bed'**
  String get ownerGuestDetailRoomBed;

  /// No description provided for @ownerGuestDetailRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get ownerGuestDetailRent;

  /// No description provided for @ownerGuestDetailDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get ownerGuestDetailDeposit;

  /// No description provided for @ownerGuestDetailJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get ownerGuestDetailJoined;

  /// No description provided for @ownerGuestDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ownerGuestDetailStatus;

  /// No description provided for @ownerGuestUpdateRoomBed.
  ///
  /// In en, this message translates to:
  /// **'Update Room/Bed'**
  String get ownerGuestUpdateRoomBed;

  /// No description provided for @ownerGuestUpdateRoomBedTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Room/Bed Assignment'**
  String get ownerGuestUpdateRoomBedTitle;

  /// No description provided for @ownerGuestRoomNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Number'**
  String get ownerGuestRoomNumberLabel;

  /// No description provided for @ownerGuestRoomNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter room number'**
  String get ownerGuestRoomNumberHint;

  /// No description provided for @ownerGuestBedNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Bed Number'**
  String get ownerGuestBedNumberLabel;

  /// No description provided for @ownerGuestBedNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter bed number'**
  String get ownerGuestBedNumberHint;

  /// No description provided for @ownerGuestUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get ownerGuestUpdateAction;

  /// No description provided for @ownerGuestRoomBedUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room/Bed updated successfully'**
  String get ownerGuestRoomBedUpdateSuccess;

  /// No description provided for @ownerGuestRoomBedUpdateFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to update room/bed'**
  String get ownerGuestRoomBedUpdateFailure;

  /// No description provided for @guestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest Details'**
  String get guestDetailsTitle;

  /// No description provided for @bikes.
  ///
  /// In en, this message translates to:
  /// **'Bikes'**
  String get bikes;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @ownerGuestNoPgSelectedTitle.
  ///
  /// In en, this message translates to:
  /// **'No PG Selected'**
  String get ownerGuestNoPgSelectedTitle;

  /// No description provided for @ownerGuestNoPgSelectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select a PG to manage guests'**
  String get ownerGuestNoPgSelectedMessage;

  /// No description provided for @ownerGuestFailedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load guest data'**
  String get ownerGuestFailedToLoadData;

  /// No description provided for @bookingRequestGuestNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest Name'**
  String get bookingRequestGuestNameLabel;

  /// No description provided for @bookingRequestPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get bookingRequestPhoneLabel;

  /// No description provided for @bookingRequestEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get bookingRequestEmailLabel;

  /// No description provided for @bookingRequestPgNameLabel.
  ///
  /// In en, this message translates to:
  /// **'PG Name'**
  String get bookingRequestPgNameLabel;

  /// No description provided for @bookingRequestDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Date'**
  String get bookingRequestDateLabel;

  /// No description provided for @bookingRequestStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bookingRequestStatusLabel;

  /// No description provided for @bookingRequestMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get bookingRequestMessageLabel;

  /// No description provided for @bookingRequestResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get bookingRequestResponseLabel;

  /// No description provided for @offlineSyncingActions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No actions to sync} one{Syncing 1 action...} other{Syncing {count} actions...}}'**
  String offlineSyncingActions(int count);

  /// No description provided for @offlineStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get offlineStatusOffline;

  /// No description provided for @offlineStatusOfflineShort.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineStatusOfflineShort;

  /// No description provided for @offlineTapToSync.
  ///
  /// In en, this message translates to:
  /// **'Tap to sync'**
  String get offlineTapToSync;

  /// No description provided for @offlineSyncQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Queue'**
  String get offlineSyncQueueTitle;

  /// No description provided for @offlineNoPendingActions.
  ///
  /// In en, this message translates to:
  /// **'No pending actions to sync'**
  String get offlineNoPendingActions;

  /// No description provided for @offlinePendingActions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} action pending sync:} other{{count} actions pending sync:}}'**
  String offlinePendingActions(int count);

  /// No description provided for @offlineSyncAll.
  ///
  /// In en, this message translates to:
  /// **'Sync All'**
  String get offlineSyncAll;

  /// No description provided for @offlineSyncCompleted.
  ///
  /// In en, this message translates to:
  /// **'Sync completed successfully!'**
  String get offlineSyncCompleted;

  /// No description provided for @offlineSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String offlineSyncFailed(String error);

  /// No description provided for @offlineSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get offlineSyncNow;

  /// No description provided for @guestBookingProcessedDefault.
  ///
  /// In en, this message translates to:
  /// **'Your booking request has been processed'**
  String get guestBookingProcessedDefault;

  /// No description provided for @guestPaymentReminder.
  ///
  /// In en, this message translates to:
  /// **'Payment reminder: Please complete your pending payment'**
  String get guestPaymentReminder;

  /// No description provided for @guestFoodMenuUpdated.
  ///
  /// In en, this message translates to:
  /// **'Food menu has been updated! Check out the new items'**
  String get guestFoodMenuUpdated;

  /// No description provided for @guestComplaintResponseMessage.
  ///
  /// In en, this message translates to:
  /// **'Complaint Response: {response}'**
  String guestComplaintResponseMessage(String response);

  /// No description provided for @guestComplaintResponseDefault.
  ///
  /// In en, this message translates to:
  /// **'Your complaint has been addressed'**
  String get guestComplaintResponseDefault;

  /// No description provided for @guestAnnouncementDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get guestAnnouncementDefaultTitle;

  /// No description provided for @guestAnnouncementDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Important announcement from your PG'**
  String get guestAnnouncementDefaultMessage;

  /// No description provided for @notificationGuestFallbackName.
  ///
  /// In en, this message translates to:
  /// **'A guest'**
  String get notificationGuestFallbackName;

  /// No description provided for @ownerBookingRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'New booking request from {guestName}'**
  String ownerBookingRequestMessage(String guestName);

  /// No description provided for @viewAction.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewAction;

  /// No description provided for @ownerPaymentReceivedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment received: ₹{amount} from {guestName}'**
  String ownerPaymentReceivedMessage(String amount, String guestName);

  /// No description provided for @ownerComplaintSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'New complaint from {guestName}'**
  String ownerComplaintSubmittedMessage(String guestName);

  /// No description provided for @ownerGuestCheckInMessage.
  ///
  /// In en, this message translates to:
  /// **'{guestName} has checked in'**
  String ownerGuestCheckInMessage(String guestName);

  /// No description provided for @ownerMaintenanceTaskFallback.
  ///
  /// In en, this message translates to:
  /// **'maintenance task'**
  String get ownerMaintenanceTaskFallback;

  /// No description provided for @ownerMaintenanceReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Maintenance reminder: {task}'**
  String ownerMaintenanceReminderMessage(String task);

  /// No description provided for @analyticsRefreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh data'**
  String get analyticsRefreshData;

  /// No description provided for @revenueAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue Analytics'**
  String get revenueAnalyticsTitle;

  /// No description provided for @revenueAnalyticsSelectedPg.
  ///
  /// In en, this message translates to:
  /// **'Performance insights for selected PG'**
  String get revenueAnalyticsSelectedPg;

  /// No description provided for @revenueAnalyticsOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall revenue performance'**
  String get revenueAnalyticsOverall;

  /// No description provided for @revenueMetricTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get revenueMetricTotalRevenue;

  /// No description provided for @revenueMetricMonthlyGrowth.
  ///
  /// In en, this message translates to:
  /// **'Monthly Growth'**
  String get revenueMetricMonthlyGrowth;

  /// No description provided for @revenueMetricAvgPerGuest.
  ///
  /// In en, this message translates to:
  /// **'Avg. per Guest'**
  String get revenueMetricAvgPerGuest;

  /// No description provided for @analyticsPeriodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get analyticsPeriodWeekly;

  /// No description provided for @analyticsPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get analyticsPeriodMonthly;

  /// No description provided for @analyticsPeriodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get analyticsPeriodYearly;

  /// No description provided for @analyticsMetricRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get analyticsMetricRevenue;

  /// No description provided for @analyticsMetricOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get analyticsMetricOccupancy;

  /// No description provided for @analyticsMetricGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get analyticsMetricGuests;

  /// No description provided for @revenueTrendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trends'**
  String get revenueTrendsLabel;

  /// No description provided for @revenueTrendLastMonths.
  ///
  /// In en, this message translates to:
  /// **'Revenue trend (last {months} months)'**
  String revenueTrendLastMonths(int months);

  /// No description provided for @revenueForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue Forecast'**
  String get revenueForecastTitle;

  /// No description provided for @revenueForecastNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next Month'**
  String get revenueForecastNextMonth;

  /// No description provided for @revenueForecastNextQuarter.
  ///
  /// In en, this message translates to:
  /// **'Next Quarter'**
  String get revenueForecastNextQuarter;

  /// No description provided for @revenueForecastInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Forecast Insights'**
  String get revenueForecastInsightsTitle;

  /// No description provided for @revenueForecastInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Insufficient data for forecasting'**
  String get revenueForecastInsufficientData;

  /// No description provided for @revenueForecastPositive.
  ///
  /// In en, this message translates to:
  /// **'Based on recent trends, revenue is showing positive growth. Consider expanding capacity.'**
  String get revenueForecastPositive;

  /// No description provided for @revenueForecastDecline.
  ///
  /// In en, this message translates to:
  /// **'Based on recent trends, revenue is declining. Review pricing and marketing strategies.'**
  String get revenueForecastDecline;

  /// No description provided for @revenueForecastStable.
  ///
  /// In en, this message translates to:
  /// **'Based on recent trends, revenue is stable. Focus on maintaining current performance.'**
  String get revenueForecastStable;

  /// No description provided for @menuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTooltip;

  /// No description provided for @analyticsTabRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get analyticsTabRevenue;

  /// No description provided for @analyticsTabOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get analyticsTabOccupancy;

  /// No description provided for @analyticsTabPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get analyticsTabPerformance;

  /// No description provided for @analyticsNoPgTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a PG'**
  String get analyticsNoPgTitle;

  /// No description provided for @analyticsNoPgMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a PG from the dropdown above to view analytics'**
  String get analyticsNoPgMessage;

  /// No description provided for @analyticsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading analytics data...'**
  String get analyticsLoading;

  /// No description provided for @analyticsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Data'**
  String get analyticsErrorTitle;

  /// No description provided for @analyticsUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get analyticsUnknownError;

  /// No description provided for @analyticsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load analytics data: {error}'**
  String analyticsLoadFailed(String error);

  /// No description provided for @performanceAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Analytics'**
  String get performanceAnalyticsTitle;

  /// No description provided for @performanceAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive performance insights and recommendations'**
  String get performanceAnalyticsSubtitle;

  /// No description provided for @performanceKpiTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
  String get performanceKpiTitle;

  /// No description provided for @performanceKpiGuestSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Guest Satisfaction'**
  String get performanceKpiGuestSatisfaction;

  /// No description provided for @performanceKpiGuestSatisfactionValue.
  ///
  /// In en, this message translates to:
  /// **'{score}/5'**
  String performanceKpiGuestSatisfactionValue(String score);

  /// No description provided for @performanceKpiResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get performanceKpiResponseTime;

  /// No description provided for @performanceKpiResponseTimeValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} hrs'**
  String performanceKpiResponseTimeValue(String hours);

  /// No description provided for @performanceKpiMaintenanceScore.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Score'**
  String get performanceKpiMaintenanceScore;

  /// No description provided for @performanceKpiMaintenanceScoreValue.
  ///
  /// In en, this message translates to:
  /// **'{score}/10'**
  String performanceKpiMaintenanceScoreValue(String score);

  /// No description provided for @performanceInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Insights'**
  String get performanceInsightsTitle;

  /// No description provided for @performanceInsightsOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall Performance: Excellent'**
  String get performanceInsightsOverall;

  /// No description provided for @performanceInsightsSummary.
  ///
  /// In en, this message translates to:
  /// **'Your PG is performing above industry standards with high guest satisfaction and efficient operations.'**
  String get performanceInsightsSummary;

  /// No description provided for @performanceRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations:'**
  String get performanceRecommendationsTitle;

  /// No description provided for @performanceRecommendationMaintainSchedule.
  ///
  /// In en, this message translates to:
  /// **'Continue current maintenance schedule'**
  String get performanceRecommendationMaintainSchedule;

  /// No description provided for @performanceRecommendationExpandCapacity.
  ///
  /// In en, this message translates to:
  /// **'Consider expanding based on high occupancy'**
  String get performanceRecommendationExpandCapacity;

  /// No description provided for @performanceRecommendationFeedbackSystem.
  ///
  /// In en, this message translates to:
  /// **'Implement guest feedback system'**
  String get performanceRecommendationFeedbackSystem;

  /// No description provided for @performanceRecommendationOptimizeEnergy.
  ///
  /// In en, this message translates to:
  /// **'Optimize energy usage for cost savings'**
  String get performanceRecommendationOptimizeEnergy;

  /// No description provided for @occupancyAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Analytics'**
  String get occupancyAnalyticsTitle;

  /// No description provided for @occupancyAnalyticsSelectedPg.
  ///
  /// In en, this message translates to:
  /// **'Occupancy insights for selected PG'**
  String get occupancyAnalyticsSelectedPg;

  /// No description provided for @occupancyAnalyticsOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall occupancy performance'**
  String get occupancyAnalyticsOverall;

  /// No description provided for @occupancyMetricCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Occupancy'**
  String get occupancyMetricCurrent;

  /// No description provided for @occupancyMetricAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg. Occupancy'**
  String get occupancyMetricAverage;

  /// No description provided for @occupancyMetricPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak Occupancy'**
  String get occupancyMetricPeak;

  /// No description provided for @occupancyTrendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Trends'**
  String get occupancyTrendsLabel;

  /// No description provided for @occupancyViewOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get occupancyViewOverview;

  /// No description provided for @occupancyViewByRoom.
  ///
  /// In en, this message translates to:
  /// **'By Room'**
  String get occupancyViewByRoom;

  /// No description provided for @occupancyViewByFloor.
  ///
  /// In en, this message translates to:
  /// **'By Floor'**
  String get occupancyViewByFloor;

  /// No description provided for @occupancyTrendLastMonths.
  ///
  /// In en, this message translates to:
  /// **'Occupancy trend (last {months} months)'**
  String occupancyTrendLastMonths(int months);

  /// No description provided for @occupancyCapacityTitle.
  ///
  /// In en, this message translates to:
  /// **'Capacity Analysis'**
  String get occupancyCapacityTitle;

  /// No description provided for @occupancyCapacityAvailableBeds.
  ///
  /// In en, this message translates to:
  /// **'Available Beds'**
  String get occupancyCapacityAvailableBeds;

  /// No description provided for @occupancyCapacityOccupiedBeds.
  ///
  /// In en, this message translates to:
  /// **'Occupied Beds'**
  String get occupancyCapacityOccupiedBeds;

  /// No description provided for @occupancyCapacityTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Capacity'**
  String get occupancyCapacityTotal;

  /// No description provided for @occupancyInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Insights'**
  String get occupancyInsightsTitle;

  /// No description provided for @occupancyRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations:'**
  String get occupancyRecommendationsTitle;

  /// No description provided for @occupancyInsightsCurrentRate.
  ///
  /// In en, this message translates to:
  /// **'Current occupancy is at {rate}.'**
  String occupancyInsightsCurrentRate(String rate);

  /// No description provided for @occupancyInsightsNearFull.
  ///
  /// In en, this message translates to:
  /// **'Your PG is nearly at full capacity. Consider expanding or opening new rooms.'**
  String get occupancyInsightsNearFull;

  /// No description provided for @occupancyInsightsGood.
  ///
  /// In en, this message translates to:
  /// **'Good occupancy rate. Monitor trends and consider marketing strategies.'**
  String get occupancyInsightsGood;

  /// No description provided for @occupancyInsightsModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate occupancy. There\'s room for improvement through better marketing.'**
  String get occupancyInsightsModerate;

  /// No description provided for @occupancyInsightsLow.
  ///
  /// In en, this message translates to:
  /// **'Low occupancy rate. Immediate action needed to improve bookings.'**
  String get occupancyInsightsLow;

  /// No description provided for @occupancyRecommendationAddCapacity.
  ///
  /// In en, this message translates to:
  /// **'Consider adding more beds or rooms'**
  String get occupancyRecommendationAddCapacity;

  /// No description provided for @occupancyRecommendationReviewPricing.
  ///
  /// In en, this message translates to:
  /// **'Review pricing strategy for high demand'**
  String get occupancyRecommendationReviewPricing;

  /// No description provided for @occupancyRecommendationMaintainOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Focus on maintaining current occupancy'**
  String get occupancyRecommendationMaintainOccupancy;

  /// No description provided for @occupancyRecommendationSeasonalPricing.
  ///
  /// In en, this message translates to:
  /// **'Consider seasonal pricing adjustments'**
  String get occupancyRecommendationSeasonalPricing;

  /// No description provided for @occupancyRecommendationIncreaseMarketing.
  ///
  /// In en, this message translates to:
  /// **'Increase marketing efforts'**
  String get occupancyRecommendationIncreaseMarketing;

  /// No description provided for @occupancyRecommendationImproveAmenities.
  ///
  /// In en, this message translates to:
  /// **'Review and improve amenities'**
  String get occupancyRecommendationImproveAmenities;

  /// No description provided for @occupancyRecommendationCompetitivePricing.
  ///
  /// In en, this message translates to:
  /// **'Consider competitive pricing'**
  String get occupancyRecommendationCompetitivePricing;

  /// No description provided for @occupancyRecommendationUrgentCampaign.
  ///
  /// In en, this message translates to:
  /// **'Urgent marketing campaign needed'**
  String get occupancyRecommendationUrgentCampaign;

  /// No description provided for @occupancyRecommendationReducePricing.
  ///
  /// In en, this message translates to:
  /// **'Review and reduce pricing'**
  String get occupancyRecommendationReducePricing;

  /// No description provided for @occupancyRecommendationImproveFacilities.
  ///
  /// In en, this message translates to:
  /// **'Improve facilities and amenities'**
  String get occupancyRecommendationImproveFacilities;

  /// No description provided for @occupancyRecommendationPartnerships.
  ///
  /// In en, this message translates to:
  /// **'Consider partnerships with local businesses'**
  String get occupancyRecommendationPartnerships;

  /// No description provided for @pgBasicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get pgBasicInfoTitle;

  /// No description provided for @pgBasicInfoAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete Address'**
  String get pgBasicInfoAddressLabel;

  /// No description provided for @pgBasicInfoAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Full address with landmark'**
  String get pgBasicInfoAddressHint;

  /// No description provided for @pgBasicInfoPgNameLabel.
  ///
  /// In en, this message translates to:
  /// **'PG Name'**
  String get pgBasicInfoPgNameLabel;

  /// No description provided for @pgBasicInfoPgNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Green Meadows PG'**
  String get pgBasicInfoPgNameHint;

  /// No description provided for @pgBasicInfoContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get pgBasicInfoContactLabel;

  /// No description provided for @pgBasicInfoContactHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., +91 9876543210'**
  String get pgBasicInfoContactHint;

  /// No description provided for @pgBasicInfoStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get pgBasicInfoStateLabel;

  /// No description provided for @pgBasicInfoStateHint.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get pgBasicInfoStateHint;

  /// No description provided for @pgBasicInfoCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get pgBasicInfoCityLabel;

  /// No description provided for @pgBasicInfoCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get pgBasicInfoCityHint;

  /// No description provided for @pgBasicInfoAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get pgBasicInfoAreaLabel;

  /// No description provided for @pgBasicInfoAreaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Sector 5, HSR Layout'**
  String get pgBasicInfoAreaHint;

  /// No description provided for @pgBasicInfoPgTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'PG Type'**
  String get pgBasicInfoPgTypeLabel;

  /// No description provided for @pgBasicInfoPgTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select PG Type'**
  String get pgBasicInfoPgTypeHint;

  /// No description provided for @pgBasicInfoPgTypeBoys.
  ///
  /// In en, this message translates to:
  /// **'Boys'**
  String get pgBasicInfoPgTypeBoys;

  /// No description provided for @pgBasicInfoPgTypeGirls.
  ///
  /// In en, this message translates to:
  /// **'Girls'**
  String get pgBasicInfoPgTypeGirls;

  /// No description provided for @pgBasicInfoPgTypeCoed.
  ///
  /// In en, this message translates to:
  /// **'Co-ed'**
  String get pgBasicInfoPgTypeCoed;

  /// No description provided for @pgBasicInfoMealTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal Type'**
  String get pgBasicInfoMealTypeLabel;

  /// No description provided for @pgBasicInfoMealTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select Meal Type'**
  String get pgBasicInfoMealTypeHint;

  /// No description provided for @pgBasicInfoMealTypeVeg.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get pgBasicInfoMealTypeVeg;

  /// No description provided for @pgBasicInfoMealTypeNonVeg.
  ///
  /// In en, this message translates to:
  /// **'Non-Vegetarian'**
  String get pgBasicInfoMealTypeNonVeg;

  /// No description provided for @pgBasicInfoMealTypeBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get pgBasicInfoMealTypeBoth;

  /// No description provided for @pgBasicInfoFoodSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Food & Meal Details'**
  String get pgBasicInfoFoodSectionTitle;

  /// No description provided for @pgBasicInfoMealTimingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal Timings'**
  String get pgBasicInfoMealTimingsLabel;

  /// No description provided for @pgBasicInfoMealTimingsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Breakfast: 8:00 AM - 10:00 AM, Lunch: 1:00 PM - 2:00 PM, Dinner: 8:00 PM - 9:30 PM'**
  String get pgBasicInfoMealTimingsHint;

  /// No description provided for @pgBasicInfoFoodQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Quality Description'**
  String get pgBasicInfoFoodQualityLabel;

  /// No description provided for @pgBasicInfoFoodQualityHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the food quality, cuisine type, specialities, etc.'**
  String get pgBasicInfoFoodQualityHint;

  /// No description provided for @pgBasicInfoDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get pgBasicInfoDescriptionLabel;

  /// No description provided for @pgBasicInfoDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your PG'**
  String get pgBasicInfoDescriptionHint;

  /// No description provided for @pgFloorStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'🏢 Floor Structure'**
  String get pgFloorStructureTitle;

  /// No description provided for @pgFloorCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of Regular Floors'**
  String get pgFloorCountLabel;

  /// No description provided for @pgFloorCountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1'**
  String get pgFloorCountHint;

  /// No description provided for @generateAction.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateAction;

  /// No description provided for @pgFloorGroundLabel.
  ///
  /// In en, this message translates to:
  /// **'Ground'**
  String get pgFloorGroundLabel;

  /// No description provided for @pgFloorTerraceLabel.
  ///
  /// In en, this message translates to:
  /// **'Terrace'**
  String get pgFloorTerraceLabel;

  /// No description provided for @pgFloorFirstLabel.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get pgFloorFirstLabel;

  /// No description provided for @pgFloorSecondLabel.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get pgFloorSecondLabel;

  /// No description provided for @pgFloorThirdLabel.
  ///
  /// In en, this message translates to:
  /// **'Third'**
  String get pgFloorThirdLabel;

  /// No description provided for @pgFloorFourthLabel.
  ///
  /// In en, this message translates to:
  /// **'Fourth'**
  String get pgFloorFourthLabel;

  /// No description provided for @pgFloorFifthLabel.
  ///
  /// In en, this message translates to:
  /// **'Fifth'**
  String get pgFloorFifthLabel;

  /// No description provided for @pgFloorNthLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor {number}'**
  String pgFloorNthLabel(int number);

  /// No description provided for @pgFloorRoomsBedsSummary.
  ///
  /// In en, this message translates to:
  /// **'{rooms} rooms • {beds} beds'**
  String pgFloorRoomsBedsSummary(int rooms, int beds);

  /// No description provided for @pgFloorAddRoom.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get pgFloorAddRoom;

  /// No description provided for @pgFloorCapacityOption.
  ///
  /// In en, this message translates to:
  /// **'{capacity}-share'**
  String pgFloorCapacityOption(int capacity);

  /// No description provided for @pgFloorBedLabel.
  ///
  /// In en, this message translates to:
  /// **'Bed-{index}'**
  String pgFloorBedLabel(int index);

  /// No description provided for @pgFloorRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room {roomNumber}'**
  String pgFloorRoomLabel(String roomNumber);

  /// No description provided for @pgFloorBedsList.
  ///
  /// In en, this message translates to:
  /// **'Beds: {bedList}'**
  String pgFloorBedsList(String bedList);

  /// No description provided for @pgFloorNoRoomsMessage.
  ///
  /// In en, this message translates to:
  /// **'No rooms added yet. Click \"Add Room\" to get started.'**
  String get pgFloorNoRoomsMessage;

  /// No description provided for @pgFloorEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Floors Generated'**
  String get pgFloorEmptyTitle;

  /// No description provided for @pgFloorEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of floors and click \"Generate\" to create your floor structure.'**
  String get pgFloorEmptyMessage;

  /// No description provided for @pgRentConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Rent Configuration'**
  String get pgRentConfigTitle;

  /// No description provided for @pgRentConfigSharingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rent ({sharing})'**
  String pgRentConfigSharingLabel(String sharing);

  /// No description provided for @pgRentConfigRentLabel.
  ///
  /// In en, this message translates to:
  /// **'Rent for {sharing} (₹)'**
  String pgRentConfigRentLabel(String sharing);

  /// No description provided for @pgRentConfigRentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 8000'**
  String get pgRentConfigRentHint;

  /// No description provided for @pgRentConfigDepositLabel.
  ///
  /// In en, this message translates to:
  /// **'Security Deposit (₹)'**
  String get pgRentConfigDepositLabel;

  /// No description provided for @pgRentConfigDepositHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 10000'**
  String get pgRentConfigDepositHint;

  /// No description provided for @pgRentConfigMaintenanceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Type'**
  String get pgRentConfigMaintenanceTypeLabel;

  /// No description provided for @pgRentConfigMaintenanceOneTime.
  ///
  /// In en, this message translates to:
  /// **'One Time'**
  String get pgRentConfigMaintenanceOneTime;

  /// No description provided for @pgRentConfigMaintenanceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get pgRentConfigMaintenanceMonthly;

  /// No description provided for @pgRentConfigMaintenanceQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get pgRentConfigMaintenanceQuarterly;

  /// No description provided for @pgRentConfigMaintenanceYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get pgRentConfigMaintenanceYearly;

  /// No description provided for @pgRentConfigMaintenanceAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Amount (₹)'**
  String get pgRentConfigMaintenanceAmountLabel;

  /// No description provided for @pgRentConfigMaintenanceAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 500'**
  String get pgRentConfigMaintenanceAmountHint;

  /// No description provided for @pgRentConfigRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposit Refund Policy:'**
  String get pgRentConfigRefundTitle;

  /// No description provided for @pgRentConfigRefundFull.
  ///
  /// In en, this message translates to:
  /// **'• Full refund if notice ≥ 30 days'**
  String get pgRentConfigRefundFull;

  /// No description provided for @pgRentConfigRefundPartial.
  ///
  /// In en, this message translates to:
  /// **'• 50% refund if notice ≥ 15 days'**
  String get pgRentConfigRefundPartial;

  /// No description provided for @pgRentConfigRefundNone.
  ///
  /// In en, this message translates to:
  /// **'• No refund if notice < 15 days'**
  String get pgRentConfigRefundNone;

  /// No description provided for @pgRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules & Policies'**
  String get pgRulesTitle;

  /// No description provided for @pgRulesEntryTimingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Entry Timings'**
  String get pgRulesEntryTimingsLabel;

  /// No description provided for @pgRulesExitTimingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Exit Timings'**
  String get pgRulesExitTimingsLabel;

  /// No description provided for @pgRulesTimingsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 6:00 AM - 11:00 PM'**
  String get pgRulesTimingsHint;

  /// No description provided for @pgRulesSmokingPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Smoking Policy'**
  String get pgRulesSmokingPolicyLabel;

  /// No description provided for @pgRulesAlcoholPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Alcohol Policy'**
  String get pgRulesAlcoholPolicyLabel;

  /// No description provided for @pgRulesPolicyHint.
  ///
  /// In en, this message translates to:
  /// **'Select Policy'**
  String get pgRulesPolicyHint;

  /// No description provided for @pgRulesPolicyNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Not Allowed'**
  String get pgRulesPolicyNotAllowed;

  /// No description provided for @pgRulesPolicyAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get pgRulesPolicyAllowed;

  /// No description provided for @pgRulesPolicyDesignatedAreas.
  ///
  /// In en, this message translates to:
  /// **'Designated Areas Only'**
  String get pgRulesPolicyDesignatedAreas;

  /// No description provided for @pgRulesNoticePeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Notice Period (Days)'**
  String get pgRulesNoticePeriodLabel;

  /// No description provided for @pgRulesNoticePeriodHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 30'**
  String get pgRulesNoticePeriodHint;

  /// No description provided for @pgRulesGuestPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest Policy'**
  String get pgRulesGuestPolicyLabel;

  /// No description provided for @pgRulesGuestPolicyHint.
  ///
  /// In en, this message translates to:
  /// **'Rules regarding guests, visitors, overnight stays, etc.'**
  String get pgRulesGuestPolicyHint;

  /// No description provided for @pgRulesRefundPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get pgRulesRefundPolicyLabel;

  /// No description provided for @pgRulesRefundPolicyHint.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions for refunds, deposits, cancellations, etc.'**
  String get pgRulesRefundPolicyHint;

  /// No description provided for @pgPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos & Gallery'**
  String get pgPhotosTitle;

  /// No description provided for @pgPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your PG to attract more guests:'**
  String get pgPhotosSubtitle;

  /// No description provided for @pgPhotosAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get pgPhotosAddButton;

  /// No description provided for @pgPhotosLimitHint.
  ///
  /// In en, this message translates to:
  /// **'You can select multiple images at once (up to 10)'**
  String get pgPhotosLimitHint;

  /// No description provided for @pgPhotosUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {count} photos successfully!'**
  String pgPhotosUploadSuccess(int count);

  /// No description provided for @pgPhotosUploadPartial.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {success} photos, {failed} failed.'**
  String pgPhotosUploadPartial(int success, int failed);

  /// No description provided for @pgPhotosUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photos'**
  String get pgPhotosUploadFailed;

  /// No description provided for @pgPhotosEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No photos added yet'**
  String get pgPhotosEmptyTitle;

  /// No description provided for @pgPhotosEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click \"Add Photos\" to upload images'**
  String get pgPhotosEmptySubtitle;

  /// No description provided for @pgPhotosRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get pgPhotosRemoveAction;

  /// No description provided for @pgAdditionalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get pgAdditionalInfoTitle;

  /// No description provided for @pgAdditionalInfoParkingLabel.
  ///
  /// In en, this message translates to:
  /// **'Parking Details'**
  String get pgAdditionalInfoParkingLabel;

  /// No description provided for @pgAdditionalInfoParkingHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2-wheeler parking available, 4-wheeler parking: ₹500/month, Capacity: 20 bikes'**
  String get pgAdditionalInfoParkingHint;

  /// No description provided for @pgAdditionalInfoSecurityLabel.
  ///
  /// In en, this message translates to:
  /// **'Security Measures'**
  String get pgAdditionalInfoSecurityLabel;

  /// No description provided for @pgAdditionalInfoSecurityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 24/7 Security guard, CCTV surveillance, Biometric access, Fire safety equipment'**
  String get pgAdditionalInfoSecurityHint;

  /// No description provided for @pgAdditionalInfoNearbyPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get pgAdditionalInfoNearbyPlacesTitle;

  /// No description provided for @pgAdditionalInfoNearbyPlacesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add nearby landmarks, locations, or points of interest'**
  String get pgAdditionalInfoNearbyPlacesDescription;

  /// No description provided for @pgAdditionalInfoNearbyPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Nearby Place'**
  String get pgAdditionalInfoNearbyPlaceLabel;

  /// No description provided for @pgAdditionalInfoNearbyPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Metro Station, Shopping Mall, Hospital'**
  String get pgAdditionalInfoNearbyPlaceHint;

  /// No description provided for @pgAdditionalInfoAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get pgAdditionalInfoAddButton;

  /// No description provided for @pgAdditionalInfoPaymentInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Instructions'**
  String get pgAdditionalInfoPaymentInstructionsLabel;

  /// No description provided for @pgAdditionalInfoPaymentInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Instructions for making payments, accepted payment methods, payment schedule, etc.'**
  String get pgAdditionalInfoPaymentInstructionsHint;

  /// No description provided for @pgAmenitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Amenities & Facilities'**
  String get pgAmenitiesTitle;

  /// No description provided for @pgAmenitiesDescription.
  ///
  /// In en, this message translates to:
  /// **'Select all amenities available in your PG:'**
  String get pgAmenitiesDescription;

  /// No description provided for @pgAmenitiesSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get pgAmenitiesSelectedLabel;

  /// No description provided for @pgAmenityWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get pgAmenityWifi;

  /// No description provided for @pgAmenityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get pgAmenityParking;

  /// No description provided for @pgAmenitySecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get pgAmenitySecurity;

  /// No description provided for @pgAmenityCctv.
  ///
  /// In en, this message translates to:
  /// **'CCTV'**
  String get pgAmenityCctv;

  /// No description provided for @pgAmenityLaundry.
  ///
  /// In en, this message translates to:
  /// **'Laundry'**
  String get pgAmenityLaundry;

  /// No description provided for @pgAmenityKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get pgAmenityKitchen;

  /// No description provided for @pgAmenityAc.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get pgAmenityAc;

  /// No description provided for @pgAmenityGeyser.
  ///
  /// In en, this message translates to:
  /// **'Geyser'**
  String get pgAmenityGeyser;

  /// No description provided for @pgAmenityTv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get pgAmenityTv;

  /// No description provided for @pgAmenityRefrigerator.
  ///
  /// In en, this message translates to:
  /// **'Refrigerator'**
  String get pgAmenityRefrigerator;

  /// No description provided for @pgAmenityPowerBackup.
  ///
  /// In en, this message translates to:
  /// **'Power Backup'**
  String get pgAmenityPowerBackup;

  /// No description provided for @pgAmenityGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get pgAmenityGym;

  /// No description provided for @pgAmenityCurtains.
  ///
  /// In en, this message translates to:
  /// **'Curtains'**
  String get pgAmenityCurtains;

  /// No description provided for @pgAmenityBucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket'**
  String get pgAmenityBucket;

  /// No description provided for @pgAmenityWaterCooler.
  ///
  /// In en, this message translates to:
  /// **'Water Cooler'**
  String get pgAmenityWaterCooler;

  /// No description provided for @pgAmenityWashingMachine.
  ///
  /// In en, this message translates to:
  /// **'Washing Machine'**
  String get pgAmenityWashingMachine;

  /// No description provided for @pgAmenityMicrowave.
  ///
  /// In en, this message translates to:
  /// **'Microwave'**
  String get pgAmenityMicrowave;

  /// No description provided for @pgAmenityLift.
  ///
  /// In en, this message translates to:
  /// **'Lift'**
  String get pgAmenityLift;

  /// No description provided for @pgAmenityHousekeeping.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping'**
  String get pgAmenityHousekeeping;

  /// No description provided for @pgAmenityAttachedBathroom.
  ///
  /// In en, this message translates to:
  /// **'Attached Bathroom'**
  String get pgAmenityAttachedBathroom;

  /// No description provided for @pgAmenityRoWater.
  ///
  /// In en, this message translates to:
  /// **'RO Water'**
  String get pgAmenityRoWater;

  /// No description provided for @pgAmenityWaterSupply.
  ///
  /// In en, this message translates to:
  /// **'24x7 Water Supply'**
  String get pgAmenityWaterSupply;

  /// No description provided for @pgAmenityBedWithMattress.
  ///
  /// In en, this message translates to:
  /// **'Bed with Mattress'**
  String get pgAmenityBedWithMattress;

  /// No description provided for @pgAmenityWardrobe.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get pgAmenityWardrobe;

  /// No description provided for @pgAmenityStudyTable.
  ///
  /// In en, this message translates to:
  /// **'Study Table'**
  String get pgAmenityStudyTable;

  /// No description provided for @pgAmenityChair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get pgAmenityChair;

  /// No description provided for @pgAmenityFan.
  ///
  /// In en, this message translates to:
  /// **'Fan'**
  String get pgAmenityFan;

  /// No description provided for @pgAmenityLighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get pgAmenityLighting;

  /// No description provided for @pgAmenityBalcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get pgAmenityBalcony;

  /// No description provided for @pgAmenityCommonArea.
  ///
  /// In en, this message translates to:
  /// **'Common Area'**
  String get pgAmenityCommonArea;

  /// No description provided for @pgAmenityDiningArea.
  ///
  /// In en, this message translates to:
  /// **'Dining Area'**
  String get pgAmenityDiningArea;

  /// No description provided for @pgAmenityInductionStove.
  ///
  /// In en, this message translates to:
  /// **'Induction Stove'**
  String get pgAmenityInductionStove;

  /// No description provided for @pgAmenityCookingAllowed.
  ///
  /// In en, this message translates to:
  /// **'Cooking Allowed'**
  String get pgAmenityCookingAllowed;

  /// No description provided for @pgAmenityFireExtinguisher.
  ///
  /// In en, this message translates to:
  /// **'Fire Extinguisher'**
  String get pgAmenityFireExtinguisher;

  /// No description provided for @pgAmenityFirstAidKit.
  ///
  /// In en, this message translates to:
  /// **'First Aid Kit'**
  String get pgAmenityFirstAidKit;

  /// No description provided for @pgAmenitySmokeDetector.
  ///
  /// In en, this message translates to:
  /// **'Smoke Detector'**
  String get pgAmenitySmokeDetector;

  /// No description provided for @pgAmenityVisitorParking.
  ///
  /// In en, this message translates to:
  /// **'Visitor Parking'**
  String get pgAmenityVisitorParking;

  /// No description provided for @pgAmenityIntercom.
  ///
  /// In en, this message translates to:
  /// **'Intercom'**
  String get pgAmenityIntercom;

  /// No description provided for @pgAmenityMaintenanceStaff.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Staff'**
  String get pgAmenityMaintenanceStaff;

  /// No description provided for @pgSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'PG Summary'**
  String get pgSummaryTitle;

  /// No description provided for @pgSummaryBasicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get pgSummaryBasicInfoTitle;

  /// No description provided for @pgSummaryRentInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Rent Information'**
  String get pgSummaryRentInfoTitle;

  /// No description provided for @pgSummaryPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get pgSummaryPhotosTitle;

  /// No description provided for @pgSummaryActionCreate.
  ///
  /// In en, this message translates to:
  /// **'create'**
  String get pgSummaryActionCreate;

  /// No description provided for @pgSummaryActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'update'**
  String get pgSummaryActionUpdate;

  /// No description provided for @pgSummaryReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Ready to {action} your PG!'**
  String pgSummaryReadyMessage(String action);

  /// No description provided for @pgSummaryReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Review all details above and click the save button to proceed.'**
  String get pgSummaryReviewMessage;

  /// No description provided for @pgSummaryNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get pgSummaryNotSpecified;

  /// No description provided for @pgSummaryLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get pgSummaryLocationLabel;

  /// No description provided for @pgSummaryLocationValue.
  ///
  /// In en, this message translates to:
  /// **'{city}, {state}'**
  String pgSummaryLocationValue(String city, String state);

  /// No description provided for @pgSummaryTotalFloorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Floors'**
  String get pgSummaryTotalFloorsLabel;

  /// No description provided for @pgSummaryTotalRoomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Rooms'**
  String get pgSummaryTotalRoomsLabel;

  /// No description provided for @pgSummaryTotalBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Beds'**
  String get pgSummaryTotalBedsLabel;

  /// No description provided for @pgSummaryEstimatedRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Monthly Revenue'**
  String get pgSummaryEstimatedRevenueLabel;

  /// No description provided for @pgSummaryMaintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get pgSummaryMaintenanceLabel;

  /// No description provided for @pgSummarySelectedAmenitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Amenities'**
  String get pgSummarySelectedAmenitiesLabel;

  /// No description provided for @pgSummaryListLabel.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get pgSummaryListLabel;

  /// No description provided for @pgSummaryUploadedPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Photos'**
  String get pgSummaryUploadedPhotosLabel;

  /// No description provided for @pgInfoNoPgSelected.
  ///
  /// In en, this message translates to:
  /// **'No PG selected'**
  String get pgInfoNoPgSelected;

  /// No description provided for @pgInfoSelectPgPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select a PG from the dropdown above'**
  String get pgInfoSelectPgPrompt;

  /// No description provided for @pgInfoEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit PG details'**
  String get pgInfoEditTooltip;

  /// No description provided for @pgInfoContactNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get pgInfoContactNotProvided;

  /// No description provided for @pgInfoPgTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'PG'**
  String get pgInfoPgTypeFallback;

  /// No description provided for @pgInfoLocationFallback.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get pgInfoLocationFallback;

  /// No description provided for @pgInfoStructureOverview.
  ///
  /// In en, this message translates to:
  /// **'PG Structure Overview'**
  String get pgInfoStructureOverview;

  /// No description provided for @pgInfoFloorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get pgInfoFloorsLabel;

  /// No description provided for @pgInfoRoomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get pgInfoRoomsLabel;

  /// No description provided for @pgInfoBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get pgInfoBedsLabel;

  /// No description provided for @pgInfoPotentialLabel.
  ///
  /// In en, this message translates to:
  /// **'Potential'**
  String get pgInfoPotentialLabel;

  /// No description provided for @pgInfoFloorRoomDetails.
  ///
  /// In en, this message translates to:
  /// **'Floor & Room Details'**
  String get pgInfoFloorRoomDetails;

  /// No description provided for @pgInfoRoomsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms'**
  String pgInfoRoomsSummary(int count);

  /// No description provided for @pgInfoRoomChip.
  ///
  /// In en, this message translates to:
  /// **'{roomNumber} ({sharingType}, {bedsCount} beds)'**
  String pgInfoRoomChip(String roomNumber, String sharingType, int bedsCount);

  /// No description provided for @pgFloorLabelFallback.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get pgFloorLabelFallback;

  /// No description provided for @ownerBedMapRoomUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get ownerBedMapRoomUnknown;

  /// No description provided for @ownerBedMapOccupancySummary.
  ///
  /// In en, this message translates to:
  /// **'{occupied}/{total} occupied • Capacity {capacity}'**
  String ownerBedMapOccupancySummary(int occupied, int total, int capacity);

  /// No description provided for @ownerBedMapStatusChipOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied {count}'**
  String ownerBedMapStatusChipOccupied(int count);

  /// No description provided for @ownerBedMapStatusChipVacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant {count}'**
  String ownerBedMapStatusChipVacant(int count);

  /// No description provided for @ownerBedMapStatusChipPending.
  ///
  /// In en, this message translates to:
  /// **'Pending {count}'**
  String ownerBedMapStatusChipPending(int count);

  /// No description provided for @ownerBedMapStatusChipMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maint. {count}'**
  String ownerBedMapStatusChipMaintenance(int count);

  /// No description provided for @ownerBedMapBedsOverview.
  ///
  /// In en, this message translates to:
  /// **'Beds Overview'**
  String get ownerBedMapBedsOverview;

  /// No description provided for @ownerBedMapMiniStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get ownerBedMapMiniStatTotal;

  /// No description provided for @ownerBedMapMiniStatOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get ownerBedMapMiniStatOccupied;

  /// No description provided for @ownerBedMapMiniStatVacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get ownerBedMapMiniStatVacant;

  /// No description provided for @ownerBedMapMiniStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ownerBedMapMiniStatPending;

  /// No description provided for @ownerBedMapMiniStatMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maint.'**
  String get ownerBedMapMiniStatMaintenance;

  /// No description provided for @ownerBedMapPlaceholderSummary.
  ///
  /// In en, this message translates to:
  /// **'{occupied}/{total} occupied'**
  String ownerBedMapPlaceholderSummary(int occupied, int total);

  /// No description provided for @ownerBedMapStatusOccupiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get ownerBedMapStatusOccupiedLabel;

  /// No description provided for @ownerBedMapStatusPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ownerBedMapStatusPendingLabel;

  /// No description provided for @ownerBedMapStatusMaintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maint.'**
  String get ownerBedMapStatusMaintenanceLabel;

  /// No description provided for @ownerBedMapStatusVacantLabel.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get ownerBedMapStatusVacantLabel;

  /// No description provided for @ownerBedMapTooltipTitle.
  ///
  /// In en, this message translates to:
  /// **'Bed {bedNumber} • {status}'**
  String ownerBedMapTooltipTitle(String bedNumber, String status);

  /// No description provided for @ownerBedMapTooltipGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest: {guest}'**
  String ownerBedMapTooltipGuest(String guest);

  /// No description provided for @ownerBedMapTooltipFrom.
  ///
  /// In en, this message translates to:
  /// **'From: {date}'**
  String ownerBedMapTooltipFrom(String date);

  /// No description provided for @ownerBedMapTooltipTill.
  ///
  /// In en, this message translates to:
  /// **'Till: {date}'**
  String ownerBedMapTooltipTill(String date);

  /// No description provided for @ownerRevenueReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue Report'**
  String get ownerRevenueReportTitle;

  /// No description provided for @ownerRevenueReportCollectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get ownerRevenueReportCollectedLabel;

  /// No description provided for @ownerRevenueReportPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ownerRevenueReportPendingLabel;

  /// No description provided for @ownerRevenueReportTotalPaymentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get ownerRevenueReportTotalPaymentsLabel;

  /// No description provided for @ownerRevenueReportCollectedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Collected Count'**
  String get ownerRevenueReportCollectedCountLabel;

  /// No description provided for @ownerOccupancyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Report'**
  String get ownerOccupancyReportTitle;

  /// No description provided for @ownerOccupancyReportTotalBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Beds'**
  String get ownerOccupancyReportTotalBedsLabel;

  /// No description provided for @ownerOccupancyReportOccupiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get ownerOccupancyReportOccupiedLabel;

  /// No description provided for @ownerOccupancyReportVacantLabel.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get ownerOccupancyReportVacantLabel;

  /// No description provided for @ownerOccupancyReportRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get ownerOccupancyReportRateLabel;

  /// No description provided for @ownerOccupancyReportPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ownerOccupancyReportPendingLabel;

  /// No description provided for @ownerOccupancyReportMaintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get ownerOccupancyReportMaintenanceLabel;

  /// No description provided for @ownerBookingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests ({count})'**
  String ownerBookingRequestsTitle(int count);

  /// No description provided for @ownerUpcomingVacatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Vacating ({count})'**
  String ownerUpcomingVacatingTitle(int count);

  /// No description provided for @ownerServiceZeroRequests.
  ///
  /// In en, this message translates to:
  /// **'0 requests'**
  String get ownerServiceZeroRequests;

  /// No description provided for @ownerPaymentUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update payment'**
  String get ownerPaymentUpdateFailed;

  /// No description provided for @guestHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get guestHelpTitle;

  /// No description provided for @guestHelpQuickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get guestHelpQuickHelp;

  /// No description provided for @guestHelpHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant answers to common questions about booking and managing your PG stay.'**
  String get guestHelpHeroSubtitle;

  /// No description provided for @guestHelpVideosTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get guestHelpVideosTitle;

  /// No description provided for @guestHelpVideosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
  String get guestHelpVideosSubtitle;

  /// No description provided for @guestHelpUnableToOpenVideos.
  ///
  /// In en, this message translates to:
  /// **'Unable to open video tutorials'**
  String get guestHelpUnableToOpenVideos;

  /// No description provided for @guestHelpDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get guestHelpDocsTitle;

  /// No description provided for @guestHelpDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read comprehensive guides'**
  String get guestHelpDocsSubtitle;

  /// No description provided for @guestHelpUnableToOpenDocs.
  ///
  /// In en, this message translates to:
  /// **'Unable to open documentation'**
  String get guestHelpUnableToOpenDocs;

  /// No description provided for @guestHelpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get guestHelpFaqTitle;

  /// No description provided for @guestHelpFaqBookQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I book a PG room?'**
  String get guestHelpFaqBookQuestion;

  /// No description provided for @guestHelpFaqBookAnswer.
  ///
  /// In en, this message translates to:
  /// **'Browse available PGs in the \"PGs\" tab, select a PG, and tap \"Book Now\" to submit a booking request.'**
  String get guestHelpFaqBookAnswer;

  /// No description provided for @guestHelpFaqStatusQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I view my booking status?'**
  String get guestHelpFaqStatusQuestion;

  /// No description provided for @guestHelpFaqStatusAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open the \"Requests\" tab to see all your booking requests and their current status.'**
  String get guestHelpFaqStatusAnswer;

  /// No description provided for @guestHelpFaqPaymentQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I make a payment?'**
  String get guestHelpFaqPaymentQuestion;

  /// No description provided for @guestHelpFaqPaymentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to the \"Payments\" tab to view history and make new payments.'**
  String get guestHelpFaqPaymentAnswer;

  /// No description provided for @guestHelpFaqProfileQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I update my profile?'**
  String get guestHelpFaqProfileQuestion;

  /// No description provided for @guestHelpFaqProfileAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open the drawer menu and tap \"My Profile\" to edit your details.'**
  String get guestHelpFaqProfileAnswer;

  /// No description provided for @guestHelpFaqComplaintQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I file a complaint?'**
  String get guestHelpFaqComplaintQuestion;

  /// No description provided for @guestHelpFaqComplaintAnswer.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the \"Complaints\" tab and tap \"Add Complaint\" to submit one.'**
  String get guestHelpFaqComplaintAnswer;

  /// No description provided for @guestHelpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get guestHelpContactTitle;

  /// No description provided for @guestHelpContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Need more help? Reach out to our support team.'**
  String get guestHelpContactSubtitle;

  /// No description provided for @guestHelpEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get guestHelpEmailTitle;

  /// No description provided for @guestHelpPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get guestHelpPhoneTitle;

  /// No description provided for @guestHelpChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get guestHelpChatTitle;

  /// No description provided for @guestHelpChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp: +91 7020797849'**
  String get guestHelpChatSubtitle;

  /// No description provided for @guestHelpUnableToOpenChat.
  ///
  /// In en, this message translates to:
  /// **'Unable to open chat. Please try WhatsApp: +91 7020797849'**
  String get guestHelpUnableToOpenChat;

  /// No description provided for @guestHelpResourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get guestHelpResourcesTitle;

  /// No description provided for @guestHelpPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get guestHelpPrivacyPolicy;

  /// No description provided for @guestHelpTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get guestHelpTermsOfService;

  /// No description provided for @ownerHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get ownerHelpTitle;

  /// No description provided for @ownerHelpQuickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get ownerHelpQuickHelp;

  /// No description provided for @ownerHelpHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant answers to common questions about managing your PG properties.'**
  String get ownerHelpHeroSubtitle;

  /// No description provided for @ownerHelpVideosTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get ownerHelpVideosTitle;

  /// No description provided for @ownerHelpVideosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
  String get ownerHelpVideosSubtitle;

  /// No description provided for @ownerHelpUnableToOpenVideos.
  ///
  /// In en, this message translates to:
  /// **'Unable to open video tutorials'**
  String get ownerHelpUnableToOpenVideos;

  /// No description provided for @ownerHelpDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get ownerHelpDocsTitle;

  /// No description provided for @ownerHelpDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read comprehensive guides'**
  String get ownerHelpDocsSubtitle;

  /// No description provided for @ownerHelpUnableToOpenDocs.
  ///
  /// In en, this message translates to:
  /// **'Unable to open documentation'**
  String get ownerHelpUnableToOpenDocs;

  /// No description provided for @ownerHelpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get ownerHelpFaqTitle;

  /// No description provided for @ownerHelpFaqAddPgQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I add a new PG property?'**
  String get ownerHelpFaqAddPgQuestion;

  /// No description provided for @ownerHelpFaqAddPgAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to the \"My PGs\" tab and tap \"Add New PG\". Fill in the details and submit.'**
  String get ownerHelpFaqAddPgAnswer;

  /// No description provided for @ownerHelpFaqBookingsQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I manage guest bookings?'**
  String get ownerHelpFaqBookingsQuestion;

  /// No description provided for @ownerHelpFaqBookingsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open the \"Guests\" tab to review, approve, or reject booking requests.'**
  String get ownerHelpFaqBookingsAnswer;

  /// No description provided for @ownerHelpFaqPaymentsQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I view payment history?'**
  String get ownerHelpFaqPaymentsQuestion;

  /// No description provided for @ownerHelpFaqPaymentsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Use the \"Overview\" tab to review payments or check individual guests under \"Guests\".'**
  String get ownerHelpFaqPaymentsAnswer;

  /// No description provided for @ownerHelpFaqProfileQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I update my profile?'**
  String get ownerHelpFaqProfileQuestion;

  /// No description provided for @ownerHelpFaqProfileAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open the drawer menu and tap \"My Profile\" to update your information.'**
  String get ownerHelpFaqProfileAnswer;

  /// No description provided for @ownerHelpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get ownerHelpContactTitle;

  /// No description provided for @ownerHelpContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Need more help? Reach out to our support team.'**
  String get ownerHelpContactSubtitle;

  /// No description provided for @ownerHelpEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get ownerHelpEmailTitle;

  /// No description provided for @ownerHelpPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get ownerHelpPhoneTitle;

  /// No description provided for @ownerHelpChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get ownerHelpChatTitle;

  /// No description provided for @ownerHelpChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp: +91 7020797849'**
  String get ownerHelpChatSubtitle;

  /// No description provided for @ownerHelpUnableToOpenChat.
  ///
  /// In en, this message translates to:
  /// **'Unable to open chat. Please try WhatsApp: +91 7020797849'**
  String get ownerHelpUnableToOpenChat;

  /// No description provided for @ownerHelpResourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get ownerHelpResourcesTitle;

  /// No description provided for @ownerHelpPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get ownerHelpPrivacyPolicy;

  /// No description provided for @ownerHelpTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get ownerHelpTermsOfService;

  /// No description provided for @guestNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get guestNotificationsTitle;

  /// No description provided for @guestNotificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get guestNotificationsLoadFailed;

  /// No description provided for @guestNotificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get guestNotificationsEmptyTitle;

  /// No description provided for @guestNotificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet.'**
  String get guestNotificationsEmptyMessage;

  /// No description provided for @guestNotificationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get guestNotificationsFilterAll;

  /// No description provided for @guestNotificationsFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get guestNotificationsFilterUnread;

  /// No description provided for @guestNotificationsFilterBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get guestNotificationsFilterBookings;

  /// No description provided for @guestNotificationsFilterPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get guestNotificationsFilterPayments;

  /// No description provided for @guestNotificationsFilterComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get guestNotificationsFilterComplaints;

  /// No description provided for @guestNotificationsFilterBedChanges.
  ///
  /// In en, this message translates to:
  /// **'Bed Changes'**
  String get guestNotificationsFilterBedChanges;

  /// No description provided for @guestNotificationsFilterPgUpdates.
  ///
  /// In en, this message translates to:
  /// **'PG Updates'**
  String get guestNotificationsFilterPgUpdates;

  /// No description provided for @guestNotificationsFilterServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get guestNotificationsFilterServices;

  /// No description provided for @guestNotificationsDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get guestNotificationsDefaultTitle;

  /// No description provided for @guestNotificationsDefaultBody.
  ///
  /// In en, this message translates to:
  /// **'No message'**
  String get guestNotificationsDefaultBody;

  /// No description provided for @ownerNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get ownerNotificationsTitle;

  /// No description provided for @ownerNotificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get ownerNotificationsLoadFailed;

  /// No description provided for @ownerNotificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get ownerNotificationsEmptyTitle;

  /// No description provided for @ownerNotificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get ownerNotificationsEmptyMessage;

  /// No description provided for @ownerNotificationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ownerNotificationsFilterAll;

  /// No description provided for @ownerNotificationsFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get ownerNotificationsFilterUnread;

  /// No description provided for @ownerNotificationsFilterBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get ownerNotificationsFilterBookings;

  /// No description provided for @ownerNotificationsFilterPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get ownerNotificationsFilterPayments;

  /// No description provided for @ownerNotificationsFilterComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get ownerNotificationsFilterComplaints;

  /// No description provided for @ownerNotificationsFilterBedChanges.
  ///
  /// In en, this message translates to:
  /// **'Bed Changes'**
  String get ownerNotificationsFilterBedChanges;

  /// No description provided for @ownerNotificationsFilterServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get ownerNotificationsFilterServices;

  /// No description provided for @ownerNotificationsDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get ownerNotificationsDefaultTitle;

  /// No description provided for @ownerNotificationsDefaultBody.
  ///
  /// In en, this message translates to:
  /// **'No message'**
  String get ownerNotificationsDefaultBody;

  /// No description provided for @ownerNotificationsMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get ownerNotificationsMarkAll;

  /// No description provided for @ownerNotificationsJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get ownerNotificationsJustNow;

  /// No description provided for @ownerNotificationsMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} minute ago} other {{count} minutes ago}}'**
  String ownerNotificationsMinutesAgo(int count);

  /// No description provided for @ownerNotificationsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} hour ago} other {{count} hours ago}}'**
  String ownerNotificationsHoursAgo(int count);

  /// No description provided for @ownerNotificationsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} day ago} other {{count} days ago}}'**
  String ownerNotificationsDaysAgo(int count);

  /// No description provided for @drawerDefaultUserName.
  ///
  /// In en, this message translates to:
  /// **'PG User'**
  String get drawerDefaultUserName;

  /// No description provided for @drawerDefaultInitial.
  ///
  /// In en, this message translates to:
  /// **'U'**
  String get drawerDefaultInitial;

  /// No description provided for @drawerVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String drawerVersionLabel(String version);

  /// No description provided for @drawerContactEmail.
  ///
  /// In en, this message translates to:
  /// **'contact@charyatani.com'**
  String get drawerContactEmail;

  /// No description provided for @drawerContactPhone.
  ///
  /// In en, this message translates to:
  /// **'+91 98765 43210'**
  String get drawerContactPhone;

  /// No description provided for @drawerContactWebsite.
  ///
  /// In en, this message translates to:
  /// **'www.charyatani.com'**
  String get drawerContactWebsite;

  /// No description provided for @ownerSpecialMenuEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Special Menu'**
  String get ownerSpecialMenuEditTitle;

  /// No description provided for @ownerSpecialMenuAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Special Menu'**
  String get ownerSpecialMenuAddTitle;

  /// No description provided for @ownerSpecialMenuSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving special menu...'**
  String get ownerSpecialMenuSaving;

  /// No description provided for @ownerSpecialMenuSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Special Menu'**
  String get ownerSpecialMenuSaveButton;

  /// No description provided for @ownerSpecialMenuFestivalHeading.
  ///
  /// In en, this message translates to:
  /// **'Festival/Event Name'**
  String get ownerSpecialMenuFestivalHeading;

  /// No description provided for @ownerSpecialMenuFestivalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Diwali, Ugadi, Special Event'**
  String get ownerSpecialMenuFestivalHint;

  /// No description provided for @ownerSpecialMenuSpecialNoteHeading.
  ///
  /// In en, this message translates to:
  /// **'Special Note'**
  String get ownerSpecialMenuSpecialNoteHeading;

  /// No description provided for @ownerSpecialMenuSpecialNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get ownerSpecialMenuSpecialNoteLabel;

  /// No description provided for @ownerSpecialMenuSpecialNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions or details...'**
  String get ownerSpecialMenuSpecialNoteHint;

  /// No description provided for @ownerSpecialMenuFallbackInfo.
  ///
  /// In en, this message translates to:
  /// **'Leave meal sections empty to use the default weekly menu for this day'**
  String get ownerSpecialMenuFallbackInfo;

  /// No description provided for @ownerSpecialMenuOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'{meal} (Optional)'**
  String ownerSpecialMenuOptionalSection(String meal);

  /// No description provided for @ownerSpecialMenuNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items added'**
  String get ownerSpecialMenuNoItems;

  /// No description provided for @ownerSpecialMenuAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get ownerSpecialMenuAddItem;

  /// No description provided for @ownerSpecialMenuAddMealItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {mealType} Item'**
  String ownerSpecialMenuAddMealItemTitle(String mealType);

  /// No description provided for @ownerSpecialMenuItemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get ownerSpecialMenuItemNameLabel;

  /// No description provided for @ownerSpecialMenuItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter meal item name'**
  String get ownerSpecialMenuItemNameHint;

  /// No description provided for @ownerSpecialMenuFestivalRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter festival/event name'**
  String get ownerSpecialMenuFestivalRequired;

  /// No description provided for @ownerSpecialMenuSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Special menu saved successfully!'**
  String get ownerSpecialMenuSaveSuccess;

  /// No description provided for @ownerSpecialMenuSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save special menu: {error}'**
  String ownerSpecialMenuSaveFailed(String error);

  /// No description provided for @ownerSpecialMenuSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving special menu: {error}'**
  String ownerSpecialMenuSaveError(String error);

  /// No description provided for @ownerMenuEditTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit {day} Menu'**
  String ownerMenuEditTitleEdit(String day);

  /// No description provided for @ownerMenuEditTitleCreate.
  ///
  /// In en, this message translates to:
  /// **'Create {day} Menu'**
  String ownerMenuEditTitleCreate(String day);

  /// No description provided for @ownerMenuEditDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete Menu'**
  String get ownerMenuEditDeleteTooltip;

  /// No description provided for @ownerMenuEditSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving menu...'**
  String get ownerMenuEditSaving;

  /// No description provided for @ownerMenuEditUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Menu'**
  String get ownerMenuEditUpdateButton;

  /// No description provided for @ownerMenuEditCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Menu'**
  String get ownerMenuEditCreateButton;

  /// No description provided for @ownerMenuEditOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'{day} Menu'**
  String ownerMenuEditOverviewTitle(String day);

  /// No description provided for @ownerMenuEditOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create & manage the daily menu'**
  String get ownerMenuEditOverviewSubtitle;

  /// No description provided for @ownerMenuEditStatItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get ownerMenuEditStatItems;

  /// No description provided for @ownerMenuEditStatPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get ownerMenuEditStatPhotos;

  /// No description provided for @ownerMenuEditOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'{meal} (Optional)'**
  String ownerMenuEditOptionalSection(String meal);

  /// No description provided for @ownerMenuEditLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {timestamp}'**
  String ownerMenuEditLastUpdated(String timestamp);

  /// No description provided for @ownerMenuEditPhotosHeading.
  ///
  /// In en, this message translates to:
  /// **'Menu Photos'**
  String get ownerMenuEditPhotosHeading;

  /// No description provided for @ownerMenuEditAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get ownerMenuEditAddPhoto;

  /// No description provided for @ownerMenuEditUploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo...'**
  String get ownerMenuEditUploadingPhoto;

  /// No description provided for @ownerMenuEditBadgeNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get ownerMenuEditBadgeNew;

  /// No description provided for @ownerMenuEditNoPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos added yet'**
  String get ownerMenuEditNoPhotos;

  /// No description provided for @ownerMenuEditItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String ownerMenuEditItemsCount(int count);

  /// No description provided for @ownerMenuEditAddItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add {meal} Item'**
  String ownerMenuEditAddItemTooltip(String meal);

  /// No description provided for @ownerMenuEditNoItemsForMeal.
  ///
  /// In en, this message translates to:
  /// **'No {meal} items added yet'**
  String ownerMenuEditNoItemsForMeal(String meal);

  /// No description provided for @ownerMenuEditRemoveItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove Item'**
  String get ownerMenuEditRemoveItemTooltip;

  /// No description provided for @ownerMenuEditDescriptionHeading.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get ownerMenuEditDescriptionHeading;

  /// No description provided for @ownerMenuEditDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Menu Description'**
  String get ownerMenuEditDescriptionLabel;

  /// No description provided for @ownerMenuEditDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special notes about this menu...'**
  String get ownerMenuEditDescriptionHint;

  /// No description provided for @ownerMenuEditAddMealItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {mealType} Item'**
  String ownerMenuEditAddMealItemTitle(String mealType);

  /// No description provided for @ownerMenuEditItemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get ownerMenuEditItemNameLabel;

  /// No description provided for @ownerMenuEditItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Idli with Sambar, Dosa, Poha'**
  String get ownerMenuEditItemNameHint;

  /// No description provided for @ownerMenuEditMealRequired.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one meal item'**
  String get ownerMenuEditMealRequired;

  /// No description provided for @ownerMenuEditAuthError.
  ///
  /// In en, this message translates to:
  /// **'Error: User not authenticated. Please login again.'**
  String get ownerMenuEditAuthError;

  /// No description provided for @ownerMenuEditUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'{day} menu updated successfully!'**
  String ownerMenuEditUpdateSuccess(String day);

  /// No description provided for @ownerMenuEditCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'{day} menu created successfully!'**
  String ownerMenuEditCreateSuccess(String day);

  /// No description provided for @ownerMenuEditSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save menu: {error}'**
  String ownerMenuEditSaveFailed(String error);

  /// No description provided for @ownerMenuEditSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving menu: {error}'**
  String ownerMenuEditSaveError(String error);

  /// No description provided for @ownerMenuEditClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Menu?'**
  String get ownerMenuEditClearTitle;

  /// No description provided for @ownerMenuEditClearMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear this menu? This will remove all items and photos.'**
  String get ownerMenuEditClearMessage;

  /// No description provided for @ownerMenuEditClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get ownerMenuEditClearConfirm;

  /// No description provided for @ownerMenuEditClearSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Menu cleared. Don\'t forget to save changes.'**
  String get ownerMenuEditClearSnackbar;

  /// No description provided for @ownerMenuEditImagePickError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String ownerMenuEditImagePickError(String error);

  /// No description provided for @chooseYourPreferredTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get chooseYourPreferredTheme;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectPreferredLanguage;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataPrivacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @receiveNotificationsOnYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get receiveNotificationsOnYourDevice;

  /// No description provided for @receiveNotificationsViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get receiveNotificationsViaEmail;

  /// No description provided for @getRemindersForPendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Get reminders for pending payments'**
  String get getRemindersForPendingPayments;

  /// No description provided for @ownerReportsSelectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select report period'**
  String get ownerReportsSelectPeriod;

  /// No description provided for @ownerReportsSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get ownerReportsSelectDateRange;

  /// No description provided for @ownerReportsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh reports'**
  String get ownerReportsRefresh;

  /// No description provided for @ownerReportsTabRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get ownerReportsTabRevenue;

  /// No description provided for @ownerReportsTabBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get ownerReportsTabBookings;

  /// No description provided for @ownerReportsTabGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get ownerReportsTabGuests;

  /// No description provided for @ownerReportsTabPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get ownerReportsTabPayments;

  /// No description provided for @ownerReportsTabComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get ownerReportsTabComplaints;

  /// No description provided for @ownerReportsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading reports...'**
  String get ownerReportsLoading;

  /// No description provided for @ownerReportsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error loading reports'**
  String get ownerReportsErrorTitle;

  /// No description provided for @ownerReportsNoRevenueData.
  ///
  /// In en, this message translates to:
  /// **'No revenue data'**
  String get ownerReportsNoRevenueData;

  /// No description provided for @ownerReportsRevenuePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Revenue data will appear here once you have bookings'**
  String get ownerReportsRevenuePlaceholder;

  /// No description provided for @ownerReportsAveragePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Average / month'**
  String get ownerReportsAveragePerMonth;

  /// No description provided for @ownerReportsMonthlyRevenueBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Monthly revenue breakdown'**
  String get ownerReportsMonthlyRevenueBreakdown;

  /// No description provided for @ownerReportsTotalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total bookings'**
  String get ownerReportsTotalBookings;

  /// No description provided for @ownerReportsPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending requests'**
  String get ownerReportsPendingRequests;

  /// No description provided for @ownerReportsTotalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total received'**
  String get ownerReportsTotalReceived;

  /// No description provided for @ownerReportsPaidCount.
  ///
  /// In en, this message translates to:
  /// **'Paid count'**
  String get ownerReportsPaidCount;

  /// No description provided for @ownerReportsPendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending count'**
  String get ownerReportsPendingCount;

  /// No description provided for @ownerReportsChangeDateRange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get ownerReportsChangeDateRange;

  /// No description provided for @ownerReportsPropertyWiseRevenue.
  ///
  /// In en, this message translates to:
  /// **'Property-wise revenue'**
  String get ownerReportsPropertyWiseRevenue;

  /// No description provided for @ownerReportsPercentageOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% of total'**
  String ownerReportsPercentageOfTotal(String percentage);

  /// No description provided for @ownerReportsBookingTrends.
  ///
  /// In en, this message translates to:
  /// **'Booking trends'**
  String get ownerReportsBookingTrends;

  /// No description provided for @ownerReportsNoBookingData.
  ///
  /// In en, this message translates to:
  /// **'No booking data available for the selected period'**
  String get ownerReportsNoBookingData;

  /// No description provided for @ownerReportsBookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bookings'**
  String ownerReportsBookingsCount(int count);

  /// No description provided for @ownerReportsGuestStatistics.
  ///
  /// In en, this message translates to:
  /// **'Guest statistics'**
  String get ownerReportsGuestStatistics;

  /// No description provided for @ownerReportsPaymentTrends.
  ///
  /// In en, this message translates to:
  /// **'Payment trends'**
  String get ownerReportsPaymentTrends;

  /// No description provided for @ownerReportsNoPaymentData.
  ///
  /// In en, this message translates to:
  /// **'No payment data available for the selected period'**
  String get ownerReportsNoPaymentData;

  /// No description provided for @ownerReportsComplaintTrends.
  ///
  /// In en, this message translates to:
  /// **'Complaint trends'**
  String get ownerReportsComplaintTrends;

  /// No description provided for @ownerReportsNoComplaintData.
  ///
  /// In en, this message translates to:
  /// **'No complaint data available for the selected period'**
  String get ownerReportsNoComplaintData;

  /// No description provided for @ownerReportsComplaintsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} complaints'**
  String ownerReportsComplaintsCount(int count);

  /// No description provided for @ownerOverviewOccupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy rate'**
  String get ownerOverviewOccupancyRate;

  /// No description provided for @ownerOverviewPerformanceExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ownerOverviewPerformanceExcellent;

  /// No description provided for @ownerOverviewPerformanceGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ownerOverviewPerformanceGood;

  /// No description provided for @ownerOverviewPerformanceFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ownerOverviewPerformanceFair;

  /// No description provided for @ownerOverviewPerformanceNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get ownerOverviewPerformanceNeedsAttention;

  /// No description provided for @ownerOverviewPgLabel.
  ///
  /// In en, this message translates to:
  /// **'{index}PG: {name}'**
  String ownerOverviewPgLabel(int index, String name);

  /// No description provided for @ownerOverviewAveragePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Average / month'**
  String get ownerOverviewAveragePerMonth;

  /// No description provided for @ownerOverviewHighestMonth.
  ///
  /// In en, this message translates to:
  /// **'Highest month'**
  String get ownerOverviewHighestMonth;

  /// No description provided for @ownerProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get ownerProfileTitle;

  /// No description provided for @ownerProfileSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get ownerProfileSaveTooltip;

  /// No description provided for @ownerProfileTabPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get ownerProfileTabPersonalInfo;

  /// No description provided for @ownerProfileTabBusinessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business Info'**
  String get ownerProfileTabBusinessInfo;

  /// No description provided for @ownerProfileTabDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get ownerProfileTabDocuments;

  /// No description provided for @ownerProfileFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get ownerProfileFullNameLabel;

  /// No description provided for @ownerProfileFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get ownerProfileFullNameHint;

  /// No description provided for @ownerProfileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get ownerProfileEmailLabel;

  /// No description provided for @ownerProfileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get ownerProfileEmailHint;

  /// No description provided for @ownerProfilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get ownerProfilePhoneLabel;

  /// No description provided for @ownerProfilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get ownerProfilePhoneHint;

  /// No description provided for @ownerProfileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'PG Address'**
  String get ownerProfileAddressLabel;

  /// No description provided for @ownerProfileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your PG address'**
  String get ownerProfileAddressHint;

  /// No description provided for @ownerProfileStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get ownerProfileStateLabel;

  /// No description provided for @ownerProfileStateHint.
  ///
  /// In en, this message translates to:
  /// **'Select state'**
  String get ownerProfileStateHint;

  /// No description provided for @ownerProfileCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get ownerProfileCityLabel;

  /// No description provided for @ownerProfileCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get ownerProfileCityHint;

  /// No description provided for @ownerProfileCityHintSelectState.
  ///
  /// In en, this message translates to:
  /// **'Select state first'**
  String get ownerProfileCityHintSelectState;

  /// No description provided for @ownerProfilePincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get ownerProfilePincodeLabel;

  /// No description provided for @ownerProfilePincodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter pincode'**
  String get ownerProfilePincodeHint;

  /// No description provided for @ownerProfileSavePersonal.
  ///
  /// In en, this message translates to:
  /// **'Save Personal Info'**
  String get ownerProfileSavePersonal;

  /// No description provided for @ownerProfileBusinessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get ownerProfileBusinessNameLabel;

  /// No description provided for @ownerProfileBusinessNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter business name'**
  String get ownerProfileBusinessNameHint;

  /// No description provided for @ownerProfileBusinessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get ownerProfileBusinessTypeLabel;

  /// No description provided for @ownerProfileBusinessTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter business type'**
  String get ownerProfileBusinessTypeHint;

  /// No description provided for @ownerProfilePanLabel.
  ///
  /// In en, this message translates to:
  /// **'PAN Number'**
  String get ownerProfilePanLabel;

  /// No description provided for @ownerProfilePanHint.
  ///
  /// In en, this message translates to:
  /// **'Enter PAN number'**
  String get ownerProfilePanHint;

  /// No description provided for @ownerProfileGstLabel.
  ///
  /// In en, this message translates to:
  /// **'GST Number'**
  String get ownerProfileGstLabel;

  /// No description provided for @ownerProfileGstHint.
  ///
  /// In en, this message translates to:
  /// **'Enter GST number'**
  String get ownerProfileGstHint;

  /// No description provided for @ownerProfileSaveBusiness.
  ///
  /// In en, this message translates to:
  /// **'Save Business Info'**
  String get ownerProfileSaveBusiness;

  /// No description provided for @ownerProfileDocumentProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get ownerProfileDocumentProfileTitle;

  /// No description provided for @ownerProfileDocumentProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload your profile photo'**
  String get ownerProfileDocumentProfileDescription;

  /// No description provided for @ownerProfileDocumentAadhaarTitle.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Photo'**
  String get ownerProfileDocumentAadhaarTitle;

  /// No description provided for @ownerProfileDocumentAadhaarDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload your Aadhaar card photo'**
  String get ownerProfileDocumentAadhaarDescription;

  /// No description provided for @ownerProfileDocumentUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get ownerProfileDocumentUpload;

  /// No description provided for @ownerProfileDocumentUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get ownerProfileDocumentUpdate;

  /// No description provided for @ownerProfilePickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String ownerProfilePickImageFailed(String error);

  /// No description provided for @ownerIdNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Owner ID not available'**
  String get ownerIdNotAvailable;

  /// No description provided for @ownerProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get ownerProfileNotFound;

  /// No description provided for @ownerProfileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get ownerProfileLoadFailed;

  /// No description provided for @ownerProfileStreamFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to stream profile'**
  String get ownerProfileStreamFailed;

  /// No description provided for @ownerProfileStreamStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start profile stream'**
  String get ownerProfileStreamStartFailed;

  /// No description provided for @ownerProfileCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create profile'**
  String get ownerProfileCreateFailed;

  /// No description provided for @ownerProfileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get ownerProfileUpdateFailed;

  /// No description provided for @ownerBankDetailsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update bank details'**
  String get ownerBankDetailsUpdateFailed;

  /// No description provided for @ownerBusinessInfoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update business information'**
  String get ownerBusinessInfoUpdateFailed;

  /// No description provided for @ownerProfilePhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload profile photo'**
  String get ownerProfilePhotoUploadFailed;

  /// No description provided for @ownerAadhaarUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload Aadhaar document'**
  String get ownerAadhaarUploadFailed;

  /// No description provided for @ownerUpiQrUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload UPI QR code'**
  String get ownerUpiQrUploadFailed;

  /// No description provided for @ownerAddPgFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add PG'**
  String get ownerAddPgFailed;

  /// No description provided for @ownerRemovePgFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove PG'**
  String get ownerRemovePgFailed;

  /// No description provided for @ownerProfileVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify profile'**
  String get ownerProfileVerifyFailed;

  /// No description provided for @ownerProfileDeactivateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to deactivate profile'**
  String get ownerProfileDeactivateFailed;

  /// No description provided for @ownerProfileActivateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to activate profile'**
  String get ownerProfileActivateFailed;

  /// No description provided for @ownerStateUpdateFailedLog.
  ///
  /// In en, this message translates to:
  /// **'Error updating selected state: {error}'**
  String ownerStateUpdateFailedLog(String error);

  /// No description provided for @ownerCityUpdateFailedLog.
  ///
  /// In en, this message translates to:
  /// **'Error updating selected city: {error}'**
  String ownerCityUpdateFailedLog(String error);

  /// No description provided for @ownerStateTelangana.
  ///
  /// In en, this message translates to:
  /// **'Telangana'**
  String get ownerStateTelangana;

  /// No description provided for @ownerStateAndhraPradesh.
  ///
  /// In en, this message translates to:
  /// **'Andhra Pradesh'**
  String get ownerStateAndhraPradesh;

  /// No description provided for @ownerProfilePhotoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile photo'**
  String get ownerProfilePhotoUpdateFailed;

  /// No description provided for @ownerAadhaarUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update Aadhaar photo'**
  String get ownerAadhaarUpdateFailed;

  /// No description provided for @ownerUpiQrUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update UPI QR code'**
  String get ownerUpiQrUpdateFailed;

  /// No description provided for @ownerFileDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete file'**
  String get ownerFileDeleteFailed;

  /// No description provided for @ownerPgFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch owner PG IDs'**
  String get ownerPgFetchFailed;

  /// No description provided for @ownerOverviewFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch owner overview data'**
  String get ownerOverviewFetchFailed;

  /// No description provided for @ownerOverviewAggregateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to aggregate owner data'**
  String get ownerOverviewAggregateFailed;

  /// No description provided for @ownerMonthlyBreakdownFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch monthly breakdown'**
  String get ownerMonthlyBreakdownFailed;

  /// No description provided for @ownerPropertyBreakdownFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch property breakdown'**
  String get ownerPropertyBreakdownFailed;

  /// No description provided for @ownerPropertyFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Property {pgId}'**
  String ownerPropertyFallbackName(String pgId);

  /// No description provided for @ownerOverviewLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load overview data'**
  String get ownerOverviewLoadFailed;

  /// No description provided for @ownerOverviewLoadFailedWithReason.
  ///
  /// In en, this message translates to:
  /// **'Failed to load overview data: {error}'**
  String ownerOverviewLoadFailedWithReason(String error);

  /// No description provided for @ownerOverviewStreamFailedWithReason.
  ///
  /// In en, this message translates to:
  /// **'Failed to stream overview data: {error}'**
  String ownerOverviewStreamFailedWithReason(String error);

  /// No description provided for @ownerMonthlyBreakdownLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load monthly breakdown: {error}'**
  String ownerMonthlyBreakdownLoadFailed(String error);

  /// No description provided for @ownerPropertyBreakdownLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load property breakdown: {error}'**
  String ownerPropertyBreakdownLoadFailed(String error);

  /// No description provided for @ownerGuestInitializeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize guest management: {error}'**
  String ownerGuestInitializeFailed(String error);

  /// No description provided for @ownerGuestStatsLoadFailedLog.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Owner Guest ViewModel: Failed to load guest stats: {error}'**
  String ownerGuestStatsLoadFailedLog(String error);

  /// No description provided for @ownerGuestUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update guest: {error}'**
  String ownerGuestUpdateFailed(String error);

  /// No description provided for @ownerComplaintReplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add reply: {error}'**
  String ownerComplaintReplyFailed(String error);

  /// No description provided for @ownerComplaintStatusUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update complaint status: {error}'**
  String ownerComplaintStatusUpdateFailed(String error);

  /// No description provided for @ownerBikeUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update bike: {error}'**
  String ownerBikeUpdateFailed(String error);

  /// No description provided for @ownerBikeMovementRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create bike movement request: {error}'**
  String ownerBikeMovementRequestFailed(String error);

  /// No description provided for @ownerServiceCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create service request: {error}'**
  String ownerServiceCreateFailed(String error);

  /// No description provided for @ownerServiceReplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add service reply: {error}'**
  String ownerServiceReplyFailed(String error);

  /// No description provided for @ownerServiceStatusUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update service status: {error}'**
  String ownerServiceStatusUpdateFailed(String error);

  /// No description provided for @ownerGuestRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh data: {error}'**
  String ownerGuestRefreshFailed(String error);

  /// No description provided for @ownerBookingApproveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve booking request: {error}'**
  String ownerBookingApproveFailed(String error);

  /// No description provided for @ownerBookingRejectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject booking request: {error}'**
  String ownerBookingRejectFailed(String error);

  /// No description provided for @ownerResponseNone.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get ownerResponseNone;

  /// No description provided for @ownerFoodLoadMenusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load menus: {error}'**
  String ownerFoodLoadMenusFailed(String error);

  /// No description provided for @ownerFoodStreamMenusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to stream menus: {error}'**
  String ownerFoodStreamMenusFailed(String error);

  /// No description provided for @ownerFoodStreamOverridesFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to stream overrides: {error}'**
  String ownerFoodStreamOverridesFailed(String error);

  /// No description provided for @ownerFoodSaveMenuFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save menu: {error}'**
  String ownerFoodSaveMenuFailed(String error);

  /// No description provided for @ownerFoodSaveMenusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save menus: {error}'**
  String ownerFoodSaveMenusFailed(String error);

  /// No description provided for @ownerFoodDeleteMenuFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete menu: {error}'**
  String ownerFoodDeleteMenuFailed(String error);

  /// No description provided for @ownerFoodSaveOverrideFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save override: {error}'**
  String ownerFoodSaveOverrideFailed(String error);

  /// No description provided for @ownerFoodDeleteOverrideFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete override: {error}'**
  String ownerFoodDeleteOverrideFailed(String error);

  /// No description provided for @ownerFoodUploadPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo: {error}'**
  String ownerFoodUploadPhotoFailed(String error);

  /// No description provided for @ownerFoodDeletePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete photo: {error}'**
  String ownerFoodDeletePhotoFailed(String error);

  /// No description provided for @ownerFoodInitializeDefaultsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize default menus: {error}'**
  String ownerFoodInitializeDefaultsFailed(String error);

  /// No description provided for @ownerFoodUpdateCurrentMenuFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update current day menu: {error}'**
  String ownerFoodUpdateCurrentMenuFailed(String error);

  /// No description provided for @ownerFoodSaveStateFailedLog.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Owner Food ViewModel: Failed to save menu state: {error}'**
  String ownerFoodSaveStateFailedLog(String error);

  /// No description provided for @ownerFoodClearStateFailedLog.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Owner Food ViewModel: Failed to clear menu state: {error}'**
  String ownerFoodClearStateFailedLog(String error);

  /// No description provided for @ownerFoodFetchMenuFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch weekly menu'**
  String get ownerFoodFetchMenuFailed;

  /// No description provided for @ownerFoodFetchOverridesFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch menu overrides'**
  String get ownerFoodFetchOverridesFailed;

  /// No description provided for @ownerFoodRepositorySaveMenuFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save weekly menu'**
  String get ownerFoodRepositorySaveMenuFailed;

  /// No description provided for @ownerFoodRepositorySaveMenusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save weekly menus'**
  String get ownerFoodRepositorySaveMenusFailed;

  /// No description provided for @ownerFoodRepositoryDeleteMenuFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete weekly menu'**
  String get ownerFoodRepositoryDeleteMenuFailed;

  /// No description provided for @ownerFoodRepositorySaveOverrideFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save menu override'**
  String get ownerFoodRepositorySaveOverrideFailed;

  /// No description provided for @ownerFoodRepositoryDeleteOverrideFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete menu override'**
  String get ownerFoodRepositoryDeleteOverrideFailed;

  /// No description provided for @ownerFoodRepositoryUploadPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo'**
  String get ownerFoodRepositoryUploadPhotoFailed;

  /// No description provided for @ownerFoodRepositoryDeletePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete photo'**
  String get ownerFoodRepositoryDeletePhotoFailed;

  /// No description provided for @ownerFoodFetchStatsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch menu stats'**
  String get ownerFoodFetchStatsFailed;

  /// No description provided for @pgPhotosUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading {count} photo(s)...'**
  String pgPhotosUploading(int count);

  /// No description provided for @pgPhotosSelectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select photos: {error}'**
  String pgPhotosSelectFailed(String error);

  /// No description provided for @pgPhotosUploadErrorLog.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image {index}: {error}'**
  String pgPhotosUploadErrorLog(int index, String error);

  /// No description provided for @pgSupabaseStorageTroubleshoot.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Supabase Storage Error: This might be due to:\n1. Storage bucket RLS policies blocking uploads\n2. CORS configuration issues\n3. Authentication required for storage uploads\nPlease check your Supabase Storage policies for the \"atitia-storage\" bucket.'**
  String get pgSupabaseStorageTroubleshoot;

  /// No description provided for @ownerPgUnknownName.
  ///
  /// In en, this message translates to:
  /// **'Unknown PG'**
  String get ownerPgUnknownName;

  /// No description provided for @ownerPgInitializeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize PG management: {error}'**
  String ownerPgInitializeFailed(String error);

  /// No description provided for @ownerPgApproveBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve booking: {error}'**
  String ownerPgApproveBookingFailed(String error);

  /// No description provided for @ownerPgRejectBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject booking: {error}'**
  String ownerPgRejectBookingFailed(String error);

  /// No description provided for @ownerPgRescheduleBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reschedule booking: {error}'**
  String ownerPgRescheduleBookingFailed(String error);

  /// No description provided for @ownerPgIdNotInitialized.
  ///
  /// In en, this message translates to:
  /// **'PG ID not initialized'**
  String get ownerPgIdNotInitialized;

  /// No description provided for @ownerPgUpdateBedStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update bed status: {error}'**
  String ownerPgUpdateBedStatusFailed(String error);

  /// No description provided for @ownerPgRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh data: {error}'**
  String ownerPgRefreshFailed(String error);

  /// No description provided for @ownerPgSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save PG: {error}'**
  String ownerPgSaveFailed(String error);

  /// No description provided for @ownerPgIdNotProvided.
  ///
  /// In en, this message translates to:
  /// **'PG ID not provided'**
  String get ownerPgIdNotProvided;

  /// No description provided for @ownerPgUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update PG: {error}'**
  String ownerPgUpdateFailed(String error);

  /// No description provided for @ownerPgDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete PG: {error}'**
  String ownerPgDeleteFailed(String error);

  /// No description provided for @ownerPgCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create PG: {error}'**
  String ownerPgCreateFailed(String error);

  /// No description provided for @ownerPgRevenueReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to get revenue report: {error}'**
  String ownerPgRevenueReportFailed(String error);

  /// No description provided for @ownerPgOccupancyReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to get occupancy report: {error}'**
  String ownerPgOccupancyReportFailed(String error);

  /// No description provided for @ownerPgFetchListFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch PGs: {error}'**
  String ownerPgFetchListFailed(String error);

  /// No description provided for @ownerPgFetchDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch PG details: {error}'**
  String ownerPgFetchDetailsFailed(String error);

  /// No description provided for @ownerPgBasicInfoZeroStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Fill in the basic information about your PG to get started.'**
  String get ownerPgBasicInfoZeroStateMessage;

  /// No description provided for @ownerPgQuickStatRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get ownerPgQuickStatRequired;

  /// No description provided for @ownerPgQuickStatRentTypes.
  ///
  /// In en, this message translates to:
  /// **'Rent Types'**
  String get ownerPgQuickStatRentTypes;

  /// No description provided for @ownerPgQuickStatDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get ownerPgQuickStatDeposit;

  /// No description provided for @ownerPgStatusNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get ownerPgStatusNotSet;

  /// No description provided for @ownerPgStatusSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get ownerPgStatusSet;

  /// No description provided for @ownerPgFloorStructureZeroStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Set up the floor structure, rooms, and beds for your PG.'**
  String get ownerPgFloorStructureZeroStateMessage;

  /// No description provided for @ownerPgQuickStatFloors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get ownerPgQuickStatFloors;

  /// No description provided for @ownerPgQuickStatRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get ownerPgQuickStatRooms;

  /// No description provided for @ownerPgQuickStatBeds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get ownerPgQuickStatBeds;

  /// No description provided for @ownerPgAmenitiesZeroStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Select the amenities your PG offers to help guests find you.'**
  String get ownerPgAmenitiesZeroStateMessage;

  /// No description provided for @ownerPgPhotosZeroStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your PG to showcase it to potential guests.'**
  String get ownerPgPhotosZeroStateMessage;

  /// No description provided for @ownerPgQuickStatSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get ownerPgQuickStatSelected;

  /// No description provided for @ownerPgBedNumberingDescription.
  ///
  /// In en, this message translates to:
  /// **'Number beds consistently based on door position so everyone agrees.'**
  String get ownerPgBedNumberingDescription;

  /// No description provided for @ownerPgBedNumberingRule.
  ///
  /// In en, this message translates to:
  /// **'Rule: Stand at the entrance facing inside → left-to-right, front-to-back (door wall to opposite wall).'**
  String get ownerPgBedNumberingRule;

  /// No description provided for @ownerPgBedLayoutTwoByTwo.
  ///
  /// In en, this message translates to:
  /// **'2x2 layout'**
  String get ownerPgBedLayoutTwoByTwo;

  /// No description provided for @ownerPgBedLayoutOneByFour.
  ///
  /// In en, this message translates to:
  /// **'1x4 along a wall (door → last wall)'**
  String get ownerPgBedLayoutOneByFour;

  /// No description provided for @ownerPgBed1NearestLeft.
  ///
  /// In en, this message translates to:
  /// **'Bed-1: nearest row, left side'**
  String get ownerPgBed1NearestLeft;

  /// No description provided for @ownerPgBed2NearestRight.
  ///
  /// In en, this message translates to:
  /// **'Bed-2: nearest row, right side'**
  String get ownerPgBed2NearestRight;

  /// No description provided for @ownerPgBed3FarLeft.
  ///
  /// In en, this message translates to:
  /// **'Bed-3: far row, left side'**
  String get ownerPgBed3FarLeft;

  /// No description provided for @ownerPgBed4FarRight.
  ///
  /// In en, this message translates to:
  /// **'Bed-4: far row, right side'**
  String get ownerPgBed4FarRight;

  /// No description provided for @ownerPgBed1ClosestDoor.
  ///
  /// In en, this message translates to:
  /// **'Bed-1: closest to door'**
  String get ownerPgBed1ClosestDoor;

  /// No description provided for @ownerPgBedNext.
  ///
  /// In en, this message translates to:
  /// **'Bed-{number}: next'**
  String ownerPgBedNext(int number);

  /// No description provided for @ownerPgBed4Farthest.
  ///
  /// In en, this message translates to:
  /// **'Bed-4: farthest from door'**
  String get ownerPgBed4Farthest;

  /// No description provided for @ownerPgRentConfigZeroStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Set up rent amounts for different sharing types and maintenance charges.'**
  String get ownerPgRentConfigZeroStateMessage;

  /// No description provided for @ownerPgProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} sections completed'**
  String ownerPgProgressDescription(int completed, int total);

  /// No description provided for @ownerPgLoadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading PG details...'**
  String get ownerPgLoadingDetails;

  /// No description provided for @ownerPgPublishedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PG published successfully'**
  String get ownerPgPublishedSuccessfully;

  /// No description provided for @ownerPgPublishFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish PG'**
  String get ownerPgPublishFailed;

  /// No description provided for @ownerAnalyticsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load analytics data: {error}'**
  String ownerAnalyticsLoadFailed(String error);

  /// No description provided for @ownerProfileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get ownerProfileUpdateSuccess;

  /// No description provided for @ownerProfileUpdateFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String ownerProfileUpdateFailure(String error);

  /// No description provided for @replaceQrCode.
  ///
  /// In en, this message translates to:
  /// **'Replace QR Code'**
  String get replaceQrCode;

  /// No description provided for @removeQrCode.
  ///
  /// In en, this message translates to:
  /// **'Remove QR Code'**
  String get removeQrCode;

  /// No description provided for @previewQrCode.
  ///
  /// In en, this message translates to:
  /// **'Preview QR Code'**
  String get previewQrCode;

  /// No description provided for @noQrCodeSelected.
  ///
  /// In en, this message translates to:
  /// **'No QR code selected yet'**
  String get noQrCodeSelected;

  /// No description provided for @newQrCodeSelected.
  ///
  /// In en, this message translates to:
  /// **'New QR code selected'**
  String get newQrCodeSelected;

  /// No description provided for @existingQrCode.
  ///
  /// In en, this message translates to:
  /// **'Existing QR code'**
  String get existingQrCode;

  /// No description provided for @exampleBankName.
  ///
  /// In en, this message translates to:
  /// **'e.g., State Bank of India'**
  String get exampleBankName;

  /// No description provided for @exampleIfsc.
  ///
  /// In en, this message translates to:
  /// **'e.g., SBIN0001234'**
  String get exampleIfsc;

  /// No description provided for @exampleUpiId.
  ///
  /// In en, this message translates to:
  /// **'yourname@paytm'**
  String get exampleUpiId;

  /// No description provided for @qrCodeInfoText.
  ///
  /// In en, this message translates to:
  /// **'You can generate a QR code from any UPI app like PhonePe, Paytm, Google Pay, etc.'**
  String get qrCodeInfoText;

  /// No description provided for @ownerProfileInitialFallback.
  ///
  /// In en, this message translates to:
  /// **'O'**
  String get ownerProfileInitialFallback;

  /// No description provided for @ownerProfileVerifiedStatus.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get ownerProfileVerifiedStatus;

  /// No description provided for @ownerProfilePendingVerificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get ownerProfilePendingVerificationStatus;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @dateFormatDdMmYyyy.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateFormatDdMmYyyy;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @guestInitialsFallback.
  ///
  /// In en, this message translates to:
  /// **'GU'**
  String get guestInitialsFallback;

  /// No description provided for @perMonthAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount}/month'**
  String perMonthAmount(String amount);

  /// No description provided for @pgPayment.
  ///
  /// In en, this message translates to:
  /// **'PG Payment'**
  String get pgPayment;

  /// No description provided for @paymentTypeRent.
  ///
  /// In en, this message translates to:
  /// **'Rent Payment'**
  String get paymentTypeRent;

  /// No description provided for @paymentTypeSecurityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security Deposit'**
  String get paymentTypeSecurityDeposit;

  /// No description provided for @paymentTypeMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Fee'**
  String get paymentTypeMaintenance;

  /// No description provided for @paymentTypeLateFee.
  ///
  /// In en, this message translates to:
  /// **'Late Fee'**
  String get paymentTypeLateFee;

  /// No description provided for @paymentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'{type} Payment'**
  String paymentTypeOther(String type);

  /// No description provided for @paymentCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment completed successfully'**
  String get paymentCompletedSuccessfully;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get paymentPending;

  /// No description provided for @paymentOverdue.
  ///
  /// In en, this message translates to:
  /// **'Payment overdue — please pay immediately'**
  String get paymentOverdue;

  /// No description provided for @paymentFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment failed — please try again'**
  String get paymentFailedMessage;

  /// No description provided for @paymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Payment has been refunded'**
  String get paymentRefunded;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get unknownStatus;

  /// No description provided for @paymentFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_filter_changed'**
  String get paymentFilterChangedEvent;

  /// No description provided for @paymentLoadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_load_error'**
  String get paymentLoadErrorEvent;

  /// No description provided for @pendingPaymentsLoadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pending_payments_load_error'**
  String get pendingPaymentsLoadErrorEvent;

  /// No description provided for @overduePaymentsLoadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'overdue_payments_load_error'**
  String get overduePaymentsLoadErrorEvent;

  /// No description provided for @paymentStatsLoadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_stats_load_error'**
  String get paymentStatsLoadErrorEvent;

  /// No description provided for @paymentAddedSuccessfullyEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_added_successfully'**
  String get paymentAddedSuccessfullyEvent;

  /// No description provided for @paymentAddFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_add_failed'**
  String get paymentAddFailedEvent;

  /// No description provided for @paymentUpdatedSuccessfullyEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_updated_successfully'**
  String get paymentUpdatedSuccessfullyEvent;

  /// No description provided for @paymentUpdateFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_update_failed'**
  String get paymentUpdateFailedEvent;

  /// No description provided for @paymentStatusUpdatedSuccessfullyEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_status_updated_successfully'**
  String get paymentStatusUpdatedSuccessfullyEvent;

  /// No description provided for @paymentStatusUpdateFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_status_update_failed'**
  String get paymentStatusUpdateFailedEvent;

  /// No description provided for @paymentDeletedSuccessfullyEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_deleted_successfully'**
  String get paymentDeletedSuccessfullyEvent;

  /// No description provided for @paymentDeletionFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'payment_deletion_failed'**
  String get paymentDeletionFailedEvent;

  /// No description provided for @paymentsRefreshedEvent.
  ///
  /// In en, this message translates to:
  /// **'payments_refreshed'**
  String get paymentsRefreshedEvent;

  /// No description provided for @failedToLoadPayments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payments: {error}'**
  String failedToLoadPayments(String error);

  /// No description provided for @failedToAddPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to add payment: {error}'**
  String failedToAddPayment(String error);

  /// No description provided for @failedToUpdatePaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update payment status: {error}'**
  String failedToUpdatePaymentStatus(String error);

  /// No description provided for @failedToFetchPayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch payment: {error}'**
  String failedToFetchPayment(String error);

  /// No description provided for @failedToDeletePayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete payment: {error}'**
  String failedToDeletePayment(String error);

  /// No description provided for @paymentSimulationDeprecated.
  ///
  /// In en, this message translates to:
  /// **'Payment simulation is deprecated.'**
  String get paymentSimulationDeprecated;

  /// No description provided for @paymentSimulationRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Please use real payment gateways (Razorpay, UPI, or Cash) via the payment method selection dialog.'**
  String get paymentSimulationRecommendation;

  /// No description provided for @paymentNotificationReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentNotificationReceivedTitle;

  /// No description provided for @paymentNotificationReceivedBody.
  ///
  /// In en, this message translates to:
  /// **'Payment of {amount} received from guest'**
  String paymentNotificationReceivedBody(Object amount);

  /// No description provided for @selectPaymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethodTitle;

  /// No description provided for @selectPaymentMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to make the payment'**
  String get selectPaymentMethodSubtitle;

  /// No description provided for @razorpayPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Secure online payment via Razorpay'**
  String get razorpayPaymentDescription;

  /// No description provided for @upiPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay via PhonePe, Paytm, Google Pay, etc. and share screenshot'**
  String get upiPaymentDescription;

  /// No description provided for @cashPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay in cash and request owner confirmation'**
  String get cashPaymentDescription;

  /// No description provided for @guestProfileLoadedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_loaded'**
  String get guestProfileLoadedEvent;

  /// No description provided for @guestProfileUpdateSuccessEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_update_success'**
  String get guestProfileUpdateSuccessEvent;

  /// No description provided for @guestProfileFieldsUpdateSuccessEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_fields_update_success'**
  String get guestProfileFieldsUpdateSuccessEvent;

  /// No description provided for @profilePhotoUploadSuccessEvent.
  ///
  /// In en, this message translates to:
  /// **'profile_photo_upload_success'**
  String get profilePhotoUploadSuccessEvent;

  /// No description provided for @aadhaarPhotoUploadSuccessEvent.
  ///
  /// In en, this message translates to:
  /// **'aadhaar_photo_upload_success'**
  String get aadhaarPhotoUploadSuccessEvent;

  /// No description provided for @idProofUploadSuccessEvent.
  ///
  /// In en, this message translates to:
  /// **'id_proof_upload_success'**
  String get idProofUploadSuccessEvent;

  /// No description provided for @guestStatusUpdateSuccessEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_status_update_success'**
  String get guestStatusUpdateSuccessEvent;

  /// No description provided for @guestProfileClearedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_cleared'**
  String get guestProfileClearedEvent;

  /// No description provided for @guestProfileEditStartedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_edit_started'**
  String get guestProfileEditStartedEvent;

  /// No description provided for @guestProfileEditCancelledEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_edit_cancelled'**
  String get guestProfileEditCancelledEvent;

  /// No description provided for @guestProfileRefreshedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_refreshed'**
  String get guestProfileRefreshedEvent;

  /// No description provided for @guestProfileNotFoundEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_not_found'**
  String get guestProfileNotFoundEvent;

  /// No description provided for @guestProfileViewedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_viewed'**
  String get guestProfileViewedEvent;

  /// No description provided for @guestProfileFetchErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_fetch_error'**
  String get guestProfileFetchErrorEvent;

  /// No description provided for @guestProfileUpdatedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_updated'**
  String get guestProfileUpdatedEvent;

  /// No description provided for @guestProfileUpdateErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_update_error'**
  String get guestProfileUpdateErrorEvent;

  /// No description provided for @guestProfileFieldsUpdatedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_fields_updated'**
  String get guestProfileFieldsUpdatedEvent;

  /// No description provided for @guestProfileFieldsUpdateErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_fields_update_error'**
  String get guestProfileFieldsUpdateErrorEvent;

  /// No description provided for @profilePhotoUploadedEvent.
  ///
  /// In en, this message translates to:
  /// **'profile_photo_uploaded'**
  String get profilePhotoUploadedEvent;

  /// No description provided for @profilePhotoUploadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'profile_photo_upload_error'**
  String get profilePhotoUploadErrorEvent;

  /// No description provided for @aadhaarPhotoUploadedEvent.
  ///
  /// In en, this message translates to:
  /// **'aadhaar_photo_uploaded'**
  String get aadhaarPhotoUploadedEvent;

  /// No description provided for @aadhaarPhotoUploadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'aadhaar_photo_upload_error'**
  String get aadhaarPhotoUploadErrorEvent;

  /// No description provided for @idProofUploadedEvent.
  ///
  /// In en, this message translates to:
  /// **'id_proof_uploaded'**
  String get idProofUploadedEvent;

  /// No description provided for @idProofUploadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'id_proof_upload_error'**
  String get idProofUploadErrorEvent;

  /// No description provided for @guestProfileDeletedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_deleted'**
  String get guestProfileDeletedEvent;

  /// No description provided for @guestProfileDeleteErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_profile_delete_error'**
  String get guestProfileDeleteErrorEvent;

  /// No description provided for @guestStatusUpdatedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_status_updated'**
  String get guestStatusUpdatedEvent;

  /// No description provided for @guestStatusUpdateErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_status_update_error'**
  String get guestStatusUpdateErrorEvent;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile: {error}'**
  String failedToLoadProfile(String error);

  /// No description provided for @failedToStreamProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to stream profile: {error}'**
  String failedToStreamProfile(String error);

  /// No description provided for @failedToUpdateGuestProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update guest profile: {error}'**
  String failedToUpdateGuestProfile(String error);

  /// No description provided for @failedToUpdateProfileFields.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile fields: {error}'**
  String failedToUpdateProfileFields(String error);

  /// No description provided for @failedToUploadIdProof.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload ID proof: {error}'**
  String failedToUploadIdProof(String error);

  /// No description provided for @failedToUpdateGuestStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update guest status: {error}'**
  String failedToUpdateGuestStatus(String error);

  /// No description provided for @failedToFetchGuestProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch guest profile: {error}'**
  String failedToFetchGuestProfile(String error);

  /// No description provided for @failedToDeleteGuestProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete guest profile: {error}'**
  String failedToDeleteGuestProfile(String error);

  /// No description provided for @noChangesToSave.
  ///
  /// In en, this message translates to:
  /// **'No changes to save'**
  String get noChangesToSave;

  /// No description provided for @pgsLoadedEvent.
  ///
  /// In en, this message translates to:
  /// **'pgs_loaded'**
  String get pgsLoadedEvent;

  /// No description provided for @pgsLoadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pgs_load_error'**
  String get pgsLoadErrorEvent;

  /// No description provided for @pgSelectedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_selected'**
  String get pgSelectedEvent;

  /// No description provided for @pgFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_filter_changed'**
  String get pgFilterChangedEvent;

  /// No description provided for @pgSearchQueryChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_search_query_changed'**
  String get pgSearchQueryChangedEvent;

  /// No description provided for @pgAmenitiesFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_amenities_filter_changed'**
  String get pgAmenitiesFilterChangedEvent;

  /// No description provided for @pgCityFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_city_filter_changed'**
  String get pgCityFilterChangedEvent;

  /// No description provided for @pgTypeFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_type_filter_changed'**
  String get pgTypeFilterChangedEvent;

  /// No description provided for @pgMealTypeFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_meal_type_filter_changed'**
  String get pgMealTypeFilterChangedEvent;

  /// No description provided for @pgWifiFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_wifi_filter_changed'**
  String get pgWifiFilterChangedEvent;

  /// No description provided for @pgParkingFilterChangedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_parking_filter_changed'**
  String get pgParkingFilterChangedEvent;

  /// No description provided for @pgFiltersClearedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_filters_cleared'**
  String get pgFiltersClearedEvent;

  /// No description provided for @pgSavedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_saved'**
  String get pgSavedEvent;

  /// No description provided for @pgDeletedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_deleted'**
  String get pgDeletedEvent;

  /// No description provided for @pgNotFoundEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_not_found'**
  String get pgNotFoundEvent;

  /// No description provided for @pgViewedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_viewed'**
  String get pgViewedEvent;

  /// No description provided for @pgFetchErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_fetch_error'**
  String get pgFetchErrorEvent;

  /// No description provided for @pgSaveErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_save_error'**
  String get pgSaveErrorEvent;

  /// No description provided for @pgDeleteErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_delete_error'**
  String get pgDeleteErrorEvent;

  /// No description provided for @pgPhotoUploadedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_photo_uploaded'**
  String get pgPhotoUploadedEvent;

  /// No description provided for @pgPhotoUploadErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_photo_upload_error'**
  String get pgPhotoUploadErrorEvent;

  /// No description provided for @pgSearchPerformedEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_search_performed'**
  String get pgSearchPerformedEvent;

  /// No description provided for @pgSearchErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'pg_search_error'**
  String get pgSearchErrorEvent;

  /// No description provided for @ownerPgsFetchedEvent.
  ///
  /// In en, this message translates to:
  /// **'owner_pgs_fetched'**
  String get ownerPgsFetchedEvent;

  /// No description provided for @ownerPgsFetchErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'owner_pgs_fetch_error'**
  String get ownerPgsFetchErrorEvent;

  /// No description provided for @cityPgsFetchedEvent.
  ///
  /// In en, this message translates to:
  /// **'city_pgs_fetched'**
  String get cityPgsFetchedEvent;

  /// No description provided for @cityPgsFetchErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'city_pgs_fetch_error'**
  String get cityPgsFetchErrorEvent;

  /// No description provided for @amenityPgsFetchedEvent.
  ///
  /// In en, this message translates to:
  /// **'amenity_pgs_fetched'**
  String get amenityPgsFetchedEvent;

  /// No description provided for @amenityPgsFetchErrorEvent.
  ///
  /// In en, this message translates to:
  /// **'amenity_pgs_fetch_error'**
  String get amenityPgsFetchErrorEvent;

  /// No description provided for @failedToLoadPgs.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PGs: {error}'**
  String failedToLoadPgs(String error);

  /// No description provided for @failedToLoadPgDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PG details: {error}'**
  String failedToLoadPgDetails(String error);

  /// No description provided for @failedToSavePg.
  ///
  /// In en, this message translates to:
  /// **'Failed to save PG: {error}'**
  String failedToSavePg(String error);

  /// No description provided for @failedToDeletePg.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete PG: {error}'**
  String failedToDeletePg(String error);

  /// No description provided for @failedToLoadPgStats.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PG statistics: {error}'**
  String failedToLoadPgStats(String error);

  /// No description provided for @failedToUploadPgPhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload PG photo: {error}'**
  String failedToUploadPgPhoto(String error);

  /// No description provided for @failedToPerformPgSearch.
  ///
  /// In en, this message translates to:
  /// **'Failed to perform search: {error}'**
  String failedToPerformPgSearch(String error);

  /// No description provided for @failedToFetchPgDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PG details: {error}'**
  String failedToFetchPgDetails(String error);

  /// No description provided for @failedToSearchPgs.
  ///
  /// In en, this message translates to:
  /// **'Failed to search PGs: {error}'**
  String failedToSearchPgs(String error);

  /// No description provided for @failedToFetchOwnerPgs.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch owner PGs: {error}'**
  String failedToFetchOwnerPgs(String error);

  /// No description provided for @failedToFetchCityPgs.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch city PGs: {error}'**
  String failedToFetchCityPgs(String error);

  /// No description provided for @failedToFetchAmenityPgs.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch amenity PGs: {error}'**
  String failedToFetchAmenityPgs(String error);

  /// No description provided for @failedToGetPgStats.
  ///
  /// In en, this message translates to:
  /// **'Failed to get PG stats: {error}'**
  String failedToGetPgStats(String error);

  /// No description provided for @guestPgProviderInitializedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_provider_initialized'**
  String get guestPgProviderInitializedEvent;

  /// No description provided for @guestPgSelectedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selected'**
  String get guestPgSelectedEvent;

  /// No description provided for @guestPgClearedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_cleared'**
  String get guestPgClearedEvent;

  /// No description provided for @guestPgSelectionRestoredEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selection_restored'**
  String get guestPgSelectionRestoredEvent;

  /// No description provided for @guestPgSelectionRestoreFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selection_restore_failed'**
  String get guestPgSelectionRestoreFailedEvent;

  /// No description provided for @guestPgSelectionSavedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selection_saved'**
  String get guestPgSelectionSavedEvent;

  /// No description provided for @guestPgSelectionSaveFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selection_save_failed'**
  String get guestPgSelectionSaveFailedEvent;

  /// No description provided for @guestPgSelectionClearedStorageEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selection_cleared_storage'**
  String get guestPgSelectionClearedStorageEvent;

  /// No description provided for @guestPgSelectionClearFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_pg_selection_clear_failed'**
  String get guestPgSelectionClearFailedEvent;

  /// No description provided for @guestBookingRequestSentEvent.
  ///
  /// In en, this message translates to:
  /// **'guest_booking_request_sent'**
  String get guestBookingRequestSentEvent;

  /// No description provided for @bookingRequestNotificationFailedEvent.
  ///
  /// In en, this message translates to:
  /// **'booking_request_notification_failed'**
  String get bookingRequestNotificationFailedEvent;

  /// No description provided for @newBookingRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New Booking Request'**
  String get newBookingRequestTitle;

  /// No description provided for @newBookingRequestBody.
  ///
  /// In en, this message translates to:
  /// **'{guestName} requested to join {pgName}'**
  String newBookingRequestBody(String guestName, String pgName);

  /// No description provided for @failedToInitializeGuestPgSelection.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize PG selection: {error}'**
  String failedToInitializeGuestPgSelection(String error);

  /// No description provided for @failedToSelectGuestPg.
  ///
  /// In en, this message translates to:
  /// **'Failed to select PG: {error}'**
  String failedToSelectGuestPg(String error);

  /// No description provided for @failedToClearGuestPgSelection.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear PG selection: {error}'**
  String failedToClearGuestPgSelection(String error);

  /// No description provided for @failedToSendBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to send booking request: {error}'**
  String failedToSendBookingRequest(String error);

  /// No description provided for @failedToUpdateBookingStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update booking status: {error}'**
  String failedToUpdateBookingStatus(String error);

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get privacyPolicyLastUpdatedLabel;

  /// No description provided for @privacyPolicyLastUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'November 11, 2025'**
  String get privacyPolicyLastUpdatedDate;

  /// No description provided for @privacyPolicyHostedNotice.
  ///
  /// In en, this message translates to:
  /// **'You can review the most recent version online at {url}.'**
  String privacyPolicyHostedNotice(String url);

  /// No description provided for @privacyPolicyViewOnlineButton.
  ///
  /// In en, this message translates to:
  /// **'Open privacy policy website'**
  String get privacyPolicyViewOnlineButton;

  /// No description provided for @privacyPolicyOpenLinkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open privacy policy. Please try again later.'**
  String get privacyPolicyOpenLinkError;

  /// No description provided for @privacyPolicySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacyPolicySection1Title;

  /// No description provided for @privacyPolicySection1Content.
  ///
  /// In en, this message translates to:
  /// **'We collect information that you provide directly to us, including:\n• Account details (name, email address, profile photo, or other identifiers)\n• Communications such as support messages, feedback, and survey responses\n• Content you share, including uploads, media, and in-app inputs\n• Sensitive data only when you give explicit consent for a feature'**
  String get privacyPolicySection1Content;

  /// No description provided for @privacyPolicySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacyPolicySection2Title;

  /// No description provided for @privacyPolicySection2Content.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to:\n• Provide, operate, maintain, and improve the Services\n• Personalize your experience and deliver relevant content\n• Handle account creation, authentication, and customer support\n• Analyze usage trends, diagnose issues, and ensure service reliability\n• Send service announcements, security alerts, and updates\n• Enforce our terms, prevent abuse, and comply with legal obligations'**
  String get privacyPolicySection2Content;

  /// No description provided for @privacyPolicySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Information Sharing'**
  String get privacyPolicySection3Title;

  /// No description provided for @privacyPolicySection3Content.
  ///
  /// In en, this message translates to:
  /// **'We share personal data only when necessary:\n• With service providers that support hosting, analytics, payments, or security and are bound by confidentiality\n• To comply with applicable laws, regulations, or lawful requests\n• During a business transfer such as a merger, acquisition, or asset sale\n• With your consent or at your direction'**
  String get privacyPolicySection3Content;

  /// No description provided for @privacyPolicySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security'**
  String get privacyPolicySection4Title;

  /// No description provided for @privacyPolicySection4Content.
  ///
  /// In en, this message translates to:
  /// **'We deploy technical and organizational safeguards—encryption in transit, secure storage, access controls, and regular reviews—to protect your data. However, no transmission or storage system is completely secure, so we encourage you to use strong passwords and notify us of any suspected unauthorized activity.'**
  String get privacyPolicySection4Content;

  /// No description provided for @privacyPolicySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get privacyPolicySection5Title;

  /// No description provided for @privacyPolicySection5Content.
  ///
  /// In en, this message translates to:
  /// **'You can:\n• Request access to or a copy of the information we hold about you\n• Update or correct inaccurate data\n• Request deletion of your data, subject to legal retention requirements\n• Withdraw consent for optional data processing\n• Opt out of marketing and non-essential communications'**
  String get privacyPolicySection5Content;

  /// No description provided for @privacyPolicySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Contact Us'**
  String get privacyPolicySection6Title;

  /// No description provided for @privacyPolicySection6Content.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this Privacy Policy, please contact us at:\n\nEmail: bantirathodtech@gmail.com\nAddress: Hitech City, Hyderabad, Telangana, India 500083'**
  String get privacyPolicySection6Content;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @termsOfServiceLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get termsOfServiceLastUpdatedLabel;

  /// No description provided for @termsOfServiceLastUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'November 2025'**
  String get termsOfServiceLastUpdatedDate;

  /// No description provided for @termsOfServiceSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get termsOfServiceSection1Title;

  /// No description provided for @termsOfServiceSection1Content.
  ///
  /// In en, this message translates to:
  /// **'By accessing and using the Atitia app, you accept and agree to be bound by these Terms of Service. If you do not agree, please do not use our services.'**
  String get termsOfServiceSection1Content;

  /// No description provided for @termsOfServiceSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. User Accounts'**
  String get termsOfServiceSection2Title;

  /// No description provided for @termsOfServiceSection2Content.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for:\n• Maintaining the confidentiality of your account\n• All activities that occur under your account\n• Providing accurate and complete information'**
  String get termsOfServiceSection2Content;

  /// No description provided for @termsOfServiceSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Booking and Payments'**
  String get termsOfServiceSection3Title;

  /// No description provided for @termsOfServiceSection3Content.
  ///
  /// In en, this message translates to:
  /// **'• Booking requests are subject to owner approval\n• Payment terms are as agreed with the property owner\n• Refunds are subject to the property\'s cancellation policy\n• We facilitate transactions but are not a party to the rental agreement'**
  String get termsOfServiceSection3Content;

  /// No description provided for @termsOfServiceSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Property Owner Responsibilities'**
  String get termsOfServiceSection4Title;

  /// No description provided for @termsOfServiceSection4Content.
  ///
  /// In en, this message translates to:
  /// **'Property owners must:\n• Provide accurate property information\n• Honor confirmed bookings\n• Maintain property standards\n• Respond to guest inquiries promptly'**
  String get termsOfServiceSection4Content;

  /// No description provided for @termsOfServiceSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Prohibited Activities'**
  String get termsOfServiceSection5Title;

  /// No description provided for @termsOfServiceSection5Content.
  ///
  /// In en, this message translates to:
  /// **'You agree not to:\n• Use the service for illegal purposes\n• Post false or misleading information\n• Interfere with the app\'s functionality\n• Attempt unauthorized access to the system'**
  String get termsOfServiceSection5Content;

  /// No description provided for @termsOfServiceSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Limitation of Liability'**
  String get termsOfServiceSection6Title;

  /// No description provided for @termsOfServiceSection6Content.
  ///
  /// In en, this message translates to:
  /// **'Atitia provides the platform \"as is\" and is not liable for:\n• Disputes between guests and property owners\n• Property condition or safety issues\n• Payment disputes or refunds\n• Indirect or consequential damages'**
  String get termsOfServiceSection6Content;

  /// No description provided for @termsOfServiceSection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Changes to Terms'**
  String get termsOfServiceSection7Title;

  /// No description provided for @termsOfServiceSection7Content.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.'**
  String get termsOfServiceSection7Content;

  /// No description provided for @termsOfServiceSection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Contact Information'**
  String get termsOfServiceSection8Title;

  /// No description provided for @termsOfServiceSection8Content.
  ///
  /// In en, this message translates to:
  /// **'For questions about these Terms, contact us at:\n\nEmail: legal@atitia.com\nPhone: +91 1234567890'**
  String get termsOfServiceSection8Content;

  /// No description provided for @notificationPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferencesTitle;

  /// No description provided for @notificationPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which types of notifications you want to receive'**
  String get notificationPreferencesSubtitle;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationCategoryPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Notifications'**
  String get notificationCategoryPaymentTitle;

  /// No description provided for @notificationCategoryPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rent reminders, payment confirmations'**
  String get notificationCategoryPaymentSubtitle;

  /// No description provided for @notificationCategoryBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Updates'**
  String get notificationCategoryBookingTitle;

  /// No description provided for @notificationCategoryBookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmations, status changes'**
  String get notificationCategoryBookingSubtitle;

  /// No description provided for @notificationCategoryComplaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint Updates'**
  String get notificationCategoryComplaintTitle;

  /// No description provided for @notificationCategoryComplaintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint responses, resolution updates'**
  String get notificationCategoryComplaintSubtitle;

  /// No description provided for @notificationCategoryFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Notifications'**
  String get notificationCategoryFoodTitle;

  /// No description provided for @notificationCategoryFoodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Menu updates, special meals'**
  String get notificationCategoryFoodSubtitle;

  /// No description provided for @notificationCategoryMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Alerts'**
  String get notificationCategoryMaintenanceTitle;

  /// No description provided for @notificationCategoryMaintenanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled maintenance, repairs'**
  String get notificationCategoryMaintenanceSubtitle;

  /// No description provided for @notificationCategoryGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General Announcements'**
  String get notificationCategoryGeneralTitle;

  /// No description provided for @notificationCategoryGeneralSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Important updates, announcements'**
  String get notificationCategoryGeneralSubtitle;

  /// No description provided for @analyticsDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get analyticsDashboardTitle;

  /// No description provided for @performanceMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetricsTitle;

  /// No description provided for @noPerformanceMetricsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No performance metrics available'**
  String get noPerformanceMetricsAvailable;

  /// No description provided for @userJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'User Journey'**
  String get userJourneyTitle;

  /// No description provided for @userJourneyDescription.
  ///
  /// In en, this message translates to:
  /// **'Track user interactions and screen flows'**
  String get userJourneyDescription;

  /// No description provided for @viewJourneyDetails.
  ///
  /// In en, this message translates to:
  /// **'View Journey Details'**
  String get viewJourneyDetails;

  /// No description provided for @businessIntelligenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Intelligence'**
  String get businessIntelligenceTitle;

  /// No description provided for @metricTotalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get metricTotalSessions;

  /// No description provided for @metricActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get metricActiveUsers;

  /// No description provided for @metricConversionRate.
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate'**
  String get metricConversionRate;

  /// No description provided for @metricAverageSessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Avg Session Duration'**
  String get metricAverageSessionDuration;

  /// No description provided for @viewInsights.
  ///
  /// In en, this message translates to:
  /// **'View Insights'**
  String get viewInsights;

  /// No description provided for @userJourneyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'User Journey Details'**
  String get userJourneyDetailsTitle;

  /// No description provided for @userJourneyDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed user journey visualization would be implemented here with charts and flow diagrams.'**
  String get userJourneyDetailsDescription;

  /// No description provided for @businessInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Insights'**
  String get businessInsightsTitle;

  /// No description provided for @businessInsightsDescription.
  ///
  /// In en, this message translates to:
  /// **'Advanced business intelligence dashboard with charts, trends, and predictive analytics would be implemented here.'**
  String get businessInsightsDescription;

  /// No description provided for @analyticsWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsWidgetTitle;

  /// No description provided for @analyticsSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get analyticsSessionsLabel;

  /// No description provided for @analyticsAverageTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg Time'**
  String get analyticsAverageTimeLabel;

  /// No description provided for @networkErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get networkErrorTryAgain;

  /// No description provided for @permissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action.'**
  String get permissionDeniedMessage;

  /// No description provided for @itemNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The requested item could not be found.'**
  String get itemNotFoundMessage;

  /// No description provided for @requestTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get requestTimeoutMessage;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpiredMessage;

  /// No description provided for @invalidInputMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get invalidInputMessage;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericErrorMessage;

  /// No description provided for @requiredFieldError.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldError;

  /// No description provided for @invalidPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhoneError;

  /// No description provided for @fileSizeExceeded.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds maximum limit'**
  String get fileSizeExceeded;

  /// No description provided for @workspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspaceTitle;

  /// No description provided for @defaultCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Atitia PG Management'**
  String get defaultCompanyName;

  /// No description provided for @noSharingInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sharing info available.'**
  String get noSharingInfoAvailable;

  /// No description provided for @sharingAndVacancy.
  ///
  /// In en, this message translates to:
  /// **'Sharing & Vacancy'**
  String get sharingAndVacancy;

  /// No description provided for @sharingColumn.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get sharingColumn;

  /// No description provided for @roomsColumn.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get roomsColumn;

  /// No description provided for @vacantBedsColumn.
  ///
  /// In en, this message translates to:
  /// **'Vacant beds'**
  String get vacantBedsColumn;

  /// No description provided for @rentPerBedColumn.
  ///
  /// In en, this message translates to:
  /// **'Rent / bed'**
  String get rentPerBedColumn;

  /// No description provided for @vacantBedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get vacantBedsAvailable;

  /// No description provided for @sharingPricePerBed.
  ///
  /// In en, this message translates to:
  /// **'{amount}/bed'**
  String sharingPricePerBed(String amount);

  /// No description provided for @anonymousGuest.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Guest'**
  String get anonymousGuest;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @staffLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffLabel;

  /// No description provided for @viewPhotos.
  ///
  /// In en, this message translates to:
  /// **'View Photos'**
  String get viewPhotos;

  /// No description provided for @helpfulWithCount.
  ///
  /// In en, this message translates to:
  /// **'Helpful ({count})'**
  String helpfulWithCount(int count);

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @overallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallRating;

  /// No description provided for @aspectRatings.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratings'**
  String get aspectRatings;

  /// No description provided for @commentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsLabel;

  /// No description provided for @shareExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get shareExperienceHint;

  /// No description provided for @optionalAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Optional: Add photos to your review'**
  String get optionalAddPhotos;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting'**
  String get submitting;

  /// No description provided for @pleaseProvideOverallRating.
  ///
  /// In en, this message translates to:
  /// **'Please provide an overall rating'**
  String get pleaseProvideOverallRating;

  /// No description provided for @reviewSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully!'**
  String get reviewSubmittedSuccessfully;

  /// No description provided for @failedToSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit review: {error}'**
  String failedToSubmitReview(String error);

  /// No description provided for @ratingPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get ratingPoor;

  /// No description provided for @ratingFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ratingFair;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get ratingVeryGood;

  /// No description provided for @ratingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ratingExcellent;

  /// No description provided for @selectRating.
  ///
  /// In en, this message translates to:
  /// **'Select a rating'**
  String get selectRating;

  /// No description provided for @photosCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos ({count}/{max})'**
  String photosCountLabel(int count, int max);

  /// No description provided for @uploadingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Uploading photos...'**
  String get uploadingPhotos;

  /// No description provided for @errorPickingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Error picking photos: {error}'**
  String errorPickingPhotos(String error);

  /// No description provided for @allPhotoUploadsFailed.
  ///
  /// In en, this message translates to:
  /// **'All photo uploads failed. Please try again.'**
  String get allPhotoUploadsFailed;

  /// No description provided for @failedToUploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photos: {error}'**
  String failedToUploadPhotos(String error);

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @themeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Theme: {current}\nTap for {next}'**
  String themeTooltip(String current, String next);

  /// No description provided for @themeModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeTitle;

  /// No description provided for @themeLightDescription.
  ///
  /// In en, this message translates to:
  /// **'Always use bright theme'**
  String get themeLightDescription;

  /// No description provided for @themeDarkDescription.
  ///
  /// In en, this message translates to:
  /// **'Always use dark theme'**
  String get themeDarkDescription;

  /// No description provided for @themeSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow device settings'**
  String get themeSystemDescription;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @noPgSelected.
  ///
  /// In en, this message translates to:
  /// **'No PG Selected'**
  String get noPgSelected;

  /// No description provided for @uploadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadingStatus;

  /// No description provided for @documentUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadedSuccessfully;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tapToUpload;

  /// No description provided for @uploadSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG up to 10MB'**
  String get uploadSupportedFormats;

  /// No description provided for @unsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type: {type}'**
  String unsupportedFileType(String type);

  /// No description provided for @offlineActionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get offlineActionCreate;

  /// No description provided for @offlineActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get offlineActionUpdate;

  /// No description provided for @offlineActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get offlineActionDelete;

  /// No description provided for @offlineActionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get offlineActionSync;

  /// No description provided for @weekday_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekday_monday;

  /// No description provided for @weekday_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekday_tuesday;

  /// No description provided for @weekday_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekday_wednesday;

  /// No description provided for @weekday_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekday_thursday;

  /// No description provided for @weekday_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekday_friday;

  /// No description provided for @weekday_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekday_saturday;

  /// No description provided for @weekday_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekday_sunday;

  /// No description provided for @menuDefaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Default menu for {day} - customize as needed'**
  String menuDefaultDescription(String day);

  /// No description provided for @menuBreakfast_monday.
  ///
  /// In en, this message translates to:
  /// **'Idli with Sambar and Coconut Chutney|Vada (2 pieces)|Filter Coffee|Banana'**
  String get menuBreakfast_monday;

  /// No description provided for @menuBreakfast_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Masala Dosa with Sambar and Chutney|Medu Vada|Tea|Seasonal Fruit'**
  String get menuBreakfast_tuesday;

  /// No description provided for @menuBreakfast_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Upma with Coconut Chutney|Vada (2 pieces)|Coffee|Boiled Eggs (2)'**
  String get menuBreakfast_wednesday;

  /// No description provided for @menuBreakfast_thursday.
  ///
  /// In en, this message translates to:
  /// **'Poha with Peanuts and Curry Leaves|Banana Chips|Tea|Papaya'**
  String get menuBreakfast_thursday;

  /// No description provided for @menuBreakfast_friday.
  ///
  /// In en, this message translates to:
  /// **'Puri with Potato Bhaji|Halwa|Coffee|Orange'**
  String get menuBreakfast_friday;

  /// No description provided for @menuBreakfast_saturday.
  ///
  /// In en, this message translates to:
  /// **'Pesarattu (Green Gram Dosa) with Ginger Chutney|Upma|Tea|Seasonal Fruit'**
  String get menuBreakfast_saturday;

  /// No description provided for @menuBreakfast_sunday.
  ///
  /// In en, this message translates to:
  /// **'Special Breakfast - Pongal with Vada|Sweet Pongal|Filter Coffee|Banana'**
  String get menuBreakfast_sunday;

  /// No description provided for @menuLunch_monday.
  ///
  /// In en, this message translates to:
  /// **'Steamed Rice|Sambar|Rasam|Vegetable Curry (Beans Palya)|Curd|Papad|Buttermilk'**
  String get menuLunch_monday;

  /// No description provided for @menuLunch_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Steamed Rice|Dal Tadka|Rasam|Cabbage Poriyal|Brinjal Curry|Curd|Pickle'**
  String get menuLunch_tuesday;

  /// No description provided for @menuLunch_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Jeera Rice|Sambar|Rasam|Potato Fry|Spinach Dal|Curd|Papad'**
  String get menuLunch_wednesday;

  /// No description provided for @menuLunch_thursday.
  ///
  /// In en, this message translates to:
  /// **'Steamed Rice|Moong Dal|Rasam|Mixed Vegetable Curry|Beetroot Poriyal|Curd|Buttermilk'**
  String get menuLunch_thursday;

  /// No description provided for @menuLunch_friday.
  ///
  /// In en, this message translates to:
  /// **'Lemon Rice|Sambar|Rasam|Okra Fry (Bhendi)|Carrot Poriyal|Curd|Pickle'**
  String get menuLunch_friday;

  /// No description provided for @menuLunch_saturday.
  ///
  /// In en, this message translates to:
  /// **'Steamed Rice|Toor Dal|Rasam|Pumpkin Curry|Green Beans Poriyal|Curd|Papad'**
  String get menuLunch_saturday;

  /// No description provided for @menuLunch_sunday.
  ///
  /// In en, this message translates to:
  /// **'Special Lunch - Pulao|Sambar|Rasam|Paneer Butter Masala|Raita|Sweet (Payasam)|Papad'**
  String get menuLunch_sunday;

  /// No description provided for @menuDinner_monday.
  ///
  /// In en, this message translates to:
  /// **'Chapati (4 pieces)|Mixed Vegetable Curry|Dal Fry|Rice|Curd'**
  String get menuDinner_monday;

  /// No description provided for @menuDinner_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Chapati (4 pieces)|Palak Paneer|Dal Tadka|Rice|Pickle'**
  String get menuDinner_tuesday;

  /// No description provided for @menuDinner_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Paratha (3 pieces)|Aloo Gobi|Moong Dal|Rice|Curd'**
  String get menuDinner_wednesday;

  /// No description provided for @menuDinner_thursday.
  ///
  /// In en, this message translates to:
  /// **'Chapati (4 pieces)|Chana Masala|Tomato Rasam|Rice|Raita'**
  String get menuDinner_thursday;

  /// No description provided for @menuDinner_friday.
  ///
  /// In en, this message translates to:
  /// **'Puri (6 pieces)|Aloo Curry|Chana Dal|Rice|Curd'**
  String get menuDinner_friday;

  /// No description provided for @menuDinner_saturday.
  ///
  /// In en, this message translates to:
  /// **'Chapati (4 pieces)|Egg Curry (2 eggs)|Dal Tadka|Rice|Pickle'**
  String get menuDinner_saturday;

  /// No description provided for @menuDinner_sunday.
  ///
  /// In en, this message translates to:
  /// **'Special Dinner - Naan (3 pieces)|Paneer Tikka Masala|Dal Makhani|Jeera Rice|Raita|Gulab Jamun (2 pieces)'**
  String get menuDinner_sunday;

  /// No description provided for @menuMealTypeBreakfastDescription.
  ///
  /// In en, this message translates to:
  /// **'Morning meal (6:00 AM - 10:00 AM)'**
  String get menuMealTypeBreakfastDescription;

  /// No description provided for @menuMealTypeLunchDescription.
  ///
  /// In en, this message translates to:
  /// **'Afternoon meal (12:00 PM - 3:00 PM)'**
  String get menuMealTypeLunchDescription;

  /// No description provided for @menuMealTypeDinnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Evening meal (7:00 PM - 10:00 PM)'**
  String get menuMealTypeDinnerDescription;

  /// No description provided for @menuMealTypeGeneric.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get menuMealTypeGeneric;

  /// No description provided for @logButtonClicked.
  ///
  /// In en, this message translates to:
  /// **'Button clicked: {buttonName}'**
  String logButtonClicked(String buttonName);

  /// No description provided for @logFormSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Form submitted: {formName}'**
  String logFormSubmitted(String formName);

  /// No description provided for @logFilterChanged.
  ///
  /// In en, this message translates to:
  /// **'Filter changed: {filterType}'**
  String logFilterChanged(String filterType);

  /// No description provided for @logSearchPerformed.
  ///
  /// In en, this message translates to:
  /// **'Search performed'**
  String get logSearchPerformed;

  /// No description provided for @logScreenViewed.
  ///
  /// In en, this message translates to:
  /// **'Screen viewed: {screenName}'**
  String logScreenViewed(String screenName);

  /// No description provided for @logDataLoading.
  ///
  /// In en, this message translates to:
  /// **'Data loading: {dataType}'**
  String logDataLoading(String dataType);

  /// No description provided for @logErrorOperation.
  ///
  /// In en, this message translates to:
  /// **'Error in {operation}: {error}'**
  String logErrorOperation(String operation, String error);

  /// No description provided for @dateInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid date format. Expected {expected} but got \"{value}\"'**
  String dateInvalidFormat(String expected, String value);

  /// No description provided for @dateComponentsNotNumbers.
  ///
  /// In en, this message translates to:
  /// **'Date components must be valid numbers: \"{value}\"'**
  String dateComponentsNotNumbers(String value);

  /// No description provided for @dateInvalidCalendar.
  ///
  /// In en, this message translates to:
  /// **'Invalid calendar date: \"{value}\"'**
  String dateInvalidCalendar(String value);

  /// No description provided for @dateEnterAsExpected.
  ///
  /// In en, this message translates to:
  /// **'Enter date as {expected}'**
  String dateEnterAsExpected(String expected);

  /// No description provided for @dateDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Date must contain only digits'**
  String get dateDigitsOnly;

  /// No description provided for @dateCalendarInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid calendar date'**
  String get dateCalendarInvalid;

  /// No description provided for @dateGenericInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid date ({expected})'**
  String dateGenericInvalid(String expected);

  /// No description provided for @dateDayRange.
  ///
  /// In en, this message translates to:
  /// **'Day must be between 1 and 31'**
  String get dateDayRange;

  /// No description provided for @dateMonthRange.
  ///
  /// In en, this message translates to:
  /// **'Month must be between 1 and 12'**
  String get dateMonthRange;

  /// No description provided for @dateYearRange.
  ///
  /// In en, this message translates to:
  /// **'Year must be between {min} and {max}'**
  String dateYearRange(int min, int max);

  /// No description provided for @credentialInvalidWebClientId.
  ///
  /// In en, this message translates to:
  /// **'Invalid Google Web Client ID format'**
  String get credentialInvalidWebClientId;

  /// No description provided for @credentialStoredWebClientId.
  ///
  /// In en, this message translates to:
  /// **'Google Web Client ID stored in secure storage'**
  String get credentialStoredWebClientId;

  /// No description provided for @credentialStoreWebClientIdFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to store Google Web Client ID: {error}'**
  String credentialStoreWebClientIdFailure(String error);

  /// No description provided for @credentialInvalidAndroidClientId.
  ///
  /// In en, this message translates to:
  /// **'Invalid Google Android Client ID format'**
  String get credentialInvalidAndroidClientId;

  /// No description provided for @credentialStoredAndroidClientId.
  ///
  /// In en, this message translates to:
  /// **'Google Android Client ID stored in secure storage'**
  String get credentialStoredAndroidClientId;

  /// No description provided for @credentialStoreAndroidClientIdFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to store Google Android Client ID: {error}'**
  String credentialStoreAndroidClientIdFailure(String error);

  /// No description provided for @credentialInvalidIosClientId.
  ///
  /// In en, this message translates to:
  /// **'Invalid Google iOS Client ID format'**
  String get credentialInvalidIosClientId;

  /// No description provided for @credentialStoredIosClientId.
  ///
  /// In en, this message translates to:
  /// **'Google iOS Client ID stored in secure storage'**
  String get credentialStoredIosClientId;

  /// No description provided for @credentialStoreIosClientIdFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to store Google iOS Client ID: {error}'**
  String credentialStoreIosClientIdFailure(String error);

  /// No description provided for @credentialInvalidClientSecret.
  ///
  /// In en, this message translates to:
  /// **'Invalid Google Client Secret format'**
  String get credentialInvalidClientSecret;

  /// No description provided for @credentialStoredClientSecret.
  ///
  /// In en, this message translates to:
  /// **'Google Client Secret stored in secure storage'**
  String get credentialStoredClientSecret;

  /// No description provided for @credentialStoreClientSecretFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to store Google Client Secret: {error}'**
  String credentialStoreClientSecretFailure(String error);

  /// No description provided for @credentialClearedAll.
  ///
  /// In en, this message translates to:
  /// **'All Google OAuth credentials cleared from secure storage'**
  String get credentialClearedAll;

  /// No description provided for @credentialClearFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear credentials: {error}'**
  String credentialClearFailure(String error);

  /// No description provided for @credentialCheckFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to check stored credentials: {error}'**
  String credentialCheckFailure(String error);

  /// No description provided for @securityAuthFailureDescription.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed for user {userId}: {failureReason}'**
  String securityAuthFailureDescription(String userId, String failureReason);

  /// No description provided for @securityMultipleFailuresDetected.
  ///
  /// In en, this message translates to:
  /// **'Multiple failed authentication attempts detected for user {userId}'**
  String securityMultipleFailuresDetected(String userId);

  /// No description provided for @securityAuthSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Successful authentication for user {userId}'**
  String securityAuthSuccessDescription(String userId);

  /// No description provided for @securityMultipleFailuresAlertDescription.
  ///
  /// In en, this message translates to:
  /// **'Multiple failed authentication attempts for user {userId}'**
  String securityMultipleFailuresAlertDescription(String userId);

  /// No description provided for @securityEventConsoleLog.
  ///
  /// In en, this message translates to:
  /// **'Security Event: {eventType} - {description}'**
  String securityEventConsoleLog(String eventType, String description);

  /// No description provided for @securityEventSendFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to send security event to analytics: {error}'**
  String securityEventSendFailure(String error);

  /// No description provided for @securityAlertConsoleLog.
  ///
  /// In en, this message translates to:
  /// **'Security Alert [{severity}]: {alertType} - {description}'**
  String securityAlertConsoleLog(
      String severity, String alertType, String description);

  /// No description provided for @securityAlertSendFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to send security alert to services: {error}'**
  String securityAlertSendFailure(String error);

  /// No description provided for @securitySuspiciousHeader.
  ///
  /// In en, this message translates to:
  /// **'Suspicious header detected: {header}'**
  String securitySuspiciousHeader(String header);

  /// No description provided for @securitySuspiciousBody.
  ///
  /// In en, this message translates to:
  /// **'Suspicious content detected in request body'**
  String get securitySuspiciousBody;

  /// No description provided for @securityIpBlocked.
  ///
  /// In en, this message translates to:
  /// **'IP blocked: {ip}'**
  String securityIpBlocked(String ip);

  /// No description provided for @securityRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Rate limit exceeded'**
  String get securityRateLimitExceeded;

  /// No description provided for @securityInvalidHeaders.
  ///
  /// In en, this message translates to:
  /// **'Invalid request headers'**
  String get securityInvalidHeaders;

  /// No description provided for @securityInvalidBody.
  ///
  /// In en, this message translates to:
  /// **'Invalid request body'**
  String get securityInvalidBody;

  /// No description provided for @securityUnsupportedMethod.
  ///
  /// In en, this message translates to:
  /// **'Unsupported HTTP method: {method}'**
  String securityUnsupportedMethod(String method);

  /// No description provided for @securityRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed: {error}'**
  String securityRequestFailed(String error);

  /// No description provided for @securitySuspiciousResponseHeader.
  ///
  /// In en, this message translates to:
  /// **'Suspicious response header: {header}'**
  String securitySuspiciousResponseHeader(String header);

  /// No description provided for @securityServerErrorResponse.
  ///
  /// In en, this message translates to:
  /// **'Server error response: {statusCode}'**
  String securityServerErrorResponse(String statusCode);

  /// No description provided for @encryptionEncryptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to encrypt data: {error}'**
  String encryptionEncryptFailed(String error);

  /// No description provided for @encryptionDecryptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt data: {error}'**
  String encryptionDecryptFailed(String error);

  /// No description provided for @encryptionFileEncryptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to encrypt file data: {error}'**
  String encryptionFileEncryptFailed(String error);

  /// No description provided for @encryptionFileDecryptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt file data: {error}'**
  String encryptionFileDecryptFailed(String error);

  /// No description provided for @securityInvalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get securityInvalidEmailFormat;

  /// No description provided for @securityInvalidPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get securityInvalidPhoneFormat;

  /// No description provided for @secureStorageStoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store secure data: {error}'**
  String secureStorageStoreFailed(String error);

  /// No description provided for @secureStorageRetrieveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve secure data: {error}'**
  String secureStorageRetrieveFailed(String error);

  /// No description provided for @secureStorageStoreCredentialsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store user credentials: {error}'**
  String secureStorageStoreCredentialsFailed(String error);

  /// No description provided for @secureStorageRetrieveCredentialsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve user credentials: {error}'**
  String secureStorageRetrieveCredentialsFailed(String error);

  /// No description provided for @secureStorageStoreAuthTokenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store auth token: {error}'**
  String secureStorageStoreAuthTokenFailed(String error);

  /// No description provided for @secureStorageRetrieveAuthTokenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve auth token: {error}'**
  String secureStorageRetrieveAuthTokenFailed(String error);

  /// No description provided for @secureStorageStoreSessionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store user session: {error}'**
  String secureStorageStoreSessionFailed(String error);

  /// No description provided for @secureStorageRetrieveSessionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve user session: {error}'**
  String secureStorageRetrieveSessionFailed(String error);

  /// No description provided for @secureStorageStoreProfileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store user profile: {error}'**
  String secureStorageStoreProfileFailed(String error);

  /// No description provided for @secureStorageRetrieveProfileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve user profile: {error}'**
  String secureStorageRetrieveProfileFailed(String error);

  /// No description provided for @secureStorageStoreApiKeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store API key: {error}'**
  String secureStorageStoreApiKeyFailed(String error);

  /// No description provided for @secureStorageRetrieveApiKeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve API key: {error}'**
  String secureStorageRetrieveApiKeyFailed(String error);

  /// No description provided for @secureStorageStorePaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store payment info: {error}'**
  String secureStorageStorePaymentFailed(String error);

  /// No description provided for @secureStorageRetrievePaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve payment info: {error}'**
  String secureStorageRetrievePaymentFailed(String error);

  /// No description provided for @secureStorageStoreBiometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store biometric data: {error}'**
  String secureStorageStoreBiometricFailed(String error);

  /// No description provided for @secureStorageRetrieveBiometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve biometric data: {error}'**
  String secureStorageRetrieveBiometricFailed(String error);

  /// No description provided for @secureStorageStoreDeviceSecurityFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to store device security data: {error}'**
  String secureStorageStoreDeviceSecurityFailed(String error);

  /// No description provided for @secureStorageRetrieveDeviceSecurityFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve device security data: {error}'**
  String secureStorageRetrieveDeviceSecurityFailed(String error);

  /// No description provided for @secureStorageDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete secure data: {error}'**
  String secureStorageDeleteFailed(String error);

  /// No description provided for @secureStorageDeleteAllFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete all secure data: {error}'**
  String secureStorageDeleteAllFailed(String error);

  /// No description provided for @secureStorageGetKeysFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to get all keys: {error}'**
  String secureStorageGetKeysFailed(String error);

  /// No description provided for @secureStorageClearUserDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear user data: {error}'**
  String secureStorageClearUserDataFailed(String error);

  /// No description provided for @secureStorageGetStatsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to get storage stats: {error}'**
  String secureStorageGetStatsFailed(String error);

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationInvalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get validationInvalidEmailFormat;

  /// No description provided for @validationEmailInvalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailInvalidAddress;

  /// No description provided for @validationEmailTooLong.
  ///
  /// In en, this message translates to:
  /// **'Email address is too long'**
  String get validationEmailTooLong;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationInvalidPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get validationInvalidPhoneFormat;

  /// No description provided for @validationPhoneLength.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get validationPhoneLength;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Indian phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationInvalidNameFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid name format'**
  String get validationInvalidNameFormat;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get validationNameTooShort;

  /// No description provided for @validationNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be less than {max} characters'**
  String validationNameTooLong(String max);

  /// No description provided for @validationNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Name can only contain letters and spaces'**
  String get validationNameInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationInvalidPasswordFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid password format'**
  String get validationInvalidPasswordFormat;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String validationPasswordTooShort(String min);

  /// No description provided for @validationPasswordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password is too long'**
  String get validationPasswordTooLong;

  /// No description provided for @validationPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get validationPasswordUppercase;

  /// No description provided for @validationPasswordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get validationPasswordLowercase;

  /// No description provided for @validationPasswordDigit.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validationPasswordDigit;

  /// No description provided for @validationPasswordSpecial.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get validationPasswordSpecial;

  /// No description provided for @validationPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password must include uppercase, lowercase, number, and special character'**
  String get validationPasswordStrength;

  /// No description provided for @validationOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get validationOtpRequired;

  /// No description provided for @validationInvalidOtpFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP format'**
  String get validationInvalidOtpFormat;

  /// No description provided for @validationOtpLength.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get validationOtpLength;

  /// No description provided for @validationOtpDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'OTP must contain only digits'**
  String get validationOtpDigitsOnly;

  /// No description provided for @validationAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get validationAddressRequired;

  /// No description provided for @validationInvalidAddressFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid address format'**
  String get validationInvalidAddressFormat;

  /// No description provided for @validationAddressTooShort.
  ///
  /// In en, this message translates to:
  /// **'Address must be at least 10 characters'**
  String get validationAddressTooShort;

  /// No description provided for @validationAddressTooLong.
  ///
  /// In en, this message translates to:
  /// **'Address must be less than 200 characters'**
  String get validationAddressTooLong;

  /// No description provided for @validationAadhaarRequired.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number is required'**
  String get validationAadhaarRequired;

  /// No description provided for @validationInvalidAadhaarFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid Aadhaar number format'**
  String get validationInvalidAadhaarFormat;

  /// No description provided for @validationAadhaarLength.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number must be 12 digits'**
  String get validationAadhaarLength;

  /// No description provided for @validationPanRequired.
  ///
  /// In en, this message translates to:
  /// **'PAN number is required'**
  String get validationPanRequired;

  /// No description provided for @validationInvalidPanFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid PAN number format'**
  String get validationInvalidPanFormat;

  /// No description provided for @validationPanInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid PAN number'**
  String get validationPanInvalid;

  /// No description provided for @validationFileRequired.
  ///
  /// In en, this message translates to:
  /// **'File is required'**
  String get validationFileRequired;

  /// No description provided for @validationFileMissing.
  ///
  /// In en, this message translates to:
  /// **'File does not exist'**
  String get validationFileMissing;

  /// No description provided for @validationFileSizeExceeded.
  ///
  /// In en, this message translates to:
  /// **'File size must be less than {max}MB'**
  String validationFileSizeExceeded(String max);

  /// No description provided for @validationFileTypeNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'File type not allowed. Allowed types: {types}'**
  String validationFileTypeNotAllowed(String types);

  /// No description provided for @validationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationFieldRequired;

  /// No description provided for @validationFieldNameRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationFieldNameRequired(String field);

  /// No description provided for @validationInvalidTextFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid text format'**
  String get validationInvalidTextFormat;

  /// No description provided for @validationTextTooShort.
  ///
  /// In en, this message translates to:
  /// **'Text must be at least {min} characters'**
  String validationTextTooShort(String min);

  /// No description provided for @validationTextTooLong.
  ///
  /// In en, this message translates to:
  /// **'Text must be less than {max} characters'**
  String validationTextTooLong(String max);

  /// No description provided for @validationFieldMinLength.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {min} characters'**
  String validationFieldMinLength(String field, String min);

  /// No description provided for @validationFieldMaxLength.
  ///
  /// In en, this message translates to:
  /// **'{field} must be less than {max} characters'**
  String validationFieldMaxLength(String field, String max);

  /// No description provided for @validationFieldMustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'{field} must be a valid number'**
  String validationFieldMustBeNumber(String field);

  /// No description provided for @validationFieldMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'{field} must be greater than zero'**
  String validationFieldMustBeGreaterThanZero(String field);

  /// No description provided for @validationFileSizeExceededDetailed.
  ///
  /// In en, this message translates to:
  /// **'{fileType}File size must be less than {max}MB'**
  String validationFileSizeExceededDetailed(String fileType, String max);

  /// No description provided for @validationInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get validationInvalidInput;

  /// No description provided for @validationDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get validationDobRequired;

  /// No description provided for @validationDobFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter date in DD/MM/YYYY format'**
  String get validationDobFormat;

  /// No description provided for @validationDobInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date format'**
  String get validationDobInvalidDate;

  /// No description provided for @validationDobFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future'**
  String get validationDobFuture;

  /// No description provided for @validationDobMinimumAge.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old'**
  String get validationDobMinimumAge;

  /// No description provided for @validationDobInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get validationDobInvalid;

  /// No description provided for @appExceptionDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get appExceptionDefaultMessage;

  /// No description provided for @appExceptionDefaultRecovery.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get appExceptionDefaultRecovery;

  /// No description provided for @appExceptionDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get appExceptionDetailsLabel;

  /// No description provided for @appExceptionSuggestionLabel.
  ///
  /// In en, this message translates to:
  /// **'💡 Suggestion'**
  String get appExceptionSuggestionLabel;

  /// No description provided for @networkExceptionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkExceptionPrefix;

  /// No description provided for @networkExceptionMessage.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get networkExceptionMessage;

  /// No description provided for @networkExceptionRecovery.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get networkExceptionRecovery;

  /// No description provided for @authExceptionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Auth Error'**
  String get authExceptionPrefix;

  /// No description provided for @authExceptionMessage.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authExceptionMessage;

  /// No description provided for @authExceptionRecovery.
  ///
  /// In en, this message translates to:
  /// **'Please check your credentials and try again'**
  String get authExceptionRecovery;

  /// No description provided for @dataParsingExceptionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Parsing Error'**
  String get dataParsingExceptionPrefix;

  /// No description provided for @dataParsingExceptionMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse data'**
  String get dataParsingExceptionMessage;

  /// No description provided for @dataParsingExceptionRecovery.
  ///
  /// In en, this message translates to:
  /// **'Please try again or contact support if the problem persists'**
  String get dataParsingExceptionRecovery;

  /// No description provided for @configurationExceptionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Config Error'**
  String get configurationExceptionPrefix;

  /// No description provided for @configurationExceptionMessage.
  ///
  /// In en, this message translates to:
  /// **'Configuration error'**
  String get configurationExceptionMessage;

  /// No description provided for @configurationExceptionRecovery.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app or contact support'**
  String get configurationExceptionRecovery;

  /// No description provided for @validationExceptionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationExceptionPrefix;

  /// No description provided for @validationExceptionMessage.
  ///
  /// In en, this message translates to:
  /// **'Validation failed for {field}'**
  String validationExceptionMessage(String field);

  /// No description provided for @validationExceptionRecovery.
  ///
  /// In en, this message translates to:
  /// **'Please check the entered information'**
  String get validationExceptionRecovery;

  /// No description provided for @imagePickerMultipleSelectionError.
  ///
  /// In en, this message translates to:
  /// **'Multiple image selection not available, error: {error}'**
  String imagePickerMultipleSelectionError(String error);

  /// No description provided for @validationFieldDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get validationFieldDefaultName;

  /// No description provided for @fileTypeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get fileTypeProfilePhoto;

  /// No description provided for @fileTypeAadhaarDocument.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar document'**
  String get fileTypeAadhaarDocument;

  /// No description provided for @performanceReportTitle.
  ///
  /// In en, this message translates to:
  /// **'=== PERFORMANCE REPORT ==='**
  String get performanceReportTitle;

  /// No description provided for @performanceReportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated: {timestamp}'**
  String performanceReportGenerated(String timestamp);

  /// No description provided for @performanceReportOperation.
  ///
  /// In en, this message translates to:
  /// **'Operation: {operation}'**
  String performanceReportOperation(String operation);

  /// No description provided for @performanceReportCount.
  ///
  /// In en, this message translates to:
  /// **'  Count: {count}'**
  String performanceReportCount(String count);

  /// No description provided for @performanceReportMin.
  ///
  /// In en, this message translates to:
  /// **'  Min: {value}'**
  String performanceReportMin(String value);

  /// No description provided for @performanceReportMax.
  ///
  /// In en, this message translates to:
  /// **'  Max: {value}'**
  String performanceReportMax(String value);

  /// No description provided for @performanceReportAverage.
  ///
  /// In en, this message translates to:
  /// **'  Average: {value}'**
  String performanceReportAverage(String value);

  /// No description provided for @performanceReportMedian.
  ///
  /// In en, this message translates to:
  /// **'  Median: {value}'**
  String performanceReportMedian(String value);

  /// No description provided for @guestPgStartingLoad.
  ///
  /// In en, this message translates to:
  /// **'Starting to load PGs'**
  String get guestPgStartingLoad;

  /// No description provided for @guestPgLoadSuccess.
  ///
  /// In en, this message translates to:
  /// **'PGs loaded successfully'**
  String get guestPgLoadSuccess;

  /// No description provided for @guestPgLoadFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PGs'**
  String get guestPgLoadFailure;

  /// No description provided for @guestPgRefreshAction.
  ///
  /// In en, this message translates to:
  /// **'Refresh PGs'**
  String get guestPgRefreshAction;

  /// No description provided for @guestPgSelectedAction.
  ///
  /// In en, this message translates to:
  /// **'PG Selected'**
  String get guestPgSelectedAction;

  /// No description provided for @guestPgClearSelectionAction.
  ///
  /// In en, this message translates to:
  /// **'Clear Selected PG'**
  String get guestPgClearSelectionAction;

  /// No description provided for @guestPgSearchQueryChangedAction.
  ///
  /// In en, this message translates to:
  /// **'Search Query Changed'**
  String get guestPgSearchQueryChangedAction;

  /// No description provided for @ownerMenuEditLogTotalItems.
  ///
  /// In en, this message translates to:
  /// **'   - Total items: {count}'**
  String ownerMenuEditLogTotalItems(int count);

  /// No description provided for @ownerMenuEditLogUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Menu updated successfully!'**
  String get ownerMenuEditLogUpdateSuccess;

  /// No description provided for @ownerMenuEditLogCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Menu created successfully!'**
  String get ownerMenuEditLogCreateSuccess;

  /// No description provided for @ownerSettingsBuildNumberValue.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get ownerSettingsBuildNumberValue;

  /// No description provided for @ownerSettingsAppVersionValue.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get ownerSettingsAppVersionValue;

  /// No description provided for @ownerOverviewOwnerFallback.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerOverviewOwnerFallback;
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
