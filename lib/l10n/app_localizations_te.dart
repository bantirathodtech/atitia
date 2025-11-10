// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

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
  String get booking => 'బుకింగ్';

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
  String get confirm => 'నిర్ధారించండి';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get back => 'వెనక్కి';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get search => 'శోధన';

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
    return 'దోషం: $error';
  }

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించు';

  @override
  String get tryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get goBack => 'వెనక్కి వెళ్లండి';

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
  String get city => 'నగరం';

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
  String get failed => 'విఫలమైనవి';

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
  String get appInitializationIssue => 'అనువర్తన ప్రారంభ సమస్య';

  @override
  String get troubleConnectingServices =>
      'మేము మా సేవలకు కనెక్ట్ అవడంలో సమస్యలను ఎదుర్కొంటున్నాము. ఇది నెట్‌వర్క్ సమస్యలు లేదా నిర్వహణ కారణంగా కావచ్చు.';

  @override
  String get exit => 'నిష్క్రమించు';

  @override
  String get pageNotFound => 'పేజీ కనుగొనబడలేదు';

  @override
  String get pageNotFoundDescription =>
      'మీరు వెతుకుతున్న పేజీ ఉనికిలో లేదు లేదా తరలించబడింది.';

  @override
  String loginAs(String role) {
    return '$roleగా ప్రవేశించండి';
  }

  @override
  String get logApiResponseLabel => 'ప్రత్యుత్తరం';

  @override
  String logAuthEventMessage(String event) {
    return 'ప్రామాణీకరణ: $event';
  }

  @override
  String logRoleActionMessage(String role, String action) {
    return '$role చర్య: $action';
  }

  @override
  String logPgActionMessage(String action) {
    return 'PG $action';
  }

  @override
  String logPaymentEventMessage(String event) {
    return 'చెల్లింపు: $event';
  }

  @override
  String logFoodActionMessage(String action) {
    return 'ఆహారం $action';
  }

  @override
  String logComplaintEventMessage(String event) {
    return 'ఫిర్యాదు: $event';
  }

  @override
  String logGuestActionMessage(String action) {
    return 'అతిథి $action';
  }

  @override
  String logOwnerActionMessage(String action) {
    return 'యజమాని $action';
  }

  @override
  String logMethodEntryMessage(String methodName) {
    return '$methodName లో ప్రవేశిస్తున్నాం';
  }

  @override
  String logMethodExitMessage(String methodName) {
    return '$methodName నుండి బయటకు వస్తున్నాం';
  }

  @override
  String logPerformanceMessage(String operation, int durationMs) {
    return 'పనితీరు: $operation పూర్తి కావడానికి ${durationMs}ms పట్టింది';
  }

  @override
  String logBusinessEventMessage(String event) {
    return 'వ్యాపార ఈవెంట్: $event';
  }

  @override
  String get enterPhoneNumberToReceiveOTP =>
      'OTP స్వీకరించడానికి మీ ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get tenDigitMobileNumber => '10 అంకెల మొబైల్ నంబర్';

  @override
  String get phoneAuthentication => 'ఫోన్ ప్రామాణీకరణ';

  @override
  String get notAvailableOnMacOS =>
      'macOSలో అందుబాటులో లేదు. దయచేసి క్రింద Google Sign-Inని ఉపయోగించండి.';

  @override
  String get sixDigitCode => '6 అంకెల కోడ్';

  @override
  String get pleaseEnterSixDigitCode =>
      'దయచేసి మీ ఫోన్‌కు పంపిన 6 అంకెల కోడ్‌ను నమోదు చేయండి';

  @override
  String get completeYourProfile => 'మీ ప్రొఫైల్‌ను పూర్తి చేయండి';

  @override
  String get personal => 'వ్యక్తిగత';

  @override
  String get documents => 'పత్రాలు';

  @override
  String get emergency => 'అత్యవసర';

  @override
  String get areYouSureYouWantToLogout =>
      'మీరు లాగ్ అవుట్ చేయాలని ఖచ్చితంగా అనుకుంటున్నారా?';

  @override
  String get loggedOutSuccessfully => 'విజయవంతంగా లాగ్ అవుట్ చేయబడింది';

  @override
  String get logoutFailed => 'లాగ్ అవుట్ విఫలమైంది';

  @override
  String get switchAccount => 'ఖాతాను మార్చండి';

  @override
  String switchAccountConfirmation(String currentRole, String newRole) {
    return 'మీరు $currentRole నుండి $newRole ఖాతాకు మారాలని ఖచ్చితంగా అనుకుంటున్నారా?\n\nమీరు కొత్త పాత్ర కోసం నమోదును పూర్తి చేయాలి.';
  }

  @override
  String switchedToAccount(String role) {
    return '$role ఖాతాకు మార్చబడింది. దయచేసి మీ నమోదును పూర్తి చేయండి.';
  }

  @override
  String get switchButton => 'మార్చండి';

  @override
  String get role => 'పాత్ర';

  @override
  String get verifiedOwner => 'ధృవీకరించబడిన యజమాని';

  @override
  String get pendingVerification => 'పెండింగ్ ధృవీకరణ';

  @override
  String get pgManagementSystem => 'PG నిర్వహణ వ్యవస్థ';

  @override
  String get madeWithLoveByAtitiaTeam => 'Atitia టీమ్ చేత ❤️తో తయారు చేయబడింది';

  @override
  String get version => 'వెర్షన్';

  @override
  String get poweredByCharyatani => 'Charyatani ద్వారా పవర్ చేయబడింది';

  @override
  String get chooseHowYouWantToUseTheApp =>
      'మీరు అనువర్తనాన్ని ఎలా ఉపయోగించాలనుకుంటున్నారో ఎంచుకోండి';

  @override
  String get findAndBookPgAccommodations =>
      'PG వసతి సౌకర్యాలను కనుగొని బుక్ చేయండి';

  @override
  String get manageYourPgPropertiesAndGuests =>
      'మీ PG ఆస్తులు మరియు అతిథులను నిర్వహించండి';

  @override
  String get requestTimedOutPleaseTryAgain =>
      'అభ్యర్థన సమయం ముగిసింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get googleSignInOnWebRequiresButton =>
      'వెబ్‌లో Google సైన్-ఇన్ సైన్-ఇన్ బటన్ అవసరం. దయచేసి పైన ఉన్న Google సైన్-ఇన్ బటన్‌ను ఉపయోగించండి.';

  @override
  String get googleSignInTimedOut =>
      'Google సైన్-ఇన్ సమయం ముగిసింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String googleSignInFailed(String error) {
    return 'Google సైన్-ఇన్ విఫలమైంది: $error';
  }

  @override
  String get briefDescriptionOfYourComplaint =>
      'మీ ఫిర్యాదు యొక్క సంక్షిప్త వివరణ';

  @override
  String get detailedDescriptionOfYourComplaint =>
      'మీ ఫిర్యాదు లేదా అభ్యర్థన యొక్క వివరణాత్మక వివరణ';

  @override
  String get subjectRequired => 'విషయం అవసరం';

  @override
  String get descriptionRequired => 'వివరణ అవసరం';

  @override
  String get imageAttachment => 'చిత్ర అటాచ్‌మెంట్';

  @override
  String get attachImage => 'చిత్రాన్ని అటాచ్ చేయండి';

  @override
  String get removeImage => 'చిత్రాన్ని తీసివేయండి';

  @override
  String get requestTimedOut => 'అభ్యర్థన సమయం ముగిసింది';

  @override
  String get pleaseTryAgain => 'దయచేసి మళ్లీ ప్రయత్నించండి';

  @override
  String get phoneNumberIsRequired => 'ఫోన్ నంబర్ అవసరం';

  @override
  String get pleaseEnterValid10DigitPhoneNumber =>
      'దయచేసి చెల్లుబాటు అయ్యే 10 అంకెల ఫోన్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get otpIsRequired => 'OTP అవసరం';

  @override
  String get otpMustBe6Digits => 'OTP 6 అంకెలు ఉండాలి';

  @override
  String get otpMustContainOnlyDigits => 'OTPలో సంఖ్యలు మాత్రమే ఉండాలి';

  @override
  String get authenticationFailedPleaseSelectCorrectRole =>
      'ప్రామాణీకరణ విఫలమైంది. దయచేసి సరైన పాత్రను ఎంచుకోండి.';

  @override
  String get userDataNotFound => 'వినియోగదారు డేటా కనుగొనబడలేదు';

  @override
  String get invalidUserRolePleaseSelectRole =>
      'చెల్లని వినియోగదారు పాత్ర. దయచేసి పాత్రను ఎంచుకోండి.';

  @override
  String verificationFailed(String error) {
    return 'ధృవీకరణ విఫలమైంది: $error';
  }

  @override
  String googleSignInFailedError(String error) {
    return 'Google సైన్-ఇన్ విఫలమైంది: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'చిత్రాన్ని ఎంచుకోవడంలో దోషం: $error';
  }

  @override
  String get otpSentSuccessfullyPleaseCheckYourPhone =>
      'OTP విజయవంతంగా పంపబడింది! దయచేసి మీ ఫోన్‌ను తనిఖీ చేయండి.';

  @override
  String get failedToSendOtpPleaseTryAgain =>
      'OTP పంపడంలో విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get tooManyRequestsPleaseWaitFewMinutes =>
      'చాలా అభ్యర్థనలు. దయచేసి మళ్లీ ప్రయత్నించే ముందు కొన్ని నిమిషాలు వేచి ఉండండి.';

  @override
  String get smsServiceTemporarilyUnavailable =>
      'SMS సేవ తాత్కాలికంగా అందుబాటులో లేదు. దయచేసి తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get securityVerificationFailedPleaseTryAgain =>
      'భద్రత ధృవీకరణ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get optional => 'ఐచ్ఛికం';

  @override
  String get attachPhotosOptional => 'ఫోటోలను అటాచ్ చేయండి (ఐచ్ఛికం)';

  @override
  String get userNotAuthenticated => 'వినియోగదారు ప్రామాణీకరించబడలేదు';

  @override
  String get complaintSubmittedSuccessfully =>
      'ఫిర్యాదు విజయవంతంగా సమర్పించబడింది';

  @override
  String get submissionFailed => 'సమర్పణ విఫలమైంది';

  @override
  String get submitNewComplaint => 'కొత్త ఫిర్యాదును సమర్పించండి';

  @override
  String get submitComplaint => 'ఫిర్యాదును సమర్పించండి';

  @override
  String get personalInformation => 'వ్యక్తిగత సమాచారం';

  @override
  String get yourRegisteredPhoneNumber => 'మీ నమోదు చేసిన ఫోన్ నంబర్';

  @override
  String get verifiedDuringLogin => '✓ లాగిన్ సమయంలో ధృవీకరించబడింది';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get fullNameIsRequired => 'పూర్తి పేరు అవసరం';

  @override
  String get nameMustBeAtLeast3Characters => 'పేరు కనీసం 3 అక్షరాలు ఉండాలి';

  @override
  String get dateOfBirth => 'పుట్టిన తేదీ';

  @override
  String get gender => 'లింగం';

  @override
  String get male => 'పురుషుడు';

  @override
  String get female => 'స్త్రీ';

  @override
  String get aadhaarNumberIsRequired => 'ఆధార్ నంబర్ అవసరం';

  @override
  String get aadhaarMustBe12Digits => 'ఆధార్ 12 అంకెలు ఉండాలి';

  @override
  String get aadhaarMustContainOnlyDigits => 'ఆధార్‌లో సంఖ్యలు మాత్రమే ఉండాలి';

  @override
  String get aadhaarDocumentUploadedSuccessfully =>
      'ఆధార్ పత్రం విజయవంతంగా అప్‌లోడ్ చేయబడింది!';

  @override
  String get contactNameIsRequired => 'సంప్రదింపు పేరు అవసరం';

  @override
  String get contactPhoneIsRequired => 'సంప్రదింపు ఫోన్ అవసరం';

  @override
  String get pleaseSelectRelationship => 'దయచేసి సంబంధాన్ని ఎంచుకోండి';

  @override
  String get contactAddressOptional => 'సంప్రదింపు చిరునామా (ఐచ్ఛికం)';

  @override
  String get allRequiredFieldsCompletedReadyToSubmit =>
      'అన్ని అవసరమైన ఫీల్డ్‌లు పూర్తయ్యాయి! సమర్పించడానికి సిద్ధంగా ఉంది.';

  @override
  String get pleaseProvideYourDetailsAsPerOfficialDocuments =>
      'దయచేసి మీ అధికారిక పత్రాల ప్రకారం మీ వివరాలను అందించండి';

  @override
  String get profilePhoto => 'ప్రొఫైల్ ఫోటో';

  @override
  String get aadhaarDocument => 'ఆధార్ పత్రం';

  @override
  String get yourDocumentsAreSecurelyStored =>
      'మీ పత్రాలు సురక్షితంగా నిల్వ చేయబడతాయి మరియు ధృవీకరణ ప్రయోజనాల కోసం మాత్రమే ఉపయోగించబడతాయి';

  @override
  String get provideDetailsOfSomeoneWeCanContact =>
      'అత్యవసర సమయంలో మేము సంప్రదింపు చేయగల వ్యక్తి యొక్క వివరాలను అందించండి';

  @override
  String get continueButton => 'కొనసాగించు';

  @override
  String get finish => 'పూర్తి చేయండి';

  @override
  String get profileUpdatedSuccessfully => 'ప్రొఫైల్ విజయవంతంగా నవీకరించబడింది';

  @override
  String get errorUpdatingProfile => 'ప్రొఫైల్‌ను నవీకరించడంలో దోషం';

  @override
  String get pgs => 'PGs';

  @override
  String get foods => 'ఆహారం';

  @override
  String get requests => 'అభ్యర్థనలు';

  @override
  String get browsePgAccommodations => 'PG వసతులను బ్రౌజ్ చేయండి';

  @override
  String get viewFoodMenu => 'ఆహార మెనూను వీక్షించండి';

  @override
  String get paymentHistory => 'చెల్లింపు చరిత్ర';

  @override
  String get bookingRequests => 'బుకింగ్ అభ్యర్థనలు';

  @override
  String get complaintsAndRequests => 'ఫిర్యాదులు మరియు అభ్యర్థనలు';

  @override
  String get findYourPg => 'మీ PGని కనుగొనండి';

  @override
  String get searchAndFilters => 'శోధన మరియు ఫిల్టర్‌లు';

  @override
  String get hideFilters => 'ఫిల్టర్‌లను దాచండి';

  @override
  String get showFilters => 'ఫిల్టర్‌లను చూపించండి';

  @override
  String get pgsAvailable => 'PGs అందుబాటులో ఉన్నాయి';

  @override
  String get cities => 'నగరాలు';

  @override
  String get amenities => 'సౌకర్యాలు';

  @override
  String get searchByNameCityArea => 'పేరు, నగరం, ప్రాంతం ద్వారా శోధించండి...';

  @override
  String get filters => 'ఫిల్టర్‌లు';

  @override
  String get clearAll => 'అన్నీ తొలగించు';

  @override
  String get activeFilters => 'క్రియాశీల ఫిల్టర్‌లు';

  @override
  String get noPgsFound => 'PGs కనుగొనబడలేదు';

  @override
  String get noPgsFoundDescription =>
      'మరిన్ని ఎంపికలను కనుగొనడానికి మీ శోధన లేదా ఫిల్టర్‌లను సర్దుబాటు చేయండి.';

  @override
  String get monday => 'సోమవారం';

  @override
  String get tuesday => 'మంగళవారం';

  @override
  String get wednesday => 'బుధవారం';

  @override
  String get thursday => 'గురువారం';

  @override
  String get friday => 'శుక్రవారం';

  @override
  String get saturday => 'శనివారం';

  @override
  String get sunday => 'ఆదివారం';

  @override
  String get breakfast => 'ఉదయ భోజనం';

  @override
  String get lunch => 'మధ్యాహ్న భోజనం';

  @override
  String get dinner => 'రాత్రి భోజనం';

  @override
  String get today => 'ఈరోజు';

  @override
  String get noMenuAvailable => 'మెనూ అందుబాటులో లేదు';

  @override
  String get noMenuAvailableDescription => 'మెనూ త్వరలో అందుబాటులో ఉంటుంది.';

  @override
  String get refresh => 'రిఫ్రెష్';

  @override
  String get refreshMenu => 'మెనూను రిఫ్రెష్ చేయండి';

  @override
  String get likeTodaysMenu => 'ఈరోజు మెనూను ఇష్టపడండి';

  @override
  String get dislike => 'ఇష్టం లేదు';

  @override
  String get menuNote => 'మెనూ గమనిక';

  @override
  String get foodGallery => 'ఆహార గ్యాలరీ';

  @override
  String noMenuForDay(String day) {
    return '$dayకు మెనూ లేదు';
  }

  @override
  String get ownerHasntSetMenuForDay =>
      'యజమాని ఈ రోజు కోసం మెనూను ఇంకా సెట్ చేయలేదు.';

  @override
  String get errorLoadingMenu => 'మెనూను లోడ్ చేయడంలో దోషం';

  @override
  String get unableToLoadMenuPleaseTryAgain =>
      'మెనూను లోడ్ చేయడం సాధ్యం కాలేదు. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get foodMenuStatistics => 'ఆహార మెనూ గణాంకాలు';

  @override
  String get weeklyMenus => 'వారపు మెనూలు';

  @override
  String get like => 'ఇష్టం';

  @override
  String get todayMenu => 'ఈరోజు మెనూ';

  @override
  String get history => 'చరిత్ర';

  @override
  String get sendPayment => 'చెల్లింపు పంపండి';

  @override
  String get paymentMethod => 'చెల్లింపు పద్ధతి';

  @override
  String get transactionId => 'లావాదేవీ ID';

  @override
  String get message => 'సందేశం';

  @override
  String get ownerResponse => 'యజమాని ప్రతిస్పందన';

  @override
  String get ownerPaymentDetails => 'యజమాని చెల్లింపు వివరాలు';

  @override
  String get upiId => 'UPI ID';

  @override
  String get upiQrCode => 'UPI QR కోడ్';

  @override
  String get sendPaymentNotification => 'చెల్లింపు నోటిఫికేషన్ పంపండి';

  @override
  String get afterMakingPaymentUploadScreenshot =>
      'చెల్లింపు చేసిన తర్వాత, స్క్రీన్‌షాట్‌ను అప్‌లోడ్ చేసి యజమానికి తెలియజేయండి';

  @override
  String get addComplaint => 'ఫిర్యాదు జోడించండి';

  @override
  String get complaints => 'ఫిర్యాదులు';

  @override
  String get noComplaintsFound => 'ఫిర్యాదులు కనుగొనబడలేదు';

  @override
  String get noComplaintsFoundDescription =>
      'మీరు ఇంకా ఏ ఫిర్యాదులను సమర్పించలేదు. జోడించడానికి + బటన్‌ను నొక్కండి.';

  @override
  String get all => 'అన్నీ';

  @override
  String get resolved => 'పరిష్కరించబడింది';

  @override
  String get inProgress => 'ప్రగతిలో ఉంది';

  @override
  String get total => 'మొత్తం';

  @override
  String get myComplaints => 'నా ఫిర్యాదులు';

  @override
  String get noComplaintsFoundWithSelectedFilter =>
      'ఎంచుకున్న ఫిల్టర్‌తో ఫిర్యాదులు కనుగొనబడలేదు';

  @override
  String get noComplaintsYet => 'ఇంకా ఫిర్యాదులు లేవు';

  @override
  String get noComplaintsYetDescription =>
      'మీరు ఇంకా ఏ ఫిర్యాదులను సమర్పించలేదు. మీ మొదటి ఫిర్యాదును జోడించడానికి + బటన్‌ను నొక్కండి.';

  @override
  String get errorLoadingComplaints => 'ఫిర్యాదులను లోడ్ చేయడంలో దోషం';

  @override
  String get unableToLoadComplaints => 'ఫిర్యాదులను లోడ్ చేయడం సాధ్యం కాలేదు';

  @override
  String get saveProfile => 'ప్రొఫైల్ సేవ్ చేయండి';

  @override
  String get loadingYourProfile => 'మీ ప్రొఫైల్ లోడ్ అవుతోంది...';

  @override
  String get errorLoadingProfile => 'ప్రొఫైల్ లోడ్ చేయడంలో దోషం';

  @override
  String get profilePhotos => 'ప్రొఫైల్ ఫోటోలు';

  @override
  String get aadhaarPhoto => 'ఆధార్ ఫోటో';

  @override
  String failedToUploadProfilePhoto(String error) {
    return 'ప్రొఫైల్ ఫోటోను అప్‌లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToUploadAadhaarPhoto(String error) {
    return 'ఆధార్ ఫోటోను అప్‌లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get noProfileDataFound => 'ప్రొఫైల్ డేటా కనుగొనబడలేదు';

  @override
  String get failedToUpdateProfile => 'ప్రొఫైల్ నవీకరించడంలో విఫలమైంది';

  @override
  String get vegetarian => 'శాకాహారి';

  @override
  String get nonVegetarian => 'మాంసాహారి';

  @override
  String get single => 'ఒంటరి';

  @override
  String get married => 'వివాహిత';

  @override
  String get foodPreference => 'ఆహార ప్రాధాన్యత';

  @override
  String get maritalStatus => 'వివాహ స్థితి';

  @override
  String get other => 'ఇతర';

  @override
  String get contactAndGuardianInformation =>
      'సంప్రదింపు మరియు సంరక్షక సమాచారం';

  @override
  String get currentAddress => 'ప్రస్తుత చిరునామా';

  @override
  String get guardianName => 'సంరక్షక పేరు';

  @override
  String get guardianPhone => 'సంరక్షక ఫోన్';

  @override
  String get preferences => 'ప్రాధాన్యతలు';

  @override
  String get eggetarian => 'అండాహారి';

  @override
  String get divorced => 'విడాకులు';

  @override
  String get items => 'అంశాలు';

  @override
  String get overview => 'అవలోకనం';

  @override
  String get food => 'ఆహారం';

  @override
  String get guests => 'అతిథులు';

  @override
  String get totalRevenue => 'మొత్తం ఆదాయం';

  @override
  String get properties => 'ఆస్తులు';

  @override
  String get activeTenants => 'క్రియాశీల అద్దెదారులు';

  @override
  String get occupancy => 'ఆక్యుపెన్సీ';

  @override
  String get pendingBookings => 'పెండింగ్ బుకింగ్‌లు';

  @override
  String get pendingComplaints => 'పెండింగ్ ఫిర్యాదులు';

  @override
  String get refreshDashboard => 'డాష్‌బోర్డ్ రిఫ్రెష్ చేయండి';

  @override
  String get loadingDashboard => 'డాష్‌బోర్డ్ లోడ్ అవుతోంది...';

  @override
  String get errorLoadingDashboard => 'డాష్‌బోర్డ్ లోడ్ చేయడంలో దోషం';

  @override
  String get dashboardDataWillAppearHere =>
      'మీరు ఆస్తులను జోడించిన తర్వాత డాష్‌బోర్డ్ డేటా ఇక్కడ కనిపిస్తుంది';

  @override
  String get welcome => 'స్వాగతం';

  @override
  String get heresYourBusinessOverview => 'ఇది మీ వ్యాపార అవలోకనం';

  @override
  String get performance => 'పనితీరు';

  @override
  String get monthlyRevenue => 'నెలవారీ ఆదాయం';

  @override
  String get propertyBreakdown => 'ఆస్తి విభజన';

  @override
  String get quickActions => 'త్వరిత చర్యలు';

  @override
  String get addProperty => 'ఆస్తి జోడించండి';

  @override
  String get addTenant => 'అద్దెదారుని జోడించండి';

  @override
  String get viewReports => 'రిపోర్ట్‌లను వీక్షించండి';

  @override
  String get propertyRevenue => 'ఆస్తి ఆదాయం';

  @override
  String totalRevenueWithPgs(int count) {
    return 'మొత్తం ఆదాయం ($count PGs)';
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
  String get initialize => 'ప్రారంభించు';

  @override
  String get defaultMenusInitializedSuccessfully =>
      'డిఫాల్ట్ మెనూలు విజయవంతంగా ప్రారంభించబడ్డాయి';

  @override
  String get failedToInitializeMenus => 'మెనూలను ప్రారంభించడంలో విఫలమైంది';

  @override
  String failedToInitializeMenusWithError(String error) {
    return 'మెనూలను ప్రారంభించడంలో విఫలమైంది: $error';
  }

  @override
  String get specialMenuOptions => 'Special Menu Options';

  @override
  String get addFestivalMenu => 'పండుగ మెనును జోడించండి';

  @override
  String get createSpecialMenuForFestivals =>
      'పండుగల కోసం ప్రత్యేక మెనును సృష్టించండి';

  @override
  String get addEventMenu => 'ఈవెంట్ మెనును జోడించండి';

  @override
  String get createSpecialMenuForEvents =>
      'ఈవెంట్‌ల కోసం ప్రత్యేక మెనును సృష్టించండి';

  @override
  String get viewAllSpecialMenus => 'అన్ని ప్రత్యేక మెనూలను వీక్షించండి';

  @override
  String get manageExistingSpecialMenus =>
      'అస్తిత్వంలో ఉన్న ప్రత్యేక మెనూలను నిర్వహించండి';

  @override
  String get editMenu => 'మెనును సవరించండి';

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
  String get createMenu => 'మెనును సృష్టించండి';

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
  String get photos => 'ఫోటోలు';

  @override
  String get festival => 'Festival';

  @override
  String get ownerFoodNoItemsAddedYet => 'ఇంకా అంశాలు జోడించలేదు';

  @override
  String get specialMenuLabel => 'ప్రత్యేక మెనూ';

  @override
  String get dayShortMon => 'సోమ';

  @override
  String get dayShortTue => 'మంగళ';

  @override
  String get dayShortWed => 'బుధ';

  @override
  String get dayShortThu => 'గురు';

  @override
  String get dayShortFri => 'శుక్ర';

  @override
  String get dayShortSat => 'శని';

  @override
  String get dayShortSun => 'ఆది';

  @override
  String get noRequests => 'No Requests';

  @override
  String get bookingAndBedChangeRequestsWillAppearHere =>
      'Booking and bed change requests will appear here';

  @override
  String get bedChanges => 'బెడ్ మార్పులు';

  @override
  String get complaintsFromGuestsWillAppearHere =>
      'Complaints from guests will appear here';

  @override
  String get complaint => 'Complaint';

  @override
  String get guest => 'అతిథి';

  @override
  String get reply => 'సమాధానం';

  @override
  String get resolve => 'Resolve';

  @override
  String get replyToComplaint => 'ఫిర్యాదుకు సమాధానం';

  @override
  String get typeYourReply => 'మీ సమాధానాన్ని టైప్ చేయండి...';

  @override
  String get send => 'పంపండి';

  @override
  String get replySent => 'Reply sent';

  @override
  String get failedToSendReply => 'Failed to send reply';

  @override
  String get resolveComplaint => 'ఫిర్యాదును పరిష్కరించండి';

  @override
  String get resolutionNotesOptional => 'పరిష్కార గమనికలు (ఐచ్ఛికం)';

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
  String get approved => 'అనుమోదించబడింది';

  @override
  String get rejected => 'తిరస్కరించబడింది';

  @override
  String get occupied => 'Occupied';

  @override
  String get vacant => 'Vacant';

  @override
  String get maintenance => 'నిర్వహణ';

  @override
  String get approve => 'అనుమోదించు';

  @override
  String get reject => 'తిరస్కరించు';

  @override
  String get noGuests => 'అతిథులు లేరు';

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
  String get changeStatus => 'స్థితిని మార్చండి';

  @override
  String get deleteSelected => 'Delete Selected';

  @override
  String updatedGuestsToStatus(int count, String status) {
    return '$count అతిథులను $statusకి నవీకరించబడింది';
  }

  @override
  String get confirmBulkDelete => 'బల్క్ డిలీట్‌ను నిర్ధారించండి';

  @override
  String areYouSureYouWantToDeleteGuests(int count) {
    return 'Are you sure you want to delete $count guests? This action cannot be undone.';
  }

  @override
  String get guestsDeletedSuccessfully => 'అతిథులు విజయవంతంగా తొలగించబడ్డారు';

  @override
  String get totalGuests => 'మొత్తం అతిథులు';

  @override
  String get activeGuests => 'Active Guests';

  @override
  String get pendingGuests => 'Pending Guests';

  @override
  String get found => 'found';

  @override
  String get guestOverview => 'Guest Overview';

  @override
  String get recordPayment => 'చెల్లింపును రికార్డ్ చేయండి';

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
  String get aboutApp => 'అప్లికేషన్ గురించి';

  @override
  String get aboutDeveloper => 'డెవలపర్ గురించి';

  @override
  String get switchToGuest => 'అతిథికి మారండి';

  @override
  String get switchToOwner => 'యజమానికి మారండి';

  @override
  String get owner => 'యజమాని';

  @override
  String get failedToSwitchAccount => 'ఖాతాను మార్చడంలో విఫలమైంది';

  @override
  String get notifications => 'నోటిఫికేషన్‌లు';

  @override
  String get userMenu => 'వినియోగదారు మెను';

  @override
  String get system => 'సిస్టమ్';

  @override
  String get privacyPolicy => 'గోప్యతా విధానం';

  @override
  String get termsOfService => 'సేవా నిబంధనలు';

  @override
  String get helpSupport => 'సహాయం & మద్దతు';

  @override
  String get or => 'లేదా';

  @override
  String get googleSignIn => 'Googleతో కొనసాగించండి';

  @override
  String get enterYourCompleteName => 'మీ పూర్తి పేరును నమోదు చేయండి';

  @override
  String get age => 'వయస్సు';

  @override
  String get years => 'సంవత్సరాలు';

  @override
  String get emailAddressOptional => 'ఇమెయిల్ చిరునామా (ఐచ్ఛికం)';

  @override
  String get yourEmailExampleCom => 'your.email@example.com';

  @override
  String get pleaseEnterValidEmail =>
      'దయచేసి చెల్లుబాటు అయ్యే ఇమెయిల్‌ను నమోదు చేయండి';

  @override
  String get uploadDocuments => 'పత్రాలను అప్‌లోడ్ చేయండి';

  @override
  String get uploadClearPhotosOfYourDocuments =>
      'ధృవీకరణ కోసం మీ పత్రాల స్పష్టమైన ఫోటోలను అప్‌లోడ్ చేయండి';

  @override
  String get uploadClearPhotoOfYourself =>
      'మీ స్వంత స్పష్టమైన ఫోటోను అప్‌లోడ్ చేయండి';

  @override
  String get uploadYourAadhaarCard =>
      'మీ ఆధార్ కార్డ్‌ను అప్‌లోడ్ చేయండి (ముందు లేదా వెనుక)';

  @override
  String get aadhaarNumber => 'ఆధార్ సంఖ్య';

  @override
  String get enter12DigitAadhaarNumber => '12 అంకెల ఆధార్ సంఖ్యను నమోదు చేయండి';

  @override
  String get emergencyContact => 'అత్యవసర సంప్రదింపు';

  @override
  String get contactName => 'సంప్రదింపు పేరు';

  @override
  String get fullNameOfEmergencyContact => 'అత్యవసర సంప్రదింపు పూర్తి పేరు';

  @override
  String get contactRelation => 'సంబంధం';

  @override
  String get fullAddressOfEmergencyContact =>
      'అత్యవసర సంప్రదింపు పూర్తి చిరునామా';

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
      'చెల్లింపు విజయవంతమైంది! యజమానిని తెలియజేస్తాం.';

  @override
  String paymentFailed(String message) {
    return 'చెల్లింపు విఫలమైంది';
  }

  @override
  String failedToProcessPayment(String error) {
    return 'చెల్లింపును ప్రాసెస్ చేయడంలో విఫలమైంది';
  }

  @override
  String get pleaseUploadPaymentScreenshot =>
      'దయచేసి చెల్లింపు స్క్రీన్‌షాట్‌ను అప్‌లోడ్ చేయండి. లావాదేవీ ID స్క్రీన్‌షాట్‌లో కనిపిస్తుంది.';

  @override
  String failedToSendNotification(String error) {
    return 'నోటిఫికేషన్ పంపడంలో విఫలమైంది';
  }

  @override
  String get uploadPaymentScreenshot =>
      'చెల్లింపు స్క్రీన్‌షాట్ అప్‌లోడ్ చేయండి';

  @override
  String get pleaseSelectPgFirstToFileComplaint =>
      'Please select a PG first to file a complaint';

  @override
  String get submitFirstComplaint => 'Submit First Complaint';

  @override
  String get viewDetails => 'వివరాలు చూడండి';

  @override
  String get editGuest => 'అతిథిని సవరించండి';

  @override
  String get sendMessage => 'సందేశం పంపండి';

  @override
  String get callGuest => 'అతిథిని కాల్ చేయండి';

  @override
  String get checkOut => 'చెక్ అవుట్';

  @override
  String get guestUpdatedSuccessfully => 'అతిథి విజయవంతంగా నవీకరించబడింది';

  @override
  String get messages => 'సందేశాలు:';

  @override
  String get noMessagesYet => 'ఇంకా సందేశాలు లేవు';

  @override
  String get replyToServiceRequest => 'సేవా అభ్యర్థనకు ప్రత్యుత్తరం ఇవ్వండి';

  @override
  String get sendReply => 'ప్రత్యుత్తరం పంపండి';

  @override
  String get pleaseFillInAllFields => 'దయచేసి అన్ని ఫీల్డ్‌లను పూరించండి';

  @override
  String get serviceRequestSubmitted => 'సేవా అభ్యర్థన సమర్పించబడింది';

  @override
  String get replySentSuccessfully => 'ప్రత్యుత్తరం విజయవంతంగా పంపబడింది';

  @override
  String failedToUpdateStatus(String error) {
    return 'స్థితిని నవీకరించడంలో విఫలమైంది';
  }

  @override
  String get completeService => 'సేవను పూర్తి చేయండి';

  @override
  String get completionNotes => 'పూర్తి నోట్స్';

  @override
  String get completionNotesOptional => 'పూర్తి నోట్స్ (ఐచ్ఛికం)...';

  @override
  String get markAsCompleted => 'పూర్తయినదిగా గుర్తించండి';

  @override
  String get serviceCompletedSuccessfully => 'సేవ విజయవంతంగా పూర్తయింది';

  @override
  String get editBike => 'బైక్‌ను సవరించండి';

  @override
  String get bikeUpdatedSuccessfully => 'బైక్ విజయవంతంగా నవీకరించబడింది';

  @override
  String get moveBike => 'బైక్‌ను తరలించండి';

  @override
  String currentSpot(String spot) {
    return 'ప్రస్తుత స్పాట్: $spot';
  }

  @override
  String get removeBike => 'బైక్‌ను తొలగించండి';

  @override
  String areYouSureYouWantToRemoveBike(String bikeName) {
    return 'మీరు $bikeNameని తొలగించాలని ఖచ్చితంగా అనుకుంటున్నారా?';
  }

  @override
  String get bikeRemovalRequestCreated =>
      'బైక్ తొలగింపు అభ్యర్థన సృష్టించబడింది';

  @override
  String get bikeMovementRequestCreated =>
      'బైక్ తరలింపు అభ్యర్థన సృష్టించబడింది';

  @override
  String get invalidPaymentOrOwnerInfoNotAvailable =>
      'చెల్లని చెల్లింపు లేదా యజమాని సమాచారం అందుబాటులో లేదు.';

  @override
  String get paymentSuccessful => 'చెల్లింపు విజయవంతమైంది!';

  @override
  String get upiPaymentNotificationSent =>
      'UPI చెల్లింపు నోటిఫికేషన్ పంపబడింది. యజమాని ధృవీకరిస్తారు మరియు నిర్ధారిస్తారు.';

  @override
  String failedToProcessUpiPayment(String error) {
    return 'UPI చెల్లింపును ప్రాసెస్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get cashPaymentNotificationSent =>
      'నగదు చెల్లింపు నోటిఫికేషన్ పంపబడింది. యజమాని చెల్లింపును స్వీకరించిన తర్వాత నిర్ధారిస్తారు.';

  @override
  String failedToProcessCashPayment(String error) {
    return 'నగదు చెల్లింపును ప్రాసెస్ చేయడంలో విఫలమైంది';
  }

  @override
  String failedToPickImage(String error) {
    return 'చిత్రాన్ని ఎంచుకోవడంలో విఫలమైంది';
  }

  @override
  String get changeScreenshot => 'స్క్రీన్‌షాట్ మార్చండి';

  @override
  String get cashPaymentConfirmation => 'నగదు చెల్లింపు నిర్ధరణ';

  @override
  String get haveYouPaidAmountInCash =>
      'యజమానికి నగదుగా మొత్తం చెల్లించారా? వారు చెల్లింపును స్వీకరించిన తర్వాత నిర్ధారిస్తారు.';

  @override
  String get yesPaid => 'అవును, చెల్లించారు';

  @override
  String get paymentDetailsSavedSuccessfully =>
      'చెల్లింపు వివరాలు విజయవంతంగా సేవ్ చేయబడ్డాయి';

  @override
  String failedToSave(String error) {
    return 'సేవ్ చేయడంలో విఫలమైంది';
  }

  @override
  String get unknownError => 'Unknown error';

  @override
  String get saveDraft => 'డ్రాఫ్ట్‌ను సేవ్ చేయండి';

  @override
  String get publish => 'ప్రచురించండి';

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
  String get pgPublishedSuccessfully => 'PG విజయవంతంగా ప్రచురించబడింది';

  @override
  String get draftSaved => 'డ్రాఫ్ట్ సేవ్ చేయబడింది';

  @override
  String failedToSelectPhotos(String error) {
    return 'ఫోటోలను ఎంచుకోవడంలో విఫలమైంది';
  }

  @override
  String get guestName => 'అతిథి పేరు';

  @override
  String get searchGuestsLabel => 'అతిథులను వెతకండి';

  @override
  String get searchGuestsHint =>
      'పేరు, ఫోన్, గది లేదా ఇమెయిల్ ద్వారా వెతకండి...';

  @override
  String get statusNew => 'కొత్త';

  @override
  String get statusVip => 'విఐపీ';

  @override
  String get exportData => 'డేటాను ఎగుమతి చేయండి';

  @override
  String get guestDataExportedSuccessfully =>
      'అతిథి డేటా విజయవంతంగా ఎగుమతి అయింది';

  @override
  String get guestListTitle => 'అతిథుల జాబితా';

  @override
  String guestCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count అతిథులు',
      one: '1 అతిథి',
      zero: '0 అతిథులు',
    );
    return '$_temp0';
  }

  @override
  String get noGuestsYet => 'ఇప్పటికీ అతిథులు లేరు';

  @override
  String get guestsAppearAfterBooking =>
      'మీ PG బుక్ చేసిన వెంటనే అతిథులు ఇక్కడ కనిపిస్తారు';

  @override
  String get checkIn => 'చెక్-ఇన్';

  @override
  String get duration => 'వ్యవధి';

  @override
  String get emergencyPhone => 'అత్యవసర ఫోన్';

  @override
  String get occupation => 'వృత్తి';

  @override
  String get company => 'కంపెనీ';

  @override
  String messageToGuest(String name) {
    return 'కు: $name';
  }

  @override
  String get enterMessageHint => 'మీ సందేశాన్ని నమోదు చేయండి...';

  @override
  String get messageSentSuccessfully => 'సందేశం విజయవంతంగా పంపబడింది';

  @override
  String get checkOutGuest => 'అతిథిని చెక్ అవుట్ చేయండి';

  @override
  String get checkOutGuestConfirmation =>
      'ఈ అతిథిని చెక్ అవుట్ చేయాలనుకుంటున్నారా? ఈ చర్యను తిరిగి మార్చలేము.';

  @override
  String get guestCheckedOutSuccessfully =>
      'అతిథి విజయవంతంగా చెక్ అవుట్ అయ్యారు';

  @override
  String get phoneNumberLabel => 'ఫోన్ నంబర్';

  @override
  String get emailLabel => 'ఇమెయిల్';

  @override
  String get emergencyContactLabel => 'Emergency Contact';

  @override
  String get emergencyPhoneLabel => 'Emergency Phone';

  @override
  String get saveChanges => 'మార్పులను సేవ్ చేయండి';

  @override
  String get parkingSpot => 'పార్కింగ్ స్పాట్';

  @override
  String get notes => 'Notes';

  @override
  String get complete => 'పూర్తి';

  @override
  String get resolutionNotes => 'పరిష్కార నోట్స్';

  @override
  String get markAsResolved => 'పరిష్కరించబడినదిగా గుర్తించండి';

  @override
  String get complaintResolvedSuccessfully =>
      'ఫిర్యాదు విజయవంతంగా పరిష్కరించబడింది';

  @override
  String get serviceType => 'సేవా రకం';

  @override
  String get serviceDescription => 'సేవా వివరణ';

  @override
  String get describeTheServiceNeeded => 'అవసరమైన సేవను వివరించండి...';

  @override
  String get submitRequest => 'అభ్యర్థనను సమర్పించండి';

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
  String get totalComplaints => 'మొత్తం ఫిర్యాదులు';

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
  String get backToPayments => 'చెల్లింపులకు తిరిగి వెళ్లండి';

  @override
  String get payNow => 'ఇప్పుడు చెల్లించండి';

  @override
  String get processing => 'ప్రాసెస్ చేస్తున్నాం...';

  @override
  String get addPhotos => 'ఫోటోలు జోడించండి';

  @override
  String get paymentDetails => 'చెల్లింపు వివరాలు';

  @override
  String get paymentNotFound => 'చెల్లింపు కనుగొనబడలేదు';

  @override
  String get theRequestedPaymentCouldNotBeFound =>
      'అభ్యర్థించిన చెల్లింపు కనబడలేదు.';

  @override
  String get dueDate => 'చెల్లించవలసిన తేదీ';

  @override
  String get paymentDate => 'చెల్లింపు తేదీ';

  @override
  String get uPIReference => 'UPI Reference';

  @override
  String get pgId => 'PG ID';

  @override
  String get ownerId => 'Owner ID';

  @override
  String get timeline => 'సమయరేఖ';

  @override
  String get created => 'సృష్టించబడింది';

  @override
  String get paid => 'చెల్లించబడింది';

  @override
  String get transactionIdOptional => 'లావాదేవీ ID (ఐచ్చికం)';

  @override
  String get transactionIdIsVisibleInScreenshot =>
      'లావాదేవీ ID స్క్రీన్‌షాట్‌లో కనిపిస్తుంది';

  @override
  String get youCanSkipThisTransactionIdIsInScreenshot =>
      'మీరు దీనిని దాటవచ్చు - ట్రాన్సాక్షన్ ID స్క్రీన్‌షాట్‌లో ఉంది';

  @override
  String get pleaseEnterAmount => 'దయచేసి మొత్తాన్ని నమోదు చేయండి';

  @override
  String get pleaseEnterValidAmount => 'దయచేసి సరైన మొత్తాన్ని నమోదు చేయండి';

  @override
  String get notRequiredAlreadyVisibleInScreenshot =>
      'అవసరం లేదు - స్క్రీన్‌షాట్‌లో ఇప్పటికే కనబడుతోంది';

  @override
  String get messageOptional => 'సందేశం (ఐచ్చికం)';

  @override
  String get paymentInformation => 'చెల్లింపు సమాచారం';

  @override
  String get additionalInformation => 'అదనపు సమాచారం';

  @override
  String get searchServices => 'సేవలను శోధించండి';

  @override
  String get searchByTitleGuestRoomOrType =>
      'శీర్షిక, అతిథి, గది లేదా రకం ద్వారా శోధించండి...';

  @override
  String get createNewServiceRequest => 'కొత్త సేవా అభ్యర్థనను సృష్టించండి';

  @override
  String get priority => 'ప్రాధాన్యత';

  @override
  String get requested => 'అభ్యర్థించబడింది';

  @override
  String get assignedTo => 'కేటాయించబడింది';

  @override
  String get serviceRequest => 'సేవా అభ్యర్థన';

  @override
  String get serviceTitle => 'సేవా శీర్షిక';

  @override
  String get room => 'గది';

  @override
  String get roomNumber => 'గది సంఖ్య';

  @override
  String get housekeeping => 'గృహనిర్వహణ';

  @override
  String get vehicle => 'వాహనం';

  @override
  String get start => 'ప్రారంభించండి';

  @override
  String get resume => 'కొనసాగించండి';

  @override
  String get details => 'వివరాలు';

  @override
  String get advancedSearch => 'Advanced Search';

  @override
  String get pgNotFound => 'PG కనుగొనబడలేదు';

  @override
  String get pricingAvailability => 'ధర & లభ్యత';

  @override
  String get locationVicinity => 'స్థానం & సమీప ప్రాంతం';

  @override
  String get facilitiesAmenities => 'సౌకర్యాలు & అనుకూలతలు';

  @override
  String get foodMealInformation => 'ఆహార & భోజన సమాచారం';

  @override
  String get rulesPolicies => 'నియమాలు & విధానాలు';

  @override
  String get contactOwnerInformation => 'సంప్రదింపు & యజమాని సమాచారం';

  @override
  String get callOwner => 'యజమానిని కాల్ చేయండి';

  @override
  String get sharePg => 'Share PG';

  @override
  String get requestBooking => 'బుకింగ్ అభ్యర్థించండి';

  @override
  String get couldNotOpenMaps => 'మ్యాప్ తెరవలేకపోయాం';

  @override
  String get pgInformationNotAvailable => 'PG సమాచారం అందుబాటులో లేదు';

  @override
  String failedToShare(String error) {
    return 'Failed to share: $error';
  }

  @override
  String get searchBikes => 'బైక్‌లను శోధించండి';

  @override
  String get searchByNumberNameGuestOrModel =>
      'నంబర్, పేరు, అతిథి లేదా మోడల్ ద్వారా శోధించండి...';

  @override
  String get searchComplaints => 'ఫిర్యాదులను శోధించండి';

  @override
  String get searchByTitleGuestRoomOrDescription =>
      'శీర్షిక, అతిథి, గది లేదా వివరణ ద్వారా శోధించండి...';

  @override
  String get yourCurrentResidentialAddress =>
      'Your current residential address';

  @override
  String get nameOfYourParentOrGuardian => 'Name of your parent or guardian';

  @override
  String get tenDigitPhoneNumber => '10 అంకెల ఫోన్ నంబర్';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'దయచేసి చెల్లుబాటు అయ్యే ఫోన్ నంబర్‌ను నమోదు చేయండి';

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
  String get bankName => 'బ్యాంక్ పేరు';

  @override
  String get accountHolderName => 'ఖాతాదారు పేరు';

  @override
  String get enterAccountNumber => 'ఖాతా నంబర్‌ను నమోదు చేయండి';

  @override
  String get ifscCode => 'IFSC కోడ్';

  @override
  String get uPIDetails => 'UPI Details';

  @override
  String get addYourUpiIdForInstantPayments =>
      'Add your UPI ID for instant payments';

  @override
  String get upiID => 'UPI ID';

  @override
  String get paymentInstructionsOptional => 'చెల్లింపు సూచనలు (ఐచ్ఛికం)';

  @override
  String get uploadYourUpiQrCodeFromAnyPaymentApp =>
      'ఏదైనా చెల్లింపు అప్లికేషన్ నుండి మీ UPI QR కోడ్‌ను అప్లోడ్ చేయండి';

  @override
  String get changeQrCode => 'Change QR Code';

  @override
  String get uploadQrCode => 'QR కోడ్‌ను అప్లోడ్ చేయండి';

  @override
  String get savePaymentDetails => 'చెల్లింపు వివరాలను సేవ్ చేయండి';

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
  String get bedNumberingGuide => 'మంచం నంబరింగ్ గైడ్';

  @override
  String get configureRentalPricing => 'అద్దె ధరను కాన్ఫిగర్ చేయండి';

  @override
  String get addPgAmenities => 'Add PG Amenities';

  @override
  String get uploadPgPhotos => 'Upload PG Photos';

  @override
  String get progress => 'ప్రగతి';

  @override
  String get theRequestedPgCouldNotBeFoundOrMayHaveBeenRemoved =>
      'అభ్యర్థించిన PG కనుగొనబడలేదు లేదా తొలగించబడింది కావచ్చు.';

  @override
  String get newParkingSpot => 'కొత్త పార్కింగ్ స్పాట్';

  @override
  String get reasonForMove => 'తరలింపు కారణం';

  @override
  String get reasonForRemoval => 'తొలగింపు కారణం';

  @override
  String get more => 'More';

  @override
  String get nameAsPerBankRecords => 'బ్యాంక్ రికార్డ్‌ల ప్రకారం పేరు';

  @override
  String get accountNumber => 'ఖాతా నంబర్';

  @override
  String get anySpecialInstructionsForGuests =>
      'అతిథులకు ఏవైనా ప్రత్యేక సూచనలు';

  @override
  String get appearance => 'దృశ్యం';

  @override
  String get pushNotifications => 'పుష్ నోటిఫికేషన్‌లు';

  @override
  String get pushNotificationsDescription =>
      'Receive notifications on your device';

  @override
  String get emailNotifications => 'ఇమెయిల్ నోటిఫికేషన్‌లు';

  @override
  String get emailNotificationsDescription => 'Receive notifications via email';

  @override
  String get paymentReminders => 'చెల్లింపు రిమైండర్‌లు';

  @override
  String get paymentRemindersDescription =>
      'Get reminders for pending payments';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get aboutSection => 'About';

  @override
  String get appVersion => 'అనువర్తన వెర్షన్';

  @override
  String get buildNumber => 'బిల్డ్ నంబర్';

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
  String get registered => 'నమోదు చేయబడింది';

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
  String get bikeNumber => 'బైక్ నంబర్';

  @override
  String get bikeName => 'Bike Name';

  @override
  String get bikeType => 'రకం';

  @override
  String get bikeModel => 'మోడల్';

  @override
  String get bikeColor => 'బైక్ రంగు';

  @override
  String get color => 'రంగు';

  @override
  String get typeLabel => 'Type';

  @override
  String get registeredOn => 'Registered';

  @override
  String get lastParked => 'చివరిగా పార్క్ చేయబడింది';

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
      'ఫిర్యాదు వివరాలు విజయవంతంగా ఎగుమతి అయ్యాయి';

  @override
  String get complaintTitle => 'ఫిర్యాదు శీర్షిక';

  @override
  String get priorityLevel => 'ప్రాధాన్యత స్థాయి';

  @override
  String get add => 'జోడించండి';

  @override
  String imagesSelected(int count) {
    return '$count చిత్రాలు ఎంపికయ్యాయి';
  }

  @override
  String get commonComplaintCategories => 'సాధారణ ఫిర్యాదు వర్గాలు:';

  @override
  String get complaintCategoryFood => 'ఆహారం';

  @override
  String get complaintCategoryCleanliness => 'శుభ్రత';

  @override
  String get complaintCategoryMaintenance => 'నిర్వహణ';

  @override
  String get complaintCategoryWater => 'నీటి సమస్యలు';

  @override
  String get complaintCategoryElectricity => 'విద్యుత్';

  @override
  String get complaintCategoryWifi => 'వై-ఫై';

  @override
  String get complaintCategoryNoise => 'శబ్దం';

  @override
  String get complaintCategoryGeneral => 'సాధారణ';

  @override
  String todayAt(String time) {
    return 'ఈ రోజు $time';
  }

  @override
  String get yesterday => 'నిన్న';

  @override
  String daysAgo(int count) {
    return '$count రోజుల క్రితం';
  }

  @override
  String get bookBed => 'బెడ్ బుక్ చేయండి';

  @override
  String get selectFloor => 'అంతస్తు ఎంచుకోండి';

  @override
  String get selectRoom => 'గది ఎంచుకోండి';

  @override
  String get selectBed => 'బెడ్ ఎంచుకోండి';

  @override
  String get startDate => 'ప్రారంభ తేదీ';

  @override
  String get selectStartDate => 'ప్రారంభ తేదీని ఎంచుకోండి';

  @override
  String get bookingSummary => 'బుకింగ్ సారాంశం';

  @override
  String get sharing => 'షేరింగ్';

  @override
  String get notSelected => 'ఎంచుకోలేదు';

  @override
  String get legacyBookingMessage =>
      'ఈ PG ని బుక్ చేయడానికి దయచేసి యజమానిని నేరుగా సంప్రదించండి.';

  @override
  String get confirmBooking => 'బుకింగ్ నిర్ధారించండి';

  @override
  String get bookingRequestSuccess =>
      'బుకింగ్ అభ్యర్థన పంపబడింది! యజమాని త్వరలో నిర్ధారిస్తారు.';

  @override
  String bookingRequestFailed(String error) {
    return 'బుకింగ్ విఫలమైంది: $error';
  }

  @override
  String roomOptionLabel(
      String roomNumber, String sharingType, int availableBeds) {
    return '$roomNumber ($sharingType-షేరింగ్) - $availableBeds ఖాళీ';
  }

  @override
  String bedLabel(String number) {
    return 'బెడ్ $number';
  }

  @override
  String get bed => 'బెడ్';

  @override
  String get requestToJoinPg => 'PG కి చేరడానికి అభ్యర్థన';

  @override
  String get sendBookingRequestToOwner => 'యజమానికి బుకింగ్ అభ్యర్థన పంపండి';

  @override
  String get contactInformation => 'సంప్రదింపు సమాచారం';

  @override
  String get enterYourPhoneNumber => 'మీ ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get enterYourEmailAddress => 'మీ ఇమెయిల్ చిరునామాను నమోదు చేయండి';

  @override
  String get messageOptionalHint =>
      'యజమానికి అదనపు సమాచారం ఉంటే ఇక్కడ నమోదు చేయండి...';

  @override
  String get pleaseEnterYourName => 'దయచేసి మీ పేరు నమోదు చేయండి';

  @override
  String get pleaseEnterYourPhoneNumber => 'దయచేసి మీ ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get pleaseEnterYourEmailAddress =>
      'దయచేసి మీ ఇమెయిల్ చిరునామాను నమోదు చేయండి';

  @override
  String get pleaseEnterValidEmailAddress =>
      'దయచేసి సరైన ఇమెయిల్ చిరునామాను నమోదు చేయండి';

  @override
  String get sendRequest => 'అభ్యర్థన పంపండి';

  @override
  String get sending => 'పంపిస్తోంది...';

  @override
  String monthlyRentDisplay(String amount) {
    return '₹$amount/నెల';
  }

  @override
  String get notAvailable => 'అందుబాటులో లేదు';

  @override
  String pgCountSummary(int filtered, int total) {
    return '$filtered / $total PGలు';
  }

  @override
  String get errorLoadingPgs => 'PGలను లోడ్ చేయడంలో లోపం';

  @override
  String get unknownErrorOccurred => 'తెలియని లోపం జరిగింది';

  @override
  String get noPgsAvailable => 'PGలు అందుబాటులో లేవు';

  @override
  String get pgListingsWillAppear =>
      'PG జాబితాలు ప్లాట్‌ఫారమ్‌లో చేర్చిన వెంటనే ఇక్కడ కనిపిస్తాయి.';

  @override
  String get bookNow => 'ఇప్పుడు బుక్ చేయండి';

  @override
  String get available => 'అందుబాటులో ఉంది';

  @override
  String get unavailable => 'అందుబాటులో లేదు';

  @override
  String photosBadge(int count) {
    return '$count ఫోటోలు';
  }

  @override
  String get noImageAvailable => 'చిత్రం అందుబాటులో లేదు';

  @override
  String distanceMeters(int meters) {
    return '$metersమీ దూరంలో';
  }

  @override
  String distanceKilometers(double kilometers) {
    return '$kilometersకిమీ దూరంలో';
  }

  @override
  String sharingLabel(int count) {
    return '$count షేరింగ్';
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
  String get noAmenitiesListed => 'ఈ PG కోసం సౌకర్యాలు జాబితా చేయబడలేదు';

  @override
  String get amenitiesSectionTitle => 'సౌకర్యాలు';

  @override
  String get amenitiesSectionSubtitle => 'ఈ PG లో అందుబాటులో ఉన్న సౌకర్యాలు';

  @override
  String get noPhotosAvailable => 'ఫోటోలు అందుబాటులో లేవు';

  @override
  String get failedToLoadImage => 'చిత్రాన్ని లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get pgDetails => 'PG వివరాలు';

  @override
  String get errorLoadingPgDetails => 'PG వివరాలను లోడ్ చేయడంలో లోపం';

  @override
  String get sharingOptionsPricing => 'షేరింగ్ ఎంపికలు & ధరలు';

  @override
  String get securityDeposit => 'భద్రతా డిపాజిట్';

  @override
  String get perMonth => 'నెలకు';

  @override
  String get oneTime => 'ఒక్కసారి';

  @override
  String get refundableWhenYouLeave => '(మీరు వెళ్తే తిరిగి చెల్లిస్తారు)';

  @override
  String get monthlyLabel => '(నెలవారీ)';

  @override
  String get oneTimeLabel => '(ఒక్కసారి)';

  @override
  String get totalInitialPayment => 'మొత్తం ప్రారంభ చెల్లింపు';

  @override
  String get firstMonthRent => 'మొదటి నెల అద్దె';

  @override
  String get totalLabel => 'మొత్తం';

  @override
  String secondMonthRentMaintenance(
      String rent, String maintenance, String total) {
    return '2వ నెల నుండి: అద్దె + నిర్వహణ (₹$rent + ₹$maintenance = ₹$total)';
  }

  @override
  String secondMonthRentOnly(String rent) {
    return '2వ నెల నుండి: కేవలం అద్దె (₹$rent)';
  }

  @override
  String availableTypes(String types) {
    return 'లభ్యమైనవి: $types';
  }

  @override
  String sharingLabelDefault(String count) {
    return '$count షేరింగ్';
  }

  @override
  String get completeAddress => 'పూర్తి చిరునామా';

  @override
  String get areaLabel => 'ప్రాంతం';

  @override
  String get cityLabel => 'నగరం';

  @override
  String get stateLabel => 'రాష్ట్రం';

  @override
  String get viewOnMap => 'మ్యాప్‌లో చూడండి';

  @override
  String get mealTypeFieldLabel => 'భోజన రకం';

  @override
  String get pgTypeFieldLabel => 'PG రకం';

  @override
  String get mealTimingsFieldLabel => 'భోజన సమయాలు';

  @override
  String get foodQualityFieldLabel => 'ఆహార నాణ్యత';

  @override
  String get entryTimings => 'ప్రవేశ సమయాలు';

  @override
  String get exitTimings => 'నిష్క్రమణ సమయాలు';

  @override
  String get guestPolicy => 'అతిథుల పాలసీ';

  @override
  String get smokingPolicy => 'పొగతాగు పాలసీ';

  @override
  String get alcoholPolicy => 'మద్యం పాలసీ';

  @override
  String get refundPolicy => 'రిఫండ్ పాలసీ';

  @override
  String get noticePeriod => 'నోటీస్ వ్యవధి';

  @override
  String get ownerNameLabel => 'యజమాని పేరు';

  @override
  String get contactNumberLabel => 'సంప్రదింపు సంఖ్య';

  @override
  String get accountHolder => 'ఖాతా యజమాని';

  @override
  String get qrCodeForPayment => 'చెల్లింపుకు QR కోడ్';

  @override
  String get paymentInstructionsLabel => 'చెల్లింపు సూచనలు';

  @override
  String get parkingDetails => 'పార్కింగ్ వివరాలు';

  @override
  String get securityMeasures => 'భద్రతా చర్యలు';

  @override
  String get descriptionLabel => 'వివరణ';

  @override
  String get nearbyPlacesLabel => 'సమీప ప్రదేశాలు';

  @override
  String get pgProperty => 'PG ఆస్తి';

  @override
  String sharePgHeading(String name) {
    return '🏠 $name';
  }

  @override
  String sharePgAddressLine(String address) {
    return '📍 చిరునామా: $address';
  }

  @override
  String get sharePgPricingHeader => '💰 ధరలు:';

  @override
  String sharePgPricingEntry(String count, String price) {
    return '$count షేర్: ₹$price';
  }

  @override
  String sharePgAmenitiesLine(String amenities) {
    return '✨ సౌకర్యాలు: $amenities';
  }

  @override
  String get sharePgFooter => 'ఈ PGని Atitiaలో చూడండి!';

  @override
  String get myBookingRequests => 'నా బుకింగ్ అభ్యర్థనలు';

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
      '⚠️ Firebase Auth వినియోగదారు లేదు - వినియోగదారు ధృవీకరించబడకపోయి ఉండవచ్చు';

  @override
  String bookingRequestLoadingDebug(String guestId) {
    return '🔑 guestId: $guestId కోసం బుకింగ్ అభ్యర్థనలను లోడ్ చేస్తున్నాము';
  }

  @override
  String bookingRequestStreamErrorDebug(String error) {
    return 'బుకింగ్ అభ్యర్థనల స్ట్రీమ్ లోపం: $error';
  }

  @override
  String bookingRequestExceptionDebug(String error) {
    return 'బుకింగ్ అభ్యర్థనలను లోడ్ చేస్తూ wyjąప్తి: $error';
  }

  @override
  String get pgLocationFallback => 'స్థానం అందుబాటులో లేదు';

  @override
  String get districtLabel => 'జిల్లా';

  @override
  String get talukaMandalLabel => 'తాలూకా/మండలం';

  @override
  String get societyLabel => 'సొసైటీ';

  @override
  String get selectPgPrompt =>
      'వివరాలను చూడడానికి మరియు మీ గడుపును నిర్వహించడానికి దయచేసి ఒక PGను ఎంచుకోండి';

  @override
  String get statusMaintenance => 'నిర్వహణలో ఉంది';

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
  String get noActiveBooking => 'క్రియాశీల బుకింగ్ లేదు';

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
  String get requestChange => 'మార్పు అభ్యర్థించండి';

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
    return 'పడక మార్పు అభ్యర్థనలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String requestedLabel(String date) {
    return 'అభ్యర్థించినది: $date';
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
    return 'చెల్లింపు విధానం: $method';
  }

  @override
  String get paymentMethodRazorpay => 'రేజర్‌పే';

  @override
  String get paymentMethodUpi => 'యుపిఐ';

  @override
  String get paymentMethodCash => 'నగదు';

  @override
  String get paymentMethodBankTransfer => 'బ్యాంక్ బదిలీ';

  @override
  String get paymentMethodOther => 'ఇతర';

  @override
  String get noPaymentsYet => 'ఇప్పటికీ చెల్లింపులు లేవు';

  @override
  String get noPaymentsYetDescription =>
      'మీరు ఇంకా చెల్లింపులు చేయలేదు. చెల్లింపులు చేసిన తర్వాత ఇవి ఇక్కడ కనిపిస్తాయి.';

  @override
  String get makePayment => 'చెల్లింపు చేయండి';

  @override
  String noPaymentsForFilter(String filter) {
    return 'ప్రస్తుతం $filter చెల్లింపులు లేవు';
  }

  @override
  String noPaymentsForFilterDescription(String filter) {
    return 'ప్రస్తుతం మీ వద్ద $filter చెల్లింపులు లేవు.';
  }

  @override
  String failedToLoadPaymentDetails(String error) {
    return 'చెల్లింపు వివరాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String paymentNumber(String id) {
    return 'చెల్లింపు #$id';
  }

  @override
  String get confirmed => 'నిర్ధారించబడింది';

  @override
  String get upiPaymentNote =>
      'UPI చెల్లింపు పూర్తైంది. దయచేసి తనిఖీ చేసి నిర్ధారించండి.';

  @override
  String get cashPaymentNote =>
      'నగదు చెల్లింపు జరిగింది. దయచేసి నిర్ధారించండి.';

  @override
  String get upiPaymentTip =>
      '💡 సూచన: PhonePe, Paytm, Google Pay వంటివి ద్వారా చెల్లింపు చేసిన తర్వాత, చెల్లింపు స్క్రీన్‌షాట్‌ను అప్‌లోడ్ చేయండి. ట్రాన్సాక్షన్ ఐడి ఇప్పటికే స్క్రీన్‌షాట్‌లో కనిపిస్తుంది.';

  @override
  String get paymentStatistics => 'చెల్లింపు గణాంకాలు';

  @override
  String get totalPayments => 'మొత్తం చెల్లింపులు';

  @override
  String get totalAmount => 'మొత్తం మొత్తం';

  @override
  String get recentPaymentsPreview => 'తాజా చెల్లింపుల ప్రివ్యూ';

  @override
  String get noPaymentHistory => 'చెల్లింపు చరిత్ర లేదు';

  @override
  String get noPaymentHistoryDescription =>
      'మీరు చెల్లింపులు చేసిన తర్వాత మీ చెల్లింపు నోటిఫికేషన్‌లు మరియు చరిత్ర ఇక్కడ కనిపిస్తాయి.';

  @override
  String get paymentDetailsNotAvailable => 'చెల్లింపు వివరాలు అందుబాటులో లేవు';

  @override
  String get ownerPaymentDetailsNotConfigured =>
      'యజమాని చెల్లింపు వివరాలు ఇంకా సెటప్ చేయబడలేదు. దయచేసి మీ PG యజమానిని సంప్రదించి చెల్లింపు సమాచారాన్ని ఏర్పాటు చేయమనండి.';

  @override
  String get paymentMethodsPreview => 'చెల్లింపు విధానాల ప్రివ్యూ:';

  @override
  String get bankAccount => 'బ్యాంక్ ఖాతా';

  @override
  String get cashPaymentNotificationInfo =>
      'మీరు యజమానికి నగదు చెల్లింపు నోటిఫికేషన్ పంపుతారు. వారు చెల్లింపును స్వీకరించిన తర్వాత నిర్ధారిస్తారు.';

  @override
  String get payViaRazorpayDescription =>
      '\"Pay Now\" పై నొక్కి Razorpay ద్వారా సురక్షిత ఆన్‌లైన్ చెల్లింపును కొనసాగించండి.';

  @override
  String get payViaRazorpay => 'రేజర్‌పే ద్వారా చెల్లించండి';

  @override
  String get upiPaymentConfirmation => 'UPI చెల్లింపు నిర్ధరణ';

  @override
  String get cashPaymentNotification => 'నగదు చెల్లింపు నోటిఫికేషన్';

  @override
  String get sendNotification => 'నోటిఫికేషన్ పంపండి';

  @override
  String get paymentNotificationSentSuccessfully =>
      'చెల్లింపు నోటిఫికేషన్ విజయవంతంగా పంపబడింది';

  @override
  String get screenshotUploaded => 'స్క్రీన్‌షాట్ అప్‌లోడ్ అయింది';

  @override
  String get ownerNoPaymentsTitle => 'చెల్లింపులు లేవు';

  @override
  String get ownerNoPaymentsMessage =>
      'చెల్లింపులు సేకరించిన తర్వాత రికార్డులు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get unknownGuest => 'తెలియని అతిథి';

  @override
  String get roomBed => 'గది/పడక';

  @override
  String get markPaymentCollected => 'చెల్లింపును సేకరించబడిందిగా గుర్తించండి';

  @override
  String confirmMarkPaymentCollected(String amount) {
    return 'ఈ $amount చెల్లింపును సేకరించబడిందిగా గుర్తించాలనుకుంటున్నారా?';
  }

  @override
  String get collectedBy => 'సేకరించిన వ్యక్తి';

  @override
  String get paymentMarkedCollected =>
      'చెల్లింపు సేకరించబడిందిగా గుర్తించబడింది';

  @override
  String failedToUpdatePayment(String error) {
    return 'చెల్లింపును నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String get rejectPayment => 'చెల్లింపును తిరస్కరించండి';

  @override
  String get provideRejectionReason =>
      'ఈ చెల్లింపును తిరస్కరించడానికి కారణాన్ని ఇవ్వండి:';

  @override
  String get rejectionReason => 'తిరస్కరణ కారణం';

  @override
  String get enterRejectionReason => 'తిరస్కరణ కారణాన్ని నమోదు చేయండి...';

  @override
  String get paymentRejected => 'చెల్లింపు తిరస్కరించబడింది';

  @override
  String get failedToRejectPayment => 'చెల్లింపును తిరస్కరించడంలో విఫలమైంది';

  @override
  String get paymentRejectedByOwner => 'యజమాని చెల్లింపును తిరస్కరించారు';

  @override
  String rejectedWithReason(String reason) {
    return 'తిరస్కరించబడింది: $reason';
  }

  @override
  String get collectedByOwnerFallback => 'యజమాని';

  @override
  String get recordPaymentDescription =>
      'అతిథి నుండి స్వీకరించిన చెల్లింపును చేతితో నమోదు చేయండి';

  @override
  String get guestAndBooking => 'అతిథి & బుకింగ్';

  @override
  String get selectGuest => 'అతిథిని ఎంచుకోండి';

  @override
  String get pleaseSelectGuest => 'దయచేసి ఒక అతిథిని ఎంచుకోండి';

  @override
  String get selectBookingOptional => 'బుకింగ్ ఎంచుకోండి (ఐచ్చికం)';

  @override
  String get paymentAmountLabel => 'చెల్లింపు మొత్తం *';

  @override
  String get enterAmountHint => 'మొత్తాన్ని రూపాయల్లో నమోదు చేయండి';

  @override
  String get enterTransactionIdHint =>
      'లావాదేవీ ID లేదా రిఫరెన్స్ నంబర్ నమోదు చేయండి';

  @override
  String get notesOptional => 'గమనికలు (ఐచ్చికం)';

  @override
  String get notesHint => 'ఈ చెల్లింపు గురించి అదనపు గమనికలు';

  @override
  String get recording => 'రికార్డ్ చేస్తున్నాం...';

  @override
  String get recordPaymentSuccess => 'చెల్లింపు విజయవంతంగా రికార్డ్ చేయబడింది!';

  @override
  String get recordPaymentFailure => 'చెల్లింపును రికార్డ్ చేయడంలో విఫలమైంది';

  @override
  String errorRecordingPayment(String error) {
    return 'చెల్లింపును రికార్డ్ చేయడంలో లోపం: $error';
  }

  @override
  String get paymentMethodCard => 'కార్డ్';

  @override
  String get pendingPayments => 'పెండింగ్ చెల్లింపులు';

  @override
  String pendingPaymentsWaiting(int count) {
    return '$count పెండింగ్‌లో ఉన్నాయి';
  }

  @override
  String notificationsCount(int count) {
    return '$count నోటిఫికేషన్లు';
  }

  @override
  String get paymentConfirmedSuccessfully =>
      'చెల్లింపు విజయవంతంగా నిర్ధారించబడింది';

  @override
  String transactionIdLabel(String transactionId) {
    return 'TXN: $transactionId';
  }

  @override
  String get rejectionReasonHint => 'ఉదా: తప్పు మొత్తం, తప్పు లావాదేవీ';

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
  String get ownerGuestDetailVehicleNumber => 'వాహనం నం.';

  @override
  String get ownerGuestDetailVehicle => 'వాహనం';

  @override
  String get ownerGuestDetailRoomBed => 'గది/పట్టు';

  @override
  String get ownerGuestDetailRent => 'అద్దె';

  @override
  String get ownerGuestDetailDeposit => 'డిపాజిట్';

  @override
  String get ownerGuestDetailJoined => 'చేరిన తేదీ';

  @override
  String get ownerGuestDetailStatus => 'స్థితి';

  @override
  String get ownerGuestUpdateRoomBed => 'గది/పట్టు నవీకరించండి';

  @override
  String get ownerGuestUpdateRoomBedTitle =>
      'గది/పట్టు కేటాయింపును నవీకరించండి';

  @override
  String get ownerGuestRoomNumberLabel => 'గది నంబర్';

  @override
  String get ownerGuestRoomNumberHint => 'గది నంబర్ నమోదు చేయండి';

  @override
  String get ownerGuestBedNumberLabel => 'పట్టు నంబర్';

  @override
  String get ownerGuestBedNumberHint => 'పట్టు నంబర్ నమోదు చేయండి';

  @override
  String get ownerGuestUpdateAction => 'నవీకరించండి';

  @override
  String get ownerGuestRoomBedUpdateSuccess =>
      'గది/పట్టు విజయవంతంగా నవీకరించబడింది';

  @override
  String get ownerGuestRoomBedUpdateFailure => 'గది/పట్టు నవీకరణ విఫలమైంది';

  @override
  String get guestDetailsTitle => 'అతిథి వివరాలు';

  @override
  String get bikes => 'బైకులు';

  @override
  String get services => 'సేవలు';

  @override
  String get ownerGuestNoPgSelectedTitle => 'ఏ PG ఎన్నుకోలేదు';

  @override
  String get ownerGuestNoPgSelectedMessage =>
      'అతిథులను నిర్వహించడానికి దయచేసి ఒక PG ని ఎంచుకోండి';

  @override
  String get ownerGuestFailedToLoadData =>
      'అతిథి డేటాను లోడ్ చేయడంలో విఫలమైంది';

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
  String get analyticsRefreshData => 'డేటాను రిఫ్రెష్ చేయి';

  @override
  String get revenueAnalyticsTitle => 'ఆదాయం విశ్లేషణ';

  @override
  String get revenueAnalyticsSelectedPg =>
      'ఎంచుకున్న PG కోసం పనితీరు అంతర్దృష్టులు';

  @override
  String get revenueAnalyticsOverall => 'మొత్తం ఆదాయం పనితీరు';

  @override
  String get revenueMetricTotalRevenue => 'మొత్తం ఆదాయం';

  @override
  String get revenueMetricMonthlyGrowth => 'నెలవారీ వృద్ధి';

  @override
  String get revenueMetricAvgPerGuest => 'ప్రతి అతిథికి సగటు';

  @override
  String get analyticsPeriodWeekly => 'వారానికి';

  @override
  String get analyticsPeriodMonthly => 'నెలవారీ';

  @override
  String get analyticsPeriodYearly => 'వార్షిక';

  @override
  String get analyticsMetricRevenue => 'ఆదాయం';

  @override
  String get analyticsMetricOccupancy => 'ఆక్రమణ';

  @override
  String get analyticsMetricGuests => 'అతిథులు';

  @override
  String get revenueTrendsLabel => 'ఆదాయం ధోరణులు';

  @override
  String revenueTrendLastMonths(int months) {
    return 'ఆదాయం ధోరణి (గత $months నెలలు)';
  }

  @override
  String get revenueForecastTitle => 'ఆదాయం అంచనా';

  @override
  String get revenueForecastNextMonth => 'తదుపరి నెల';

  @override
  String get revenueForecastNextQuarter => 'తదుపరి త్రైమాసికం';

  @override
  String get revenueForecastInsightsTitle => 'అంచనా అంతర్దృష్టులు';

  @override
  String get revenueForecastInsufficientData => 'అంచనాకు సరిపడా డేటా లేదు';

  @override
  String get revenueForecastPositive =>
      'ఇటీవల ధోరణుల ఆధారంగా ఆదాయం సానుకూల వృద్ధి చూపుతోంది. సామర్థ్య విస్తరణను పరిగణించండి.';

  @override
  String get revenueForecastDecline =>
      'ఇటీవల ధోరణుల ఆధారంగా ఆదాయం తగ్గుతోంది. ధరలు, మార్కెటింగ్ వ్యూహాలను సమీక్షించండి.';

  @override
  String get revenueForecastStable =>
      'ఇటీవల ధోరణుల ప్రకారం ఆదాయం స్థిరంగా ఉంది. ప్రస్తుత పనితీరును కొనసాగించడంపై దృష్టి పెట్టండి.';

  @override
  String get menuTooltip => 'మెను';

  @override
  String get analyticsTabRevenue => 'ఆదాయం';

  @override
  String get analyticsTabOccupancy => 'ఆక్రమణ';

  @override
  String get analyticsTabPerformance => 'పనితీరు';

  @override
  String get analyticsNoPgTitle => 'PG ని ఎంచుకోండి';

  @override
  String get analyticsNoPgMessage =>
      'విశ్లేషణలు చూడడానికి పై డ్రాప్‌డౌన్ నుండి PG ని ఎంచుకోండి';

  @override
  String get analyticsLoading => 'విశ్లేషణ డేటాను లోడ్ చేస్తున్నాం...';

  @override
  String get analyticsErrorTitle => 'డేటాను లోడ్ చేయడంలో లోపం';

  @override
  String get analyticsUnknownError => 'తెలియని లోపం జరిగింది';

  @override
  String analyticsLoadFailed(String error) {
    return 'విశ్లేషణ డేటాను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get performanceAnalyticsTitle => 'పనితీరు విశ్లేషణ';

  @override
  String get performanceAnalyticsSubtitle =>
      'సమగ్ర పనితీరు అంతర్దృష్టులు మరియు సిఫార్సులు';

  @override
  String get performanceKpiTitle => 'ప్రధాన పనితీరు సూచికలు';

  @override
  String get performanceKpiGuestSatisfaction => 'అతిథి సంతృప్తి';

  @override
  String performanceKpiGuestSatisfactionValue(String score) {
    return '$score/5';
  }

  @override
  String get performanceKpiResponseTime => 'ప్రతిస్పందన సమయం';

  @override
  String performanceKpiResponseTimeValue(String hours) {
    return '$hours గం.';
  }

  @override
  String get performanceKpiMaintenanceScore => 'నిర్వహణ స్కోరు';

  @override
  String performanceKpiMaintenanceScoreValue(String score) {
    return '$score/10';
  }

  @override
  String get performanceInsightsTitle => 'పనితీరు అంతర్దృష్టులు';

  @override
  String get performanceInsightsOverall => 'మొత్తం పనితీరు: అద్భుతం';

  @override
  String get performanceInsightsSummary =>
      'మీ PG పరిశ్రమ ప్రమాణాల కంటే మెరుగ్గా, అధిక అతిథి సంతృప్తి మరియు సమర్థవంతమైన కార్యకలాపాలతో పనిచేస్తోంది.';

  @override
  String get performanceRecommendationsTitle => 'సిఫార్సులు:';

  @override
  String get performanceRecommendationMaintainSchedule =>
      'ప్రస్తుత నిర్వహణ షెడ్యూల్‌ను కొనసాగించండి';

  @override
  String get performanceRecommendationExpandCapacity =>
      'అధిక ఆక్రమణ దృష్ట్యా విస్తరణను పరిగణించండి';

  @override
  String get performanceRecommendationFeedbackSystem =>
      'అతిథి ప్రతిస్పందన వ్యవస్థను అమలు చేయండి';

  @override
  String get performanceRecommendationOptimizeEnergy =>
      'ఖర్చు తగ్గించేందుకు ఎనర్జీ వినియోగాన్ని మెరుగుపరచండి';

  @override
  String get occupancyAnalyticsTitle => 'ఆక్రమణ విశ్లేషణ';

  @override
  String get occupancyAnalyticsSelectedPg =>
      'ఎంచుకున్న PG కోసం ఆక్రమణ అంతర్దృష్టులు';

  @override
  String get occupancyAnalyticsOverall => 'మొత్తం ఆక్రమణ పనితీరు';

  @override
  String get occupancyMetricCurrent => 'ప్రస్తుత ఆక్రమణ';

  @override
  String get occupancyMetricAverage => 'సగటు ఆక్రమణ';

  @override
  String get occupancyMetricPeak => 'శిఖర ఆక్రమణ';

  @override
  String get occupancyTrendsLabel => 'ఆక్రమణ ధోరణులు';

  @override
  String get occupancyViewOverview => 'అవలోకనం';

  @override
  String get occupancyViewByRoom => 'గది వారీగా';

  @override
  String get occupancyViewByFloor => 'అంతస్తు వారీగా';

  @override
  String occupancyTrendLastMonths(int months) {
    return 'ఆక్రమణ ధోరణి (గత $months నెలలు)';
  }

  @override
  String get occupancyCapacityTitle => 'సామర్థ్య విశ్లేషణ';

  @override
  String get occupancyCapacityAvailableBeds => 'లభ్యమైన పడకలు';

  @override
  String get occupancyCapacityOccupiedBeds => 'ఆక్రమించిన పడకలు';

  @override
  String get occupancyCapacityTotal => 'మొత్తం సామర్థ్యం';

  @override
  String get occupancyInsightsTitle => 'ఆక్రమణ అంతర్దృష్టులు';

  @override
  String get occupancyRecommendationsTitle => 'సిఫార్సులు:';

  @override
  String occupancyInsightsCurrentRate(String rate) {
    return 'ప్రస్తుత ఆక్రమణ $rate వద్ద ఉంది.';
  }

  @override
  String get occupancyInsightsNearFull =>
      'మీ PG దాదాపు పూర్తి సామర్థ్యంతో ఉంది. అదనపు గదులు లేదా పడకలను పరిగణించండి.';

  @override
  String get occupancyInsightsGood =>
      'ఆక్రమణ రేటు బాగుంది. ధోరణులను పరిశీలించి మార్కెటింగ్ వ్యూహాలను పరిగణించండి.';

  @override
  String get occupancyInsightsModerate =>
      'ఆక్రమణ మోస్తరు స్థాయిలో ఉంది. మెరుగైన మార్కెటింగ్ ద్వారా మెరుగుదలకు అవకాశం ఉంది.';

  @override
  String get occupancyInsightsLow =>
      'ఆక్రమణ రేటు తక్కువగా ఉంది. బుకింగ్‌లను పెంచడానికి తక్షణ చర్య అవసరం.';

  @override
  String get occupancyRecommendationAddCapacity =>
      'మరిన్ని పడకలు లేదా గదులను చేర్చడాన్ని పరిగణించండి';

  @override
  String get occupancyRecommendationReviewPricing =>
      'అధిక డిమాండ్ కోసం ధర వ్యూహాన్ని సమీక్షించండి';

  @override
  String get occupancyRecommendationMaintainOccupancy =>
      'ప్రస్తుత ఆక్రమణను కొనసాగించడంపై దృష్టి పెట్టండి';

  @override
  String get occupancyRecommendationSeasonalPricing =>
      'ఋతువారీ ధర సర్దుబాట్లను పరిగణించండి';

  @override
  String get occupancyRecommendationIncreaseMarketing =>
      'మార్కెటింగ్ ప్రయత్నాలను పెంచండి';

  @override
  String get occupancyRecommendationImproveAmenities =>
      'సౌకర్యాలను సమీక్షించి మెరుగుపరచండి';

  @override
  String get occupancyRecommendationCompetitivePricing =>
      'స్పర్ధాత్మక ధరలను పరిగణించండి';

  @override
  String get occupancyRecommendationUrgentCampaign =>
      'తక్షణ మార్కెటింగ్ ప్రచారం చేపట్టండి';

  @override
  String get occupancyRecommendationReducePricing =>
      'ధరలను సమీక్షించి తగ్గించండి';

  @override
  String get occupancyRecommendationImproveFacilities =>
      'సౌకర్యాలు మరియు సౌలభ్యాలను మెరుగుపరచండి';

  @override
  String get occupancyRecommendationPartnerships =>
      'స్థానిక వ్యాపారాలతో భాగస్వామ్యాలను పరిగణించండి';

  @override
  String get pgBasicInfoTitle => 'ప్రాథమిక సమాచారం';

  @override
  String get pgBasicInfoAddressLabel => 'పూర్తి చిరునామా';

  @override
  String get pgBasicInfoAddressHint => 'ల్యాండ్‌మార్క్‌తో పూర్తి చిరునామా';

  @override
  String get pgBasicInfoPgNameLabel => 'PG పేరు';

  @override
  String get pgBasicInfoPgNameHint => 'ఉదా: గ్రీన్ మెడోస్ PG';

  @override
  String get pgBasicInfoContactLabel => 'సంప్రదించు సంఖ్య';

  @override
  String get pgBasicInfoContactHint => 'ఉదా: +91 9876543210';

  @override
  String get pgBasicInfoStateLabel => 'రాష్ట్రం';

  @override
  String get pgBasicInfoStateHint => 'రాష్ట్రాన్ని ఎంచుకోండి';

  @override
  String get pgBasicInfoCityLabel => 'నగరం';

  @override
  String get pgBasicInfoCityHint => 'నగరాన్ని ఎంచుకోండి';

  @override
  String get pgBasicInfoAreaLabel => 'ప్రాంతం';

  @override
  String get pgBasicInfoAreaHint => 'ఉదా: సెక్టార్ 5, HSR Layout';

  @override
  String get pgBasicInfoPgTypeLabel => 'PG రకం';

  @override
  String get pgBasicInfoPgTypeHint => 'PG రకాన్ని ఎంచుకోండి';

  @override
  String get pgBasicInfoPgTypeBoys => 'బాయ్స్';

  @override
  String get pgBasicInfoPgTypeGirls => 'గర్ల్స్';

  @override
  String get pgBasicInfoPgTypeCoed => 'కో-ఎడ్';

  @override
  String get pgBasicInfoMealTypeLabel => 'భోజన రకం';

  @override
  String get pgBasicInfoMealTypeHint => 'భోజన రకాన్ని ఎంచుకోండి';

  @override
  String get pgBasicInfoMealTypeVeg => 'వెజిటేరియన్';

  @override
  String get pgBasicInfoMealTypeNonVeg => 'నాన్-వెజిటేరియన్';

  @override
  String get pgBasicInfoMealTypeBoth => 'రెండూ';

  @override
  String get pgBasicInfoFoodSectionTitle => 'ఆహారం & భోజన వివరాలు';

  @override
  String get pgBasicInfoMealTimingsLabel => 'భోజన సమయాలు';

  @override
  String get pgBasicInfoMealTimingsHint =>
      'ఉదా: బ్రేక్‌ఫాస్ట్: ఉదయం 8 - 10, లంచ్: మధ్యాహ్నం 1 - 2, డిన్నర్: రాత్రి 8 - 9.30';

  @override
  String get pgBasicInfoFoodQualityLabel => 'ఆహార నాణ్యత వివరణ';

  @override
  String get pgBasicInfoFoodQualityHint =>
      'ఆహార నాణ్యత, వంటకాలు, ప్రత్యేకతలు మొదలైనవిని వివరించండి';

  @override
  String get pgBasicInfoDescriptionLabel => 'వివరణ';

  @override
  String get pgBasicInfoDescriptionHint => 'మీ PG గురించి సంక్షిప్త వివరణ';

  @override
  String get pgFloorStructureTitle => '🏢 అంతస్తుల నిర్మాణం';

  @override
  String get pgFloorCountLabel => 'సాధారణ అంతస్తుల సంఖ్య';

  @override
  String get pgFloorCountHint => 'ఉదా: 1';

  @override
  String get generateAction => 'సృష్టించు';

  @override
  String get pgFloorGroundLabel => 'గ్రౌండ్';

  @override
  String get pgFloorTerraceLabel => 'టెర్రేస్';

  @override
  String get pgFloorFirstLabel => 'మొదటి';

  @override
  String get pgFloorSecondLabel => 'రెండవ';

  @override
  String get pgFloorThirdLabel => 'మూడవ';

  @override
  String get pgFloorFourthLabel => 'నాలుగవ';

  @override
  String get pgFloorFifthLabel => 'ఐదవ';

  @override
  String pgFloorNthLabel(int number) {
    return '$numberవ అంతస్తు';
  }

  @override
  String pgFloorRoomsBedsSummary(int rooms, int beds) {
    return '$rooms గదులు • $beds పడకలు';
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
    return 'గది $roomNumber';
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
    return '$count ఫోటోలు విజయవంతంగా అప్లోడ్ అయ్యాయి!';
  }

  @override
  String pgPhotosUploadPartial(int success, int failed) {
    return '$success ఫోటోలు అప్లోడ్ అయ్యాయి, $failed విఫలమయ్యాయి.';
  }

  @override
  String get pgPhotosUploadFailed => 'ఫోటోల్ని అప్లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get pgPhotosEmptyTitle => 'No photos added yet';

  @override
  String get pgPhotosEmptySubtitle => 'Click \"Add Photos\" to upload images';

  @override
  String get pgPhotosRemoveAction => 'Remove photo';

  @override
  String get pgAdditionalInfoTitle => 'అదనపు సమాచారం';

  @override
  String get pgAdditionalInfoParkingLabel => 'పార్కింగ్ వివరాలు';

  @override
  String get pgAdditionalInfoParkingHint =>
      'ఉదా., 2-చక్రాల పార్కింగ్ అందుబాటు, 4-చక్రాల పార్కింగ్: ₹500/నెల, సామర్థ్యం: 20 బైకులు';

  @override
  String get pgAdditionalInfoSecurityLabel => 'భద్రతా చర్యలు';

  @override
  String get pgAdditionalInfoSecurityHint =>
      'ఉదా., 24/7 భద్రతా గార్డు, సీసీటీవీ పర్యవేక్షణ, బయోమెట్రిక్ యాక్సెస్, ఫైర్ సేఫ్టీ పరికరాలు';

  @override
  String get pgAdditionalInfoNearbyPlacesTitle => 'సమీప ప్రదేశాలు';

  @override
  String get pgAdditionalInfoNearbyPlacesDescription =>
      'సమీపంలోని గుర్తించదగిన స్థలాలు లేదా ఆసక్తి ప్రదేశాలను జోడించండి';

  @override
  String get pgAdditionalInfoNearbyPlaceLabel => 'సమీప ప్రదేశం';

  @override
  String get pgAdditionalInfoNearbyPlaceHint =>
      'ఉదా., మెట్రో స్టేషన్, షాపింగ్ మాల్, ఆసుపత్రి';

  @override
  String get pgAdditionalInfoAddButton => 'జోడించండి';

  @override
  String get pgAdditionalInfoPaymentInstructionsLabel => 'చెల్లింపు సూచనలు';

  @override
  String get pgAdditionalInfoPaymentInstructionsHint =>
      'చెల్లింపులు చేసే సూచనలు, అంగీకరించిన చెల్లింపు విధానాలు, చెల్లింపు షెడ్యూల్ మొదలైనవి.';

  @override
  String get pgAmenitiesTitle => 'సౌకర్యాలు & సదుపాయాలు';

  @override
  String get pgAmenitiesDescription =>
      'మీ PGలో అందుబాటులో ఉన్న అన్ని సౌకర్యాలను ఎంపిక చేయండి:';

  @override
  String get pgAmenitiesSelectedLabel => 'ఎంపిక చేసినవి';

  @override
  String get pgAmenityWifi => 'వైఫై';

  @override
  String get pgAmenityParking => 'పార్కింగ్';

  @override
  String get pgAmenitySecurity => 'భద్రత';

  @override
  String get pgAmenityCctv => 'సీసీటీవీ';

  @override
  String get pgAmenityLaundry => 'లాండ్రీ';

  @override
  String get pgAmenityKitchen => 'వంటగది';

  @override
  String get pgAmenityAc => 'ఏసీ';

  @override
  String get pgAmenityGeyser => 'గీజర్';

  @override
  String get pgAmenityTv => 'టీవీ';

  @override
  String get pgAmenityRefrigerator => 'ఫ్రిజ్';

  @override
  String get pgAmenityPowerBackup => 'పవర్ బ్యాకప్';

  @override
  String get pgAmenityGym => 'జిమ్';

  @override
  String get pgAmenityCurtains => 'పర్దాలు';

  @override
  String get pgAmenityBucket => 'బకెట్';

  @override
  String get pgAmenityWaterCooler => 'వాటర్ కూలర్';

  @override
  String get pgAmenityWashingMachine => 'వాషింగ్ మెషీన్';

  @override
  String get pgAmenityMicrowave => 'మైక్రోవేవ్';

  @override
  String get pgAmenityLift => 'లిఫ్ట్';

  @override
  String get pgAmenityHousekeeping => 'హౌస్ కీపింగ్';

  @override
  String get pgAmenityAttachedBathroom => 'అటాచ్‌డ్ బాత్రూమ్';

  @override
  String get pgAmenityRoWater => 'ఆర్‌ఓ నీరు';

  @override
  String get pgAmenityWaterSupply => '24x7 నీటి సరఫరా';

  @override
  String get pgAmenityBedWithMattress => 'మెట్రెస్‌తో బెడ్';

  @override
  String get pgAmenityWardrobe => 'వార్డ్రోబ్';

  @override
  String get pgAmenityStudyTable => 'స్టడీ టేబుల్';

  @override
  String get pgAmenityChair => 'కుర్చీ';

  @override
  String get pgAmenityFan => 'ఫ్యాన్';

  @override
  String get pgAmenityLighting => 'లైటింగ్';

  @override
  String get pgAmenityBalcony => 'బాల్కనీ';

  @override
  String get pgAmenityCommonArea => 'కామన్ ఏరియా';

  @override
  String get pgAmenityDiningArea => 'డైనింగ్ ఏరియా';

  @override
  String get pgAmenityInductionStove => 'ఇండక్షన్ స్టోవ్';

  @override
  String get pgAmenityCookingAllowed => 'వంటకు అనుమతి';

  @override
  String get pgAmenityFireExtinguisher => 'ఫైర్ ఎక్స్టింగ్విషర్';

  @override
  String get pgAmenityFirstAidKit => 'ఫస్ట్ ఎయిడ్ కిట్';

  @override
  String get pgAmenitySmokeDetector => 'స్మోక్ డిటెక్టర్';

  @override
  String get pgAmenityVisitorParking => 'విజిటర్ పార్కింగ్';

  @override
  String get pgAmenityIntercom => 'ఇంటర్‌కామ్';

  @override
  String get pgAmenityMaintenanceStaff => 'మెయింటెనెన్స్ సిబ్బంది';

  @override
  String get pgSummaryTitle => 'PG సమీక్ష';

  @override
  String get pgSummaryBasicInfoTitle => 'ప్రాథమిక సమాచారం';

  @override
  String get pgSummaryRentInfoTitle => 'అద్దె సమాచారం';

  @override
  String get pgSummaryPhotosTitle => 'ఫోటోలు';

  @override
  String get pgSummaryActionCreate => 'సృష్టించండి';

  @override
  String get pgSummaryActionUpdate => 'నవీకరించండి';

  @override
  String pgSummaryReadyMessage(String action) {
    return 'మీ PGని $action చేయడానికి సిద్ధంగా ఉంది!';
  }

  @override
  String get pgSummaryReviewMessage =>
      'పైన ఉన్న అన్ని వివరాలను సమీక్షించి, సేవ్ బటన్‌ను నొక్కండి.';

  @override
  String get pgSummaryNotSpecified => 'ఉల్లేఖించలేదు';

  @override
  String get pgSummaryLocationLabel => 'స్థానం';

  @override
  String pgSummaryLocationValue(String city, String state) {
    return '$city, $state';
  }

  @override
  String get pgSummaryTotalFloorsLabel => 'మొత్తం అంతస్తులు';

  @override
  String get pgSummaryTotalRoomsLabel => 'మొత్తం గదులు';

  @override
  String get pgSummaryTotalBedsLabel => 'మొత్తం పడకలు';

  @override
  String get pgSummaryEstimatedRevenueLabel => 'అంచనా నెలవారీ ఆదాయం';

  @override
  String get pgSummaryMaintenanceLabel => 'నిర్వహణ';

  @override
  String get pgSummarySelectedAmenitiesLabel => 'ఎంపిక చేసిన సౌకర్యాలు';

  @override
  String get pgSummaryListLabel => 'జాబితా';

  @override
  String get pgSummaryUploadedPhotosLabel => 'అప్‌లోడ్ చేసిన ఫోటోలు';

  @override
  String get pgInfoNoPgSelected => 'ఏ PG ఎంపిక కాలేదు';

  @override
  String get pgInfoSelectPgPrompt =>
      'దయచేసి పై డ్రాప్‌డౌన్ నుండి ఒక PGని ఎంపిక చేయండి';

  @override
  String get pgInfoEditTooltip => 'PG వివరాలను సవరించండి';

  @override
  String get pgInfoContactNotProvided => 'అందుబాటులో లేదు';

  @override
  String get pgInfoPgTypeFallback => 'PG';

  @override
  String get pgInfoLocationFallback => 'స్థానం అందుబాటులో లేదు';

  @override
  String get pgInfoStructureOverview => 'PG నిర్మాణ అవలోకనం';

  @override
  String get pgInfoFloorsLabel => 'అంతస్తులు';

  @override
  String get pgInfoRoomsLabel => 'గదులు';

  @override
  String get pgInfoBedsLabel => 'పడకలు';

  @override
  String get pgInfoPotentialLabel => 'సంభావ్యత';

  @override
  String get pgInfoFloorRoomDetails => 'అంతస్తులు & గదుల వివరాలు';

  @override
  String pgInfoRoomsSummary(int count) {
    return '$count గదులు';
  }

  @override
  String pgInfoRoomChip(String roomNumber, String sharingType, int bedsCount) {
    return '$roomNumber ($sharingType, $bedsCount పడకలు)';
  }

  @override
  String get pgFloorLabelFallback => 'అంతస్తు';

  @override
  String get ownerBedMapRoomUnknown => 'తెలియని';

  @override
  String ownerBedMapOccupancySummary(int occupied, int total, int capacity) {
    return '$occupied/$total ఆక్రమణ • సామర్థ్యం $capacity';
  }

  @override
  String ownerBedMapStatusChipOccupied(int count) {
    return 'ఆక్రమణ $count';
  }

  @override
  String ownerBedMapStatusChipVacant(int count) {
    return 'ఖాళీ $count';
  }

  @override
  String ownerBedMapStatusChipPending(int count) {
    return 'పెండింగ్ $count';
  }

  @override
  String ownerBedMapStatusChipMaintenance(int count) {
    return 'నిర్వహణ $count';
  }

  @override
  String get ownerBedMapBedsOverview => 'పడకల అవలోకనం';

  @override
  String get ownerBedMapMiniStatTotal => 'మొత్తం';

  @override
  String get ownerBedMapMiniStatOccupied => 'ఆక్రమణ';

  @override
  String get ownerBedMapMiniStatVacant => 'ఖాళీ';

  @override
  String get ownerBedMapMiniStatPending => 'పెండింగ్';

  @override
  String get ownerBedMapMiniStatMaintenance => 'నిర్వహణ';

  @override
  String ownerBedMapPlaceholderSummary(int occupied, int total) {
    return '$occupied/$total ఆక్రమణ';
  }

  @override
  String get ownerBedMapStatusOccupiedLabel => 'ఆక్రమణ';

  @override
  String get ownerBedMapStatusPendingLabel => 'పెండింగ్';

  @override
  String get ownerBedMapStatusMaintenanceLabel => 'నిర్వహణ';

  @override
  String get ownerBedMapStatusVacantLabel => 'ఖాళీ';

  @override
  String ownerBedMapTooltipTitle(String bedNumber, String status) {
    return 'పడక $bedNumber • $status';
  }

  @override
  String ownerBedMapTooltipGuest(String guest) {
    return 'అతిథి: $guest';
  }

  @override
  String ownerBedMapTooltipFrom(String date) {
    return 'ప్రారంభం: $date';
  }

  @override
  String ownerBedMapTooltipTill(String date) {
    return 'ముగింపు: $date';
  }

  @override
  String get ownerRevenueReportTitle => 'ఆదాయ నివేదిక';

  @override
  String get ownerRevenueReportCollectedLabel => 'సేకరించబడినది';

  @override
  String get ownerRevenueReportPendingLabel => 'పెండింగ్';

  @override
  String get ownerRevenueReportTotalPaymentsLabel => 'మొత్తం చెల్లింపులు';

  @override
  String get ownerRevenueReportCollectedCountLabel => 'సేకరించిన సంఖ్య';

  @override
  String get ownerOccupancyReportTitle => 'ఆక్యుపెన్సీ నివేదిక';

  @override
  String get ownerOccupancyReportTotalBedsLabel => 'మొత్తం పడకలు';

  @override
  String get ownerOccupancyReportOccupiedLabel => 'ఆక్రమణలో';

  @override
  String get ownerOccupancyReportVacantLabel => 'ఖాళీ';

  @override
  String get ownerOccupancyReportRateLabel => 'ఆక్యుపెన్సీ శాతం';

  @override
  String get ownerOccupancyReportPendingLabel => 'పెండింగ్';

  @override
  String get ownerOccupancyReportMaintenanceLabel => 'నిర్వహణ';

  @override
  String ownerBookingRequestsTitle(int count) {
    return 'పెండింగ్ అభ్యర్థనలు ($count)';
  }

  @override
  String ownerUpcomingVacatingTitle(int count) {
    return 'త్వరలో ఖాళీ అవుతున్నవి ($count)';
  }

  @override
  String get ownerServiceZeroRequests => '0 అభ్యర్ధనలు';

  @override
  String get ownerPaymentUpdateFailed => 'చెల్లింపును నవీకరించడం విఫలమైంది';

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
  String get ownerHelpTitle => 'సహాయం & మద్దతు';

  @override
  String get ownerHelpQuickHelp => 'త్వరిత సహాయం';

  @override
  String get ownerHelpHeroSubtitle =>
      'మీ PG ఆస్తులను నిర్వహించే సాధారణ ప్రశ్నలకు వెంటనే సమాధానాలు పొందండి.';

  @override
  String get ownerHelpVideosTitle => 'వీడియో ట్యుటోరియల్స్';

  @override
  String get ownerHelpVideosSubtitle => 'దశలవారీ మార్గదర్శకాలు చూడండి';

  @override
  String get ownerHelpUnableToOpenVideos =>
      'వీడియో ట్యుటోరియల్స్ తెరవడం సాధ్యం కాలేదు';

  @override
  String get ownerHelpDocsTitle => 'డాక్యుమెంటేషన్';

  @override
  String get ownerHelpDocsSubtitle => 'విస్తృత మార్గదర్శకాలను చదవండి';

  @override
  String get ownerHelpUnableToOpenDocs => 'డాక్యుమెంటేషన్ తెరవడం సాధ్యం కాలేదు';

  @override
  String get ownerHelpFaqTitle => 'తరచుగా అడిగే ప్రశ్నలు';

  @override
  String get ownerHelpFaqAddPgQuestion => 'కొత్త PG ఆస్తిని ఎలా జోడించాలి?';

  @override
  String get ownerHelpFaqAddPgAnswer =>
      '\"My PGs\" టాబ్‌కి వెళ్లి \"Add New PG\" పై నొక్కండి. వివరాలను నమోదు చేసి సమర్పించండి.';

  @override
  String get ownerHelpFaqBookingsQuestion =>
      'అతిథుల బుకింగ్‌లను ఎలా నిర్వహించాలి?';

  @override
  String get ownerHelpFaqBookingsAnswer =>
      '\"Guests\" టాబ్‌ను తెరిచి బుకింగ్ అభ్యర్థనలను పరిశీలించి ఆమోదించండి లేదా తిరస్కరించండి.';

  @override
  String get ownerHelpFaqPaymentsQuestion => 'చెల్లింపు చరిత్రను ఎలా చూడాలి?';

  @override
  String get ownerHelpFaqPaymentsAnswer =>
      '\"Overview\" లేదా \"Guests\" సెక్షన్‌లో అతిథుల వారీగా చెల్లింపులను తనిఖీ చేయండి.';

  @override
  String get ownerHelpFaqProfileQuestion =>
      'నా ప్రొఫైల్‌ను ఎలా అప్‌డేట్ చేయాలి?';

  @override
  String get ownerHelpFaqProfileAnswer =>
      'డ్రాయర్ మెనూను తెరిచి \"My Profile\" పై నొక్కి మీ సమాచారాన్ని అప్‌డేట్ చేయండి.';

  @override
  String get ownerHelpContactTitle => 'సపోర్ట్‌ను సంప్రదించండి';

  @override
  String get ownerHelpContactSubtitle =>
      'ఇంకా సహాయం కావాలా? మా సపోర్ట్ టీంను సంప్రదించండి.';

  @override
  String get ownerHelpEmailTitle => 'ఇమెయిల్ సపోర్ట్';

  @override
  String get ownerHelpPhoneTitle => 'ఫోన్ సపోర్ట్';

  @override
  String get ownerHelpChatTitle => 'లైవ్ చాట్';

  @override
  String get ownerHelpChatSubtitle => 'WhatsApp: +91 7020797849';

  @override
  String get ownerHelpUnableToOpenChat =>
      'చాట్ తెరవడం సాధ్యం కాలేదు. దయచేసి WhatsApp ప్రయత్నించండి: +91 7020797849';

  @override
  String get ownerHelpResourcesTitle => 'వనరులు';

  @override
  String get ownerHelpPrivacyPolicy => 'గోప్యతా విధానం';

  @override
  String get ownerHelpTermsOfService => 'సేవా నిబంధనలు';

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
  String get ownerNotificationsEmptyMessage => 'నోటిఫికేషన్‌లు లేవు';

  @override
  String get ownerNotificationsFilterAll => 'అన్నీ';

  @override
  String get ownerNotificationsFilterUnread => 'Unread';

  @override
  String get ownerNotificationsFilterBookings => 'Bookings';

  @override
  String get ownerNotificationsFilterPayments => 'Payments';

  @override
  String get ownerNotificationsFilterComplaints => 'Complaints';

  @override
  String get ownerNotificationsFilterBedChanges => 'పడక మార్పులు';

  @override
  String get ownerNotificationsFilterServices => 'సేవలు';

  @override
  String get ownerNotificationsDefaultTitle => 'నోటిఫికేషన్';

  @override
  String get ownerNotificationsDefaultBody => 'సందేశం లేదు';

  @override
  String get ownerNotificationsMarkAll => 'అన్నింటినీ చదివినట్లు గుర్తించండి';

  @override
  String get ownerNotificationsJustNow => 'ఇప్పుడే';

  @override
  String ownerNotificationsMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count నిమిషాల క్రితం',
      one: '$count నిమిషం క్రితం',
    );
    return '$_temp0';
  }

  @override
  String ownerNotificationsHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count గంటల క్రితం',
      one: '$count గంట క్రితం',
    );
    return '$_temp0';
  }

  @override
  String ownerNotificationsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count రోజుల క్రితం',
      one: '$count రోజు క్రితం',
    );
    return '$_temp0';
  }

  @override
  String get drawerDefaultUserName => 'వినియోగదారు';

  @override
  String get drawerDefaultInitial => 'యు';

  @override
  String drawerVersionLabel(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get drawerContactEmail => 'contact@charyatani.com';

  @override
  String get drawerContactPhone => '+91 98765 43210';

  @override
  String get drawerContactWebsite => 'www.charyatani.com';

  @override
  String get ownerSpecialMenuEditTitle => 'ప్రత్యేక మెను మార్చండి';

  @override
  String get ownerSpecialMenuAddTitle => 'ప్రత్యేక మెను జోడించండి';

  @override
  String get ownerSpecialMenuSaving => 'ప్రత్యేక మెను సేవ్ అవుతోంది...';

  @override
  String get ownerSpecialMenuSaveButton => 'ప్రత్యేక మెను సేవ్ చేయండి';

  @override
  String get ownerSpecialMenuFestivalHeading => 'పండుగ/ఈవెంట్ పేరు';

  @override
  String get ownerSpecialMenuFestivalHint =>
      'ఉదా., దీపావళి, ఉగాది, ప్రత్యేక కార్యక్రమం';

  @override
  String get ownerSpecialMenuSpecialNoteHeading => 'ప్రత్యేక సూచన';

  @override
  String get ownerSpecialMenuSpecialNoteLabel => 'గమనిక';

  @override
  String get ownerSpecialMenuSpecialNoteHint =>
      'ప్రత్యేక సూచనలు లేదా వివరాలు...';

  @override
  String get ownerSpecialMenuFallbackInfo =>
      'ఈ రోజు కోసం డిఫాల్ట్ వారపు మెనును ఉపయోగించడానికి మీల్ విభాగాలను ఖాళీగా ఉంచండి';

  @override
  String ownerSpecialMenuOptionalSection(String meal) {
    return '$meal (ఐచ్చికం)';
  }

  @override
  String get ownerSpecialMenuNoItems => 'ఇటమ్స్ ఏవి జోడించలేదు';

  @override
  String get ownerSpecialMenuAddItem => 'ఇటమ్ జోడించండి';

  @override
  String ownerSpecialMenuAddMealItemTitle(String mealType) {
    return '$mealType ఐటమ్ జోడించండి';
  }

  @override
  String get ownerSpecialMenuItemNameLabel => 'ఇటమ్ పేరు';

  @override
  String get ownerSpecialMenuItemNameHint => 'భోజన అంశం పేరును నమోదు చేయండి';

  @override
  String get ownerSpecialMenuFestivalRequired =>
      'దయచేసి పండుగ/ఈవెంట్ పేరు నమోదు చేయండి';

  @override
  String get ownerSpecialMenuSaveSuccess =>
      'ప్రత్యేక మెను విజయవంతంగా సేవ్ చేయబడింది!';

  @override
  String ownerSpecialMenuSaveFailed(String error) {
    return 'ప్రత్యేక మెను సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerSpecialMenuSaveError(String error) {
    return 'ప్రత్యేక మెను సేవ్ చేయడంలో లోపం: $error';
  }

  @override
  String ownerMenuEditTitleEdit(String day) {
    return '$day మెను సవరించండి';
  }

  @override
  String ownerMenuEditTitleCreate(String day) {
    return '$day మెను సృష్టించండి';
  }

  @override
  String get ownerMenuEditDeleteTooltip => 'మెను తొలగించండి';

  @override
  String get ownerMenuEditSaving => 'మెను సేవ్ అవుతోంది...';

  @override
  String get ownerMenuEditUpdateButton => 'మెను నవీకరించండి';

  @override
  String get ownerMenuEditCreateButton => 'మెను సృష్టించండి';

  @override
  String ownerMenuEditOverviewTitle(String day) {
    return '$day మెను';
  }

  @override
  String get ownerMenuEditOverviewSubtitle =>
      'రోజువారీ మెనూను సృష్టించండి మరియు నిర్వహించండి';

  @override
  String get ownerMenuEditStatItems => 'అంశాలు';

  @override
  String get ownerMenuEditStatPhotos => 'ఫోటోలు';

  @override
  String ownerMenuEditOptionalSection(String meal) {
    return '$meal (ఐచ్చికం)';
  }

  @override
  String ownerMenuEditLastUpdated(String timestamp) {
    return 'చివరిసారి నవీకరించిన తేదీ: $timestamp';
  }

  @override
  String get ownerMenuEditPhotosHeading => 'మెను ఫోటోలు';

  @override
  String get ownerMenuEditAddPhoto => 'ఫోటో జోడించండి';

  @override
  String get ownerMenuEditUploadingPhoto => 'ఫోటో అప్లోడ్ అవుతోంది...';

  @override
  String get ownerMenuEditBadgeNew => 'కొత్త';

  @override
  String get ownerMenuEditNoPhotos => 'ఇప్పటికీ ఫోటోలు జోడించలేదు';

  @override
  String ownerMenuEditItemsCount(int count) {
    return '$count అంశాలు';
  }

  @override
  String ownerMenuEditAddItemTooltip(String meal) {
    return '$meal అంశాన్ని జోడించండి';
  }

  @override
  String ownerMenuEditNoItemsForMeal(String meal) {
    return '$meal కోసం ఇంకా అంశాలు జోడించలేదు';
  }

  @override
  String get ownerMenuEditRemoveItemTooltip => 'అంశాన్ని తొలగించండి';

  @override
  String get ownerMenuEditDescriptionHeading => 'వివరణ (ఐచ్చికం)';

  @override
  String get ownerMenuEditDescriptionLabel => 'మెను వివరణ';

  @override
  String get ownerMenuEditDescriptionHint =>
      'ఈ మెనుకు సంబంధించిన ఏదైనా ప్రత్యేక గమనికలను జోడించండి...';

  @override
  String ownerMenuEditAddMealItemTitle(String mealType) {
    return '$mealType అంశాన్ని జోడించండి';
  }

  @override
  String get ownerMenuEditItemNameLabel => 'అంశం పేరు';

  @override
  String get ownerMenuEditItemNameHint => 'ఉదా., ఇడ్లీ సాంబార్, దోస, ఉప్మా';

  @override
  String get ownerMenuEditMealRequired =>
      'దయచేసి కనీసం ఒక భోజన అంశాన్ని జోడించండి';

  @override
  String get ownerMenuEditAuthError =>
      'లోపం: వినియోగదారు ధృవీకరించబడలేదు. దయచేసి మళ్లీ లాగిన్ అవండి.';

  @override
  String ownerMenuEditUpdateSuccess(String day) {
    return '$day మెను విజయవంతంగా నవీకరించబడింది!';
  }

  @override
  String ownerMenuEditCreateSuccess(String day) {
    return '$day మెను విజయవంతంగా సృష్టించబడింది!';
  }

  @override
  String ownerMenuEditSaveFailed(String error) {
    return 'మెనూ సేవ్ చేయడం విఫలమైంది: $error';
  }

  @override
  String ownerMenuEditSaveError(String error) {
    return 'మెనును సేవ్ చేయడంలో లోపం: $error';
  }

  @override
  String get ownerMenuEditClearTitle => 'మెనును క్లియర్ చేయాలా?';

  @override
  String get ownerMenuEditClearMessage =>
      'ఈ మెనును నిజంగా క్లియర్ చేయాలనుకుంటున్నారా? దీని వల్ల అన్ని అంశాలు మరియు ఫోటోలు తొలగించబడతాయి.';

  @override
  String get ownerMenuEditClearConfirm => 'క్లియర్';

  @override
  String get ownerMenuEditClearSnackbar =>
      'మెను క్లియర్ చేయబడింది. మార్పులను సేవ్ చేయడం మర్చిపోవద్దు.';

  @override
  String ownerMenuEditImagePickError(String error) {
    return 'చిత్రాన్ని ఎంచుకోవడం విఫలమైంది: $error';
  }

  @override
  String get chooseYourPreferredTheme => 'మీకు ఇష్టమైన థీమ్‌ను ఎంచుకోండి';

  @override
  String get selectPreferredLanguage => 'మీకు ఇష్టమైన భాషను ఎంచుకోండి';

  @override
  String get dataPrivacy => 'డేటా వ్యక్తిగతత';

  @override
  String get about => 'గురించి';

  @override
  String get receiveNotificationsOnYourDevice =>
      'మీ పరికరంలో నోటిఫికేషన్లు పొందండి';

  @override
  String get receiveNotificationsViaEmail =>
      'ఇమెయిల్ ద్వారా నోటిఫికేషన్లు పొందండి';

  @override
  String get getRemindersForPendingPayments =>
      'పెండింగ్ చెల్లింపుల కోసం రిమైండర్లు పొందండి';

  @override
  String get ownerReportsSelectPeriod => 'రిపోర్ట్ కాలాన్ని ఎంచుకోండి';

  @override
  String get ownerReportsSelectDateRange => 'తేదీ పరిధిని ఎంచుకోండి';

  @override
  String get ownerReportsRefresh => 'రిపోర్టులను రిఫ్రెష్ చేయి';

  @override
  String get ownerReportsTabRevenue => 'ఆదాయం';

  @override
  String get ownerReportsTabBookings => 'బుకింగ్స్';

  @override
  String get ownerReportsTabGuests => 'అతిథులు';

  @override
  String get ownerReportsTabPayments => 'చెల్లింపులు';

  @override
  String get ownerReportsTabComplaints => 'ఫిర్యాదులు';

  @override
  String get ownerReportsLoading => 'రిపోర్టులను లోడ్ చేస్తున్నాం...';

  @override
  String get ownerReportsErrorTitle => 'రిపోర్టులను లోడ్ చేయడంలో లోపం';

  @override
  String get ownerReportsNoRevenueData => 'ఆదాయం డేటా లేదు';

  @override
  String get ownerReportsRevenuePlaceholder =>
      'మీ వద్ద బుకింగ్స్ ఉన్న తర్వాత ఆదాయం డేటా ఇక్కడ కనిపిస్తుంది';

  @override
  String get ownerReportsAveragePerMonth => 'సగటు / నెల';

  @override
  String get ownerReportsMonthlyRevenueBreakdown => 'నెలవారీ ఆదాయం విభజన';

  @override
  String get ownerReportsTotalBookings => 'మొత్తం బుకింగ్స్';

  @override
  String get ownerReportsPendingRequests => 'పెండింగ్ అభ్యర్థనలు';

  @override
  String get ownerReportsTotalReceived => 'మొత్తం స్వీకరించబడింది';

  @override
  String get ownerReportsPaidCount => 'చెల్లించిన సంఖ్య';

  @override
  String get ownerReportsPendingCount => 'పెండింగ్ సంఖ్య';

  @override
  String get ownerReportsChangeDateRange => 'మార్చు';

  @override
  String get ownerReportsPropertyWiseRevenue => 'ఆస్తి వారీ ఆదాయం';

  @override
  String ownerReportsPercentageOfTotal(String percentage) {
    return 'మొత్తంలో $percentage%';
  }

  @override
  String get ownerReportsBookingTrends => 'బుకింగ్ ధోరణులు';

  @override
  String get ownerReportsNoBookingData =>
      'ఎంచుకున్న కాలానికి బుకింగ్ డేటా అందుబాటులో లేదు';

  @override
  String ownerReportsBookingsCount(int count) {
    return '$count బుకింగ్స్';
  }

  @override
  String get ownerReportsGuestStatistics => 'అతిథి గణాంకాలు';

  @override
  String get ownerReportsPaymentTrends => 'చెల్లింపు ధోరణులు';

  @override
  String get ownerReportsNoPaymentData =>
      'ఎంచుకున్న కాలానికి చెల్లింపు డేటా అందుబాటులో లేదు';

  @override
  String get ownerReportsComplaintTrends => 'ఫిర్యాదు ధోరణులు';

  @override
  String get ownerReportsNoComplaintData =>
      'ఎంచుకున్న కాలానికి ఫిర్యాదు డేటా అందుబాటులో లేదు';

  @override
  String ownerReportsComplaintsCount(int count) {
    return '$count ఫిర్యాదులు';
  }

  @override
  String get ownerOverviewOccupancyRate => 'ఆక్రమణ రేటు';

  @override
  String get ownerOverviewPerformanceExcellent => 'అత్యుత్తమం';

  @override
  String get ownerOverviewPerformanceGood => 'బాగుంది';

  @override
  String get ownerOverviewPerformanceFair => 'సగటు స్థాయి';

  @override
  String get ownerOverviewPerformanceNeedsAttention => 'శ్రద్ధ అవసరం';

  @override
  String ownerOverviewPgLabel(int index, String name) {
    return '${index}PG: $name';
  }

  @override
  String get ownerOverviewAveragePerMonth => 'సగటు / నెల';

  @override
  String get ownerOverviewHighestMonth => 'అత్యధిక నెల';

  @override
  String get ownerProfileTitle => 'నా ప్రొఫైల్';

  @override
  String get ownerProfileSaveTooltip => 'ప్రొఫైల్‌ను సేవ్ చేయండి';

  @override
  String get ownerProfileTabPersonalInfo => 'వ్యక్తిగత సమాచారం';

  @override
  String get ownerProfileTabBusinessInfo => 'వ్యాపార సమాచారం';

  @override
  String get ownerProfileTabDocuments => 'పత్రాలు';

  @override
  String get ownerProfileFullNameLabel => 'పూర్తి పేరు';

  @override
  String get ownerProfileFullNameHint => 'మీ పూర్తి పేరును నమోదు చేయండి';

  @override
  String get ownerProfileEmailLabel => 'ఇమెయిల్';

  @override
  String get ownerProfileEmailHint => 'మీ ఇమెయిల్‌ను నమోదు చేయండి';

  @override
  String get ownerProfilePhoneLabel => 'ఫోన్ నంబర్';

  @override
  String get ownerProfilePhoneHint => 'మీ ఫోన్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get ownerProfileAddressLabel => 'PG చిరునామా';

  @override
  String get ownerProfileAddressHint => 'మీ PG చిరునామాను నమోదు చేయండి';

  @override
  String get ownerProfileStateLabel => 'రాష్ట్రం';

  @override
  String get ownerProfileStateHint => 'రాష్ట్రాన్ని ఎంచుకోండి';

  @override
  String get ownerProfileCityLabel => 'నగరం';

  @override
  String get ownerProfileCityHint => 'నగరాన్ని ఎంచుకోండి';

  @override
  String get ownerProfileCityHintSelectState => 'ముందు రాష్ట్రాన్ని ఎంచుకోండి';

  @override
  String get ownerProfilePincodeLabel => 'పిన్‌కోడ్';

  @override
  String get ownerProfilePincodeHint => 'పిన్‌కోడ్‌ను నమోదు చేయండి';

  @override
  String get ownerProfileSavePersonal => 'వ్యక్తిగత సమాచారాన్ని సేవ్ చేయండి';

  @override
  String get ownerProfileBusinessNameLabel => 'వ్యాపార పేరు';

  @override
  String get ownerProfileBusinessNameHint => 'వ్యాపార పేరును నమోదు చేయండి';

  @override
  String get ownerProfileBusinessTypeLabel => 'వ్యాపార రకం';

  @override
  String get ownerProfileBusinessTypeHint => 'వ్యాపార రకాన్ని నమోదు చేయండి';

  @override
  String get ownerProfilePanLabel => 'PAN నంబర్';

  @override
  String get ownerProfilePanHint => 'PAN నంబర్‌ను నమోదు చేయండి';

  @override
  String get ownerProfileGstLabel => 'GST నంబర్';

  @override
  String get ownerProfileGstHint => 'GST నంబర్‌ను నమోదు చేయండి';

  @override
  String get ownerProfileSaveBusiness => 'వ్యాపార సమాచారాన్ని సేవ్ చేయండి';

  @override
  String get ownerProfileDocumentProfileTitle => 'ప్రొఫైల్ ఫోటో';

  @override
  String get ownerProfileDocumentProfileDescription =>
      'మీ ప్రొఫైల్ ఫోటోను అప్‌లోడ్ చేయండి';

  @override
  String get ownerProfileDocumentAadhaarTitle => 'ఆధార్ ఫోటో';

  @override
  String get ownerProfileDocumentAadhaarDescription =>
      'మీ ఆధార్ కార్డ్ ఫోటోను అప్‌లోడ్ చేయండి';

  @override
  String get ownerProfileDocumentUpload => 'అప్‌లోడ్ చేయండి';

  @override
  String get ownerProfileDocumentUpdate => 'నవీకరించండి';

  @override
  String ownerProfilePickImageFailed(String error) {
    return 'చిత్రాన్ని ఎంచుకోవడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerIdNotAvailable => 'యజమాని ID అందుబాటులో లేదు';

  @override
  String get ownerProfileNotFound => 'ప్రొఫైల్ కనుగొనబడలేదు';

  @override
  String get ownerProfileLoadFailed => 'ప్రొఫైల్‌ను లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerProfileStreamFailed => 'ప్రొఫైల్ స్ట్రీమ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerProfileStreamStartFailed =>
      'ప్రొఫైల్ స్ట్రీమ్ ప్రారంభించడంలో విఫలమైంది';

  @override
  String get ownerProfileCreateFailed => 'ప్రొఫైల్ సృష్టించడంలో విఫలమైంది';

  @override
  String get ownerProfileUpdateFailed => 'ప్రొఫైల్‌ను నవీకరించడంలో విఫలమైంది';

  @override
  String get ownerBankDetailsUpdateFailed =>
      'బ్యాంక్ వివరాలను నవీకరించడంలో విఫలమైంది';

  @override
  String get ownerBusinessInfoUpdateFailed =>
      'వ్యాపార సమాచారాన్ని నవీకరించడంలో విఫలమైంది';

  @override
  String get ownerProfilePhotoUploadFailed =>
      'ప్రొఫైల్ ఫోటోను అప్‌లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerAadhaarUploadFailed =>
      'ఆధార్ పత్రాన్ని అప్‌లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerUpiQrUploadFailed =>
      'UPI QR కోడ్‌ను అప్‌లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerAddPgFailed => 'PGని జోడించడంలో విఫలమైంది';

  @override
  String get ownerRemovePgFailed => 'PGని తొలగించడంలో విఫలమైంది';

  @override
  String get ownerProfileVerifyFailed => 'ప్రొఫైల్‌ను ధృవీకరించడంలో విఫలమైంది';

  @override
  String get ownerProfileDeactivateFailed =>
      'ప్రొఫైల్‌ను నిలిపివేయడంలో విఫలమైంది';

  @override
  String get ownerProfileActivateFailed =>
      'ప్రొఫైల్‌ను సక్రియం చేయడంలో విఫలమైంది';

  @override
  String ownerStateUpdateFailedLog(String error) {
    return 'ఎంచుకున్న రాష్ట్రాన్ని నవీకరించడంలో లోపం: $error';
  }

  @override
  String ownerCityUpdateFailedLog(String error) {
    return 'ఎంచుకున్న నగరాన్ని నవీకరించడంలో లోపం: $error';
  }

  @override
  String get ownerStateTelangana => 'తెలంగాణ';

  @override
  String get ownerStateAndhraPradesh => 'ఆంధ్రప్రదేశ్';

  @override
  String get ownerProfilePhotoUpdateFailed =>
      'ప్రొఫైల్ ఫోటోను నవీకరించడంలో విఫలమైంది';

  @override
  String get ownerAadhaarUpdateFailed => 'ఆధార్ ఫోటోను నవీకరించడంలో విఫలమైంది';

  @override
  String get ownerUpiQrUpdateFailed => 'UPI QR కోడ్‌ను నవీకరించడంలో విఫలమైంది';

  @override
  String get ownerFileDeleteFailed => 'ఫైల్‌ను తొలగించడంలో విఫలమైంది';

  @override
  String get ownerPgFetchFailed => 'యజమాని PG IDలను పొందడంలో విఫలమైంది';

  @override
  String get ownerOverviewFetchFailed =>
      'యజమాని అవలోకన డేటాను పొందడంలో విఫలమైంది';

  @override
  String get ownerOverviewAggregateFailed =>
      'యజమాని డేటాను సమగ్రపరచడంలో విఫలమైంది';

  @override
  String get ownerMonthlyBreakdownFailed =>
      'నెలవారీ విభజనను పొందడంలో విఫలమైంది';

  @override
  String get ownerPropertyBreakdownFailed =>
      'ఆస్తి వారీ విభజనను పొందడంలో విఫలమైంది';

  @override
  String ownerPropertyFallbackName(String pgId) {
    return 'ఆస్తి $pgId';
  }

  @override
  String get ownerOverviewLoadFailed => 'అవలోకన డేటాను లోడ్ చేయడంలో విఫలమైంది';

  @override
  String ownerOverviewLoadFailedWithReason(String error) {
    return 'అవలోకన డేటాను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerOverviewStreamFailedWithReason(String error) {
    return 'అవలోకన డేటాను స్ట్రీమ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerMonthlyBreakdownLoadFailed(String error) {
    return 'మాసిక వివరాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPropertyBreakdownLoadFailed(String error) {
    return 'ప్రాపర్టీ వివరాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerGuestInitializeFailed(String error) {
    return 'అతిథుల నిర్వహణను ప్రారంభించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerGuestStatsLoadFailedLog(String error) {
    return '⚠️ Owner Guest ViewModel: గెస్ట్ గణాంకాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerGuestUpdateFailed(String error) {
    return 'అతిథిని నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerComplaintReplyFailed(String error) {
    return 'ఫిర్యాదు ప్రతిస్పందనను జోడించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerComplaintStatusUpdateFailed(String error) {
    return 'ఫిర్యాదు స్థితిని నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerBikeUpdateFailed(String error) {
    return 'బైక్‌ను నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerBikeMovementRequestFailed(String error) {
    return 'బైక్ మువ్‌మెంట్ అభ్యర్థనను సృష్టించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerServiceCreateFailed(String error) {
    return 'సేవ అభ్యర్థనను సృష్టించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerServiceReplyFailed(String error) {
    return 'సేవ ప్రతిస్పందనను జోడించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerServiceStatusUpdateFailed(String error) {
    return 'సేవ స్థితిని నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerGuestRefreshFailed(String error) {
    return 'డేటాను రిఫ్రెష్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerBookingApproveFailed(String error) {
    return 'బుకింగ్ అభ్యర్థనను ఆమోదించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerBookingRejectFailed(String error) {
    return 'బుకింగ్ అభ్యర్థనను తిరస్కరించడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerResponseNone => 'ఏదీ లేదు';

  @override
  String ownerFoodLoadMenusFailed(String error) {
    return 'మెనూను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodStreamMenusFailed(String error) {
    return 'మెనూను స్ట్రీమ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodStreamOverridesFailed(String error) {
    return 'ఓవర్‌రైడ్‌లను స్ట్రీమ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodSaveMenuFailed(String error) {
    return 'మెనూను సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodSaveMenusFailed(String error) {
    return 'మెనూలను సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodDeleteMenuFailed(String error) {
    return 'మెనూను తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodSaveOverrideFailed(String error) {
    return 'ఓవర్‌రైడ్‌ను సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodDeleteOverrideFailed(String error) {
    return 'ఓవర్‌రైడ్‌ను తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodUploadPhotoFailed(String error) {
    return 'ఆహార ఫోటోను అప్‌లోడ్ చేయడంలో విఫలమైంది';
  }

  @override
  String ownerFoodDeletePhotoFailed(String error) {
    return 'ఆహార ఫోటోను తొలగించడంలో విఫలమైంది';
  }

  @override
  String ownerFoodInitializeDefaultsFailed(String error) {
    return 'డిఫాల్ట్ మెనూలను ఆరంభించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodUpdateCurrentMenuFailed(String error) {
    return 'ఈరోజు మెనూను నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodSaveStateFailedLog(String error) {
    return '⚠️ Owner Food ViewModel: మెను స్థితిని సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerFoodClearStateFailedLog(String error) {
    return '⚠️ Owner Food ViewModel: మెను స్థితిని క్లియర్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerFoodFetchMenuFailed => 'సాప్తాహిక మెనూను పొందడంలో విఫలమైంది';

  @override
  String get ownerFoodFetchOverridesFailed =>
      'మెను ఓవర్‌రైడ్‌లను పొందడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositorySaveMenuFailed =>
      'సాప్తాహిక మెనూను సేవ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositorySaveMenusFailed =>
      'సాప్తాహిక మెనూలను సేవ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositoryDeleteMenuFailed =>
      'సాప్తాహిక మెనూను తొలగించడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositorySaveOverrideFailed =>
      'మెను ఓవర్‌రైడ్‌ను సేవ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositoryDeleteOverrideFailed =>
      'మెను ఓవర్‌రైడ్‌ను తొలగించడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositoryUploadPhotoFailed =>
      'ఫోటోను అప్లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get ownerFoodRepositoryDeletePhotoFailed =>
      'ఫోటోను తొలగించడంలో విఫలమైంది';

  @override
  String get ownerFoodFetchStatsFailed => 'మెను గణాంకాలను పొందడంలో విఫలమైంది';

  @override
  String pgPhotosUploading(int count) {
    return '$count ఫోటో(లు)ను అప్లోడ్ చేస్తున్నాము...';
  }

  @override
  String pgPhotosSelectFailed(String error) {
    return 'ఫోటోల్ని ఎంచుకోవడంలో విఫలమైంది: $error';
  }

  @override
  String pgPhotosUploadErrorLog(int index, String error) {
    return 'ఫోటో $index అప్లోడ్ విఫలమైంది: $error';
  }

  @override
  String get pgSupabaseStorageTroubleshoot =>
      '⚠️ Supabase స్టోరేజ్ లోపం: ఇవి కారణాలై ఉండొచ్చు:\n1. స్టోరేజ్ బకెట్ RLS పాలసీలు అప్లోడ్స్‌ను నిరోధించడం\n2. CORS కాన్ఫిగరేషన్ సమస్యలు\n3. స్టోరేజ్ అప్లోడ్స్‌కు ప్రమాణీకరణ అవసరం\nదయచేసి \"atitia-storage\" బకెట్‌కు సంబంధించిన Supabase స్టోరేజ్ పాలసీలను పరిశీలించండి.';

  @override
  String get ownerPgUnknownName => 'తెలియని PG';

  @override
  String ownerPgInitializeFailed(String error) {
    return 'PG నిర్వహణను ప్రారంభించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgApproveBookingFailed(String error) {
    return 'బుకింగ్‌ను ఆమోదించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgRejectBookingFailed(String error) {
    return 'బుకింగ్‌ను తిరస్కరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgRescheduleBookingFailed(String error) {
    return 'బుకింగ్‌ను మళ్లీ షెడ్యూల్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerPgIdNotInitialized => 'PG ID ప్రారంభించబడలేదు';

  @override
  String ownerPgUpdateBedStatusFailed(String error) {
    return 'పడక స్థితిని నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgRefreshFailed(String error) {
    return 'డేటాను రిఫ్రెష్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgSaveFailed(String error) {
    return 'PGను సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerPgIdNotProvided => 'PG ID అందించబడలేదు';

  @override
  String ownerPgUpdateFailed(String error) {
    return 'PGను నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgDeleteFailed(String error) {
    return 'PGను తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgCreateFailed(String error) {
    return 'PGను సృష్టించడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgRevenueReportFailed(String error) {
    return 'రెవెన్యూ నివేదికను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgOccupancyReportFailed(String error) {
    return 'ఆక్యుపెన్సీ నివేదికను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgFetchListFailed(String error) {
    return 'PGలను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String ownerPgFetchDetailsFailed(String error) {
    return 'PG వివరాలను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerPgBasicInfoZeroStateMessage =>
      'మీ PG గురించి మౌలిక సమాచారాన్ని నింపి ప్రారంభించండి.';

  @override
  String get ownerPgQuickStatRequired => 'అవసరం';

  @override
  String get ownerPgQuickStatRentTypes => 'అద్దె రకాలూ';

  @override
  String get ownerPgQuickStatDeposit => 'డిపాజిట్';

  @override
  String get ownerPgStatusNotSet => 'సెట్ చేయలేదు';

  @override
  String get ownerPgStatusSet => 'సెట్ చేశారు';

  @override
  String get ownerPgFloorStructureZeroStateMessage =>
      'మీ PG కోసం అంతస్తులు, గదులు, పడకలను సెట్ చేయండి.';

  @override
  String get ownerPgQuickStatFloors => 'అంతస్తులు';

  @override
  String get ownerPgQuickStatRooms => 'గదులు';

  @override
  String get ownerPgQuickStatBeds => 'పడకలు';

  @override
  String get ownerPgAmenitiesZeroStateMessage =>
      'అతిథులు సులభంగా కనుగొనడానికి మీ PG అందించే సౌకర్యాలను ఎంచుకోండి.';

  @override
  String get ownerPgPhotosZeroStateMessage =>
      'మీ PGను ప్రదర్శించేందుకు ఫోటోలను జోడించండి.';

  @override
  String get ownerPgQuickStatSelected => 'ఎంచుకున్నవి';

  @override
  String get ownerPgBedNumberingDescription =>
      'తలుపు స్థానాన్ని ఆధారంగా పడకలకు సంఖ్య ఇవ్వండి ώστε అందరూ ఒప్పుకోగలరు.';

  @override
  String get ownerPgBedNumberingRule =>
      'ప్రతి గదికి ఎన్నిమంది ఉంటారో నిర్ణయించి, పడకలకు సంఖ్యలు కేటాయించండి (ఉదా: B1, B2)';

  @override
  String get ownerPgBedLayoutTwoByTwo =>
      '2x2 లేఅవుట్ (B1-B2 ఎడమ వైపు, B3-B4 కుడి వైపు) వంటి లేఅవుట్లను ఉపయోగించండి';

  @override
  String get ownerPgBedLayoutOneByFour =>
      '1x4 లేఅవుట్ (B1 నుండి B4 వరకు వరుసగా) వంటి లేఅవుట్లను చార్ట్‌లో చూపించండి';

  @override
  String get ownerPgBed1NearestLeft =>
      'B1ను గది ప్రవేశానికి సమీపమైన ఎడమ మూలలో ఉంచండి';

  @override
  String get ownerPgBed2NearestRight => 'పడక-2: సమీప వరుస, కుడి వైపు';

  @override
  String get ownerPgBed3FarLeft => 'పడక-3: దూర వరుస, ఎడమ వైపు';

  @override
  String get ownerPgBed4FarRight => 'పడక-4: దూర వరుస, కుడి వైపు';

  @override
  String get ownerPgBed1ClosestDoor => 'పడక-1: తలుపుకు అత్యంత దగ్గరగా';

  @override
  String ownerPgBedNext(int number) {
    return 'పడక-$number: తరువాతది';
  }

  @override
  String get ownerPgBed4Farthest => 'పడక-4: తలుపు నుండి దూరంగా';

  @override
  String get ownerPgRentConfigZeroStateMessage =>
      'విభిన్న షేరింగ్ రకాల కోసం అద్దె మొత్తాలు మరియు మెయింటెనెన్స్ చార్జీలను సెట్ చేయండి.';

  @override
  String ownerPgProgressDescription(int completed, int total) {
    return '$completed / $total విభాగాలు పూర్తయ్యాయి';
  }

  @override
  String get ownerPgLoadingDetails => 'PG వివరాలను లోడ్ చేస్తున్నాం...';

  @override
  String get ownerPgPublishedSuccessfully => 'PG విజయవంతంగా ప్రచురించబడింది';

  @override
  String get ownerPgPublishFailed => 'PGని ప్రచురించడంలో విఫలమైంది';

  @override
  String ownerAnalyticsLoadFailed(String error) {
    return 'అనలిటిక్స్ డేటా లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get ownerProfileUpdateSuccess => 'ప్రొఫైల్ విజయవంతంగా నవీకరించబడింది';

  @override
  String ownerProfileUpdateFailure(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get replaceQrCode => 'QR కోడ్‌ను మార్చండి';

  @override
  String get removeQrCode => 'QR కోడ్‌ను తీసివేయండి';

  @override
  String get previewQrCode => 'QR కోడ్‌ను ముందస్తు వీక్షణ చేయండి';

  @override
  String get noQrCodeSelected => 'ఇప్పటికీ QR కోడ్ ఎంపిక చేయలేదు';

  @override
  String get newQrCodeSelected => 'కొత్త QR కోడ్ ఎంపిక చేయబడింది';

  @override
  String get existingQrCode => 'ఉన్న QR కోడ్';

  @override
  String get exampleBankName => 'ఉదా., స్టేట్ బ్యాంక్ ఆఫ్ ఇండియా';

  @override
  String get exampleIfsc => 'ఉదా., SBIN0001234';

  @override
  String get exampleUpiId => 'yourname@paytm';

  @override
  String get qrCodeInfoText =>
      'ఫోన్‌పే, పేటీఎం, గూగుల్ పే వంటి ఏదైనా UPI యాప్ నుండి మీరు QR కోడ్‌ను సృష్టించవచ్చు.';

  @override
  String get ownerProfileInitialFallback => 'ఓ';

  @override
  String get ownerProfileVerifiedStatus => 'ధృవీకరించబడింది';

  @override
  String get ownerProfilePendingVerificationStatus => 'ధృవీకరణ పెండింగ్';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get dateFormatDdMmYyyy => 'DD/MM/YYYY';

  @override
  String get guestUser => 'అతిథి వినియోగదారు';

  @override
  String get guestInitialsFallback => 'GU';

  @override
  String perMonthAmount(String amount) {
    return '$amount/నెల';
  }

  @override
  String get pgPayment => 'PG చెల్లింపు';

  @override
  String get paymentTypeRent => 'అద్దె చెల్లింపు';

  @override
  String get paymentTypeSecurityDeposit => 'భద్రతా డిపాజిట్';

  @override
  String get paymentTypeMaintenance => 'నిర్వహణ రుసుము';

  @override
  String get paymentTypeLateFee => 'ఆలస్య రుసుము';

  @override
  String paymentTypeOther(String type) {
    return '$type చెల్లింపు';
  }

  @override
  String get paymentCompletedSuccessfully =>
      'చెల్లింపు విజయవంతంగా పూర్తయ్యింది';

  @override
  String get paymentPending => 'చెల్లింపు పెండింగ్‌లో ఉంది';

  @override
  String get paymentOverdue =>
      'చెల్లింపు ఆలస్యమైంది — దయచేసి వెంటనే చెల్లించండి';

  @override
  String get paymentFailedMessage =>
      'చెల్లింపు విఫలమైంది — దయచేసి మళ్లీ ప్రయత్నించండి';

  @override
  String get paymentRefunded => 'చెల్లింపు తిరిగి చెల్లించబడింది';

  @override
  String get unknownStatus => 'తెలియని స్థితి';

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
    return 'చెల్లింపులను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToAddPayment(String error) {
    return 'చెల్లింపును జోడించడంలో విఫలమైంది: $error';
  }

  @override
  String failedToUpdatePaymentStatus(String error) {
    return 'చెల్లింపు స్థితిని నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String failedToFetchPayment(String error) {
    return 'చెల్లింపును పొందడంలో విఫలమైంది: $error';
  }

  @override
  String failedToDeletePayment(String error) {
    return 'చెల్లింపును తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String get paymentSimulationDeprecated => 'చెల్లింపు అనుకరణను విరమించారు.';

  @override
  String get paymentSimulationRecommendation =>
      'చెల్లింపు పద్ధతుల ఎంపిక సంభాషణ ద్వారా నిజమైన చెల్లింపు గేట్వేలను (Razorpay, UPI లేదా Cash) ఉపయోగించండి.';

  @override
  String get paymentNotificationReceivedTitle => 'చెల్లింపు స్వీకరించబడింది';

  @override
  String paymentNotificationReceivedBody(Object amount) {
    return 'అతిథి నుండి $amount స్వీకరించబడింది';
  }

  @override
  String get selectPaymentMethodTitle => 'చెల్లింపు విధానాన్ని ఎంచుకోండి';

  @override
  String get selectPaymentMethodSubtitle =>
      'మీరు చెల్లింపును ఎలా చేయాలనుకుంటున్నారో ఎంచుకోండి';

  @override
  String get razorpayPaymentDescription =>
      'Razorpay ద్వారా సురక్షిత ఆన్‌లైన్ చెల్లింపు';

  @override
  String get upiPaymentDescription =>
      'PhonePe, Paytm, Google Pay తదితరాల ద్వారా చెల్లించి స్క్రీన్‌షాట్‌ను షేర్ చేయండి';

  @override
  String get cashPaymentDescription =>
      'నగదుగా చెల్లించి యజమాని నిర్ధారణను అభ్యర్థించండి';

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
    return 'అతిథి ప్రొఫైల్‌ను నవీకరించడంలో విఫలమైంది: $error';
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
    return 'అతిథి ప్రొఫైల్‌ను తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String get noChangesToSave => 'భద్రపరచడానికి మార్పులు లేవు';

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
    return 'PGలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToLoadPgDetails(String error) {
    return 'PG వివరాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToSavePg(String error) {
    return 'PGని సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToDeletePg(String error) {
    return 'PGని తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String failedToLoadPgStats(String error) {
    return 'PG గణాంకాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToUploadPgPhoto(String error) {
    return 'PG ఫోటోను అప్‌లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToPerformPgSearch(String error) {
    return 'శోధనను నిర్వహించడంలో విఫలమైంది: $error';
  }

  @override
  String failedToFetchPgDetails(String error) {
    return 'PG వివరాలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToSearchPgs(String error) {
    return 'PGలను శోధించడంలో విఫలమైంది: $error';
  }

  @override
  String failedToFetchOwnerPgs(String error) {
    return 'ఓనర్ PGలను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String failedToFetchCityPgs(String error) {
    return 'నగర PGలను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String failedToFetchAmenityPgs(String error) {
    return 'అమెనిటీ PGలను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String failedToGetPgStats(String error) {
    return 'PG గణాంకాలను పొందడంలో విఫలమైంది: $error';
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
  String get newBookingRequestTitle => 'కొత్త బుకింగ్ అభ్యర్థన';

  @override
  String newBookingRequestBody(String guestName, String pgName) {
    return '$guestName $pgName లో చేరడానికి అభ్యర్థించారు';
  }

  @override
  String failedToInitializeGuestPgSelection(String error) {
    return 'PG ఎంపికను ప్రారంభించడంలో విఫలమైంది: $error';
  }

  @override
  String failedToSelectGuestPg(String error) {
    return 'PGను ఎంచుకోవడంలో విఫలమైంది: $error';
  }

  @override
  String failedToClearGuestPgSelection(String error) {
    return 'PG ఎంపికను క్లియర్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String failedToSendBookingRequest(String error) {
    return 'బుకింగ్ అభ్యర్థనను పంపడంలో విఫలమైంది: $error';
  }

  @override
  String failedToUpdateBookingStatus(String error) {
    return 'బుకింగ్ స్థితిని నవీకరించడంలో విఫలమైంది: $error';
  }

  @override
  String get privacyPolicyTitle => 'గోప్యతా విధానం';

  @override
  String get privacyPolicyLastUpdatedLabel => 'చివరిగా నవీకరించిన తేదీ';

  @override
  String get privacyPolicyLastUpdatedDate => 'నవంబర్ 2025';

  @override
  String get privacyPolicySection1Title => '1. మేము సేకరించే సమాచారం';

  @override
  String get privacyPolicySection1Content =>
      'మేము మీరు మాకు నేరుగా అందించే సమాచారాన్ని సేకరిస్తాము, అందులో ఇవి ఉన్నాయి:\n• వ్యక్తిగత సమాచారం (పేరు, ఇమెయిల్, ఫోన్ నంబర్)\n• PG బుకింగ్ మరియు చెల్లింపు సమాచారం\n• ప్రొఫైల్ మరియు అభిరుచుల డేటా\n• ఆస్తి యజమానులతో మీ కమ్యూనికేషన్ రికార్డులు';

  @override
  String get privacyPolicySection2Title =>
      '2. మేము మీ సమాచారాన్ని ఎలా ఉపయోగిస్తాము';

  @override
  String get privacyPolicySection2Content =>
      'మేము సేకరించిన సమాచారాన్ని ఈ విధంగా ఉపయోగిస్తాము:\n• మా సేవలను అందించడానికి, నిర్వహించడానికి మరియు మెరుగుపరచడానికి\n• లావాదేవీలను ప్రాసెస్ చేసి సంబంధిత సమాచారాన్ని పంపడానికి\n• సాంకేతిక నోటీసులు మరియు మద్దతు సందేశాలను పంపడానికి\n• మీ వ్యాఖ్యలు మరియు ప్రశ్నలకు స్పందించడానికి';

  @override
  String get privacyPolicySection3Title => '3. సమాచారం పంచుకోవడం';

  @override
  String get privacyPolicySection3Content =>
      'మేము మీ వ్యక్తిగత సమాచారాన్ని అమ్మము, వ్యాపారం చేయము లేదా అద్దెకు ఇవ్వము. మీ సమాచారాన్ని కేవలం ఈ సందర్భాలలో మాత్రమే పంచుకోవచ్చు:\n• బుకింగ్ కోసం ప్రాపర్టీ యజమానులతో\n• చట్టపరమైన బాధ్యతలను అనుసరించడానికి\n• మా హక్కులు మరియు భద్రతను రక్షించడానికి';

  @override
  String get privacyPolicySection4Title => '4. డేటా భద్రత';

  @override
  String get privacyPolicySection4Content =>
      'మీ వ్యక్తిగత సమాచారాన్ని రక్షించడానికి మేము తగిన భద్రతా చర్యలను అమలు చేస్తున్నాము. అయితే, ఇంటర్నెట్ ద్వారా ప్రసారం 100% భద్రమైనది కాదని గమనించండి.';

  @override
  String get privacyPolicySection5Title => '5. మీ హక్కులు';

  @override
  String get privacyPolicySection5Content =>
      'మీకు ఈ హక్కులు ఉన్నాయి:\n• మీ వ్యక్తిగత సమాచారాన్ని యాక్సెస్ చేయడం\n• తప్పు ఉన్న డేటాను సరిచేయడం\n• మీ డేటాను తొలగించాలని అభ్యర్థించడం\n• కొన్ని కమ్యూనికేషన్ల నుండి నిష్క్రమించడం';

  @override
  String get privacyPolicySection6Title => '6. మమ్మల్ని సంప్రదించండి';

  @override
  String get privacyPolicySection6Content =>
      'ఈ గోప్యతా విధానం గురించి మీకు ప్రశ్నలు ఉంటే, దయచేసి మమ్మల్ని ఈ విధంగా సంప్రదించండి:\n\nఇమెయిల్: privacy@atitia.com\nఫోన్: +91 1234567890';

  @override
  String get termsOfServiceTitle => 'సేవా నిబంధనలు';

  @override
  String get termsOfServiceLastUpdatedLabel => 'చివరిగా నవీకరించిన తేదీ';

  @override
  String get termsOfServiceLastUpdatedDate => 'నవంబర్ 2025';

  @override
  String get termsOfServiceSection1Title => '1. నిబంధనల స్వీకారం';

  @override
  String get termsOfServiceSection1Content =>
      'Atitia యాప్‌ను యాక్సెస్ చేసి ఉపయోగించడం ద్వారా, ఈ సేవా నిబంధనలను మీరు అంగీకరిస్తున్నారు. మీరు అంగీకరించకపోతే, దయచేసి మా సేవలను ఉపయోగించవద్దు.';

  @override
  String get termsOfServiceSection2Title => '2. వినియోగదారు ఖాతాలు';

  @override
  String get termsOfServiceSection2Content =>
      'మీరు ఈ బాధ్యతలు వహించాలి:\n• మీ ఖాతా గోప్యతను కాపాడడం\n• మీ ఖాతా ద్వారా జరిగే అన్ని కార్యకలాపాలకు బాధ్యత వహించడం\n• ఖచ్చితమైన మరియు పూర్తిగా సమాచారాన్ని అందించడం';

  @override
  String get termsOfServiceSection3Title => '3. బుకింగ్ మరియు చెల్లింపులు';

  @override
  String get termsOfServiceSection3Content =>
      '• బుకింగ్ అభ్యర్థనలు యజమాని ఆమోదానికి లోబడి ఉంటాయి\n• చెల్లింపు నిబంధనలు ఆస్తి యజమానితో మీరు ఒప్పుకున్నట్లే ఉంటాయి\n• రీఫండ్‌లు ఆస్తి రద్దు విధానానికి లోబడి ఉంటాయి\n• మేము లావాదేవీలను సులభతరం చేస్తాము కానీ అద్దె ఒప్పందంలో భాగస్వాములు కాదము';

  @override
  String get termsOfServiceSection4Title => '4. ఆస్తి యజమాని బాధ్యతలు';

  @override
  String get termsOfServiceSection4Content =>
      'ఆస్తి యజమానులు తప్పనిసరిగా:\n• ఖచ్చితమైన ఆస్తి సమాచారాన్ని అందించాలి\n• ధృవీకరించిన బుకింగ్‌లను గౌరవించాలి\n• ఆస్తి ప్రమాణాలను నిర్వహించాలి\n• అతిథుల ప్రశ్నలకు సమయానికి స్పందించాలి';

  @override
  String get termsOfServiceSection5Title => '5. నిషేధిత కార్యకలాపాలు';

  @override
  String get termsOfServiceSection5Content =>
      'మీరు ఈ క్రియలను చేయకూడదని అంగీకరిస్తున్నారు:\n• చట్ట విరుద్ధ ప్రయోజనాలకు సేవను ఉపయోగించడం\n• తప్పుడు లేదా తప్పుదోవ పట్టించే సమాచారాన్ని పోస్టు చేయడం\n• యాప్ పనితీరును భంగం చేయడం\n• వ్యవస్థకు అనధికారికంగా ప్రవేశించడానికి ప్రయత్నించడం';

  @override
  String get termsOfServiceSection6Title => '6. బాధ్యత పరిమితి';

  @override
  String get termsOfServiceSection6Content =>
      'Atitia వేదికను \"అలాగే\" అందిస్తుంది మరియు క్రింది విషయాలకు బాధ్యత వహించదు:\n• అతిథులు మరియు ఆస్తి యజమానుల మధ్య వివాదాలు\n• ఆస్తి పరిస్థితి లేదా భద్రత సమస్యలు\n• చెల్లింపు వివాదాలు లేదా రీఫండ్‌లు\n• ప్రత్యక్ష లేదా పరోక్ష నష్టాలు';

  @override
  String get termsOfServiceSection7Title => '7. నిబంధనల మార్పులు';

  @override
  String get termsOfServiceSection7Content =>
      'ఈ నిబంధనలను ఎప్పుడైనా మార్చుకునే హక్కు మాకు ఉంది. సేవను కొనసాగిస్తూ ఉపయోగించడం ద్వారా, మార్పు చేసిన నిబంధనలను మీరు అంగీకరించినట్టే భావిస్తాము.';

  @override
  String get termsOfServiceSection8Title => '8. సంప్రదింపు సమాచారం';

  @override
  String get termsOfServiceSection8Content =>
      'ఈ నిబంధనల గురించి ప్రశ్నలైతే, దయచేసి మమ్మల్ని ఈ విధంగా సంప్రదించండి:\n\nఇమెయిల్: legal@atitia.com\nఫోన్: +91 1234567890';

  @override
  String get notificationPreferencesTitle => 'నోటిఫికేషన్ ప్రిఫరెన్సులు';

  @override
  String get notificationPreferencesSubtitle =>
      'మీకు ఏ రకాల నోటిఫికేషన్‌లు కావాలో ఎంచుకోండి';

  @override
  String get notificationSettingsTitle => 'నోటిఫికేషన్ సెట్టింగ్‌లు';

  @override
  String get notificationCategoryPaymentTitle => 'చెల్లింపు నోటిఫికేషన్‌లు';

  @override
  String get notificationCategoryPaymentSubtitle =>
      'అద్దె రైమైండర్లు, చెల్లింపు నిర్ధారణలు';

  @override
  String get notificationCategoryBookingTitle => 'బుకింగ్ అప్‌డేట్లు';

  @override
  String get notificationCategoryBookingSubtitle =>
      'బుకింగ్ నిర్ధారణలు, స్థితి మార్పులు';

  @override
  String get notificationCategoryComplaintTitle => 'ఫిర్యాదు అప్‌డేట్లు';

  @override
  String get notificationCategoryComplaintSubtitle =>
      'ఫిర్యాదు స్పందనలు, పరిష్కార అప్‌డేట్లు';

  @override
  String get notificationCategoryFoodTitle => 'ఆహార నోటిఫికేషన్‌లు';

  @override
  String get notificationCategoryFoodSubtitle =>
      'మెను అప్‌డేట్లు, ప్రత్యేక భోజనాలు';

  @override
  String get notificationCategoryMaintenanceTitle => 'నిర్వహణ హెచ్చరికలు';

  @override
  String get notificationCategoryMaintenanceSubtitle =>
      'నిర్దేశిత నిర్వహణ, మరమ్మతులు';

  @override
  String get notificationCategoryGeneralTitle => 'సాధారణ ప్రకటనలు';

  @override
  String get notificationCategoryGeneralSubtitle =>
      'ముఖ్యమైన అప్‌డేట్లు, ప్రకటనలు';

  @override
  String get analyticsDashboardTitle => 'విశ్లేషణల డ్యాష్‌బోర్డు';

  @override
  String get performanceMetricsTitle => 'పనితీరు ప్రమాణాలు';

  @override
  String get noPerformanceMetricsAvailable =>
      'పనితీరు ప్రమాణాలు అందుబాటులో లేవు';

  @override
  String get userJourneyTitle => 'వినియోగదారు ప్రయాణం';

  @override
  String get userJourneyDescription =>
      'వినియోగదారు పరస్పర చర్యలు మరియు స్క్రీన్ ప్రవాహాలను ట్రాక్ చేయండి';

  @override
  String get viewJourneyDetails => 'ప్రయాణ వివరాలను చూడండి';

  @override
  String get businessIntelligenceTitle => 'వ్యాపార విజ్ఞానం';

  @override
  String get metricTotalSessions => 'మొత్తం సెషన్లు';

  @override
  String get metricActiveUsers => 'సక్రియ వినియోగదారులు';

  @override
  String get metricConversionRate => 'మార్పిడి శాతం';

  @override
  String get metricAverageSessionDuration => 'సెషన్ సగటు వ్యవధి';

  @override
  String get viewInsights => 'అంతర్దృష్టులను చూడండి';

  @override
  String get userJourneyDetailsTitle => 'వినియోగదారు ప్రయాణ వివరాలు';

  @override
  String get userJourneyDetailsDescription =>
      'చార్ట్‌లు మరియు ప్రవాహ డయాగ్రామ్‌లతో వివరమైన వినియోగదారు ప్రయాణ విజువలైజేషన్ ఇక్కడ అమలు చేయబడుతుంది.';

  @override
  String get businessInsightsTitle => 'వ్యాపార అంతర్దృష్టులు';

  @override
  String get businessInsightsDescription =>
      'గ్రాఫ్‌లు, ధోరణులు మరియు అంచనా విశ్లేషణలతో ఆధునిక వ్యాపార విజ్ఞానం డ్యాష్‌బోర్డు ఇక్కడ అమలు చేయబడుతుంది.';

  @override
  String get analyticsWidgetTitle => 'విశ్లేషణలు';

  @override
  String get analyticsSessionsLabel => 'సెషన్లు';

  @override
  String get analyticsAverageTimeLabel => 'సగటు సమయం';

  @override
  String get networkErrorTryAgain =>
      'దయచేసి మీ ఇంటర్నెట్ కనెక్షన్‌ను తనిఖీ చేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get permissionDeniedMessage => 'ఈ చర్యను చేయడానికి మీకు అనుమతి లేదు.';

  @override
  String get itemNotFoundMessage => 'అభ్యర్థించిన అంశం కనుగొనబడలేదు.';

  @override
  String get requestTimeoutMessage =>
      'వినతి సమయం ముగిసింది. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get sessionExpiredMessage =>
      'మీ సెషన్ ముగిసింది. దయచేసి మళ్ళీ సైన్ ఇన్ చేయండి.';

  @override
  String get invalidInputMessage =>
      'దయచేసి మీ ఇన్‌పుట్‌ను తనిఖీ చేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get genericErrorMessage =>
      'ఏదో తప్పు జరిగింది. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get requiredFieldError => 'ఈ ఫీల్డ్ తప్పనిసరి';

  @override
  String get invalidPhoneError => 'దయచేసి సరైన ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get fileSizeExceeded => 'ఫైల్ పరిమాణం గరిష్ఠ పరిమితిని మించిపోయింది';

  @override
  String get workspaceTitle => 'వర్క్‌స్పేస్';

  @override
  String get defaultCompanyName => 'అటిటియా PG మేనేజ్‌మెంట్';

  @override
  String get noSharingInfoAvailable => 'షేరింగ్ సమాచారం అందుబాటులో లేదు.';

  @override
  String get sharingAndVacancy => 'షేరింగ్ మరియు ఖాళీలు';

  @override
  String get sharingColumn => 'షేరింగ్';

  @override
  String get roomsColumn => 'గదులు';

  @override
  String get vacantBedsColumn => 'ఖాళీ పడకలు';

  @override
  String get rentPerBedColumn => 'పడకకు అద్దె';

  @override
  String get vacantBedsAvailable => 'లభ్యం';

  @override
  String sharingPricePerBed(String amount) {
    return '$amount/పడక';
  }

  @override
  String get anonymousGuest => 'అజ్ఞాత అతిథి';

  @override
  String get locationLabel => 'ప్రాంతం';

  @override
  String get staffLabel => 'సిబ్బంది';

  @override
  String get viewPhotos => 'ఫోటోలు చూడండి';

  @override
  String helpfulWithCount(int count) {
    return 'సహాయకం ($count)';
  }

  @override
  String get writeReview => 'సమీక్ష రాయండి';

  @override
  String get overallRating => 'మొత్తం రేటింగ్';

  @override
  String get aspectRatings => 'విభాగ రేటింగ్స్';

  @override
  String get commentsLabel => 'వ్యాఖ్యలు';

  @override
  String get shareExperienceHint => 'మీ అనుభవాన్ని పంచుకోండి...';

  @override
  String get optionalAddPhotos => 'ఐచ్చికం: మీ సమీక్షకు ఫోటోలు జోడించండి';

  @override
  String get submitReview => 'సమీక్షను సమర్పించండి';

  @override
  String get submitting => 'సమర్పిస్తున్నాం';

  @override
  String get pleaseProvideOverallRating => 'దయచేసి మొత్తం రేటింగ్ ఇవ్వండి';

  @override
  String get reviewSubmittedSuccessfully => 'సమీక్ష విజయవంతంగా సమర్పించబడింది!';

  @override
  String failedToSubmitReview(String error) {
    return 'సమీక్షను సమర్పించడంలో విఫలమయ్యాం: $error';
  }

  @override
  String get ratingPoor => 'తక్కువ';

  @override
  String get ratingFair => 'సరిపడ';

  @override
  String get ratingGood => 'మంచి';

  @override
  String get ratingVeryGood => 'చాలా మంచి';

  @override
  String get ratingExcellent => 'అద్భుతం';

  @override
  String get selectRating => 'ఒక రేటింగ్ ఎంచుకోండి';

  @override
  String photosCountLabel(int count, int max) {
    return 'ఫోటోలు ($count/$max)';
  }

  @override
  String get uploadingPhotos => 'ఫోటోలు అప్లోడ్ అవుతున్నాయి...';

  @override
  String errorPickingPhotos(String error) {
    return 'ఫోటోలు ఎంపికలో లోపం: $error';
  }

  @override
  String get allPhotoUploadsFailed =>
      'అన్ని ఫోటో అప్లోడ్లు విఫలమయ్యాయి. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String failedToUploadPhotos(String error) {
    return 'ఫోటోలు అప్లోడ్ చేయడంలో విఫలమయ్యాం: $error';
  }

  @override
  String get noItemsFound => 'ఏ అంశాలు కనబడలేదు';

  @override
  String get searchHint => 'శోధించండి...';

  @override
  String get lightMode => 'లైట్ మోడ్';

  @override
  String get darkMode => 'డార్క్ మోడ్';

  @override
  String get systemDefault => 'సిస్టమ్ డిఫాల్ట్';

  @override
  String themeTooltip(String current, String next) {
    return 'థీమ్: $current\\n$next కోసం ట్యాప్ చేయండి';
  }

  @override
  String get themeModeTitle => 'థీమ్ మోడ్';

  @override
  String get themeLightDescription =>
      'ఎల్లప్పుడూ ప్రకాశవంతమైన థీమ్‌ను ఉపయోగించండి';

  @override
  String get themeDarkDescription => 'ఎల్లప్పుడూ డార్క్ థీమ్‌ను ఉపయోగించండి';

  @override
  String get themeSystemDescription => 'పరికరం సెట్టింగ్‌లను అనుసరించండి';

  @override
  String get menu => 'మెను';

  @override
  String get noPgSelected => 'ఏ PG ఎంపిక కాలేదు';

  @override
  String get uploadingStatus => 'అప్‌లోడ్ అవుతోంది...';

  @override
  String get documentUploadedSuccessfully => 'పత్రం విజయవంతంగా అప్‌లోడ్ అయింది';

  @override
  String get tapToUpload => 'అప్‌లోడ్ చేయడానికి ట్యాప్ చేయండి';

  @override
  String get uploadSupportedFormats => 'JPG, PNG 10MB వరకు';

  @override
  String unsupportedFileType(String type) {
    return 'మద్దతు లేని ఫైల్ రకం: $type';
  }

  @override
  String get offlineActionCreate => 'సృష్టించు';

  @override
  String get offlineActionUpdate => 'నవీకరణ';

  @override
  String get offlineActionDelete => 'తొలగించు';

  @override
  String get offlineActionSync => 'సింక్';

  @override
  String get weekday_monday => 'సోమవారం';

  @override
  String get weekday_tuesday => 'మంగళవారం';

  @override
  String get weekday_wednesday => 'బుధవారం';

  @override
  String get weekday_thursday => 'గురువారం';

  @override
  String get weekday_friday => 'శుక్రవారం';

  @override
  String get weekday_saturday => 'శనివారం';

  @override
  String get weekday_sunday => 'ఆదివారం';

  @override
  String menuDefaultDescription(String day) {
    return '$day కోసం మౌలిక మెనూ - అవసరానుసారం అనుకూలించండి';
  }

  @override
  String get menuBreakfast_monday =>
      'సాంబార్ కొబ్బరి పచ్చడితో ఇడ్లీ|వడ (2 ముక్కలు)|ఫిల్టర్ కాఫీ|అరటి పండు';

  @override
  String get menuBreakfast_tuesday =>
      'సాంబార్, చట్నీతో మసాలా దోస|మేడూ వడ|టీ|ఋతువారీ ఫలం';

  @override
  String get menuBreakfast_wednesday =>
      'కొబ్బరి పచ్చడితో ఉప్మా|వడ (2 ముక్కలు)|కాఫీ|మరిగించిన గుడ్లు (2)';

  @override
  String get menuBreakfast_thursday =>
      'వేరుశెనగలు, కరివేపాకుతో పోహా|అరటి చిప్స్|టీ|బొప్పాయి';

  @override
  String get menuBreakfast_friday => 'పూరి ఆలూ భాజీతో|హల్వా|కాఫీ|నారింజ';

  @override
  String get menuBreakfast_saturday =>
      'అల్లం పచ్చడితో పెసరట్టు (పచ్చ పెసర దోశ)|ఉప్మా|టీ|ఋతువారీ ఫలం';

  @override
  String get menuBreakfast_sunday =>
      'ప్రత్యేక అల్పాహారం - వడతో పొంగల్|తీపి పొంగల్|ఫిల్టర్ కాఫీ|అరటి పండు';

  @override
  String get menuLunch_monday =>
      'ఆవిరి బియ్యం|సాంబార్|రసం|వెజిటేబుల్ కర్రీ (బీన్స్ పాల్యా)|పెరుగు|పప్పడమ్|మజ్జిగ';

  @override
  String get menuLunch_tuesday =>
      'ఆవిరి బియ్యం|డాల్ తడ్కా|రసం|కాబేజీ పొరియల్|వంకాయ కూర|పెరుగు|ఊరగాయ';

  @override
  String get menuLunch_wednesday =>
      'జీలకర్ర అన్నం|సాంబార్|రసం|ఆలూ వేపుడు|పాలకూర పప్పు|పెరుగు|పప్పడమ్';

  @override
  String get menuLunch_thursday =>
      'ఆవిరి బియ్యం|పెసర పప్పు|రసం|మిశ్రమ కూరగాయ కూర|బీట్‌రూట్ పొరియల్|పెరుగు|మజ్జిగ';

  @override
  String get menuLunch_friday =>
      'నిమ్మ అన్నం|సాంబార్|రసం|బెండకాయ వేపుడు|కారెట్ పొరియల్|పెరుగు|ఊరగాయ';

  @override
  String get menuLunch_saturday =>
      'ఆవిరి బియ్యం|కందిపప్పు|రసం|గుమ్మడికాయ కూర|గ్రీన్ బీన్స్ పొరియల్|పెరుగు|పప్పడమ్';

  @override
  String get menuLunch_sunday =>
      'ప్రత్యేక భోజనం - పులావు|సాంబార్|రసం|పనీర్ బటర్ మసాలా|రాయితా|తీపి (పాయసం)|పప్పడమ్';

  @override
  String get menuDinner_monday =>
      'చపాతీ (4 ముక్కలు)|మిశ్రమ కూరగాయ కూర|డాల్ ఫ్రై|అన్నం|పెరుగు';

  @override
  String get menuDinner_tuesday =>
      'చపాతీ (4 ముక్కలు)|పాలక్ పనీర్|డాల్ తడ్కా|అన్నం|ఊరగాయ';

  @override
  String get menuDinner_wednesday =>
      'పరాతా (3 ముక్కలు)|ఆలూ గోబీ|పెసర పప్పు|అన్నం|పెరుగు';

  @override
  String get menuDinner_thursday =>
      'చపాతీ (4 ముక్కలు)|చనా మసాలా|టమోటా రసం|అన్నం|రాయితా';

  @override
  String get menuDinner_friday =>
      'పూరి (6 ముక్కలు)|ఆలూ కూర|శనగ పప్పు|అన్నం|పెరుగు';

  @override
  String get menuDinner_saturday =>
      'చపాతీ (4 ముక్కలు)|గుడ్డు కూర (2 గుడ్లు)|డాల్ తడ్కా|అన్నం|ఊరగాయ';

  @override
  String get menuDinner_sunday =>
      'ప్రత్యేక డిన్నర్ - నాన్ (3 ముక్కలు)|పనీర్ తిక్కా మసాలా|డాల్ మఖానీ|జీలకర్ర అన్నం|రాయితా|గులాబ్ జామున్ (2 ముక్కలు)';

  @override
  String get menuMealTypeBreakfastDescription => 'ఉదయం భోజనం (ఉ. 6:00 - 10:00)';

  @override
  String get menuMealTypeLunchDescription => 'మధ్యాహ్న భోజనం (మ. 12:00 - 3:00)';

  @override
  String get menuMealTypeDinnerDescription =>
      'సాయంత్రం భోజనం (సా. 7:00 - 10:00)';

  @override
  String get menuMealTypeGeneric => 'భోజనం';

  @override
  String logButtonClicked(String buttonName) {
    return 'బటన్ క్లిక్ చేయబడింది: $buttonName';
  }

  @override
  String logFormSubmitted(String formName) {
    return 'ఫారమ్ సమర్పించబడింది: $formName';
  }

  @override
  String logFilterChanged(String filterType) {
    return 'ఫిల్టర్ మార్చబడింది: $filterType';
  }

  @override
  String get logSearchPerformed => 'శోధన నిర్వహించబడింది';

  @override
  String logScreenViewed(String screenName) {
    return 'స్క్రీన్ వీక్షించబడింది: $screenName';
  }

  @override
  String logDataLoading(String dataType) {
    return 'డేటా లోడ్ అవుతోంది: $dataType';
  }

  @override
  String logErrorOperation(String operation, String error) {
    return '$operation లో లోపం: $error';
  }

  @override
  String dateInvalidFormat(String expected, String value) {
    return 'చెల్లని తేదీ ఫార్మాట్. $expected కావాలి కానీ \"$value\" అందింది';
  }

  @override
  String dateComponentsNotNumbers(String value) {
    return 'తేదీ భాగాలు సంఖ్యలు కావాలి: \"$value\"';
  }

  @override
  String dateInvalidCalendar(String value) {
    return 'చెల్లని క్యాలెండర్ తేదీ: \"$value\"';
  }

  @override
  String dateEnterAsExpected(String expected) {
    return '$expected విధంగా తేదీని నమోదు చేయండి';
  }

  @override
  String get dateDigitsOnly => 'తేదీ మొత్తంగా అంకెలతో ఉండాలి';

  @override
  String get dateCalendarInvalid =>
      'చెల్లుబాటు అయ్యే క్యాలెండర్ తేదీని నమోదు చేయండి';

  @override
  String dateGenericInvalid(String expected) {
    return 'చెల్లుబాటు అయ్యే తేదీని నమోదు చేయండి ($expected)';
  }

  @override
  String get dateDayRange => 'రోజు 1 మరియు 31 మధ్య ఉండాలి';

  @override
  String get dateMonthRange => 'నెల 1 మరియు 12 మధ్య ఉండాలి';

  @override
  String dateYearRange(int min, int max) {
    return 'సంవత్సరం $min మరియు $max మధ్య ఉండాలి';
  }

  @override
  String get credentialInvalidWebClientId =>
      'చెల్లని Google Web Client ID ఫార్మాట్';

  @override
  String get credentialStoredWebClientId =>
      'Google Web Client ID సురక్షిత నిల్వలో భద్రపరచబడింది';

  @override
  String credentialStoreWebClientIdFailure(String error) {
    return 'Google Web Client ID నిల్వ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get credentialInvalidAndroidClientId =>
      'చెల్లని Google Android Client ID ఫార్మాట్';

  @override
  String get credentialStoredAndroidClientId =>
      'Google Android Client ID సురక్షిత నిల్వలో భద్రపరచబడింది';

  @override
  String credentialStoreAndroidClientIdFailure(String error) {
    return 'Google Android Client ID నిల్వ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get credentialInvalidIosClientId =>
      'చెల్లని Google iOS Client ID ఫార్మాట్';

  @override
  String get credentialStoredIosClientId =>
      'Google iOS Client ID సురక్షిత నిల్వలో భద్రపరచబడింది';

  @override
  String credentialStoreIosClientIdFailure(String error) {
    return 'Google iOS Client ID నిల్వ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get credentialInvalidClientSecret =>
      'చెల్లని Google Client Secret ఫార్మాట్';

  @override
  String get credentialStoredClientSecret =>
      'Google Client Secret సురక్షిత నిల్వలో భద్రపరచబడింది';

  @override
  String credentialStoreClientSecretFailure(String error) {
    return 'Google Client Secret నిల్వ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get credentialClearedAll =>
      'అన్ని Google OAuth వివరాలు సురక్షిత నిల్వ నుండి తొలగించబడాయి';

  @override
  String credentialClearFailure(String error) {
    return 'క్రెడెన్షియల్స్ క్లియర్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String credentialCheckFailure(String error) {
    return 'నిల్వ చేసిన క్రెడెన్షియల్స్‌ను తనిఖీ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String securityAuthFailureDescription(String userId, String failureReason) {
    return 'వినియోగదారు $userId కోసం ధృవీకరణ విఫలమైంది: $failureReason';
  }

  @override
  String securityMultipleFailuresDetected(String userId) {
    return 'వినియోగదారు $userId కోసం అనేక విఫల ధృవీకరణ ప్రయత్నాలు గుర్తించబడ్డాయి';
  }

  @override
  String securityAuthSuccessDescription(String userId) {
    return 'వినియోగదారు $userId కోసం ధృవీకరణ విజయవంతం';
  }

  @override
  String securityMultipleFailuresAlertDescription(String userId) {
    return 'వినియోగదారు $userId కోసం అనేక విఫల ధృవీకరణ ప్రయత్నాలు';
  }

  @override
  String securityEventConsoleLog(String eventType, String description) {
    return 'భద్రతా ఈవెంట్: $eventType - $description';
  }

  @override
  String securityEventSendFailure(String error) {
    return 'భద్రతా ఈవెంట్‌ను విశ్లేషణలకు పంపడంలో విఫలమైంది: $error';
  }

  @override
  String securityAlertConsoleLog(
      String severity, String alertType, String description) {
    return 'భద్రతా హెచ్చరిక [$severity]: $alertType - $description';
  }

  @override
  String securityAlertSendFailure(String error) {
    return 'భద్రతా హెచ్చరికను సేవలకు పంపడంలో విఫలమైంది: $error';
  }

  @override
  String securitySuspiciousHeader(String header) {
    return 'సందేహాస్పద హెడర్ గుర్తించబడింది: $header';
  }

  @override
  String get securitySuspiciousBody =>
      'వినతిలో సందేహాస్పద కంటెంట్ గుర్తించబడింది';

  @override
  String securityIpBlocked(String ip) {
    return 'IP నిరోధించబడింది: $ip';
  }

  @override
  String get securityRateLimitExceeded => 'రేట్ పరిమితి దాటింది';

  @override
  String get securityInvalidHeaders => 'చెల్లని వినతి శీర్షికలు';

  @override
  String get securityInvalidBody => 'చెల్లని వినతి బాడీ';

  @override
  String securityUnsupportedMethod(String method) {
    return 'మద్దతు లేని HTTP పద్ధతి: $method';
  }

  @override
  String securityRequestFailed(String error) {
    return 'వినతి విఫలమైంది: $error';
  }

  @override
  String securitySuspiciousResponseHeader(String header) {
    return 'సందేహాస్పద ప్రతిస్పందన హెడర్: $header';
  }

  @override
  String securityServerErrorResponse(String statusCode) {
    return 'సర్వర్ లోప ప్రతిస్పందన: $statusCode';
  }

  @override
  String encryptionEncryptFailed(String error) {
    return 'డేటాను ఎన్క్రిప్ట్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String encryptionDecryptFailed(String error) {
    return 'డేటాను డీక్రిప్ట్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String encryptionFileEncryptFailed(String error) {
    return 'ఫైల్ డేటాను ఎన్క్రిప్ట్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String encryptionFileDecryptFailed(String error) {
    return 'ఫైల్ డేటాను డీక్రిప్ట్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get securityInvalidEmailFormat => 'చెల్లని ఈమెయిల్ ఫార్మాట్';

  @override
  String get securityInvalidPhoneFormat => 'చెల్లని ఫోన్ నంబర్ ఫార్మాట్';

  @override
  String secureStorageStoreFailed(String error) {
    return 'సురక్షిత డేటాను నిల్వ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveFailed(String error) {
    return 'సురక్షిత డేటాను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreCredentialsFailed(String error) {
    return 'వినియోగదారు క్రెడెన్షియల్స్ నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveCredentialsFailed(String error) {
    return 'వినియోగదారు క్రెడెన్షియల్స్ పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreAuthTokenFailed(String error) {
    return 'ఆథ్ టోకెన్ నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveAuthTokenFailed(String error) {
    return 'ఆథ్ టోకెన్ పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreSessionFailed(String error) {
    return 'వినియోగదారు సెషన్ నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveSessionFailed(String error) {
    return 'వినియోగదారు సెషన్ పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreProfileFailed(String error) {
    return 'వినియోగదారు ప్రొఫైల్ నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveProfileFailed(String error) {
    return 'వినియోగదారు ప్రొఫైల్ పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreApiKeyFailed(String error) {
    return 'API కీ నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveApiKeyFailed(String error) {
    return 'API కీ పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStorePaymentFailed(String error) {
    return 'చెల్లింపు సమాచారాన్ని నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrievePaymentFailed(String error) {
    return 'చెల్లింపు సమాచారాన్ని పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreBiometricFailed(String error) {
    return 'బయోమెట్రిక్ డేటాను నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveBiometricFailed(String error) {
    return 'బయోమెట్రిక్ డేటాను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageStoreDeviceSecurityFailed(String error) {
    return 'పరికర భద్రతా డేటా నిల్వలో విఫలమైంది: $error';
  }

  @override
  String secureStorageRetrieveDeviceSecurityFailed(String error) {
    return 'పరికర భద్రతా డేటాను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageDeleteFailed(String error) {
    return 'సురక్షిత డేటాను తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageDeleteAllFailed(String error) {
    return 'అన్ని సురక్షిత డేటాను తొలగించడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageGetKeysFailed(String error) {
    return 'అన్ని కీలు పొందడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageClearUserDataFailed(String error) {
    return 'వినియోగదారు డేటాను క్లియర్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String secureStorageGetStatsFailed(String error) {
    return 'స్టోరేజ్ గణాంకాలను పొందడంలో విఫలమైంది: $error';
  }

  @override
  String get validationEmailRequired => 'ఈమెయిల్ అవసరం';

  @override
  String get validationInvalidEmailFormat => 'చెల్లని ఈమెయిల్ ఫార్మాట్';

  @override
  String get validationEmailInvalidAddress => 'సరైన ఈమెయిల్ చిరునామాను ఇవ్వండి';

  @override
  String get validationEmailTooLong => 'ఈమెయిల్ చిరునామా చాలా పొడవుగా ఉంది';

  @override
  String get validationPhoneRequired => 'ఫోన్ నంబర్ అవసరం';

  @override
  String get validationInvalidPhoneFormat => 'చెల్లని ఫోన్ నంబర్ ఫార్మాట్';

  @override
  String get validationPhoneLength => 'ఫోన్ నంబర్ 10 అంకెలు ఉండాలి';

  @override
  String get validationPhoneInvalid => 'సరైన భారతీయ ఫోన్ నంబర్ ఇవ్వండి';

  @override
  String get validationNameRequired => 'పేరు అవసరం';

  @override
  String get validationInvalidNameFormat => 'చెల్లని పేరు ఫార్మాట్';

  @override
  String get validationNameTooShort => 'పేరు కనీసం 2 అక్షరాలు ఉండాలి';

  @override
  String validationNameTooLong(String max) {
    return 'పేరు $max అక్షరాల కన్నా తక్కువ ఉండాలి';
  }

  @override
  String get validationNameInvalid =>
      'పేరు లో అక్షరాలు మరియు స్పేస్‌లు మాత్రమే ఉండాలి';

  @override
  String get validationPasswordRequired => 'పాస్‌వర్డ్ అవసరం';

  @override
  String get validationInvalidPasswordFormat => 'చెల్లని పాస్‌వర్డ్ ఫార్మాట్';

  @override
  String validationPasswordTooShort(String min) {
    return 'పాస్‌వర్డ్ కనీసం $min అక్షరాలు ఉండాలి';
  }

  @override
  String get validationPasswordTooLong => 'పాస్‌వర్డ్ చాలా పొడవుగా ఉంది';

  @override
  String get validationPasswordUppercase =>
      'పాస్‌వర్డ్‌లో కనీసం ఒక పెద్ద అక్షరం ఉండాలి';

  @override
  String get validationPasswordLowercase =>
      'పాస్‌వర్డ్‌లో కనీసం ఒక చిన్న అక్షరం ఉండాలి';

  @override
  String get validationPasswordDigit => 'పాస్‌వర్డ్‌లో కనీసం ఒక సంఖ్య ఉండాలి';

  @override
  String get validationPasswordSpecial =>
      'పాస్‌వర్డ్‌లో కనీసం ఒక ప్రత్యేక అక్షరం ఉండాలి';

  @override
  String get validationPasswordStrength =>
      'పాస్‌వర్డ్‌లో పెద్ద, చిన్న అక్షరాలు, సంఖ్య, ప్రత్యేక అక్షరం ఉండాలి';

  @override
  String get validationOtpRequired => 'OTP అవసరం';

  @override
  String get validationInvalidOtpFormat => 'చెల్లని OTP ఫార్మాట్';

  @override
  String get validationOtpLength => 'OTP 6 అంకెలు ఉండాలి';

  @override
  String get validationOtpDigitsOnly => 'OTPలో కేవలం అంకెలు మాత్రమే ఉండాలి';

  @override
  String get validationAddressRequired => 'చిరునామా అవసరం';

  @override
  String get validationInvalidAddressFormat => 'చెల్లని చిరునామా ఫార్మాట్';

  @override
  String get validationAddressTooShort => 'చిరునామా కనీసం 10 అక్షరాలు ఉండాలి';

  @override
  String get validationAddressTooLong =>
      'చిరునామా 200 అక్షరాల కన్నా తక్కువ ఉండాలి';

  @override
  String get validationAadhaarRequired => 'ఆధార్ నంబర్ అవసరం';

  @override
  String get validationInvalidAadhaarFormat => 'చెల్లని ఆధార్ నంబర్ ఫార్మాట్';

  @override
  String get validationAadhaarLength => 'ఆధార్ నంబర్ 12 అంకెలు ఉండాలి';

  @override
  String get validationPanRequired => 'PAN నంబర్ అవసరం';

  @override
  String get validationInvalidPanFormat => 'చెల్లని PAN నంబర్ ఫార్మాట్';

  @override
  String get validationPanInvalid => 'సరైన PAN నంబర్ ఇవ్వండి';

  @override
  String get validationFileRequired => 'ఫైల్ అవసరం';

  @override
  String get validationFileMissing => 'ఫైల్ లేదు';

  @override
  String validationFileSizeExceeded(String max) {
    return 'ఫైల్ పరిమాణం ${max}MB కంటే తక్కువగా ఉండాలి';
  }

  @override
  String validationFileTypeNotAllowed(String types) {
    return 'ఫైల్ రకం అనుమతించబడలేదు. అనుమతించిన రకాలు: $types';
  }

  @override
  String get validationFieldRequired => 'ఈ ఫీల్డ్ అవసరం';

  @override
  String validationFieldNameRequired(String field) {
    return '$field అవసరం';
  }

  @override
  String get validationInvalidTextFormat => 'చెల్లని టెక్స్ట్ ఫార్మాట్';

  @override
  String validationTextTooShort(String min) {
    return 'టెక్స్ట్ కనీసం $min అక్షరాలు ఉండాలి';
  }

  @override
  String validationTextTooLong(String max) {
    return 'టెక్స్ట్ $max అక్షరాల కన్నా తక్కువ ఉండాలి';
  }

  @override
  String validationFieldMinLength(String field, String min) {
    return '$field కనీసం $min అక్షరాలు ఉండాలి';
  }

  @override
  String validationFieldMaxLength(String field, String max) {
    return '$field $max అక్షరాల కన్నా తక్కువ ఉండాలి';
  }

  @override
  String validationFieldMustBeNumber(String field) {
    return '$field చెల్లుబాటు అయ్యే సంఖ్య కావాలి';
  }

  @override
  String validationFieldMustBeGreaterThanZero(String field) {
    return '$field సున్నా కంటే ఎక్కువ ఉండాలి';
  }

  @override
  String validationFileSizeExceededDetailed(String fileType, String max) {
    return '$fileTypeఫైల్ పరిమాణం ${max}MB కంటే తక్కువగా ఉండాలి';
  }

  @override
  String get validationInvalidInput => 'చెల్లని ఇన్‌పుట్';

  @override
  String get validationDobRequired => 'పుట్టిన తేదీ అవసరం';

  @override
  String get validationDobFormat => 'DD/MM/YYYY ఫార్మాట్‌లో తేదీని ఇవ్వండి';

  @override
  String get validationDobInvalidDate => 'చెల్లని తేదీ ఫార్మాట్';

  @override
  String get validationDobFuture => 'పుట్టిన తేదీ భవిష్యత్తులో ఉండకూడదు';

  @override
  String get validationDobMinimumAge => 'మీ వయసు కనీసం 18 సంవత్సరాలు ఉండాలి';

  @override
  String get validationDobInvalid => 'చెల్లని తేదీ';

  @override
  String get appExceptionDefaultMessage => 'లోపం సంభవించింది';

  @override
  String get appExceptionDefaultRecovery =>
      'దయచేసి కొంతసేపు తరువాత మళ్లీ ప్రయత్నించండి';

  @override
  String get appExceptionDetailsLabel => 'వివరాలు';

  @override
  String get appExceptionSuggestionLabel => '💡 సూచన';

  @override
  String get networkExceptionPrefix => 'నెట్‌వర్క్ లోపం';

  @override
  String get networkExceptionMessage => 'ఇంటర్నెట్ కనెక్షన్ లేదు';

  @override
  String get networkExceptionRecovery =>
      'మీ కనెక్షన్‌ను తనిఖీ చేసి మళ్లీ ప్రయత్నించండి';

  @override
  String get authExceptionPrefix => 'ఆథ్ లోపం';

  @override
  String get authExceptionMessage => 'దృవీకరణ విఫలమైంది';

  @override
  String get authExceptionRecovery =>
      'దయచేసి మీ గుర్తింపు వివరాలను తనిఖీ చేసి మళ్లీ ప్రయత్నించండి';

  @override
  String get dataParsingExceptionPrefix => 'పార్సింగ్ లోపం';

  @override
  String get dataParsingExceptionMessage => 'డేటాను విశ్లేషించడంలో విఫలమైంది';

  @override
  String get dataParsingExceptionRecovery =>
      'దయచేసి మళ్లీ ప్రయత్నించండి లేదా సమస్య కొనసాగితే మద్దతును సంప్రదించండి';

  @override
  String get configurationExceptionPrefix => 'కాన్ఫిగ్ లోపం';

  @override
  String get configurationExceptionMessage => 'కాన్ఫిగరేషన్ లోపం';

  @override
  String get configurationExceptionRecovery =>
      'దయచేసి యాప్‌ను రీస్టార్ట్ చేయండి లేదా మద్దతును సంప్రదించండి';

  @override
  String get validationExceptionPrefix => 'ధృవీకరణ లోపం';

  @override
  String validationExceptionMessage(String field) {
    return '$field కోసం ధృవీకరణ విఫలమైంది';
  }

  @override
  String get validationExceptionRecovery =>
      'దయచేసి నమోదు చేసిన సమాచారాన్ని తనిఖీ చేయండి';

  @override
  String imagePickerMultipleSelectionError(String error) {
    return 'బహుళ చిత్ర ఎంపిక అందుబాటులో లేదు, లోపం: $error';
  }

  @override
  String get validationFieldDefaultName => 'ఫీల్డ్';

  @override
  String get fileTypeProfilePhoto => 'ప్రొఫైల్ ఫోటో';

  @override
  String get fileTypeAadhaarDocument => 'ఆధార్ డాక్యుమెంట్';

  @override
  String get performanceReportTitle => '=== పనితీరు నివేదిక ===';

  @override
  String performanceReportGenerated(String timestamp) {
    return 'సృష్టించినది: $timestamp';
  }

  @override
  String performanceReportOperation(String operation) {
    return 'ఆపరేషన్: $operation';
  }

  @override
  String performanceReportCount(String count) {
    return '  లెక్క: $count';
  }

  @override
  String performanceReportMin(String value) {
    return '  కనిష్ఠం: $value';
  }

  @override
  String performanceReportMax(String value) {
    return '  గరిష్ఠం: $value';
  }

  @override
  String performanceReportAverage(String value) {
    return '  సగటు: $value';
  }

  @override
  String performanceReportMedian(String value) {
    return '  మధ్య విలువ: $value';
  }

  @override
  String get guestPgStartingLoad => 'PGలను లోడ్ చేయడం ప్రారంభిస్తోంది';

  @override
  String get guestPgLoadSuccess => 'PGలు విజయవంతంగా లోడ్ అయ్యాయి';

  @override
  String get guestPgLoadFailure => 'PGలను లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get guestPgRefreshAction => 'PGలను రిఫ్రెష్ చేయండి';

  @override
  String get guestPgSelectedAction => 'PG ఎంపిక చేయబడింది';

  @override
  String get guestPgClearSelectionAction => 'PG ఎంపికను క్లియర్ చేయండి';

  @override
  String get guestPgSearchQueryChangedAction => 'శోధన ప్రశ్న మార్చబడింది';

  @override
  String ownerMenuEditLogTotalItems(int count) {
    return '   - మొత్తం అంశాలు: $count';
  }

  @override
  String get ownerMenuEditLogUpdateSuccess =>
      '✅ మెనూ విజయవంతంగా నవీకరించబడింది!';

  @override
  String get ownerMenuEditLogCreateSuccess =>
      '✅ మెనూ విజయవంతంగా సృష్టించబడింది!';

  @override
  String get ownerSettingsBuildNumberValue => '1';

  @override
  String get ownerSettingsAppVersionValue => '1.0.0';

  @override
  String get ownerOverviewOwnerFallback => 'యజమాని';
}
